#FUNCTION FOUR
#returns community at each time step for each niche on an island with given migration rate

neutral_time_series_one_island <- function(m, t_max, nu) {
  store_my_indices <- list()
  store_my_niche_communities <- list()
  num_niches <- m*1000 #this tells us how many niches we need to simulate for this
  #particular island
  
  for (n in 1:num_niches) {
    #calculate indicies for each niche
    store_my_indices[[n]] <- indices(m, t_max, nu) #calculate the starting community/idices
  }
  
  for (j in 1:num_niches) { #for each niche
    unpack_me(store_my_indices[[j]]) #upack the indices
    
    series <- list()
    
    for (i in 1:t_max)  { #run the simulation on that niche for t_max timesteps
      y <- simulation_one_timestep(i) 
      series[[i]] <- y #store that niche community at each timestep in series
    }
    
    store_my_niche_communities[[j]] <- series
    
  }
  
  return(store_my_niche_communities)
}