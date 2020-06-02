#script to plot timeseries for each island and put results into dataframe

rm(list=ls())
graphics.off()

#FUNCTION TO READ IN SIMULATIONS#
#read in 100 simulations
ImportMyData <- function() {
  my_sims <- list()
  for (i in 1:100) {
    load(paste0(file="simulation_timeseries_", i, ".rda"))
    my_sims[[i]] <- my_islands
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
    K_num <- rep(1:20, 50)
    area <- K_num*10
    island_species <- vector()
    
    for (island in 1:length(simulation)) { #for each island in the simulation
      
      focal_island <- simulation[[island]]
      species_richness <- unlist(tail(focal_island[[2]], n=1))
      island_species[[island]] <- species_richness
      SpRichTimeseries <- unlist(focal_island[[2]])
      sim_number <- rep(sim, length(SpRichTimeseries))
      island_num <- rep(island, length(SpRichTimeseries))
      timestep <- (1:length(SpRichTimeseries))*1000
      x <- focal_island[[1]]
      migration_rate <- rep(x[[1]]$do_speciation, length(SpRichTimeseries))
      df <- cbind(sim_number, island_num, migration_rate, timestep, SpRichTimeseries)
      island_timeseries[[island]] <- df
      
    }

    
    df <- cbind(sim_number, migration_rates, area, K_num, island_species)
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

write.csv(Data2Fit, "../../Results/SimModelFitData.csv", row.names = FALSE)
write.csv(Data2Plot, "../../Results/SimTimeseriesPlotData.csv", row.names = FALSE)

