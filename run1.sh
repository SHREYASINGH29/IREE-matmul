IREE_OPT=~/iree/iree-build/tools/iree-opt

$IREE_OPT $1 --iree-hal-target-backends=llvm-cpu \
  --iree-abi-transformation-pipeline \
  --iree-flow-transformation-pipeline \
  --iree-stream-transformation-pipeline \
  --iree-hal-configuration-pipeline | \
$IREE_OPT --pass-pipeline='hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target))' \
  --iree-codegen-llvmcpu-use-transform-dialect=matmul_codegen_default_spec.mlir
