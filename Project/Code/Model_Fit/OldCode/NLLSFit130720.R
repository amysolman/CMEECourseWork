#script to fit Chisholm model to datasets with 
#area metric (see other scripts for those with volume/distance metrics)

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")
#install.packages("LambertW") <- if you've never installed LambertW before
library("LambertW")

#######################################################
#############FUNCTION ONE: THE MODEL###################
#######################################################

#define the model function
chisholm_model <- function(area, theta, m0, K, rho) {
  rho = rho
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area) 
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#############################################################
#############FUNCTION TWO: STARTING VALUES###################
#############################################################
#function to find NLLS starting values 
get_my_starts <- function(K, Data) {
  rho = Data$rho[[1]]
  Amed = median(Data$area)
  m0_start = -(K/(rho*Amed*W(-K/(rho*Amed), branch=-1)))
  m = m0_start
  Amax = max(Data$area)
  SAmax = Data[Data$area == Amax, ]$species
  S = SAmax
  Y = (rho*Amax - 1)*m/(1-m)
  theta_start = (S*Y*log(m))/(S-Y*log(m)*W(((exp(S/(Y*log(m)))*S)/(Y*log(m))), branch=-1))
  starts <- data.frame(m0_start, theta_start)
  
  return(starts)
}

#############################################################
#############FUNCTION THREE: THE FITTING#####################
#############################################################

#function for NLLS fitting

NLLSfits <- function(Data) {
  
  this_result = 0 
  
  best_fit_and_k <- list()
  
  rho = Data$rho[[1]]
  
  for (K in 1:ceiling(max(Data$species))) { #for num of niches from 1 to max number of species
    
    starts <- get_my_starts(K = K, Data = Data) #get starting estimates
    
    #fit the model
    fit_chisholm <- try(nlsLM(species ~ chisholm_model(area, theta, m0, K, rho), data = Data, 
                              start = list(theta = starts$theta_start, m0 = starts$m0_start), lower=c(0, 0), upper=c(Inf, 1)), silent = T)
    
    
    
    
    #Get the R-squared value of the fitting
    if(class(fit_chisholm) !="try-error"){
      RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((Data$species - mean(Data$species))^2) #Total sum of squares 
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

#################################################################
#############FUNCTION FOUR: THE MODEL POINTS#####################
#################################################################
#function to generate plotting points from NLLS fitting data
get_my_points <- function(Data, a) {
  
  area <- Data$area
  rho = Data$rho[[1]]
  chisholm_points <- chisholm_model(area = area, theta = a[[1]], m0 = a[[2]], K = niches, rho = rho)
  
  #NLLS points into dataframe
  df <- data.frame(area, chisholm_points)
  df <- round(df, 5)
  names(df) <- c("area", "species")
  return(df)
  
}

#################################################################
#############FUNCTION FIVE: CRITICAL AREA#####################
#################################################################
CriticalArea <- function(theta, m0, k, rho){
  
  #Let's get our critical area for regime transition
  
  ACrit <- (theta*(1-m0)*(exp(k/theta)-1))/(m0*rho*log(1/m0))
  
  return(ACrit)
}

##################################################
################DO THE FITTING####################
##################################################

#1) Read in the full data set
MyData <- read.csv("../../Data/MyData.csv")

#list for our parameters results 

all_parameters <- list()

#2) loop through datasets

for (datasetID in 1:length(unique(MyData$dataset_ID))){
  
  Data <- MyData[MyData$dataset_ID == datasetID, ]
  Data <- Data[c(4,3,5,38,39,40)]
  names(Data) <- c("author", "year", "title", "area", "species", "rho")
  Data$rho <- Data$rho
  
  #3) Do the model fitting and extract the parameter estimates 
  best_fit_and_k <- NLLSfits(Data = Data)
  fit_store <- best_fit_and_k[[1]]
  niches <- best_fit_and_k[[2]]
  
  #Get the R-squared value of the fitting
  RSS <- sum(residuals(fit_store)^2) #Residual sum of squares of our NLLS model
  TSS <- sum((Data$species - mean(Data$species))^2) #Total sum of squares 
  RSq <- 1 - (RSS/TSS) #R-squared value
  
  #get the parameter estimates
  a <- (summary(fit_store))$coefficients[, 1]
  
  #get our parameters
  m0 = a[[2]]
  k = niches
  theta = a[[1]]
  
  #4) Get the points for plotting
  df <- get_my_points(Data = Data, a = a)
  Data$chisholm_points <- df$species
  
  #5) Get the critical area
  ACrit <- CriticalArea(theta, m0, k, rho = Data$rho[[1]])
  
  #6) Plot the true data points, the nlls fit data points and the critical area and save
  author = paste(as.character(Data$author[1]), as.character(Data$year[1]))
  
  p1 <-ggplot(Data, aes(x=area)) +
    scale_x_log10()+
    geom_point(aes(y = species), color = "darkred") +
    geom_point(aes(y = chisholm_points), color="steelblue")+
    ggtitle(paste(author, substr(Data$title, start = 1, stop = 45), "...")) +
    xlab(paste("log(area cm2)")) +
    ylab(paste("OTUs")) +
    geom_vline(xintercept = ACrit, linetype="dotted",
               color = "red", size=1.5)+
    theme_bw()
  
  file_name = paste("../../Results/NLLSplot_", datasetID, ".pdf", sep="")
  pdf(file_name)
  print(p1)
  dev.off()
  
  #7) Save our parameters and fitting statistics
  
  parameters <- data.frame(datasetID, RSq, ACrit, m0, m, k, theta)
  names(parameters) <- c("ID", "R^2", "CriticalArea", "m0", "m_rate", "k", "theta")
  parameters$`R^2` <- round(parameters$`R^2`, digits = 2)
  parameters$CriticalArea <- signif(parameters$CriticalArea, digits = 3)
  parameters$m0 <- signif(parameters$m0, digits = 3)
  parameters$m_rate <- signif(parameters$m_rate, digits = 3)
  parameters$theta <- round(parameters$theta, digits = 2)
  
  all_parameters[[datasetID]] <- parameters
}

final_parameters <- do.call("rbind", all_parameters)

write.csv(all_parameters, "../../Results/Plots/NLLSParameters.csv", row.names = FALSE)




