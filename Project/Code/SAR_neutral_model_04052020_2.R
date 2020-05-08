rm(list=ls())
graphics.off()

#create empty island matrix of 10 niches with room for 10 individuals
island <- matrix( rep( 0, len=100), nrow=10, dimnames = list(c("K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10")))

#create metacommunity
J_meta = 1000
Meta_species = 1:J_meta

#fitness classes of meta individuals
meta_fitness <- rep(1:10, each=100)
meta_fitness <- cbind(Meta_species, meta_fitness)

#migration rate
m = 0.05

#number of time steps
t_max = 10000

#define when migration events will occur
do_migration = rbinom(t_max, 1, m)

#define which individual will die from the island
#at each timestep
death_indices_individual = sample(10, t_max, replace = T)
death_indices_niche = sample(10, t_max, replace=T)

#define which individual from the metacommunity might migrate
#at each timestep
birth_indices_meta = sample(J_meta, t_max, replace = T)

for (i in 1:t_max) {
  if (do_migration) {
    if (meta_fitness[birth_indices_meta[i],2] >= death_indices_niche[i]) {
      island[death_indices_niche[i], death_indices_individual[i]] = meta_fitness[birth_indices_meta[i]]
    } else {
      island[death_indices_niche[i], death_indices_individual[i]] = 0
    }
  } else {
    island[death_indices_niche]
  }
}
