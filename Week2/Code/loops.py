#!/usr/bin/env python3

__appname__ = 'loops.py'
__version__ = '0.0.1'

"""In shell either run loops.py (for ipython)
or python3 cfexerciseloops.py. Script contains five loops.
First loop will print integers within range(5). 
Second generates and print a list. Third creates list of
integers and loops through, adding them to total, printing and generating 
new total variable. Fourth 'while' loop prints variable + 1 and applies
output to new variable while variable is < 100. Fifth applies boolean statement 
to variable and prints message while statement is true.""" 

# FOR loops in Python
# Prints all numbers up to range (5)
for i in range(5): 
    print(i)

# Prints list
my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

# Prints accending numbers 0, 1, 12, 123, 1234
total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
print(total)

# WHILE loops in Python
# Prints numbers 1 to 100
z = 0
while z < 100:
    z = z + 1
print(z)

# Prints infinite loop of string
b = True
while b:
    print("GERONIMO! infinite loop! ctrl+c to stop!")
# ctrl + c to stop!