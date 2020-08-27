#script to fit Chisholm model to simulation

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")
#install.packages("LambertW") <- if you've never installed LambertW before
library("LambertW") #<- estimating starting parameters
library(lamW) #<- for critical area formula

#1) Read in the full data set
MyData <- read.csv("../../Data/DataEdit.csv")

#######################################################
#############FUNCTION ONE: THE MODEL###################
#######################################################

#define the model function
chisholm_model <- function(area, theta, m0, K, rho) { 
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area) #per capital immigration rate
  gamma_stars = J_stars*ms/(1-ms)
  
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#############################################################
#############FUNCTION TWO: STARTING VALUES###################
#############################################################
#function to find NLLS starting values 
get_my_starts <- function(K, Data) {
  
  rho = round(Data$rho[[1]])
  
  Amed = median(Data$area)
  m0_start = -(K/(rho*Amed*W(-K/(rho*Amed), branch=-1))) #estimation of the constant proportionality of immigration rate across all islands
  m0 = m0_start
  
  Amax = max(Data$area) #maximum area
  SAmax = Data[Data$area == Amax, ]$species #species on largest island
  SAmax = round(mean(SAmax)) #this finds mean species if there are several islands with the same size
  S = SAmax 
  Y = (((rho*Amax) - 1)*m0)/(1-m0)
  theta_start = (S*Y*log(m0))/(S-Y*log(m0)*W(((exp(S/(Y*log(m0)))*S)/(Y*log(m0))), branch=-1))
  
  if (theta_start <= 0 || theta_start > 1000000 || theta_start == "NaN"){
    theta_start = 20
  }
  
  starts <- data.frame(m0_start, theta_start)
  
  return(starts)
}

#############################################################
#############FUNCTION THREE: THE FITTING#####################
#############################################################

#function for NLLS fitting

NLLSfits <- function(Data) {
  
  #create empty dataframe for storing results
  
  my_df <- data.frame(niches=numeric(0), RSq=numeric(0), AdjRSq=numeric(0), m0=numeric(0), theta=numeric(0))
  
  for (K in 1:ceiling(max(Data$species))) { #for num of niches from 1 to max number of species
    
    starts <- get_my_starts(K = K, Data = Data) #get starting estimates
    
    #fit the model
    fit_chisholm <- try(nlsLM(species ~ chisholm_model(area, theta, m0, K, rho = round(Data$rho[[1]])), data = Data, 
                              start = list(theta = starts$theta_start, m0 = starts$m0_start), lower=c(0, 0), upper=c(Inf, 1)), silent = T)
    
    
    #Get the R-squared value of the fitting
    if(class(fit_chisholm) !="try-error"){
      RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((Data$species - mean(Data$species))^2) #Total sum of squares 
      RSq <- 1 - (RSS/TSS) #R-squared value
      
      #get our parameters
      niches = K
      m0 = coef(fit_chisholm)["m0"]
      theta = coef(fit_chisholm)["theta"]
      
      #confint(fit_chisholm) <- for confidence intervals
      
      #add the results to the dataframe
      new_df <- data.frame(niches, RSq, m0, theta)
      my_df <- rbind(my_df, new_df)
      
    }
    
  }
  
  
  return(my_df)
}

#################################################################
#############FUNCTION FOUR: CRITICAL AREA#####################
#################################################################
CriticalArea <- function(theta, m0, K, rho){
  
  #Let's get our critical area for regime transition
  x = theta*(exp(K/theta)-1)/(m0*rho)
  ACrit = (x/lambertW0(x/m0))^2
  
  return(ACrit)
}

#######################################################
######FUNCTION SIX: THE POWER LAW MODEL################
#######################################################

powMod <- function(x, c, z) {
  return(c * x^z)
}

##################################################
################DO THE FITTING####################
##################################################

#list for storing results

results_list <- list()
Pow_results_list <- list()

for (i in 1:length(unique(MyData$datasetID))){
  
  #subset data
  Data <- MyData[MyData$datasetID == i, ]
  Data <- Data[-c(38:40)] #remove the log(area) and spearmans coefficient columns
  #for some reason this interfers with the NLLS fitting
  
  #1) Do the model fitting and extract the parameter estimates 
  fit_Results <- NLLSfits(Data = Data) #do the fitting and store all results for K
  best_fit_results <- fit_Results[which.max(fit_Results$RSq),] #extract the best results
  theta_best = best_fit_results$theta
  m0_best = best_fit_results$m0
  K_best = best_fit_results$niches
  
  #DO POWER-LAW FITTING
  PowFit <- nlsLM(species ~ powMod(area, c, z), data = Data, start = list(c = .1, z = .1))
  
  #2) Get the points for plotting and bind with sim data
  Area <- Data$area
  rho = round(Data$rho[[1]])
  chisholm_points <- chisholm_model(Area, theta_best, m0_best, K_best, rho)
  PowFit_points <- powMod(Area,coef(PowFit)["c"],coef(PowFit)["z"])
  plot_species <- c(Data$species, chisholm_points, PowFit_points)
  plot_areas <- c(Data$area, Area, Area)
  categories <- rep(c("Dataset", "NLLS", "Power"), each=length(plot_areas)/3)
  df <- cbind.data.frame(plot_areas, plot_species, categories)
  
  #3) Get the critical area
  ACrit <- CriticalArea(theta_best, m0_best, K_best, rho)
  
  #4) Plot fitted results 
  p <- ggplot(df, aes(x=plot_areas, y=plot_species, group=categories))+
    geom_point(data=df[df$categories == "Dataset",])+
    scale_x_log10()+
    geom_smooth(data=df[df$categories == "NLLS",], method='lm',formula=y ~ poly(x, 3),se=F)+
    geom_smooth(data=df[df$categories == "Power",], color="green", method='lm',formula=y ~ poly(x, 3),se=F)+
    xlab(paste("log(area)")) +
    ylab(paste("species")) +
    geom_vline(xintercept = ACrit, linetype="dotted",
               color = "red", size=3)+
    theme(
      plot.title = element_blank(),
      axis.title.x = element_text(size=20, face="bold"),
      axis.title.y = element_text(size=20, face="bold"),
      axis.text.x = element_text(size=20, face="bold"),
      axis.text.y = element_text(size=20, face="bold"),
      # Remove panel border
      panel.border = element_blank(),  
      # Remove panel grid lines
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      # Remove panel background
      panel.background = element_blank(),
      # Add axis line
      axis.line = element_line(colour = "grey"),
      legend.title = element_blank(),
      legend.position = "none")
  
  #export plot
  file_name = paste0("../../Results/PeriNLLSPlot", i, ".pdf")
  pdf(file_name)
  print(p)
  dev.off()
  
  #calculate adjusted r-squared
    RSq = best_fit_results$RSq #Rsquared
    N = nrow(Data) #number of datapoints
    IndReg = 4 #number of independent regressors/num variables in the model
    RSqAdj = 1-(((1-RSq)*(N-1))/(N-IndReg-1))
    
    #Calculate Rsquared scores for the power fit 
    PowRSS <- sum(residuals(PowFit)^2) #Residual sum of squares of our NLLS model
    PowTSS <- sum((Data$species - mean(Data$species))^2) #Total sum of squares 
    PowRSq <- 1 - (PowRSS/PowTSS) #R-squared value
    PowRSqAdj = 1-(((1-PowRSq)*(N-1))/(N-IndReg-1))
    
    #get power model coefficient values
    Pow_c <- coef(PowFit)["c"]
    Pow_z <- coef(PowFit)["z"]
    
    #calculate AIC by rerunning the nlls fit with best fit K
    starts <- get_my_starts(K = K_best, Data = Data) #get starting estimates
    #fit the model
    fit_chisholm <- try(nlsLM(species ~ chisholm_model(area, theta, m0, K_best, rho = round(Data$rho[[1]])), data = Data, 
                              start = list(theta = starts$theta_start, m0 = starts$m0_start), lower=c(0, 0), upper=c(Inf, Inf)), silent = T)
    
    AIC_score <- AIC(PowFit) - AIC(fit_chisholm)
    
    
    #area range of dataset
  area_range <- range(Data$area)
  area_range <- paste(area_range[1], "-", area_range[2])
  
  
  #save results to table
  
  results_df <- data.frame(Data$studyID[[1]], Data$datasetID[[1]], Data$year[[1]], 
                           Data$author[[1]], Data$title[[1]], Data$aqua_terra[[1]], Data$fresh_saline[[1]],
                           Data$in_situ_lab[[1]], Data$taxa[[1]], Data$archipelago_type[[1]], 
                           Data$expanded_archipelago_type[[1]], N, area_range, RSq, RSqAdj, theta_best, K_best, m0_best, Data$rho[[1]], as.numeric(ACrit))
  
  results_list[[i]] <- results_df
  
  Pow_results_df <- data.frame(Data$studyID[[1]], Data$datasetID[[1]], Data$year[[1]], 
                               Data$author[[1]], Data$title[[1]], Data$aqua_terra[[1]], Data$fresh_saline[[1]],
                               Data$in_situ_lab[[1]], Data$taxa[[1]], Data$archipelago_type[[1]], 
                               Data$expanded_archipelago_type[[1]], N, area_range, PowRSq, PowRSqAdj, Pow_z, Pow_c, AIC_score) 
  
  Pow_results_list[[i]] <- Pow_results_df
  
  
}

#bind final results into table

final_results <- do.call("rbind", results_list)

colnames(final_results) <- c("StudyID", "DataID", "Year", "Author", "Title", "Aquatic_Terrestrial",
                             "Fresh_Saline", "In_Situ_Lab", "Taxa", "Archipelago_Type",
                             "Expanded_Archipelago_Type", "Num_Data_Points", "Area_Range (cm2)", "RSq", "RSqAdj", "Theta", "K", "m0", "rho", "CriticalArea")
final_results$RSq <- format(round(final_results$RSq, 2), nsmall = 2)
final_results$RSqAdj <- format(round(final_results$RSqAdj, 2), nsmall = 2)
final_results$Theta <- format(round(final_results$Theta, 2), nsmall = 2)
final_results$K <- format(round(final_results$K, 2), nsmall = 2)
final_results$m0 <- signif(final_results$m0, 3)
final_results$rho <- round(final_results$rho)

#if critical area is a real number, round to 2 decimal places
for (j in 1:nrow(final_results)){
  if (is.numeric(final_results$CriticalArea[j]) == TRUE){
    final_results$CriticalArea[[j]] <- format(round(final_results$CriticalArea[[j]], 2), nsmall = 2)
  }
}

#add critical area to original data table to visually compare with areas
CriticalAreas <- list()
for (i in 1:length(unique(MyData$datasetID))){
  this_data <- MyData[MyData$datasetID == i, ]
  CriticalA <- final_results[i,]$CriticalArea
  CriticalAreas[[i]] <- rep(CriticalA, nrow(this_data))
}
CriticalAs <- unlist(CriticalAreas)
MyData$CriticalAreas <- CriticalAs

#bind power fit results
Pow_final_results <- do.call("rbind", Pow_results_list)

colnames(Pow_final_results) <- c("StudyID", "DataID", "Year", "Author", "Title", "Aquatic_Terrestrial",
                                 "Fresh_Saline", "In_Situ_Lab", "Taxa", "Archipelago_Type",
                                 "Expanded_Archipelago_Type", "Num_Data_Points", "Area_Range (cm2)", "RSq", "RSqAdj", "Z", "C", "AIC")

#export results for statistical analysis

write.csv(MyData, "../../Data/PeriACrit.csv")
write.csv(final_results, "../../Results/PeriNLLSResults.csv", row.names = FALSE)
write.csv(Pow_final_results, "../../Results/PeriPowResults.csv", row.names = FALSE)




