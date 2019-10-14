## run a simulation that involves sampling from a population

x <- rnorm(50) # Generate your population. Generates 50 sudo random numbers and applies to the vector x
doit <- function(x){ # Names a function (doit) which will work with an argument(x)
  x <- sample(x, replace = TRUE)
  if(length(unique(x)) > 30) { # only take mean if sample was sufficient
    print(paste("Mean of this sample was:", as.character(mean(x))))
  }
}

## Run 100 iterations using vectorization:
result <- lapply(1:100, function(i) doit(x))

## Or using a for loop:
result <- vector ("list", 100) #Preallocate/Initialize
for(i in 1:100){
  result[[1]] <- doit(x)
}
