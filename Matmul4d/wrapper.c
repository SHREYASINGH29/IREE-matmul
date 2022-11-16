#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// MACRO: baseline = 1 runs the plain C baseline; otherwise calls the
// MLIR-generated function. Compile with -Dbaseline=1 or -Dbaseline=0

#define Grid 16 
#define size 1024
#define block_size 64
#define C(P0,P1,i,j) (C[(P0 * block_size + i) * size + (P1 * block_size + j)])
#define A(P0,Kouter,i,k) (A[(P0 * block_size +i) * size + (Kouter * block_size + k)])
#define B(Kouter,P1,k,j) (B[(Kouter * block_size + k) * size + (P1 * block_size + j)])
//C[i][j] = A[i][k] * B[K][j]
//C[i*n+j] = A[i*n+K] * B[k*n+j]
// MLIR/LLVM-generated function
extern void
matmul
(
 void*, void*, int64_t, int64_t, int64_t, 
 void*, void*, int64_t, int64_t, int64_t,
 void*, void*, int64_t, int64_t, int64_t
 );


void print_arr(int len, float* A){
	for(int i = 0; i < size; i++) {
    	for(int j = 0; j < size; j++) {
			int x = i *size + j;

        	printf("%d,%f ",x,A[x]);
    	}
    	printf("\n");
	} 
}
void main(void) {
  // Data arrays
  float* B = malloc(sizeof(float)*size*size);
  float* A = malloc(sizeof(float)*size*size);
  float* C = malloc(sizeof(float)*size*size);    

  int i, j, k, Kouter, P0, P1;
//Initialize A
for(P0 = 0; P0 < Grid; P0++)
	for(Kouter = 0; Kouter < Grid; Kouter++)
		for(i = 0; i < block_size; i++)
			for(k = 0; k < block_size; k++){
				//A(P0,Kouter,i,k) = (P0 + Kouter + i +k)%3;
				A(P0,Kouter,i,k) = 2;
				
			}
//Initialize B
for(P1 = 0; P1 < Grid; P1++)
	for(Kouter = 0; Kouter < Grid; Kouter++)
		for(j = 0; j < block_size; j++)
			for(k = 0; k < block_size; k++)
	//			B(Kouter,P1,k,j) = (Kouter +P1+k+j)%3;
				B(Kouter,P1,k,j) = 3;
//Initialize C
for(P0 = 0; P0 < Grid; P0++)
	for(P1 = 0; P1 < Grid; P1++)
		for(i = 0; i < block_size; i++)
			for(j = 0; j < block_size; j++)
				C(P0,P1,i,j) = 0;
//print_arr(size,A);
//print_arr(size, B);
//print_arr(size, C);
  clock_t t = clock();


  if (baseline) {
	for(P0 = 0; P0 < Grid; P0++)
		for(P1 = 0; P1 < Grid; P1++)
			for(Kouter = 0; Kouter < Grid; Kouter++)
				for(i = 0; i < block_size; i++)
					for(j = 0; j < block_size; j++)
						for(k = 0; k < block_size; k++)
							C(P0,P1,i,j) += A(P0,Kouter,i,k)*B(Kouter,P1,k,j);
  } else {
	  matmul(A,A,0,size,1,B,B,0,size,1,C,C,0,size,1);
  }
  
  t = clock() - t;
  print_arr(size, C);
  double time_taken = ((double)t)/CLOCKS_PER_SEC; // in seconds
  if (baseline)
    printf("Baseline time: %lf sec\n", time_taken);
  else
    printf("MLIR time: %lf sec\n", time_taken);    

  // Simple checksum
//  double check = 0.;
//  for (n = 0; n < N; n++)
//    for (h = 0; h < H; h++)
//      for (w = 0; w < W; w++)
//	for (f = 0; f < F; f++)  	
//	  check += ((n+h+w+f)%2==0) ? Out(n,h,w,f) : -Out(n,h,w,f);
//  printf("Checksum: %lf\n",check);
//  
}
