#script to fit Chisholm model to simulation

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
  Js = area*rho
  J_stars = Js/K
  ms = m0#per capital immigration rate
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#############################################################
#############FUNCTION TWO: STARTING VALUES###################
#############################################################
#function to find NLLS starting values 
get_my_starts <- function(K, Data) {
  
  rho = 1 #just for the simulation
  
  Amed = median(Data$area)
  m0_start = -(K/(rho*Amed*W(-K/(rho*Amed), branch=-1))) #estimation of the constant proportionality of immigration rate across all islands
  m0 = m0_start
  
  Amax = max(Data$area) #maximum area
  SAmax = Data[Data$area == Amax, ]$species #species on largest island
  S = SAmax 
  Y = (((rho*Amax) - 1)*m0)/(1-m0)
  theta_start = (S*Y*log(m0))/(S-Y*log(m0)*W(((exp(S/(Y*log(m0)))*S)/(Y*log(m0))), branch=-1))
  
  if (theta_start <= 0){
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
  
  my_df <- data.frame(niches=numeric(0), RSq=numeric(0), m0=numeric(0), theta=numeric(0))
  
  for (K in 1:ceiling(max(Data$species))) { #for num of niches from 1 to max number of species
    
    starts <- get_my_starts(K = K, Data = Data) #get starting estimates
    
    #fit the model
    fit_chisholm <- try(nlsLM(species ~ chisholm_model(area, theta, m0, K, rho = 1), data = Data, 
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
  
  ACrit <- (theta*(1-m0)*(exp(K/theta)-1))/(m0*rho*log(1/m0))
  
  return(ACrit)
}


##################################################
################DO THE FITTING####################
##################################################
my_df <- list()
RSqResults <- list()

for (j in 1:10){
  Data <- read.csv(paste0("../../../Data/MeanAnalyticClassic", j, ".csv"))
  
  #1) Do the model fitting and extract the parameter estimates 
  fit_Results <- NLLSfits(Data = Data) #do the fitting and store all results for K
  best_fit_results <- fit_Results[which.max(fit_Results$RSq),] #extract the best results
  theta = best_fit_results$theta
  m0 = best_fit_results$m0
  K = best_fit_results$niches
  
  #calculate adjusted r-squared
  RSq = best_fit_results$RSq #Rsquared
  N = nrow(Data) #number of datapoints
  IndReg = 4 #number of independent regressors/num variables in the model
  RSqAdj = 1-(((1-RSq)*(N-1))/(N-IndReg-1))
  RSqResults[[j]] <- cbind(j, RSq, RSqAdj)
  
  #put the estimated parameters into a dataframe
  m0_results <- data.frame("m0", Data$m0_true[[1]], m0)
  colnames(m0_results) <- c("Parameter", "True", "Estimated")
  K_results <- data.frame("K", Data$K_true[[1]], K)
  colnames(K_results) <- c("Parameter", "True", "Estimated")
  theta_results <- data.frame("theta", Data$theta_true[[1]], theta)
  colnames(theta_results) <- c("Parameter", "True", "Estimated")
  my_df[[j]] <- rbind(m0_results, K_results, theta_results)
  
  #2) Get the points for plotting and bind with sim data
  Area <- Data$area
  rho = 1
  chisholm_points <- chisholm_model(Area, theta, m0, K, rho)
  plot_species <- c(Data$species, chisholm_points)
  plot_areas <- c(Data$area, Area)
  categories <- rep(c("Simulation", "NLLS"), each=length(plot_areas)/2)
  df <- cbind.data.frame(plot_areas, plot_species, categories)
  
  #3) Get the critical area
  ACrit <- CriticalArea(theta, m0, K, rho)
  
  
  #4) Plot fitted results 
  
  p1 <- ggplot(df, aes(x=plot_areas, y=plot_species, group=categories))+
    geom_point(data = df[df$categories == "Simulation",], aes(x=plot_areas, y=plot_species), colour = "black", size = 5)+
    scale_x_log10()+
    geom_line(data = df[df$categories == "NLLS",], aes(x=plot_areas, y=plot_species), colour = "blue")+
    xlab(paste("log(area)")) +
    ylab(paste("species")) +
    geom_vline(xintercept = ACrit, linetype="dotted",
               color = "red", size=5)+
    theme(
      plot.title = element_blank(),
      axis.title.x = element_text(size=30, face="bold"),
      axis.title.y = element_text(size=30, face="bold"),
      axis.text.x = element_text(size=30, face="bold"),
      axis.text.y = element_text(size=30, face="bold"),
      # Remove panel border
      panel.border = element_blank(),  
      # Remove panel grid lines
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      # Remove panel background
      panel.background = element_blank(),
      # Add axis line
      axis.line = element_line(colour = "grey"),
      legend.title = element_blank()
    )
  
  
  file_name = paste0("../../../Results/Simulation/NLLSPlotClassic", j, ".pdf")
  pdf(file_name)
  print(p1)
  dev.off()
  
}

my_final_dfs <- do.call("rbind", my_df)
theta_results <- my_final_dfs[my_final_dfs$Parameter == "theta", ]
theta_results$Difference <- theta_results$Estimated - theta_results$True

theta_mean_dif <- mean(theta_results$Difference)
m0_results <- my_final_dfs[my_final_dfs$Parameter == "m0", ]
m0_results$Difference <- m0_results$Estimated - m0_results$True
m0_mean_dif <- mean(m0_results$Difference)
K_results <- my_final_dfs[my_final_dfs$Parameter == "K", ]
K_results$Difference <- K_results$Estimated - K_results$True
K_mean_dif <- mean(K_results$Difference)

final_RSq <- do.call("rbind", RSqResults)
meanRSq <- mean(final_RSq[,2])
meanRSqAdj <- mean(final_RSq[,3])

Parameters <- c("theta", "m0", "K")
T_theta <- mean(theta_results$True)
E_theta <- mean(theta_results$Estimated)
T_m0 <- mean(m0_results$True)
E_m0 <- mean(m0_results$Estimated)
T_K <- mean(K_results$True)
E_K <- mean(K_results$Estimated)
True <- c(T_theta, T_m0, T_K)
Estimated <- c(E_theta, E_m0, E_K)
my_df <- data.frame(Parameters, True, Estimated)
my_df$Difference <- my_df$Estimated - my_df$True
my_df$True <- round(my_df$True, digits = 3)
my_df$Estimated <- round(my_df$Estimated, digits = 3)
my_df$Difference <- round(my_df$Difference, digits = 3)

#export as csv
write.csv(my_df, "../../../FinalReport/ClassicParam.csv", row.names = FALSE, quote = FALSE)

p1 <- ggplot(theta_results, aes(x=True, y=Estimated))+
  geom_point(size = 2.5)+
  geom_abline(intercept = 0, slope = 1, size = 1.5)+
  theme(
    plot.title = element_blank(),
    axis.title.x = element_text(size=30, face="bold"),
    axis.title.y = element_text(size=30, face="bold"),
    axis.text.x = element_text(size=30, face="bold"),
    axis.text.y = element_text(size=30, face="bold"),
    # Remove panel border
    panel.border = element_blank(),  
    # Remove panel grid lines
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Remove panel background
    panel.background = element_blank(),
    # Add axis line
    axis.line = element_line(colour = "grey")
  )

p2 <- ggplot(m0_results, aes(x=True, y=Estimated))+
  geom_point(size=2.5)+
  geom_abline(intercept = 0, slope = 1, size=1.5)+
  theme(
    plot.title = element_blank(),
    axis.title.x = element_text(size=30, face="bold"),
    axis.title.y = element_text(size=30, face="bold"),
    axis.text.x = element_text(size=30, face="bold"),
    axis.text.y = element_text(size=30, face="bold"),
    # Remove panel border
    panel.border = element_blank(),  
    # Remove panel grid lines
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Remove panel background
    panel.background = element_blank(),
    # Add axis line
    axis.line = element_line(colour = "grey")
  )

p3 <- ggplot(K_results, aes(x=True, y=Estimated))+
  geom_point(size=2.5)+
  geom_abline(intercept = 0, slope = 1, size=1.5)+
  theme(
    plot.title = element_blank(),
    axis.title.x = element_text(size=30, face="bold"),
    axis.title.y = element_text(size=30, face="bold"),
    axis.text.x = element_text(size=30, face="bold"),
    axis.text.y = element_text(size=30, face="bold"),
    # Remove panel border
    panel.border = element_blank(),  
    # Remove panel grid lines
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # Remove panel background
    panel.background = element_blank(),
    # Add axis line
    axis.line = element_line(colour = "grey")
  )

pdf("../../../FinalReport/AreaThetaResults.pdf")
print(p1)
dev.off()

pdf("../../../FinalReport/Aream0Results.pdf")
print(p2)
dev.off()

pdf("../../../FinalReport/AreaKResults.pdf")
print(p3)
dev.off()

#############is the difference between the paired values normally distributed?

shapiro.test(theta_results$Difference) #normally distributed

shapiro.test(m0_results$Difference) #not normally distributed

shapiro.test(K_results$Difference) #normally distributed

#####Becuase the data are (almost) normally distributed we can
#perform a paired sample t-test to see how different these results are

t.test(theta_results$True, theta_results$Estimated, paired = TRUE, alternative = "two.sided") #results are significantly different

wilcox.test(theta_results$True, theta_results$Estimated, paired = TRUE, alternative = "two.sided")

t.test(m0_results$True, m0_results$Estimated, paired = TRUE, alternative = "two.sided") #results not significantly different

wilcox.test(m0_results$True, m0_results$Estimated, paired = TRUE, alternative = "two.sided")

t.test(K_results$True, K_results$Estimated, paired = TRUE, alternative = "two.sided") #results not significantly different

wilcox.test(K_results$True, K_results$Estimated, paired = TRUE, alternative = "two.sided")
