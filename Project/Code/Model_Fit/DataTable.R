##script to generate dataset summary table
rm(list=ls())
graphics.off()

library(dplyr)

#read in the datasets
Data <- read.csv("../../Data/FinalData.csv")

#Reduce each dataset to first line
df <- list()
for (i in 1:length(unique(Data$datasetID))){
  my_data <- Data[Data$datasetID == i, ]
  df[[i]] <- my_data[1, ]
}

#bind rows
df <- do.call("rbind", df)

#sort data by taxa and habitat type
x <- df %>% group_by(taxa, archipelago_type) %>% 
  tally()

#change column names
colnames(x) <- c("Taxa", "Habitat Type", "Occurences")

#export
write.csv(x, "../../Other/FinalReport/SummaryTab.csv", row.names=FALSE, quote=FALSE)

