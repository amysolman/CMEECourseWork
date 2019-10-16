#!/usr/bin/env python3
# Date: Oct 2019

__appname__ = 'oaks.py'
__version__ = '0.0.1'

"""In shell either run scope.py (for ipython)
or python3 scope.py. Script will generate five short scripts
looking at the value of local and global variables."""

# Functions are blocks of code that only run when called.
# What is created inside a function stays inside a function.
# Variables inside a function are invisible outside of it
# They don't presist once a function is run - these are local variables!
# Global variables are visible inside and outside functions
# Any variable created OUTSIDE the function is GLOBAL
# To create a GLOBAL variable inside a function use the GLOBAL keyword

_a_global = 10 # a global variable with value 10

if _a_global > 5: # if _a_global variable is greater than 5
    _b_global = _a_global + 5 # _b_global variable is equal to _a_global variable plus 5

def a_function(): # Let's (def)ine a function!
    _a_global = 5 # a local variable because it's inside a function

    if _a_global >= 5: # if this local variable is greater than or equal to 5
        _b_global = _a_global + 5 # we create _b_global which takes on the value of _a_global plus 5

    _a_local = 4 # This is a new local variable with the value 4

    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_local is ", _a_local)

    return None # Don't tell me anything else about this function - Just STOP!

a_function()

print("Outside the function the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)

_a_global = 10

def a_function():
    _a_local = 4

    print("Inside the function, the value _a_local is ", _a_local)
    print("Inside the function, the value of _a_global is ", _a_global)

    return None

a_function()

print("Outisde the function, the value of _a_global is ", _a_global)

_a_global = 10

print("Outside the function, the value of _a_global is ", _a_global)

def a_function():
    global _a_global
    _a_global = 5
    _a_local = 4

    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _a_local is ", _a_local)

    return None

a_function()

print("Outside the function, the value of _a_global now is", _a_global)

def a_function():
    _a_global = 10

    def _a_function2():
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()

    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of _a_global in main workspace / namespace is ", _a_global)

_a_global = 10

def a_function():

    def _a_function2():
        global _a_global
        _a_global = 20

    print("Before calling a_function, value of _a_global is ", _a_global)

    _a_function2()

    print("After calling _a_function2, value of _a_global is ", _a_global)

a_function()

print("The value of _a_global in main workspace / namespace is ", _a_global)
