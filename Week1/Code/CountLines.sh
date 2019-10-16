#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: CountLines.sh
# Desc: Calculates the number of lines in a file
# Date: Oct 2019

"""Input a file and count the number of lines"""


NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo 
