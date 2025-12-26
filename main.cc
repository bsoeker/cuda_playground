#include <cstdio>
#include <cuda_runtime.h>

int main(int argc, char* argv[]) {
  cudaDeviceProp prop;
  cudaGetDeviceProperties(&prop, 0);

  printf("Shared memory per block: %zu bytes\n", prop.sharedMemPerBlock);
  printf("Shared memory per SM:    %zu bytes\n",
         prop.sharedMemPerMultiprocessor);
  printf("Number of SMs:           %d\n", prop.multiProcessorCount);

  return 0;
}
