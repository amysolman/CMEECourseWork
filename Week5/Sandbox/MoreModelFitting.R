# Amy Solman amy.solman19@imperial.ac.uk
# 5th November
# Model Fitting


#For starters, clear all variables and graphic devices and load necessary packages
rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week5/Sandbox")
graphics.off()

#Install nls.lm – what’s this? The standard non-linear least squares (NLLS) 
#function in R (called nls) uses a less robust algorithm called the Gauss-Newton algorithm.
#Nls will often fail to fit your model to the data if you start off at starting values 
#for the parameters (coefficients) that are too far off from the optimal values.
#Especially if the "parameter space" is weirdly shaped
#i.e. the model has a mathematical form that makes it hard to 
#find parameter combinations that minimize the residual sun of squares (RSS).
#So, basically, we want to use nls_LM from the nls.lm package rather than nls
#It's just better okay, so just chill.

install.packages("minpack.lm")
library("minpack.lm")

#Awesome! We have a package that will help us fit our model using the
#non-linear least squares method - find the smallest squared residuals
#even when we've got non-linear coefficients

########TRAITS DATA AS AN EXAMPLE#########
#Our first set of examples will focus on traits
#A trait is any measurable feature of an individual organism.
#This includes physical traits (e.g. morphology, bodymass, wing length),
#performance traits (e.g. respiration rate, body velocity, fecundity),
#and behavioural traits (e.g. feeding parameters, foraging strategy, mate choice).
#All natural populations show variation in traits across individuals. 
#A trait is a function when it directly (e.g. mortality rate) 
#or indirectly (e.g. somatic development/growth rate) determines
#individual fitness. Therefore, variation in (functional - effecting fitness)
#traits can generate variation in the rate of increase and persistence of populations.
#So, physical, performance or behaviour traits can increase or decrease
#fitness, thus affecting the increase/persistance of populations.
#When measured in the context of life cycles,
#without considering interactions of other organisms (e.g. predators or prey of the focal
#functional traits are typically called life history traits (such as mortality rate or fecundity).
#So, life history traits are physical, perfromance or behavioural traits
#that are considered outside the influence of other organisms
#e.g. mortality rate or mating frequency - don't have anything to do (more or less)
#with other species. Other trsits determine interactions both within
#the focal population (e.g. intra-specific interference or mating frequency)
#and between the focal population/species and others, including the species
#which may act as resources (e.g. prey). Thus, both life history (not involving other species)
#and interaction traits determine population fitness (it's ability to pass genetic
#info (alleles) to the next generation) and therefore abundance,
#which ultimately influences dynamics and functioning of the wider ecosystem, such as carbon
#fixation rate or disease transmission rate.

##########ALLOMETRIC SCALING OF TRAITS##########
#Let's starr with a common and reasonably simple example from biology:
#Allometric scaling. 
#Allometry in biology is the change in an organism in relation to proportional 
#changes in it's body size. 
#Allometry, in its broadest sense, describes how the characteristics
#of living creatures change with size. The term originally refered to 
#the scaling relationship between the size of a body part 
#and the size of the body as a whole, as both grow during development.
#However, more recently the meaning of the term allometry has been modified
#and expanded to refer to biological scaling relationships in general, 
#be it for morphological traits (e.g. the relationship between brain size and body size
#among adult humans), physiological traits (e.g. the relationship between metabolic 
#rate and body size among mammal species) or ecological traits
#(e.g. the relationship between wing size and flight performance 
#in birds). 
#Allometric relationships between linear measurements such as body length,
#wing span, and thorax width are a good way to obtain estimates
#of body weights of individual organisms. We will look at allometric scaling of
#body weight vs. total body length in dragonflies and dameselflies.

#Allometric relationships take the form: y=ax^b
#where x and y are morphological measures (body length and body weight, in our example
#the constant is the value of y at body length x=1 unit, and b is the scaling "exponent"
#This is also called a power-law, because y relates to x through a simple power.
#In statistics, a power law is a functional relationship between two quantities
#where a relative change in one quanitity results in a proportional
#relative change in the other quantity, independent of the initial size of those
#quantities: one quantity varies as a power of another. 
#The power law is also called the scaling law. It states a relative change in one
#quantity results in a proportional relative change in another. 
#The simplest example of the law in action is a square. 
#If you double the length of a size, the area will quadruple.

#Let's create a function object for the power law model:

powMod <- function(x, a, b) { #We've given our function a name and told it
  #to take values for x, a and b
  return(a * x^b) # our output should be y which is a * x^b
}

#Now we're going to import out data

MyData <- read.csv("../Data/GenomeSize.csv")
head(MyData)

#Here we see that Anisoptera are dragonflies and Zygoptera are Damselflies
#The variables of interest are BodyWeight and TotalLength
#LEt's use the dragonflies subset

#So subset the data accordingly and remove NAs:
#We create a new data frame with only the dragonflies suborder
Data2Fit <- subset(MyData, Suborder == "Anisoptera")

#Update our dataframe to exclude individuals for whome we don't have bodyweight/length values
Data2Fit <- subset(Data2Fit, BodyWeight != "NA")
Data2Fit <- subset(Data2Fit, TotalLength != "NA")

#An alternative way of doing the same thing...
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),]

#Now, let's plot the data!

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)

#We can do the same thing using ggplot:

library("ggplot2")

ggplot(Data2Fit, aes(x=TotalLength, y=BodyWeight)) +
  geom_point(size=(3), color="red") + theme_bw() +
  labs(y="Body mass (mg)", x= "Wing Lengths (mm)")
#So we've created a lovely scatter plot of our Wing length by Bodymass

#Remember, when you write this analysis into a stand-alone
#R script, you should put all commands for loading packages
#(library(), require()), at the start of the script

#Now we're going to fit the model to the data using NLLS

PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit,
                start = list(a=.1, b=.1))

#So, what's happening here? We're going to use the non-linear least squares function
#to generate an equation that explains bodyweight (y) by total length (x)
#We call upon the power model function we created earlier than manually created the 
#allometric scaling of traits equation y = a*x^b
#So we're asking the non-linear least squares function to find the best way of explaining body weight, 
#using the allometric scaling equation where x is total length and a is our coefficient,
#and b is our exponent.

?nlsLM #there are various arguments (alterations you can make to the function) to fit
#your specific non-linear least squares fitting needs

#Let's see what the NLLS function came up with to explain BodyWeight

summary(PowFit)

# Formula: BodyWeight ~ powMod(TotalLength, a, b)
# 
# Parameters:
#   Estimate Std. Error t value Pr(>|t|)    
# a 3.941e-06  2.234e-06   1.764    0.083 .  
# b 2.585e+00  1.348e-01  19.174   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.02807 on 58 degrees of freedom
# 
# Number of iterations to convergence: 39 
# Achieved convergence tolerance: 1.49e-08

#This is our summary output, but what do all these things mean?
#Firstly, at the top we have the formula used by the NLLS function 
#to find the best equation for our data
#Then we have descriptive statistics of our coefficient a and exponent b
#Firstly we have the estimated values, for a this is 0.000003941
#and for b this is 2.585
#We then have the standard error of our line (equation/model) from the actual data points
#due to variable a = 0.000002234 and  b = 0.1348 - we want our standard errors
#to be as small as possible!
#What about t-tests? A t-test uses, you guessed it, the t distribution. 
#The t-test is used to check the significance of coefficients.
#The t-test: are the coefficients (effect sizes) bigger than zero? 
#So we want a large coefficient value divided by small standard error 
#(the amount our line differs from the data points. How much does changing 
#the explanatory variable change our response variable? So a larger t value shows 
#that our coefficients are significantly different from zero and significantly affect 
#our response variable.
#We want our t-values to be +/-2, so here it is the exponent b that seems to most
#significantly affect our response variable BodyWeight.
#Now for p-values, we want a p-value of <0.05 to show significance. Once again,
#the b variable is very small so we see that the exponent acting on our explanatory variable,
#TotalLength explains the response variable more than our coefficient
#Most of the output is analogous to the output of an lm(). However,
#further statistical inference here cannot be done using analysis of variance (ANOVA)
#because the model is not linear (it contains an exponent).

#Now, let's visualise the fit. For this, first we need to generate a vector of body
#lengths (the x-axis variabel) for plotting:

Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len=200)

#Next, calculate the predicted line. For this, we will need to extract the coefficient from
#the model fit object using the coef() command.
#Basically, what we're doing here is creating a vector of total lengths 
#these are the data points of our x-axis and the values we need to plug into our
#power law function. The coefficients it gives us are actually the same values we talked about earlier
#a = 0.00000394 and b = 2.585

a <- coef(PowFit)["a"]
b <- coef(PowFit)["b"]

#So we can generate the fitted model using our previous power law function.
#We take the vector of lengths as our x (explanatory variable), the coefficient of a and b estimated
#by the non-linear least squares function we used earlier

Predic2PlotPow <- powMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])

#Now plot the data and the fitted model line:

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col= "blue", lwd=2.5)

#Tada! Amazing! We have a plot of data and a fitted linear model
#We can calculate the confidence intervals on the estimated parameters 
#as we would in OLS fitting used for Linear Models
#Confidence intervals tell us that we can be 95% certain the values 
#of our coefficients will fall within this range

confint(PowFit)

##########EXERCISES PART ONE##########
#A
#Okay, next we're going to make the same plot as above, fitted line and all, in ggplot,
#and add (display) the equation you estimated to our new plot.
#The equation is: Weight = 3.94 x 10^-06 x Length^2.59.

require(ggplot2)

#and put them in a dataframe
#my_data <- data.frame(x=Data2Fit$TotalLength, y=Data2Fit$BodyWeight)

#perform a linear regression
# my_lm <- summary(lm(BodyWeight ~ TotalLength, data = Data2Fit))

#plot the data
##########CAN YOU USE GEOM_SMOOTH INSTEAD ON NON-LINEAR REGRESSION##########
my_plot <- ggplot(Data2Fit, aes(x=TotalLength, y=BodyWeight)) +
  geom_point(size=(3), color="red") + theme_bw() +
  geom_smooth() +
  labs(y="Body mass (mg)", x= "Total Length (mm)")

my_plot

#add the regression line
# my_plot <- my_plot + geom_abline(
#   intercept = my_lm$coefficients[1],
#   slope = my_lm$coefficients[2],
#   colour = "blue")

#throw some math on the plot
##########HOW TO MAKE MY EQUATION BETTER##########
my_plot <- my_plot + geom_text(aes(x = 60, y = 0,
                       label = "Weight=3.94*10^-06*Length^2.59"),
                   parse = TRUE, size = 6,
                   colour = "blue")
my_plot

#B 
#Try plying with the starting values, and see if you can "break"
#the model fitting -- that is, change the starting values till
#the nlls fitting does not converge on a solution

##########DOES THIS MEAN CHANGE THE STARTING VALUES IN POWFIT FUNCTION##########
# PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit,
#                 start = list(a=100000000, b=9999999999))

#C
#Repeat the model fitting, (including a-b above) using the Zygoptera data subset

#We've already got our fucntion object for the power law model
#And we've imported out dataset, now we need to subset it to include the Zygoptera (Damselflie) data

Data2Fit2 <- subset(MyData, Suborder == 'Zygoptera')

#We'll plot the data

plot(Data2Fit2$TotalLength, Data2Fit2$BodyWeight)

#Or we can do this using ggplot

ggplot(Data2Fit2, aes(x=TotalLength, y=BodyWeight)) +
  geom_point(size=(3), color="red") + theme_bw() +
  labs(y="Body mass (mg)", x = "Total Lengths (mm)")

#Now we're going to fit the model to the data using NLLS

PowFit2 <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit2,
                 star = list(a=.1, b=.1))

#Now let's see the summary of our non-linear least squares model for Zygoptera

summary(PowFit2)

#Now, let's visualise the fit. For this, first we need to generate a vector of body
#lengths (the x-axis variabel) for plotting:

Lengths2 <- seq(min(Data2Fit2$TotalLength), max(Data2Fit2$TotalLength), len=200)

#We'll find our coefficients for our NLLS model and save them as numeric values

a <- coef(PowFit2)["a"]
b <- coef(PowFit2)["b"]

#So we can generate the fitted model using our previous power law function.
#We take the vector of lengths as our x (explanatory variable), the coefficient of a and b estimated
#by the non-linear least squares function we used earlier

Predic2PlotPow2 <- powMod(Lengths2, coef(PowFit2)["a"], coef(PowFit2)["b"])

#Now plot the data and the fitted model line:

plot(Data2Fit2$TotalLength, Data2Fit2$BodyWeight)
lines(Lengths2, Predic2PlotPow2, col = "blue", lwd=2.5)

#We can calculate the confidence intervals on the estimated parameters 
#as we would in OLS fitting used for Linear Models
#Confidence intervals tell us that we can be 95% certain the values 
#of our coefficients will fall within this range

##########WHY DO THESE CONFIDENCE INTERVALS HAVE NA IN THEM##########
confint(PowFit2)

# now we'll do the same with ggplot
#plot the data

##########CAN YOU USE GEOM_SMOOTH INSTEAD ON NON-LINEAR REGRESSION##########

my_plot2 <- ggplot(Data2Fit2, aes(x=TotalLength, y=BodyWeight)) +
  geom_point(size=(3), color="red") + theme_bw() +
  geom_smooth() + 
  labs(y="Body mass (mg)", x = "Total Length (mm)")

#throw some math on the plot
##########HOW TO MAKE MY EQUATION BETTER##########
my_plot2 <- my_plot2 + geom_text(aes(x = 40, y = 0,
                                   label = "Weight=1.21*10^-06*Length^2.59"),
                               parse = TRUE, size = 6,
                               colour = "blue")
my_plot2

#B 
#Try plying with the starting values, and see if you can "break"
#the model fitting -- that is, change the starting values till
#the nlls fitting does not converge on a solution

##########DOES THIS MEAN CHANGE THE STARTING VALUES IN POWFIT FUNCTION##########
PowFit2 <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit2,
                 star = list(a=.1, b=.1))

#D
#There is an alternative (and in fact, more commonly-used) approach for fitting
#the allometric model to data: using Ordinary Least Squares on bi-logarithmically
#transformed data. That is, if you take a log of both sides of the allomatric equation 
#we get , log(y) = log(a) + b log(x)
#This is a straight line equation of the form c = d + bz where c = log(c)
#d = log(d), z = log(x), and b is now the slope parameter.So you can use Ordinary Least Squares
#and the linear models framework (with lm()) in R to estimate the parameters of the allometric equation. 

#In this exercise, try comparing the NLLS vs OLS methods to see how much difference you get in the parameter estimates between
#them.

#So here we are being asked to find the equation that best explains body mass with total length using the ordinary least
#squares method. How do we use the ordinary least squares method? 

#This is how you would do a normal linear regression 
# my_lm <- summary(lm(y ~ x, data = my_data))

library(dplyr)

#Plot the Anisoptera (Dragonfly) data
Data2Fit %>%
  ggplot(aes(x = TotalLength, y = BodyWeight)) +
  geom_point(colour = "red")

#The strength of the relationship can be quantified using the 
#Pearson correlation coefficient

cor(Data2Fit$TotalLength, Data2Fit$BodyWeight) #Strong positive correlation

#As the realtionship is non-linear, we will transform the response
#and predictor variable in order to coerce the realtionship to one
#that is more linear

Data2Fit %>%
  ggplot(aes(x = log(TotalLength), y = log(BodyWeight))) +
  geom_point(colour = "red")
#The next step is to determine if whether the relationship is statistically
#significant and not just some random occurrence. This is done by investigating
#the variance of the data points about the fitted line. If the data fit well to 
#the line, then the relationship is likely to be a real effect.
#The goodness of fit can be easily quantified using the root mean squared error (RMSE)
#and r-squared metrics. The RMSE represents the variance of the model errors and is
#an absolute measure of fit which has units identical to the response variable.
#R-squared is simply the Pearson correlation coefficient squared and represents
#variance explained in the response variable by the predictor variable.
#The number of data points is also important and influence the p-value of the model.
#A rule of thumb for OLS linear regression is that at least 20 data points
#are required for a valid model. The p-value is the probability of there being
#no relationship (null hypothesis) between the variables.

#An OLS linear model is now fit to the transformed data.

Data2Fit %>%
  ggplot(aes(x = log(TotalLength), y = log(BodyWeight))) +
  geom_point(colour = "red") +
  geom_smooth(method = "lm", fill = NA)

#The model object can be created as follows:

OLS_Dragon <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit)

#The slope and intercept can be obtained

OLS_Dragon$coefficients

#And the model summary contains important information

summary(OLS_Dragon)

#The p-value indicated a statistically significant relationship at the 
#p<0.001 cut-off level. The multiple R-squared value (R-squared) of 0.859
#gives the variance explained and can be used as a measure of predictive power
#(in the absence of overfitting). 
#The take home message from the output is that for every unit increase in the log
#Total Length, there is a 2.422 increase in the log Body Weight.
#Therefore, body weight increases with increasing total length.

#Now, let's try the OLS method again with Zygoptera

Data2Fit2 %>%
  ggplot(aes(x = log(TotalLength), y = log(BodyWeight))) +
  geom_point(colour = "red") +
  geom_smooth(method = "lm", fill = NA)

OLS_Damsel <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit2)
OLS_Damsel$coefficients
summary(OLS_Damsel)

##########WHAT CAN I INFER FROM THESE DIFFERENCES##########
#Finally, let's compare the parameter estimates (a as intercept, and b as total length exponent)
#with the NLLS and OLS methods
#NLLS - Dragon (a=0.000003941, b=2.585), Damsel (a=0.000001.208, b=2.589)
#OLS - Dragon (a=-11.818, b=2.422)m Damsel (a=-15.005, b=2.956)


#E
#The allometry between Body weight and Length is not the end of the story.
#You have a number of other morphological measurements (HeadLength, ThoraxLength, AbdomenLength
#ForewingLEngth, HindwingLength, ForewingArea, and HindwingArea) that can also be investigated.
#In this exercise, try two lines of investigation (again, repeated seperately for Dragonflies and Damselflies):

#i
#How do each of these measures allometrically scale with Body length (obtain estimates of scaling constant
#and exponent)? (Hint: you may want to use the pairs() command in R to get an overview of all the pairs
#of potentially scaling relationships)

#How do each of these measurements increase with total length (how are they explained by total length)?

##########IS THIS THE CORRECT WAY TO DRAW A PAIRS GRAPH##########
pairs(~ TotalLength + HeadLength + ThoraxLength + AdbdomenLength + 
        ForewingLength + HindwingLength + ForewingArea + HindwingArea, data = Data2Fit)

pairs(~TotalLength + HeadLength + ThoraxLength + AdbdomenLength +
        ForewingLength + HindwingLength + ForewingArea + HindwingArea, data = Data2Fit2)

#We can see from the pairs plots for Dragonflies and Danselflies that there appears to be a positive 
#correlation between TotalLength and all other body measurements. From here we can investigate each
#morphological measure to see how each of them scale with body length. 

#ORDINARY LEAST SQUARES METHOD WITH BI-LOGARITHMIC ADJUSTMENT

#ANISOPTERA

OLS_Drag_Head <- lm(log(HeadLength) ~ log(TotalLength), data = Data2Fit)
summary(OLS_Drag_Head) #R^2 0.6306
#Scaling constant = -0.876 exponent = 0.623
OLS_Drag_Thorax <- lm(log(ThoraxLength) ~ log(TotalLength), data = Data2Fit)
summary(OLS_Drag_Thorax) #R^2 0.7586
#Scaling constant = -0.364 exponent = 0.688
OLS_Drag_Adbdomen <- lm(log(AdbdomenLength) ~ log(TotalLength), data = Data2Fit)
summary(OLS_Drag_Adbdomen) #R^2 0.984
#Scaling constant = -0.957 exponent = 1.152
OLS_Drag_ForeL <- lm(log(ForewingLength) ~ log(TotalLength), data = Data2Fit)
summary(OLS_Drag_ForeL) #R^2 0.8218
#Scaling constant = 0.506 exponent = 0.782
OLS_Drag_ForeA <- lm(log(ForewingArea) ~ log (TotalLength), data = Data2Fit)
summary(OLS_Drag_ForeA) #R^2 0.7956
#Scaling constant = -0.018 exponent = 1.393
OLS_Drag_HindL <- lm(log(HindwingLength) ~ log(TotalLength), data = Data2Fit)
summary(OLS_Drag_HindL) #R^2 0.8288
#Scaling constant = 0.403 exponent = 0.799
OLS_Drag_HindA <- lm(log(HindwingArea) ~ log(TotalLength), data = Data2Fit)
summary(OLS_Drag_HindA) #R^2 0.7434
#Scaling constant = 0.269 exponent = 1.37

#For anisoptera total length has the strongest relationship with abdoment length
#with an r^2 value of 0.98, a scaling constant = -0.957 exponent = 1.152

#ZYGOPTERA

OLS_Damsel_Head <- lm(log(HeadLength) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_Head) #R^2 0.784
#Scaling constant = -2.819 exponent = 0.972
OLS_Damsel_Thorax <- lm(log(ThoraxLength) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_Thorax) #R^2 0.93
#Scaling constant = -1.873 exponent = 0.999
OLS_Damsel_Adbdomen <- lm(log(AdbdomenLength) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_Adbdomen) #R^2 0.995
#Scaling constant = -0.242 exponent = 1.003
OLS_Damsel_ForeL <- lm(log(ForewingLength) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_ForeL) #R^2 0.91
#Scaling constant = -1.018 exponent = 1.139
OLS_Damsel_ForeA <- lm(log(ForewingArea) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_ForeA) #R^2 0.7913
#Scaling constant = -4.985 exponent = 2.555
OLS_Damsel_HindL <- lm(log(HindwingLength) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_HindL) #R^2 0.917
#Scaling constant = -1.226 exponent = 1.182
OLS_Damsel_HindA <- lm(log(HindwingArea) ~ log(TotalLength), data = Data2Fit2)
summary(OLS_Damsel_HindA) #R^2 
#Scaling constant = -5.287 exponent = 2.614

#For zygoptera total length had the strongest relationship with abdomen length
#with an R^2 value of 0.995, a scaling constant = -0.242 and exponent = 1.003

#ii
#Do any of the linear morphological measurements other than body length better
#predict body weight? That is, does body weight scale more tightly with a linear morphological
#measure other than total body length?
#You would use model selection here, which we will learn next. But for now, you can just
#look at and compare the R^2 values of the models.

#R^2 value of bodyweight explained by total length = 0.8593

##########SHOULD I BE USING THE MULTIPLE R-SQUARES ON THE ADJUSTED R-SQUARED##########
##########WHAT'S THE BEST WAS TO INTERPRET LOGARITHMICALLY SCALED RESULTS##########

OLS_Drag_Head <- lm(log(BodyWeight) ~ log(HeadLength), data = Data2Fit)
summary(OLS_Drag_Head) #R^2 0.5744
OLS_Drag_Thorax <- lm(log(BodyWeight) ~ log(ThoraxLength), data = Data2Fit)
summary(OLS_Drag_Thorax) #R^2 0.7871
OLS_Drag_Adbdomen <- lm(log(BodyWeight) ~ log(AdbdomenLength), data = Data2Fit)
summary(OLS_Drag_Adbdomen) #R^2 0.808
OLS_Drag_ForeL <- lm(log(BodyWeight) ~ log(ForewingLength), data = Data2Fit)
summary(OLS_Drag_ForeL) #R^2 0.7625
OLS_Drag_ForeA <- lm(log(BodyWeight) ~ log (ForewingArea), data = Data2Fit)
summary(OLS_Drag_ForeA) #R^2 0.7541
OLS_Drag_HindL <- lm(log(BodyWeight) ~ log(HindwingLength), data = Data2Fit)
summary(OLS_Drag_HindL) #R^2 0.7696
OLS_Drag_HindA <- lm(log(BodyWeight) ~ log(HindwingArea), data = Data2Fit)
summary(OLS_Drag_HindA) #R^2 0.7078

#For our dragonfly data, bodyweigth was scaled more tightly with body length 
# than any other morphological features as our OLS fitted model gave the highest R^2 value (0.859)
#As R^2 is a goodness of fit measure for linear regression models. This statistics indicates the 
#percentage of the variance in the dependent variable (body weight) that the independent variables 
#(morphological features) explain. R-squared measures the strength of the realtionship between your 
#model and the dependent variable on a convenient 0-100% scale. So 86% of variance in bodyweight
#is explained by total length for Anisoptera.

#ZYGOPTERA - DAMSELFLIES
#R-squared of bodyweight explained by total length = 0.8663

OLS_Damsel_Head <- lm(log(BodyWeight) ~ log(HeadLength), data = Data2Fit2)
summary(OLS_Damsel_Head) # R^2 0.8898
OLS_Damsel_Thorax <- lm(log(BodyWeight) ~ log(ThoraxLength), data = Data2Fit2)
summary(OLS_Damsel_Thorax) # R^2 0.938
OLS_Damsel_Adbdomen <- lm(log(BodyWeight) ~ log(AdbdomenLength), data = Data2Fit2)
summary(OLS_Damsel_Adbdomen) # R^2 0.8199
OLS_Damsel_ForeL <- lm(log(BodyWeight) ~ log(ForewingLength), data = Data2Fit2)
summary(OLS_Damsel_ForeL) # R^2 0.8846
OLS_Damsel_ForeA <- lm(log(BodyWeight) ~ log(ForewingArea), data = Data2Fit2)
summary(OLS_Damsel_ForeA) # R^2 0.7812
OLS_Damsel_HindL <- lm(log(BodyWeight) ~ log(HindwingLength), data = Data2Fit2)
summary(OLS_Damsel_HindL) # R^2 0.8796
OLS_Damsel_HindA <- lm(log(BodyWeight) ~ log(HindwingArea), data = Data2Fit2)
summary(OLS_Damsel_HindA) # R^2 0.7712

#For our damselfly data, head length (R^2 = 0.889) scaled more tightly with body weight than 
#total length (R^2 = 0.866) or any other morphological variable. So 89% of variance in body weight
#is explained by head length for zygoptera.

##########COMPARING MODELS##########
#How do we know that there isn't a better or alternative model that adequately explains
#the pattern in your dataset?

#This is an important consideration in all data analyses (and more generally,
#the scientific method!), so you must aim to compare your NLLS model with
#one or more alternatives for a more extensive and reliable investigation of the problem.

#Let's use model comparison to investigate whether the relationship between body weight and length
#we found above is indeed allomatric. For this, we need an alternative model that can be fitted 
#to the same data. Let's try a quadratic curve, which is of the form:
#y = a + bx + cx^2
#This can also be capture curvature in data, and is an alterntive model to the allometric equation.
#Note that this mode is linear in its parameters (a linear model),
#which you can fit to the simply data using your family lm() function.

QuaFit <- lm(BodyWeight ~ poly(TotalLength,2), data = Data2Fit)
#So here we have used the linear model function (lm()) to create an alternative
#linear model in the form of a quadratic curve. We've asked R to find a linear equation
#(one where the coefficients aren't squared or doing anything weird) to predict
#the response variable of BodyWeight using TotalLength - but the difference here
#is that we've specified 'poly', so we want the explantory variable used more than once.
#We've also specified '2', so we want it used twice which would give us the equation for
#a quadratic curve,
#And like before, we obtain the predicted values but this time using the predict.lm function:
#So, now we've created out quadratic curve linear model function
#We've going to create a new vector to store the predicted values (the curved line)
#so we can then plot that on a graph

Predic2PlotQua <- predict.lm(QuaFit, data.frame(TotalLength = Lengths))
#So, we're telling the program to fill our new vector with the values predicted by the lm
#function QuaFit, using our data.frame we mad earlier called Lengths

#Now let's plot the two fitted models together:

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight) #Plot a basic scattergraph of our vairables
lines(Lengths, Predic2PlotPow, col = "blue", lwd = 2.5)
lines(Lengths, Predic2PlotQua, col = "red", lwd = 2.5)

#We can now see our basic scatter plot with a NLLS regression and quadratic curve regression plotted
#We have two different equations (models) trying to predict our data
#Very similar fits, except that the quadratic model seems to deviate a bit from the data at the lower 
#end of the data range. Let's do a proper, formal model comparison now to check which model better fits
#the data.

#First calculate the R-squared values of the two fitted models:

#FOR OUR NON-LINEAR LEAST SQUARES MODEL
RSS_Pow <- sum(residuals(PowFit)^2) #Residual sum of squares of our NLLS model
TSS_Pow <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2) #Total sum of squares 
#Sum of the squared difference between the observed dependent variable (BodyWeight) and the mean
#BodyWeight. TSS tells us how much variation there is in the dependent variable.
RSq_Pow <- 1 - (RSS_Pow/TSS_Pow) #R-squared value: 1 minus residual sum of squares divided by
#the total sum of squares. For a large r-value (good model) we want the RSS/TSS to be as small as
#possible. 1 gives us a starting point of 100% accuracy, the value of RSS/TSS gives us a value of
#inaccuracy. It is, the left over values (errors) divided by the variation in the model. 
#If we have low errors compared the variability fo the data then we get a low number. Minus
# 1 gives us a high R-value!
#R-squared value tells us the percentage in variance of the dependent variable (BodyWeight) that is 
#explained by the model. The higher the R-value, the better the model.

#FOR OUR QUADRATIC CURVE MODEL
RSS_Qua <- sum(residuals(QuaFit)^2)
TSS_Qua <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2)
RSq_Qua <- 1 - (RSS_Qua/TSS_Qua)

RSq_Pow #0.9005
RSq_Qua #0.9003

#Not very useful. In general R-squared is a good measure of model fit, but cannot be used
#for model selection -- especially not here, given the tiny difference.

#Instead, as explained in the lecture, we can use the Akaike Informaton Criterion (AIC)
#Let's remind ourselves what this is.
#AIC stands for Akaike information criterion. It is an estimator of the relative quality 
#of statistical models for a given set of data. Given a collection of models for the data, 
#AIC estimates the quality of each model, relative to each of the other models. 
#The lower AIC the better.

n <- nrow(Data2Fit) #set sample size (the rows of our dataset - 60)
pPow <- length(coef(PowFit)) #get the number of parameters in the power law model
#just a reminder, our power law model is non-linear because we use one
#of the parameters as an exponent on our predictor vairable (total length)
pQua <- length(coef(QuaFit)) #get the number of parameters in quadratic model

AIC_Pow <- n + 2 + n * log((2 * pi) / n) + n * log(RSS_Pow) + 2 * pPow
AIC_Qua <- n + 2 + n * log((2 * pi) / n) + n * log(RSS_Qua) + 2 * pQua
AIC_Pow - AIC_Qua # -2.147

#We can actually d the above test using an in-built function in R

AIC(PowFit) - AIC(QuaFit) # -2.147

#So which model wins? As we had discussed in the NLLS lecture, a rule of thumb is that
#a AIC value difference of more than 2 is an acceptable cutoff for calling a winner. So the 
#power law (allometric model) is a better fit here.

#EXERCISES

#(A) Calculate the Baysian Information Criterion, also known as the Schwartz Criterion

BIC(PowFit) - BIC(QuaFit) # -4.242

#The power law (allometric model) is still the winner!

#(B) Fit a straight line to the same data and compare with the allometric and quadratic models

SL_Reg <- lm(BodyWeight ~ TotalLength, data = Data2Fit)

SL_Plot <- ggplot(Data2Fit, aes(x=TotalLength, y=BodyWeight)) +
                  geom_point() +
                  geom_abline(
                    intercept = SL_Reg$coefficients[1],
                    slope = SL_Reg$coefficients[2],
                    colour = "red"
                  )
SL_Plot

AIC(SL_Reg) # - 228.1835
BIC(SL_Reg) # - 221.9004

AIC(SL_Reg) - AIC(PowFit) #26.3559
AIC(SL_Reg) - AIC(QuaFit) #24.2085

BIC(SL_Reg) - BIC(PowFit) #26.3559
BIC(SL_Reg) - BIC(QuaFit) #22.1141

#Comparing the three models using both Akaike Information Criterion
#and Bayesian Information Criterion, the allometric model is still the 
#best fitting model

#(C) Repeat the model comparison (including 1-2 above) using the Damselfly
#(Zygoptera) data subset -- does the allometric model still win?

#We've already created the power law model for the zygoptera subset so we can check it's effectiveness
#straight away!

AIC(PowFit2) # - 325.9769
BIC(PowFit2) # - 321.0641

#Now let's create a quadratic model for the data

QuaFit2 <- lm(BodyWeight ~ poly(TotalLength, 2), data = Data2Fit2)
Predic2PlotQua2 <- predict.lm(QuaFit2, data.frame(TotalLength = Lengths2))

plot(Data2Fit2$TotalLength, Data2Fit2$BodyWeight)
lines(Lengths2, Predic2PlotPow2, col = "blue", lwd = 2.5)
lines(Lengths2, Predic2PlotQua2, col = "red", lwd = 2.5)

AIC(QuaFit2) # - 326.7516
BIC(QuaFit2) # - 320.2013

AIC(PowFit2) - AIC(QuaFit2) #0.7747
BIC(PowFit2) - BIC(PowFit2) #0

#There is no significant difference between the goodnes-of-fit of these two models
#But how will they compare to a simple linear regression model?

SL_Reg2 <- lm(BodyWeight ~ TotalLength, data = Data2Fit2)

SL_Plot2 <- ggplot(Data2Fit2, aes(x=TotalLength, y = BodyWeight)) +
  geom_point() +
  geom_abline (
    intercept = SL_Reg2$coefficients[1],
    slope = SL_Reg2$coefficients[2],
    color = "red"
  )

SL_Plot2

AIC(SL_Reg2) - AIC(PowFit2) #5.36
AIC(SL_Reg2) - AIC(QuaFit2) #6.134
BIC(SL_Reg2) - BIC(PowFit2) #5.36
BIC(SL_Reg2) - BIC(QuaFit2) #4.497

#So, whilst there was no significant difference between the power law and quadratic models,
#both are significantly better at describing the data than the straight line regression

#(D) Repeate exercise e(i) from the above set, but with model comparison (e.g. again using
#a quadratic as an alternative model) to establish that the realtionships are indeed allometric.

#See how well total length explains each other morphological measurement using quadratic models
#then compare these models to the bi-logrithmically adjusted ordinary least squares models we made

#ANTISOPTERA
#Let's compare total length with: HeadLength, ThoraxLength, AdbdomentLength, ForewingLength,
#ForewingArea, HindwingLength, HindwingArea using quadratic models

QuaFit_Head <- lm(HeadLength ~ poly(TotalLength, 2), data = Data2Fit)
summary(QuaFit_Head) #R-squared = 0.648

AIC(QuaFit_Head) - AIC(OLS_Drag_Head) # 35.385 (OLS model fits the data best)

QuaFit_Thorax <- lm(ThoraxLength ~ poly(TotalLength,2), data = Data2Fit)
summary(QuaFit_Thorax) #R-squared = 0.7321

AIC(QuaFit_Thorax) - AIC(OLS_Drag_Thorax) # 150.728 (OLS model fits the data best)

QuaFit_Abdo <- lm(AdbdomenLength ~ poly(TotalLength, 2), data = Data2Fit)
summary(QuaFit_Abdo) #R-squared value = 0.986

AIC(QuaFit_Abdo) - AIC(OLS_Drag_Adbdomen) # 170.7137 (OLS model fits the data best)

QuaFit_ForeL <- lm(ForewingLength ~ poly(TotalLength, 2), data = Data2Fit)
summary(QuaFit_ForeL) #R-squared = 0.819

AIC(QuaFit_ForeL) - AIC(OLS_Drag_ForeL) # 279.557

QuaFit_ForeA <- lm(ForewingArea ~ poly(TotalLength,2), data = Data2Fit)
summary(QuaFit_ForeA) # 0.806

AIC(QuaFit_ForeA) - AIC(OLS_Drag_ForeA) # 586.0138

QuaFit_HindL <- lm(HindwingLength ~ poly(TotalLength,2), data = Data2Fit)
summary(QuaFit_HindL) # 0.83

AIC(QuaFit_HindL) - AIC(OLS_Drag_HindL) # 275.854

QuaFit_HindA <- lm(HindwingArea ~ poly(TotalLength,2), data = Data2Fit)
summary(QuaFit_HindA) # 0.741

AIC(QuaFit_HindA) - AIC(OLS_Drag_HindA) # 620.2744

##########SHOULD THESE RESULTS BE THIS BIG##########

#ZYGOPTERA
#Let's compare total length with: HeadLength, ThoraxLength, AdbdomentLength, ForewingLength,
#ForewingArea, HindwingLength, HindwingArea using quadratic models

QuaFit2_Head <- lm(HeadLength ~ poly(TotalLength, 2), data = Data2Fit2)
summary(QuaFit2_Head) #R-squared = 0.806

AIC(QuaFit2_Head) - AIC(OLS_Damsel_Head) # -10.655 (Quadratic model fits the data best)

QuaFit2_Thorax <- lm(ThoraxLength ~ poly(TotalLength,2), data = Data2Fit2)
summary(QuaFit2_Thorax) #R-squared = 0.934

AIC(QuaFit2_Thorax) - AIC(OLS_Damsel_Thorax) # 15.449 (OLS model fits the data best)

QuaFit2_Abdo <- lm(AdbdomenLength ~ poly(TotalLength, 2), data = Data2Fit2)
summary(QuaFit2_Abdo) #R-squared value = 0.995

AIC(QuaFit2_Abdo) - AIC(OLS_Damsel_Adbdomen) # 29.593 (OLS model fits the data best)

QuaFit2_ForeL <- lm(ForewingLength ~ poly(TotalLength, 2), data = Data2Fit2)
summary(QuaFit2_ForeL) #R-squared = 0.909

AIC(QuaFit2_ForeL) - AIC(OLS_Damsel_ForeL) # 141.309

QuaFit2_ForeA <- lm(ForewingArea ~ poly(TotalLength,2), data = Data2Fit2)
summary(QuaFit2_ForeA) # 0.754

AIC(QuaFit2_ForeA) - AIC(OLS_Damsel_ForeA) # 316.693

QuaFit2_HindL <- lm(HindwingLength ~ poly(TotalLength,2), data = Data2Fit2)
summary(QuaFit2_HindL) # 0.916

AIC(QuaFit2_HindL) - AIC(OLS_Damsel_HindL) # 135.846

QuaFit2_HindA <- lm(HindwingArea ~ poly(TotalLength,2), data = Data2Fit2)
summary(QuaFit2_HindA) # 0.723

AIC(QuaFit2_HindA) - AIC(OLS_Damsel_HindA) # 318.0726

#The OLS (allometric scaling) model best explains the zygoptera morphological measurements

#(E) Repeate exercise e(ii) from the above set, but with model comparison to establish which linear
#measurement is the best predictor of bodyweight.

#ANISOPTERA
AIC(OLS_Drag_Head) - AIC(OLS_Drag_Thorax) # 41.0223 (OLS_Drag_Thorax better predictor of body weight)
AIC(OLS_Drag_Thorax) - AIC(OLS_Drag_Adbdomen) # 6.196 (OLS_Drag_Adbdomen better predictor of body weight)
AIC(OLS_Drag_Adbdomen) - AIC(OLS_Drag_ForeL) # -12.768 (OLS_Drag_Adbdomen better predictor of body weight)
AIC(OLS_Drag_Adbdomen) - AIC(OLS_Drag_ForeA) # -14.844 (OLS_Drag_Adbdomen better predictor of body weight)
AIC(OLS_Drag_Adbdomen) - AIC(OLS_Drag_HindL) # -10.940 (OLS_Drag_Adbdomen better predictor of body weight)
AIC(OLS_Drag_Adbdomen) - AIC(OLS_Drag_HindA) # -25.206 (OLS_Drag_Adbdomen better predictor of body weight)

OLS_Drag_Total <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit)
AIC(OLS_Drag_Adbdomen) - AIC(OLS_Drag_Total) # 18.654

#The linear measurement of total length is the best predictor of bodyweight

#ZYGOPTERA

AIC(OLS_Damsel_Head) - AIC(OLS_Damsel_Thorax) # 21.836 (OLS_Damsel_Thorax better predictor of body weight)
AIC(OLS_Damsel_Thorax) - AIC(OLS_Damsel_Adbdomen) # - 40.490 (OLS_Damsel_Thorax better predictor of body weight)
AIC(OLS_Damsel_Thorax) - AIC(OLS_Damsel_ForeL) # - 22.747 (OLS_Damsel_Thorax better predictor of body weight)
AIC(OLS_Damsel_Thorax) - AIC(OLS_Damsel_ForeA) # - 45.777 (OLS_Damsel_Thorax better predictor of body weight)
AIC(OLS_Damsel_Thorax) - AIC(OLS_Damsel_HindL) # - 24.273 (OLS_Damsel_Thorax better predictor of body weight)
AIC(OLS_Damsel_Thorax) - AIC(OLS_Damsel_HindA) # - 47.380 (OLS_Damsel_Thorax better predictor of body weight)

OLS_Damsel_Total <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit2)
AIC(OLS_Damsel_Thorax) - AIC(OLS_Damsel_Total) # - 29.161 (OLS_Damsel_Thorax better predictor of body weight)

#The linear measurement of thorax length is the best predictor of bodyweight

#ALBATROSS CHICK GROWTH

#Now let's look at a different trait example: the growth of an individual albatross chick
#(you can find similar data for vector and non-vector arthropods in VecTraits). First load and plot the data:

alb <- read.csv(file="../Data/albatross_grow.csv")
alb <- subset(x=alb, !is.na(alb$wt))
plot(alb$age, alb$wt, xlab="age (days)", ylab = "weight (g)", xlim=c(0,100))

#FITTING THREE MODELS USING NLLS

#Let's fit multiple models to this dataset.

#The Von Bertalanffy model is commonly used for modelling the growth of an individual.
#We will compare this model against the classical logistic growth equation,
#and a straight line. First, as we did before, let's define the R functions for the two models.

logistic1<-function(t, r, K, N0){
  N0*K*exp(r*t)/(K+N0*(exp(r*t)-1))
}

vonbert.w<-function(t, Winf, c, K) {
  Winf*(1-exp(-K*t) + c*exp(-K*t))^3
}

#For the straight line we will simply use R's lm() function,
#as that is a linear least squares problem. /using NLLS will give 
#(approximately) the same answer, of course. Now fit all 3 models using least squares.

#We will scale the data before fitting to improve the stability of the estimates.

scale<-4000

alb.lin<-lm(wt/scale~age, data=alb) #create linear regression model of weight
#by scaled age. Feature scaling is a method used to normalise the range of independent
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

#These starting values are our guess values for the parameters we're looking for.
#It's a starting point for the models
alb.log<-nlsLM(wt/scale~logistic1(age, r, K, N0), start=list(K=1, r=0.1, N0=0.1), data=alb)
alb.vb<-nlsLM(wt/scale~vonbert.w(age, Winf, c, K), start=list(Winf=0.75, c=0.01, K=0.01), data=alb)

#Next let's calculate predictions for each of the models across a range of ages

ages<-seq(0,100,length=1000) #create a vector with 1000 values ranging from 1 to 100

pred.lin<-predict(alb.lin, newdata = list(age=ages))*scale
pred.log<-predict(alb.log, newdata = list(age=ages))*scale
pred.vb<-predict(alb.vb, newdata = list(age=ages))*scale

#So here, for each model, we have created a vector of values that can be plotted 
#as regression lines against our real data
#For each model we have asked them to runt he model (predict) with some new data,
#in this case using the vector 'ages' that we made to fill the parameter of age in each model
#multiplying that prediction by 4000 to scale our low numerical ages
#with high numberical weight (grams)

#And finally plot the data with the fits:

plot(alb$age, alb$wt, xlab="age (days)", ylab="weight (grams)", xlim=c(0,100))
lines(ages, pred.lin, col=2, lwd=2)
lines(ages, pred.log, col=3, lwd=2)
lines(ages, pred.vb, col=4, lwd=2)

legend("topleft", legend = c("linear", "logistic", "VonBert"), lwd=2, lty=1, col=2:4)

#Next examine the residuals between the 3 models:

par(mfrow=c(3,1), bty="n")
plot(alb$age, resid(alb.lin), main="LM resids", xlim=c(0,100))
plot(alb$age, resid(alb.log), main="Logistic resids", xlim=c(0,100))
plot(alb$age, resid(alb.vb), main="Von Bert resids", xlim=c(0,100))

#The residuals for all 3 models still exhibit some patterns. In particular,
#the data seems to go down near the end of the observation period, but none of these models
#can capture that behaviour.
#Finally, let's compare the 3 models using a simpler approach than the AIC/BIC one that we
#used above by calculating the adjusted Sums of Squared Errors (SSEs):

n<-length(alb$wt) #Create a vector with the number of wt observations
list(lin=signif(sum(resid(alb.lin)^2)/(n-2*2), 3),
     log=signif(sum(resid(alb.log)^2)/(n-2*2), 3),
     vb=signif(sum(resid(alb.vb)^2)/(n-2*2), 3))

#The logistic model has the lowest adjusted SSE, so it's the best by this measure.
#It is also, visually, a better fit.

#EXERCISES
#(A) Use AIC/BIC to perform model selection on the Albatross data as we did for the
#trait allometry example
AIC(alb.lin) - AIC(alb.log) # 50.013 (Logistic model is the best fit)
AIC(alb.log) - AIC(alb.vb) # -10.668 (Logistic model is the best fit)

#(B) Write this example as a self-sufficient R script, with ggplot instead of base plotting.

alb <- read.csv(file="../Data/albatross_grow.csv")
alb <- subset(x=alb, !is.na(alb$wt))

ggplot(alb, aes(x=age, y=wt)) +
  geom_point() +
  xlab("age (years)") +
  ylab("weight (g)")

logistic1<-function(t, r, K, N0){
  N0*K*exp(r*t)/(K+N0*(exp(r*t)-1))
}

vonbert.w<-function(t, Winf, c, K) {
  Winf*(1-exp(-K*t) + c*exp(-K*t))^3
}

scale<-4000

alb.lin<-lm(wt/scale~age, data=alb) 

alb.log<-nlsLM(wt/scale~logistic1(age, r, K, N0), start=list(K=1, r=0.1, N0=0.1), data=alb)
alb.vb<-nlsLM(wt/scale~vonbert.w(age, Winf, c, K), start=list(Winf=0.75, c=0.01, K=0.01), data=alb)

ages<-seq(0,100,length=1000)

pred.lin<-predict(alb.lin, newdata = list(age=ages))*scale
pred.log<-predict(alb.log, newdata = list(age=ages))*scale
pred.vb<-predict(alb.vb, newdata = list(age=ages))*scale

pred.lin <- as.data.frame(cbind(ages, pred.lin))
pred.log <- as.data.frame(cbind(ages, pred.log))
pred.vb <- as.data.frame(cbind(ages, pred.vb))


ggplot(alb, aes(x=age, y=wt)) +
  geom_point() +
  #geom_smooth(method="lm") +
  xlab("age (years)") +
  ylab("weight (grams)") +
  xlim(0,100) +
  theme_bw() +
  ggtitle("My Plot") +
  geom_line(data = pred.log, aes(x = ages, y = pred.log), color = "green") +
  geom_line(data = pred.lin, aes(x = ages, y = pred.lin), colour = "red") +
  geom_line(data = pred.vb, aes(x = ages, y = pred.vb), colour = "blue")


par(mfrow=c(1,1))
plot(alb$age, alb$wt, xlab="age (days)", ylab="weight (grams)", xlim=c(0,100))
lines(ages, pred.lin, col=2, lwd=2)
lines(ages, pred.log, col=3, lwd=2)
lines(ages, pred.vb, col=4, lwd=2)

legend("topleft", legend = c("linear", "logistic", "VonBert"), lwd=2, lty=1, col=2:4)

par(mfrow=c(3,1), bty="n")
plot(alb$age, resid(alb.lin), main="LM resids", xlim=c(0,100))
plot(alb$age, resid(alb.log), main="Logistic resids", xlim=c(0,100))
plot(alb$age, resid(alb.vb), main="Von Bert resids", xlim=c(0,100))

n<-length(alb$wt)
list(lin=signif(sum(resid(alb.lin)^2)/(n-2*2), 3),
     log=signif(sum(resid(alb.log)^2)/(n-2*2), 3),
     vb=signif(sum(resid(alb.vb)^2)/(n-2*2), 3))
