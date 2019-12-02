#!/usr/bin/env python3
# Date: Dec 2019

"""Runs the stochastic (with gaussian fluctuations) Ricker Eqn
 followed by a vectorized version of the same equation"""

__appname__ = 'Vectorize2.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import numpy as np 
import scipy as sc 
import time 

def stochrick(p0 = np.random.uniform(low = 0.5, high = 1.5, size = 1000), r = 1.2, K = 1, sigma = 0.2, numyears = 100):
    N = sc.zeros((numyears, len(p0)))
    N[1,] = p0 # apply the starting population to the matrix first row, all columns
    for pop in range(len(p0)): #loop through the populations
        for yr in range(2, numyears): #for each pop, loop through the years
            N[yr,pop] = N[yr-1,pop]*np.exp(r*(1-N[yr-1,pop]//K)+np.random.normal(loc = 0.0, scale = sigma, size = 1)) # run the stochastic 
    return(N)  

start = time.time()
stochrick(p0 = np.random.uniform(low = 0.5, high = 1.5, size = 1000), r = 1.2, K = 1, sigma = 0.2, numyears = 100)
print("The loop Stochastic Ricker function takes %fs to run." % (time.time() - start))

def stochrick(p0, r = 1.2, K = 1, sigma = 0.2, numyears = 100):
    N = sc.zeros((numyears, len(p0)))
    N[1,] = p0 
    for yr in range(2, numyears): #for each pop, loop through the years
        N[yr,] = N[yr-1,]*np.exp(r*(1-N[yr-1,]//K)+np.random.normal(loc = 0.0, scale = sigma, size = 1)) # run the stochastic 
    return(N) 

start = time.time()
stochrick(p0 = np.random.uniform(low = 0.5, high = 1.5, size = 1000), r = 1.2, K = 1, sigma = 0.2, numyears = 100)
print("The vectorized Stochastic Ricker function takes %fs to run." % (time.time() - start))