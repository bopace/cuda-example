//****************************************************************************80
//
//  file name:
//
//    non_cuda_raise_to_power.cpp
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

#include <iostream>
#include <math.h>

//****************************************************************************80
//
//  description:
//
//    raises the elements of one array to the power of the elements of another
//	  array
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
void raise_to_power(int n, float* arr1, float* arr2)
{
	for (int i = 0; i < n; i++)
	{
		arr2[i] = powf(arr1[i], arr2[i]);
	}
}

int main(void)
{
	int arr_size = 1 << 20; // 1 million

	float* arr1 = new float[arr_size];
    float* arr2 = new float[arr_size];

	// initialize x and y arrays on the host
	for (int i = 0; i < arr_size; i++)
	{
		arr1[i] = 3.0f;
		arr2[i] = 2.0f;
	}

    // run on the cpu
	raise_to_power(arr_size, arr1, arr2);

	// check for errors (all values should be 9.0f)
	float maxError = 0.0f;
	for (int i = 0; i < arr_size; i++)
	{
		maxError = fmax(maxError, fabs(arr2[i] - 9.0f));
	}

	std::cout << "Max error: " << maxError << '\n';

	// free memory
	delete[] arr1;
	delete[] arr2;

	return 0;
}
