#!/usr/bin/env python3

__appname__ = 'sysargv.py'
__version__ = '0.0.1'

"""In shell either run sysargv.py (for ipython)
or python3 sysargv.py. Script will generate the name of the module,
number of arguments applied to the module, and a list of the arguments.""" 

# An argument is a value provided to a function when you call it
import sys
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))