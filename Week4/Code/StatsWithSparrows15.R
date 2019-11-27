# Amy Solman amy.solman19@imperial.ac.uk
# 25th October 2019
# Lecture 15

##########LECTURE FIFTEEN##########

rm(list=ls())


daphnia <- read.delim("../Data/daphnia.txt")
summary(daphnia)
head(daphnia)

#We check for potential outliers in x and y. From the summary data, 
#we can see that the categories have sufficient sample size - this is a homogeneous dataset

#Create a two panel graph (boxplot) plotting growth rate against detergent
#then growth rate against daphnia
par(mfrow = c(1, 2))
plot(Growth.rate~Detergent, data = daphnia)
plot(Growth.rate~Daphnia, data = daphnia)

#Outliers in boxplots come up as circles. So, there are none.
#Growth rates in defferent detergents appear to have a similar means
#within about one point of each other
#Clone 2 and 3 have similar growth rates, Clone 1 has a lower mean growth rate

#Homogeneitry of variances

#This is an important assumption for ANOVAS and regression analysis
#To run the model explaining growth rate with Detergent brand and genotype,
# we have to assume that the variances within each brand, and within each genotype are similar.
#Looking at the plot they are sort of similar.
#Rule of thumb for ANOVA is that the ratio between the largest and smallest variance should not be
#much more than four

require(dplyr)

daphnia %>%
  group_by(Detergent) %>%
  summarise (variance=var(Growth.rate))

daphnia %>%
  group_by(Daphnia) %>%
  summarise (variance=var(Growth.rate))

#Ratio of variances for Clone 1 with the other two is about 5 (5 times smaller).
#But ecological data is messy - plough ahead but keep this in mind
#When interpreting model and drawing conclusions

#Are the data normally distributed?

hist(daphnia$Growth.rate)

#Not very normally distrubuted
#Linear regression assumes normality but is reasonably robust against violations
#However, it assumes that the observations for each x (detergent, genotype)
#are normal.
#Not too many zeros in data

#Is there any collinearity among the covariates? The condition in which some of the independent
#variables are highly correlated. We only have catagories here so it doesn't apply.
# Data set is homogenous because the variables are of one type.

#Model daphnia
#Create barplots showing the means and standard errors of the mean for both clonal 
#genotype and detergent presence.

seFun <- function(x) {
  sqrt(var(x)/length(x))
}
detergentMean <- with(daphnia, tapply(Growth.rate, INDEX = Detergent,
        FUN = mean))
detergentSEM <- with(daphnia, tapply(Growth.rate, INDEX = Detergent,
        FUN = seFun))
cloneMean <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = mean))
cloneSEM <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = seFun))

par(mfrow = c(2,1), mar=c(4,4,1,1))
barMids <- barplot(detergentMean, xlab = "Detergent type", ylab = "Population growth rate",
                   ylim = c(0, 5))
arrows(barMids, detergentMean - detergentSEM, barMids, 
       detergentMean + detergentSEM, code = 3, angle = 90)
barMids <- barplot(cloneMean, xlab = "Daphnia clone", ylab = "Population growth rate",
        ylim = c(0, 5))
arrows(barMids, cloneMean - cloneSEM, barMids, cloneMean + cloneSEM,
       code = 3, angle = 90)

# Do they have any explanatory power?
#The differences in the means for the detergents don't look like they matter but
#we should test whether they have any explanatory power. We can do this by adding both variables
#into the formula describing the model. So far we have only seen this in simple situations
#where there is one variable describing another (y~x). We can use the + sign
#to add extra variables into the right hand side of the formula: y~x+z, means model y
#using both the x and z variables. So now we can fit the model and look at
#the analysis of variance table.

daphniaMod <- lm(Growth.rate~Detergent + Daphnia, data = daphnia)
anova(daphniaMod)

#We now have the ANOVA table with line for each variable. In each case we follow
#exactly the same procedure of  using an F-test on the mean squares - does this variable
#explain a significant amount of variation in the data? In each case, we compare the mean
#square variation fro the line('Mean Sq') to the residual mean square variation.

#From this we conclude that genotype is important in determining the population growth rate
#measured in the Daphnia but that the detergents do not have any effect. We can now
#use the same techniques as before to see the differences in the means between each detergent
#and genotype.

summary(daphniaMod)

detergentMean - detergentMean[1]

cloneMean - cloneMean[1]

daphniaANOVAMod <- aov(Growth.rate~Detergent + Daphnia, data = daphnia)
summary(daphnia)

?aov

daphniaModHSD <- TukeyHSD(daphniaANOVAMod)
daphniaModHSD

par(mfrow=c(2,1), mar=c(4,4,1,1))
plot(daphniaModHSD)

par(mfrow=c(2,2))
plot(daphniaMod)

timber <- read.delim("../Data/timber.txt")
summary(timber)

par(mfrow = c(2,2))
boxplot(timber$volume)
boxplot(timber$girth)
boxplot(timber$height)

var(timber$volume)
var(timber$girth)
var(timber$height)

t2 <- as.data.frame(subset(timber, timber$volume!="NA"))
t2$z.girth <- scale(timber$girth)
t2$z.height <- scale(timber$height)
var(t2$z.girth)
var(t2$z.height)
plot(t2)

par(mfrow=c(2,2))
hist(t2$volume)
hist(t2$girth)
hist(t2$height)

pairs(timber)

cor(timber)

summary(lm(girth~height, data = timber))

VIF <- 1/(1-0.27)
VIF

sqrt(VIF)

pairs(timber)

cor(timber)

pairs(t2)

cor(t2)

timberMod <- lm(volume~girth + height, data = timber)
anova(timberMod)
summary(timberMod)
plot(timberMod)

#Extra exercises in the handout