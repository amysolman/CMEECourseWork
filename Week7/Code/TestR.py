#!/usr/bin/env python3
# Date: 14th November 2019

"""Using subprocess to use R and python together"""

__appname__ = 'TestR.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk'
__version__ = '0.0.1'

#RUNNING R
#R is likely an importatn part of your project's analusis and data visualization components in particular
#For example for statistical analyses and pretty plotting (ggplot2)

import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout", shell=True).wait()


#Now run TestR.py (or %cpaste) and check TestR.Rout and RestR_errorFile.Rout. #WHAT IS %CPASTE???

#Also, check what happens if you run (type directly into ipython or python console):

subprocess.Popen("Rscript --verbose NonExistScript.R > ../Results/outputFile.Rout 2> ../Results/errorFile.Rout", shell=True).wait()

#It is possible that the location of RScript is different in your Ubuntu install. To locate it,
#try find /usr -name 'Rscript' in the linux terminal (not in python!). 
#For example, you might need to specify the path to it using /usr/lib/R/bin/Rscript.

#What do you see on the screen? Now check outputFile.Rout and 'errorFile.Rout.