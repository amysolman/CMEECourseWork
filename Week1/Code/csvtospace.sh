#!/bin/bash
# Author: Amy Solman amy.solman19@imperial.ac.uk
# Script: csvtospace.sh
# Desc: substitute comma seperated values in the files with spaces
# saves the output into a new .txt file
# Arguments: 1-> comma delimited file
# Date: Oct 2019

"""Creates new space seperated file from csv file"""

echo "Creating a space seperated values version of $1 ..."
cat $1 | tr -s "," "\t" >> $1.txt
echo "Done!"
exit
