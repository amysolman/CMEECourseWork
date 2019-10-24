# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# Vectorize1.R

# Creates a matrix (collection of elements of same data type -
# here numeric - arranged in fixed number of rows/columns.
# A 2D vector). Made of 1000000 random deviates, with 1000 rows and 1000 columns.
M <- matrix(runif(1000000),1000,1000) 

SumAllElements <- function(M){ # Create a function that will take the matrix
  # M as an argument
  Dimensions <- dim(M) # Dimensions of matrix applied to Dimensions variable
  Tot <- 0 # Numerical value 0 applied to 'Tot'-al
  for (i in 1:Dimensions[1]){ # For each element from 1 to the first element in dimensions (1000)
    for (j in 1:Dimensions[2]){ # For each element from 1 to the second element in dimensions (1000)
      Tot <- Tot + M[i,j] # Tot is assigned the value of Tot plus one element from first dimention 
      # and one element from second dimension of matrix
    }
  }
   return (Tot)             
}

print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))