#get analytic results for multi archipelago simulation

rm(list=ls())
graphics.off()

data <- read.csv("../../../Results/total_sim_results.csv")

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

for (i in 1:nrow(data)) { #for each row of the dataframe
  island <- data[i, ]
  m = island$immigration
  area = island$area
  J = area
  m0 = m/sqrt(area)
  nu = 0.01
  J_meta = 10000000 #size of metacommunity that supplied island immigrants
  K = island$niches
  #theta = 2*(niche_size*K)*nu #2*the metacommunity size immigrating to the island*nu
  theta = nu*(J_meta-1)/(1-nu) #should I use J_meta or the niche size?
  model_species[[i]] <- round(chisholm_model(area, theta, m0, K), digits = 2)
}

#bind results to single dataframe
# Data <- cbind.data.frame(data, theta)
# Data$SimOrAnalytic <- "simulation"
# names(Data) <- c("area", "species", "migration", "niches", "theta", "SimOrAnalytic")
# Data2 <- Data[, -c(2)]
# Data2 <- cbind.data.frame(Data2, model_species)
# Data2 <- Data2[c(1,6,2,3,4, 5)]
# Data2$SimOrAnalytic <- "analytic"
# names(Data2) <- c("area", "species", "migration", "niches", "theta", "SimOrAnalytic")
# Data <- rbind(Data, Data2)
# 

# 
# p<-ggplot(Data, aes(x=log(area), y=species, group=SimOrAnalytic)) +
#   geom_line(aes(color=SimOrAnalytic))+
#   geom_point(aes(color=SimOrAnalytic)) +
#   theme_bw()

Data <- cbind.data.frame(data, theta, model_species) #bind theta and model species in with the dataframe
Data <- Data[c(1,6,2,3,4,5,7)] #rearrange columns
Data$difference <- (Data$species - Data$model_species)

write.csv(Data, "../../../Results/Simulation2/MultiSimAnalyticData.csv", row.names = FALSE)

# pdf("../../../Results/Simulation2/MultiMeanResultsPlot.pdf")
# print(p1)
# dev.off()