#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

library("ggplot2")

#function to give island size as a function of migration rate
island_size <- function(m) {
  J_island = m*10000
  return(J_island)
}

#function to give starting homogenous island community as a function of island size
island_com <- function(m) {
  J_island = island_size(m)
  Island = rep(1, J_island)
  return(Island)
}

#function to give birth/death/speciation and migration indices as a function of migration rate,
#number of timesteps and speciation rate
indices <- function(m, t_max, nu) {
  J_meta = 1000
  Meta = 1:J_meta
  J_island = island_size(m)
  Island = island_com(m)
  death_indices = sample(J_island, t_max, replace = T)
  birth_indices_island = sample(J_island, t_max, replace = T)
  birth_indices_meta = sample(J_meta, t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  index_list <- list(Meta, Island, death_indices, birth_indices_meta, birth_indices_island, do_speciation, do_migration)
  names(index_list) <- c("Meta", "Island", "death_indices", "birth_indices_meta", "birth_indices_island", "do_speciation", "do_migration")
  return(index_list)
  
}

#return all indices items from list to global values
unpack_me <- function(x) {
  list2env(x,globalenv())
}

##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
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

##### FUNCTION TO RUN T_MAX TIMESTEPS ON ONE NICHE #####
multi_timestep <- function(t_max) {
  
  for (i in 1:t_max) {
    set.seed(i)
    simulation_one_timestep(i)
  }
  return(Island)
}

#RUN SIMULATION T_MAX TIMESTEPS WITH FIXED MIGRATION RATE #####
##### TO STORE community FOR each NICHE #####

multi_niche <- function(niches, m, t_max) {
  
  niche_communities <- list()
  
  for (i in 1:niches) {
    set.seed(i)
    x = indices(m, t_max, 0.01)
    unpack_me(x)
    multi_timestep(t_max)
    niche_communities[[i]] <- Island
    
  }
  
  total_island_community <- unlist(niche_communities)
  
  return(total_island_community)
}

#run simulation of one island with 0.001 immigration rate and 1 niche
#store unique number of species

run_multiple_niches <- function(number_of_niches, m, t_max) {
  
  com <- list()
  niches = 1
  previous_niche_community <- NULL
  
  for (niches in 1:number_of_niches){
    set.seed(niches)
    community <- multi_niche(niches, m, t_max)
    com[[niches]] <- c(previous_niche_community, community)
    previous_niche_community <- unlist(com[niches-1])
    niches = niches + 1
    
  }
  
  return(com)
  
}

#run multiple niche simulation for 100 different sized islands (migration rates)

run_migration_and_niches <- function(number_of_niches, t_max) {
  
  m = 0
  islands <- list()
  
  for (i in 1:100) {
    set.seed(i)
    m = m + 0.001
    x <- run_multiple_niches(number_of_niches, m, t_max)
    islands[[i]] <- x
  }
  
  return(islands)
}

#run a simulation with 100 islands of varying sizes, and multiple niches for multiple timesteps
#and returns a dataframe with island number, migration_rate, niches and unique species

find_my_species_richness <- function (number_of_niches, t_max) {
  
  a <- run_migration_and_niches(number_of_niches, t_max)
  df <- data.frame(matrix(ncol = 0, nrow = 0))
  
  for (x in 1:length(a)) {
    species_richness <- vector()
    this_island <- a[[x]]
    for (y in 1:length(this_island)) {
      species_richness[y] <- length(unique(this_island[[y]]))
    }
    
    niches <- seq(1, length(this_island))
    migration_rate <- x*0.001
    migration_rate <- rep(migration_rate, length(this_island))
    #island_number <- rep(x, length(this_island))
    new_df <- cbind.data.frame(migration_rate, niches, species_richness)
    df <- rbind(df, new_df)
  }
  return(df)
}

#run simulation of 1000 islands with varying migration rate/niche numbers and plot

sp <- find_my_species_richness(10, 100000)

  q <- ggplot(sp, aes(x=migration_rate, y=species_richness, shape=as.factor(niches), colour= as.factor(niches))) +
    scale_shape_manual(values=1:10) +
    geom_point() +
    ylab("Species Richness") +
    xlab("Migration Rate") +
    ggtitle("Species richness, as a function of migration rate and number of niches") +
    geom_smooth(aes(fill=as.factor(niches))) +
    theme(legend.title = element_blank())

  p <- ggplot(sp, aes(x=log(migration_rate), y=species_richness, shape=as.factor(niches), colour= as.factor(niches))) +
    scale_shape_manual(values=1:10) +
    geom_point() +
    ylab("Species Richness") +
    xlab("Migration Rate") +
    ggtitle("Species richness, as a function of migration rate and number of niches") +
    geom_smooth(aes(fill=as.factor(niches))) +
    theme(legend.title = element_blank())

