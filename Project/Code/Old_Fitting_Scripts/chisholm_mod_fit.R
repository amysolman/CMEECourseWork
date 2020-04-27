rm(list=ls())
graphics.off()

#install nlls fitting package
library("minpack.lm") #for nlls fitting
#install.packages("preseqR")
library(preseqR) #for calculating fishers alpha
library("ggplot2")

#create a function object for the model
chisholm_model <- function(theta, K, J_stars, gamma_stars) { 
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K))) 
}

#import the data
#My dummy dataset
species_rich <- c(1, 1, 3, 4, 4, 6, 10, 15, 15, 19, 25, 31, 47, 56, 53, 54, 56, 58, 58, 58)
area <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
data <- data.frame(species_rich, area)

#define the starting values for model fitting
rho = 1 #number of individuals per unit area
theta = 200 #equivalent to fishers alpha, diversity index typically between 1 - 200

#example of how to calculate fisher's alpha
no_species <- c(2, 4, 6, 8, 10) #need to know how often specific species occur, so 2 species appeard 5 times
frequency <- c(5, 4, 3, 2, 1) #4 species recorded 4 times, 6 species recorded 8 times, 10 species recorded once
df <- data.frame(frequency, no_species)
theta <- fisher.alpha(df)

K = 10 #number of niches

#parameters A0 and m0 are used to define the area and immigration rate of some hypothetical reference island
#--essentially it defines one point on the m versus A curve
m0 = 0.0005 #immigration rate when island area is 1 (A0)
A0 = 1 #island area 

Js = data$area*rho #total number of individuals on each island 
J_stars = Js/K #number of individuals per niche on each island
ms = m0*sqrt(A0)/sqrt(data$area) #estimated immigration rate of each island
gamma_stars = J_stars*ms/(1-ms)

#plot area vs species
plot(data$area, data$species_rich) 

#fit a linear model
fit_lm <- lm(log(data$species_rich) ~ log(data$area))
curve(exp(coef(fit_lm)[1])*x^coef(fit_lm)[2], add=T, from=0, to=20, col='red', lwd=2)

#fit the model to the data using nlls
chisholm_fit <- nlsLM(species_rich ~ chisholm_model(theta, K, gamma_stars, J_stars), data = data, start = list(theta=theta, K=K, gamma_stars=gamma_stars, J_stars=J_stars))

#Calculate the sum of squared errors
RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
TSS <- sum((data$species_rich - mean(data$species_rich))^2) #Total sum of squares 
RSq <- 1 - (RSS/TSS) #R-squared value

#repeat nlls model fitting for each value of k from 1 to max species richness to find the K that produces highest R^2 value
#use these parameters to plot the data and the fitted model line

