#!/usr/bin/env python3
# Date: 15th November 2019

"""Runs fmr.R to generate desired pdf plot"""

__appname__ = 'run_fmr_R.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk'
__version__ = '0.0.1'


import subprocess

p = subprocess.Popen(["Rscript", "fmr.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()
print(stdout.decode())
if p.returncode == 0:
    print('Run successful! Well done! Goldstar!')

#run_fmr_R.py should also print to the python screen whether the run was successful, and the contents of the R console output