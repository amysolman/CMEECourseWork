#!/urs/bin/env python3
# Date: Oct 2019

"""Short script for running with python debugger"""

def makeabug(x):
    y = x**4 # x to the power of 4
    z = 0.
    y = y/z # doesn't work because you can't divide by 0
    return y

makeabug(25)

