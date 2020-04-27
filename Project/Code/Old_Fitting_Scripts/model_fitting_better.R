rm(list=ls())
graphics.off()

#install nlls fitting package
library("minpack.lm") #for nlls fitting

#My dummy dataset
species_rich <- c(1, 1, 3, 4, 4, 6, 10, 15, 15, 19, 25, 31, 47, 56, 53, 54, 56, 58, 58, 58)
area <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
data <- data.frame(species_rich, area)

#or import your data
data <- read.csv('../Data/Bell2005.csv')

#remove NA values
data<-data[complete.cases(data$Number.of.Species),]

species_rich <- data$Number.of.Species
area <- data$Size.of.Island

#define the function
chisholm_model <- function(area, theta, m0) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#Loop through the model fitting, with niche values (K) from 1 to maximum species richness
#recorded on an 'island'
#calculate R^2 value and store best parameter results

for(i in 1:max(species_rich)) {
  
  K <- i
  
  chisholm_fit <- nlsLM(species_rich ~ chisholm_model(area, theta, m0), data = data, start = list(theta = 200, m0 = 0.0005))
  
  #Calculate the sum of squared errors
  RSS <- sum(residuals(chisholm_fit)^2) #Residual sum of squares of our NLLS model
  TSS <- sum((data$species_rich - mean(data$species_rich))^2) #Total sum of squares 
  RSq <- 1 - (RSS/TSS) #R-squared value
  
  #store these results
  results <- data.frame(RSq, coef(chisholm_fit)["theta"], coef(chisholm_fit)["m0"])
  names(results) <- c("R-Squared", "Theta", "Immigration")
  
  species <- chisholm_model(area = area, theta = coef(chisholm_fit)["theta"], m0 = coef(chisholm_fit)["m0"])
  points_plot <- data.frame(area, species)
  
#if the new RSq value is greater than the previous RSq value, store the results 
  
  a <- 0
  
  if (RSq > a) {
    fit_results <- results
    plot_points <- points_plot
    a <- RSq 
  }
  
}


#generate a vector of areas to for plotting our model fit
Area <- seq(min(area),max(area),len=length(area))

#plot the most successful model fit with the data
plot(area, species_rich)
lines(Area, points_plot$species, col = 'blue', lwd = 2.5)
