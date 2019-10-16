# CMEE README WEEK 2

CMEE Bootcamp Week2 (07/10/19-11/10/19)
This week we were introduced to bioloigcal computing in Python. We covered topic areas including:
 - Working in ipython
 - Variables
 - Operators
 - Data structures
 - Testing blocks of code
 - Running scripts
 - Control flow tools
 - Comprehensions
 - Writing programs
 - Unit testing/debugging
 - Importing modules

All work was completed used Mac OS Mojave version 10.14.6, Python 3.7.4_1 and the code editor Visual Studio Code. Below is a comprehensive guide to all files and scripts within the WEEK2 directory of my CMEECourseWork folder.

# Sandbox
 - File - test.txt: Simple text file containing lines of text for manipulating in python script basic_io1.py (../Week2/Code).
 - File - testout.txt: Simple text file containing integers 0-99 printed in a column as output from basic_io2.py (../Week2/Code).
 - File - testp.p: File containing pickle dumped dictionary data from basic_io3.py (../Week2/Code)

# Code
  - File - basic_io1.py: Script for opening text file (../Sandbox/test.txt), printing contents of file, closing file, reopening file and printing contents again with the black lines stripped.
  - File - basic_io2.py: Script for saving integers in range 0-100 to new file testout.text.  
  - File - basic_io3.py: Script for pickle dumping (serializing/de-serializing) data from dictionary to testp.p.
  - File - basic_csv.py: Script for taking tabular data and turning into turples within a list. Also creating new csv file with only species name and body mass.
  - File - cfexercises1.py: Script containing six functions. 1) Calculates the square root of a variable. 2) Determines which of two variables is bigger. 3) Re-orders three variables. 4,5 and 6) Three different ways of finding factorials of a variable. Function 5 (foo_5) is a recursive function, calling itself. These foo functions are modules that take arguments from the user.
  - File - loops.py: Script containing fife loops. 1) Prints integers within range(5). 2) Generates and prints a list. 3)Creates list of integers and loops through, adding them to total, printing and generating new total variable. 4) 'While' loop prints variable + 1 and applies output to new variable while variable is < 100. 5) Applies boolean statement to variable and prints message while statement is true.
  - File - cfexercises2.py: Four short scripts combining loops and conditionals. 1) For each value in range(12). When the value divided by 3 has no remainder, print 'hello'. 2) For each value in range(15). When the value is divided by 5 with a remainder of 3 print 'hello', else if the value divided by four has a remainder of 3, print 'hello'. 3) While the value is not equal to 15 print 'hello'. Add three to variable and loop. 4) While the value of the variable is less than 100, if the variable is equal to 31 print 'hello' in range(7). Else if the variable is equal to 18, print 'hello'. Add 1 to variable and loop.
  - File - oaks.py: Four short scripts compairing the creation of sets from previous list/function using for loops and list comprehensions.
  - File - scope.py: Five different scripts showing the effect of global and local variables on output, as well as the 'global' keyword.
  - File - boilerplate.py: Basic "boilerplate" program for using sys module to action function when called in command line.
  - File - using_name.py: Script illustrating the __name__/__main__ code that tells us if a file it being run directly or imported.
  - File - sysargv.py: Script demonstrating the use of sys.argv. Prints name of module, length of module and the arguments applied to it.
  - File - control_flow.py: Five functions exemplifying the use of control statements.
  - File - Ic1.py: Script containing six short modules generated from a set list of birds with latin names, common names and mean body mass. 1) List comprehension containing birds latin names. 2) List comprehension containing birds common names. 3) List comprehension containing birds mean body mass. 4) Conventionl loops containing birds latin names. 5) Conventional loops containing birds common names. 4) Conventional loops containing birds mean body mass.
  - File - Ic2.py: Script containing four modules. First two use list comprehension to pull high and low rainfall data. Second two modules serve the same function but using conventional loops.
  - File - dictionary.py: Takes list of tuples including species latin name and order. Converts these to keys (order) and values (species) and prints as dictionary list.
  - File - tuple.py: Takes tuple or tuples (bird species latin, common names and mass) and prints each tuple on a seperate line.
  - File - test_control_flow.py: Script importing doctest module to run test functions on a piece of code.
  - File - debugme.py: Short script with erroneous function for use in debugging.
  - File - align_seqs.py: Takes two DNA sequences from csv file and saves best alignment with corresponding score to seperate txt file (.../Week2/Results/align_seq_result.txt).
  - File - oaks_debugme.py: Oak species search script, bugs removed. Includes doctest.
  - File - test_oaks_debugme.py: Oak species search script with doctest for function.
  - File - align_seqs_fasta.py: Compares DNA sequences of two fasta files.

# Data
 - File - testcsv.csv: Species data taked from TheMulQuaBio's data directory for manipulation in basic_csv.py script (../Week2/Code)
 - File - bodymass.csv: Species name and body mass data file output from basic_csv.py (../Week2/Code)
 - File - TestOaksData.csv: Oaks data for testing script (..Code/oaks_debugme.py)