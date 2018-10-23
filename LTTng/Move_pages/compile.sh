#!/bin/bash 
#gcc  -fopenmp test1.c  -lnuma -o test1
#gcc  -g -fopenmp move_pages.c  -lnuma -o move_pages 
#gcc  -g -fopenmp move_pages.c  -finstrument-functions -lnuma -o move_pages 

gcc -c -I. move_pages_tp.c
gcc -c move_pages.c
gcc -g -fopenmp -o move_pages move_pages.o move_pages_tp.o -llttng-ust -ldl -finstrument-functions -lnuma
