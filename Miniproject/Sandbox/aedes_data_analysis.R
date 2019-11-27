#####SELF STANDING AEDES DATA ANALYSIS SCRIPT

rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week5/Sandbox")
graphics.off()

library("minpack.lm")
library("ggplot2")

#Aedes aegypti fecundity
#Now let's actually look at a disease vector example. These data measure
#the response of Aedes aegypti fecundity
#to temperature. First load and visualize the data:

aedes<-read.csv(file="../data/aedes_fecund.csv")

plot(aedes$T, aedes$EFD, xlab="temperature (C)", ylab="Eggs/day")

#The TPC models
#Let's define some models first:
quad1 <- function(T, T0, Tm, c){
  c*(T-T0)*(T-Tm)*as.numeric(T<Tm)*as.numeric(T>T0)
}

briere <- function(T, T0, Tm, c) {
  c*T*(T-T0)*(abs(Tm-T)^(1/2))*as.numeric(T<Tm)*as.numeric(T>T0)
}

#Instead of using the inbuilt quadratic function in R, we define our own to make it easier
#to choose starting values, and so that we can force the function to be equal to zero
#above and below the minimum and maximum temperature thresholds.
#The Briere function is a commonly used model for tempoeratuire dependent of insect traits.
#As in the case of the albatross growth data, we will also compare these two with a straight line
#again this is a linear model, so we can just use lm() wihtout needing to define a functionf or it.

#Now fit all three models using least squares. Although it's not necessary here 
#(as the data don't have as large values as the albatross example)
#we will again scale the data first:

scale <- 20

aed.lin <- lm(EFD/scale~T, data=aedes)

aed.quad <- nlsLM(EFD/scale~quad1(T, T0, Tm, c), start=list(T0=10, Tm=40, c=0.01), data=aedes)
aed.quad <- nlsLM(EFD/scale~quad1(T, T0, Tm, c), start=list(T0=10, Tm=40, c=0.01), data=aedes)

aed.br <- nlsLM(EFD/scale~briere(T, T0, Tm, c), start=list(T0=10, Tm=40, c=0.1), data=aedes)

#EXERCISES
#Complete the Aedes data analysis by fitting model, calculating predictions and
#then comparing models. Write a single, self standing script for it. Which model fits best? By what measure?

#Let's start by calculating predictions for each of the models across a range of temperatures

temp<-seq(0,40,length=100) #create a vector with 100 values ranging from 1 to 40 %>% 

pred.lm<-predict(aed.lin, newdata = list(T=temp))*scale
pred.quad<-predict(aed.quad, newdata = list(T=temp))*scale
pred.br<-predict(aed.br, newdata = list(T=temp))*scale

pred.lm <- as.data.frame(cbind(temp, pred.lm))
pred.quad <- as.data.frame(cbind(temp, pred.quad))
pred.br <- as.data.frame(cbind(temp, pred.br))

ggplot(aedes, aes(x=T, y=EFD)) +
  geom_point() +
  #geom_smooth(method="lm") +
  xlab("temperature (C)") +
  ylab("eggs/day") +
  xlim(0,40) +
  ylim(0, 25) +
  theme_bw() +
  ggtitle("My Plot") +
  geom_line(data = pred.quad, aes(x = temp, y = pred.quad), color = "green") +
  geom_line(data = pred.lm, aes(x = temp, y = pred.lm), colour = "red") +
  geom_line(data = pred.br, aes(x = temp, y = pred.br), colour = "blue")

#Next examine the residuals between the 3 models:

par(mfrow=c(3,1), bty="n")
plot(aedes$T, resid(aed.lin), main="LM resids", xlim=c(0,40))
plot(aedes$T, resid(aed.quad), main="Quad1 resids", xlim=c(0,40))
plot(aedes$T, resid(aed.br), main="Briere resids", xlim=c(0,40))

#Finally, let's compare the 3 models using a simpler approach than the AIC/BIC one that we
#used above by calculating the adjusted Sums of Squared Errors (SSEs):

n<-length(aedes$EFD) #Create a vector with the number of wt observations
list(lin=signif(sum(resid(aed.lin)^2)/(n-2*2), 3),
     quad=signif(sum(resid(aed.quad)^2)/(n-2*2), 3),
     br=signif(sum(resid(aed.br)^2)/(n-2*2), 3))

#The quad model has the lowest adjusted SSE, so it's the best by this measure.
#It is also, visually, a better fit.

#Use AIC/BIC to perform model selection on the Aedes data
AIC(aed.lin) - AIC(aed.quad) # 4.232 (Quad model is the best fit)
AIC(aed.quad) - AIC(aed.br) # -2.352 (Quad model is the best fit)

#The Quad model fits the data best according to the adjusted sums of squared errors 
#and AIC.
