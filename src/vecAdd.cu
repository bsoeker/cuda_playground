#include "vecAdd_api.h"

__global__ void vecAdd_kernel(const float* vec1, const float* vec2,
                              float* result, int N) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < N)
    result[i] = vec1[i] + vec2[i];
}

void vecAdd(const float* vec1, const float* vec2, float* result, int N) {
  vecAdd_kernel<<<1, N>>>(vec1, vec2, result, N);
  cudaDeviceSynchronize();
}
