#Sunday 1st June 2020
#Script to call simulation functions and run on the cluster

rm(list=ls())
graphics.off()

source("Simulation_peri.R")

#Read in the job number from the cluster. To do this your code should include a new variable iter
#and should start with the line:

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))  #this will not work on a local machine
#so to run locally we set the value of iter for ourselves

#iter <- 1 

i <- iter

set.seed(i)

output_file_name = paste0("simulation_peri_seven_", i, ".rda")

cluster_run_function(nu = 0.00007, m0 = 0.6, num_islands = 20, k = 35, wall_time = 1440, output_file_name = output_file_name)

