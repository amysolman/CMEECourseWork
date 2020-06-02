#Neutral Simulation Local Run

rm(list=ls())
graphics.off()

#install.packages("untb") #package to generate an equilibrium metacommunity
library(untb)

source("neutral_sim_timeseries_noindices.R")

#Generate equilibrium meta community

get_my_meta <- function(size_ecosystem, num_species, max_num_abundance_classes) {
  J_Meta = fisher.ecosystem(size_ecosystem, num_species, max_num_abundance_classes) #size of ecosystem, number of species,
  #max num species abundance classes to consider
  Meta <- vector()
  for (s in 1:nrow(J_Meta)) {
    num <- J_Meta[[s]]
    com <- rep(s, num)
    Meta <- c(Meta, com)
  }
  
  return(Meta)
}

Meta = get_my_meta(10000, 100, 1000)

iter <- 1 

i <- iter

set.seed(i)

output_file_name = paste0("simulation_timeseries_local", i, ".rda")

cluster_run_function(nu = 0.001, islands = 10, wall_time = 5, output_file_name = output_file_name)
