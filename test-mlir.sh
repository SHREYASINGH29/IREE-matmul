#!/bin/bash

# takes .mlir file as an input
# only uses cpu backend

$IREE_BUILD/tools/iree-compile --iree-hal-target-backends=llvm-cpu --iree-input-type=mhlo  --mlir-print-ir-after-all $1 -o $1.vmfb &> $1.print-after-all.txt
$IREE_BUILD/tools/iree-check-module $1.vmfb
