# Amy Solman amy.solman19@imperial.ac.uk
# 22nd October 2019
# Lecture 1 and 2

##########LECTURE ONE##########

rm = (list=ls())

getwd() # check which working directory we're in
setwd("/Users/amysolman/Documents/SparrowStats") # re-set working directory
getwd() # check what we did worked

2*2+1

2*(2+1)

12/2^3

(12/2)^3

x <- 5
x

y <- 2
y

x2 <- x^2
x2

x

a <- x2 + x
a

y2 <- y^2
z2 <- x2 + y2
z <- sqrt(z2)
print(z)

3>2

3 >= 3

4<2

myNumericVector <- c(1.3, 2.5, 1.9, 3.4, 5.6, 1.4, 3.1, 2.9)
myCharacterVector <- c("low", "low", "low", "low", "high", "high", "high", "high")
myLogicalVector <- c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE)

str(myNumericVector)
str(myCharacterVector)
str(myLogicalVector)

myMixedVector <- c(1, TRUE, FALSE, 3, "help", 1.2, TRUE, "notwhatIplanned")
str(myMixedVector)

install.packages("lme4")
library(lme4) 
require(lme4)

help(getwd)
help(log)

sqrt(4); 4^0.5; log(0); log(1); log(10); log(Inf)

exp(1)

pi

##########LECTURE TWO##########

setwd("/Users/amysolman/Documents/SparrowStats")

d <- read.table("/Users/amysolman/Documents/SparrowStats/HandOutsandData'18/SparrowSize.txt", header=TRUE)
str(d)
head(d)

averages <- c(1, 2, 3, 3, 3, 4, 5, 5, 5, 20)

mean(averages)
median(averages)
mode(averages)

# function for mode
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

result <- getmode(averages)
print(result)

print(d)



# Print mean of bill/mass/wing
mean(d$Bill, na.rm = TRUE)
mean(d$Mass, na.rm = TRUE)
mean(d$Wing, na.rm = TRUE)

# Print variation of bill/mass/wing
var(d$Bill, na.rm = TRUE)
var(d$Mass, na.rm = TRUE)
var(d$Wing, na.rm = TRUE)

# Print standard deviation of bill/mass/wing
sd(d$Bill, na.rm = TRUE)
sd(d$Mass, na.rm = TRUE)
sd(d$Wing, na.rm = TRUE)

hist(d$Tarsus)
hist(d$Bill, breaks=60)
hist(d$Mass, breaks=60)
hist(d$Wing, breaks=60) 

install.packages("modeest")






