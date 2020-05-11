#function that does pop size on island as function of migration rate
rm(list=ls())

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
    x = indices(m, t_max, 0.02)
    unpack_me(x)
    multi_timestep(t_max)
    niche_communities[[i]] <- Island
    
  }
  
  return(niche_communities)
}
