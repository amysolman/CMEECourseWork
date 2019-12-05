#!/usr/bin/env python3
# Date: 3rd December 2019

"""Script ploting output of discrete-time version of Lokta-Volterra model"""

__appname__ = 'LV3.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import scipy as sc

import matplotlib.pylab as p

import numpy as np 


r = 1 #growth rate of resource pop
a = 0.1 #search rate for resource
z = 1.5 #mortality rate
e = 0.75 #consumers efficiency converting resource to consumer biomass
R0 = 10 #starting resource pop
C0 = 5 #starting consumer pop
K = 30

#Define time vector from point 0 to 30 using 10 subdivisions
timeseries = list(sc.linspace(0, 15, 1000))
rows = len(timeseries)

RC = np.zeros([rows,2]) #create numpy array of zeros 
RC[:1] = sc.array([R0, C0]) #fill the first row of the array with the starting pops

#Discrete-time version of the LV model

for t in range(0, len(timeseries) - 1):
    RC[t+1][0] = RC[t][0] * (1 + (r * (1 - RC[t][0] / K)) - a * RC[t][1]) #fill first column of the next row with the new R pop
    RC[t+1][1] = RC[t][1] * (1 - z + e * a * RC[t][0]) #fill first column of the next row with the new C pop

f1 = p.figure()
p.plot(timeseries, RC[:,0], 'g-', label='Resource density') #Plot
p.plot(timeseries, RC[:,1], 'b-', label = 'Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')

#Finally, save the figure as a pdf:

f1.savefig('../results/LV_model5.pdf') #save figure

f2 = p.figure()
p.plot(RC[:,0], RC[:,1], 'r-')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')

f2.savefig('../results/LV_model6.pdf')

