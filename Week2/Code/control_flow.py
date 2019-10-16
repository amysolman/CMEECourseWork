#!/usr/bin/env python3
# Date: Oct 2019

"""Some functions exemplifying the use of control statements"""
#docstrings are considered part of the running code (normal comments
# are stripped). Hence, you can access your docstrings at run time.

__appname__ = 'countrol_flow.py'
__author__ = 'Samraat Pawar (s.pawar@imperial.ac.uk)'
__version__ = '0.0.1'

import sys # module to interface our program with the operating system

def even_or_odd(x=0): # if not specified, x should take value 0.

    """Find whether a number x is even or odd."""
    if x % 2 == 0: # If the variable / 2 has remainder 0
        return "%d is Even!" % x # Give me 'variable' is Even
    return "%d is Odd!" % x # Remainder != 0 give me 'variable' is Odd
def largest_divisor_five(x=120): # Define function, 0 = 120 if not specified
    """Find which is the largest divisor of x among 2,3,4,5."""
    largest = 0 # variable (largest) = 0
    if x % 5 == 0: # if variable (x) / 5 has remainder 0
        largest = 5 
    elif x % 4 == 0: # means "else, if"
        largest = 4
    elif x % 3 == 0:
        largest = 3
    elif x % 2 == 0:
        largest == 2
    else: # When all other (if, elif) conditions are not met
        return "No divisor found for %d!" % x # Each function can return a value or a variable.
    return "The largest divisor of %d is %d" % (x, largest)

def is_prime(x=70):
    """Find whether an integer is prime."""
    for i in range(2, x): # "range" returns a sequence of integers
        if x % i == 0:
            print("%d is not a prime: %d is a divisor" % (x, i))
            return False

    print("%d is a prime!" % x)
    return True

def find_all_primes(x=22):
    """Find all the primes up to x"""
    allprimes = []
    for i in range(2, x + 1):
        if is_prime(i):
            allprimes.append(i)
    print("There are %d primes between 2 and %d" % (len(allprimes), x))
    return allprimes

def main(argv):
    print(even_or_odd(22))
    print(even_or_odd(33))
    print(largest_divisor_five(120))
    print(largest_divisor_five(121))
    print(is_prime(60))
    print(is_prime(59))
    print(find_all_primes(100))
    return 0

# Makes the file useable as a script as well as an importable moduel
# Directs python to set the special name variable (__name__) to have the value "__main__"
if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)
# Terminates the program in an explicit manner, returning appropriate status code
# Main () returns 0 on successful run
# sys.exit(status) returns zero - successful termination

