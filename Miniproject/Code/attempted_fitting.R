# Amy Solman amy.solman19@imperial.ac.uk
# 10th April 2020
# ModelFittingScript.R: Fitting biphasic SAR model as described by Ryan et al. 2016

rm(list=ls())
graphics.off()

library("minpack.lm")#for nonlinear model fitting to find best-fit starting values
library(sfsmisc) #Ryan used this for plotting his data, do I need this?

#My dummy dataset
species_rich <- c(1, 1, 3, 4, 4, 6, 10, 15, 15, 19, 25, 31, 47, 56, 53, 54, 56, 58, 58, 58)
area <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
data <- data.frame(species_rich, area)

#Obtain starting values for theta, K, gamma_stars and J_stars

K <- 10 #will run the model with K value from 1 to maximum species richness
#but won't worry about this now

As <- data$area
rho <- 1
Js = As*rho #total number of individuals on each island 
J_stars = Js/K #number of individuals per niche on each island

m0 <- 0.0005 #baseline immigration rate
A0 <- 1
ms = m0*sqrt(A0)/sqrt(As) #starting value for immigration rate for each island using island area
#baseline immigration rate and A0
gamma_stars = J_stars*ms/(1-ms) #function ofaverage individuals per niche and immigration rate

theta <- 10 #this is how Ryan did it
#this is how I might do it, going by the equation in the paper
#but for now we won't worry about this

Samax <- as.numeric(data[which.max(data$area),][1]) #species richness on largest island
theta <- (Samax*gamma_stars*log(ms))/(Samax - gamma_stars*log(ms)*((Samax/gamma_stars*log(ms))*exp(Samax/gamma_stars*log(ms))))



#Define the model function

chisholm_model <- function(theta, K, J_stars, gamma_stars) { 
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K))) 
}


#Fit the model

fit_chisholm <- nlsLM(log(species_rich) ~ chisholm_model(theta, K, J_stars, gamma_stars), data,
                          list(theta = theta, K = K, J_stars = J_stars, gamma_stars = gamma_stars))

#Calculate the sum of squared errors to be minimised for each loop, changing the value of K from 1 to maximum species richness

RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
TSS <- sum((data$species_rich - mean(data$species_rich))^2) #Total sum of squares 
RSq <- 1 - (RSS/TSS) #R-squared value
