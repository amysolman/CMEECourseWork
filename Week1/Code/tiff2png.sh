#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: tiff2png.sh
# Desc: Converts tiff file to png file
# Date: Oct 2019

for f in *.tif;
do  
    echo "Converting $f"; 
    convert "$f"  "$(basename "$f" .tif).jpg"; 
done