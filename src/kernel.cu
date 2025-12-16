#include "kernel_api.h"
#include <cuda_runtime.h>

int cuda_device_count() {
  int n = 0;
  cudaGetDeviceCount(&n);
  return n;
}
