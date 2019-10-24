# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# sample.R

########## Functions ##########

## A function to take a sample of size n from a population "popn" and return its mean
myexperiment <- function(popn,n){ # assign function that will take the popn and sample size
  pop_sample <- sample(popn, n, replace = FALSE) # take a sample of size from popn
  # do not replace
  return(mean(pop_sample)) # give me the mean of the population sample
}

## Calculate means using a for loop without preallocation:
# Re-run the mean test 1000 times
loopy_sample1 <- function(popn, n, num){ # assign function that will take popn, sample size, 
  # number of times to rerun experiment
        result1 <- vector() # Initialize empty vector of size 1
        for (i in 1:num){ # for each element from 1 to the re-run number
                result1 <- c(result1, myexperiment(popn, n)) # run myexperiment on popn
                # concatenate with result1 empty vector
    }
        return(result1)   
} 

## To run "num" iterations of the experiment using a for loop on a vector with preallocation:
loopy_sample2 <- function(popn, n, num){
  result2 <- vector(,num) #Preallocate expected size
  for(i in 1:num){
    result2[i] <- myexperiment(popn, n)
  }
  return(result2)
}

## To run "num" iterations of the experiment using a for loop on a list with preallocation:
loopy_sample3 <- function(popn, n, num){
        result3 <- vector("list", num) # Preallocate expected size
        for(i in 1:num){
                result3[[i]] <- myexperiment(popn, n)
   }
        return(result3)
}

## To run "num" iterations of the experiment using vectorization with lappy
# When you want to apply a function to each element
# of a list in turn and get a list back
lapply_sample <- function(popn, n, num){
       result4 <- lapply(1:num, function(i) myexperiment(popn, n))
       return(result4)
}

## To run"num" iterations of the experiment using vectorization with sappy
# When you want to apply a function to each element of a list in turn,
# but you want a vector back, rather than a list
sapply_sample <- function(popn, n, num){ #function taking pop, sample size, re-run times
  result5 <- sapply(1:num, function(i) myexperiment(popn, n)) 
  return(result5)
}

# sapply is the same as lapply just simplify2array instead of list

popn <-rnorm(1000) # Generate a population of 1000 normally distributed random numbers
hist(popn)

n <- 20 # sampe size for each experiment
num <- 1000 # Number of time to rerun experiment

print("The loopy, non-preallocation approach takes:")
print(system.time(loopy_sample1(popn, n, num)))

print("The loopy, but with preallocation approach takes:")
print(system.time(loopy_sample2(popn, n, num)))

print("The loopy with preallocated lists approach takes:")
print(system.time(loopy_sample3(popn, n, num)))

print("The vectorized lapply approach takes:")
print(system.time(lapply_sample(popn, n, num)))

print("The vectorized sapply approach takes:")
print(system.time(sapply_sample(popn, n, num)))