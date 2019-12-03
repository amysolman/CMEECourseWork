# Amy Solman amy.solman19@imperial.ac.uk
# 3rd December 2019
# PP_Regress_loc.R
# Results of an analysis of Linear regression on subsets of the data 
# corresponding to Location 

require(plyr)
require(dplyr)
require(broom)


##########OPEN DATASET TO READ - PUT INTO DATAFRAME##########
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

My_Data <- MyDF[c("Location", "Predator.mass", "Prey.mass")]


My_Data %>%
  group_by(Location) %>%
  do(tidy(lm(Predator.mass ~ Prey.mass, .))) %>%
  write.csv("../Results/PP_Regress_Results_loc.csv") # write it out as a new file


