#parameters plot

rm(list=ls())

data <- read.csv("../../Data/SimData/ModData2.csv")

store <- list()

for (i in 1:length(unique(data$ID2))) {
  parameters <- data[data$ID2 == i, ]
  parameters <- parameters[1, ][, 5:8]
  #parameters <- parameters[,c(1, 3, 4, 2)]
  #names(parameters) <- c("MigrationRates", "NumberOfNiches", "SizeOfNiches", "Area")
  store[[i]] <- parameters
}

my_parameters <- do.call("rbind", store)

write.csv(my_parameters, "../../Results/Simulation2/Parameters.csv", row.names = FALSE)
