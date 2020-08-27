#script for statistical analysis 

rm(list=ls())
graphics.off()


#install.packages("dplyr") #<- for checking data before two way anova
library("dplyr")
#install.packages("ggpubr") #<- for boxplot visualisations
library("ggpubr")
library(viridis) #<- for boxplot colours


#read in datasets
Data <- read.csv("../../Results/FinalNLLSFittingResults.csv")
ClassicAIC <- read.csv("../../Results/ClassicPowResults.csv")
DepthAIC <- read.csv("../../Results/DepthPowResults.csv")
PerimeterAIC <- read.csv("../../Results/PeriPowResults.csv")

#Power Law Analysis
#combin classic, depth and peri AIC scores 
PowEdit <- ClassicAIC
PowEdit$AIC_Depth <- DepthAIC[,(18)]
PowEdit$AIC_Peri <- PerimeterAIC[,(18)]
colnames(PowEdit)[18] <- "AIC_Classic"

#mean z value before removing failed fits
z_value <- mean(PowEdit$Z)

#remove failed fittings
Vec <- vector()
for (i in 1:nrow(PowEdit)){
  if (PowEdit$RSqAdj[i] > 0 && PowEdit$RSqAdj[i] < 1){
    Vec <- c(Vec, i)
  }
}
PowChop <- data.frame()
for (i in 1:length(Vec)){
  PowChop <- rbind(PowChop, PowEdit[Vec[[i]], ])
}

#mean scores for power model
mean_z <- mean(PowChop$Z)
meanR <- mean(PowChop$RSq)
meanAR <- mean(PowChop$RSqAdj)

#how many times did the models perform better?
nrow(PowChop[PowChop$AIC_Classic>2, ])
nrow(PowChop[PowChop$AIC_Depth>2, ])
nrow(PowChop[PowChop$AIC_Peri>2, ])

#remove datasets that have Adj RSq that are less than 0 or more than 1
Vec <- vector()
for (i in 1:nrow(Data)){
  if (Data$Peri_AdjR2[i] > 0 && Data$Peri_AdjR2[i] < 1 
      || Data$Classic_AdjR2[i] > 0 && Data$Classic_AdjR2[i] < 1
      || Data$Depth_AdjR2[i] > 0 && Data$Depth_AdjR2[i] < 1) {
    Vec <- c(Vec, i)
  }
}
#bind together the best fits
DataEdit <- data.frame()
for (i in 1:length(Vec)){
  DataEdit <- rbind(DataEdit, Data[Vec[[i]], ])
}

#mean R2 and adj R2 scores for each model
meanClassic <- mean(DataEdit$Classic_R2)
AdjmeanClassic <- mean(DataEdit$Classic_AdjR2)
meanDepth <- mean(DataEdit$Depth_R2)
AdjmeanDepth <- mean(DataEdit$Depth_AdjR2)
meanPeri <- mean(DataEdit$Peri_R2)
AdjmeanPeri <- mean(DataEdit$Peri_AdjR2)


#export as table
models <- c("Classic", "Depth", "Perimeter")
R_scores <- round(c(meanClassic, meanDepth, meanPeri), digits=3)
AdR_scores <- round(c(AdjmeanClassic, AdjmeanDepth, AdjmeanPeri), digits=3)
R_results <- data.frame(models, R_scores, AdR_scores)
colnames(R_results) <- c("Model", "R2", "Adj R2")

write.csv(R_results, "../../Other/FinalReport/RResults.csv", row.names = FALSE, quote=FALSE)


#for each dataset get the best results and put into dataframe
Final <- list()
for (x in 1:nrow(DataEdit)){
  dataset <- DataEdit[x,]
  if (dataset$Peri_AdjR2 > dataset$Classic_AdjR2 && dataset$Peri_AdjR2 > dataset$Depth_AdjR2){
    z <- dataset[,c(1:14, 17, 20, 23, 26, 29, 32)]
    names(z)[14] <- "R2"
    names(z)[15] <- "AdjR2" #peri best
    names(z)[16] <- "Theta"
    names(z)[17] <- "K"
    names(z)[18] <- "m0"
    names(z)[19] <- "rho"
    names(z)[20] <- "ACrit"
    Final[[x]] <- z
  } else if (dataset$Classic_AdjR2 > dataset$Peri_AdjR2 && dataset$Classic_AdjR2 > dataset$Depth_AdjR2){
    z <- dataset[,c(1:13, 15, 18, 21, 24, 27, 30, 33)]
    names(z)[14] <- "R2"
    names(z)[15] <- "AdjR2"
    names(z)[16] <- "Theta" #classic best
    names(z)[17] <- "K"
    names(z)[18] <- "m0"
    names(z)[19] <- "rho"
    names(z)[20] <- "ACrit"
    Final[[x]] <- z
  } else if (dataset$Depth_AdjR2 > dataset$Classic_AdjR2 && dataset$Depth_AdjR2 > dataset$Peri_AdjR2){
    z <- dataset[,c(1:13, 16, 19, 22, 25, 28, 31, 34)]
    names(z)[14] <- "R2"
    names(z)[15] <- "AdjR2"
    names(z)[16] <- "Theta" #depth best
    names(z)[17] <- "K"
    names(z)[18] <- "m0"
    names(z)[19] <- "rho"
    names(z)[20] <- "ACrit"
    Final[[x]] <- z
  } else if (dataset$Depth_AdjR2 == dataset$Classic_AdjR2 && dataset$Depth_AdjR2 == dataset$Peri_AdjR2){
    z <- dataset[,1:13]
    z$R2 <- mean(dataset$Peri_R2, dataset$Classic_R2, dataset$Depth_R2)
    z$AdjR2 <- mean(dataset$Peri_AdjR2, dataset$Classic_AdjR2, dataset$Depth_AdjR2)
    z$Theta <- mean(dataset$Peri_theta, dataset$Classic_theta, dataset$Depth_theta) #all three best
    z$K <- mean(dataset$Peri_K, dataset$Classic_K, dataset$Depth_K)
    z$m0 <- mean(dataset$Peri_m0, dataset$Classic_m0, dataset$Depth_m0)
    z$rho <- mean(dataset$Peri_rho, dataset$Classic_rho, dataset$Depth_rho)
    z$ACrit <- mean(dataset$Peri_ACrit, dataset$Classic_ACrit, dataset$Depth_ACrit)
    Final[[x]] <- z
    
  } else if ( dataset$Depth_AdjR2 == dataset$Classic_AdjR2 && dataset$Depth_AdjR2 > dataset$Peri_AdjR2){
    z <- dataset[,1:13]
    z$R2 <- mean(dataset$Classic_R2, dataset$Depth_R2)
    z$AdjR2 <- mean(dataset$Classic_AdjR2, dataset$Depth_AdjR2) #depth and classic best
    z$Theta <- mean(dataset$Classic_theta, dataset$Depth_theta)
    z$K <- mean(dataset$Classic_K, dataset$Depth_K)
    z$m0 <- mean(dataset$Classic_m0, dataset$Depth_m0)
    z$rho <- mean(dataset$Classic_rho, dataset$Depth_rho)
    z$ACrit <- mean(dataset$Classic_ACrit, dataset$Depth_ACrit)
    Final[[x]] <- z
  } else if ( dataset$Depth_AdjR2 == dataset$Peri_AdjR2 && dataset$Depth_AdjR2 > dataset$Classic_AdjR2){
    z <- dataset[,1:13]
    z$R2 <- mean(dataset$Peri_R2, dataset$Depth_R2)
    z$AdjR2 <- mean(dataset$Peri_AdjR2, dataset$Depth_AdjR2) #depth and peri best
    z$Theta <- mean(dataset$Peri_theta, dataset$Depth_theta)
    z$K <- mean(dataset$Peri_K, dataset$Depth_K)
    z$m0 <- mean(dataset$Peri_m0, dataset$Depth_m0)
    z$rho <- mean(dataset$Peri_rho, dataset$Depth_rho)
    z$ACrit <- mean(dataset$Peri_ACrit, dataset$Depth_ACrit)
    Final[[x]] <- z
  } else if ( dataset$Classic_AdjR2 == dataset$Peri_AdjR2 && dataset$Classic_AdjR2 > dataset$Classic_AdjR2){
    z <- dataset[,1:13]
    z$R2 <- mean(dataset$Peri_R2, dataset$Classic_R2)
    z$AdjR2 <- mean(dataset$Peri_AdjR2, dataset$Classic_AdjR2) #classic and peri best
    z$Theta <- mean(dataset$Peri_theta, dataset$Classic_theta)
    z$K <- mean(dataset$Peri_K, dataset$Classic_K)
    z$m0 <- mean(dataset$Peri_m0, dataset$Classic_m0)
    z$rho <- mean(dataset$Peri_rho, dataset$Classic_rho)
    z$ACrit <- mean(dataset$Peri_ACrit, dataset$Classic_ACrit)
    Final[[x]] <- z
  }
}

TotalData <- do.call("rbind", Final)

#log Critical Classic
TotalData$logACrit <- log(TotalData$ACrit)

#Make table of the best fits
Classic_best <- 1
Depth_best <- 2
Peri_best <- 2
Classic_Depth_best <- 10
Peri_Depth <- 0
Peri_Classic <- 0
All_best <- 9

Combo <- c("Classic", "Depth", "Perimeter", "Classic and Depth", "Classic and Perimeter", "Depth and Perimeter", "All")
Score <- c(1, 2, 2, 10, 0, 0, 9)
Score_Combo <- data.frame(Combo, Score)

#export as csv
write.csv(Score_Combo, "../../FinalReport/BestModel.csv", row.names=FALSE, quote=FALSE)

#get mean RSq and RSqAdj of fittings
RSq <- round(mean(TotalData$R2), 3)
RSqAdj <- round(mean(TotalData$AdjR2), 3)

#get standard deviation and range of RSq and RSqAdj
RSqSD <- round(sd(TotalData$R2), 3)
RSqAdjSD <- round(sd(TotalData$AdjR2), 3)
RSqRange <- range(TotalData$R2)
RSqRange <- paste(RSqRange[1], "-", RSqRange[2])
RSqAdjRange <- range(TotalData$AdjR2)
RSqAdjRange <- paste(RSqAdjRange[1], "-", RSqAdjRange[2])

#put RSq and RSqAdj into table to export
RSqResults <- rbind.data.frame(RSq, RSqSD, RSqRange)
RSqAdjResults <- rbind.data.frame(RSqAdj, RSqAdjSD, RSqAdjRange)
TotalRSqResults <- cbind(RSqResults, RSqAdjResults)
row.names(TotalRSqResults) <- c("Mean", "Standard Deviation", "Range")
colnames(TotalRSqResults) <- c("R-Squared", "Adjusted R-Squared")

write.csv(TotalRSqResults, "../../Results/RSqResults.csv", row.names = FALSE)

#get mean theta, m0 and K of fittings
Theta <- round(mean(TotalData$Theta))
K <- round(mean(TotalData$K))
m0 <- signif(mean(TotalData$m0), 3)

#get median theta m0 and K
ThetaMedian <- round(median(TotalData$Theta))
KMedian <- round(median(TotalData$K))
m0Median <- median(TotalData$m0)

#which was the most variable parameter?
ThetaRange <- range(TotalData$Theta)
ThetaRange <- paste(ThetaRange[1], "-", ThetaRange[2])
KRange <- range(TotalData$K)
KRange <- paste(KRange[1], "-", KRange[2])
m0Range <- range(TotalData$m0)
m0Range <- paste(m0Range[1], "-", m0Range[2])

#Bind results into table to export
Theta <- rbind.data.frame(Theta, ThetaMedian, ThetaRange)
K <- rbind.data.frame(K, KMedian, KRange)
m0 <- rbind.data.frame(m0, m0Median, m0Range)
para <- cbind(Theta, K, m0)
row.names(para) <- c("Mean", "Median", "Range")
colnames(para) <- c("Theta", "K", "m0")

#Are there correlations between the four parameters?
ThetaKCor <-cor.test(TotalData$Theta, TotalData$K,  method = "spearman")
Thetam0Cor <-cor.test(TotalData$Theta, TotalData$m0,  method = "spearman")
ThetarhoCor <-cor.test(TotalData$Theta, TotalData$rho,  method = "spearman")
Km0Cor <-cor.test(TotalData$K, TotalData$m0,  method = "spearman")
KrhoCor <-cor.test(TotalData$K, TotalData$rho,  method = "spearman")
m0rhoCor <-cor.test(TotalData$m0, TotalData$rho,  method = "spearman")

#correlations in the table
ThetaKSpearmans_rho <- round(as.numeric(ThetaKCor$estimate), 5)
ThetaKSpearmans_p <- round(ThetaKCor$p.value, 5)
Thetam0Spearmans_rho <- round(as.numeric(Thetam0Cor$estimate), 5)
Thetam0Spearmans_p <- round(Thetam0Cor$p.value, 5)
ThetarhoSpearmans_rho <- round(as.numeric(ThetarhoCor$estimate), 5)
ThetarhoSpearmans_p <- round(ThetarhoCor$p.value, 5)
Km0Spearmans_rho <- round(as.numeric(Km0Cor$estimate), 5)
Km0Spearmans_p <- round(Km0Cor$p.value, 5)
KrhoSpearmans_rho <- round(as.numeric(KrhoCor$estimate), 5)
KrhoSpearmans_p <- round(KrhoCor$p.value, 5)
m0rhoSpearmans_rho <- round(as.numeric(m0rhoCor$estimate), 5)
m0rhoSpearmans_p <- round(m0rhoCor$p.value, 5)

#Spearmans rho statistic
K_r_corr <- rbind.data.frame(K=NA, ThetaKSpearmans_rho, Km0Spearmans_rho, KrhoSpearmans_rho)
Theta_r_corr <- rbind.data.frame(ThetaKSpearmans_rho, Theta=NA, Thetam0Spearmans_rho, ThetarhoSpearmans_rho)
m0_r_corr <- rbind.data.frame(Km0Spearmans_rho, Thetam0Spearmans_rho, m0=NA, m0rhoSpearmans_rho)
rho_r_corr <- rbind.data.frame(KrhoSpearmans_rho, ThetarhoSpearmans_rho, m0rhoSpearmans_rho, rho=NA)
r_corr <- cbind(K_r_corr, Theta_r_corr, m0_r_corr, rho_r_corr)
row.names(r_corr) <- c("K", "Theta", "m0", "rho")
colnames(r_corr) <- c("K", "Theta", "m0", "rho")

#Spearmans p statistic
K_p_corr <- rbind.data.frame(K=NA, ThetaKSpearmans_p, Km0Spearmans_p, KrhoSpearmans_p)
Theta_p_corr <- rbind.data.frame(ThetaKSpearmans_p, Theta=NA, Thetam0Spearmans_p, ThetarhoSpearmans_p)
m0_p_corr <- rbind.data.frame(Km0Spearmans_p, Thetam0Spearmans_p, m0=NA, m0rhoSpearmans_p)
rho_p_corr <- rbind.data.frame(KrhoSpearmans_p, ThetarhoSpearmans_p, m0rhoSpearmans_p, rho=NA)
p_corr <- cbind(K_p_corr, Theta_p_corr, m0_p_corr, rho_p_corr)
row.names(p_corr) <- c("K", "Theta", "m0", "rho")
colnames(p_corr) <- c("K", "Theta", "m0", "rho")

write.csv(r_corr, "../../Results/Spearmansrank_r_corr.csv", row.names=TRUE, quote=FALSE)
write.csv(p_corr, "../../Other/FinalReport/Spearmansrank_p_corr.csv", row.names=TRUE, quote=FALSE)

############################################################
#The proceeding analysis was originally carried out with the whole datasets
#After plotting the acrit model fit i.e. plot(acritMod) an anomolous point
#was spotted and removed. To save script repetition I've included the analysis 
#with anomolous point removed only.
############################################################

#Remove outlying data points
TotalData <- TotalData[-c(13),]

#What were the differences in average ACrit across archipelago type and taxa?
#Aquatic or terrestrial
AquaData <- TotalData[TotalData$Aquatic_Terrestrial == "aqua", ]
AquaDataMean <- mean(AquaData$ACrit)
logAquaDataMean <- mean(AquaData$logACrit)
TerraData <- TotalData[TotalData$Aquatic_Terrestrial == "terra", ]
TerraDataMean <- mean(TerraData$ACrit)
logTerraMean <- mean(TerraData$logACrit)

#Get the mean and range of our habitat types and export as table
TerraHab <- TotalData[TotalData$Archipelago_Type == "terrestrial",]
LacHab <- TotalData[TotalData$Archipelago_Type == "lacustrine", ]
PlantHab <- TotalData[TotalData$Archipelago_Type == "plant", ]
MachHab <- TotalData[TotalData$Archipelago_Type == "machine", ]

meanTerraHab <- mean(TerraHab$ACrit)
rangeTerra <- round(range(TerraHab$logACrit), digits = 3)
rangeTerra <- paste0(rangeTerra[1], ",", rangeTerra[2])
logmeanTerraHab <- mean(TerraHab$logACrit)

meanLacHab <- mean(LacHab$ACrit)
rangeLac <- round(range(LacHab$logACrit), digits = 3)
rangeLac <- paste0(rangeLac[1], ",", rangeLac[2])
logmeanLacHab <- mean(LacHab$logACrit)

meanPlantHab <- mean(PlantHab$ACrit)
logmeanPlantHab <- mean(PlantHab$logACrit)
rangePlant <- round(range(PlantHab$logACrit), digits = 3)
rangePlant <- paste0(rangePlant[1], ",", rangePlant[2])

meanMachHab <- mean(MachHab$ACrit)
logmeanMachHab <- mean(MachHab$logACrit)
rangeMach <- round(range(MachHab$logACrit), digits = 3)
rangeMach <- paste0(rangeMach[1], ",", rangeMach[2])

Habitats <- c("Terrestrial", "Lacustrine", "Plant", "Machine")
meansHab <- round(c(logmeanTerraHab, logmeanLacHab, logmeanPlantHab, logmeanMachHab))
rangesHab <- c(rangeTerra, rangeLac, rangePlant, rangeMach)
HabDF <- data.frame(Habitats, meansHab, rangesHab)
colnames(HabDF) <- c("Habitat", "Mean log Acrit", "log ACrit Range")

#export
write.csv(HabDF, "../../Other/FinalReport/Habitats.csv", row.names=FALSE, quote=FALSE)

#get the mean of taxonomic groups

bac <- TotalData[TotalData$Taxa == "bacteria", ]
fun <- TotalData[TotalData$Taxa == "fungi", ]
alg <- TotalData[TotalData$Taxa == "algae", ]
pro <- TotalData[TotalData$Taxa == "protozoa", ]
pat <- TotalData[TotalData$Taxa == "pathogen", ]

meanbac <- mean(bac$ACrit)
meanfun <- mean(fun$ACrit)
meanalg <- mean(alg$ACrit)
meanpro <- mean(pro$ACrit)
meanpat <- mean(pat$ACrit)

logmeanbac <- mean(bac$logACrit)
logmeanfun <- mean(fun$logACrit)
logmeanalg <- mean(alg$logACrit)
logmeanpro <- mean(pro$logACrit)
logmeanpat <- mean(pat$logACrit)

#Do multiple regression analysis with log(ACrit) as dependent variable, and taxa 
#and archipelago type as categorical explanatory variables (use a two-way ANOVA) 

#boxplot of habitat types
p1 <- ggboxplot(TotalData, x="Archipelago_Type", y="logACrit", color = "Archipelago_Type", palette = "aaas")+
  rremove("legend")

#boxplot of taxonomic groups
p2 <- ggboxplot(TotalData, x="Taxa", y="logACrit", color="Taxa", palette = "npg")+rremove("legend")

#export
pdf("../../Other/FinalReport/BoxplotTotalACritArch.pdf")
print(p1)
dev.off()
pdf("../../Other/FinalReport/BoxplotTotalACritTaxa.pdf")
print(p2)
dev.off()

# Are the log(critical area) normally distributed?
shapiro.test(TotalData$logACrit) # p value < 0.05 so data are NOT normally distributed

#Are both habitat type and taxa important in predicting critical area?

#Important assumption for ANOVAS and regression analysis is that the variances
#are homogenous
#To run the model explaining log(ACrit) with habitat type and taxa group we have to assume
#that the variances within each taxa group and habitat are similar. A rule of thumb for 
#ANOVA is that the ratio between the largest and the smallest variances shouldn't be
#much more than 4.

TotalData %>%
  group_by(Archipelago_Type) %>%
  summarise (variance=var(logACrit)) #this shows there is a large variance ratio between the habitat types

TotalData %>%
  group_by(Taxa) %>%
  summarise (variance=var(logACrit)) #there is less variance but still too big!

hist(TotalData$logACrit) #lots of low values

#lets fit the model and look at the analysis of variances
acritMod <- lm(logACrit ~ factor(Archipelago_Type) + factor(Taxa), data = TotalData)
x <- anova(acritMod)
summary(acritMod)
confint(acritMod)

#habitat is not significant so we'll run the model again with just taxa group
acritMod2 <- lm(logACrit ~ factor(Taxa), data = TotalData)
x2 <- anova(acritMod2)
summary(acritMod2)
confint(acritMod2)

#We can use Tukey HSD to test all the pairwise differences 
#This is a useful test to test across multiple categories
#But to do that we need to runt he model slightly differently 
acritANOVAMod <- aov(logACrit ~ Archipelago_Type + Taxa, data = TotalData)
summary(acritANOVAMod)
confit(acritANOVAMod)

acritANOVAMod <- aov(logACrit ~ Archipelago_Type + Taxa + Archipelago_Type:Taxa, data = TotalData)
summary(acritANOVAMod)

acritModHSD <- TukeyHSD(acritANOVAMod)
acritModHSD

#This Tukey test also give us upper and lower 95% confidence intervals
#It give us two tables, the first shows with pair of habitats differ 
#in their effect on logACrit and the second shows with differences in taxa matter

#plotting the tukey test will also give us two plots 
par(mfrow=c(2,1),mar=c(4,4,1,1))
pdf("../../Other/FinalReport/TukeyTest.pdf")
plot(acritModHSD)
dev.off()

#now for model validation
par(mfrow=c(2,2))
plot(acritMod) # I stop removing anomolous data points here because the dataset is already small and
#I've already removed the worst offender

