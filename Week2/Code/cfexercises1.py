#!/usr/bin/env python3
# Date: Oct 2019

__appname__ = 'cfexercises1.py'
__version__ = '0.0.1'

"""In shell either run cfexercises1.py (for ipython)
or python3 cfexercises1.py. Script will generate several different functions
using different conditionals. Sys module means functions can be called 
for use with other scripts.""" 

import sys 

# What does each of foo_x do?
# This take the square root
def foo_1(x=4):
    return x ** 0.5 

# Takes two numbers, prints the largest
def foo_2(x=5, y=10):
    if x > y:
        return x
    if x < y:
        return y


# Tries to sort numerically but doesn't fully work
def foo_3(x=5, y=2, z=3):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

 #Here is an alterntaive script that sorts three integers
def foo_3a(x=8, y=4, z=6):
    a = min(x, y, z)
    b = max(x, y, z)
    c = (x + y + z) - (a + b)
    return [a, c, b]

# Factoria of 4 = (4x1) + (4x2) + (4x3) = 24
def foo_4(x=4):
    """ Calculate the factorial of x """
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x=24): # a recursive function (calls itself - foo_5) that calculates the factorial of x
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x=4): # Calculate the factorial of x in a different way
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto 

def main(argv):
    print(foo_1(4))
    print(foo_2(5, 10))
    print(foo_3(5, 2, 3))
    print(foo_3a(8, 4, 6))
    print(foo_4(4))
    print(foo_5(24))
    print(foo_6(4))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
    
