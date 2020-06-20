#Script to bind useful results together
rm(list=ls())
graphics.off()
#Let's look at the general stats for the simulation dataset and model dataset 

Stats <- list()
maxArea <- vector()

div = 20

for (i in 1:div) {
  data <- read.csv(paste0("../../Results/Simulation/MyStats_", i, ".csv"))
  Stats[[i]] <- data
  
  a <- read.csv(paste0("../../Results/Simulation/maxArea_", i, ".csv"))
  maxArea <- c(maxArea, a)
}

maxArea <- unlist(maxArea)

Stats <- do.call("rbind", Stats)
Stats$maxArea <- rep(maxArea, each = 2)
Stats$ModelOrSim <- rep( c("SolmanSim", "ChisholmMod"), 10)

StatsMax <- Stats[Stats$maxArea == max(Stats$maxArea), ]
StatsMin <- Stats[Stats$maxArea == min(Stats$maxArea), ]
StatsEdit <- rbind(StatsMax, StatsMin)

write.csv(StatsEdit, "../../Results/Simulation/StatsEdit.csv", row.names = FALSE)
write.csv(Stats, "../../Results/Simulation/Stats.csv", row.names = FALSE)

#Next we'll look at our t-test and paired t-test results 

ttest <-list()
pairedt <- list()

for (i in 1:div) {
  tdata <- read.csv(paste0("../../Results/Simulation/tTestResults_", i, ".csv"))
  ttest[[i]] <- tdata
  
  paireddata <- read.csv(paste0("../../Results/Simulation/PairedtTestResults_", i, ".csv"))
  pairedt[[i]] <- paireddata
}

ttest <- do.call("rbind", ttest)
pairedt <- do.call("rbind", pairedt)

ttest$maxArea <- maxArea
pairedt$maxArea <- maxArea

pairedtMax <- pairedt[pairedt$maxArea == max(as.numeric(pairedt$maxArea)), ]
pairedtMin <- pairedt[pairedt$maxArea == min(as.numeric(pairedt$maxArea)), ]

pairedtMaxMin <- rbind(pairedtMax, pairedtMin)

write.csv(ttest, "../../Results/Simulation/tTest.csv", row.names = FALSE)
write.csv(pairedt, "../../Results/Simulation/pairedT.csv", row.names = FALSE)
write.csv(pairedtMaxMin, "../../Results/Simulation/pairedtMaxMin.csv", row.names = FALSE)


#LEt's import our niche/area linear model results to compare them for our
#simulaltion dataset as the max area decreases

LMResults <- list()

for (i in 1:div){
  data <- read.csv(paste0("../../Results/Simulation/lmResults_", i, ".csv"))
  LMResults[[i]] <- data
}

LMResults <- do.call("rbind", LMResults)
Area <- rep(maxArea, each = 4)

LMResults$X <- paste(Area)
names(LMResults)[[1]] <- c("maxArea")

LMMax <- LMResults[LMResults$maxArea == max(as.numeric(LMResults$maxArea)), ]
LMMin <- LMResults[LMResults$maxArea == min(as.numeric(LMResults$maxArea)), ]

LMMaxMin <- rbind(LMMax, LMMin)

write.csv(LMResults, "../../Results/Simulation/LMResults.csv", row.names = FALSE)
write.csv(LMMaxMin, "../../Results/Simulation/LMMaxMin.csv", row.names = FALSE)

#Now let's look at how our multivariate analysis changes as we decrease max area

MultiResults <- list()

for (i in 1:div) {
  data <- read.csv(paste0("../../Results/Simulation/MultiAnalysis_", i, ".csv"))
  MultiResults[[i]] <- data
}

MultiResults <- do.call("rbind", MultiResults)
Area <- rep(maxArea, each = 9)
MultiResults$X <-paste(Area)
names(MultiResults)[[1]] <- c("maxArea")

MultiMax <- MultiResults[MultiResults$maxArea == max(as.numeric(MultiResults$maxArea)), ]
MultiMin <- MultiResults[MultiResults$maxArea == min(as.numeric(MultiResults$maxArea)), ]

MultiMaxMin <- rbind(MultiMax, MultiMin)

MultiMaxMin <- MultiMaxMin[MultiMaxMin$Variate != "Niche", ]

write.csv(MultiResults, "../../Results/Simulation/MultiAnalysis.csv", row.names = FALSE)
write.csv(MultiMaxMin, "../../Results/Simulation/MultiMaxMin.csv", row.names = FALSE)

