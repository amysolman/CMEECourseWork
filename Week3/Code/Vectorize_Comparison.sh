#!/bin/bash
#Bash script to run and time all four vectorization scripts 

echo "Script comparison is beginning!"

time Rscript Vectorize1.R
time ipython3 Vectorize1.py
time Rscript Vectorize2.R 
time ipython3 Vectorize2.py

echo "Script comparison has finished!"