#USING PYTHON TO BUILD WORKFLOWS

#You can use python to build an automated data analysis or simulation
#workflow that involves multiple languages, especially the ones
#you have already learnt: R, LATEX, UNIX bash
#For example, you could, in theory, write a single Python script
#to generate and update your masters dissertation, tables, plots, and all.
#Python is ideal for building such workflows because it
#has packages for practically every purpose.
#Thus this topic may be useful for your Miniproject, which will involve
#building a reproducible computational workflow.

#USING SUBPROCESS
#For building a workflow in Python the subprocess module is key.
#With this module you can run non-Python commands and scripts, obtain their outputs,
#and also crawl through and manipulate directories.

#First, import the module (this is part of the python standard lbrary
# so you won't need to install it)

import subprocess

#RUNNING PROCESSES
#There are two main ways to run commands through subprocess:
#'run' for basic usage, and 'Popen' (process open) for more advances usage.
#We will work directly with popen because run() is a wrapper around
#popen. Using popen directly gives more control over how the command is run,
#and how its input and output are processed.
#Let's try running some commands in the UNIX bash
#n a terminal, first cd to your code directory, launch ipython3, then and type:

p = subprocess.Popen(["echo", "I'm talkin' to you, bash!"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
#create object (p) - subprocess, process open - the lines you would usually type into terminal are entered here as strings "echo" and "I'm talking to you bash"
#stdout = output from the process created by command, in bytes, will need to be decoded
#stderr = error code to show if the process ran correctly
#PIPE = creates PIPE to "child process", sends the information from this command to the new command

#This creates an object p, from which you can extract the output and other information from the command you ran.
#Before we do anything more, let's look at our subprocess.popen call carefully.
#The command line arguments were passed as a list of strings, which avoids the need for escaping quotes or other
#special characters that might be interpreted by the shell (for example, in this case, there are apostrophes in the string
#that is being echoed in bash)
#stdout is the output from the process "spawned" by your command. This is bytes sequence (which you will need to decode - 
#more on this below)
#stderr is the error code (from which you can capture whether the process ran successfully or not). The method PIPE creates
#a new "pipe" to the "child process".

stdout, stderr = p.communicate()
stderr #nothing in this error code

#Nothing here, because the echo command does not return any code.
#The 'b' indicates that the output is in bites (unencoded).
#By default, stdout, stderr (and other outputs of p.communicate) are returned as binary (byte) format.
#Now check what's in stdout:

stdout #contains out message in bytes

#Let's encode and print it:
print(stdout.decode()) #decodes the bash command and prints

#You can also use a universal_newlines = True so that these outputs
#are returned as encoded text (default beng utf-8 usually), with line
#endings converted to '\n'.

#Let's try something else:
p = subprocess.Popen(["ls", "-l"], stdout=subprocess.PIPE)
stdout, stderr = p.communicate()
print (stdout.decode())
#Recall that the ls -l command lists all files in a long list format.

#You can also call python itself from bash (!):

p = subprocess.Popen(["python", "boilerplate.py"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()
print(stdout.decode())

#Similarly, to compile a LATEX document (using pdflatx in this case), you can
# do something like this:
# subprocess.os.system("pdflatex yourlatexdoc.tex")

# You can also do this instead:
########WHAT IS DIFFERENT ABOUT THESE?
p = subprocess.Popen(["python", "boilerplate.py"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()
print(stdout.decode()) 

#HANDLING DIRECTORY AND FILE PATHS

#You can also use subprocess.os to make your code OS (Linux, Windows, Mac) independent.
#For example, to assign paths:

subprocess.os.path.join('directory', 'subdirectory', 'file')

#Note that in all cases you can "catch" the output of subprocess so that you can then
#use the ouput within your python script. A simple example, where the output is a platform-dependent directory path, is:

MyPath = subprocess.os.path.join('amysolman', 'Documents', 'CMEECourseWork')
MyPath

#Explore what subprocess can do by tabbing subprocess., also for 
#submodules e.g. type subprocess.os. and then tab.