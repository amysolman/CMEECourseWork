#Amy Solman amy.solman19@imperial.ac.uk
#29th October 2019
#Investigation of the Chihuahuan Desert Ecosystem

#We want to ask, does hing leg length differ between species?
# Does hind leg length differ within species?
# Does hind leg length differ between sexes?
# Does hind leg length differ within sexes?

rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week5/StatisticsR")

{#modifying the data for analysis
a <- read.csv("rodents.csv", header=T, stringsAsFactors =F)
head(a)
str(a)

a$sex <- ifelse(a$sex!="M", ifelse(a$sex!="F", "No_Data", "F"), "M")

a$tag <- ifelse(a$tag=="", "No_Tag", a$tag)

a$yr <- as.factor(a$yr)
a$mo <- as.factor(a$mo)
a$sex <- as.factor(a$sex)
a$tag <- as.factor(a$tag)
a$species <- as.factor(a$species)

colnames(a)[6] <- "hindfootlength.mm"
colnames(a)[7] <- "weight.g"
colnames(a)[8] <- "precip.mm"
}

str(a)

## Data Description

hist(a$hindfootlength.mm)
summary(a$hindfootlength.mm)

boxplot(a$hindfootlength.mm~a$species)
boxplot(a$hindfootlength.mm~a$sex)
boxplot(a$hindfootlength.mm~a$yr)

boxplot(a$weight.g~a$species)
boxplot(a$weight.g~a$sex)
boxplot(a$weight.g~a$yr)
boxplot(a$weight.g~a$precip.mm)
boxplot(a$weight.g~a$hindfootlength.mm)
boxplot(a$weight.g~a$mo)

require(lme4) 
require(ggplot2)

#Does precipitation affect weight

#testing normality
hist(a$precip.mm)
hist(a$weight.g)

#not normally distributed so lets try log
hist(log(a$precip.mm))
hist(log(a$weight.g))

install.packages("car")
library(car)

#use qqplot to test if data is normally distributed
#if it is it meet parametric requirements for linear model
qqPlot(log(a$weight.g))
qqPlot(log(a$precip.mm), ylim = c(0, 5))

# We can't use parametric tests
hist(a$hindfootlength.mm)
hist(a$weight.g)
qqPlot(a$hindfootlength.mm)

#The data is not normally distrubuted so we will use non-parametric tests
#using number to number (weight/precip) so use spearmans rank

#correlation test
cor.test(a$weight.g, a$precip.mm, method="spearman")
#no significant relationship 
plot(log(a$weight.g)~log(a$precip.mm), main="Correlation between rodent weight and precipitation", 
     ylab="log Rodent Weight", xlab = "log Precipitation")
plot(a$weight.g~a$precip.mm)

#non-parametric t-test is mann-whitney

#non-parametric version of ANOVA test
kruskal.test(a$weight.g~interaction(a$species, a$sex))
#very significant p-value 
#variation in weight is significantly influenced by species and sex

#post hoc for kruskal-wallis

install.packages("PMCMRplus")
library(PMCMRplus)

aa<-a[which(a$sex!="No_Data"),]
aa$sex<-as.factor(as.character(aa$sex))
boxplot(aa$weight.g~aa$sex, main ="Boxplot of rodent weight against gender", ylab="Weight (g)", xlab = "Gender")
