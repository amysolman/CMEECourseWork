#script to fit Chisholm model to datasets with 
#area metric (see other scripts for those with volume/distance metrics)

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")

#read in data 

MyData <- read.csv("../../Data/TotalData.csv")

#this gives us the datasets that have volume data only
MyVolumeData <- MyData[!is.na(MyData$volume.metric),]
MyVolumeData <- MyVolumeData[is.na(MyVolumeData$area.metric),]

#define the model function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area) #change this from m0/sqrt(area) to m0*sqrt(area)??? 
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}


#function to find NLLS starting values 
get_my_starts <- function() {
  
  nu = 0.01
  m_start = nu*median(Data$volume)/200
  m0_start = m_start/sqrt(median(Data$volume))
  theta_start = median(Data$sp.rich)
  
  starts <- data.frame(nu, m_start, m0_start, theta_start)
  
  return(starts)
}

#function for NLLS fitting

NLLSfits <- function() {
  
  starts <- get_my_starts() #get starting estimates
  
  this_result = 0 
  
  best_fit_and_k <- list()
  
  for (K in 1:ceiling(max(Data$sp.rich))) { #for num of niches from 1 to max number of species
    
    #fit the model
    fit_chisholm <- try(nlsLM(sp.rich ~ chisholm_model(area = volume, theta, m0, K), data = Data, 
                              start = list(theta = starts$theta_start, m0 = starts$m0_start), lower=c(0, 0), upper=c(Inf, 1)), silent = T)
    
    
    
    
    #Get the R-squared value of the fitting
    if(class(fit_chisholm) !="try-error"){
      RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((Data$sp.rich - mean(Data$sp.rich))^2) #Total sum of squares 
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

#function to generate plotting points from NLLS fitting data

get_my_points <- function() {
  
  volume <- Data$volume
  chisholm_points <- chisholm_model(area = volume, theta = a[[1]], m0 = a[[2]], K = niches)
  
  #NLLS points into dataframe
  df <- data.frame(volume, chisholm_points)
  df <- round(df, 5)
  names(df) <- c("volume", "species")
  return(df)
  
}

all_parameters <- data.frame(ID = numeric(0), RSquared = numeric(0), criticalvolume = numeric(0),
                             m0 = numeric(0), mrate = numeric(0), k = numeric(0), theta=numeric(0))
names(all_parameters) <- c("ID", "R^2", "CriticalVolume", "m0", "m_rate", "k", "theta")


#subset data by ID and run NLLS fitting


for (i in 1:length(unique(MyVolumeData$ID))) {
  
  ID <- unique(MyVolumeData$ID)[i] #get the ID
  
  Data<-MyVolumeData[which(MyVolumeData$ID==ID),]
  
  #should I do the fitting before or after log scaling the data?
  best_fit_and_k <- try(NLLSfits(), silent = T)
  
  if(class(best_fit_and_k) !="try-error"){
    
    fit_store <- best_fit_and_k[[1]]
    niches <- best_fit_and_k[[2]]
    
    #Get the R-squared value of the fitting
    
    RSS <- sum(residuals(fit_store)^2) #Residual sum of squares of our NLLS model
    TSS <- sum((Data$sp.rich - mean(Data$sp.rich))^2) #Total sum of squares 
    RSq <- 1 - (RSS/TSS) #R-squared value
    
    #get the parameter estimates
    a <- (summary(fit_store))$coefficients[, 1]
    
    #get our points for plotting
    df <- get_my_points()
    
    #get our parameters
    m0 = a[[2]]
    m = m0/sqrt(median(Data$volume))
    k = niches
    theta = a[[1]]
    
    #rho is the individual density per unit area, how can we find this out?
    rho = 100
    #Let's get our critical area for regime transition
    ACrit <- theta*(1-m)*(exp(k/theta)-1)/m*rho*log(1/m)
    
    
    #plot simulation, analytic and NLLS results
    
    author = paste(as.character(Data$author[1]), as.character(Data$year[1]))
    
    p1 <- ggplot(Data, aes(x = volume, y = sp.rich)) +
      geom_point()+
      #scale_x_log10() +
      ggtitle(paste(author, substr(Data$title, start = 1, stop = 45), "...")) +
      xlab(paste("log(volume)", Data$volume.metric)) +
      ylab(paste("richness (", Data$sp.rich.metric, ")")) +
      geom_smooth(data = df, aes(x=volume, y=species), se=F)+
      geom_vline(xintercept = log(ACrit), linetype="dotted", 
                 color = "red", size=1.5) +
      theme_bw()
    
    if (Data$log.volume[1]=="no"){
      p1 = p1 + scale_x_log10()
    }
    
    
    file_name = paste("../../Results/NLLSplot_", author, ".pdf", sep="")
    pdf(file_name)
    print(p1)
    dev.off()
    
    parameters <- data.frame(i, RSq, ACrit, m0, m, k, theta)
    names(parameters) <- c("ID", "R^2", "CriticalArea", "m0", "m_rate", "k", "theta")
    all_parameters <- rbind(all_parameters, parameters)
    
    
  }
  
}


all_parameters$`R^2` <- round(all_parameters$`R^2`, digits = 2)
all_parameters$CriticalArea <- signif(all_parameters$CriticalArea, digits = 3)
all_parameters$m0 <- signif(all_parameters$m0, digits = 3)
all_parameters$m_rate <- signif(all_parameters$m_rate, digits = 3)
all_parameters$theta <- round(all_parameters$theta, digits = 2)
write.csv(all_parameters, "../../Results/Plots/NLLSParametersVolume.csv", row.names = FALSE)

