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