#!/usr/bin/env python3

__appname__ = 'basic_csv.py'
__version__ = '0.0.1'

"""Reads tabular file with species name, order, family, 
distribution and male body mass. Read in to csvread variable,
for each row of information transforms into turples within temp list.
Prints 'The species is' followed by each turpled row."""

import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
f = open('../data/testcsv.csv','r')

csvread = csv.reader(f) # reads in the info using csv module and saves to csvread variable
temp = [ ] #create an empty list
for row in csvread: #for each row in the data read from the file
    temp.append(tuple(row)) #add to the list 'temp' the row data as a tuple
#Tuples are like a list but immutable, that is, a particular pair or sequence of strings
#or numbers cannot be modified after it is created
#So a tuple is like a read-only list

print(row)
print("The species is", row[0])

# Includes top info in table (species, infraorder etc.)

f.close()

# With is a better manner to handle file open/close operations
# with open('../Data/testcsv.csv', 'r') as f:
#     csvread = csv.reader(f)
#     temp = []
#     for row in csvread:
#         temp.append(tuple(row))
#     print(row)
#     print("The species is", row[0])


# write a file containing only species name and Body mass
f = open('../data/testcsv.csv','r') #open the data file
g = open('../data/bodymass.csv','w') #create/open a new file we're going to put our data into

csvread = csv.reader(f) #create a new vector with the data from the file
csvwrite = csv.writer(g) #create a new vector to fill with the data for our new file
for row in csvread: #for each row in the data
    print(row) #print the row
    csvwrite.writerow([row[0], row[4]]) #write to our new file the data from the first row and 5th column

f.close()
g.close()

