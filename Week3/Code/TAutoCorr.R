# Amy Solman amy.solman19@imperial.ac.uk
# 18th October 2019
# TAutoCorr.R
# Autocorrelation in weather: Are temperatures of one year significantly correlated
#with the next year (successive years), across years in a given location?

# Null hypothesis: There is no significant correlation between the temperatures of 
# one year with the next year in a given location (Key West)
# Alternative hypothesis: There is a significant correlation between the temperatures of
# one year with the next year in a given location (Key West)

load("../Data/KeyWestAnnualMeanTemperature.Rdata") #load script

head(ats) 

# There are no missing values in the data set so 'na.rm' and 'use' aren't needed

plot(ats$Year, ats$Temp) # scatter plot of year (x-axis) and temp(y-axis)
# Visual assessment shows weak positive correlation between temperature and year

# Get the correlation coefficientthen store it
# Use autocorrelation/lagged correlations
# First create two vecotrs each with length n-1 such that
# the rows correspond to (x[t], x[t-1]) pairs or us
x_t0 <- ats$Temp[-1]
x_t1 <- ats$Temp[-100]
head(cbind(x_t0, x_t1)) # Confirm that these vectors are the right pairs
plot(x_t0, x_t1) # plot the vectors
correlation <- cor(x_t0, x_t1) # Compute the correlation coefficient 
# and store it
correlation

# Repeat the calculation 10000 times, randomly permuting the time series, and then recalculating
# correlation coefficient for each randomly permuted year sequence and storing it (use sample function)
# Read the help file for this function and experiment with it

#This function takes the two variables of successive years (x_t0, x_t1) 
# as a sample of 99 random temperatures from the list and correlates them
correlation_multi <- function(x_t0, x_t1){ 
  x_t0 <- sample(ats$Temp, 99, replace = FALSE)
  x_t1 <- sample(ats$Temp, 99, replace = FALSE)
  return(cor(x_t0, x_t1))
}

# Now I want to repeat this function 10000 times

correlation_loop <- function(x_t0, x_t1){
  result <- vector(,1000) #Preallocate expected size
  for(i in 1:1000){
    result[i] <- correlation_multi()
  }
  return(result)
}

loop_result <- correlation_loop(x_t0, x_t1)

# Calculate what fraction of the correlation coefficients were greater than that from the first step.

z <- loop_result > correlation # shows how many times the random sample was greater than our 
# original test
x <- length(z[z==TRUE])
y <- length(z[z==FALSE])
p_value = x/y
p_value 






