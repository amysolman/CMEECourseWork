# Amy Solman amy.solman19@imperial.ac.uk
# 20th November 2019
# plot_analysis.R
#Final plotting and analysis scipt

#Next, you can import the results from the previous step and plot every curve with the two 
#(or more) models (or none, if nothing converges) overlaid. Doing this will help you identify 
#poor fits visually and help you decide whether the previous, NLLS fitting script can be 
#further optimized (e.g., by improving the starting values generator). All plots should be saved 
#in a single separate sub-directory. This script will also perform any analyses of the results 
#of the Model fitting, for example to summarize which model(s) fit(s) best, and address any 
#biological questions involving co-variates.

library("ggplot2")
library("plyr")
library("dplyr")

rm(list=ls())
# setwd("/Users/amysolman/Documents/CMEECourseWork/Miniproject/Code")
graphics.off()

data <- read.csv("../data/modified_data.csv")
stats_results <- read.csv("../results/total_stats_results.csv")
plot_results <- read.csv("../results/total_plot_results.csv")

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

# X <- ((length(unique(data$ID))) - 1) #minus 1 because length = 286, but number of datasets= 285, avoid error
 
for (i in 1:((length(unique(data$ID))) - 1)) { 
  ID_df<-data[which(data$ID==i),]
  
  ID_plots <- plot_results[which(plot_results$ID==i),]
  ID_stats <- stats_results[which(stats_results$ID==i),]
  
  # ID_stats[ID_stats==0] <- NA
  # ID_stats[ID_stats==0] <- Inf
  # ID_stats<-ID_stats[complete.cases(ID_stats$AIC.Score),]
  
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
 
 best_R <- ID_stats[which.max(ID_stats[,3]),7]
 best_R <- as.character(best_R)
 best_AIC <- ID_stats[which.min(abs(ID_stats[,4])),7]
 best_AIC <- as.character(best_AIC)
 best_BIC <- ID_stats[which.min(abs(ID_stats[,5])),7]
 best_BIC <- as.character(best_BIC)
 
 final_stats <- data.frame(i, best_R, best_AIC, best_BIC)
 names(final_stats) <- c("ID", "Best R-Sq Model", "Best AIC Model", "Best BIC Model")
 
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
merged_data <- ldply(df_list, data.frame)

#How many times does each model appear in each column
R_Squared <- table(merged_data$Best.R.Sq.Model)
AIC <- table(merged_data$Best.AIC.Model)
BIC <- table(merged_data$Best.BIC.Model)
total_best <- table(merged_data == "Barani")

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

total <- total %>% 
            mutate(Total = rowSums(.[2:4]))

# Export final statistical results for all model fits as csv file

write.csv(total, ("../results/final_stats.csv"))


