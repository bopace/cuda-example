//****************************************************************************80
//
//  file name:
//
//    raise_to_power.cu
//
//  licensing:
//
//    this code is distributed under the mit license.
//
//  author:
//    bo pace
//
//  reference:
//    based on https://developer.nvidia.com/blog/even-easier-introduction-cuda/
//    an article by mark harris of nvidia

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <iostream>
#include <math.h>

//****************************************************************************80
//
//  description:
//
//    cuda kernal function. raises the elements of one array to the power of the
//    elements of another array
//
//  last modified:
//
//    17 april 2021
//
//  input:
//
//	  int n - the length of the arrays
//    float* arr1 - pointer to array of bases
//	  float* arr2 - pointer to array of exponents
//
__global__
void raise_to_power(int n, float* arr1, float* arr2)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	int stride = blockDim.x * gridDim.x;
	for (int i = index; i < n; i += stride)
	{
		arr2[i] = pow(arr1[i], arr2[i]);
	}
}

int main(void)
{
	int arr_size = 1 << 20; // 1 million

	// allocate unified memory -- accessible from cpu or gpu
	float* arr1, * arr2;
	cudaMallocManaged(&arr1, arr_size * sizeof(float));
	cudaMallocManaged(&arr2, arr_size * sizeof(float));

	// initialize x and y arrays on the host
	for (int i = 0; i < arr_size; i++)
	{
		arr1[i] = 3.0f;
		arr2[i] = 2.0f;
	}

	int blockSize = 256;
	int numBlocks = (arr_size + blockSize - 1) / blockSize;
	raise_to_power <<<numBlocks, blockSize>>> (arr_size, arr1, arr2);

	// wait for gpu to finish before accessing on host
	cudaDeviceSynchronize();

	// check for errors (all values should be 9.0f)
	float maxError = 0.0f;
	for (int i = 0; i < arr_size; i++)
	{
		maxError = fmax(maxError, fabs(arr2[i] - 9.0f));
	}

	std::cout << "Max error: " << maxError << '\n';

	// free memory
	cudaFree(arr1);
	cudaFree(arr2);

	return 0;
}
