#NLLS Fitting Script

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")
library("broom") #for using tidy()

#Start by defining the model function

chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

#In this script I will use NLLS fitting to see
#What parameters the model estimates for the mean data set?

#Let's get our mean data
data <- read.csv("../../Results/Simulation/TotalMeanResults.csv")

#To run the model fitting we need our island areas and species richness, as well as starting values for theta, m0 and K
nu = 0.001
theta <- nu*(sum(data$area-1)/(1-nu))
m <- 0.01
m0 <- m*sqrt(sum(data$area))
K <- 10

#fit the model
fit_chisholm <- nlsLM(Species_Rich ~ chisholm_model(area, theta, m0, K), data = data, start = list(theta = theta, m0 = m0, K=K))

a <- tidy(fit_chisholm)
b <- as.data.frame(a)
c <- round(b[, 2:4], digits = 2)
mergeme <- cbind(b[, 1], c, b[, 5])
names(mergeme) <- c("Terms", "Estimate", "StandardError", "Statistic", "P-Value")
mergeme$`P-Value`[1] <- c("$<$ 0.001") #check these manually
mergeme$`P-Value`[2] <- c("$<$ 0.001")
mergeme$`P-Value`[3] <- c("$<$ 0.001")
  

#Get the R-squared value of the fitting

RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
TSS <- sum((data$Species_Rich - mean(data$Species_Rich))^2) #Total sum of squares 
RSq <- 1 - (RSS/TSS) #R-squared value

#store our summary stats

mean_m0 <- mean(data$migration)*sqrt(sum(data$area))
mean_niches <- mean(data$niches)
results <- data.frame(RSq, coef(fit_chisholm)["theta"], coef(fit_chisholm)["m0"], mean_m0, coef(fit_chisholm)["K"], mean_niches)
names(results) <- c("R-Squared", "EstTheta", "EstM0", "MeanM0", "EstNiches", "MeanNiches")
results <- round(results, digits = 3)
#get estimated points to plot

area <- data$area
species <- data$Species_Rich
chisholm_points <- chisholm_model(area = area, theta = coef(fit_chisholm)["theta"], m0 = coef(fit_chisholm)["m0"], K = coef(fit_chisholm)["K"])

df1 <- data.frame(area, species)
df1$Model <- as.factor("Solman")
names(df1) <- c("Area", "Species", "ModelOrSim")
df2 <- data.frame(area, chisholm_points)
df2$Model <- as.factor("Chisholm")
names(df2) <- c("Area", "Species","ModelOrSim")
df <- rbind(df1, df2)

#Export stats results and plot data

p1 <- ggplot(df, aes(x = Area, y = Species, colour = ModelOrSim)) +
  geom_point() +
  scale_color_manual(values=c("red", "blue")) +
  theme_bw() +
  labs(title="NLLS Fitting of Chisholm Model \nto Solman Simulation Data") +
  ylab("Species Richness") +
  xlab("Island Area") +
  theme(legend.title = element_blank())

pdf("../../Results/Simulation/NLLSFit.pdf")
print(p1)
dev.off()

modOrsim <- c("Solman", "Chisholm")
modelmean <- round(mean(chisholm_points), digits = 3)
simmean <- round(mean(data$Species_Rich), digits = 3)
modelsd <- round(sd(chisholm_points), digits = 3)
simsd <- round(sd(data$Species_Rich), digits = 3)
modelrange <- round(range(chisholm_points), digits = 3)
x <- toString(modelrange[1])
y <- toString(modelrange[2])
modelrange <- paste(x, "-", y)
simrange <- round(range(data$Species_Rich), digits = 3)
x <- toString(simrange[1])
y <- toString(simrange[2])
simrange <- paste(x, "-", y)
modelvar <- round(var(chisholm_points), digits = 3)
simvar <- round(var(data$Species_Rich), digits = 3)
modelse <- round(sqrt(var(chisholm_points)/length(chisholm_points)), digits = 3)
simse <- round(sqrt(var(data$Species_Rich)/length(data$Species_Rich)), digits = 3)

NLLSSolman <- data.frame(modOrsim[1], simmean, simrange, simvar, simsd, simse)
names(NLLSSolman) <- c("ModelOrSim", "Mean", "Range", "Variance", "StandardDeviation", "StandardError")
NLLSChisholm <- data.frame(modOrsim[2], modelmean, modelrange, modelvar, modelsd, modelse)
names(NLLSChisholm) <- c("ModelOrSim", "Mean", "Range", "Variance", "StandardDeviation", "StandardError")
NLLSBind <- rbind(NLLSSolman, NLLSChisholm)

write.csv(mergeme, "../../Results/Simulation/NLLSSummary.csv", row.names = FALSE)
write.csv(NLLSBind, "../../Results/Simulation/NLLSStats.csv", row.names = FALSE)



