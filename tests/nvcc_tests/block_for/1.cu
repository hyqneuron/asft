__global__ void k(int *input, int *output, int count)
{
	int tid = threadIdx.x;
	int nid = blockDim.x;
	#pragma unroll 3
	for(int i =tid; i<count; i+=nid)
	{
		output[i]=input[i]*16;
	}
}


