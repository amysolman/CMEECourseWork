#!/usr/bin/env python3
# Date: Dec 2019

"""Creates a matrix (collection of elements of samer data type -
here numeric - arranged in fixed number of rows/columns.
A 2D vector, made of 1000000 random deviates, with 1000 rows and 1000 columns."""

__appname__ = 'Vectorize1.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import scipy as sc 
import numpy as np 
import time

#create a matrix of 1,000,000 random numbers (0,1) with 1000 x 1000 dimensions
M = np.random.uniform(size = 1000000)
M = M.reshape(1000,1000)
M = sc.matrix(M)

def SumAllElements(M):
    Dimensions = M.shape
    Sum = 0
    for i in range(Dimensions[0]):
        for j in range(Dimensions[1]):
            Sum = Sum + M[i,j]
    return(Sum)

start = time.time()
SumAllElements(M)
print("The loop function takes %fs to run." % (time.time() - start))

start = time.time()
np.sum(M)
print("The in-built vectorized function takes %fs to run." % (time.time() - start))



