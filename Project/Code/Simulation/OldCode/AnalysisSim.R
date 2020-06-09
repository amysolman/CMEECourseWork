#Script to analyise simulation data and compare to Chisholm Model estimations

rm(list=ls())
graphics.off()

#package for finding the mode
#install.packages("modeest")
library("modeest")
library("ggplot2")
library("dplyr")
library("broom") #for getting t-test results

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

###CHECK TO SEE IF THE DATA ARE NORMALLY DISTRIBUTED
#Let's check to see if our data is normally distributed

SolmanData <- TotalData[TotalData$SimOrModel == "Solman_Sim", ]
ChisholmData <- TotalData[TotalData$SimOrModel == "Chisholm_Model", ]


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

####LETS MAKE A BOX PLOT OF SIMULATED AND ESTIMATED SPECIES RICHNESSES
pdf("../../Results/Simulation/SolmanChisholmBoxplot.pdf")
b1 <- boxplot(TotalData$island_species ~ TotalData$SimOrModel, col = c("red", "blue"), ylab = "Num_Species")
print(b1)
dev.off()

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

df2 <- as.data.frame(t.test2)
names(df2) <- c("Mean Difference", "t-value", "p-value", "df", "conf. low", "conf. high", "method", "alternative")

#Round the t-test statistics to 2 decimal places
for (i in 1:6) {
  df2[i][[1]] <- round(df2[i][[1]], digits = 2)
}

#Save to CSV 
write.csv(df, "../../Results/Simulation/PairedtTestResults.csv")

#####LET'S START RUNNING SOME LINEAR MODELS TO SEE IF THERE
###IS A STATISTICALLY SIGNIFICANT RELATIONSHIP BETWEEN OUR VARIABLES

#run linear models with species and my z transformed data
model1 <- lm(island_species ~ z.area, data = SolmanData)
model2 <- lm(island_species ~ z.K_num, data = SolmanData)

#Get the relevant statistics and, round to 3 decimal places and save to csv

AreaR <- summary(model1)$r.squared
AreaP <- c("< 0.001") #this is a manual entry - check this and update yourself!
df3 <- tidy(model1)
df3$rSquared <- rep(AreaR, 2)
df3$Variate <- c("Area")
names(df3) <- c("Coefficients", "Estimate", "Standard Error", "t-value", "p-value", "R-Squared", "Variate")
df3$`p-value` <- AreaP

for (i in 2:4) {
  df3[i][[1]] <- round(df3[i][[1]], digits = 3)
}

df3[6][[1]] <- round(df3[6][[1]], digits = 3)

NicheR <- summary(model2)$r.squared
NicheP <- c("< 0.001") #this is a manual entry - check this and update yourself!
df4 <- tidy(model2)
df4$rSquared <- rep(NicheR, 2)
df4$Variate <- c("Niches")
names(df4) <- c("Coefficients", "Estimate", "Standard Error", "t-value", "p-value", "R-Squared", "Variate")
df4$`p-value` <- NicheP

for (i in 2:4) {
  df4[i][[1]] <- round(df4[i][[1]], digits = 3)
}

df4[6][[1]] <- round(df4[6][[1]], digits = 3)

df5 <- rbind(df3, df4)

write.csv(df5, "../../Results/Simulation/lmResults.csv")

####LET'S GET HISTOGRAMS OF THE RESIDUALS#####
pdf("../../Results/Simulation/AreaSpeciesResidualHisto.pdf")
h4 <- hist(model1$residuals)
print(h4)
dev.off()

pdf("../../Results/Simulation/NicheSpeciesResidualHisto.pdf")
h5 <- hist(model2$residuals)
print(h5)
dev.off()

#######LET'S PLOT THE MODEL TO CHECK THE DISTRIBUTION OF OUR RESIDUALS####

pdf("../../Results/Simulation/AreaSpeciesLmPlot.pdf")
par(mfrow=c(2,2))
m1 <- plot(model1)
print(m1)
dev.off()

pdf("../../Results/Simulation/NicheSpeciesLmPlot.pdf")
par(mfrow=c(2,2))
m2 <- plot(model2)
print(m2)
dev.off()

######NOW WE'LL CHECK THE REPEATABILITY OF OUR SIMULATION

#Start by running a linear model of island species against simulation number as a factor
model3 <- lm(island_species ~ as.factor(sim_number), data = SolmanData)

a <- tidy(anova(model3)) #Then do an anova of the model to see if there is more variance within simulations#or amoung them
#we use the tidy function to get the results into a dataframe, makes them easier to access

#We can then workout the repeatability statistic by getting the sum of squares of our sim number
SimNumMeanSq <- a$`Mean Sq`[1]
ResidMeanSq <- a$`Mean Sq`[2]

#note that if our simulations were different sizes we would have to work this out different - see stats notes
repeatability = (SimNumMeanSq - ResidMeanSq)/(ResidMeanSq + (SimNumMeanSq - ResidMeanSq))
repeatability <- round(repeatability, digits = 3)

write.csv(repeatability, "../../Results/Simulation/repeatabilityscore.csv")

####LASTLY LET'S FIT A MODEL WITH MULTIPLE VARIABLES###

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


######
#####check to make sure this works
pairs(SolmanData[, 2:5]) #is there colinearity amoung covariates?
cor(SolmanData)

#These variables are all positively correlated, with
#number of niches being a better predictor of species richness 
#than island area.
#Too much correlation amoung the predictors (niche number and area)
#is not a good thing. This is called collinearity. What it does is it inflates
#variation. So when you have a lot of collinearity in your covariates,
#You'll get larger standard errors of those correlated variables
#than you'd get if there was no collinearity.
#This means it is more difficult to detect an effect, that you are likely 
#to not get a significant result even though there might be one. 
#This means that if there is lots of collinearity any normal evaluation of a model is super conservative.

#Let's find the Variance Inflation Factor. 
#This VIF we can use to find out what amount of collinearity is too much.
#VIF can be calulated by running an extra linear model in which the covariate of focus (here, K_num)
#is y and all other covariates of the model are covariates.

#first let's z-standardise migration rate
SolmanData$z.migration <- scale(SolmanData$migration_rates)

#We know mathematically that number of niches is correlated to area in our simulation
#let's make sure it's not too much!
model4 <- summary(lm(z.K_num ~ z.area, data = SolmanData))
VIF <- 1/(1-model4$r.squared)
SEInflation_Area <- sqrt(VIF) #The standard errors of k_num are thus inflated by
# 1.32 which is not a lot. A VIF of 1.8 is also okay. 
#Keep it in mind when you do oyur interpretation and discolse it in your report!
#think biology always!
VIF_Results <- rbind(VIF, SEInflation_Area)
VIF_Results <- as.data.frame(VIF_Results)
names(VIF_Results) <- c("Niches")

write.csv(VIF_Results, "../../Results/Simulation/NichesAreaVIFResults.csv")

####Now we'll do our multivariate analysis!!!
model4 <- lm(island_species ~ z.K_num + z.area + z.migration, data = SolmanData)
summary(model4)

model5 <- lm(island_species ~ z.K_num + z.area, data = SolmanData)
summary(model5)

model6 <- lm(island_species ~ z.K_num, data = SolmanData)
summary(model6)

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
