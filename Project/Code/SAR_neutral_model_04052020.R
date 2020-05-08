rm(list=ls())
graphics.off()

#Nested loop, where the chance of migration from the metacommunity is increase by 0.001
#each time. This is proportional to increasing area size.

#Within this, a homogenous island community of 100 individuals experiences speciation (with
#probability nu) or migration from the metacommunity (with probability m) or
#replacement with offspring from the island community (with probability 1 - (nu+m))

#migration rate - proportional the island area
m = 0

#define selection strength, this is how much the fitness
#category of the individual will affect it's likeihood
#of reproducing
s = 0.05

#empty list to store island species rank-abundance distributions
species_abundance = list()

for (j in 1:100) {
  
  #define metacommunity
  J_meta = 1000
  Meta_species = 1:J_meta
  
  #fitness classes of meta individuals
  meta_fitness <- rep(1:10, each=100)
  meta_fitness <- cbind(Meta_species, meta_fitness)
  
  #define island community
  J_island = 100
  Island_species = rep(1, J_island)
  
  #fitness classes of island individuals
  fitness <- rep(1:10, each=10)
  species_fitness <- cbind(Island_species, fitness)
  
  #define the number of niches on the island
  #a species can only successfully join a niche if it has the same of higher
  #value (e.g. K[1] needs fitness 1 or higher to be inhabited)
  #K = 1:10
  
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
    
    #if there is a migration event
    if (do_migration[i]) {
      
      #and if the fitness of the metacommunity birthing individual is greater than
      #or equal to the fitness of the dead individual
      if (meta_fitness[[birth_indices_meta[i],2]] >= species_fitness[[death_indices[i],2]]) {
    
        #the migrating indivudual successfully replaces the dead individual
        species_fitness[[death_indices[i]]] = meta_fitness[[birth_indices_meta[i]]]
        species_fitness[[death_indices[i],2]] = meta_fitness[[birth_indices_meta[i],2]]
      } else {
        
        #otherwise the dead individual is replaced with nothing
        species_fitness[[death_indices[i]]] = 0
        species_fitness[[death_indices[i],2]] = 0
      }
      
      #if there is a speciation event
    } else if (do_speciation[i]) {
      
      #the dead individual is replaced with a species uniue to the island
      #and that individual inherits the fitness of the birthing individual
      species_fitness[[death_indices[i]]] = S_curr +1
      species_fitness[[death_indices[i],2]] = species_fitness[[birth_indices_island[i],2]]
      
    } else {
      
      #otherwise if the fitness of the local birthing individual is greater than or equal to
      #the fitness of the dead individual, then they successfully replace the species and fitness
      if (species_fitness[[birth_indices_island[i],2]] >= species_fitness[[death_indices[i],2]]) {
        species_fitness[[death_indices[i]]] = species_fitness[[birth_indices_island[i]]]
        species_fitness[[death_indices[i],2]] = species_fitness[[birth_indices_island[i],2]]
        
      } else {
        
        #otherwise the dead individual is replaced with nothing
        species_fitness[[death_indices[i]]] = 0
        species_fitness[[death_indices[i],2]] = 0
      }

    }
    
    S_curr <- length(unique(species_fitness[Island_species]))
  }

  sp_abund = table(species_fitness[,1])
  species_abundance[[j]] <- sp_abund #save the species abundance to list 
}

species_richness <- list()

for (i in 1:100) {
  species_richness[[i]] <- length(unique(species_abundance[[i]]))
}

migration_rate = seq(0.001, 0.1, by = 0.001)

plot(migration_rate, species_richness, log='y', type='l')





