library("ggplot2")
library("gridExtra")

rm(list=ls())
graphics.off()

#read in 100 simulations
my_results <- list()
for (i in 1:100) {
  load(paste0(file="simulation_timeseries_", i, ".rda"))
  my_results[[i]] <- my_indices
} 

sim_results <- list()
final_richness <- list()
sim_final_rich <- list()

for (s in 1:length(my_results)) {
  
  #how many species at the end
  timeseries <- list()
  
  #seperate out timeseries for each island in simulation
  for (j in 1:length(my_results[[s]])) {
    my_island <- my_results[[s]][[j]]
    timeseries[[j]] <- my_island[[2]]
  }
  
  #get migration rates
  m <- 0
  m_rate <- vector()
  for (r in 1:length(timeseries)) {
    m <- m + 0.002
    m_rate[[r]] <- m
  }
  
  df <- list()
  for (i in 1:length(timeseries)) {
    #get the final species richness from the end of the timeseries
    final_richness[[i]] <- tail(timeseries[[i]], n=1)
    
    #cut down the timeseries and put in a df for plotting
    species_richness <- unlist(timeseries[[i]])
    migration_rate <- rep(m_rate[[i]], length(species_richness))
    timestep <- seq(from = 0, to = length(timeseries[[1]]), by = 1000)
    df[[i]] <- cbind(migration_rate, timestep, species_richness)
  } 
  
  sim_final_rich[[s]] <- final_richness 
  sim_results[[s]] <- as.data.frame(do.call("rbind", df)) #timeseries dataframe
}

#plot three of our simulations to check they reached equilibrium
plot_data_a <- sim_results[[1]]
plot_data_b <- sim_results[[50]]
plot_data_c <- sim_results[[100]]

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

simulation <- rep(1:100, each=5)
date <- rep(010620, 500)
timesteps <- rep(timesteps, 500)
m <- rep(m_rate, 100)
area <- m*10000
nu <- rep(0.01, 500)
K <- m*1000
data <- data.frame(simulation=simulation, date=date, timesteps=timesteps, m=m, area=area, Js=area, nu=nu, K=K, sp_rich=species_richness_vector)


write.csv(data, "../../Results/SimResults010620.csv", row.names = FALSE)
