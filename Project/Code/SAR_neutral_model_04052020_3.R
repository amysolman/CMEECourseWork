rm(list=ls())
graphics.off()

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
m = 0.005

#initial species counter
S_curr = 1

#compute island death indices, metacommunity/island birth indices and speciation/migration indicies
death_indices = sample(J_island, t_max, replace = T)
birth_indices_island = sample(J_island, t_max, replace = T)
birth_indices_meta = sample(J_meta, t_max, replace = T)
do_speciation = rbinom(t_max, 1, nu)
do_migration = rbinom(t_max, 1, m)

#function to perform one time step on one niche - i = timestep number
#returns the number of unique species
simulation_one_timestep <- function(i) {
  
  if (do_speciation[i]) {
    Island[death_indices[i]] <<- S_curr + 1
    S_curr <<- S_curr + 1
  } else if (do_migration[i]) {
    Island[death_indices[i]] <<- Meta[birth_indices_meta[i]]
  } else {
    Island[death_indices[i]] <<- Island[birth_indices_island[i]]
  }
  
  return(length(unique(Island)))

}

#function to run multiple timesteps of the simulation
#and return the final species richness

multi_timestep <- function(t_max) {
  for (i in 1:t_max) {
    simulation_one_timestep(i)
  }
  return(length(unique(Island)))
}

#function to run t_max number of timesteps of simulation
#for 100 different migration rates (m)
#retuning species richness for each migration rate
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

#run simulation for t_max timesteps and for multiple migration rates
migration_multi_timestep()

#plot species richness and migration rate
migration_rate = seq(0.001, 0.1, by = 0.001)
plot(migration_rate, species_richness, log='y', type='l')


#create loop to run simulation multiple time steps, 
#store species abundance
#run second time and sum those abundances together

species_abundance <- list()
 
#run the simulation t_max number of times and store the unique species
#IDs in species_abundance

for (x in 1:10) {
  multi_timestep(t_max)
  species_abundance[[x]] <- c(unique(Island))
}

niche_one <- length(unique(species_abundance[[1]]))
niche_two <- length(unique(species_abundance[[2]]))
niche_three <- length(unique(species_abundance[[3]]))
niche_four <- length(unique(species_abundance[[4]]))
niche_five <- length(unique(species_abundance[[5]]))
niche_six <- length(unique(species_abundance[[6]]))
niche_seven <- length(unique(species_abundance[[7]]))
niche_eight <- length(unique(species_abundance[[8]]))
niche_nine <- length(unique(species_abundance[[9]]))
niche_ten <- length(unique(species_abundance[[10]]))

species_richness_one_niche <- niche_one
species_richness_two_niches <- niche_one + niche_two
species_richness_three_niches <- species_richness_two_niches + niche_three
species_richness_four_niches <- species_richness_three_niches + niche_four
species_richness_five_niches <- species_richness_four_niches + niche_five
species_richness_six_niches <- species_richness_five_niches + niche_six
species_richness_seven_niches <- species_richness_six_niches + niche_seven
species_richness_eight_niches <- species_richness_seven_niches + niche_eight
species_richness_nine_niches <- species_richness_eight_niches + niche_nine
species_richness_ten_niches <- species_richness_nine_niches + niche_ten

niche_richness <- c(species_richness_one_niche, species_richness_two_niches, species_richness_three_niches, species_richness_four_niches, species_richness_five_niches, species_richness_six_niches, species_richness_seven_niches, species_richness_eight_niches, species_richness_nine_niches, species_richness_ten_niches)


niches = seq(1:10)

plot(niches, niche_richness, log='y', type='l')



