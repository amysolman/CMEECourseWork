#Script to perform NLLS fitting on multiple archipelagos of Simulation data
#to try and retrieve the known parameters of migration rate, 
#niches and theta

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")
#install.packages("LambertW") <- if you've never installed LambertW before
#library("LambertW")

#Import Data
Data <- read.csv("../../../Results/Simulation2/MultiSimAnalyticData.csv")

#############################################################
#######################FUNCTION ONE##########################
#############################################################
#define the model function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0*sqrt(area) #change this from m0/sqrt(area) to m0*sqrt(area)??? 
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}


#############################################################
#######################FUNCTION TWO##########################
#############################################################
#function to find NLLS starting values 
get_my_starts <- function() {
  
  nu = 0.01
  m_start = nu*median(Data$area)/200
  m0_start = m_start/sqrt(median(Data$area))
  theta_start = median(Data$species)*6
  
  starts <- data.frame(nu, m_start, m0_start, theta_start)
  
  return(starts)
}

#############################################################
#######################FUNCTION THREE##########################
#############################################################
#function to perform NLLS fitting on each dataset and store best fit coefficients

NLLSfits <- function(Data) {
  
  starts <- get_my_starts() #get starting estimates
  
  this_result = 0 
  
  best_fit_and_k <- list()
  
  for (K in 1:ceiling(max(Data$species))) { #for num of niches from 1 to max number of species

    #fit the model
    fit_chisholm <- try(nlsLM(species ~ chisholm_model(area, theta, m0, K), data = Data2, 
                              start = list(theta = starts$theta_start, m0 = starts$m0_start), lower=c(0, 0), upper=c(Inf, 1)), silent = T)
    
    
    
    
    #Get the R-squared value of the fitting
    if(class(fit_chisholm) !="try-error"){
      RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((Data2$species - mean(Data2$species))^2) #Total sum of squares 
      RSq <- 1 - (RSS/TSS) #R-squared value
      
      #if this RSq value is higher than the last one, we store the results
      
      if (RSq >= this_result) {
        
        fit_store <- fit_chisholm
        this_result <- RSq
        best_k <- K
        
      }
    }
    
  }
  
  best_fit_and_k[[1]] <- fit_store
  best_fit_and_k[[2]] <- best_k
  
  return(best_fit_and_k)
}

#############################################################
#######################FUNCTION FOUR##########################
#############################################################
#function to generate plotting points from NLLS fitting data

get_my_points <- function(Data) {
  
  area <- Data$area
  chisholm_points <- chisholm_model(area = area, theta = a[[1]], m0 = a[[2]], K = niches)
  Data$chisholm_points <- chisholm_points
  Data$est_immigration = a[[2]]*sqrt(median(area))
  Data$est_theta = a[[1]]
  Data$est_K = niches
  Data$immigration_dif <- (Data$immigration - Data$est_immigration)
  Data$theta_dif <- (Data$theta - Data$est_theta)
  Data$K_dif <- (Data$niches - Data$est_K)
  
  return(Data)
  
}


#############################################################
#######################FUNCTION FIVE##########################
#############################################################
nlls_one_arch <- function(Data, num){
  
  Data2 <- Data[Data$arch_num == num, ] #subset data to one archipelago
  
  best_fit_and_k <- NLLSfits(Data = Data2)
  
  fit_store <- best_fit_and_k[[1]]
  niches <- best_fit_and_k[[2]]
  
  #Get the R-squared value of the fitting
  
  RSS <- sum(residuals(fit_store)^2) #Residual sum of squares of our NLLS model
  TSS <- sum((Data2$species - mean(Data2$species))^2) #Total sum of squares 
  RSq <- 1 - (RSS/TSS) #R-squared value
  
  #get the parameter estimates
  a <- (summary(fit_store))$coefficients[, 1]
  
  df <- get_my_points(Data = Data2)
  
  return(df)
}

arch = Data[Data$arch_num == 1, ]
plot(log(arch$area), arch$species)
