#include "saxpy_api.h"
#include <cstdlib>
#include <iostream>

int main() {
  int N = 1 << 20;
  float a = 2.0f;

  float* x = (float*)malloc(N * sizeof(float));
  float* y = (float*)malloc(N * sizeof(float));

  for (int i = 0; i < N; ++i) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  saxpy(y, x, a, N);

  for (int i = 0; i < N; i++)
    std::cout << "y[0] = " << y[i] << std::endl;

  free(x);
  free(y);
  return 0;
}
