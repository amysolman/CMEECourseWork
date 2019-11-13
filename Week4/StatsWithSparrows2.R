# Amy Solman amy.solman19@imperial.ac.uk
# 23rd October 2019

rm = (list=ls())

setwd("/Users/amysolman/Documents/SparrowStats") # re-set working directory

str(d)
head(d)
length(d$Tarsus)

#Centrality, mean, median and mode in normally distributed data

mean(d$Tarsus) #NA because of missing values in our dataset
mean(d$Tarsus, na.rm = TRUE)
median(d$Tarsus, na.rm = TRUE)
mode(d$Tarsus) #returns numeric - mode function returns description of the type of object
#mode is difficult to estimate the mode in a continuous dataset because it is possible very
#few of the values will be exactly the same, most values occur only once

par(mfrow = c(2,2)) #par used to set or query graphical parameters, creates simple multipanel plot
hist(d$Tarsus, breaks=3, col="grey")
hist(d$Tarsus, breaks=10, col="grey")
hist(d$Tarsus, breaks=30, col="grey")
hist(d$Tarsus, breaks=100, col="grey")

#breaks in the data show the resolution (breaks) is greater than the resolution of the 
#measuring device

install.packages("modeest") #install doesn't work
require(modeest)

mlv(d$Tarsus) #should be in modeest package, this wouldn't work anyway
#because we have to recode the dataset to deal with NA values

d2 <- subset(d, d$Tarsus!='NA')
length(d$Tarsus)
length(d2$Tarsus)

mlv(d2$Tarsus) #this would give us a mode

#or we can use this function...

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

result <- getmode(d2$Tarsus)
print(result)

#in normally distributed data the mean, mode and median should be similar (18.5, 18.6, 19)

#Range, variance and standard deviation

range(d$Tarsus, na.rm = TRUE)
range(d2$Tarsus, na.rm = TRUE)
var(d$Tarsus, na.rm = TRUE)
var(d2$Tarsus, na.rm = TRUE)

sum((d2$Tarsus - mean(d2$Tarsus))^2)/(length(d2$Tarsus) - 1) #variance
#square root variance for standard deviation
sqrt(var(d2$Tarsus))

sqrt(0.74)

sd(d2$Tarsus)

#Z scores and quantiles

zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)
var(zTarsus)

sd(zTarsus)
hist(zTarsus)

set.seed(123)
znormal <- rnorm(1e+06)
hist(znormal, breaks = 100)

summary(znormal)

qnorm(c(0.025, 0.975))
pnorm(.Last.value)

par(mfrow = c(1, 2)) #make a multi panel graph with 1 row and two columns
hist(znormal, breaks = 100) # make a histogram of znormal with 100 breaks
abline(v=qnorm(c(0.25, 0.5, 0.75)), lwd = 2) # put a line on histo showing median and
# 50% quantiles
abline(v=qnorm(c(0.025, 0.975)), lwd = 2, lty = "dashed") # draw a line on histogram
# showing 2.5% and 97.5% quartiles
plot(density(znormal)) # plot density graph of znormal
abline(v = qnorm(c(0.25, 0.5, 0.75)), col = "gray") # put a line on histo showing median and
# 50% quantiles
abline(v = qnorm(c(0.025, 0.975)), lty = "dotted", col = "black") # draw a line on histogram
# showing 2.5% and 97.5% quartiles
abline(h = 0, lwd = 3, col = "blue") 
text(2, 0.3, "1.96", col = "red", adj = 0)
text(-2, 0.3, "-1.96", col = "red", adj = 1)

class(d$Sex)
class(d$Sex.1)

boxplot(d$Tarsus~d$Sex.1, col = c("red", "blue"), ylab = "Tarsus length (mm)")
