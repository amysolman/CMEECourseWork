#Tuesday 19th May 2020
#Script to call simulation functions and run on the cluster

rm(list=ls())
graphics.off()

source("neutral_island_simulation.R")

#Read in the job number from the cluster. To do this your code should include a new variable iter
#and should start with the line:

#iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))  #this will not work on a local machine
#so to run locally we set the value of iter for ourselves

iter <- 29

i = iter

set.seed(i)

output_file_name = paste0("simulation_test", i, ".rda")
#outout_file_name = paste0("simulation_test", i, ".rda")

cluster_run_function(0.02, wall_time = 10, output_file_name = output_file_name)

