rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")

#####HERE WE LOAD ALL OF OUT DATASETS INTO A LIST OF DATAFRAMES#####

folder <- "../Data/"  # path to folder that holds multiple .csv files
file_list <- list.files(path=folder, pattern="*.csv") # create list of all .csv files in folder
#load the csv files into a list
datasets <- lapply(file_list,
                   function(x)
                     read.csv(paste(folder, x, sep = ''),
                              stringsAsFactors = FALSE))

a <- 0 #will be used for storing best fit results in the loop
points_list <- list() #for storing our fitted points for plotting
results_list <- list() #for storing our RSq and parameter results
plots <- list() #this will be used for storing our plots!


#define the function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#FOR EACH DATASET IN THE LIST OF DATAFRAMES
#FIND THE COLUMN WITH SPECIES IN IT AND RENAME THIS SPECIES_RICH



  j <-1

  x <- data.frame(datasets[j])
  area <- x[5] #assign the area column of our dataframe to a vector
  species_rich <- x[6] #assign the species richness column of our dataframe to a vector
  data <- data.frame(area, species_rich) #bind into a new dataframe we will use for fitting
  names(data) <- c("area", "species_rich") #rename the columns
  data$area <- as.numeric(as.character(data$area)) #make sure all values are numeric or NA
  data <- data[complete.cases(data),] #remove NAs
  best_plot_points <- NA
  best_fit_results <- NA
  
  
  #Loop through the model fitting, with niche values (K) from 1 to maximum species richness
  #recorded on an 'island'
  #calculate R^2 value and store best parameter results
  
  for(K in 1:max(length(data$species_rich))) {

    
    chisholm_fit <- try(nlsLM(species_rich ~ chisholm_model(area, theta, m0, K), data = data, start = list(theta = 200, m0 = 0.0005, K=K)), silent=T)
    
    #Calculate the sum of squared errors - if there was no error in the model fitting!
    if(class(chisholm_fit) != "try-error"){
      RSS <- sum(residuals(chisholm_fit)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((data$species_rich - mean(data$species_rich))^2) #Total sum of squares 
      RSq <- 1 - (RSS/TSS) #R-squared value
      
      #store these results
      results <- data.frame(RSq, coef(chisholm_fit)["theta"], coef(chisholm_fit)["m0"], K)
      names(results) <- c("R-Squared", "Theta", "Immigration", "Niches")
      
      species <- chisholm_model(area = area, theta = coef(chisholm_fit)["theta"], m0 = coef(chisholm_fit)["m0"], K)
      points_plot <- data.frame(area, species)
      names(points_plot) <- c("area", "species")
      
      
      #if the new RSq value is greater than the previous RSq value, store the results 
      
      if (RSq > a) {
        best_fit_results <- results
        best_plot_points <- points_plot
        a <- RSq 
      }
      
    }
    
  }
  
  points_list[[j]] <- best_plot_points #store best points for plotting
  results_list[[j]] <- best_fit_results #store best RSq parameter results
  
  file_name = paste("../Results/SingleRunResults_", x[[2]][[1]], ".csv", sep="")
  write.csv(results_list, (file_name))

  



