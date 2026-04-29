#define TILE_SIZE 32
// We add +1 for padding to avoid bank conflicts when accessing columns
#define PADDED_SIZE 33

__global__ void tiledMatMul(float* A, float* B, float* C, int width) {
  // Shared memory for tiles of A and B
  __shared__ float tileA[TILE_SIZE][PADDED_SIZE];
  __shared__ float tileB[TILE_SIZE][PADDED_SIZE];

  int tx = threadIdx.x;
  int ty = threadIdx.y;
  int row = blockIdx.y * TILE_SIZE + ty;
  int col = blockIdx.x * TILE_SIZE + tx;

  float val = 0;

  // Loop over tiles
  for (int m = 0; m < (width / TILE_SIZE); ++m) {
    // 1. COALESCED LOAD: Threads grab data from Global Memory
    // A is accessed by row, B by row.
    tileA[ty][tx] = A[row * width + (m * TILE_SIZE + tx)];
    tileB[ty][tx] = B[(m * TILE_SIZE + ty) * width + col];

    // 2. SYNCHRONIZE: The BSP Barrier
    // Ensure the whole tile is loaded before anyone starts math
    __syncthreads();

    // 3. COMPUTE: Multiply the tiles
    // Because of the PADDED_SIZE, reading columns of tileB
    // will not cause bank conflicts.
    for (int k = 0; k < TILE_SIZE; ++k) {
      val += tileA[ty][k] * tileB[k][tx];
    }

    // 4. SYNCHRONIZE again:
    // Ensure math is done before we overwrite the tile in the next loop
    __syncthreads();
  }

  C[row * width + col] = val;
}
