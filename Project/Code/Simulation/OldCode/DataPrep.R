#script to process simulation data, ready for model fitting 
#and timeseries plotting

rm(list=ls())
graphics.off()

#FUNCTION TO READ IN SIMULATIONS#
#read in 100 simulations
ImportMyData <- function() {
  my_sims <- list()
  for (i in 1:100) {
    try(load(paste0(file="../../Data/SimData/10thJune/simulation_timeseries_", i, ".rda")), silent = T) 
    my_sims[[i]] <- store_my_islands
  } 
  
  return(my_sims)
}

#FUNCTION TO PROCESS DATA READY TO WRITE TO CSV#
ProcessMyData <- function() {
  
  my_sims <- ImportMyData()
  
  FinalData <- list()
  listofdataframes <- list()
  all_my_sims <- list() 
  
  for (sim in 1:length(my_sims)) { #for each simulation
    
    island_timeseries <- list()
    
    simulation <- my_sims[[sim]] #seperate out the simulation
    sim_number <- rep(sim, length(simulation)) #get the number of the simulation
    migration_rates <- names(simulation)
    
    island_species <- vector()
    K_num <- vector()
    area <- vector()
    K_size <- vector()
    
    for (island in 1:length(simulation)) { #for each island in the simulation
      
      K <- length(simulation[[island]][[1]])
      area <- c(area, K * length(simulation[[island]][[1]][[1]]$Niche))
      K_num <- c(K_num, K)
      K_size <- c(K_size, length(simulation[island][[1]][[1]][[1]][[1]]))
      focal_island <- simulation[[island]]
      species_richness <- unlist(tail(focal_island[[2]], n=1))
      island_species[[island]] <- species_richness
      SpRichTimeseries <- unlist(focal_island[[2]])
      sim_number <- rep(sim, length(SpRichTimeseries))
      island_num <- rep(island, length(SpRichTimeseries))
      timestep <- (1:length(SpRichTimeseries))*10000
      x <- focal_island[[1]]
      migration_rate <- migration_rates[island]
      df <- cbind(sim_number, island_num, migration_rate, timestep, SpRichTimeseries)
      island_timeseries[[island]] <- df
      
    }

    
    df <- cbind(sim_number, migration_rates, area, K_num, K_size, island_species)
    listofdataframes[[sim]] <- df
    
    combine <- as.data.frame(do.call("rbind", island_timeseries))
    all_my_sims[[sim]] <- combine
    
    
  }
  
  FinalData[[1]] <- as.data.frame(do.call("rbind", listofdataframes)) 
  FinalData[[2]] <- as.data.frame(do.call("rbind", all_my_sims))
  
  return(FinalData)
  
}

#FUNCTION FOR EXTRACTING FITTING DATA
DataForFitting <- function(FinalData) {
  
  Data2Fit <- FinalData[[1]] 
  
  return(Data2Fit)
  
}

#FUNCTION FOR EXTRACTING PLOTTING DATA
DataForPlotting <- function(FinalData) {
  
  Data2Plot <- FinalData[[2]]
  
  return(Data2Plot)
  
}

#GET THE DATA, WRITE TO CSV
FinalData <- ProcessMyData()
Data2Fit <- DataForFitting(FinalData)
Data2Plot <- DataForPlotting(FinalData)

write.csv(Data2Fit, "../../Data/SimData/SimModelFitData.csv", row.names = FALSE)
write.csv(Data2Plot, "../../Data/SimData/SimTimeseriesPlotData.csv", row.names = FALSE)



