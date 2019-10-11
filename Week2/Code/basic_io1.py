##!/usr/bin/env python3

#############################
# FILE INPUT
#############################

""" In shell either run basic_io1.py (for ipython)
or python3 basic_io1.py and the test file will print
to terminal. """

__appname__ = 'basic_io1.py'
__version__ = '0.0.1'

# Open a file for reading
f = open('../sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

""" Second module prints contents of file as before
but with lines removed. """

# Same example, skip blank lines
f = open('../sandbox/test.txt', 'r') # r for read
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()