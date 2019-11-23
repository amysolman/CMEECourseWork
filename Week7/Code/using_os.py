""" This is blah blah"""

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess, pathlib, re

subprocess.Popen(["ls", "-l"], cwd=pathlib.Path.home())

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []

# Use a for loop to walk through the home directory.
for (dir, subdir, files) in subprocess.os.walk(home):
        FilesDirsStartingWithC.extend(re.findall(r'^C\w+', ''.join(dir)))
        FilesDirsStartingWithC.extend(re.findall(r'^C\w+', ''.join(subdir)))
        FilesDirsStartingWithC.extend(re.findall(r'^C\w+', ''.join(files)))
print(FilesDirsStartingWithC)

#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
home = subprocess.os.path.expanduser("~")
FilesDirsStartingWithCc = []
for (dir, subdir, files) in subprocess.os.walk(home):
        FilesDirsStartingWithCc.extend(re.findall(r'^C\w+|^c\w+', ''.join(dir)))
        FilesDirsStartingWithCc.extend(re.findall(r'^C\w+|^c\w+', ''.join(subdir)))
        FilesDirsStartingWithCc.extend(re.findall(r'^C\w+|^c\w+', ''.join(files)))
print(FilesDirsStartingWithCc)

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:
home = subprocess.os.path.expanduser("~")
DirsStartingWithCc = []
for (dir, subdir, files) in subprocess.os.walk(home):
        DirsStartingWithCc.extend(re.findall(r'^C\w+|^c\w+', ''.join(dir)))
        DirsStartingWithCc.extend(re.findall(r'^C\w+|^c\w+', ''.join(subdir)))
print(DirsStartingWithCc)