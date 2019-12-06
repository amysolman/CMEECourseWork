#!/usr/bin/env python3
# Date: 16th November 2019

"""Script ploting output of Lokta-Volterra model"""

__appname__ = 'LV2.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
from sys import argv
script, first, second, third, fourth = argv

#Now define a function that returns the growth rate of consumer and resource population at any give time step.
def dCR_dt(pops, t=0):

    R = pops[0]
    C = pops[1]
    dRdt_1 = r * R - a * R * C
    K = r * R * ( 1 - R) / dRdt_1
    dRdt = r * R * (1 - R /  K) - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

r = float(first)
a = float(second)
z = float(third)
e = float(fourth)

t = sc.linspace(0, 15, 1000) 
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)

f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') #Plot
p.plot(t, pops[:,1], 'b-', label = 'Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics \n r = 1, a = 0.1, z = 1.5, e = 0.75')
Final_Pred_Pop = pops[:,0][-1]
Final_Prey_Pop = pops[:,1][-1]
textstr2 = '\n'.join((
    r'$Final Pred Pop=%.2f$' % (Final_Pred_Pop, ),
    r'$Final Prey Pop=%.2f$' % (Final_Prey_Pop, )))
props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
p.text(0.05, 40, textstr2, fontsize=12,
        verticalalignment='top', bbox=props)

f1.savefig('../results/LV2_model1.pdf') #save figure

f2 = p.figure()
p.plot(pops[:,0], pops[:,1], 'r-')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics \n r = 1, a = 0.1, z = 1.5, e = 0.75')
Final_Pred_Pop = pops[:,0][-1]
Final_Prey_Pop = pops[:,1][-1]
textstr2 = '\n'.join((
    r'$Final Pred Pop=%.2f$' % (Final_Pred_Pop, ),
    r'$Final Prey Pop=%.2f$' % (Final_Prey_Pop, )))
props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
p.text(5, 18, textstr2, fontsize=12,
        verticalalignment='top', bbox=props)
f2.savefig('../results/LV2_model2.pdf')
