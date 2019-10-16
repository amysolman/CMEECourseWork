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
def foo_1(x):
    return x ** 0.5

# Takes two numbers, prints the largest
def foo_2(x, y):
    if x > y:
        return x
    return y

# Tries to sort numerically but doesn't fully work
def foo_3(x, y, z):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

# Here is an alterntaive script that sorts three integers
# def foo_3(x, y, z):
#     a = min(x, y, z)
#     b = max(x, y, z)
#     c = (x + y + z) - (a + b)
#     return [a, c, b]

# Factoria of 4 = (4x1) + (4x2) + (4x3) = 24
def foo_4(x):
    """ Calculate the factorial of x """
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x): # a recursive function (calls itself - foo_5) that calculates the factorial of x
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x): # Calculate the factorial of x in a different way
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto 

def main(argv):
    print(foo_1(3))
    print(foo_2(1, 4))
    print(foo_3(3, 4, 5))
    print(foo_4(3))
    print(foo_5(2))
    print(foo_6(7))
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)