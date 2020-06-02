#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

#FUNCTION ONE
#function to give birth/death/speciation and migration indices as a function of migration rate,
#number of timesteps and speciation rate
indices <- function(m, t_max, nu) {
  J_meta = 1000
  Meta = 1:J_meta
  Island = rep(1, 10)
  death_indices = sample(length(Island), t_max, replace = T)
  birth_indices_island = sample(length(Island), t_max, replace = T)
  birth_indices_meta = sample(J_meta, t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  #unique_species = length(unique(Meta)) + length(unique(Island))
  index_list <- list(Meta, Island, death_indices, birth_indices_meta, birth_indices_island, do_speciation, do_migration)
  names(index_list) <- c("Meta", "Island", "death_indices", "birth_indices_meta", "birth_indices_island", "do_speciation", "do_migration")
  return(index_list)
  
}

#FUNCTION TWO
#return all indices items from list to global values
unpack_me <- function(x) {
  list2env(x,globalenv())
}

#FUNCTION THREE
##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
####will have to run indices and then unpack function beforehand for this to work####
#### e.g. unpack_me(indicies(0.005, 1000, 0.02)) #####
simulation_one_timestep <- function(i) {
  
  if (do_speciation[i]) {
    Island[death_indices[i]] <<- sample(1001:5000, 1) #trying to give unique species at each speciation event
  } else if (do_migration[i]) {
    Island[death_indices[i]] <<- Meta[birth_indices_meta[i]]
  } else {
    Island[death_indices[i]] <<- Island[birth_indices_island[i]]
  }
  
  return(Island)
  
}

#FUNCTION FOUR
#Function to give indices for multiple niches
niche_indices <- function(m, nu) {
  
  store_my_indices <- list()
  
  num_niches <- m*1000 #this tells us how many niches we need to simulate for this
  #particular island
  for (n in 1:num_niches) {
    #calculate indicies for each niche for 100000 timesteps
    store_my_indices[[n]] <- indices(m, 100000, nu)
  }
  
  return(store_my_indices)
}

#FUNCTION FIVE
#Function to give indices for multiple islands made up of multiple niches

island_indices <- function(nu) {
  m <- 0
  multi_island_indices <- list()
  for (n in 1:10) {
    m <- m + 0.01
    x <- niche_indices(m, nu)
    multi_island_indices[[n]] <- x
  }
  
  return(multi_island_indices)
}

#FUNCTION SIX
#function to take focal island and number of niches
#and run one timestep on each niche
#need focal island indices to run this

timestep_my_focal_island <- function(focal_island) {
  num_niches <- length(focal_island)
  k <- 1 #initialise niche counter
  while (k <= num_niches) {
    unpack_me(focal_island[[k]]) #upack the indices for one niche
    y <- simulation_one_timestep(i)#do simulation on niche and store community in y
    #focal_island[[k]]$unique_species <- focal_island[[k]]$unique_species + 1
    focal_island[[k]]$Island <- y #replace the last community with the new community
    k <- k + 1
  } 
  
  return(focal_island)
}

#FUNTION SEVEN
#Function to run simulation on the cluster
cluster_run_function <- function(nu, wall_time, output_file_name) {
  
  my_indices <- island_indices(nu) #calculates indices for each niche of 25 islands of varying migration rate
  
  i <- 1 #initialise i for counting timesteps
  j <- 1 #initialise j for counting islands
  
  num_islands <- length(my_indices)
  
  ptm <- proc.time()[3] #set start of timer, this counts in seconds
  
  while (proc.time()[3] - ptm < wall_time*60){ 
    
    if (j <= num_islands) { #if j is between 1 and number of islands
    
      my_indices[[j]] <- timestep_my_focal_island(my_indices[[j]]) #do one timestep on one island
        
      } else { #if J is over 25

        j <- 1 #make j 1 again (e.g. return to first island)
        i <- i + 1 #move to the next timestep
        
        my_indices[[j]] <- timestep_my_focal_island(my_indices[[j]]) #do next timestep on one island 
      }
      
    j <- j + 1 #move on to the next island
    
  }
  
  timesteps <- i


#give total final communities for each island by combining the niches
all_communities <- list()
  
  for (n in 1:length(my_indices)) {
    island <- my_indices[[n]]
    
    total_com <- vector()
    
  for (k in 1:length(island)) {
    community <- island[[k]]$Island
    total_com <- rbind(total_com, community)
  }
  all_communities[[n]] <- total_com
  }
  
  #save to file
  
  total_time <- proc.time()[3] - ptm
  
  save(timesteps, all_communities, total_time, nu, file = output_file_name)
  
}







