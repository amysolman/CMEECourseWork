#!/bin/bash
#Author: Amy Solman amy.solman@imperial.ac.uk
#Script: run_LV1_LV2.sh
#Description:Bash script to run LV1.py, LV2.py and LV3.py

echo "Running of our scripts is about to begin..."

ipython3 run LV1.py
ipython3 run LV2.py 1. 0.1 1.5 0.75 
ipython3 run LV3.py
ipython3 run LV4.py

echo "Now for profiling!"

python3 -m cProfile LV1.py
python3 -m cProfile LV2.py 1. 0.1 1.5 0.75 
python3 -m cProfile LV3.py
python3 -m cProfile LV4.py


echo "Done!"
exit 

