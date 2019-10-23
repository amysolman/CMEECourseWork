# Amy Solman amy.solman19@imperial.ac.uk
# 21st October 2019
# PP_Lattice.R

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv") # open data set to read
head(MyDF)

# 1) Draw and save lattice graph by feeding
# interaction type for log predator mass

library(lattice)
pdf("../Results/Pred_Lattice.pdf", #Open blank pdf page using a relative path
    11.7, 8.3) #These numbers are page dimensions in inches
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF)
graphics.off(); #You can also use dev.off()  

# 2) Draw and save lattice graph by feeding
# interaction type for log prey mass

pdf("../Results/Prey_Lattice.pdf", #Open blank pdf page using a relative path
    11.7, 8.3) #These numbers are page dimensions in inches
densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data=MyDF)
graphics.off(); #You can also use dev.off()  

# 3) Draw and save lattice graph by feeding
# interaction type for log prey mass over
# predator mass 

SizeRatio <- MyDF[13]/MyDF[9]
SizeRatio

pdf("../Results/SizeRatioLattice.pdf", #Open blank pdf page using a relative path
    11.7, 8.3) #These numbers are page dimensions in inches
densityplot(~log(SizeRatio) | Type.of.feeding.interaction, data=MyDF)
graphics.off(); #You can also use dev.off()  

# 4) Calculate mean and median for log predator, 
# prey and prey over predator mass.
# Initialize a new dataframe/matrix to store the calculations.

####################MAYBE THIS WILL WORK#########################

# x <- log(MyDF$Predator.mass)
# factor <- MyDF$Type.of.feeding.interaction
# 
# PredMeanMedian <- function(x) c(mean = mean(x), median = median(x))
# simplify2array(tapply(x, factor, PredMeanMedian))
# 
# x <- log(MyDF$Prey.mass)
# factor <- MyDF$Type.of.feeding.interaction
# 
# PreyMeanMedian <- function(x) c(mean = mean(x), median = median(x))
# simplify2array(tapply(x, factor, PreyMeanMedian))
# 
# x <- log(MyDF$Prey.mass/MyDF$Predator.mass)
# factor <- MyDF$Type.of.feeding.interaction
# 
# RatioMeanMedian <- function(x) c(mean = mean(x), median = median(x))
# simplify2array(tapply(x, factor, RatioMeanMedian))

####################MAYBE THIS WILL WORK#########################

# PredMean <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, mean)
# #Col1 <- t(Col1)
# 
# PredMed <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)
# #Col3 <- t(Col3)
# 
# PreyMean <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, mean)
# #Col2 <- t(Col2)
# 
# PreyMed <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, median)
# #Col4 <- t(Col4)
# 
# RatMean <- tapply(log(MyDF$Prey.mass/MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, mean)
# 
# RatMed <- tapply(log(MyDF$Prey.mass/MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)
# 
# Result <- t(rbind(PredMean, PredMed, PreyMean, PreyMed, RatMean, RatMed))
# Result <- t(Result)
# Result

####################MAYBE THIS WILL WORK#########################

require(dplyr)


Results <- MyDF %>%
  group_by(Type.of.feeding.interaction) %>%
  summarise(mean(log(Predator.mass)),mean(log(Prey.mass)), mean(log(Prey.mass/Predator.mass)), 
            median(log(Predator.mass)), median(log(Prey.mass)),median(log(Prey.mass/Predator.mass)))


write.csv(Results, "../Results/PP_Results.csv", row.names = TRUE, col.names = TRUE) 
