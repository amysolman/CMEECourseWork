# Amy Solman amy.solman19@imperial.ac.uk
# 22nd October 2019
# PP_Regress.R
# Results of 
# an analysis of Linear regression on subsets of the data 
#corresponding to available Feeding Type × Predator life Stage 
#combination — not a multivariate linear model with these two as separate covariates!

require(ggplot2)
require(dplyr)
install.packages("broom")
require(broom)

##########OPEN DATASET TO READ - PUT INTO DATAFRAME##########
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

##########CREATES MULTIFACETED PLOT##########
p <- qplot(Prey.mass, Predator.mass, facets = Type.of.feeding.interaction ~., data = MyDF, shape= I(3), log="xy", 
      xlab = "Prey mass in grams", 
      ylab = "Predator mass in grams",
      colour = Predator.lifestage) + 
      theme(legend.position="bottom") +
      geom_smooth(method = "lm",
     fullrange = TRUE)

pdf("../Results/PP_Regress.pdf", 5, 9)
print(p)
dev.off()

My_Data <- MyDF[c("Predator.lifestage", "Type.of.feeding.interaction", "Predator.mass", "Prey.mass")]
head(My_Data)

My_Data %>%
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
  do(tidy(lm(Predator.mass ~ Prey.mass, .))) %>%
  write.csv("../Results/PP_Regress_Results.csv") # write it out as a new file

############COULD WORK BUT CURRENTLY HAS BUG, COME BACK TO##############

# install.packages("data.table")
# 
# library(data.table)
# 
# write.csv(My_Data, "../Data/MyTrimmedData.csv") 
# 
# dat <- fread("../Data/MyTrimmedData.csv")
# 
# results <- dat[,.(Pvalue=summary(lm(Predator.mass~Prey.mass))$coefficient[2,4], 
#                   beta=summary(lm(Predator.mass~Prey.mass))$coefficient[2,4], 
#                   r2=summary(lm(Predator.mass~Prey.mass))$r.squared),
#                by=c("Predator.lifestage","Type.of.feeding.interaction")]
