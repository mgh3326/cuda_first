
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#define N 1000	// size of vectors

#define T 10000// number of threads per block


__global__ void vecAdd(int *A, int *B, int *C) {
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	C[i] = A[i] * 10 + B[i];
}
int main(int argc, char **argv) {

	int size = N * T * sizeof(int);
	int  a[N*T], b[N*T], c[N*T], *devA, *devB, *devC;
	for (int i = 0; i < N*T; i++) {
		/*devA[i] = 0;
		devB[i] = 0;
		devC[i] = 0;*/
		a[i] = i;
		b[i] = 1;
		//c[i] = 0;
	}
	cudaMalloc((void**)&devA, size);
	cudaMalloc((void**)&devB, size);
	cudaMalloc((void**)&devC, size);

	cudaMemcpy(devA, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(devB, b, size, cudaMemcpyHostToDevice);

	vecAdd << <T, N >> > (devA, devB, devC);

	cudaMemcpy(c, devC, size, cudaMemcpyDeviceToHost);
	cudaFree(devA);
	cudaFree(devB);
	cudaFree(devC);

	for (int i = 0; i < N*T; i++) {

		//c[i] = a[i] * 10 + b[i];

		printf("c[%d]= %d\n", i, c[i]);
	}
	return(0);
}
// Helper function for using CUDA to add vectors in parallel.

