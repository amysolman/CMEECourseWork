# one set of results as a list from all your cluster runs put together.

#That is the four sets of octaves in a list of 4 vectors as the only thing saved in an RDA file.

##########CODE TO IMPORT RESULTS#########

# octave_500 <- list() #create empty lists for each octave
# octave_1000 <- list()
# octave_2500 <- list()
# octave_5000 <- list()
# 
# ##########LOAD SPECIES OCTAVES AND RICHNESS BY SIMULATION SIZE###########
# for (i in 1:100) {
#   loaded <- load(paste0("simulation_",i,".rda"))
#   if (size == 500) {
#     octave_500[[i]] <- species_octaves_list
#   } else {
#     if (size == 1000) {
#       octave_1000[[i]] <- species_octaves_list
#     } else {
#       if (size == 2500) {
#         octave_2500[[i]] <- species_octaves_list
#       } else {
#         if (size == 5000) {
#           octave_5000[[i]] <- species_octaves_list
#         }
#       }
#     }
#   }
#   
# }
# 
# ##########REMOVE NULL VALUES#########
# 
# l1 <- lapply(octave_1000, function(x) x[lengths(x) > 0])
# octave_1000 <- l1[lengths(l1) >  0]
# 
# l1 <- lapply(octave_2500, function(x) x[lengths(x) > 0])
# octave_2500 <- l1[lengths(l1) >  0]
# 
# l1 <- lapply(octave_500, function(x) x[lengths(x) > 0])
# octave_500 <- l1[lengths(l1) >  0]
# 
# l1 <- lapply(octave_5000, function(x) x[lengths(x) > 0])
# octave_5000 <- l1[lengths(l1) >  0]

# rm(l1)
# rm(species_octaves_list)
# rm(species_richness_list)
# rm(burn_in_generations)
# rm(community)
# rm(i)
# rm(interval_oct)
# rm(interval_rich)
# rm(loaded)
# rm(size)
# rm(speciation_rate)
# rm(total_time)
# rm(x)
# rm(y)

save(octave_500, octave_1000, octave_2500, octave_5000, file = "asolman_cluster_results.rda")
