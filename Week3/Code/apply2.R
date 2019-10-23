# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# apply2.R

SomeOperation <- function(v){ # assigns function that will take v as an argument
  if (sum(v) > 0){ # if the total value of the v vector is greater than 0
    return(v*100) # give me the vector times 100
  }
  return(v) # give me the new vector
}

M <- matrix(rnorm(100), 10, 10) # matrix of 100 normally distributed random numbers
print(apply(M, 1, SomeOperation)) # print the row values of the matrix 
# with the function acting on it