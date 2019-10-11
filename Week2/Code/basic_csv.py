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
temp = []
for row in csvread:
    temp.append(tuple(row)) 
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
#         print(row)
#         print("The species is", row[0])


# write a file containing only species name and Body mass
f = open('../data/testcsv.csv','r')
g = open('../data/bodymass.csv','w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
