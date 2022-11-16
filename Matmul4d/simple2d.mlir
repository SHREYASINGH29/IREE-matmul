func.func @matmul(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c4 = arith.constant 4 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c4_i32 = arith.constant 4 : i32
    scf.for %arg3 = %c0 to %c4 step %c1 {
      %0 = arith.index_cast %arg3 : index to i32
      %1 = arith.muli %0, %c4_i32 : i32
      scf.for %arg4 = %c0 to %c4 step %c1 {
        %2 = arith.index_cast %arg4 : index to i32
        %3 = arith.addi %1, %2 : i32
        %4 = arith.index_cast %3 : i32 to index
        scf.for %arg5 = %c0 to %c4 step %c1 {
          %5 = arith.index_cast %arg5 : index to i32
          %6 = arith.addi %1, %5 : i32
          %7 = arith.index_cast %6 : i32 to index
          %8 = memref.load %arg0[%7] : memref<?xf32>
          %9 = arith.muli %5, %c4_i32 : i32
          %10 = arith.addi %9, %2 : i32
          %11 = arith.index_cast %10 : i32 to index
          %12 = memref.load %arg1[%11] : memref<?xf32>
          %13 = arith.mulf %8, %12 : f32
          %14 = memref.load %arg2[%4] : memref<?xf32>
          %15 = arith.addf %14, %13 : f32
          memref.store %15, %arg2[%4] : memref<?xf32>
        }
      }
    }
    return
  }
