#NLLS Fitting Script

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting

results_list <- list()
points_list <- list()

#Start by defining the model function

chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#What parameters does the model estimate when fitted to data that has the same migration rate 
#and same number of niches?

#Let's seperate out the data into those with the same m rate and same niches

data <- read.csv("../../Results/Simulation/SimModelFitData.csv")

m_rates <- unique(data$migration_rates)
c <- 1

for (i in 1:length(m_rates)) {
  
  x <- data[data$migration_rates == m_rates[i], ]
  niches <- unique(x$K_num)
   
  for (n in 1:length(niches)){
    
    y <- x[x$K_num == niches[n], ]
    
    migration_rate <- m_rates[i]
    
    #To run the model fitting we need our island areas and species richness, as well as starting values for theta, m0 and K
    nu = 0.001
    theta <- nu*(sum(y$area-1)/(1-nu))
    m <- 0.01
    m0 <- m*sqrt(sum(y$area))
    K <- 5
    
    #fit the model
    fit_chisholm <- try(nlsLM(island_species ~ chisholm_model(area, theta, m0, K), data = y, start = list(theta = theta, m0 = m0, K=K)), silent=T)
    #summary(fit_chisholm)
    
    #Get the R-squared value of the fitting
    if(class(fit_chisholm) != "try-error"){
    RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
    TSS <- sum((y$island_species - mean(y$island_species))^2) #Total sum of squares 
    RSq <- 1 - (RSS/TSS) #R-squared value
    
    #store our summary stats
    
    mean_m0 <- mean(y$migration_rates)*sqrt(sum(y$area))
    mean_niches <- mean(y$K_num)
    results <- data.frame(migration_rate, RSq, coef(fit_chisholm)["theta"], coef(fit_chisholm)["m0"], mean_m0, coef(fit_chisholm)["K"], mean_niches)
    names(results) <- c("MigrationRate", "R-Squared", "EstTheta", "EstM0", "M0", "EstNiches", "Niches")
    
    #get estimated points to plot
    
    area <- y$area
    chisholm_points <- chisholm_model(area = area, theta = coef(fit_chisholm)["theta"], m0 = coef(fit_chisholm)["m0"], K = coef(fit_chisholm)["K"])
    df1 <- data.frame(area, chisholm_points)
    df1$Model <- "Chisholm Model"
    names(df1) <- c("Area", "Species", "Model")
    
    } else {
      results <- data.frame(NA, NA, NA, NA)
      names(results) <- c("R-Squared", "EstTheta", "EstMigration", "EstNiches")
      
      df1 <- data.frame(NA, NA)
      df1$Model <- "Chisholm Model"
      names(df1) <- c("Area", "Sp_Rich", "Model")
    }
    
    #store results
    results_list[[c]] <- results
    points_list[[c]] <- df1
    
    c <- c + 1
    
  }
 
}



#Export stats results and plotting points

write.csv(results, "../../Results/Simulation/NLLSMeanStats.csv", row.names = FALSE)
write.csv(df1, "../../Results/Simulation/NLLSMeanPlotPoints.csv", row.names = FALSE)
