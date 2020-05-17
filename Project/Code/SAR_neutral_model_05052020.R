rm(list=ls())
graphics.off()

##### SAR Neutral Model Simulation Code #####

###Define our starting communities + parameters

#define metacommunity
J_meta = 1000
Meta = 1:J_meta

#define island community
J_island = 100
Island = rep(1, J_island)

#speciation rate
nu = 0.01

#number of timesteps to run the simulation for
t_max = 10000000

#migration rate - proportional the island area
m = 0.005

#compute island death indices, metacommunity/island birth indices and speciation/migration indicies
death_indices = sample(J_island, t_max, replace = T)
birth_indices_island = sample(J_island, t_max, replace = T)
birth_indices_meta = sample(J_meta, t_max, replace = T)
do_speciation = rbinom(t_max, 1, nu)
do_migration = rbinom(t_max, 1, m)

##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####

#returns Island community

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

#returnS the Island community at the end

multi_timestep <- function(t_max) {
  
  for (i in 1:t_max) {
    simulation_one_timestep(i)
  }
  return(Island)
}

##### FUNCTION TO RUN T_MAX TIMESTEPS FOR INCREASING MIGRATION RATE FROM 0.001 - 0.1 

#returns species richness for each migration rate
#set migration rate to 0 so it can be gradually increased 
m = 0
species_richness <- list()

migration_multi_timestep <- function () {
  for (j in 1:100){
    m <<- m + 0.001
    do_migration <<- rbinom(t_max, 1, m)
    multi_timestep(t_max)
    species_richness[[j]] <<- length(unique(Island))
  }
}

#### RUN AND PLOT THIS MIGRATION RATE/SPECIES RICHNESS #####

migration_multi_timestep()

#plot species richness and migration rate
migration_rate = seq(0.001, 0.1, by = 0.001)
plot(migration_rate, species_richness, xlab = "Migration Rate", ylab = "Species Richness", log='y', type='l')


##### LOOP TO RUN SIMULATION T_MAX TIMESTEPS WITH FIXED MIGRATION RATE #####
##### TO STORE SPECIES RICHNESS FOR MULTIPLE NICHES #####


cummulative_niche <- list()

for (x in 1:10) {
  m = 0.005
  death_indices = sample(J_island, t_max, replace = T)
  birth_indices_island = sample(J_island, t_max, replace = T)
  birth_indices_meta = sample(J_meta, t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  multi_timestep(t_max)
  cummulative_niche[[x]] <- c(unique(Island))
}

##### FIND THE CUMMULATIVE SUM OF SPECIES RICHNESS WITH INCREASING NUMBER OF NICHES AND PLOT #####

for (n in 1:10) {
cummulative_niche[[n]] <- length(unique(cummulative_niche[[n]]))  
}

#plot
niche = seq(1:10)
plot(niche, cumsum(cummulative_niche), xlab = "Number of Niches", ylab = "Species Richness", log = 'y', type = 'l')






