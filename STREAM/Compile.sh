#!/bin/bash
export OMP_NUM_THREADS=10
#gcc -O -fopenmp stream.c -DSTREAM_ARRAY_SIZE=1000000000  -mcmodel=medium -o stream_omp
gcc -g -O -fopenmp stream-numa-move.c    -lnuma -DSTREAM_ARRAY_SIZE=32768000  -mcmodel=medium -o stream_numa_move_omp
#time ./stream_omp
