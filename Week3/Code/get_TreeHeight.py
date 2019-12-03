#!/usr/bin/env python3
# Date: Dec 2019

"""Takes input file of tree distances and degress, calculates height
and outputs results file with input file name."""

__appname__ = 'get_TreeHeight.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
import pandas as pd
import os
import math


MyDF = pd.read_csv(sys.argv[1], sep=',')

inputfile = sys.argv[1]

TreeDistance = MyDF.iloc[:, 1]


TreeDegrees = MyDF.iloc[:, 2]

def Tree_Height(degrees, distance):
    radians = degrees*math.pi/180
    height = distance*radians.astype(float).map(math.tan)
    return(height)

TreeHeight = Tree_Height(TreeDegrees, TreeDistance)

MyDF['TreeHeight'] = TreeHeight

file_dir = "../Results"
outputfile = inputfile.split(".")[0] + "_treeheights_py.csv"
final_path = os.path.join(file_dir, outputfile)

export_csv = MyDF.to_csv(final_path, header=True, index=False)
