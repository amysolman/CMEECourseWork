#Sunday 1st June 2020
#Script to call simulation functions and run on the cluster

rm(list=ls())
graphics.off()

source("Simulation_area.R")

#Read in the job number from the cluster. To do this your code should include a new variable iter
#and should start with the line:

#iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))  #this will not work on a local machine
#so to run locally we set the value of iter for ourselves

iter <- 1 

i <- iter

set.seed(i)

output_file_name = paste0("simulation_area_test_", i, ".rda")

cluster_run_function(nu = 0.1, m0 = 0.9, num_islands = 10, k = 10, wall_time = 10, output_file_name = output_file_name)
