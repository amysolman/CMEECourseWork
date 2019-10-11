##!/usr/bin/env python3

#############################
# FILE OUTPUT
#############################

""" In shell either run basic_io2.py (for ipython)
or python3 basic_io2.py and the module will save the numbers 0-99
to a new file called testout.txt. """

__appname__ = 'basic_io2.py'
__version__ = '0.0.1'

# Save the elements of a list to a file
list_to_save = range(100)

f = open('../sandbox/testout.txt', 'w') # w means write
for i in list_to_save:
    f.write(str(i) + '\n')

f.close()