#Let's plot our mean simulation data with model estimates
rm(list=ls())
graphics.off()

library("ggplot2")

#First import my data

Solman <- read.csv("../../Results/Simulation/SolmanMean_1.csv")

#now define the model function

chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#create empty list for storing estimated species richness
Chisholm_Est <- vector()

for (i in 1: nrow(Solman)) {
  data <- Solman[i, ]
  m = data$migration_rate
  area = data$area
  J = area
  m0 = m*sqrt(area)
  nu = 0.001
  theta = 2*J*nu
  K = data$niches
  Chisholm_Est[[i]] <- round(chisholm_model(area, theta, m0, K), digits = 2)
}

Chisholm_Est <- cbind.data.frame(Solman[, 1:3], Chisholm_Est)
Solman$SimOrMod <- rep("Solman", nrow(Solman))
colnames(Solman)[4] <- "Species_Rich"
Chisholm_Est$SimOrMod <- rep("Chisholm", nrow(Chisholm_Est))
colnames(Chisholm_Est)[4] <- "Species_Rich"

unique_areas <- unique(Solman$area)

df <- data.frame(area = integer(), Species_Rich = integer(), niches = integer(), migration = integer(), SimOrMod = character())

for (a in 1:length(unique_areas)) {
  area <- unique_areas[a]
  data <- Solman[Solman$area == area, ]
  Species_Rich <- mean(data$Species_Rich)
  niches <- mean(data$niches)
  migration <- mean(data$migration_rate)
  SimOrMod <- "Solman"
  new_df <- data.frame(area, Species_Rich, niches, migration, SimOrMod)
  df <- rbind(df, new_df)
}

#export those final mean results
write.csv(df, "../../Results/Simulation/TotalMeanResults.csv", row.names = FALSE)

unique_areas <- unique(Chisholm_Est$area)

for (a in 1:length(unique_areas)) {
  area <- unique_areas[a]
  data <- Chisholm_Est[Chisholm_Est$area == area, ]
  Species_Rich <- mean(data$Species_Rich)
  niches <- mean(data$niches)
  migration <- mean(data$migration_rate)
  SimOrMod <- "Chisholm"
  new_df <- data.frame(area, Species_Rich, niches, migration, SimOrMod)
  df <- rbind(df, new_df)
}




TotalData <- rbind(Solman, Chisholm_Est)

p1 <- ggplot(df, aes(x=area, y = Species_Rich, group = SimOrMod)) +
  geom_point(aes(colour=SimOrMod)) +
  labs(colour = "Simulation (Solman) \n or Model (Chisholm)") +
  labs(x = "Island Area", y = "Species Richness") +
  labs(title = "Mean species richness for Solman SAR (species-area relationship) simulation \nplotted with Chisholm model estimates") +
  theme_bw()

pdf("../../Results/Simulation/MeanResultsPlot.pdf")
print(p1)
dev.off()

