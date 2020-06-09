#Script to bind useful results together
rm(list=ls())
graphics.off()
#Let's look at the general stats for the simulation dataset and model dataset 

Stats <- list()
maxArea <- vector()

for (i in 1:10) {
  data <- read.csv(paste0("../../Results/Simulation/MyStats_", i, ".csv"))
  Stats[[i]] <- data
  
  a <- read.csv(paste0("../../Results/Simulation/maxArea_", i, ".csv"))
  maxArea <- c(maxArea, a)
}

maxArea <- unlist(maxArea)

Stats <- do.call("rbind", Stats)
Stats$maxArea <- rep(maxArea, each = 2)
Stats$ModelOrSim <- rep( c("Solman_Sim", "Chisholm_Mod"), 10)

write.csv(Stats, "../../Results/Simulation/Stats.csv", row.names = FALSE)

#Next we'll look at our t-test and paired t-test results 

ttest <-list()
pairedt <- list()

for (i in 1:10) {
  tdata <- read.csv(paste0("../../Results/Simulation/tTestResults_", i, ".csv"))
  ttest[[i]] <- tdata
  
  paireddata <- read.csv(paste0("../../Results/Simulation/PairedtTestResults_", i, ".csv"))
  pairedt[[i]] <- paireddata
}

ttest <- do.call("rbind", ttest)
pairedt <- do.call("rbind", pairedt)

ttest$maxArea <- maxArea
pairedt$maxArea <- maxArea


write.csv(ttest, "../../Results/Simulation/tTest.csv", row.names = FALSE)
write.csv(pairedt, "../../Results/Simulation/pairedT.csv", row.names = FALSE)


#LEt's import our niche/area linear model results to compare them for our
#simulaltion dataset as the max area decreases

LMResults <- list()

for (i in 1:10){
  data <- read.csv(paste0("../../Results/Simulation/lmResults_", i, ".csv"))
  LMResults[[i]] <- data
}

LMResults <- do.call("rbind", LMResults)
Area <- rep(maxArea, each = 4)

LMResults$X <- paste(Area)
names(LMResults)[[1]] <- c("maxArea")

write.csv(LMResults, "../../Results/Simulation/LMResults.csv", row.names = FALSE)

#Now let's look at how our multivariate analysis changes as we decrease max area

MultiResults <- list()

for (i in 1:10) {
  data <- read.csv(paste0("../../Results/Simulation/MultiAnalysis_", i, ".csv"))
  MultiResults[[i]] <- data
}

MultiResults <- do.call("rbind", MultiResults)
Area <- rep(maxArea, each = 9)
MultiResults$X <-paste(Area)
names(MultiResults)[[1]] <- c("maxArea")

write.csv(MultiResults, "../../Results/Simulation/MultiAnalysis.csv", row.names = FALSE)

