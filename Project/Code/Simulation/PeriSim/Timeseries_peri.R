###Script to plot three simulation timeseries
#to make sure extinction-migration dynamic equilibrium has been reached

rm(list=ls())
graphics.off()

library("ggplot2")
library("gridExtra") #for multiplots on one graph

#FUNCTION TO READ IN SIMULATIONS#
#read in 100 simulations
ImportMyData <- function(num_sim) {
  my_sims <- list()
  for (i in 1:100) {
    try(load(paste0(file="../../../Data/SimData/Perimeter/simulation_peri_", num_sim, "_", i, ".rda")))
    my_sims[[i]] <- store_my_islands
  } 
  
  return(my_sims)
}

#Import the data
for (j in 1:10){
  numbers <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
  
  data <- ImportMyData(num_sim = numbers[j])
  
  #select 3 random simulations
  num <- sample(1:100, 3)
  
  #empty list for storing my plots
  my_plots <- list()
  
  #plot three of our simulations to check they reached equilibrium
  for (p in 1:3){
    
    Data <- data[[num[[p]]]]
    
    timesteps <- seq(1, length(Data[[1]][[2]]))*5000
    island_num <- seq(1, 100)
    species_rich <- Data[[1]][[2]]
    df <- cbind.data.frame(timesteps, species_rich, island_num[[1]])
    colnames(df) <- c("timesteps", "species", "island_num")
    
    for (i in 2:length(Data)){
      species_rich <- Data[[i]][[2]]
      df2 <- cbind.data.frame(timesteps, species_rich, island_num[[i]])
      colnames(df2) <- c("timesteps", "species", "island_num")
      df <- rbind(df, df2)
    }
    
    
    plot <- ggplot(df, aes(x=timesteps, y=species, group=island_num))+
      geom_line(aes(color=island_num, group=island_num))+
      scale_colour_gradientn(colours=rainbow(10))
    
    my_plots[[p]] <- plot
  }
  
  # Print the plot to a pdf file
  file_name = paste0("../../../Results/Simulation/PeriTimeseriesPlot_", j, ".pdf")
  pdf(file_name)
  myplot <- do.call(grid.arrange,my_plots)
  print(myplot)
  dev.off()
  
}

