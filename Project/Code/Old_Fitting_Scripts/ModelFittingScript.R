# Amy Solman amy.solman19@imperial.ac.uk
# 2nd April 2020
# ModelFittingScript.R: Fitting biphasic SAR model as described by Ryan et al. 2016

rm(list=ls())
graphics.off()

install.packages("LambertW")
library("LambertW") #for using Lambert W function
library("minpack.lm") #for nonlinear model fitting to find best-fit starting values

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
chisholm_model <- function(O, K, j, y) { 
  return(O(digamma(O/K+y(digamma(y+j)-digamma(y)))-digamma(O/K))) 
}

#obtaining starting values K (niche diversity), O (fundamental biodiversity number),
# and m (immigration parameter)
#For each K between 1 and Smax, a least squares algorithm is used to find the best-fit values for m and O
K <- 5 #will create a loop to run through values of K, but defined as 5 here to test the formulas

Smax <- max(data$Species.Richness, na.rm = TRUE) #maximum species richness
J <- sum(data$Number.of.Individuals) #total number of individuals in the community
p <- J/(sum(data$Area)) #number of individuals per unit area
Amax <- max(data$Area) #maximum island area
Amed <- median(data$Area) #median island area
Samax <- as.numeric(data[which.max(data$Area),][1])#species richness on largest island
j <- J/K #number of individuals per niche

#starting value for immigration rate, why does this NaN?
m_start <- -(J/p*Amed*(W_1(-K/p*Amed))) 

#starting value for y (a function of average individuals per niche and immigration rate)
y_start <- (p*Amax - 1)*m_start/(1-m_start) 

#starting value for fundamental biodiversity number
O_start <- (Samax*y_start*log(m_start))/(Samax - y_start*log(m_start)*W_1((Samax/y_start*log(m_start))*exp(Samax/y_start*log(m_start)))) #fundamental biodiveristy number


#For each K, run a non-linear model fitting to find the best-fit values of m and O

#Select the m and O values for each K with the highest R^2 values




