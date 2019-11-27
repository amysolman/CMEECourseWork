# Amy Solman amy.solman19@imperial.ac.uk
# 18th November
# Miniproject

rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week8/Code")
graphics.off()

library("minpack.lm")
library("ggplot2")
library("plyr")
library("dplyr")

#import our data

MyData <- read.csv("../Data/LogisticGrowthData.csv")
head(MyData)

#We have a logistic growth dataset
#The main parameters we are interested in are Time/PopBio

#plot full dataset
plot(MyData$PopBio, MyData$Time)

#plot log full dataset
plot(log(MyData$PopBio), log(MyData$Time))

#plot full data set with ggplot:
ggplot(MyData, aes(x=log(Time), y=log(PopBio))) +
  geom_point(size=(3), color="red") + theme_bw() +
  labs(y="PopBio", x= "Time")

#Data can be divided up by species
Y <- split(MyData, with(MyData, interaction(Species)), drop = TRUE)

#and species and temp
X <- split(MyData, with(MyData, interaction(Species,Temp)), drop = TRUE)

ggplot(X[[1]], aes(x=log(Time), y=log(PopBio))) +
  geom_point(size=(3), color="red") + theme_bw() +
  labs(y="PopBio", x= "Time")

plot(X[[1]]$Time, X[[1]]$PopBio)

#X has 208 sets of data

for (i in 1:length(X)) {
  plot(X[[i]]$Time, X[[i]]$PopBio, main = X[[i]]$Species[1], xlab = "Time", ylab = "PopBio")
}

#Plot and save each Time/PopBio for Species/Temp
for (i in 1:length(X)) {
  pdf(paste("../Results/Plots/PopGrowth_",names(X)[i],".pdf"))
  plot(X[[i]]$Time, X[[i]]$PopBio, main = X[[i]]$Species[1], xlab = "Time", ylab = "PopBio")
  dev.off()
}


#Do the same with GGPlot
for(i in 1:length(X)){
  p = ggplot(X[[i]], aes(x=Time, y=PopBio)) +
    geom_point(size=(3), color="red") + theme_bw() +
    labs(y="PopBio", x= "Time")
  pdf(paste0("../Results/GG_Plots/Pop_Growth_",names(X)[i],".pdf"))
  print(p)
  dev.off()  
}

#Print and save whole species data plots
for(i in 1:length(Y)){
  p = ggplot(Y[[i]], aes(x=Time, y=PopBio)) +
    geom_point(size=(3), color="red") + theme_bw() +
    labs(y="PopBio", x= "Time")
  pdf(paste0("../Results/SpeciesPlots/Pop_Growth_Species",names(Y)[i],".pdf"))
  print(p)
  dev.off()  
}

#Do we need to scale the data before fitting to improve the stability of the estimates?
#Feature scaling is a method used to normalise the range of independent
#variables of features of data. In data processing, it is also known as data 
#normalisation and is generally performed during the data preprocessing step.
#Most of the time, your dataset will contain deatures highly varying in
#magnitude, units and range. But since most of the machine learning algorithms use 
#Eucledian distance between two data points in their computations this is a problem.
#If left alone, these algorithms only take in the magnitude of features neglecting the units. 
#The result would vary greatly between different units, 5kg and 5000g. The features with high magnitudes
#will weigh in a lot more in the distance calculations than features with low magnitudes.
#To supress this effect, we need to brung all features to the same level of magnitudes.
#This can be achieved by scaling.
#scale<-4000

time <- c(0, 2, 4, 6, 8, 10, 12, 16, 20, 24) #timepoints in hours
log_cells <- c(3.62, 3.62, 3.62, 4.12, 5.23, 6.27, 7.57, 8.38, 8.70, 8.69) #logged cell counts - more on this below

set.seed(1234) #set seed to ensure you always get the same random sequence of fluctuations

data <- data.frame(time, log_cells + rnorm(length(time), sd=.1)) #add some random error

names(data) <- c("t", "LogN")

head(data)

#We have added a vector of normally distributed errors to emulate random "sampling errors".
#Note also that the assumption of normality of errors underlies the statistical analysis of Ordinary NLLS fits, 
#just as it underlies Ordinary Least Squares (your standard linear modelling).
#In this case, we are talking about log-normality because we are using logged cell counts. Why log them?
#Because NLLS often converges better if you linearize the data (and correspondingly, the model -
#see how the models are specified below).

#Plot the data:

ggplot(data, aes(x = t, y = LogN)) + geom_point()

#We will fit three growth models, all of which are known to fit such population growth data, especially in microbes.
#These are a modified Gompertz model, the Barannyi model, and the Buchanan model
#(or three-phase logistic model). Given a set of cell numbers (N) and times (t), each growth model
#can be described in terms of:
#N0 - initial cell culture (population) density (number of cells per unit volume)
#Nmax - Maximum culture density (aka carrying capacity)
#rmax - Maximum growth rate
#tlag - Duration of the lag phase before the population starts growing exponentially

#First let's specify the model functions:


#####Here are some models we can use:

#classical logistic growth equation,

#CLASSICAL LOGISTIC GROWTH MODEL
logistic1<-function(t, r, K, N0){
  N0*K*exp(r*t)/(K+N0*(exp(r*t)-1))
}
#BARANYI MODEL
baranyi_model <- function(t, r_max, N_max, N_0, t_lag){
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}
#BUCHANAN MODEL (THREE PHASE LOGISTIC)
buchanan_model <- function(t, r_max, N_max, N_0, t_lag){ 
  return(N_0 + (t >= t_lag) * (t <= (t_lag + (N_max - N_0) * log(10)/r_max)) * r_max * (t - t_lag)/log(10) +
           (t >= t_lag) * (t > (t_lag + (N_max - N_0) * log(10)/r_max)) * (N_max - N_0))
}  
#MODIFIED GOMPERTZ MODEL
gompertz_model <- function(t, r_max, N_max, N_0, t_lag){
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1)))
}

#Now we're going to fit the LOGISTIC model to the data using NLLS

#How to create a individual dataframes in a loop:
for (i in 1:length(X)){
  df[i] <- as.data.frame((X[[i]]))
}

#Create an individual dataframe
df1 <- as.data.frame(X[[1]])

df1.log<-nlsLM(PopBio~logistic1(Time, r, K, N0), start=list(K=1, r=0.1, N0=0.1), data=df1)

#So, what's happening here? We're going to use the non-linear least squares function
#to generate an equation that explains bodyweight (y) by total length (x)
#We call upon the power model function we created earlier than manually created the 
#allometric scaling of traits equation y = a*x^b
#So we're asking the non-linear least squares function to find the best way of explaining body weight, 
#using the allometric scaling equation where x is total length and a is our coefficient,
#and b is our exponent.

#It is important to note that we have written the function in log (to the base 10 - can also be base 2 or natural log)
#scale because we want to do the fitting in log scale (both model and data linearized). The interpretation of each of the 
#estimated/fitted parametrs does not change if we take a log of the model's equation.

#Now let's generate some starting values for the NLLS fitting. We did not pay much attention to what starting values we used 
#in the above example on fitting an allometric model because the power-law model is easy to fit using NLLS, and starting 
#far from the optimal paramaters does not matter too muchl. Here, we derive the starting values by using the actual data:

N_0_start <- min(data$LogN)
N_max_start <- max(data$LogN)
t_lag_start <- data$t[which.max(diff(diff(data$LogN)))]
r_max_start <- max(diff(data$LogN))/mean(diff(data$t))

