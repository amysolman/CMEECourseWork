#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

#install.packages("ggplot2")
library("ggplot2")

#FUNCTION ONE
#function to give starting homogenous island community one niche
island_com <- function() {
  Island = rep(1, 10)
  return(Island)
}

#FUNCTION TWO
#function to give birth/death/speciation and migration indices as a function of migration rate,
#number of timesteps and speciation rate
indices <- function(m, t_max, nu) {
  J_meta = 1000
  Meta = 1:J_meta
  Island = island_com()
  death_indices = sample(Island, t_max, replace = T)
  birth_indices_island = sample(Island, t_max, replace = T)
  birth_indices_meta = sample(Island, t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  index_list <- list(Meta, Island, death_indices, birth_indices_meta, birth_indices_island, do_speciation, do_migration)
  names(index_list) <- c("Meta", "Island", "death_indices", "birth_indices_meta", "birth_indices_island", "do_speciation", "do_migration")
  return(index_list)
  
}

#FUNCTION THREE
#return all indices items from list to global values
unpack_me <- function(x) {
  list2env(x,globalenv())
}

#FUNCTION FOUR
##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
####will have to run indices and then unpack function beforehand for this to work####
#### e.g. unpack_me(indicies(0.005, 1000, 0.02)) #####
simulation_one_timestep <- function(i) {
  
  if (do_speciation[i]) {
    Island[death_indices[i]] <<- length(unique(Meta)) + 1
  } else if (do_migration[i]) {
    Island[death_indices[i]] <<- Meta[birth_indices_meta[i]]
  } else {
    Island[death_indices[i]] <<- Island[birth_indices_island[i]]
  }
  
  return(Island)
  
}

#FUNCTION FIVE
###Run the simulation for a given number of timesteps and return the Island community
##for each timestep

neutral_time_series <- function(m, t_max, nu) {
  series <- vector()
  x <- indices(m, t_max, nu)
  unpack_me(x)
  for (i in 1:t_max) {
    y <- simulation_one_timestep(i)
    series <- rbind(series, y)
  }
  return(series)
}

#FUNCTION SIX
###Function to give time series of one island with a specified number of niches and specified
#migration rate
timeseries_multi_niches <- function(num_niches, m, t_max, nu) {
  
  store_my_niches <- list()
  
  for (i in 1:num_niches) {
    set.seed(i)
    a <- neutral_time_series(m, t_max, nu)
    store_my_niches[[i]] <- a
  }
  
  combined_niches <- do.call(cbind, store_my_niches)
  species_rich <- apply(combined_niches, 1, function(x) length(unique(x)))
  
  timestep <- seq(1, t_max)
  migration_rate <- rep(m, t_max)
  niches <- rep(num_niches, t_max)
  df <- cbind.data.frame(niches, timestep, migration_rate, species_rich)
  
  return(df)
  
}

#FUNCTION SEVEN
###Function to give time series of one island with multiple niches and specified
#migration rate
one_whole_island_step <- function(m, nu) {
  
  store_my_niches <- list() #list to store niche communities
  
  num_niches <- m*1000 #number of niches in relation to migration rate/island size
  
  #for each niche on the island
  #give the community after one timestep
  for (i in 1:num_niches) {
    set.seed(i)
    a <- neutral_time_series(m, 1, nu) #run neautral time series for one step
    store_my_niches[[i]] <- a #store community
  }
  
  #combine the niche communities, to give the total island community at this step
  combined_niches_community <- do.call(cbind, store_my_niches)
  
  return(combined_niches_community)
  
}

#Function Eight
#give whole island community timeseries

whole_island_timeseries <- function(m, t_max, nu) {
  
  for (t in 1:t_max) {
    community <- one_whole_island_step(m, nu)
  }
}


#FUNCTION EIGHT
####function to give timeseries of multiple islands with different number of niches
#but the same migration rate

multi_island_niches <- function(m, t_max, nu) {
  
  store_my_island <- list()
  
  num_niches <- m*1000
  
    set.seed(num_niches)
    island <- timeseries_multi_niches(num_niches, m, t_max, nu)
    store_my_island[[num_niches]] <- island
  
  all_my_islands <- do.call(rbind, store_my_island)
  
  return(all_my_islands)
}

#FUNCTION NINE
####function to give timeseries of multiple islands with different numbers of niches
#and different migration rates

multi_island_niches_migrations <- function(t_max, nu) {
  
  final_store_my_islands <- list()
  m = 0
  
  for (k in 1:25) {
    set.seed(k)
    m = m + 0.001
    multi_niche_islands <- multi_island_niches(m, t_max, nu)
    final_store_my_islands[[k]] <- multi_niche_islands
  }
  
  final_all_my_islands <- do.call(rbind, final_store_my_islands)
  final_all_my_islands$IDs <- cumsum(!duplicated(final_all_my_islands[, -c(2, 4)]))
  
  return(final_all_my_islands)
}

#####Function to run simulation on the cluster

cluster_run_neutral_island <- function(t_max, nu, wall_time, output_file_name) {
  
  ptm <- proc.time()[3] #set start of timer, this counts in seconds
  
  #while the time NOW minus start time (e.g. time elapsed in seconds) is less than wall_time*60 (e.g. wall_time in seconds)
  #carry out the simulation and store the timeseries of all the islands in my_islands
  while (proc.time()[3] - ptm < wall_time*60){ #while the third element in proc.time minus starting time is less than wall_time
    #run the one timestep of the simulation and store the community
    my_islands <- multi_island_niches_migrations(t_max, nu) #this returns dataframe with species rich timeseries of 
    #25 different sized islands
    
  }
  
  
  #save to file
  
  total_time <- proc.time()[3] - ptm
  
  save(my_islands, total_time, nu, t_max, file = output_file_name)
    
}
  
  

