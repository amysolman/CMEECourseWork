#function that does pop size on island as function of migration rate
rm(list=ls())
graphics.off()

#install.packages("ggplot2")
library("ggplot2")

#function to give island size as a function of migration rate
island_size <- function(m) {
  J_island = m*10000
  return(J_island)
}

#function to give starting homogenous island community as a function of island size
island_com <- function(m) {
  J_island = island_size(m)
  Island = rep(1, J_island)
  return(Island)
}

#function to give birth/death/speciation and migration indices as a function of migration rate,
#number of timesteps and speciation rate
indices <- function(m, t_max, nu) {
  J_meta = 1000
  Meta = 1:J_meta
  J_island = island_size(m)
  Island = island_com(m)
  death_indices = sample(J_island, t_max, replace = T)
  birth_indices_island = sample(J_island, t_max, replace = T)
  birth_indices_meta = sample(J_meta, t_max, replace = T)
  do_speciation = rbinom(t_max, 1, nu)
  do_migration = rbinom(t_max, 1, m)
  index_list <- list(Meta, Island, death_indices, birth_indices_meta, birth_indices_island, do_speciation, do_migration)
  names(index_list) <- c("Meta", "Island", "death_indices", "birth_indices_meta", "birth_indices_island", "do_speciation", "do_migration")
  return(index_list)
  
}

#return all indices items from list to global values
unpack_me <- function(x) {
  list2env(x,globalenv())
}

##### FUNCTION TO RUN ONE TIMESTEP ON ONE NICHE #####
####will have to run indices and then unpack function beforehand for this to work####
#### e.g. unpack_me(indicies(0.005, 1000, 0.02)) #####
simulation_one_timestep <- function(i) {
  
  if (do_speciation[i]) {
    Island[death_indices[i]] <<- length(unique(Meta)) + 1
  } else if (do_migration[i]) {
    Island[death_indices[i]] <<- Meta[birth_indices_meta[i]]
  } else {
    Island[death_indices[i]] <<- Island[birth_indices_island[i]]
  }
  
  return(Island)
  
}

##### FUNCTION TO RUN T_MAX TIMESTEPS ON ONE NICHE #####
multi_timestep <- function(m, t_max, nu) {
  
  x <- indices(m, t_max, nu)
  unpack_me(x)
  
  for (i in 1:t_max) {
    set.seed(i)
    simulation_one_timestep(i)
  }
  return(Island)
}


###Run the simulation for a given number of timesteps and return the Island community
##for each timestep

neutral_time_series <- function(m, t_max, nu) {
  series <- vector()
  x <- indices(m, t_max, nu)
  unpack_me(x)
  for (i in 1:t_max) {
    y <- simulation_one_timestep(i)
    series <- rbind(series, y)
  }
  return(series)
}

###function to create time series for multiple migration rates
##returns list of 100 islands, with community at each timestep

timeseries_multi_migration <- function(t_max, nu) {
  
  m = 0
  my_series <- list()
  
  for (i in 1:100) {
    set.seed(i)
    m = m + 0.001
    x <- neutral_time_series(m, t_max, nu)
    my_series[[i]] <- x
  }
  
  return(my_series)
}

###preps results multiple migration rate time_series###
##for each island at each timestep, calculate and store species richness for plotting
#in next step

prep_my_multiple_migration_rate_timeseries <- function(my_series) {
  graphics.off()
  data <- my_series
  island_list <- list()
  multi_list <- list()
  
  for (i in 1:length(data)) {
    x <- data[[i]]
    
    for (j in 1:nrow(x)) {
      y <- species_richness(x[j,])
      island_list[[j]] <-  y
    }
    multi_list[[i]] <- island_list
  }
  
  return(multi_list)
}

##turn multiple timeseries lists from prep step into dataframe and plot#####

plot_multiple_migration_timeseries <- function (multi_list, t_max) {

  a <- multi_list
  df <- data.frame(matrix(ncol = 0, nrow = 0))
  
  for (x in 1:length(a)) {
    species_rich <- a[[x]]
    species_rich <- unlist(species_rich)
    
    migration_rate <- x*0.001
    timestep <- seq(1, length(species_rich))
    island_number <- rep(1:100, each=t_max)
    migration_rate <- rep(migration_rate, length(species_rich))
    new_df <- cbind.data.frame(island_number, timestep, migration_rate, species_rich)
    df <- rbind(df, new_df)
  }
  return(df)
  
  #####now plot on a graph#####
  
  ggplot(data=df, aes(x=timestep, y=species_rich, group=island_number)) +
    geom_line(aes(colour=island_number))+
    geom_point(aes(colour=island_number))
}


###Function to give time series of one island with a specified number of niches and specified
#migration rate
timeseries_multi_niches <- function(num_niches, m, t_max, nu) {
  
  store_my_niches <- list()
  
  for (i in 1:num_niches) {
    set.seed(i)
    a <- neutral_time_series(m, t_max, nu)
    store_my_niches[[i]] <- a
  }
  
  combined_niches <- do.call(cbind, store_my_niches)
  species_rich <- apply(combined_niches, 1, function(x) length(unique(x)))
  
  timestep <- seq(1, t_max)
  migration_rate <- rep(m, t_max)
  niches <- rep(num_niches, t_max)
  df <- cbind.data.frame(niches, timestep, migration_rate, species_rich)
  
  return(df)
  
}

####function to give timeseries of multiple islands with different number of niches
#but the same migration rate

multi_island_niches <- function(num_niches, m, t_max, nu) {
  
  store_my_island <- list()
  
  for (j in 1:num_niches) {
    set.seed(j)
    island <- timeseries_multi_niches(j, m, t_max, nu)
    store_my_island[[j]] <- island
  }
  
  all_my_islands <- do.call(rbind, store_my_island)
  
  return(all_my_islands)
}

####function to give timeseries of multiple islands with different numbers of niches
#and different migration rates

multi_island_niches_migrations <- function(num_niches, t_max, nu) {
  
  final_store_my_islands <- list()
  m = 0
  
  for (k in 1:50) {
    set.seed(k)
    m = m + 0.002
    multi_niche_islands <- multi_island_niches(num_niches, m, t_max, nu)
    final_store_my_islands[[k]] <- multi_niche_islands
  }
  
  final_all_my_islands <- do.call(rbind, final_store_my_islands)
  final_all_my_islands$IDs <- cumsum(!duplicated(final_all_my_islands[, -c(2, 4)]))
  
  return(final_all_my_islands)
}

#plot all my islands
#simulation 1000 timesteps took 1hr 40mins
t_max = 10000
my_data <- multi_island_niches_migrations(10, t_max, 0.02)
my_data_summary <- my_data[my_data$timestep == t_max, ]

my_plot <- ggplot(my_data, aes(x=timestep, y=species_rich, group=IDs)) +
  geom_line(aes(color=IDs, group=IDs)) +
  geom_point(aes(color=IDs))

my_summary_plot <- ggplot(my_data_summary, aes(x=migration_rate, y=species_rich, group=niches, colour=niches)) +
  geom_point()


  pdf("../Results/simulation_timeseries_plot.pdf") 
  print(my_plot)
  dev.off()
  
  pdf("../Results/simulation_results.pdf")
  print(my_summary_plot)
  dev.off()
  
  write.csv(my_data, "../Results/species_rich_migration_niches_1000timesteps.csv")
  write.csv(my_data_summary, "../Results/simulation_results.csv")
  
  

