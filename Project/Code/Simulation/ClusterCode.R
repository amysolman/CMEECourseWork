#Sunday 1st June 2020
#Script to call simulation functions and run on the cluster

rm(list=ls())
graphics.off()

source("SimTimeseries.R")

#Read in the job number from the cluster. To do this your code should include a new variable iter
#and should start with the line:

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))  #this will not work on a local machine
#so to run locally we set the value of iter for ourselves

#iter <- 1 

i <- iter

set.seed(i)

output_file_name = paste0("simulation_timeseries_", i, ".rda")

#function takes the size of the metacommunity we want to create,
#the speciation rate, the number of different migration rates we want to simulate,
#the max number of different niches for each migration rate we want to simulation,
#the wall time and output file name

cluster_run_function(J_meta = 10000, nu = 0.001, num_m_rates = 50, max_K = 20, wall_time = 60, output_file_name = output_file_name)

