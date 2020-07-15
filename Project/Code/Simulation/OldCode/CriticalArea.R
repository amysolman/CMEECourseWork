#Script for finding archipelago critical area

rm(list=ls())
graphics.off()

#to find the critical area I need the island results
#and the estimated nlls fitting parameter values
Data <- read.csv("../../Results/Simulation2/SimAnalyticData.csv")
parameters <- read.csv("../../Results/Simulation2/parameters.csv")

theta <- parameters$theta
k <- as.numeric(parameters$niches)
m <- parameters$migration

ACrit <- theta*(1-m)*(exp(k/theta)-1)/m*1*log(1/m)
