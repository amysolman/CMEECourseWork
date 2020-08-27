#Bind final results together into one dataset for comparison

rm(list=ls())
graphics.off()

#Import classic results
Classic <- read.csv("../../Results/ClassicNLLSResults.csv")
#Import depth results
Depth <- read.csv("../../Results/DepthNLLSResults.csv")
#Import perimeter results
Peri <- read.csv("../../Results/PeriNLLSResults.csv")

#Get the R2, Adjusted R2, parameter and ACrit values for Peri, Classic and Depth

Peri_Results <- Peri[tail(names(Peri), 7)]

Classic_Results <- Classic[tail(names(Classic), 7)]

Depth_Results <- Depth[tail(names(Depth), 7)]

#rename the columns so we know which fitting procedure each set of results came from

colnames(Peri_Results) <- c("Peri_R2", "Peri_AdjR2", "Peri_theta", "Peri_K", "Peri_m0", "Peri_rho", "Peri_ACrit")

colnames(Classic_Results) <- c("Classic_R2", "Classic_AdjR2", "Classic_theta", "Classic_K", "Classic_m0", "Classic_rho", "Classic_ACrit")

colnames(Depth_Results) <- c("Depth_R2", "Depth_AdjR2", "Depth_theta", "Depth_K", "Depth_m0", "Depth_rho", "Depth_ACrit")

#combine into one dataframe

Data <- Peri[head(names(Peri), 13)]

Final <- cbind.data.frame(Data, Peri_Results, Classic_Results, Depth_Results)

#Rearrange columns so they're more easily compared
Final <- Final[c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,21,28,15,22,29,16,23,30,17,24,31,18,25,32,19,26,33,20,27,34)]

#Export results 

write.csv(Final, "../../Results/FinalNLLSFittingResults.csv", row.names=FALSE)

