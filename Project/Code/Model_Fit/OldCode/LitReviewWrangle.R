#script for wrangling and producing table of lit data

rm(list=ls())
graphics.off()

#import data
data_info <- read.csv("../../Other/FinalReport/LitReview.csv")
data_info$Author <- as.character(data_info$Author)
data_info$Title <- as.character(data_info$Title)
data_info$Aquatic.Terrestrial <- as.character(data_info$Aquatic.Terrestrial)
data_info$In.situ.Lab <- as.character(data_info$In.situ.Lab)


write.csv(data_info, "../../Other/FinalReport/Literature.csv", row.names=FALSE) 
