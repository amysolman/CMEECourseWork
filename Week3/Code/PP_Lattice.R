# Amy Solman amy.solman19@imperial.ac.uk
# 21st October 2019
# PP_Lattice.R
rm(list=ls())
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv") # open data set to read
#head(MyDF)
graphics.off()

# 1) Draw and save lattice graph by feeding
# interaction type for log predator mass
library(lattice)
library(dplyr)

pdf("../Results/Pred_Lattice.pdf", #Open blank pdf page using a relative path
    11.7, 8.3) #These numbers are page dimensions in inches
print(densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF)) 
#remember to use PRINT with lattice plots otherwise they won't show up properly
graphics.off(); #You can also use dev.off()  

# 2) Draw and save lattice graph by feeding
# interaction type for log prey mass

pdf("../Results/Prey_Lattice.pdf", #Open blank pdf page using a relative path
    11.7, 8.3) #These numbers are page dimensions in inches
print(densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data=MyDF)) 
graphics.off(); #You can also use dev.off()  

# 3) Draw and save lattice graph by feeding
# interaction type for log prey mass over
# predator mass 

SizeRatio <- MyDF[13]/MyDF[9]
SizeRatio

pdf("../Results/SizeRatioLattice.pdf", #Open blank pdf page using a relative path
    11.7, 8.3) #These numbers are page dimensions in inches
print(densityplot(~log(SizeRatio) | Type.of.feeding.interaction, data=MyDF))
graphics.off(); #You can also use dev.off()  





Results <- MyDF %>%
  group_by(Type.of.feeding.interaction) %>%
  summarise(mean(log(Predator.mass)),mean(log(Prey.mass)), mean(log(Prey.mass/Predator.mass)), 
            median(log(Predator.mass)), median(log(Prey.mass)),median(log(Prey.mass/Predator.mass)))


write.csv(Results, "../Results/PP_Results.csv", row.names = TRUE, col.names = TRUE) 
