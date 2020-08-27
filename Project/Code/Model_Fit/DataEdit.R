#R script to check for correlation between area and species in the datasets
rm(list=ls())
graphics.off()
library("ggpubr")

#1) Read in the full data set
MyData <- read.csv("../../Data/FinalData.csv")

#add log area column
MyData$logArea <- log(MyData$area)

#List for storing spearman rank correlation coefficients
CorrCo <- list()

#do correlation tests for each dataset
for (i in 1:length(unique(MyData$datasetID))){
  
  Data <- MyData[MyData$datasetID == i, ]
  
  #visualise the data
  p <-ggscatter(Data, x = "logArea", y = "species", 
            add = "reg.line", conf.int = TRUE, 
            cor.coef = TRUE, cor.method = "spearman",
            xlab = "log(Area)", ylab = "Species")
  
  #do spearmans rank test
  x <- cor.test(Data$logArea, Data$species, method = "spearman")
  
  #store the rho estimate
  CorrCo[[i]] <- rep(x$estimate, nrow(Data))
  
  file_name = paste0("../../Results/SpearmansRankVisualisation", i, ".pdf")
  pdf(file_name)
  print(p)
  dev.off()
}

#unlist the correlation coefficients
CorrCo <- unlist(CorrCo)

#add the correlation coefficients to the original data frame
MyData$SpearmansCC <- CorrCo

#remove datasets with correlation <= 0
MyData <- MyData[MyData$SpearmansCC > 0, ]

#Re-number remaining datasets
newIDS <- list()
for (i in 1:length(unique(MyData$datasetID))){
  uniqueIDS <- unique(MyData$datasetID)
  Data <- MyData[MyData$datasetID == uniqueIDS[[i]], ]
  newIDS[[i]] <- rep(i, nrow(Data))
}

MyData$datasetID <- unlist(newIDS)

#Re-number remaining studies
newstudyIDs <- list()

for (i in 1:length(unique(MyData$studyID))){
  uniquestudyIDS <- unique(MyData$studyID)
  Data <- MyData[MyData$studyID == uniquestudyIDS[[i]], ]
  newstudyIDs[[i]] <- rep(i, nrow(Data))
}

#newstudyIDs <- unlist(newstudyIDs)
MyData$studyID <- unlist(newstudyIDs)

#export edited data
write.csv(MyData, "../../Data/DataEdit.csv", row.names = FALSE)

