#!/bin/bash
#Author: Amy Solman amy.solman@imperial.ac.uk
#Script: run_get_TreeHeight.sh
#Description:Bash script to run get_TreeHeight.R with input file

echo "Test of get_TreeHeight.R is about to begin..."
echo "Our input file is trees.csv"

Rscript get_TreeHeight.R trees.csv
ipython3 get_TreeHeight.py trees.csv

echo "Done!"
exit 