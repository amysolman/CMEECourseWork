#Final plotting and analysis scipt

#Next, you can import the results from the previous step and plot every curve with the two 
#(or more) models (or none, if nothing converges) overlaid. Doing this will help you identify 
#poor fits visually and help you decide whether the previous, NLLS fitting script can be 
#further optimized (e.g., by improving the starting values generator). All plots should be saved 
#in a single separate sub-directory. This script will also perform any analyses of the results 
#of the Model fitting, for example to summarize which model(s) fit(s) best, and address any 
#biological questions involving co-variates.

library("ggplot2")
library("data.table")
library("plyr")
library("dplyr")

rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week8/Code")
graphics.off()

data <- read.csv('../data/modified_data.csv')
total_stats_results <- read.csv("../results/total_stats_results.csv")
total_plot_results <- read.csv("../results/total_plot_results.csv")

data[data==0] <- NA
data<-data[complete.cases(data$PopBio),]
data <- data[data$PopBio >= 0, ]
data <- data[data$Time >= 0, ]
data$LogN <- log(data$PopBio)
data$t <- data$Time

total_stats_results[total_stats_results==0] <- NA
total_stats_results<-total_stats_results[complete.cases(total_stats_results$R.Squared),]

plot_list = list()
data_frame_list = list()

X <- ((length(unique(data$ID))) - 1) #minus 1 because length = 286, but number of datasets= 285, avoid error
 
for (i in 1:X) { 
  ID_df<-data[which(data$ID==i),]
  
  ID_plots <- total_plot_results[which(total_plot_results$ID==i),]
  ID_stats <- total_stats_results[which(total_stats_results$ID==i),]
  
  ID_stats[ID_stats==0] <- NA
  ID_stats[ID_stats==0] <- Inf
  ID_stats<-ID_stats[complete.cases(ID_stats$AIC.Score),]
  

ID_plots_Gom <- subset(ID_plots, Model == "Gompertz")
ID_plots_Bar <- subset(ID_plots, Model == "Baranyi")
ID_plots_Buc <- subset(ID_plots, Model == "Buchanan")
ID_plots_Qua <- subset(ID_plots, Model == "Quadratic")
ID_plots_Pol <- subset(ID_plots, Model == "Polynomial")
ID_plots_Lin <- subset(ID_plots, Model == "Linear")

#Plot each dataset of ID with each successful model

p <- ggplot(ID_df, aes(x=t, y=LogN)) +
  geom_point() +
  xlab("time") +
  ylab("logN") +
  theme_bw() +
  ggtitle("Population Growth", i) +
  geom_line(data = ID_plots_Gom, aes(x = t, y = LogN, colour = "Gompertz")) +
  geom_line(data = ID_plots_Bar, aes(x = t, y = LogN, colour = "Baranyi")) +
  geom_line(data = ID_plots_Buc, aes(x = t, y = LogN, colour = "Buchanan")) +
  geom_line(data = ID_plots_Qua, aes(x = t, y = LogN, colour = "Quadratic")) +
  geom_line(data = ID_plots_Pol, aes(x = t, y = LogN, colour = "Polynomial")) +
  geom_line(data = ID_plots_Lin, aes(x = t, y = LogN, color = "Linear")) +
  scale_color_discrete(name = "Models")

 plot_list[[i]] <- p

 #SAVE BEST MODEL DATA TO DATAFRAME
 
 best_model_R <- ID_stats[which.max(ID_stats[,3]),7]
 best_model_R <- as.character(best_model_R)
 best_model_AIC <- ID_stats[which.min(abs(ID_stats[,4])),7]
 best_model_AIC <- as.character(best_model_AIC)
 best_model_BIC <- ID_stats[which.min(abs(ID_stats[,5])),7]
 best_model_BIC <- as.character(best_model_BIC)
 
 final_stats <- data.frame(i, best_model_R, best_model_AIC, best_model_BIC)
 names(final_stats) <- c("ID", "Best R-Sq Model", "Best AIC Model", "Best BIC Model")
 
 data_frame_list[[i]] <- final_stats
 
}

#save the list of plots to pdf
invisible(mapply(ggsave, file=paste0("../results/model_fits/plot-", names(plot_list), ".pdf"), plot=plot_list))


# total_final_stats <- list.files(path = "../results/", pattern=glob2rx("final_stats*.csv"), full.names = TRUE) %>% 
#   lapply(read_csv) %>% 
#   bind_rows 

#merge the list of dataframes in to one
merged_data <- ldply(data_frame_list, data.frame)

#How many times does each model appear in each column

R_Squared <- table(merged_data$Best.R.Sq.Model)
AIC <- table(merged_data$Best.AIC.Model)
BIC <- table(merged_data$Best.BIC.Model)



