__global__ void k(int *input, int *output, int count)
{
	for(int i =0; i<count; i++)
		output[i]=input[i]*16;
}
