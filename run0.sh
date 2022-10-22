IREE_OPT=~/iree/iree-build/tools/iree-opt

$IREE_OPT $1 --iree-hal-target-backends=llvm-cpu \
  --iree-abi-transformation-pipeline --iree-flow-transformation-pipeline \
  --iree-flow-dispatch-via-region-ops \
  --iree-flow-dispatch-via-region-ops-generate-workload-region=false \
  --iree-stream-transformation-pipeline \
  --iree-hal-configuration-pipeline | \
$IREE_OPT --pass-pipeline='hal.executable(hal.executable.variant(iree-llvmcpu-lower-executable-target))' \
  --iree-codegen-llvmcpu-use-transform-dialect=matmul_codegen_custom_dispatch_formation_spec.mlir
