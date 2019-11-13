# Amy Solman amy.solman19@imperial.ac.uk
# 24th October 2019
# Lecture 5
#Hypothesis Testing

#p-value - the probability of observing this particular result
#and more extreme results when the null hypothesis is true(this is no effect)


rm(list=ls())

setwd("/Users/amysolman/Documents/SparrowStats/HandOutsandData'18")
d <- read.table("SparrowSize.txt", header = TRUE)

boxplot(d$Mass~d$Sex.1, col=c("red", "blue"), ylab="Body mass (g)")

# Males seem slightly heavier than females
#We have to find out our null hypothesis
#Difference between males and females is equal zero
#If difference is positive, males have larger bodies
#If difference is negative, males have lower body mass

t.test1 <- t.test(d$Mass~d$Sex.1)
t.test1

#R tells us the alternative hypothesis
#t-value is large, given the degrees of freedom
#means with high probability males are heavier than females

d1 <- as.data.frame(head(d, 50))
length(d1$Mass)

t.test2 <- t.test(d1$Mass~d1$Sex)
t.test2

#Test if wing length in 2001 differs from the grand total mean
d2 <- subset(d, d$Year==2001)

t.test4 <-t.test(d2$Wing)
t.test4

#test if male and female wing length differ in 2001
d2 <- subset(d, d$Year==2001)
t.test5 <- t.test(d2$Wing~d2$Sex.1)
t.test5

#test if male and female wing length differ in full data set
t.test6 <- t.test(d$Wing~d$Sex.1)
t.test6

install.packages("pwr")

require(pwr)

#sampe size needed to find 5mm difference 
pwr.t.test(d=(0-5)/2.41,power=0.8,sig.level=0.05,type="two.sample",alternative="two.sided")
