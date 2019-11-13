# Amy Solman amy.solman19@imperial.ac.uk
# 24th October 2019
# Lecture 9

##########LECTURE NINE##########

#Run a linear regression in R

x <- c(1, 2, 3, 4, 8) # create vector of data values
y <- c(4, 3, 5, 7, 9) # create vector of data values

model1 <- (lm(y~x)) # assign a linear model of x/y to vector model1
#explain y with x
model1 #print model1

# Coefficients:
# (Intercept)     x  
# 2.6164       0.8288   - where line of best fit would cross the axis - I think?

summary(model1) #summary stats of the model

# Residuals:
#   1       2       3       4       5 
# 0.5548 -1.2740 -0.1027  1.0685 -0.2466  - distance from the line of each data point
# errors of each point
# 
# Coefficients:
#                                           Estimate Std. Error   t value Pr(>|t|)  
# (Intercept)                                  2.6164     0.8214   3.185   0.0499 *
#   x (for increase of 1 x, y increases by...) 0.8288     0.1894   4.375   0.0221 *
#   
# performs t-test on intercept, is it different from zero. is 2.6 different from zero given
# an error on 0.8
#
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.024 on 3 degrees of freedom
# Multiple R-squared:  0.8645,	Adjusted R-squared:  0.8193 
# F-statistic: 19.14 on 1 and 3 DF,  p-value: 0.0221

anova(model1) #analysis of variance

# Analysis of Variance Table

# Response: y
# Df  Sum Sq Mean Sq F value Pr(>F)  
# 1 20.0562 20.0562  19.139 0.0221 *
#   Residuals  3  3.1438  1.0479                 
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 1.024 on 3 degrees of freedom
# Multiple R-squared:  0.8645,	Adjusted R-squared:  0.8193 
# F-statistic: 19.14 on 1 and 3 DF,  p-value: 0.0221

resid(model1) #extracts model residuals from objects returned by modeling functions

# 1          2          3          4          5 
# 0.5547945 -1.2739726 -0.1027397  1.0684932 -0.2465753 

cov(x, y) #covariance, measure of the koint variability
#of two random variables

# 6.05

var(x) #variance of x

# 7.3

plot(y~x) #plot the values
