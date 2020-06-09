#Script to analyise simulation data and compare to Chisholm Model estimations

rm(list=ls())
graphics.off()

library("ggplot2")
#library("dplyr")
library("broom") #for getting t-test results

#CHECK LIST OF STATISTICAL ANALYSIS AND MODEL FITTING
# 1: Get the data!
# 2: Outliers
# 3: Homogeneitry of variances 
# 4: Are the data normally distributed?
# 5: Are there excessively many zeroes?
# 6: Is there collinearity among the covariates?
# 7: Visually inspect relationships 
# 8: Consider interactions?
# 9: Decide on maximal model based on biology and question 
# 10: Simplify model 
# 11: Decide on final model 
# 12: Run model validation
# 13: Check repeatability of simulation

##############################################
##########STEP ONE: GET OUT DATA##############
##############################################

#Find import the results of the simulation
ImportMe <- function() {
  SimData <- read.csv("../../Results/Simulation/SimModelFitData.csv") #import data
  SimOrModel <- rep("Solman_Sim", nrow(SimData)) #create a bind SimOrModel column
  SimData <- cbind.data.frame(SimData, SimOrModel)
  
  return(SimData)
}


#define the model function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#function to compare total results to model
compare_results <- function() {
  
  SimData <- ImportMe()
  
  #create empty list for storing estimated species richness
  island_species <- vector()
  EstData <- SimData[, -c(5:6)] #copy my simulation data
  
  
  for (i in 1: nrow(EstData)) {
    data <- EstData[i, ]
    m = data$migration_rate
    area = data$area
    J = area
    m0 = m*sqrt(area)
    nu = 0.001
    theta = 2*J*nu
    K = data$K_num
    island_species[[i]] <- round(chisholm_model(area, theta, m0, K), digits = 2)
  }
  
  #bind results to single dataframe
  EstData <- cbind.data.frame(EstData, island_species)
  
  #Add a SimOrModel column
  SimOrModel <- rep("Chisholm_Model", nrow(EstData))
  EstData <- cbind.data.frame(EstData, SimOrModel)
  
  #bind both datasets
  TotalData <- rbind.data.frame(SimData, EstData)
  
  return(TotalData)
  
  
}

###RUN CHISHOLMS FUNCTION AND GET OUR ESTIMATES
TotalData <- compare_results()

#divide up the datasets for ease of analysis
SolmanData <- TotalData[TotalData$SimOrModel == "Solman_Sim", ]
ChisholmData <- TotalData[TotalData$SimOrModel == "Chisholm_Model", ]

####We're also going to get the mean values from all our simulations####
    
    my_data <- list()
    for (m in 1:length(unique(SolmanData$migration_rates))) {
      migration_rates <- unique(SolmanData$migration_rates)
      rate <- SolmanData[SolmanData$migration_rates == migration_rates[m], ]
      my_data[[m]] <- rate
    }

  my_new_data <- list()
  y <- 1
  
  for (i in 1:length(my_data)) {
    
    x <- my_data[[i]]
    
    for (a in 1:length(unique(x$area))) {
      area <- unique(x$area)
      rate <- x[x$area == area[a], ]
      my_new_data[[y]] <- rate
      y <<- y + 1
    }
  }
  
  my_new_new_data <- list()
  
  z <- 1
  
  for (i in 1:length(my_new_data)) {
    
    x <- my_new_data[[i]]
    
    for (k in 1:length(unique(x$K_num))) {
      niches <- unique(x$K_num)
      rate <- x[x$K_num == niches[k], ]
      my_new_new_data[[z]] <- rate
      z <<- z + 1
      
    }
  }
  
  mean_df <- list()
  
  for (a in 1:length(my_new_new_data)) {
    dt <- my_new_new_data[a]
    b <- dt[[1]]
    mean_sp <- mean(b$island_species)
    migration_rate <- b$migration_rates[[1]]
    area <- b$area[[1]]
    niches <- b$K_num[[1]]
    mean_df[[a]] <- cbind(migration_rate, area, niches, mean_sp)
  }
  
  total_mean <- do.call("rbind", mean_df)
  SolmanMean <- as.data.frame(total_mean)


#####################################################
##########STEP TWO: ARE THERE OUTLIERS?##############
#####################################################

####LETS MAKE A BOX PLOT OF SIMULATED AND ESTIMATED SPECIES RICHNESSES
#Outliers should appear as circles in our boxplots
pdf("../../Results/Simulation/SolmanChisholmBoxplot.pdf")
b1 <- boxplot(TotalData$island_species ~ TotalData$SimOrModel, col = c("red", "blue"), ylab = "Num_Species")
print(b1)
dev.off()

#There are some outliers of our simulation data,
#but that may be because the simulation hadn't finished running
#will check again next time, and consider removing outlying datapoints

############################################################
##########STEP THREE: HOMOGENEITY OF VARIANCES##############
############################################################

#####GET THE RANGE, VARIANCE, SD AND SE OF EACH DATASET
####AND BIND INTO A DATAFRAME TO EXPORT

S <- range(SolmanData$island_species) # 1 - 33
x <- toString(S[1])
y <- toString(S[2])
Solman <- paste(x, "-", y)

C <- range(ChisholmData$island_species) # 1 - 20.88
x <- toString(C[1])
y <- toString(C[2])
Chisholm <- paste(x, "-", y)
ranges <- rbind(Solman, Chisholm)

#Variance is the deviation from the mean of each datapoint,
#squared then divided by the number of datapoints
#minus one
Solman_var <- var(SolmanData$island_species) #23.11
Chisholm_var <- var(ChisholmData$island_species) # 33.94
variances <- rbind(Solman_var, Chisholm_var)
variances <- round(variances, digits = 3)

#if we square root the variance we get the standard deviation
Solman_sd <- sd(SolmanData$island_species) #4.81
Chisholm_sd <- sd(ChisholmData$island_species) #5.83
SDs <- rbind(Solman_sd, Chisholm_sd)
SDs <- round(SDs, digits = 3)

#Standard errors are a good way to display uncertainty
Solman_se <- sqrt(var(SolmanData$island_species)/length(SolmanData$island_species))
Chisholm_se <- sqrt(var(ChisholmData$island_species)/length(ChisholmData$island_species))
SEs <- rbind(Solman_se, Chisholm_se)
SEs <- round(SEs, digits = 3)

#Let's bind these statistics into a dataframe so we can export them as a csv file
MyStats <- as.data.frame(cbind(ranges, variances, SDs, SEs))
names(MyStats) <- c("Range", "Variance", "Standard Deviation", "Standard Error")

write.csv(MyStats, "../../Results/Simulation/MyStats.csv")

############################################################
##########STEP FOUR: ARE THE DATA NORMALLY DISTRIBUTED?#####
############################################################

#My simulation histogram shows fairly normally distributed data

####HISTOGRAM OF SOLMAN SPECIES RICHNESS
pdf("../../Results/Simulation/SolmanSpeciesHistogram.pdf")
h1 <- hist(SolmanData$island_species) #produces left skewed data
print(h1)
dev.off()

######HISTOGRAM OF ISLAND AREAS
pdf("../../Results/Simulation/SolmanAreaHistogram.pdf")
h2 <- hist(SolmanData$area)
print(h2)
dev.off()

#####HISTOGRAM OF CHISHOLM SPECIES RICHNESS
pdf("../../Results/Simulation/ChisholmDataHistogram.pdf")
h3 <- hist(ChisholmData$island_species) #produces uniform frequency of observations, no 'hump'
print(h3)
dev.off()

############################################################
##########STEP FIVE: ARE THERE EXCESSIVELY MANY ZEROS?######
############################################################

#Look at the histogram for my species richnesses
#there are no zero species islands

############################################################
###STEP SIX: IS THERE COLLINEARITY AMOUNG THE COVARIATES?###
############################################################

##WE START WITH Z-TRANSFORMING OUR AREA AND NICHE VARIABLES
#Should I do this at this stage? Does it matter?
SolmanData$z.area <- scale(SolmanData$area)
SolmanData$z.K_num <- scale(SolmanData$K_num)

SolmanMean$z.area <- scale(SolmanMean$area)
SolmanMean$z.K_num <- scale(SolmanMean$niches)

pdf("../../Results/Simulation/CollinearityPlot.pdf")
pairs(SolmanMean)#is there collinearity amoung covariates?
dev.off()

df <- cor(SolmanMean)
df <- as.data.frame(df)
df <- round(df, digits = 3)

write.csv(df, "../../Results/Simulation/CollineaityResults.csv")

#Area and niches are somewhat positively correlated (migration rate is not), with
#number of niches being a better predictor of species richness 
#than island area.

#Let's find the Variance Inflation Factor. 
#This VIF we can use to find out what amount of collinearity is too much.
#VIF can be calulated by running an extra linear model in which the covariate of focus (here, K_num)
#is y and all other covariates of the model are covariates.

#We know mathematically that number of niches is correlated to area in our simulation
#let's make sure it's not too much!
model1 <- summary(lm(z.K_num ~ z.area, data = SolmanMean))
VIF <- 1/(1-model1$r.squared)
SEInflation_Area <- sqrt(VIF) #The standard errors of k_num are thus inflated by
# 1.32 which is not a lot. A VIF of 1.8 is also okay. 

#Keep it in mind when you do YOUR interpretation and discolse it in your report!
#think biology always!
VIF_Results <- rbind(VIF, SEInflation_Area)
VIF_Results <- as.data.frame(VIF_Results)
VIF_Results <- round(VIF_Results, digits = 3)
names(VIF_Results) <- c("Niches")

write.csv(VIF_Results, "../../Results/Simulation/NichesAreaVIFResults.csv")

#So we don't have too much collinearity!  Woohoo!!

############################################################
##########STEP SEVEN: VISUALLY INSPECT RELATIONSHIPS########
############################################################

#We've already looked at the boxplots of species/area for 
#our sim vs model data. That looks pretty normal.
#area and migration rate are continuous covariates - do I have
#to do anything inparticular because of this?
#Is number of niches a continuous covariate?

############################################################
############STEP EIGHT: CONSIDER INTERACTIONS###############
############################################################

#What sort of interactions would I consider here?

##################################################################
#STEP NINE: DECIDE ON MAXIMAL MODEL BASED ON BIOLOGY AND QUESTION#
##################################################################

#will do a t test and paired t test to see if there is a significant
#difference between my simulation results and the model results

#will do linear models of z-transformed niche and area data against species richness
#to see if either influence the number of species

#will do multivariate analysis to see how migration rate, number of niches and 
#island area affect species richness - to simplify in step 10/11

#######################################################################
#STEPS TEN AND ELEVEN: RUN TESTS/MODELS, SIMPLIFY AND RUN FINAL MODELS#
#######################################################################

#######LET'S DO A HYPOTHESIS TEST TO SEE IF THESE DIFFERENCES MEAN SOMETHING
#Null hypothesis: The difference between simulation species richness and model species 
#richness is zero

#Usually t-test should only be done on normally distributed data
#but because we have a large dataset (N>50) we can use it

t.test1 <- tidy(t.test(TotalData$island_species ~ TotalData$SimOrModel))
df <- as.data.frame(t.test1)
names(df) <- c("Mean Difference", "Solman_Sim Mean", "Chisholm_Model Mean", "t-value", "p-value", "df", 
               "conf. low", "conf. high", "method", "alternative")

#Round the t-test statistics to 2 decimal places
for (i in 1:8) {
  df[i][[1]] <- round(df[i][[1]], digits = 2)
}

#Save to CSV 
write.csv(df, "../../Results/Simulation/tTestResults.csv")

###Let's also try a paired sample t-test
t.test2 <- tidy(t.test(SolmanData$island_species, ChisholmData$island_species, paired = TRUE, alternative = "two.sided"))

df1 <- as.data.frame(t.test2)
names(df1) <- c("Mean Difference", "t-value", "p-value", "df", "conf. low", "conf. high", "method", "alternative")

#Round the t-test statistics to 2 decimal places
for (i in 1:6) {
  df1[i][[1]] <- round(df1[i][[1]], digits = 2)
}

#Save to CSV 
write.csv(df, "../../Results/Simulation/PairedtTestResults.csv")

#####LET'S START RUNNING SOME LINEAR MODELS TO SEE IF THERE
###IS A STATISTICALLY SIGNIFICANT RELATIONSHIP BETWEEN OUR VARIABLES

#for these I'm going to reduce the datasets again because my 
#computer is struggling to process them all
#SolmanSim <- SolmanData[SolmanData$sim_number > 5 & SolmanData$sim_number<8, ]

#run linear models with species and my z transformed data
model2 <- lm(mean_sp ~ z.area, data = SolmanMean)
model3 <- lm(mean_sp ~ z.K_num, data = SolmanMean)

#Get the relevant statistics and, round to 3 decimal places and save to csv

AreaR <- summary(model2)$r.squared
AreaP <- c("< 0.001") #this is a manual entry - check this and update yourself!
df2 <- tidy(model2)
df2$rSquared <- rep(AreaR, 2)
df2$Variate <- c("Area")
names(df2) <- c("Coefficients", "Estimate", "Standard Error", "t-value", "p.value", "R-Squared", "Variate")
df2$p.value <- AreaP

for (i in 2:4) {
  df2[i][[1]] <- round(df2[i][[1]], digits = 3)
}

df2[6][[1]] <- round(df2[6][[1]], digits = 3)

NicheR <- summary(model3)$r.squared
NicheP <- c("< 0.001") #this is a manual entry - check this and update yourself!
df3 <- tidy(model3)
df3$rSquared <- rep(NicheR, 2)
df3$Variate <- c("Niches")
names(df3) <- c("Coefficients", "Estimate", "Standard Error", "t-value", "p.value", "R-Squared", "Variate")
df3$p.value <- NicheP

for (i in 2:4) {
  df3[i][[1]] <- round(df3[i][[1]], digits = 3)
}

df3[6][[1]] <- round(df3[6][[1]], digits = 3)

df4 <- rbind(df2, df3)

write.csv(df4, "../../Results/Simulation/lmResults.csv")

##########################################################
####EXTENSION OF STEP THREE: HOMOGENEITY OF VARIANCES#####
##########################################################

####LET'S GET HISTOGRAMS OF THE RESIDUALS#####
pdf("../../Results/Simulation/AreaSpeciesResidualHisto.pdf")
h4 <- hist(model1$residuals)
print(h4)
dev.off()

pdf("../../Results/Simulation/NicheSpeciesResidualHisto.pdf")
h5 <- hist(model2$residuals)
print(h5)
dev.off()

#################################################
#########STEP TWELVE: MODEL VALIDATION###########
#################################################

#Looking for stary sky residuals 
#######LET'S PLOT THE MODEL TO CHECK THE DISTRIBUTION OF OUR RESIDUALS####

pdf("../../Results/Simulation/AreaSpeciesLmPlot.pdf")
par(mfrow=c(2,2))
m2 <- plot(model2)
print(m2)
dev.off()

pdf("../../Results/Simulation/NicheSpeciesLmPlot.pdf")
par(mfrow=c(2,2))
m3 <- plot(model3)
print(m3)
dev.off()


####LASTLY LET'S FIT A MODEL WITH MULTIPLE VARIABLES###

########################################################################
#########EXTENSION OF STEP FOUR: ARE THE DATA NORMALLY DISTRIBUTED?#####
########################################################################

#histograms show data is not normally distributed - is this a problem?
#how do I address this?
h6 <- hist(SolmanData$island_species)
h7 <- hist(SolmanData$z.area)
h8 <- hist(SolmanData$z.K_num)

pdf("../../Results/Simulation/HistoForMultivariateAnalysis.pdf")
plot(h6)
plot(h7)
plot(h8)
dev.off()

#first let's z-standardise migration rate
SolmanMean$z.migration <- scale(SolmanMean$migration_rate)

####################################################################################
#EXTENSION OF STEPS TEN AND ELEVEN: RUN TESTS/MODELS, SIMPLIFY AND RUN FINAL MODELS#
####################################################################################

####Now we'll do our multivariate analysis!!!
model4 <- lm(mean_sp ~ z.K_num + z.area + z.migration, data = SolmanMean)
summary(model4)

model5 <- lm(mean_sp ~ z.K_num + z.area, data = SolmanMean)
summary(model5)

model6 <- lm(mean_sp ~ z.K_num, data = SolmanMean)
summary(model6)

##############################################################
#########EXTENSION OF STEP TWELVE: MODEL VALIDATION###########
##############################################################

#######LET'S PLOT THE MODEL TO CHECK THE DISTRIBUTION OF OUR RESIDUALS####

pdf("../../Results/Simulation/NicheAreaMigrationLmPlot.pdf")
par(mfrow=c(2,2))
m4 <- plot(model4)
print(m4)
dev.off()

pdf("../../Results/Simulation/NicheAreaLmPlot.pdf")
par(mfrow=c(2,2))
m5 <- plot(model5)
print(m5)
dev.off()

pdf("../../Results/Simulation/NicheLmPlot.pdf")
par(mfrow=c(2,2))
m6 <- plot(model6)
print(m6)
dev.off()

#####################################################################
#######STEP THIRTEEN: CHECK THE REPEATABILITY OF THE SIMULATION######
#####################################################################

#Start by running a linear model of island species against simulation number as a factor
model7 <- lm(island_species ~ as.factor(sim_number), data = SolmanData)

a <- tidy(anova(model7)) #Then do an anova of the model to see if there is more variance within simulations#or amoung them
#we use the tidy function to get the results into a dataframe, makes them easier to access

#We can then workout the repeatability statistic by getting the sum of squares of our sim number
SimNumMeanSq <- a$meansq[1]
ResidMeanSq <- a$meansq[2]

#note that if our simulations were different sizes we would have to work this out different - see stats notes
repeatability = (SimNumMeanSq - ResidMeanSq)/(ResidMeanSq + (SimNumMeanSq - ResidMeanSq))
repeatability <- round(repeatability, digits = 3)

write.csv(repeatability, "../../Results/Simulation/repeatabilityscore.csv")




