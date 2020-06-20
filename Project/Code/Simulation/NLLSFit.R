#NLLS Fitting Script

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")
library("broom")

#Start by defining the model function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma
                                             (gamma_stars)))-digamma(theta/K)))
}

#get our full dataset
data <- read.csv("../../Data/SimData/ModData2.csv")

#function to loop through each unique combination of migration niche parameters and give their 
#mean species richnesses

get_my_means <- function() {
  
  myDFs <- list()
  
  for (i in 1:length(unique(data$ID))){ #for each unique ID
    
    mydata <- data[data$ID == i, ] #select all data with that id

    myareas <- unique(mydata$area)  #these are my unique areas
    species <- list()
    
    for (j in 1:length(myareas)){
      
      x <- mydata[mydata$area == myareas[j], ] #these are all the islands with the same mrate
      #num of niches and area
      
      species[[j]] <- mean(x$island_species)
    }
    
    #unlist our species list
    species <- unlist(species)
    
    df <- data.frame(myareas, species, mydata$migration_rates[[1]], mydata$K_num[[1]])
    names(df) <- c("area", "species", "migration", "niches")
    
    myDFs[[i]] <- df
  
  }
  
  return(myDFs)
  
}

#function to find NLLS starting values 
get_my_starts <- function(data) {
  
  nu = 0.001
  m_start = nu*median(data$area)/10
  m0_start = m_start*sqrt(median(data$area))
  theta_start = 50
  
  starts <- data.frame(nu, m_start, m0_start, theta_start)
  
  return(starts)
}
  

#function to perform NLLS fitting on each dataset and store best fit coefficients

NLLSfits <- function() {
  
  data <- get_my_means()
  
  #empty lists for storing our results
  
  RSq_store <- list()
  theta_store <- list()
  m0_store <- list()
  K_store <- list()
  fit_store <- list()
  all_results <- list()
  
  for (i in 1:length(data)) {
    
    starts <- get_my_starts(data[[i]])
    
    this_result = 0
    
    for (k in 1:ceiling(max(data[[i]]$species))) { #for num of niches from 1 to max number of species
      
      #fit the model
      fit_chisholm <- nlsLM(species ~ chisholm_model(area, theta, m0, K), data = data[[i]], 
                            start = list(theta = starts$theta_start, m0 = starts$m0_start, K=k))
      
      my_fits <- fit_chisholm
      
      #Get the R-squared value of the fitting
      
      RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((data[[i]]$species - mean(data[[i]]$species))^2) #Total sum of squares 
      RSq <- 1 - (RSS/TSS) #R-squared value
      
      #if this RSq value is higher than the last one, we store the results
      
      if (RSq >= this_result) {
        
        RSq_store[[i]] <- RSq
        theta_store[[i]] <- coef(fit_chisholm)["theta"]
        m0_store[[i]] <- coef(fit_chisholm)["m0"]
        K_store[[i]] <- coef(fit_chisholm)["K"]
        fit_store[[i]] <- my_fits
        this_result <- RSq
        
      }
      
    }
    
    
  }
  
  RSq_store <- unlist(RSq_store)
  theta_store <- unlist(theta_store)
  m0_store <- unlist(m0_store)
  K_store <- unlist(K_store)
  
  all_my_data <- data.frame(RSq_store, theta_store, m0_store, K_store)
  all_results[[1]] <- fit_store
  all_results[[2]] <- all_my_data
  
  return(all_results)
  
}


#function to generate plotting points from NLLS fitting data

get_my_points <- function() {
  
  df_store <- list()
  meandata <- get_my_means()
  all_results <- NLLSfits()
  fits_data <- all_results[[2]]
  
  for (i in 1:length(meandata)) {
    
    area <- meandata[[i]]$area
    chisholm_points <- chisholm_model(area = area, theta = fits_data[i,]$theta_store, m0 = fits_data[i,]$m0_store, K = fits_data[i,]$K_store)
  
    df1 <- data.frame(meandata[[i]]$area, meandata[[i]]$species)
    df1$Model <- as.factor("Solman")
    names(df1) <- c("area", "species", "ModelOrSim")
    df2 <- data.frame(area, chisholm_points)
    df2$Model <- as.factor("Chisholm")
    names(df2) <- c("area", "species","ModelOrSim")
    df <- rbind(df1, df2)
    
    df_store[[i]] <- df
    }
  
  return(df_store)
  
}


#plot all my fits

plot_my_fits <- function() {
  
  my_plots <- list()
  
  for (i in 1:length(df_store)) {
    
    df1 <- df_store[[i]][df_store[[i]]$ModelOrSim == "Solman", ]
    df2 <- df_store[[i]][df_store[[i]]$ModelOrSim == "Chisholm", ]
    
    p1 <- ggplot(df1, aes(x = log(area), y = species, colour = ModelOrSim)) +
      geom_point() +
      scale_color_manual(values=c("blue", "red")) +
      theme_bw() +
      ylab("Species Richness") +
      xlab("Island Area") +
      geom_line(data = df2, aes(x = log(area), y = species, colour = ModelOrSim)) +
      theme(legend.position = "none")
    
    my_plots[[i]] <- p1
    
    file_name = paste("../../Results/Simulation2/NLLS/NLLSfits_", i, ".pdf", sep="")
    pdf(file_name)
    plot <- my_plots[[i]]
    print(plot)
    dev.off()
    
  }

  return(my_plots)

  
}
  

  #let's store our r-squared results as well as summary parameter statistics

get_my_results <- function() {
  
  all_results <- NLLSfits()
  fits <- all_results[[1]]
  stats <- all_results[[2]]
  meandata <- get_my_means()
  results <- list()
  
  for (i in 1:length(fits)) {
    
    fit <- fits[[i]]
    
    y <- tidy(fit)
    y <- as.data.frame(y)
    y$r.squared <- stats[i,]$RSq_store
    z <- round(y[, 2:6], digits = 3)
    z <- cbind(y[, 1], z)
    names(z)[1] <- c("term")
    z$migration.rates <- meandata[[i]][1,]$migration
    z$niches <- meandata[[i]][1,]$niches
    z$num.islands <- nrow(meandata[[i]])
    z$fit.num <- i
    z <- z[,c(10,1,2,3,4,5,6,7,8,9)]
    
    results[[i]] <- z
    
  }
  
    all_results <- do.call("rbind", results)
    results1 <- all_results[all_results$fit.num == 1, ]
    results200 <- all_results[all_results$fit.num == 200, ]
    results400 <- all_results[all_results$fit.num == 400, ]
    
    resultsMulti <- rbind(results1, results200, results400)
    resultsMulti <- resultsMulti[-c(10)]
    
    #let's get a df of summary stats of the fits
    a = nrow(all_results[all_results$r.squared > 0.9, ])/3
    
    write.csv(all_results, "../../Results/Simulation2/NLLS/Results.csv", row.names = FALSE)
    write.csv(resultsMulti, "../../Results/Simulation2/NLLS/SumResults.csv", row.names = FALSE)
    
  
  
}
  








