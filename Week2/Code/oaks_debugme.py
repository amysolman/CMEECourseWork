#!/usr/bin/env python3 

"""Script reading tree species from a file and adding to
second file if oak species. Includes doctest."""

# Open and run the code oaks_debugme.py — there's a bug, for no oaks are being found! 
# (where's TestOaksData.csv? — in the data directory of TheMulQuaBio repo!)
# Fix the bug (e.g., you could insert a debugging breakpoint using import ipdb; ipdb.set_trace())
# Now, write doctests to make sure that, bug or no bug, your is_an_oak function is working as expected 
# (hint: >>> is_an_oak('Fagus sylvatica') should return False)
# If you wrote good doctests, you will find another bug that you might not have by just debugging 
# (hint: what happens if you try the doctest with "Quercuss" instead of "Quercus"? Should this pass or fail?). 
# Modify your doctests approriately, and modify your script such that it can handle cases where there is a typo 
# (such as 'Quercuss') or there is a genus name that is not strictly 'Quercus'. 

__appname__ = 'oaks_debugme.py'

__version__ = '0.0.1'


import csv # to read and write csvs
import sys # to modularise functions within a script
# can be used to get information from the user
# part of the standard library within python - does lots of things!
import doctest # to test arguments against a function

#Define function
def is_an_oak(name): # defines the function is_an_oak which will take the argument 'name'
    """ Returns True if name is starts with 'quercus' """ 
    return name.split()[0].lower() == 'quercus'

def main(argv): # define's the main function that will take the argument value (argv)
# argv is a list - first value is name of the value. Shows where you are in the file system
    f = open('../data/TestOaksData.csv','r') # open testoaksdata to read
    g = open('../data/JustOaksData.csv','w') # open a new file  justoaksdata to write
    writer = csv.DictWriter(
        g, fieldnames=["Genus", "Species"])
    writer.writeheader()
    taxa = csv.reader(f) # the variable (taxa) is applied to the testoaksdata file
    csvwrite = csv.writer(g) # the variable (csvwrite) is applied to the justoaksdata file
    next(taxa, None)
    oaks = set() # create a new set called oaks
    
    for row in taxa: # for each thing in testoaksdata
        print(row) # print that thing
        print ("The genus is: ") # print 'the genus is'
        print(row[0] + '\n') # print the first character in the first row of things in the testoaks data with a break
        if is_an_oak(row[0]): 
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])  
    

    return 0

    
if (__name__ == "__main__"):
    status = main(sys.argv)