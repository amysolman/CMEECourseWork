#Sunday 1st June 2020
#Script to call simulation functions and run on the cluster

rm(list=ls())
graphics.off()

source("ClusterArchipelago.R")

#Read in the job number from the cluster. To do this your code should include a new variable iter
#and should start with the line:

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))  #this will not work on a local machine
#so to run locally we set the value of iter for ourselves

#iter <- 1 

i <- iter

set.seed(i)

output_file_name = paste0("simulation_timeseries_", i, ".rda")

cluster_run_function(J_meta = 10000000, nu = 0.01, m = 0.05, max_k_size = 100, k = 20, wall_time = 20, output_file_name = output_file_name)

