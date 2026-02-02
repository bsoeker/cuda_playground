#include "hello_api.h"
#include <cstdio>

__global__ void say_hello_kernel() {
  int id = blockIdx.x * blockDim.x + threadIdx.x;
  printf("Hello from GPU thread: %d\n", id);
}

void say_hello(int gridDim, int blockDim) {
  say_hello_kernel<<<gridDim, blockDim>>>();
  cudaDeviceSynchronize();
}
