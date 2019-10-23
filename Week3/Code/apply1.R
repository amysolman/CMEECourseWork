# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# apply1.R

## Build a matrix of 100 normally distributed, random numbers, 10 rows by 10 columns
M <- matrix(rnorm(100), 10, 10) 

## Take the mean of each row
RowMeans <-apply(M, 1, mean)
print(RowMeans)

## Now the variance
RowVars <- apply(M, 1, var)
print(RowVars)

## By column
ColMeans <- apply(M, 2, mean)
print(ColMeans)