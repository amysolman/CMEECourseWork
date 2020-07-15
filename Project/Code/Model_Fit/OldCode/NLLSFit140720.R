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
  Y = (((rho*Amax) - 1)*m)/(1-m)
  theta_start = (S*Y*log(m))/(S-Y*log(m)*W(((exp(S/(Y*log(m)))*S)/(Y*log(m))), branch=-1))
  
  # if (theta_start <= 0){ #is this right to include?
  #   theta_start = 20
  # }
  
  starts <- data.frame(m0_start, theta_start)
  
  return(starts)
}

#############################################################
#############FUNCTION THREE: THE FITTING#####################
#############################################################

#function for NLLS fitting

NLLSfits <- function(Data) {
  
  #create empty dataframe for storing results
  
  my_df <- data.frame(niches=numeric(0), RSq=numeric(0), m0=numeric(0), theta=numeric(0))
  
  #give value of rho for the fitting
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
      
      #get the parameter estimates
      a <- (summary(fit_chisholm))$coefficients[, 1]
      
      #get our parameters
      m0 = a[[2]]
      niches = K
      theta = a[[1]]
      
      #add the results to the dataframe
      new_df <- data.frame(niches, RSq, m0, theta)
      my_df <- rbind(my_df, new_df)
      
    }
      
  }
      
  
  return(my_df)
}

#################################################################
#############FUNCTION FOUR: THE MODEL POINTS#####################
#################################################################
#function to generate plotting points from NLLS fitting data
get_my_points <- function(Data, theta, m0, k) {
  
  area <- Data$area
  rho = Data$rho[[1]]
  chisholm_points <- chisholm_model(area = area, theta, m0, K = k, rho = rho)
  
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

for (ID in 1:length(unique(MyData$dataset_ID))){
  
  Data <- MyData[MyData$dataset_ID == ID, ]
  Data <- Data[c(4,3,5,33,34,35,21,22)]
  names(Data) <- c("author", "year", "title", "area", "species", "rho", "taxa", "archipelago")
  Data$rho <- Data$rho
  
  #3) Do the model fitting and extract the parameter estimates 
  fit_Results <- NLLSfits(Data = Data)
  best_fit_results <- fit_Results[which.max(fit_Results$RSq),]
  theta = best_fit_results$theta
  m0 = best_fit_results$m0
  k = best_fit_results$niches
  
  #4) Get the points for plotting
  df <- get_my_points(Data = Data, theta, m0, k)
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
  
  file_name = paste("../../Results/NLLSplot_", ID, ".pdf", sep="")
  pdf(file_name)
  print(p1)
  dev.off()
  
  #7) Save our parameters and fitting statistics
  
  parameters <- data.frame(ID, best_fit_results$RSq, ACrit, m0, k, theta, Data$taxa[[1]], Data$archipelago[[1]])
  names(parameters) <- c("ID", "R^2", "CriticalArea", "m0", "k", "theta", "taxa", "archipelago_type")
  parameters$`R^2` <- round(parameters$`R^2`, digits = 2)
  parameters$CriticalArea <- signif(parameters$CriticalArea, digits = 3)
  parameters$m0 <- signif(parameters$m0, digits = 3)
  parameters$theta <- round(parameters$theta, digits = 2)
  
  all_parameters[[ID]] <- parameters
}

final_parameters <- do.call("rbind", all_parameters)

write.csv(all_parameters, "../../Results/Plots/NLLSParameters.csv", row.names = FALSE)




