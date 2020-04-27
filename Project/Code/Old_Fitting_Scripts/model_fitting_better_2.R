rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("plyr")

#My dummy dataset

area <- 10^seq(log10(10^3),log10(10^5),length.out=20)
species_rich <- area/1000
data <- data.frame(species_rich, area)

a <- 0 #will be used for storing best fit results in the loop

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

for(i in 1:max(data$species_rich)) {

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
  
  if (RSq > a) {
    best_fit_results <- results
    best_plot_points <- points_plot
    a <- RSq 
  }
  
}


#generate a vector of areas to for plotting our model fit
Area <- seq(min(area),max(area),len=length(area))

#plot the most successful model fit with the data
plot(data$area, data$species_rich)
lines(Area, best_plot_points$species, col = 'blue', lwd = 2.5)
