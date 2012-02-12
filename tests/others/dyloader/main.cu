#include <stdlib.h>
#include <stdio.h>
#include <cuda.h>

extern "C"
{
	__global__ void testKernel(int* addr, unsigned short param1, char param2)
	{
		addr[0] = param1 + param2;
	}
}

char* muGetErrorString(CUresult result);
void muEC(int position); //checks and outputs error position and error string
void muRC(int position, CUresult result);
char* muGetErrorString(CUresult result);
bool ProcessCommandLine(char **argv, int argc, int &length, int &tcount, int &interval, int &choice,  bool &odd, bool &even);

int main( int argc, char** argv) 
{
	int length, tcount, interval, choice;
	bool odd, even;
	if(!ProcessCommandLine(argv, argc, length, tcount, interval, choice, odd, even))
		return -1;
	unsigned int cpu_loadee[] = {
		0x00005de4,
		0x28004404,
		0x94001c04,
		0x2c000000,
		0x84009c04,
		0x2c000000,
		0x8000dde4,
		0x28004000,
		0x20001ca3,
		0x20044000,
		0x10011ca3,
		0x2007c000,
		0x10009ce3,
		0x5000c000,
		0x90215c43,
		0x48004000,
		0x00401c85,
		0x94000000,
		0x00001de7,
		0x80000000};
	int loadee_size = sizeof(int) * 20;

//Initialize device and context, module and kernel func handles
	CUdeviceptr gpu_output, gpu_loadee, gpu_flag;
	CUdevice device;
	CUcontext context;
	CUmodule module;
	CUfunction kernel;

	muRC(100, cuInit(0));
	muRC(95, cuDeviceGet(&device, 0));
	muRC(92, cuCtxCreate(&context, CU_CTX_SCHED_SPIN, device));
	muRC(0, cuModuleLoad(&module, argv[1]));
	muRC(1, cuModuleGetFunction(&kernel, module, argv[2]));

//Prepare memory resources
	//tcount is used as block count, while a block uses 1024 threads
	bool addr_loaded = false;
	unsigned int container_addr = 0;
	length = tcount * 1024;
	int size = length * sizeof(int);
	int *cpu_output = new int[length];
	cuMemAlloc(&gpu_output, size);
	cuMemAlloc(&gpu_loadee, loadee_size);
	cuMemAlloc(&gpu_flag, 4);
	cuMemcpyHtoD(gpu_loadee, cpu_loadee, loadee_size);
	int flag = -1;
	cuMemcpyHtoD(gpu_flag, &flag, 4);


//set up events
	CUevent eStart, eStop;
	muRC(89, cuEventCreate(&eStart, CU_EVENT_DEFAULT));
	muRC(88, cuEventCreate(&eStop, CU_EVENT_DEFAULT));

//set kernel parameters
LB1:
	if(addr_loaded)
	{
		//first launch flag = -1, signalling loader to output LEPC result
		//second launch flag = 0, signalling loader to load loadee
		flag = 0;
		cuMemcpyHtoD(gpu_flag, &flag, 4);
	}
	muRC(2, cuParamSetSize(kernel, 32));
	muRC(3, cuParamSetv(kernel, 0x0, &gpu_output, 8));
	muRC(3, cuParamSetv(kernel, 0x8, &gpu_loadee, 8));
	muRC(3, cuParamSetv(kernel, 0x10,&gpu_flag,   8));
	muRC(3, cuParamSetv(kernel, 0x18,&container_addr,4));
	muRC(3, cuParamSetv(kernel, 0x1c,&loadee_size,4));
	muRC(4, cuFuncSetBlockShape(kernel, 1024,1,1));

//launch, with events
	cuMemsetD32(gpu_output, 0, length);
	muRC(41, cuEventRecord(eStart,0) );
	muRC(5, cuLaunchGrid(kernel, tcount, 1)); //tcount used as block count
	muRC(51, cuEventRecord(eStop,0) );

//copy back result
	muRC(6, cuMemcpyDtoH(cpu_output, gpu_output, size));
	muRC(7, cuCtxSynchronize());
	float time;
	muRC(75, cuEventElapsedTime(&time, eStart, eStop)); 
	printf("length=%i\n", length);
	printf("tcount=%i\n", tcount);
	printf("time=%f\n", time);

	//first launch, getting PC and relaunch
	if(!addr_loaded)
	{
		addr_loaded = true;
		container_addr = cpu_output[0];
		printf("container addr is: %x\n", container_addr);
		container_addr += 0x400;
		printf("container addr to mod is: %x\n", container_addr);
		puts("=========Relaunching==========");
		goto LB1;
	}
	//second launch, check result
	else
	{
		bool error = false;
		for(int i = 0; i<length; i++)
		{
			if(cpu_output[i]!=i)
			{
				error = true;
				printf("error found when i = %x\n", i);
				break;
			}
		}
		if(error)
		{
			puts("error found");
			for(int i =0; i<length; i++)
				printf("i=%x, value = %x\n", i, cpu_output[i]);
		}
		else
			puts("kernel success");
	}

//clean up
	muRC(9, cuMemFree(gpu_output));
	muRC(9, cuMemFree(gpu_loadee));
	muRC(9, cuMemFree(gpu_flag));
	delete[] cpu_output;
	muRC(8, cuModuleUnload(module));
	muRC(10, cuCtxDestroy(context));
	return 0;
}


bool ProcessCommandLine(char **argv, int argc, int &length, int &tcount, int &interval, int &choice,  bool &odd, bool &even)
{
	if(argc<3)
	{
		puts("arguments: cubinname kernelname length tcount interval choice");
		puts("	length: number of 4-byte elements to allocate in memory");
		puts("	tcount: number of threads");
		puts("	interval: number of output items per group");
		puts("	choice: 0, all; 1, odd group only; 2, even group only; 3: none");
		return false;
	}
	length = 8;
	if(argc>=4)
	{
		length = atoi(argv[3]);
	}
	tcount = 1;
	if(argc>=5)
	{
		tcount = atoi(argv[4]);
	}
	interval = 1;
	if(argc>=6)
	{
		interval = atoi(argv[5]);
	}
	odd = true;
	even = true;
	if(argc>=7)
	{
		choice = atoi(argv[6]);
		if(choice==1)
			even = false;
		else if(choice==2)
			odd = false;
		else if(choice==3)
		{
			even = false;
			odd = false;
		}
	}
	return true;
}


void muEC(int position) //checks and outputs error position and error string
{
	cudaError_t errcode = cudaGetLastError();
	if(errcode==cudaSuccess)
	{
		printf("No error at position %i\n", position);
		return;
	}
	printf("Error position: %i\nCode:%s\n", position, cudaGetErrorString(errcode));
}

void muRC(int position, CUresult result)
{
	if(result==0){}
		//printf("Success at %i\n", position);
	else
		printf("Error at %i:%s\n", position, muGetErrorString(result));
}

char* muGetErrorString(CUresult result)
{
	switch(result)
	{
	case 0:		return "Success";
	case 1:		return "Invalid value";
	case 2:		return "Out of memory";
	case 3:		return "Not Initialized";
	case 4:		return "Deinitialized";

	case 100:	return "No device";
	case 101:	return "Invalid device";

	case 200:	return "Invalid image";
	case 201:	return "Invalid context";
	case 202:	return "Context already current";
	case 205:	return "Map failed";
	case 206:	return "Unmap failed";
	case 207:	return "Array is mapped";
	case 208:	return "Already mapped";
	case 209:	return "No binary for GPU";
	case 210:	return "Already acquired";
	case 211:	return "Not mapped";

	case 300:	return "Invalid source";
	case 301:	return "File not found";

	case 400:	return "Invalid handle";
	case 500:	return "Not found";
	case 600:	return "Not ready";

	case 700:	return "Launch failed";
	case 701:	return "Launch out of resources";
	case 702:	return "Launch timeout";
	case 703:	return "Launch incompatible texturing";

	case 999:	return "Unknown";
	};
	return "Unknown";
}
