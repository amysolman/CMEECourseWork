#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

###FUNCTION ONE TO NAME UP TO 104 NICHES######
name_my_niches <- function(k) {
  
  letters <- LETTERS
  my_niche_names <- list()
  
  for (i in 1:k) {
    if (i <= 26) {
      niche_name <- strsplit(letters, '')[[i]]
      my_niche_names[[i]] <- paste(niche_name,1, sep="")
    } else if (26 < i && i <= 52) {
      niche_name <- strsplit(letters, '')[[i-26]]
      my_niche_names[[i]] <- paste(niche_name,2, sep="")
    } else if (52 < i && i <= 78) {
      niche_name <- strsplit(letters, '')[[i-52]]
      my_niche_names[[i]] <- paste(niche_name,3, sep="")
    } else if (78 < i && i <= 104) {
      niche_name <- strsplit(letters, '')[[i-78]]
      my_niche_names[[i]] <- paste(niche_name,4, sep="")
    }
    
  }
  my_niche_names <- unlist(my_niche_names)
  
  return(my_niche_names)
} 

###FUNCTION TWO COALESCNCE FUNCTION####
#coalescence code from James
#generates metacommunity species abundances for one niche
#repeat 20 times and store each niche individually with letter identity (a - t)

coalescence_test <- function(J_meta, nu, k)
{
  metaniches <- list()
  
  for (c in 1:k) { #do the test k times to get k niches for the meta community
    
    niche_size <- J_meta/k
    #Initialise a vector lineages of length J with 1 as every entry.
    lineages <- seq(1,1,length=niche_size)
    #Initialise an empty vector abundances.
    abundances <- c()
    #Initialise a number N=J.
    N <- niche_size
    #Calculate θ, where θ=ν (J-1)/(1-ν).
    theta <- nu*(niche_size-1)/(1-nu) #should this be niche size of remain J?
    while(N > 1) # If N > 1 repeat the code
    {
      #Choose an index j of the vector lineages at random according to a uniform distribution.
      linvect <- 1:length(lineages)
      j <- sample(linvect,size=1)
      # Pick a random decimal number randnum between 0 and 1.
      randnum <- runif(1)
      if (randnum <theta/(theta+N-1))
      {
        # If randnum <θ/(θ+N-1)
        # append lineages[j] to the vector abundances.
        abundances <- c(abundances,lineages[j])
      } else {
        # If randnum ≥θ/(θ+N-1)
        # choose another index i of the vector lineages at random, but not allowing i = j.
        # Then set lineages[i] = lineages[i] + lineages[j].
        i <- sample(linvect[-j],size=1)
        lineages[i] <- lineages[i] + lineages[j]
      }
      #remove lineages[j] from lineages so that the lineages vector is now one shorter.
      lineages <- lineages [-j]
      #Decrease N by one so that N still gives the length of the lineages vector.
      N <- N-1
    }
    #Add the only element left in lineages to the end of abundances.
    abundances <- c(abundances,lineages[1])
    
    metaniches[[c]] <- abundances
    
  }
  names <- name_my_niches(k)
  names(metaniches) <- names
  
  #END: a vector of simulated species abundances is stored in abundances.
  return(metaniches)
}

###FUNCTION THREE####
#Takes species abundances from the coalescence test
#and outputs a metacommunity vector of seperate niches
metacommunity <- function(J_meta, nu, k) {
  
  meta <- vector() #empty vector for storing the community
  
  metaniches <- coalescence_test(J_meta, nu, k) #run coalescence test and get 
  
  for (a in 1:length(metaniches)) {
    
    metaniches[[a]] <- sort(metaniches[[a]], decreasing = TRUE) #sort by most abundant species
    
    for (i in 1:length(metaniches[[a]])) {
      
      meta <- c(meta, rep(i, metaniches[[a]][i])) #repeat for each species by abundance to give meta vector
      
      
    }
    metaniches[[a]] <- meta
    
    meta <- vector()
    
  } 
  
  return(metaniches)
}

#####FUNCTION FOUR#####
#function to store niche community, type and migration rate info
niche_info <- function(m0, k_size, letter) {
  Niche = rep(1, k_size)
  m0 = m0
  type = letter
  index_list <- list(Niche, type, m0)
  names(index_list) <- c("Niche", "Type", "m0")
  return(index_list)
  
}

#######FUNCTION FIVE#######
#Function to give max_num niches for each m0 rate of island
# 1 niche island, 2 niche island, 3 niche island

niches <- function(m0, k, k_size) {
  
  store_my_islands <- list() 
  
  for (a in 1:k) { #for each niche on the island
    
    names <- name_my_niches(k) #get niche names 
    letter <- names[[a]] #apply the appropriate name
    
    store_my_islands[[a]] <- niche_info(m0, k_size, letter) #generate niche info and store
    
  }
  
  return(store_my_islands)
  
}


#####FUNCTION SIX ######
#GIVE WHOLE ISLAND RICHNESS AT A GIVEN TIMESTEP
timeseries_richness <- function(focal_island) {
  
  species_richness <- list()
  
  for (n in 1:length(focal_island)) { #for each niche in the focal island
    x <- focal_island[[n]]$Niche #give the niche community to x
    niche_unique <- length(unique(x)) #the number of unique species in the niche
    species_richness[[n]] <- niche_unique
    
  }
  
  unique_sp <- sum(unlist(species_richness))
  
  return(unique_sp) #give number of unique species across entire island
}


####### FUNCTION SEVEN ######
#Function to generate multiple islands made up of multiple niches

my_island <- function(m0, k, k_size) {
  
  m0 <- m0
  x <- niches(m0, k, k_size)
  
  unique_sp <- timeseries_richness(x)
  
  #for each island create nested lists
  #each island has two lists, one to hold niche communities and one to 
  #store the timeseries of species richness
  island_data <- list()
  island_data[[1]] <- x
  island_data[[2]] <- unique_sp
  
  
  return(island_data)
}

#######FUNCTION EIGHT#######
##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
####will have to run indices and then unpack function beforehand for this to work####
#### e.g. unpack_me(indicies(0.005, 1000, 0.02)) #####
simulation_one_timestep <- function(i, k, island_area) {
  
  num <- runif(1)
  
  names <- name_my_niches(k)
  
  x <- match(Type, names) #at what index does the match occur?
  
  do_migration <- m0 #the likelihood of an immigration event occuring on the whole island
  
  #then we can specify to only have migration from the corresponding niche in the meta community
  
  if (num <= do_migration) { #if do_migration rate then replace a niche individual with a member of the 
    #corresponding niche in the metacommunity
    Niche[sample(length(Niche), 1, replace = T)] <<- Meta[[x]][sample(length(Meta[[x]]), 1, replace = T)]
  } else {
    Niche[sample(length(Niche), 1, replace = T)] <<- Niche[sample(length(Niche), 1, replace = T)]
  }
  
  return(Niche)
  
}


#######FUNCTION EIGHT#######
#return all indices items from list to global values
unpack_me <- function(x) {
  list2env(x,globalenv())
}

#######FUNCTION NINE######
#function to take focal island and number of niches
#and run one timestep on a randomly selected niche

timestep_my_focal_island <- function(focal_island, k) {
  
  for (z in 1:k){
    
    island_area <- length(focal_island[[1]])*length(focal_island[[1]][[1]]$Niche)
    
    unpack_me(focal_island[[1]][[z]]) #upack the community for that niche
    
    y <- simulation_one_timestep(i, k, island_area) #do simulation on niche and store community in y
    
    focal_island[[1]][[z]]$Niche <- y #replace the last community with the new community
  }
  
  
  #store the new niche communities for that island
  new_island_data <- list()
  new_island_data[[1]] <- focal_island[[1]]
  
  #combine previous timeseries results with new results
  #use an if statement here to save sp richness on timestep (i) multiples of 100
  
  if (i %% 5000 == 0) {
    unique_sp <- timeseries_richness(focal_island = focal_island[[1]])
    species <- focal_island[[2]] #previous timeseries results
    species[[length(species) + 1]] <- unique_sp #add new results
    new_island_data[[2]] <- species #add all that into our new list
  } else {
    new_island_data[[2]] <- focal_island[[2]]
  }
  
  
  return(new_island_data)
  
}

#######FUNTION TEN#######
#Function to run simulation on the cluster

cluster_run_function <- function(J_meta, nu, m0, num_islands, k, wall_time, output_file_name) {
  
  j <- 1
  
  Meta <<- metacommunity(J_meta, nu, k) #generate metacommunity for this simulation
  
  #generate islands 
  store_my_islands <- list()
  
  
  for (x in 1:num_islands) { #give multiple islands with same k and m0 rate, but different SIZED niches
    
    my_islands <- my_island(m0, k, k_size=x^2) 
    
    store_my_islands[[x]] <- my_islands
    
  }
  
  ptm <- proc.time()[3] #set start of timer, this counts in seconds
  
  while (proc.time()[3] - ptm < wall_time*60){ 
    
    num_islands <- length(store_my_islands)
    
    
    if (j <= num_islands) { #if j is between 1 and number of islands
      
      store_my_islands[[j]] <- timestep_my_focal_island(store_my_islands[[j]], k) #do one timestep on one island
      
      
    } else { #if J is over 10
      
      j <- 1 #make j 1 again (e.g. return to first island)
      i <<- i + 1 #move to the next timestep
      
      store_my_islands[[j]] <- timestep_my_focal_island(store_my_islands[[j]], k) #do next timestep on first island 
    }
    
    j <- j + 1 #move on to the next island
    
  }
  
  
  timesteps <- i
  
  #save to file
  
  total_time <- proc.time()[3] - ptm
  
  save(store_my_islands, timesteps, total_time, J_meta, nu, file = output_file_name)
  
}
