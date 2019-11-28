#!/usr/bin/env python3
# Date: 11th November 2019

"""Script ploting output of Lokta-Volterra model"""

__appname__ = 'LV1.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk'
__version__ = '0.0.1'

import scipy as sc

import scipy.integrate as integrate

import matplotlib.pylab as p

#Now define a function that returns the growth rate of consumer and resource population at any give time step.
def dCR_dt(pops, t=0):

    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

type(dCR_dt)

#So dCR_dt has been stored as a function object in teh current Python session, all ready to go.
#Now assign some parameter values:

r = 1. #growth rate of resource pop
a = 0.1 #search rate for resource
z = 1.5 #mortality rate
e = 0.75 #consumers efficiency converting resource to consumer biomass

#Define the time vector; let's integrate from time point 0 to 15, using 1000 sub-divisions of time:

t = sc.linspace(0, 15, 1000) #sc.linspace = return evenly spaced numbers over a
#specified interval from x to y with z subdivisions
#Note that the units of time are arbitrary here.
#Set the initial conditions for the two populations (10 resources and 5 consumers per unit area)
#and convert the two into an array (because our dCR_dt function takes an array as input)

R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

#Now numerically integrate this system forward from those starting conditions:

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)
pops
#So pops contains the result (the population trajectories).
#Also check what's in infodict (it's a dictionary with additional information).
type(infodict)
infodict.keys()
#check what the infodict output is by reading the help documentation with ?scipy.integrate.odeint.
#For example, you can return a message to screen about whether the integration was successful:
infodict['message']
infodict['hu']
#So it worked, great! But we would like to visualize the results. LEt's do it using the matplotlib package.

#PLOTTING IN PYTHON
#To visualize the results of your numerical simulations in Python (or for data exploration/analyses),
#you can use matplotlib which uses Matlab like plotting syntax.
#First let's import the package:

#Now open an empty figure object (analogous to an R graphics object)

f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') #Plot
p.plot(t, pops[:,1], 'b-', label = 'Consumer densioty')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')

#Finally, save the figure as a pdf:

f1.savefig('../results/LV_model.pdf') #save figure

f2 = p.figure()
p.plot(pops[:,0], pops[:,1], 'r-')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')

f2.savefig('../results/LV_model2.pdf')