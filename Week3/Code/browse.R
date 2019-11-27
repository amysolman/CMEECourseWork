# Amy Solman amy.solman19@imperial.ac.uk
# 18th October 2019
# browse.R
#Inserts a breakpoint within the script, to then step through
#the code

Exponential <- function(N0 = 1, r = 1, generations = 10){
  # Runs a simulation of exponential growth
  # Returns a vector of length generations
  
  N <- rep(NA, generations) # Creates a vector of NA
  
  N[1] <- N0
  for (t in 2:generations){
    N[t] <- N[t-1] * exp(r)
    browser()
    # Script will run until the first iteration of the for loop
    # and the console will enter the browser mode
  }
  return(N)
}

plot(Exponential(), type="l", main="Exponential growth")