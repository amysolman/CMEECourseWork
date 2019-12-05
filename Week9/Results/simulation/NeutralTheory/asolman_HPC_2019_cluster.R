# CMEE 2019 HPC excercises R code HPC run code proforma
# Amy Solman amy.solman19@imperial.ac.uk
# 28th November 2019
# question18.R

rm(list=ls())
graphics.off()

#Load all the functions you need by sourcing your main R fail
source("asolman_HPC_2019_main.R")

#Read in the job number from the cluster. To do this your code should include a new variable iter
#and should start with the line:
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX")) #will not work on local machine, instead set iter for yourself

#iter <- 5

i = iter

set.seed(i) 

# if (iter <= 25) {
#   size = 500
# } else {
#   if (iter <= 50)
#     size = 1000
# } else {
#   if (iter <= 75)
#     size = 2500
# } else {
#   if (iter <= 100)
#     size = 5000
# }

sizevect <- c(500, 1000, 2500, 5000) #more efficient version of the above
size = sizevect[(iter %% 4) + 1]

output_file_name = paste0("simulation_",i,".rda") 

cluster_run(speciation_rate = 0.005043, size = size, wall_time = 690, interval_rich = 1, interval_oct = size/10, 
            burn_in_generations = 8*size, output_file_name = output_file_name)
