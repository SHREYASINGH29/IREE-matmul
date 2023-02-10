# Implemetation of 2D Matrix Multiplication

## Building MLIR
```sh
git clone https://github.com/llvm/llvm-project.git
cd llvm-project; mkdir build; cd build
cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS=mlir -DLLVM_BUILD_EXAMPLES=ON -DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON
cmake --build . --target check-mlir
cmake --build . --target opt
```
## Simple End-to-end Example Without Grid (No Transformation)
Somewhere outside the llvm-project directory create a directory
```sh
mkdir Simple
cd Simple
```
Copy these two files files into Simple directory [simple.mlir](https://github.com/SHREYASINGH29/IREE-matmul/blob/master/Matmul4d/simple2d.mlir), [wrapper.c](https://github.com/SHREYASINGH29/IREE-matmul/blob/master/Matmul4d/wrapper2d.c)
```sh
export MLIR_PATH="/somepath/llvm-project/build"
```
Lower to LLVM dialect
```sh
($MLIR_PATH/bin/mlir-opt simple.mlir -one-shot-bufferize="bufferize-function-boundaries=1 allow-return-allocs" -drop-equivalent-buffer-results | $MLIR_PATH/bin/mlir-opt -convert-linalg-to-loops -convert-scf-to-cf -convert-linalg-to-llvm -lower-affine -convert-scf-to-cf --convert-memref-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts | $MLIR_PATH/bin/mlir-translate -mlir-to-llvmir) > simple.ll
```
Create optimized LLVM bytecode
```sh
$MLIR_PATH/bin/opt -O3 simple.ll -o simple.bc
```
Create object code
```sh
$MLIR_PATH/bin/llc -filetype=obj simple.bc
```
Create and run baseline plain-C version
```sh
gcc -Dbaseline=1 -O3 -o full wrapper.c; ./full
```
Create and run version with MLIR-generated function
```sh
gcc -Dbaseline=0 -O3 -o full wrapper.c simple.o; ./full
```
## Simple End-to-end Example with 2D Grid(No Transformation)
Somewhere outside the llvm-project directory create a directory
```sh
mkdir Simple2d
cd Simple2d
```
Copy these two files files into Simple directory [simple2d.mlir](https://github.com/SHREYASINGH29/IREE-matmul/blob/master/Matmul4d/simple.mlir), [wrapper2d.c](https://github.com/SHREYASINGH29/IREE-matmul/blob/master/Matmul4d/wrapper.c)
```sh
export MLIR_PATH="/somepath/llvm-project/build"
```
Lower to LLVM dialect
```sh
($MLIR_PATH/bin/mlir-opt simple2d.mlir -one-shot-bufferize="bufferize-function-boundaries=1 allow-return-allocs" -drop-equivalent-buffer-results | $MLIR_PATH/bin/mlir-opt -convert-linalg-to-loops -convert-scf-to-cf -convert-linalg-to-llvm -lower-affine -convert-scf-to-cf --convert-memref-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts | $MLIR_PATH/bin/mlir-translate -mlir-to-llvmir) > simple2d.ll
```
Create optimized LLVM bytecode
```sh
$MLIR_PATH/bin/opt -O3 simple2d.ll -o simple2d.bc
```
Create object code
```sh
$MLIR_PATH/bin/llc -filetype=obj simple2d.bc
```
Create and run baseline plain-C version
```sh
gcc -Dbaseline=1 -O3 -o full wrapper2d.c; ./full
```
Create and run version with MLIR-generated function
```sh
gcc -Dbaseline=0 -O3 -o full wrapper2d.c simple2d.o; ./full
```
