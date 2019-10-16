#!/usr/bin/env python3
# Date: Oct 2019

__appname__ = 'oaks.py'
__version__ = '0.0.1'

"""In shell either run oaks.py (for ipython)
or python3 oaks.py. Script will generate a function for finding oaks within a list,
adds those species to a new set using loops, does the same again using list comprehensions.
The script then runs the same modules again with UPPER CASE outputs.""" 

## Finds just those taxa that are oak trees from a list of species
# Adds any species from the list that match the defined criteria
taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea'
        ]
def is_an_oak(name): # define a function (is_an_oak) to be used with variable (name)
    return name.lower().startswith('quercus ') # give the variable (name) is lowercase if it
# starts with string 'quercus'. This does not print the list just applied them to the is_an_oak
# function.

## Using for loops
# From the pre-defined list is_an_oak, adds those species to a seperate set oaks_loops
oaks_loops = set() # create a new empty set (oak_loops)
for species in taxa: # for items (species) in the list (taxa)
    if is_an_oak(species): # if an item (species) matches with names added to the previous function
        oaks_loops.add(species) # add that item to the function
print(oaks_loops) # print the function

## Using list comprehensions
# Adds species from is_an_oak species to oaks_lc list
oaks_lc = set([species for species in taxa if is_an_oak(species)]) # creates new set
# conditional says if there is an item in the taxa list that matches the is_an_oak list 
# it will be added to the new list
print(oaks_lc) # print the list

## Get names in UPPER CASE using for loops
oaks_loops = set() # create empty set
for species in taxa: # for items in original list
    if is_an_oak(species): # if they match items in the is_an_oak function
        oaks_loops.add(species.upper()) # add them to oaks_loops in upper case
print(oaks_loops) # print list

## Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)]) # create new set 
# items printed in uppercase for items in list if same at items in function
print(oaks_lc) # print list