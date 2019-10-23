# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# try.R: 

rm=(list=ls())

# Function that runs a simulation that involved sampling from a synthetic
# population with replacement and takes its mean, but only if at least 30
# unique samples are obtained.
# Replacement: when a sample is take from the population it is replaced 
# before the function is rerun. So the probability of getting any data point
# within the population remains the same.
doit <- function(x){ # assign the function 'doit' to take argument 'x'
        temp_x <- sample(x, replace = TRUE)  
        # sample takes a sample of the specified size x from the popn
        if(length(unique(temp_x)) > 30) { #only take mean if sample was sufficient
              print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        }
        else {
              stop("Couldn't calculate mean: too few unique values!") 
        }
}

popn <- rnorm(50) # generate your population of 50 from a normal distribution

# Run the function using lapply, repeating sampling 15 times
# lapply(1:15, function(x) doit(popn))
# The script will fail because of the stop command

# Do the same as lapply with 'try'. Ask for the mean of 15 samples
result <- lapply(1:15, function(x) try(doit(popn), FALSE))
# FALSE modifying for the 'try' command suppressed any error message
# Result will still contain them so we can inspect them below...

class(result) # List, stores each of the 15 runs including errors

result # tells you which runs ran into error and why

# Tou can store the results manually by using a for loop 
# to do the same
result <- vector("list", 15) # Preallocate/Initialize
for (i in 1:15){
    result[[i]] <- try(doit(popn), FALSE)
}