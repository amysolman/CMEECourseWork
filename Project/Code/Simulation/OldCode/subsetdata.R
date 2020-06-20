rm(list=ls())
graphics.off()

data <- read.csv("../../Results/Simulation/SolmanMean_20.csv")
data <- read.csv("../../Data/SimData/SimModelFitData.csv")

data2 <- data[data$area < 10, ]
data1 <- data[data$K_num == 1, ]
data2 <- data1[data1$migration_rates < 0.01, ]

  ggplot(data2, aes(x=log(area), y = log(island_species))) +
  geom_point() +
  labs(colour = "Simulation") +
  labs(x = "Island Area", y = "Species Richness") +
  #labs(title = "Mean species richness for Solman SAR (species-area relationship) 
    #simulation \nplotted with Chisholm model estimates") +
  theme_bw() +
  theme(legend.title = element_blank())
  
  
  area = seq(1:1000)
  niches = rep(1:50, each = 20)
  immigration = rep(1:200, each = 5)
  immigration = immigration
  df <- as.data.frame(cbind(area, niches, immigration))
  
  ggplot(df, aes(x = area, y = niches)) +
    geom_line()
  
  p <- ggplot(df, aes(x=area)) + 
    geom_line(aes(y = niches), color = "red") + 
    geom_line(aes(y = immigration), color="blue") +
    theme_bw() +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())
  
  pdf("../../Other/plot4presentation.pdf")
  print(p)
  dev.off()
    
    
  