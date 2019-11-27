# Amy Solman amy.solman19@imperial.ac.uk
# 24th October 2019
# Lecture 10

##########LECTURE TEN##########

rm(list=ls()) #clear environment

d <- read.table("../Data/SparrowSize.txt", header = TRUE)
str(d) #structure of data

#plot mass/tarsus scatterplot with labels
plot(d$Mass~d$Tarsus, ylab = "Mass (g)", xlab = "Tarsus (mm)", pch = 19, cex = 0.4)

x <- c(1:100) #populate new x vector
b <- 0.5 
m <- 1.5
y <- m*x+b # y is slope times x plus intercept
plot(x, y, xlim = c(0,100), pch = 19, cex = 0.5) #plot x/y - straight line!

d$Mass[1] #the first y value

length(d$Mass) #y sample size

d$Mass[1770] #y value at index 1770

plot(d$Mass~d$Tarsus, ylab = "Mass (g)", xlab = "Tarsus (mm)", pch = 19, cex = 0.4, 
     ylim = c(-5, 38), xlim = c(0,22))
#plot y/x with axis lengths defined

plot(d$Mass~d$Tarsus, ylab = "Mass (g)", xlab = "Tarsus (mm)", pch = 19, cex = 0.4)
#plot y/x with automatic axis lengths

d1 <- subset(d, d$Mass!="NA") # create a subset of the data with NA values for Mass removed
d2 <- subset(d1, d1$Tarsus!="NA") # create a subset of that subset with NA value for
#tarsus removed
length(d2$Tarsus) #what is the sample size of tarsus in the new dataset

model1 <- lm(Mass~Tarsus, data=d2) #model the data of the new data set with NA removed
summary(model1) #summarise

hist(model1$residuals) #create histogram of the residuals

head(model1$residuals) #show top six residuals

model2 <- lm(y~x) #create new linear model from previously defined vectors
summary(model2) #summary data from that model

#run the model with z scores of x variable
d2$z.Tarsus <- scale(d2$Tarsus) 
model3 <- lm(Mass~z.Tarsus, data = d2)
summary(model3)

plot(d2$Mass~d2$z.Tarsus, pch = 19, cex = 0.4) 
abline(v = 0, lty = "dotted") #add straight line to a plot 

head(d)

str(d)

d$Sex <- as.numeric(d$Sex) #transform Sex data to numeric variable
par(mfrow = c(1,2)) #create multi frame plot
plot(d$Wing ~ d$Sex.1, ylab = "Wing (mm)") #plot wing/sex as 2 factor variable
plot(d$Wing ~ d$Sex, xlab = "Sex", xlim = c(-0.1, 1.1), ylab = "") #plot wing/sex as numeric variable
#with defined axis lengths
abline(lm(d$Wing ~ d$Sex), lwd = 2) #add straight line to the plot
text(0.15, 76, "intercept") #add ingraph text
text(0.9, 77.5, "slope", col = "red") #add ingraph text

d4 <- subset(d, d$Wing!="NA") #new data frame with subset excluding NA for wings
m4 <- lm(Wing~Sex, data=d4) #new linear model for wing/sex in new data frame
t4 <- t.test(d4$Wing~d4$Sex, var.equal=TRUE) #t-test on new data frame 
summary(m4)
t4

par(mfrow = c(2, 2)) #create four panel multi graph of model3 (linear regression)
plot(model3)

par(mfrow = c(2, 2)) #create four panel multi graph of m4 (linear regression)
plot(m4)

##########EXERCISES##########

# Run diagnostics for a model with sex as explanatory variable. Interpret the plot.

# Run a linear model, where you test the hypothesis that sparrows with bigger bills can eat more.
# The prediction is that the larger the bill, the heavier the sparrow.

#plot of mass as explained by bill size, with labelled axis
d3 <- subset(d1, d1$Bill!="NA")

plot(d3$Mass~d3$Bill, ylab = "Mass (g)", xlab = "Bill (mm)", pch = 19, cex = 0.4,
     xlim = c(0, 20), ylim = c(0, 40))
#pch is type of character used to show data point, cex is size of that character
#manually set axis lengths

length(d3$Bill)
summary(d3$Mass)
sd(d3$Mass)
summary(d3$Bill)
sd(d3$Bill)

model4 <- lm(Mass~Bill, data=d3)
summary(model4)

d3$z.Bill <- scale(d3$Bill)
model5 <- lm(Mass~z.Bill, data=d3)
summary(model5)

plot(d3$Mass~d3$z.Bill, pch = 19, cex = 0.4)
abline(v = 0, lty = "dotted")

# Detail what your explanatory and what your response variable is.
# Write a short (1A4) report on methods and results. Before you go into the 
# linear model, you should first describe your data, say how many sparrows, how many females and males,
# whether there is a difference in your response between the sexes. If that difference is meaningful,
# you should test the sexes seperately. Write this section as you would write it for a scientific article.

##########REPORT###########

##########METHODS##########
# To test whether sparrows with bigger bills can eat more, and thus have greater mass, I used
# a linear model, where body mass (g) was the response variable, and bill size (mm) the explanatory variable.
# I z-standardized bill size to a mean of zero and SD of one, so that the intercept could be interpreted
# as the mean of body mass. Following the analysis, I used visual inspection of residual plots to assess
# that the assumption that the residuals follow a normal distribution was not violated. I report results as
# statistically significant if p equals or is smaller than 0.05. I used R version 3.3 (R Core Team 2015)
# for all analysis and plotting.

##########RESULTS##########
# I used data from 1111 observations. The sparrows weighed on average 27.65g (SD 2.04, range: 21.25-36.20).
# The bills of the sparrows were on average 13.31mm long(wide?) (SD 0.60, range: 9.70-16.00). I found a positive,
# statistically significant association between mass and bill size (Table 1).