# Amy Solman amy.solman19@imperial.ac.uk
# 28th October 2019
# Model Fitting

#Workshop working through multiple techniques to fit models

#library(repr) ; options(repr.plot.width=4, repr.plot.height=4) #Change plot sizes (in cm)
# - THIS BIT OF CODE IS ONLY RELEVENT IF YOU ARE USING JUPYTER NOTEBOOK, IGNORE OTHERWISE

#For starters, clear all variables and graphic devices and load necessary packages
rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week5")
graphics.off()

install.packages("repr")
library(repr)
# options(repr.plot.width=4, repr.plot.height=4) # Change default plot size; not necessary if you are using Rstudio

#Model fitting using Non-linear least squares

#Linear vs Non-linear models

#A model is linear when each term is either a constant (the y intercept)
#or the product of a parameter and a predictor variable
#A linear equation is constructed by adding the results for each term.
#This constrains the equation to one basic form:
#Response(y) = intercept + parameter*x(slope) + parameter*predictor...
#In stats, a regression equation (or function) is linear when it is linear in the parameters
#While the equation must be linear in the parameters, you can transform the predictor variables in way that produce curvature
#For instance, you can include a squared variable to produce a U-shaped curve
# Y = b0 + b1x1 + b2x1^2
#This model is still linear in the parameters even though the predictor variable is squared. 
#you can also use log and inverse functional forms that are linear in the parameters to produce
#different types of curves.

#Nonlinear regression equations
#Nonlinear equations can take many forms. 
#The easiest way to determine whether an equation is nonlinear is to focus on the term 'nonlinear'
#itself. Literally, it's not linear.
#If each term in the equation isn't either a constant (the intercept) or
# the product of a parameter and the x variable, it's nonlinear.
#Nonlinear regression then prodives the most flexible curve-fitting functionality. 

install.packages("minpack.lm") 

require("minpack.lm") #for Levenberg-Marquardt nlls fitting

#Traits data as an example
#Trait any measurable feature of an individual organism. Includes physical trailts (morphology,
#body mass, wing length), performance traits (respiration, body velocity, fecundity) and behavioural traits
#(feeding preferences, foraging strategy). All natural pops show variation in traits across
#individuals. A trait is a functional when it directly (e.g. mortality rate) or 
#indirectly (e.g. somatic development or growth rate) determines individual fitness.
#Therefore, variation in (functional) traits can generate variation in the rate of increase and persistence of pops.
#Life history/interaction traits determine pop fitness and abundance - influences dynamics and functioning
#of wider ecosystem, e.g. carbon fixation rate or disease transmission rate.

#Allomatric scaling of traits
#Allometric relationships between linear measurements such as body length
#wing span, and thorax width are a good way to obtain
#estimates of body weights of individual organisms.
#Allomentric relationships: y = ax^b where x and y are morphological measures
#the constant is the value of y at body length x=1 unit, and b is the scaling 'exponent'.
#This is also called a power law because y relates to x through a simple power

#First create a function object for the power law model
powMod <- function(x, a, b) {
  return(a * x^b)
}

MyData <- read.csv("../Data/GenomeSize.csv")

head(MyData)

#Anisoptera are dragonflies and Zygoptera are Damselflies
#The variables of interest are BodyWeight and Total Length
#Let's use the dragonflies dataset
#Subset the data accoringly and remove NAs

Data2Fit <- subset(MyData, Suborder = "Anisoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] #remove NA's

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)

#Try plotting using ggplot

library("ggplot2")

ggplot(Data2Fit, aes(x=TotalLength, y=BodyWeight)) +
  geom_point(size=(3), color="red") + theme_bw() +
  labs(y="Bodymass (mg)", x = "Wing length (mm)")

#When you write this analysis into a stand-alone R script, you
#should put all commands for loading packages (librayr, require)
#at the start of the script

#Now fit the model to the data using NLLS
PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit, start = list(a = .1, b = .1))

#Let's have a look at what nlsLM's arguments are
?nlsLM 
#R Interface to the Levenberg-Marquardt Nonlinear 
# Least-SquaresAlgorithm Found in MINPACK

summary(PowFit)

anova(PowFit) #cannot be done because the model isn't linear

#Now let's visualize the fit. For this, first we need to generate
#a vector of body lengths (the x-axis variable) for plotting

Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len=200)

#Next, calculate the predicted line
#For this we will need to extract the coefficient from the model
#fit object using the coef() command - the constant quanitity that
#multiplied the variable

coef(PowFit)["a"]
coef(PowFit)["b"]

Predic2PlotPow <- powMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])

#Now plot the data and the fitted model line

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)

#We can calculate the confidence intervals on the estimated parameters as we
#would in OLS fitting used for Linear Models

confint(PowFit)

#Exercises
#(a) Make the same plot as above, fitted line and all in ggplot, and add
#(display) the equation you estimated to your new (ggplot) plot. The equation is: Weight = 3.94 x 10^-06 x Length^2.59

#(b) Try playing with the starting values, and see if you can "break" the model fitting
#that is, change the starting values till the NLLS fitting does not converge on a solution

#(c) There is an alternative (and in fact, more commonly-used) approach for fitting
#the allometic model to data: using Ordinary Least Squares on bi-logarithamically transformed data.
#That is, if you take a log of both sides of the allometic equation we get,
# log(y) = log(a) + b log(x)
#This is a straight line equation of the form c = d + bz, where c = log(c), d - log(a), z = log(x), and b
#is now the slope parameter. So you can use Ordinary Least Squares and the linear models framework (with lm()) in R to 
#estimate the parameters of the allometric equation.

# In this exercise, try comparing the NLLS vs OLS methods to see how much 
#difference you get in the parameter estimates between them

#(e) The allometry between Body weight and Length is not the end of the story. 
#You have a number of other linear morphological measurements (HeadLength, 
#ThoraxLength, AdbdomenLength, ForewingLength, HindwingLength, ForewingArea, 
#and HindwingArea) that can also be investigated. In this exercise, try two 
#lines of investigation (again, repeated separately for Dragonflies and Damselfiles):
  
#(i) How do each of these measures allometrically scale with Body length 
#(obtain estimates of scaling constant and exponent)? 
#(Hint: you may want to use the pairs() command in R to get an overview of 
#all the pairs of potential scaling relationships.
                                                                                                                                                                                                                                                  (ii) Do any of the linear morphological measurements other than body length better predict Body weight? That is, does body weight scale more tightly with a linear morphological measurement other than total body length? You would use model selection here, which we will learn next. But for now, you can just look at and compare the R2
                                                                                                                                values of the models.






