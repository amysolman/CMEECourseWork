#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: MyExampleScript.sh
# Desc: Prints 'Hello' and 'username' twice
# Date: Oct 2019

"""Enter user name and see it printed twice"""

msg1="Hello"
msg2=$USER
echo "$msg1 $msg2"
echo "Hello $USER"
echo 