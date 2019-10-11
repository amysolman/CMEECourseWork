#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: variables.sh
# Desc: Prints string, asks for and prints new string. Asks for two numbers, adds and prints result.
# Date: Oct 2019

#Shows the use of variables
MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of a variable is' $MyVar

## Reading multiple values
echo 'Enter two numbers seperated by space(s)'
read a b 
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum=`expr $a + $b`
echo $mysum 
