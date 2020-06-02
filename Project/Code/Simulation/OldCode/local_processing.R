rm(list=ls())
graphics.off()

library("ggplot2")
library("gridExtra")



#read in local simulation
for (i in 1) {
  load(paste0(file="simulation_timeseries_local", i, ".rda"))
} 

sim_results <- list()
final_richness <- list()
sim_final_rich <- list()
timeseries <- list()
  
  #seperate out timeseries for each island in simulation
  for (s in 1:length(my_indices)) {
    my_island <- my_indices[[s]]
    timeseries[[s]] <- my_island[[2]]
  }
  
  #get migration rates
  m <- 0
  m_rate <- vector()
  for (r in 1:length(timeseries)) {
    m <- m + 0.002
    m_rate[[r]] <- m
  }
  
  #create dataframe for each island
  df <- list()
  for (i in 1:length(timeseries)) {
    #get the final species richness from the end of the timeseries
    final_richness[[i]] <- tail(timeseries[[i]], n=1)
    migration_rate <- rep(m_rate[[i]], length(timeseries))
    timestep <- seq(from = 0, to = (length(timeseries[[1]])-1)*10000, by = 10000)
    species_richness <- unlist(timeseries[[i]])
    df[[i]] <- cbind(migration_rate, timestep, species_richness)
  } 
  
  sim_final_rich <- final_richness 
  sim_results <- as.data.frame(do.call("rbind", df)) #timeseries dataframe

#plot three of our simulations to check they reached equilibrium
plot_data_a <- sim_results[sim_results$migration_rate == 0.002, ]
plot_data_b <- sim_results[sim_results$migration_rate == 0.010, ]
plot_data_c <- sim_results[sim_results$migration_rate == 0.016, ]

a<-ggplot(plot_data_a, aes(x=timestep, y=species_richness, group=migration_rate)) +
  geom_line(aes(color=migration_rate, group=migration_rate))+
  geom_point(aes(color=migration_rate, group=migration_rate)) +
  scale_colour_gradientn(colours=rainbow(10))

b<-ggplot(plot_data_b, aes(x=timestep, y=species_richness, group=migration_rate)) +
  geom_line(aes(color=migration_rate, group=migration_rate))+
  geom_point(aes(color=migration_rate, group=migration_rate)) +
  scale_colour_gradientn(colours=rainbow(10))

c<-ggplot(plot_data_c, aes(x=timestep, y=species_richness, group=migration_rate)) +
  geom_line(aes(color=migration_rate, group=migration_rate))+
  geom_point(aes(color=migration_rate, group=migration_rate)) +
  scale_colour_gradientn(colours=rainbow(10))

grid.arrange(a, b, c, nrow = 3)

#final species richnesses dataframe 
#ready for exporting and running with Ryan's model in next step

species_richness_vector <- vector()
for (i in 1:length(sim_final_rich)) {
  species_richness <- unlist(sim_final_rich[[i]])
  species_richness_vector <- c(species_richness_vector, species_richness)
}

simulation <- rep(1, 10)
date <- rep(010620, 10)
timesteps <- rep(timesteps, 10)
m <- m_rate
area <- m*10000
nu <- rep(0.001, 10)
K <- m*1000
data <- data.frame(simulation=simulation, date=date, timesteps=timesteps, m=m, area=area, Js=area, nu=nu, K=K, sp_rich=species_richness_vector)


write.csv(data, "../../Results/SimResults010620.csv", row.names = FALSE)
