# Amy Solman amy.solman19@imperial.ac.uk
# 18th October 2019
# Ricker.R
# Run the Ricker model, a classic discrete population model
#introduced in 1954 by Ricker to model recruitment of stock in fisheries.

rm(list=ls()) 

Ricker <- function(N0=1, r=1, K=10, generations=50) # the function will take four arguments:
  #number of individuals (density), intrinsic growth rate, carrying capacity of environment and
  # generations (number of times model is run and results plotted). 
{
  # Runs a simulation of the Ricker model
  # Returns a vector of length generations
  
  N <- rep(NA, generations) # Creates a vector of NA 
  # replicate the empty vector (number of individuals) 50 times. This preallocates the vector so 
  # R doesn't have to reallocate memory with each iteration
  # of the model - makes it faster! 
  
  N[1] <- N0 # Apply the number of individuals to 1 element of the population
  # vector
  for (t in 2:generations) # for each time from second to given
    # number of generation
  {
    N[t] <- N[t-1] * exp(r*(1.0-(N[t-1]/K))) # do the Ricker equation!
  }
  return (N) # Give the population size for the specified number of generations
}

plot(Ricker(generations=10), type="l") # plot this function with 10 
# generations, type - line graph