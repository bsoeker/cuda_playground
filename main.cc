#include "kernel_api.h"
#include <iostream>

int main() { std::cout << "CUDA devices: " << cuda_device_count() << "\n"; }
