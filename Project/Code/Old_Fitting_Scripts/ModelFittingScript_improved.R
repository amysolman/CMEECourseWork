# Amy Solman amy.solman19@imperial.ac.uk
# 2nd April 2020
# ModelFittingScript.R: Fitting biphasic SAR model as described by Ryan et al. 2016

rm(list=ls())
graphics.off()

#install.packages("LambertW")
#library("LambertW") #for using Lambert W function
library("minpack.lm")#for nonlinear model fitting to find best-fit starting values
library(sfsmisc) 

#data <- read.csv('../Data/data.csv') read in data file here

#For the purposes of testing this script I've created a set of dummy data here
species_rich <- c(1, 1, 3, 4, 4, 6, 10, 15, 15, 19, 25, 31, 47, 56, 53, 54, 56, 58, 58, 58)
num_ind <- c(2, 4, 6, 8, 10, 13, 17, 27, 33, 40, 49, 61, 73, 85, 101, 123, 157, 163, 162, 179)
area <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
data <- data.frame(species_rich, num_ind, area)

#Define the biphasic mechanistic model as a function
#function takes fundamental biodiversity number (O), niche diversity (K), 
#average no. individuals per niche (j) and (y) - a function of average
#individuals per niche and immigration rate
chisholm_model <- function(theta, K, J_stars, gamma_stars) { 
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K))) 
}

#obtaining starting values K (niche diversity), O (fundamental biodiversity number),
# and m (immigration parameter)
#For each K between 1 and Smax, a least squares algorithm is used to find the best-fit values for ms and theta
K = 10 #will create a loop to run through values of K, but defined as 10 here to test the formulas

Smax <- max(data$Species.Richness, na.rm = TRUE) #maximum species richness
Js = As*rho #total number of individuals in the community
rho <- Js/(sum(data$Area)) #number of individuals per unit area
Amax <- max(data$Area) #maximum island area
Amed <- median(data$Area) #median island area
Samax <- as.numeric(data[which.max(data$Area),][1])#species richness on largest island
J_stars = Js/K #number of individuals per niche

#starting value for immigration rate
ms = m0*sqrt(A0)/sqrt(As)

#starting value for gamma_stars (a function of average individuals per niche and immigration rate)
gamma_stars = J_stars*ms/(1-ms) 

#starting value for fundamental biodiversity number
theta <- (Samax*gamma_stars*log(ms))/(Samax - gamma_stars*log(ms)*((Samax/gamma_stars*log(ms))*exp(Samax/gamma_stars*log(ms)))) #fundamental biodiveristy number
theta = 200 #fundamental biodiversity number 

#For each K, run a non-linear model fitting to find the best-fit values of m and O

fit_chisholm <- nlsLM(species_rich ~ chisholm_model(theta, K, J_stars, gamma_stars), data,
                          list(theta = theta, K = K, J_stars = J_stars, gamma_stars = gamma_stars))

#Select the m and O values for each K with the highest R^2 values




