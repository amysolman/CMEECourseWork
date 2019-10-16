#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Concatenates two files into new file
# Date: Oct 2019

"""Inputs text data from two files into single third file"""

cat $1 > $3
cat $2 >> $3
echo "Merged File is" cat $3