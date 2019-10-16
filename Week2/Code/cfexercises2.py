#!/usr/bin/env python3
# Date: Oct 2019

__appname__ = 'cfexercises2.py'
__version__ = '0.0.1'

"""In shell either run cfexercises2.py (for ipython)
or python3 cfexercises2.py. Script contains four scripts
combining loops and conditionals.""" 

# Prints 'hello' each time a number (in range 12) divided by 3 has no remainder
for j in range(12):
    if j % 3 == 0:
        print('hello')

# Prints 'hello' each time a number (in range 15) divided by 5 has a remainder of 3 OR divided by 4 has a remainder of 3
for j in range(15):
    if j % 5 == 3:
        print('hello')
    elif j % 4 == 3:
        print('hello')

# Prints 'hello' each time z isn't equal to 0, then adds 3 to z and repeats
z = 0
while z != 15:
    print('hello')
    z = z + 3

# Prints 'hello' 7 times when z is equal to 31 and one when equal to 18, then stops at 100
z = 12
while z < 100:
    if z == 31:
        for k in range(7):
            print('hello')
    elif z == 18:
        print('hello')
    z = z + 1