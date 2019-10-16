#!/usr/bin/env python3
# Date: Oct 2019
# Filename: using_name.py

"""In shell either run using_name.py (for ipython)
or python3 using_name.py. Script will generate several different functions
using different conditionals.""" 

# Before python runs the code in a file it sets a few special variables, 
# __name__ is one of them. When it runs the file directly it sets the __name__ variable
# equal to __main__. But we can also import modules! Whenever we import a module 
# from another program/module, it sets the __name__ variable to the name of the file. 
# In this case __using_name__. It does this because the module is no longer being run directly
# from Python, it is being imported. This is useful because we can check if the file
# is being run directly from Python or imported.

if __name__ == '__main__':
    print('This program is being run by itself') # This program is being run directly!
else:
    print('I am being imported from another module')

print("This module's name is: " + __name__)

