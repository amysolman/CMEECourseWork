#script to get analytic results of one archipelago 
#from the simulation
rm(list=ls())
graphics.off()

#BE AWARE OF THE SLIGHT CHANGE TO THE MODEL IN REGARDS TO M RATE

library("ggplot2")

#FUNCTION TO READ IN SIMULATIONS#
#read in 100 simulations
ImportMyData <- function() {
  my_sims <- list()
  for (i in 1:100) {
    try(load(paste0(file="../../../Data/SimData/1stJuly/simulation_timeseries_", i, ".rda")), silent = T) 
    my_sims[[i]] <- store_my_islands
  } 
  
  return(my_sims)
}

#Import the data
data <- ImportMyData()

#get the migration rate and number of niches for the archipelago
migration_rate <- data[[1]][[1]][[1]][[1]]$do_migration
num_niches <- length(data[[1]][[1]][[1]])

#find the archipelago mean
get_my_mean <- function() {
  
  island_mean <- vector()
  
  for (j in 1:length(data[[1]])) {
    
    z <- vector()
    
    for (i in 1:length(data)) {
      x <- data[[i]][[j]][[2]]
      y <- tail(x, n=1)
      z <- c(z, y)
    }
    
    island_mean[[j]] <- mean(z)
  }
  
  return(island_mean)
}

#function to get island areas

get_my_areas <- function() {
  
  area <- vector() #create empty list for storing island areas
  for (i in 1:length(data[[1]])) {
    area[[i]] <- length(data[[1]][[i]][[1]][[1]]$Niche)*num_niches
  }
  return(area)
}

#bind our data into a dataframe
island_mean <- get_my_mean()
area <- get_my_areas()
mean_data <- data.frame(area, island_mean)
mean_data$migration <- migration_rate
mean_data$niches <- num_niches

#what estimates does the model give with these parameters?

#define the model function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0*sqrt(area) #changed this from m0/sqrt(area) to m0*sqrt(area)??? 
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}


model_species <- vector()

#Simulation and analytic results the same regardless of which
#estimation of theta is used

for (i in 1:nrow(mean_data)) {
  data <- mean_data[i, ]
  m = data$migration
  area = data$area
  J = area
  m0 = m/sqrt(area)
  nu = 0.01
  J_meta = 10000000 #size of metacommunity that supplied island immigrants
  K = data$niches
  #niche_size = J_meta/K #size of each niche in the metacommunity
  #theta = 2*(niche_size*K)*nu #2*the metacommunity size immigrating to the island*nu
  theta = nu*(J_meta-1)/(1-nu)
  model_species[[i]] <- round(chisholm_model(area, theta, m0, K), digits = 2)
}

#bind results to single dataframe
Data <- cbind.data.frame(mean_data, theta)
Data$SimOrAnalytic <- "simulation"
names(Data) <- c("area", "species", "migration", "niches", "theta", "SimOrAnalytic")
Data2 <- Data[, -c(2)]
Data2 <- cbind.data.frame(Data2, model_species)
Data2 <- Data2[c(1,6,2,3,4, 5)]
Data2$SimOrAnalytic <- "analytic"
names(Data2) <- c("area", "species", "migration", "niches", "theta", "SimOrAnalytic")
Data <- rbind(Data, Data2)

write.csv(Data, "../../../Results/Simulation2/SimAnalyticData_changed.csv")

p<-ggplot(Data, aes(x=log(area), y=species, group=SimOrAnalytic)) +
  geom_line(aes(color=SimOrAnalytic))+
  geom_point(aes(color=SimOrAnalytic)) +
  theme_bw()


pdf("../../../Results/Simulation2/MeanResultsPlot_changed.pdf")
print(p1)
dev.off()

