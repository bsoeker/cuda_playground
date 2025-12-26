#include "hello_api.h"
#include <cstdio>

__global__ void say_hello_kernel() {
  int id = blockIdx.x * blockDim.x + threadIdx.x;
  printf("Hello from GPU thread: %d\n", id);
}

void say_hello() {
  say_hello_kernel<<<4, 256>>>();
  cudaDeviceSynchronize();
}
