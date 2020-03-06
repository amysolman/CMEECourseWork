# Amy Solman amy.solman19@imperial.ac.uk
# 20th November 2019
# plot_analysis.R
#Final plotting and analysis scipt

rm(list=ls())
graphics.off()

library("ggplot2")
library("plyr")
library("dplyr")

data <- read.csv("../data/modified_data.csv")
stats_results <- read.csv("../results/merged_total_stats_results.csv")
plot_results <- read.csv("../results/merged_total_plot_results.csv")

#Subset stats but model
Log <- subset(stats_results, Model == "Logistic")
Gom <- subset(stats_results, Model == "Gompertz")
Bar <- subset(stats_results, Model == "Baranyi")
Buc <- subset(stats_results, Model == "Buchanan")
Qua <- subset(stats_results, Model == "Quadratic")
Pol <- subset(stats_results, Model == "Polynomial")
Lin <- subset(stats_results, Model == "Linear")

#How many times did the model fail?
Log_NA <- sum(is.na(Log$AIC.Score))
#Percentage of failure
Log_NA_cent <- Log_NA/(nrow(Log))

#Repeat for remaining models
Gom_NA <- sum(is.na(Gom$AIC.Score))
Gom_NA_cent <- Gom_NA/(nrow(Gom))
Bar_NA <- sum(is.na(Bar$AIC.Score))
Bar_NA_cent <- Bar_NA/(nrow(Bar))
Buc_NA <- sum(is.na(Buc$AIC.Score))
Buc_NA_cent <- Buc_NA/(nrow(Buc))
Qua_NA <- sum(is.na(Qua$AIC.Score))
Qua_NA_cent <- Qua_NA/(nrow(Qua))
Pol_NA <- sum(is.na(Pol$AIC.Score))
Pol_NA_cent <- Pol_NA/(nrow(Pol))
Lin_NA <- sum(is.na(Lin$AIC.Score))
Lin_NA_cent <- Lin_NA/(nrow(Lin))



df <- data.frame(Model=sort(unique(stats_results$Model)), 
                 Fit = c((nrow(Bar)-Bar_NA), (nrow(Buc)-Buc_NA), (nrow(Gom)-Gom_NA),
                         (nrow(Lin)-Lin_NA), (nrow(Log)-Log_NA),
                         (nrow(Pol)-Pol_NA), (nrow(Qua)-Qua_NA)), 
                 Fail = c(Bar_NA, Buc_NA, Gom_NA, Lin_NA, Log_NA, Pol_NA, Qua_NA),
                 Success_Rate = c((1-Bar_NA_cent), (1-Buc_NA_cent), (1-Gom_NA_cent), (1-Lin_NA_cent), (1-Log_NA_cent), (1-Pol_NA_cent), (1-Qua_NA_cent))) 
names(df) <- c("Model", "Fit", "Fail", "Success Rate")

is.num <- sapply(df$`Success Rate`, is.numeric)
df$`Success Rate`[is.num] <- lapply(df$`Success Rate`[is.num], round, 3)
df = data.frame(lapply(df, as.character), stringsAsFactors=FALSE)

write.csv(df, ("../results/fits_fails.csv"), row.names = FALSE)

data[data==0] <- NA
data<-data[complete.cases(data$PopBio),]
data <- data[data$PopBio >= 0, ]
data <- data[data$Time >= 0, ]
data$LogN <- log(data$PopBio)
data$t <- data$Time

stats_results[stats_results==0] <- NA
stats_results<-stats_results[complete.cases(stats_results$R.Squared),]

plot_list = list()
df_list = list()

for (i in 1:((length(unique(data$ID))) - 1)) { 
  ID_df<-data[which(data$ID==i),]
  Species <- unique(ID_df$Species)
  Temp <- unique(ID_df$Temp)
  
  ID_plots <- plot_results[which(plot_results$ID==i),]
  ID_stats <- stats_results[which(stats_results$ID==i),]
  
plot_Log <- subset(ID_plots, Model == "Logistic")
plot_Gom <- subset(ID_plots, Model == "Gompertz")
plot_Bar <- subset(ID_plots, Model == "Baranyi")
plot_Buc <- subset(ID_plots, Model == "Buchanan")
plot_Qua <- subset(ID_plots, Model == "Quadratic")
plot_Pol <- subset(ID_plots, Model == "Polynomial")
plot_Lin <- subset(ID_plots, Model == "Linear")

#Plot each dataset of ID with each successful model

p <-ggplot(ID_df, aes(x=t, y=LogN)) +
  geom_point() +
  xlab("time") +
  ylab("logN") +
  theme_bw() +
  ggtitle("Population Growth", i) +
  geom_line(data = plot_Log, aes(x = t, y = LogN, colour = "Logistic")) +
  geom_line(data = plot_Gom, aes(x = t, y = LogN, colour = "Gompertz")) +
  geom_line(data = plot_Bar, aes(x = t, y = LogN, colour = "Baranyi")) +
  geom_line(data = plot_Buc, aes(x = t, y = LogN, colour = "Buchanan")) +
  geom_line(data = plot_Qua, aes(x = t, y = LogN, colour = "Quadratic")) +
  geom_line(data = plot_Pol, aes(x = t, y = LogN, colour = "Polynomial")) +
  geom_line(data = plot_Lin, aes(x = t, y = LogN, color = "Linear")) +
  scale_color_discrete(name = "Models")

 plot_list[[i]] <- p

 #SAVE BEST MODEL DATA TO DATAFRAME
 
 best_R <- ID_stats[which.max(ID_stats[,2]),8]
 best_R <- as.character(best_R)
 best_AIC <- ID_stats[which.min(abs(ID_stats[,3])),8]
 best_AIC <- as.character(best_AIC)
 best_BIC <- ID_stats[which.min(abs(ID_stats[,4])),8]
 best_BIC <- as.character(best_BIC)
 
 final_stats <- data.frame(i, Species, Temp, best_R, best_AIC, best_BIC)
 names(final_stats) <- c("ID", "Species", "Temp", "Best R-Sq Model", "Best AIC Model", "Best BIC Model")
 
 df_list[[i]] <- final_stats
 
}

#save the list of plots to pdf

for (i in 1:(length(plot_list))) {
  file_name = paste("../results/plot_fits/plot_", i, ".pdf", sep="")
  pdf(file_name)
  print(plot_list[[i]])
  dev.off()
}

#merge the list of dataframes in to one
# use plyr package here
merged_data <- ldply(df_list, data.frame)

#How many times does each model appear in each column
R_Squared <- table(merged_data$Best.R.Sq.Model)
AIC <- table(merged_data$Best.AIC.Model)
BIC <- table(merged_data$Best.BIC.Model)

R <- as.data.frame(R_Squared, stringsAsFactors = FALSE)
AIC <- as.data.frame(AIC)
BIC <- as.data.frame(BIC)

names(R) <- c("Model", "R-Squared")
names(AIC) <- c("Model", "AIC")
names(BIC) <- c("Model", "BIC")

R[7,1] = "Linear"
R[7,2] = 0 

total <- merge(R, AIC, by = "Model")
total <- merge(total, BIC, by = "Model")

#dplyr package used here
total <- total %>% 
            mutate(Total = rowSums(.[2:4]))

# create empty list for species data

species_list_AIC <- list()
species_list_BIC <- list()

#Subset the data by species

for (i in 1:length(unique(merged_data$Species))) {
data_species <- subset(merged_data, Species == Species[i]) #subset data by species

AIC_species <- table(data_species$Best.AIC.Model)
AIC_species <- as.data.frame(AIC_species)
names(AIC_species) <- c("Model", "AIC")

AIC_species$Species <- merged_data$Species[i]

df2_AIC <- data.frame(t(AIC_species[-1]))
colnames(df2_AIC) <- AIC_species[, 1]
df2_AIC <- df2_AIC[-c(2), ]
df2_AIC <- cbind(Species = merged_data$Species[i], df2_AIC)

species_list_AIC[[i]] <- df2_AIC

BIC_species <- table(data_species$Best.BIC.Model)
BIC_species <- as.data.frame(BIC_species)
names(BIC_species) <- c("Model", "AIC")

BIC_species$Species <- merged_data$Species[i]

df2_BIC <- data.frame(t(BIC_species[-1]))
colnames(df2_BIC) <- BIC_species[, 1]
df2_BIC <- df2_BIC[-c(2), ]
df2_BIC <- cbind(Species = merged_data$Species[i], df2_BIC)

species_list_BIC[[i]] <- df2_BIC

}

merged_species_AIC <- ldply(species_list_AIC, data.frame)
merged_species_BIC <- ldply(species_list_BIC, data.frame)

#Change data frame values to character then numeric (to maintain their values as they change from factor)
for (i in 2:8) {
merged_species_AIC[,i] <- as.numeric(as.character(merged_species_AIC[,i]))
}

#Reduce the species value tothe first 12 characters
merged_species_AIC$Species <- substr(merged_species_AIC$Species, 0, 12)

#Merge the species
merged_species_AIC <- aggregate(.~ Species , data =merged_species_AIC, sum)

#Repeat for BIC
for (i in 2:8) {
  merged_species_BIC[,i] <- as.numeric(as.character(merged_species_BIC[,i]))
}

merged_species_BIC$Species <- substr(merged_species_BIC$Species, 0, 12)

merged_species_BIC <- aggregate(.~ Species , data =merged_species_BIC, sum)


write.csv(merged_species_AIC, ("../results/species_stats_AIC.csv"), row.names = FALSE)
write.csv(merged_species_BIC, ("../results/species_stats_BIC.csv"), row.names = FALSE)

# create empty list for temp data

temp_list_AIC <- list()
temp_list_BIC <- list()

merged_data<-merged_data[complete.cases(merged_data$Temp),]

#Subset the data by temp

for (i in 1:length(unique(merged_data$Temp))) {
  data_temp <- subset(merged_data, Temp == unique(merged_data$Temp)[i]) #subset data by temp
  
  AIC_temp <- table(data_temp$Best.AIC.Model)
  AIC_temp <- as.data.frame(AIC_temp)
  names(AIC_temp) <- c("Model", "AIC")
  
  AIC_temp$Temp <- unique(merged_data$Temp)[i]
  
  df2_AIC <- data.frame(t(AIC_temp[-1]))
  colnames(df2_AIC) <- AIC_temp[, 1]
  df2_AIC <- df2_AIC[-c(2), ]
  df2_AIC <- cbind(Temp = unique(merged_data$Temp)[i], df2_AIC)
  
  temp_list_AIC[[i]] <- df2_AIC
  
  BIC_temp <- table(data_temp$Best.BIC.Model)
  BIC_temp <- as.data.frame(BIC_temp)
  names(BIC_temp) <- c("Model", "AIC")
  
  BIC_temp$Temp <- unique(merged_data$Temp)[i]
  
  df2_BIC <- data.frame(t(BIC_temp[-1]))
  colnames(df2_BIC) <- BIC_temp[, 1]
  df2_BIC <- df2_BIC[-c(2), ]
  df2_BIC <- cbind(Temp = unique(merged_data$Temp)[i], df2_BIC)
  
  temp_list_BIC[[i]] <- df2_BIC
  
}

merged_temp_AIC <- ldply(temp_list_AIC, data.frame)
merged_temp_BIC <- ldply(temp_list_BIC, data.frame)

merged_temp_AIC <- merged_temp_AIC[order(merged_temp_AIC$Temp),]
merged_temp_BIC <- merged_temp_BIC[order(merged_temp_BIC$Temp),]

write.csv(merged_temp_AIC, ("../results/temp_stats_AIC.csv"), row.names = FALSE)
write.csv(merged_temp_BIC, ("../results/temp_stats_BIC.csv"), row.names = FALSE)

ggsave(filename = "../results/AIC_temp_plot.pdf", ggplot(merged_temp_AIC, aes(x=merged_temp_AIC$Temp, y=merged_temp_AIC$Quadratic))+
         xlab("Temperature °C") +
         ylab("Number of Best Fits") +
         ylim(0, 15)+
         theme_bw() +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Logistic, colour = "Logistic")) +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Gompertz, colour = "Gompertz")) +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Baranyi, colour = "Baranyi")) +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Buchanan, colour = "Buchanan")) +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Quadratic, colour = "Quadratic")) +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Polynomial, colour = "Polynomial")) +
         geom_line(data = merged_temp_AIC, aes(x = Temp, y = Linear, color = "Linear"))+
         scale_color_discrete(name = "Models"),
       width = 6, height = 2, dpi = 300, units = "in", device='pdf')

ggsave(filename="../results/BIC_temp_plot.pdf", ggplot(merged_temp_BIC, aes(x=merged_temp_BIC$Temp, y=merged_temp_BIC$Quadratic))+
         xlab("Temperature °C") +
         ylab("Number of Best Fits") +
         theme_bw() +
         theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))+
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Logistic, colour = "Logistic")) +
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Gompertz, colour = "Gompertz")) +
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Baranyi, colour = "Baranyi")) +
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Buchanan, colour = "Buchanan")) +
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Quadratic, colour = "Quadratic")) +
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Polynomial, colour = "Polynomial")) +
         geom_line(data = merged_temp_BIC, aes(x = Temp, y = Linear, color = "Linear"))+
         scale_color_discrete(name = "Models"),
       width = 6, height = 2, dpi = 300, units = "in", device='pdf')


# Export final statistical results for all model fits as csv file


write.csv(total, ("../results/final_stats.csv"), row.names = FALSE)



