void __global__ loadee(int *output)
{
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	output[tid]=tid;
}
