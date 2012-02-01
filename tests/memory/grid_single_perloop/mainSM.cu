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
	if(result==0)
		printf("Success at %i\n", position);
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


int main( int argc, char** argv) 
{
	if(argc<3)
	{
		puts("arguments: cubinname kernelname length tcount interval choice");
		puts("	length: number of 4-byte elements to allocate in memory");
		puts("	tcount: number of threads");
		puts("	interval: number of output items per group");
		puts("	choice: 0, all; 1, odd group only; 2, even group only; 3: none");
		return 0;
	}
	int length = 8;
	if(argc>=4)
	{
		length = atoi(argv[3]);
	}
	int tcount = 1;
	if(argc>=5)
	{
		tcount = atoi(argv[4]);
	}
	int size = sizeof(int)*length;
	int interval = 1;
	if(argc>=6)
	{
		interval = atoi(argv[5]);
	}
	bool odd = true;
	bool even = true;
	if(argc>=7)
	{
		int choice = atoi(argv[6]);
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
	CUdeviceptr gpu_output;
	CUdevice device;
	CUcontext context;
	CUmodule module;
	CUfunction kernel;
	CUevent eStart, eStop;

	muRC(100, cuInit(0));
	muRC(95, cuDeviceGet(&device, 0));
	muRC(92, cuCtxCreate(&context, CU_CTX_SCHED_SPIN, device));
	muRC(91, cuCtxSetCacheConfig(CU_FUNC_CACHE_PREFER_SHARED));
	//muRC(91, cuCtxSetCacheConfig(CU_FUNC_CACHE_PREFER_L1));
	muRC(90, cuMemAlloc(&gpu_output, size));

	muRC(89, cuEventCreate(&eStart, CU_EVENT_DEFAULT));
	muRC(88, cuEventCreate(&eStop, CU_EVENT_DEFAULT));
	muRC(0, cuModuleLoad(&module, argv[1]));
	muRC(1, cuModuleGetFunction(&kernel, module, argv[2]));

	muRC(2, cuParamSetSize(kernel, 20));
	muRC(3, cuParamSetv(kernel, 0, &gpu_output, 8));
	muRC(4, cuFuncSetBlockShape(kernel, tcount,1,1));

	muRC(41, cuEventRecord(eStart,0) );
	muRC(5, cuLaunchGrid(kernel, 150, 1));
	muRC(51, cuEventRecord(eStop,0) );

	muRC(7, cuCtxSynchronize());
	float time;
	muRC(75, cuEventElapsedTime(&time, eStart, eStop)); 

	printf("length=%i\n", length);
	printf("tcount=%i\n", tcount);
	printf("time=%f\n", time);
	printf("Allocation = %x, size = %x\n", gpu_output, size);
	
	muRC(8, cuModuleUnload(module));
	muRC(9, cuMemFree(gpu_output));
	muRC(10, cuCtxDestroy(context));
	return 0;
}
