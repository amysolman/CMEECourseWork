######SCRIPT TO DO INITIAL PLOTS OF DATASETS#######

rm(list=ls())
graphics.off()

library("ggplot2")

#read in data 

MyData <- read.csv("../../Data/TotalData.csv")

#these studies mostly deal with area but some deal with volume instead. 
#I'm going to start by seperating out the datasets that deal with area from those
#that deal with volume and plot them seperately - careful not to log data that is already logged!

#start by plotting each dataset to get a view of what we're working with

#which datasets have area values?
MyAreaData <- MyData[!is.na(MyData$area.metric),]

#this gives us the datasets that have volume data only
MyVolumeData <- MyData[!is.na(MyData$volume.metric),]
MyVolumeData <- MyVolumeData[is.na(MyVolumeData$area.metric),]

#we also have one dataset that only gives us a distance metric
MyDistanceData <- MyData[!is.na(MyData$distance.metric),]
MyDistanceData <- MyDistanceData[is.na(MyDistanceData$area.metric),]
MyDistanceData <- MyDistanceData[is.na(MyDistanceData$volume.metric),]

#let's plot the datasets with area metrics

my_plots <- list() #store my plots

for (i in 1:length(unique(MyAreaData$ID))) {
  
  ID <- unique(MyAreaData$ID)[i] #pick an ID based on the index of i
  
  data <- MyAreaData[MyAreaData$ID == ID, ] #seperate out the dataset
  
  author = paste(as.character(data$author[1]), as.character(data$year[1])) #get author and year details
  
  p <- ggplot(data, aes(x = area, y = sp.rich)) +
    geom_point()+
    ggtitle(paste(author, substr(data$title, start = 1, stop = 45), "...")) +
    xlab(paste("log(area)", data$area.metric)) +
    ylab(paste("richness (", data$sp.rich.metric, ")")) +
    theme_bw()
  
  if (data$log.area[1]=="no"){
    p = p + scale_x_log10()
  }

  file_name = paste("../../Results/dataset_", author, ".pdf", sep="")
  pdf(file_name)
  print(p)
  dev.off()
  
}

###PLOT THE VOLUME DATASETS###

my_plots <- list() #store my plots

for (i in 1:length(unique(MyVolumeData$ID))) {
  
  ID <- unique(MyVolumeData$ID)[i] #pick an ID based on the index of i
  
  data <- MyVolumeData[MyVolumeData$ID == ID, ] #seperate out the dataset
  
  author = paste(as.character(data$author[1]), as.character(data$year[1])) #get author and year details
  
  p <- ggplot(data, aes(x = volume, y = sp.rich)) +
    geom_point()+
    ggtitle(paste(author, substr(data$title, start = 1, stop = 45), "...")) +
    xlab(paste("log(volume)", data$volume.metric)) +
    ylab(paste("richness (", data$sp.rich.metric, ")")) +
    theme_bw()
  
  if (data$log.volume[1]=="no"){
    p = p + scale_x_log10()
  }
  
  file_name = paste("../../Results/dataset_", author, ".pdf", sep="")
  pdf(file_name)
  print(p)
  dev.off()
  
}

####AND OUR DISTANCE DATASET#####

my_plots <- list() #store my plots

for (i in 1:length(unique(MyDistanceData$ID))) {
  
  ID <- unique(MyDistanceData$ID)[i] #pick an ID based on the index of i
  
  data <- MyDistanceData[MyDistanceData$ID == ID, ] #seperate out the dataset
  
  author = paste(as.character(data$author[1]), as.character(data$year[1])) #get author and year details
  
  p <- ggplot(data, aes(x = area, y = sp.rich)) +
    geom_point()+
    ggtitle(paste(author, substr(data$title, start = 1, stop = 45), "...")) +
    xlab(paste("log(distance)", data$distance.metric)) +
    ylab(paste("richness (", data$sp.rich.metric, ")")) +
    theme_bw()
  
  if (data$log.distance[1]=="no"){
    p = p + scale_x_log10()
  }
  
  file_name = paste("../../Results/dataset_", author, ".pdf", sep="")
  pdf(file_name)
  print(p)
  dev.off()
  
}
