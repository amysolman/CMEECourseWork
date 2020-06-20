#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

###FUNCTION ONE COALESCNCE FUNCTION####
#coalescence code from James
#generates metacommunity species abundances for one niche
#repeat 20 times and store each niche individually with letter identity (a - t)

coalescence_test <- function(J_meta,nu)
{
  metaniches <- list()
  
  for (c in 1:20) { #do the test 20 times to get 20 niches for the meta community
    
  niche_size <- J_meta/20
  #Initialise a vector lineages of length J with 1 as every entry.
  lineages <- seq(1,1,length=niche_size)
  #Initialise an empty vector abundances.
  abundances <- c()
  #Initialise a number N=J.
  N <- niche_size
  #Calculate θ, where θ=ν (J-1)/(1-ν).
  theta <- nu*(niche_size-1)/(1-nu)
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
  names <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T")
  names(metaniches) <- names
  #END: a vector of simulated species abundances is stored in abundances.
  return(metaniches)
}

###FUNCTION TWO####
#Takes species abundances from the coalescence test
#and outputs a metacommunity vector of 20 seperate niches
metacommunity <- function(J_meta, nu) {
  
  meta <- vector() #empty vector for storing the community
  
  metaniches <- coalescence_test(J_meta, nu) #run coalescence test and get 
  
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

#####FUNCTION THREE#####
#function to give birth/death/speciation and migration indices as a function of migration rate,
#number of timesteps and speciation rate
niche_info <- function(m, k_size, letter) {
  Niche = rep(1, k_size)
  do_migration = m
  type = letter
  index_list <- list(Niche, type, do_migration)
  names(index_list) <- c("Niche", "Type", "do_migration")
  return(index_list)
  
}

#######FUNCTION FOUR#######
#Function to give max_num niches for each m rate of island
# 1 niche island, 2 niche island, 3 niche island

niches <- function(m, max_k_num, k_size) {
  
  store_my_islands <- list() 
  store_my_niches <- list()
  
  for (a in 1:max_k_num) { #for 1 to the maximum number of niches
    
    store_my_islands[[a]] <- store_my_niches #creates list of 20 empty entries
  }
  
  
  for (b in 1:max_k_num) { #for 1 to maximum number of niches
    
    for (c in 1:b) {
      
      myletters <- "ABCDEFGHIJKLMNOPQRST"
      letter = strsplit(myletters, '')[[1]][[c]]
      store_my_islands[[b]][[c]] <- niche_info(m, k_size, letter) #generate niche info and store
      
    }
  }
  
  return(store_my_islands)
  
}


#####FUNCTION FIVE ######
#GIVE WHOLE ISLAND RICHNESS EACH TIMESTEP
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

####### FUNCTION SIX ######
#Function to generate multiple islands made up of multiple niches

multi_islands <- function(num_m_rates, max_k_num, k_size) {
  
  m <- 0
  
  #give incices for multiple num_m_rates
  multi_migration_islands <- list()
  migration_rates <- vector()
  
  for (n in 1:num_m_rates) {
    m <- m + 0.003
    x <- niches(m, max_k_num, k_size)
    multi_migration_islands[[n]] <- x
    migration_rates <- c(migration_rates, rep(m, max_k_num))
  }
  
  multi_migration_islands <- do.call(c, multi_migration_islands)
  names(multi_migration_islands) <- migration_rates
  
  
  #give starting species richness for each island
  unique_sp <- list()
  
  for (sp in 1:length(multi_migration_islands)) { #for each migration rate being simulated
    focal_island <- multi_migration_islands[[sp]]
    unique_sp[[sp]] <- timeseries_richness(focal_island)
  }
  
  #for each island create nested lists
  #each island has two lists, one to hold niche communities and one to 
  #store the timeseries of species richness
  island_data <- list()
  
  for (e in 1:length(multi_migration_islands)){
    island_data[[e]] <- list()
    island_data[[e]][[1]] <- multi_migration_islands[[e]]
    island_data[[e]][[2]] <- list()
    island_data[[e]][[2]][[1]] <- unique_sp[[e]]
  }
  
  names(island_data) <- migration_rates
  
  return(island_data)
}

#island_data <- multi_islands(num_m_rates, max_k_num, k_size)

#island_data[[x]] <- individual island x
#island_data[[x]][[1]] <- niches data
#island_data[[x]][[2]] <- timeseries data
#island_data[[x]][[1]][[y]] <- individual niche y with community, type and migration rate
#island_data[[20]][[1]][[5]]$Type <- will give you the type of niche

#######FUNCTION SEVEN#######
##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
####will have to run indices and then unpack function beforehand for this to work####
#### e.g. unpack_me(indicies(0.005, 1000, 0.02)) #####
simulation_one_timestep <- function(i) {
  
  num <- runif(1)
  
  myLetters <- LETTERS[1:26] #get capital letters 
  
  x <- match(Type, myLetters) #at what index does the niche time occur
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
#and run one timestep on each niche
#need focal island indices to run this

timestep_my_focal_island <- function(focal_island) {
  
  num_niches <- length(focal_island[[1]])
  
  k <- 1 #initialise niche counter
  #run timesteo on each niche
  while (k <= num_niches) {
    unpack_me(focal_island[[1]][[k]]) #upack the indices for one niche
    
    y <- simulation_one_timestep(i)#do simulation on niche and store community in y
    
    focal_island[[1]][[k]]$Niche <- y #replace the last community with the new community
    k <- k + 1
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

cluster_run_function <- function(J_meta, nu, num_m_rates, max_k_size, max_k_num, wall_time, output_file_name) {
  
  j <- 1 #initialise j for counting islands
  
  Meta <<- metacommunity(J_meta, nu) #generate metacommunity for this simulation
  
  store_my_islands <- list()
  
  for (x in 1:max_k_size) {
    
    my_islands <- multi_islands(num_m_rates, max_k_num, k_size = x) 
    
    store_my_islands <- c(store_my_islands, my_islands)
    
  }
  
  
  #calculates indices for niche of each island
  
  num_islands <- length(store_my_islands)
  
  ptm <- proc.time()[3] #set start of timer, this counts in seconds
  
  while (proc.time()[3] - ptm < wall_time*60){ 
    
    
    
    if (j <= num_islands) { #if j is between 1 and number of islands
      
      store_my_islands[[j]] <- timestep_my_focal_island(store_my_islands[[j]]) #do one timestep on one island
      
      
    } else { #if J is over 10
      
      j <- 1 #make j 1 again (e.g. return to first island)
      i <<- i + 1 #move to the next timestep
      
      store_my_islands[[j]] <- timestep_my_focal_island(store_my_islands[[j]]) #do next timestep on first island 
    }
    
    j <- j + 1 #move on to the next island
    
  }
  
  timesteps <- i
  
  #save to file
  
  total_time <- proc.time()[3] - ptm
  
  save(store_my_islands, timesteps, total_time, J_meta, nu, file = output_file_name)
  
}

