# Amy Solman amy.solman19@imperial.ac.uk
# 28th October 2019
# Lecture 18: Linear mixed models

##########LECTURE EIGHTEEN##########

rm(list=ls())

setwd("/Users/amysolman/Documents/SparrowStats/HandOutsandData'18")

a <- read.table("ObserverRepeatability.txt", header=T)

#We want to find out how much the measurement of tarsus and bill
#width depends on different observers. We will use the ANOVA method to do that.
#Calculate the between-observer repeatability pf tarsus of the porn-star female!

require(dplyr)

#List how many counts are provided by each student
a %>%
  group_by(StudentID) %>%
  summarise (count=length(StudentID))

#List how many students provided counts
a %>%
  group_by(StudentID) %>%
  summarise(count=length(StudentID)) %>%
    summarise(length(StudentID))

#List how many counts were provided in total
a %>%
  group_by(StudentID) %>%
  summarise(count=length(StudentID)) %>%
    summarise(sum(count))

#List how many counts were provided in total - a quicker way!
length(a$StudentID)

#Sum the square values of each count (sum of squares)
a %>%
  group_by(StudentID) %>%
  summarise(count=length(StudentID)) %>%
  summarise(sum(count^2))

#Calculate denominator of equation for repeatability
1/79*(151-333/151)

#Run ANOVA to check the mean squares
mod <- lm(Tarsus~StudentID, data=a)
anova(mod)

#Test whether handedness, and which leg was measured made a difference
mod <- lm(Tarsus~Leg+Handedness+StudentID,data=a)
anova(mod)

#Linear mixed-effects models using 'Eigen' and S4
require(lme4)

#In this model, specify leg and handedness as fixed factors
#(1|Student) code for modelling StudenID as random effect on the intercept
lmm <- lmer(Tarsus~Leg+Handedness+(1|StudentID),data=a)
summary(lmm)

var(a$Tarsus)

3.03+1.71

summary(lmm)
