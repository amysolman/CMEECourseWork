#Script to perform NLLS fitting on one archipelago of Simulation data
#to try and retrieve the known parameters of migration rate, 
#niches and theta

#BE AWARE OF THE SLIGHT CHANGE TO THE MODEL IN REGARDS TO M RATE

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")
#install.packages("LambertW") <- if you've never installed LambertW before
#library("LambertW")

#Import Data
Data <- read.csv("../../../Results/Simulation2/SimAnalyticData.csv")

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

#fit chisholm model using nlls fitting

#function to find NLLS starting values 
get_my_starts <- function() {
  
  nu = 0.01
  m_start = nu*median(Data$area)/200
  m0_start = m_start/sqrt(median(Data$area))
  theta_start = median(Data$species)*6
  
  starts <- data.frame(nu, m_start, m0_start, theta_start)
  
  return(starts)
}

Data2 <- Data[Data$SimOrAnalytic == "simulation", ] #subset data to just simulation

#function to perform NLLS fitting on each dataset and store best fit coefficients

NLLSfits <- function() {
  
  starts <- get_my_starts() #get starting estimates
  
  this_result = 0 
  
  best_fit_and_k <- list()
  
  for (K in 1:ceiling(max(Data2$species))) { #for num of niches from 1 to max number of species
    
    
    # #an atempt at finding starting values
    # m_start = K/(1*median(Data2$area)*W(-K/1*(median(Data2$area)), branch = -1))
    # gamma_start = (1*max(Data2$area - 1))*m_start/(1 - m_start)
    # 
    # #species richness on largest island
    # Largest_Island = Data2[Data2$area == max(Data2$area), ]
    # SAmax = Largest_Island$species #found the mean here because we had two island of the same size
    # 
    # theta_start = SAmax*gamma_start*log(m_start)/SAmax - gamma_start* log(m_start)*W((SAmax/gamma_start*log(m_start)*exp(SAmax/gamma_start*log(m_start))), branch = -1)
    
    #fit the model
    fit_chisholm <- try(nlsLM(species ~ chisholm_model(area, theta, m0, K), data = Data2, 
                              start = list(theta = starts$theta_start, m0 = starts$m0_start)), silent = T)
    
    
    
    
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


best_fit_and_k <- NLLSfits()

fit_store <- best_fit_and_k[[1]]
niches <- best_fit_and_k[[2]]

#Get the R-squared value of the fitting

RSS <- sum(residuals(fit_store)^2) #Residual sum of squares of our NLLS model
TSS <- sum((Data2$species - mean(Data2$species))^2) #Total sum of squares 
RSq <- 1 - (RSS/TSS) #R-squared value

#get the parameter estimates
a <- (summary(fit_store))$coefficients[, 1]


#function to generate plotting points from NLLS fitting data

get_my_points <- function() {
  
  area <- Data2$area
  chisholm_points <- chisholm_model(area = area, theta = a[[1]], m0 = a[[2]], K = niches)
  
  
  #merge NLLS points into dataframe with simulation and analytic results
  migration = a[[2]]*sqrt(median(area))
  df <- data.frame(area, chisholm_points, migration, K = niches, a[[1]])
  df <- round(df, 5)
  df$SimOrAnalytic <- "NLLS"
  names(df) <- c("area", "species", "migration", "niches", "theta", "SimAnalyticNLLS")
  colnames(Data)[7] <- "SimAnalyticNLLS"
  Data <- Data[, -c(1)]
  Data <- rbind(Data, df)

  return(Data)
  
}

Data <- get_my_points()

#Let's get our parameters

m = a[[2]]*sqrt(median(Data$area))
k = niches
theta = a[[1]]

#Let's get our critical area for regime transition
ACrit <- theta*(1-m)*(exp(k/theta)-1)/m*1*log(1/m)

#plot simulation, analytic and NLLS results
  p1 <- ggplot(Data, aes(x = area, y = species, group = SimAnalyticNLLS)) +
    scale_x_log10() +
    xlab("log(area)")+
    geom_point(aes(colour = SimAnalyticNLLS)) +
    geom_line(aes(colour = SimAnalyticNLLS)) + 
    annotate(geom="text", x=150, y=250, label="NLLS Results",
             color="red") +
    annotate(geom="text", x=100, y=230, label="R^2:",
             color="red") +
    annotate(geom="text", x=200, y=230, label=c(round(RSq, 2)),
             color="red") +
    annotate(geom="text", x=100, y=210, label="m_rate:",
             color="red") +
    annotate(geom="text", x=200, y=210, label=c(round(m, 2)),
             color="red") +
    annotate(geom="text", x=100, y=190, label="niches:",
             color="red") +
    annotate(geom="text", x=200, y=190, label=c(round(k, 2)),
             color="red") +
    annotate(geom="text", x=80, y=170, label="theta:",
             color="red") +
    annotate(geom="text", x=250, y=170, label=c(round(theta, 2)),
             color="red") +
    annotate(geom="text", x=100, y=150, label="ACrit:",
             color="red") +
    annotate(geom="text", x=270, y=150, label=c(round(ACrit, 2)),
             color="red") +
    geom_vline(xintercept = ACrit, linetype="dotted", 
               color = "red", size=1.5) +
    theme_bw()
  
pdf("../../Results/Simulation2/NLLS/SimAnalyticNLLSfit_changed.pdf")
print(p1)
dev.off()

#let's export our parameter estimations
parameters <- cbind.data.frame(m, niches, theta)
write.csv(parameters, "../../Results/Simulation2/parameters_changed.csv", row.names = FALSE)
