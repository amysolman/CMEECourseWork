rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting

#####HERE WE LOAD ALL OF OUT DATASETS INTO A LIST OF DATAFRAMES#####

folder <- "../Data/"  # path to folder that holds multiple .csv files
file_list <- list.files(path=folder, pattern="*.csv") # create list of all .csv files in folder
#load the csv files into a list
datasets <- lapply(file_list,
                       function(x)
                         read.csv(paste(folder, x, sep = ''),
                                  stringsAsFactors = FALSE))

a <- 0 #will be used for storing best fit results in the loop
points_list <- list() #for storing our fitted points
results_list <- list() #for storing our results
plots <- list() #this will be used for storing our plots!


#define the function
chisholm_model <- function(area, theta, m0) {
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

for (j in 1:length(datasets)) {

  x <- data.frame(datasets[j])
  area <- x[5] #assign the area column of our dataframe to a vector
  species_rich <- x[6] #assign the species richness column of our dataframe to a vector
  data <- data.frame(area, species_rich) #bind into a new dataframe we will use for fitting
  names(data) <- c("area", "species_rich") #rename the columns
  data$area <- as.numeric(as.character(data$area)) #make sure all values are numeric or NA
  data <- data[complete.cases(data),] #remove NAs

#Loop through the model fitting, with niche values (K) from 1 to maximum species richness
#recorded on an 'island'
#calculate R^2 value and store best parameter results

for(i in 1:max(length(data$species_rich))) {

  K <- i
  
  chisholm_fit <- try(nlsLM(species_rich ~ chisholm_model(area, theta, m0), data = data, start = list(theta = 200, m0 = 0.0005)), silent=T)
  
  #Calculate the sum of squared errors - if there was no error in the model fitting!
  if(class(chisholm_fit) != "try-error"){
  RSS <- sum(residuals(chisholm_fit)^2) #Residual sum of squares of our NLLS model
  TSS <- sum((data$species_rich - mean(data$species_rich))^2) #Total sum of squares 
  RSq <- 1 - (RSS/TSS) #R-squared value
  
  #store these results
  results <- data.frame(RSq, coef(chisholm_fit)["theta"], coef(chisholm_fit)["m0"])
  names(results) <- c("R-Squared", "Theta", "Immigration")
  
  species <- chisholm_model(area = area, theta = coef(chisholm_fit)["theta"], m0 = coef(chisholm_fit)["m0"])
  points_plot <- data.frame(area, species)
  names(points_plot) <- c("area", "species")
  
  
#if the new RSq value is greater than the previous RSq value, store the results 
  
  if (RSq > a) {
    best_fit_results <- results
    best_plot_points <- points_plot
    a <- RSq 
  }
  
  }else{
    if (!is.na(best_fit_results)){ #if best_fit_results are not NA
      best_fit_results <- best_fit_results #they stay the same
      best_plot_results <- best_plot_results
    }else{
      best_fit_results <- NA #if not, store as NA
      best_plot_points <- NA
    }
  }
  
  
}

  points_list[[j]] <- best_plot_points
  results_list[[j]] <- best_fit_results

  if(!is.na(points_list[[j]])){
    
    #generate a vector of areas to for plotting our model fit
    Area <- seq(min(data$area),max(data$area),len=length(data$area))
    
    #remove incomplete cases from our plot points
    best_plot_points <- best_plot_points[complete.cases(best_plot_points),] 
    
    #plot the most successful model fit with the data
    p <- ggplot(data, aes(x=area, y=species_rich)) +
      geom_point() +
      xlab("Area") +
      ylab("Species Richness") +
      theme_bw() +
      ggtitle("Species-Area Relationship") +
      geom_line(data = best_plot_points, aes(x = area, y = species))
    
    plots[[j]] <- p
  }else{
    plots[[j]] <- NA
  }


}



#Save plots

for (i in 1:(length(plots))) {
  file_name = paste("../Results/plot_", i, ".pdf", sep="")
  pdf(file_name)
  print(plots[[i]])
  dev.off()
}
