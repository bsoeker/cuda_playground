# =============================
# Compilers
# =============================
CXX  := clang++
NVCC := nvcc
CUDA_HOME := /opt/cuda

# =============================
# Flags
# =============================
CXXFLAGS  := -Iinclude -MMD -MP -Wall -Wextra -std=c++20
CXXFLAGS  += -I$(CUDA_HOME)/include
CXXFLAGS  += --cuda-path=$(CUDA_HOME)
NVCCFLAGS := -Iinclude -std=c++20

# CUDA arch
CUDA_ARCH := -arch=sm_89

# =============================
# Sources
# =============================
CPP_SRC  := $(wildcard src/*.cc) main.cc
CUDA_SRC := $(wildcard src/*.cu)

CPP_OBJ  := $(patsubst %.cc, build/%.o, $(notdir $(CPP_SRC)))
CUDA_OBJ := $(patsubst %.cu, build/%.cu.o, $(notdir $(CUDA_SRC)))

OBJ := $(CPP_OBJ) $(CUDA_OBJ)
DEP := $(CPP_OBJ:.o=.d)

# =============================
# Output
# =============================
OUT := build/program

# =============================
# Default
# =============================
all: release

release: CXXFLAGS += -O2
release: NVCCFLAGS += -O2
release: $(OUT)

debug: CXXFLAGS += -g -O0
debug: NVCCFLAGS += -g -O0
debug: $(OUT)

# =============================
# Linking
# =============================
$(OUT): $(OBJ)
	$(NVCC) -o $@ $^

# =============================
# Compile rules
# =============================
build/%.o: src/%.cc | build
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.o: %.cc | build
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cu.o: src/%.cu | build
	$(NVCC) $(NVCCFLAGS) $(CUDA_ARCH) -c $< -o $@

build/%.cu.o: %.cu | build
	$(NVCC) $(NVCCFLAGS) $(CUDA_ARCH) -c $< -o $@

# =============================
# Housekeeping
# =============================
build:
	mkdir -p build

run: $(OUT)
	./$(OUT)

clean:
	rm -rf build

-include $(DEP)

.PHONY: all release debug clean run build

