#!/bin/bash
#Author: Amy Solman amy.solman@imperial.ac.uk
#Script: run_LV1_LV2.sh
#Description:Bash script to run LV1.py and LV2.py

echo "Running of our scripts is about to begin..."

python3 -m cProfile LV1.py
python3 -m cProfile LV2.py 1. 0.1 1.5 0.75  

echo "Done!"
exit 

