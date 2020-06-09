#NLLS Fitting Script

rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")

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
summary(fit_chisholm)

#Get the R-squared value of the fitting

RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
TSS <- sum((data$Species_Rich - mean(data$Species_Rich))^2) #Total sum of squares 
RSq <- 1 - (RSS/TSS) #R-squared value

#store our summary stats

mean_m0 <- mean(data$migration)*sqrt(sum(data$area))
mean_niches <- mean(data$niches)
results <- data.frame(RSq, coef(fit_chisholm)["theta"], coef(fit_chisholm)["m0"], mean_m0, coef(fit_chisholm)["K"], mean_niches)
names(results) <- c("R-Squared", "EstTheta", "EstM0", "MeanM0", "EstNiches", "MeanNiches")

#get estimated points to plot

area <- data$area
species <- data$Species_Rich
chisholm_points <- chisholm_model(area = area, theta = coef(fit_chisholm)["theta"], m0 = coef(fit_chisholm)["m0"], K = coef(fit_chisholm)["K"])
df1 <- data.frame(area, chisholm_points)
df1$Model <- "Chisholm Model"
names(df1) <- c("Area", "Species","ModelOrSim")
df2 <- data.frame(area, species)
df2$Model <- "Solman Sim"
names(df2) <- c("Area", "Species", "ModelOrSim")
df <- rbind(df1, df2)

#Export stats results and plot data

p1 <- ggplot(df, aes(x = Area, y = Species, group = ModelOrSim)) +
  geom_point(aes(colour = ModelOrSim)) +
  geom_line(data = df[df$ModelOrSim == "Chisholm Model", ], aes(x = Area, y = Species, colour = "Chisholm Model")) +
  theme(legend.title = element_blank()) +
  theme_bw() +
  labs(title="NLLS Fitting of Chisholm Model \nto Solman Simulation Data") +
  geom_text(x=150, y=6, label= "R-Squared:") +
  geom_text(x=180, y =6, label = round(RSq, digits = 2)) +
  geom_text(x=150, y =5, label = "Theta:") +
  geom_text(x=180, y=5, label = round(coef(fit_chisholm)["theta"], digits = 2)) +
  geom_text(x=150, y=4, label = "m0:") +
  geom_text(x=180, y=4, label = round(coef(fit_chisholm)["m0"], digits = 2)) +
  geom_text(x=150, y=3, label= "Niches:") +
  geom_text(x=180, y=3, label= round(coef(fit_chisholm)["K"], digits = 2))

pdf("../../Results/Simulation/NLLSFit.pdf")
print(p1)
dev.off()

write.csv(results, "../../Results/Simulation/NLLSMeanStats.csv", row.names = FALSE)



