#include "saxpy_api.h"

__global__ void saxpy_kernel(float* y, const float* x, const float a, int N) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < N)
    y[i] = a * x[i] + y[i];
}

void saxpy(float* y, const float* x, const float a, int N) {
  int blockDim = 256;
  int gridDim = (N + blockDim - 1) / blockDim;
  size_t bytes = N * sizeof(float);

  float* d_x = nullptr;
  float* d_y = nullptr;

  cudaMalloc(&d_x, bytes);
  cudaMalloc(&d_y, bytes);

  cudaMemcpy(d_x, x, bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, y, bytes, cudaMemcpyHostToDevice);

  saxpy_kernel<<<gridDim, blockDim>>>(d_y, d_x, a, N);
  cudaDeviceSynchronize();

  cudaMemcpy(y, d_y, bytes, cudaMemcpyDeviceToHost);

  cudaFree(d_x);
  cudaFree(d_y);
}
