  func.func @matmul(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c64 = arith.constant 64 : index
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1024_i32 = arith.constant 1024 : i32
    %c64_i32 = arith.constant 64 : i32
    scf.for %arg3 = %c0 to %c16 step %c1 {
      %0 = arith.index_cast %arg3 : index to i32
      %1 = arith.muli %0, %c64_i32 : i32
      scf.for %arg4 = %c0 to %c16 step %c1 {
        %2 = arith.index_cast %arg4 : index to i32
        %3 = arith.muli %2, %c64_i32 : i32
        scf.for %arg5 = %c0 to %c16 step %c1 {
          %4 = arith.index_cast %arg5 : index to i32
          %5 = arith.muli %4, %c64_i32 : i32
          scf.for %arg6 = %c0 to %c64 step %c1 {
            %6 = arith.index_cast %arg6 : index to i32
            %7 = arith.addi %1, %6 : i32
            %8 = arith.muli %7, %c1024_i32 : i32
            scf.for %arg7 = %c0 to %c64 step %c1 {
              %9 = arith.index_cast %arg7 : index to i32
              %10 = arith.addi %3, %9 : i32
              %11 = arith.addi %8, %10 : i32
              %12 = arith.index_cast %11 : i32 to index
              scf.for %arg8 = %c0 to %c64 step %c1 {
                %13 = arith.index_cast %arg8 : index to i32
                %14 = arith.addi %5, %13 : i32
                %15 = arith.addi %8, %14 : i32
                %16 = arith.index_cast %15 : i32 to index
                %17 = memref.load %arg0[%16] : memref<?xf32>
                %18 = arith.muli %14, %c1024_i32 : i32
                %19 = arith.addi %18, %10 : i32
                %20 = arith.index_cast %19 : i32 to index
                %21 = memref.load %arg1[%20] : memref<?xf32>
                %22 = arith.mulf %17, %21 : f32
                %23 = memref.load %arg2[%12] : memref<?xf32>
                %24 = arith.addf %23, %22 : f32
                memref.store %24, %arg2[%12] : memref<?xf32>
              }
            }
          }
        }
      }
    }
    return
  }
