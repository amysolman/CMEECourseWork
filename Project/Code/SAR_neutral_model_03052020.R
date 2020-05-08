rm(list=ls())
graphics.off()

#Nested loop, where the chance of migration from the metacommunity is increase by 0.001
#each time. This is proportional to increasing area size.

#Within this, a homogenous island community of 100 individuals experiences speciation (with
#probability nu) or migration from the metacommunity (with probability m) or
#replacement with offspring from the island community (with probability 1 - (nu+m))

#migration rate - proportional to island area
m = 0.005

#empty list to store island species rank-abundance distributions
species_abundance = list()

for (j in 1:100) {
  
  #define metacommunity
  J_meta = 1000
  Meta = 1:J_meta
  
  #define island community
  J_island = 100
  Island = rep(1, J_island)
  
  #speciation rate
  nu = 0.01
  
  #number of timesteps to run the simulation for
  t_max = 100000
  
  #immigration rate - proportional the island area
  m = m + 0.001
  
  #initial species counter
  S_curr = 1
  
  #compute death, birth, speciation and migration indices in advance
  death_indices = sample(J_island, t_max, replace = T)
  birth_indices_island = sample(J_island, t_max, replace = T)
  birth_indices_meta = sample(J_meta, t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  
  
  
  for (i in 1:t_max) {
    
    if (do_speciation[i]) {
      Island[death_indices[i]] = S_curr + 1
      S_curr = S_curr + 1
    } else if (do_migration[i]) {
      Island[death_indices[i]] = Meta[birth_indices_meta[i]]
    } else {
      Island[death_indices[i]] = Island[birth_indices_island[i]]
    }
    
  }
  
  sp_abund = table(Island)
  species_abundance[[j]] <- sp_abund #save the species abundance to list
  
}

species_richness <- list()

for (i in 1:100) {
  species_richness[[i]] <- length(unique(species_abundance[[i]]))
}

migration_rate = seq(0.001, 0.1, by = 0.001)

plot(migration_rate, species_richness, log='y', type='l')







