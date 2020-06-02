#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

####FUNCTION ONE#######
###FUNCTION TO GENERATE EQUILIBRIUM METACOMMUNITY####
#This function can be run locally, but the package is not compatible on the cluster
#Therefore I have manually input the metacommunity from a previous run of this function
#To be run with HPC


# local_meta_fucntion <- function() {
#   Meta <- c(rep(1, 893), rep(2, 682), rep(3, 644), rep(4, 574), rep(5, 499), rep(6, 482))
#   Meta <- c(Meta, rep(7, 453), rep(8, 388), rep(9, 375), rep(10, 345), rep(11, 321), rep(12, 252))
#   Meta <- c(Meta, rep(13, 251), rep(14, 217), rep(15, 202), rep(16, 195), rep(17, 160))
#   Meta <- c(Meta, rep(18, 143), rep(19, 143), rep(20, 125), rep(21, 104), rep(22, 78))
#   Meta <- c(Meta, rep(23, 77), rep(24, 77), rep(25, 72), rep(26, 57), rep(27, 56), rep(28, 49))
#   Meta <- c(Meta, rep(29, 46), rep(30, 37), rep(31, 34), rep(32, 34), rep(33, 32), rep(34, 27))
#   Meta <- c(Meta, rep(35, 26), rep(36, 25), rep(37, 23), rep(38, 22), rep(39, 21), rep(40, 20))
#   Meta <- c(Meta, rep(41, 17), rep(42, 16), rep(43, 14), rep(44, 13), rep(45, 13), rep(46, 11))
#   Meta <- c(Meta, rep(47, 10), rep(48, 9), rep(49, 8), rep(50, 8), rep(51, 8), rep(52, 8))
#   Meta <- c(Meta, rep(53, 8), rep(54, 8), rep(55, 7), rep(56, 7), rep(57, 6), rep(58, 6))
#   Meta <- c(Meta, rep(59:60, each=5), rep(61:64, each=4), rep(65:68, each=3), rep(69:79, each=2), rep(80:93, each=1))
#   
#   return(Meta)
#   
# }



#####FUNCTION TWO#####
#function to give birth/death/speciation and migration indices as a function of migration rate,
#number of timesteps and speciation rate
indices <- function(m, t_max, nu) {
  Meta = Meta
  #Meta = local_meta_fucntion() #for use with HPC
  Island = rep(1, 10)
  death_indices = sample(length(Island), t_max, replace = T)
  birth_indices_island = sample(length(Island), t_max, replace = T)
  birth_indices_meta = sample(length(Meta), t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  index_list <- list(Meta, Island, death_indices, birth_indices_meta, birth_indices_island, do_speciation, do_migration)
  names(index_list) <- c("Meta", "Island", "death_indices", "birth_indices_meta", "birth_indices_island", "do_speciation", "do_migration")
  return(index_list)
  
}

#######FUNCTION THREE#######
#return all indices items from list to global values
unpack_me <- function(x) {
  list2env(x,globalenv())
}

#######FUNCTION FOUR#######
##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
####will have to run indices and then unpack function beforehand for this to work####
#### e.g. unpack_me(indicies(0.005, 1000, 0.02)) #####
simulation_one_timestep <- function(i) {
  
  if (do_speciation[i]) {
    Island[death_indices[i]] <<- sample(100:500, 1) #give unique species at each speciation event
  } else if (do_migration[i]) {
    Island[death_indices[i]] <<- Meta[birth_indices_meta[i]]
  } else {
    Island[death_indices[i]] <<- Island[birth_indices_island[i]]
  }
  
  return(Island)
  
}

#######FUNCTION FIVE#######
#Function to give indices for multiple niches
niche_indices <- function(m, nu) {
  
  store_my_indices <- list()
  
  num_niches <- m*1000 #this tells us how many niches we need to simulate for this
  #particular island
  for (n in 1:num_niches) {
    #calculate indicies for each niche for 100000 timesteps
    store_my_indices[[n]] <- indices(m, 1000000, nu)
  }
  
  return(store_my_indices)
}

#####FUNCTION SIX ######
#GIVE WHOLE ISLAND RICHNESS EACH TIMESTEP
timeseries_richness <- function(focal_island) {
  
  species_richness <- list()
  
  for (n in 1:length(focal_island)) {
    x <- focal_island[[n]]$Island
    species_richness[[n]] <- c(x) #combine each niche community into one big community
  }
  
  vect <- vector()
  vect <- unlist(species_richness)
  unique_sp <- length(unique(vect))
  return(unique_sp) #give number of unique species across entire island
}

####### FUNCTION SEVEN ######
#Function to give indices for multiple islands made up of multiple niches

island_indices <- function(nu, islands) {
  
  m <- 0
  
  #give incices for multiple islands
  multi_island_indices <- list()
  
  for (n in 1:islands) {
    m <- m + 0.002
    x <- niche_indices(m, nu)
    multi_island_indices[[n]] <- x
  }
  
  #give total species richness for each island
  #which to start with will be 1
  unique_sp <- list()
  
  for (sp in 1:islands) {
    focal_island <- multi_island_indices[[sp]]
    unique_sp[[sp]] <- timeseries_richness(focal_island)
  }
  
  #for each island create nested lists
  #each island has two lists, one to hold indices and one to 
  #store the timeseries of species richness
  island_data <- list()
  
  for (e in 1:islands){
    island_data[[e]] <- list()
    island_data[[e]][[1]] <- multi_island_indices[[e]]
    island_data[[e]][[2]] <- list()
    island_data[[e]][[2]][[1]] <- unique_sp[[e]]
  }
  
  
  return(island_data)
}

#######FUNCTION EIGHT######
#function to take focal island and number of niches
#and run one timestep on each niche
#need focal island indices to run this

timestep_my_focal_island <- function(focal_island) {
  
  num_niches <- length(focal_island[[1]])
  
  k <- 1 #initialise niche counter
  #run timesteo on each niche
  while (k <= num_niches) {
    unpack_me(focal_island[[1]][[k]]) #upack the indices for one niche
    y <- simulation_one_timestep(i)#do simulation on niche and store community in y
    focal_island[[1]][[k]]$Island <- y #replace the last community with the new community
    k <- k + 1
  }   
  
  #unique_sp <- timeseries_richness(focal_island = focal_island[[1]])
  
  #store the new niche communities for that island
  new_island_data <- list()
  new_island_data[[1]] <- focal_island[[1]]
  
  #combine previous timeseries results with new results
  #use an if statement here to save sp richness on timestep (i) multiples of 100
  
  if (i %% 10000 == 0) {
    unique_sp <- timeseries_richness(focal_island = focal_island[[1]])
    species <- focal_island[[2]] #previous timeseries results
    species[[length(species) + 1]] <- unique_sp #add new results
    new_island_data[[2]] <- species #add all that into our new list
  } else {
    new_island_data[[2]] <- focal_island[[2]]
  }

  
  return(new_island_data)

}

#######FUNTION NINE#######
#Function to run simulation on the cluster
cluster_run_function <- function(nu, islands, wall_time, output_file_name) {
  
  j <- 1 #initialise j for counting islands
  
  my_indices <- island_indices(nu, islands) #calculates indices for each niche of 10 islands of varying migration rate

  num_islands <- length(my_indices)
  
  ptm <- proc.time()[3] #set start of timer, this counts in seconds
  
  while (proc.time()[3] - ptm < wall_time*60){ 
    

    
    if (j <= num_islands) { #if j is between 1 and number of islands
    
      my_indices[[j]] <- timestep_my_focal_island(my_indices[[j]]) #do one timestep on one island

        
      } else { #if J is over 10

        j <- 1 #make j 1 again (e.g. return to first island)
        i <<- i + 1 #move to the next timestep
        
        my_indices[[j]] <- timestep_my_focal_island(my_indices[[j]]) #do next timestep on one island 
      }
      
    j <- j + 1 #move on to the next island
    
  }
  
  timesteps <- i
  
  #save to file
  
  total_time <- proc.time()[3] - ptm
  
  save(my_indices, timesteps, total_time, nu, file = output_file_name)
  
}

# i = 1
# nu = 0.001
# islands = 10
# wall_time = 5
# 
# output_file_name = paste0("sim_timeseries_localtest", i, ".rda")
# 
# cluster_run_function(nu = 0.001, islands = 10, wall_time = 5, output_file_name = output_file_name)

