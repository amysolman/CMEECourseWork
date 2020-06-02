##Script for processing cluster results

rm(list=ls())
graphics.off()

library("ggplot2")

# make_my_islands <- function() {
#   all_communities <- list()
#   for (i in 1:25) {
#     all_communities[[i]] <- matrix(sample(1:100, replace=T), ncol=10, nrow =  i)
#   }
#   return(all_communities)
# }
# 
# make_my_sims <- function() {
#   my_results <- list()
#   
#   for (i in 1:100) {
#     my_results[[i]] <- make_my_islands()
#   }
#   
#   return(my_results)
# }
# 
# my_results <- make_my_sims()




#read in 100 simulations
my_results <- list()
for (i in 1:100) {
  load(paste0(file="simulation_", i, ".rda"))
  my_results[[i]] <- all_communities
} 


#create num_dfs dataframes for storing each islands communities
my_island_dataframes <- function(num_dfs) {
  list_of_dfs <- list()
  for (d in 1:num_dfs) {
    df = data.frame()
  list_of_dfs[[d]] <- df
  }
  return(list_of_dfs)
}

#For each simulation, seperate out the final communities of each island
my_islands <- function(my_results) {
  y <- my_island_dataframes(length(my_results[[1]]))#call the previous function to create a dataframe
  #for each island
  
  for (l in 1:length(y)) { #we'll create 100 spaces in the dataframe for our 100 sims
    y[[l]] <- my_island_dataframes(length(my_results))
  }
  
  for (i in 1:length(my_results)) { #for each simulation
    x <- my_results[[i]]
    for (j in 1:length(x)) {
      y[[j]][[i]] <- x[[j]] #store the community of each island in the relevant dataframe
    }
  }
  
  migration_rates <- seq(1:10)
  migration_rates <- migration_rates*0.01
  names(y) <- c(migration_rates)
  
  return(y)
}

y <- my_islands(my_results = my_results)

#function to give species richness of each island, input is y list from previous function
how_rich_am_I <- function(outcomes) {
  
  total_species_richness <- list()
  
  for (i in 1:length(outcomes)) {
    
    islands <- outcomes[[i]]
    species_richness <- list()
    
    
    for (j in 1:length(islands)) {
      z <- islands[[j]]
      x <- length(unique(as.vector(islands[[j]])))
      species_richness[[j]] <- x
      
    }

    total_species_richness[[i]] <- species_richness
    
  }
  
  migration_rates <- seq(1:10)
  migration_rates <- migration_rates*0.01
  names(total_species_richness) <- c(migration_rates)
  
  return(total_species_richness)
}

#Function to give the mean species richness for each island size across the 100 simulations

mean_species_richness <- function(total_species_richness) {
  
  my_mean_sp_rich <- list()
  
  for (a in 1:length(total_species_richness)) {
    x <- total_species_richness[[a]]
    y <- sum(unlist(x))/length(x)
    my_mean_sp_rich[[a]] <- y
  }
  
  migration_rates <- seq(1:10)
  migration_rates <- migration_rates*0.01
  names(my_mean_sp_rich) <- c(migration_rates)
  
  return(my_mean_sp_rich)
}

#plot mean richness
results_dataframe <- function() {
  final_sp_rich <- unlist(my_mean_sp_rich)
  migration_rates <- seq(1:10)
  migration_rates <- migration_rates*0.01
  data <- data.frame("Migration_Rates" = migration_rates, "Species_Richness" = final_sp_rich)
  return(data)
}

#export results

export_me <- function() {
  write.csv(data, "../Results/mean_sim_one.csv")
}

#log migration rate
q <- ggplot(data, aes(x = log(Migration_Rates), y=Species_Richness)) +
  geom_point() +
  geom_smooth()

#no log

p <- ggplot(data, aes(x = Migration_Rates, y=Species_Richness)) +
  geom_point() +
  geom_smooth()


