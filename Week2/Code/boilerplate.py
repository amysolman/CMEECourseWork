#!/usr/bin/env python3 - specifies location to python
# Tells the computer where to look for python
# Determines scripts ability to execute when part of a program

# Triple quotes start 'docstring' comment, describes operation of the script
# OR function/module within it
# Part of the running code in contrast to normal comments
# Access docstrings at run time
# Put at start
"""Description of this program or application.
    You can use several lines"""
# __ signal "internal" variables. Special variable names reserved
# By python for its own purposes
__appname__ = '[Boilerplate]'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## imports ##
import sys # module to interface our program with the operating system
# allows you to be able to access modules from this program elsewhere using the module name

## constants ##

## functions ##
# def indicates start of a python function, all subsequent lines must be indented
# File containing function def and statements (assignments of constant variables) called modules
# argv = argument variable. A variable that holds the arguments you pass 
# to your Python script when you run it
# sys.argv object created by python using sys module (imported at beginning of script)
# that contains names of the argument variables in the current script

# This is the main function. Arguments obtained in the __name__ function
# Are fed to the main function
# if main function called only code in this module imported into other programs
# argv means arguments (values passed to a function) vector (transporter)
def main(argv): # defining main as a function and 
    """ Main entry point of the program """
    print('This is a boilerplate') # NOTE: indented used two tabs or 4 spaces
    return 0 # 0 means everything ran and has been fine. Hidden variable.

# Makes the file useable as a script as well as an importable moduel
# Directs python to set the special name variable (__name__) to have the value "__main__"
# This part means if you type the function name into command line
# it will action the module
if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)
# Terminates the program in an explicit manner, returning appropriate status code
# Main () returns 0 on successful run
# sys.exit(status) returns zero - successful termination

