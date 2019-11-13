# Amy Solman amy.solman19@imperial.ac.uk
# 25th October 2019
# Lecture 6

##########LECTURE SIX##########

#Using statistical powers

#The chance that it will come out statistically significant when it should - 
#this is, when the alternative hypothesis is really true. Power is a probability and
#is very often expressed as a percentage.

rm(list=ls())

setwd("/Users/amysolman/Documents/SparrowStats/HandOutsandData'18")
d <- read.table("SparrowSize.txt", header = TRUE)

library(pwr)

#POWER ANALYSIS
pwr.t.test(d=(0-0.16)/0.96, power=.8,sig.level=.05, type = "two.sample", alternative="two.sided")

#POWER ANALYSIS TO FIND DIFFERENCE OF AN EFFECT SIZE OF 5MM
pwr.t.test(d=(0-5)/2.41,power=0.8,sig.level=0.05,type="two.sample",alternative="two.sided")
