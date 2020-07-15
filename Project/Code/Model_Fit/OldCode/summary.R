#r script for summarising microbial species area data

rm(list=ls())
graphics.off()

#import data

data <- read.csv("../../Data/TotalData.csv")

#how many aquatic datasets are fresh or saline?
aqua_data <- data[data$aqua.terra == "aqua", ]
type <- vector()
for (i in 1:length(unique(aqua_data$ID))){
  IDs <- unique(aqua_data$ID) #get unique ids
  dataset <- aqua_data[aqua_data$ID == IDs[i], ] #for each unique id
  type[[i]] <- as.character(dataset$fresh.saline[1])
}

fresh_saline <- data.frame(table(type)) #results as df
fresh_saline$terra <- 0 #add column of NAs
colnames(fresh_saline) <- c("attribute", "aqua", "terra")

#how many datasets are in-situ/lab, natural/modified, isolated/continuous,
#include archaea, bacteria, fungi, algae, protozoa, pathogens

get_my_summary <- function(subset_data){
  
  situ_lab <- vector()
  nat_mod <- vector()
  iso_cont <- vector()
  archaea <- vector()
  bacteria <- vector()
  fungi <- vector()
  algae <- vector()
  protozoa <- vector()
  pathogens <- vector()
  
  for (i in 1:length(unique(subset_data$ID))) { #for each aquatic dataset
    IDs <- unique(subset_data$ID) #get unique ids
    dataset <- subset_data[subset_data$ID == IDs[i], ] #for each unique id
    situ_lab[[i]] <- as.character(dataset$in.situ.lab[1])
    nat_mod[[i]] <- as.character(dataset$natural.modified[1])
    iso_cont[[i]] <- as.character(dataset$isolated.continuous[1])
    archaea[[i]] <- as.character(dataset$archaea[1])
    bacteria[[i]] <- as.character(dataset$bacteria[1])
    fungi[[i]] <- as.character(dataset$fungi[1])
    algae[[i]] <- as.character(dataset$algae[1])
    protozoa[[i]] <- as.character(dataset$protozoa[1])
    pathogens[[i]] <- as.character(dataset$pathogens[1])
  }
  
  situ_lab <- data.frame(table(situ_lab))
  colnames(situ_lab) <- c("attribute", "my_data")
  nat_mod <- data.frame(table(nat_mod))
  colnames(nat_mod) <- c("attribute", "my_data")
  iso_cont <- data.frame(table(iso_cont))
  colnames(iso_cont) <- c("attribute", "my_data")
  archaea <- as.numeric(table(archaea)[2])
  bacteria <- as.numeric(table(bacteria)[2])
  fungi <- as.numeric(table(fungi)[2])
  algae <- as.numeric(table(algae)[2])
  protozoa <- as.numeric(table(protozoa)[2])
  pathogens <- as.numeric(table(pathogens)[2])
  
  attributes <- c("archaea", "bacteria", "fungi", "algae", "protozoa", "pathogens")
  my_data <- c(archaea, bacteria, fungi, algae, protozoa, pathogens)
  taxa <- data.frame(cbind(attributes, my_data))
  colnames(taxa) <- c("attribute", "my_data")
  all <- rbind(situ_lab, nat_mod, iso_cont, taxa)
  
  return(all)
  
}

#subset data by terra
terra_data <- data[data$aqua.terra == "terra", ]

all_aqua <- get_my_summary(subset_data = aqua_data) #get our aqua summary
all_terra <- get_my_summary(subset_data = terra_data) #get our terra summary

colnames(all_aqua) <- c("attribute", "aqua") #rename the columns
colnames(all_terra) <- c("attribute", "terra")

all_aqua$terra <- all_terra$terra #add the terra data to the aqua data

final <- rbind(fresh_saline, all_aqua) #bind the results

#how many datasets are aquatic or terrestrial?
type <- vector()
for (i in 1:length(unique(data$ID))) {
  dataset <- data[data$ID == i, ]
  type[[i]] <- as.character(dataset$aqua.terra[1])
}

aqua_terra <- (table(type)) #put data into table
df <- data.frame(rbind(aqua_terra)) #rbind into dataframe
rownames(df) <- NULL
df$attribute <- "total"
df <- df[,c(3,1,2)] #rearrange columns

final <- rbind(final, df) #final dataframe bind
final[is.na(final)] <- 0 #make all NAs into 0s
final_edit <- as.data.frame(final[, 2:3]) #remove character column
totals <- rowSums(sapply(final_edit, as.numeric)) #get totals

#add total column
final$total <- totals

#export csv

write.csv(final, "../../Other/FinalReport/summary_stats.csv", row.names = FALSE, quote = FALSE)
