#Runs fmr.R to generate the desired result

import subprocess

p = subprocess.Popen(["Rscript", "fmr.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()
print(stdout.decode())
if p.returncode == 0:
    print('Run successful! Well done! Goldstar!')

#run_fmr_R.py should also print to the python screen whether the run was successful, and the contents of the R console output