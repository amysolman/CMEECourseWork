# Amy Solman amy.solman19@imperial.ac.uk
# 18th October 2019
# Vectorize2.R
# Runs the stochastic (with gaussian fluctuations) Ricker Eqn
# followed by a vectorized version of the same equation

rm(list=ls()) # remove all objects from the current workspace

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) # assigns function that 
  # takes the arguments: 'p0' starting population of 1000 randomly generated numbers of a uniform distribution
  # 'r' as intrinsic growth rate, 'K' as carrying capacity of environment, 'sigma' as standard deviation,
  # and 'numyears' as the number of times the model will be run
{
  #initialize
  N<-matrix(NA,numyears,length(p0)) # initialize matrix (N) of 100 by 1000 empty element
  # so the model should give us a matrix of population numbers by years
  N[1,]<-p0 # apply the starting population to the matrix first row, all columns
  
  for (pop in 1:length(p0)) #loop through the populations
    # for each element (population number) from 1 to the length of the starting population (1000) 
  {
    for (yr in 2:numyears) #for each pop, loop through the years
      # for each year from year two to the total number of years
    {
      N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma)) # run the stochastic 
      # (with gauccian fluctuations) Ricker Eqn and applies the results to the 'N' matrix of
      # year by population
    }
  }
 return(N) 

}

print("Stochastic Ricker takes:")
print(system.time(res2<-stochrick()))


rm(list=ls()) # remove all objects from the current workspace

stochrickvect<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) # assigns function that 
  # takes the arguments: 'p0' starting population of 1000 randomly generated numbers of a uniform distribution
  # 'r' as intrinsic growth rate, 'K' as carrying capacity of environment, 'sigma' as standard deviation,
  # and 'numyears' as the number of times the model will be run
{
  #initialize
  N<-matrix(NA,numyears,length(p0)) # initialize matrix (N) of 100 by 1000 empty element
  # so the model should give us a matrix of population numbers by years
  N[1,]<-p0 # apply the starting population to the matrix first row, all columns
  
  for (yr in 2:numyears) #for each pop, loop through the years
    # for each year from year two to the total number of years
  {
    N[yr,]<-N[yr-1,]*exp(r*(1-N[yr-1,]/K)+rnorm(1,0,sigma)) # run the stochastic 
    # (with gauccian fluctuations) Ricker Eqn and applies the results to the 'N' matrix of
    # year by population
    # takes previous years population and updates it - this is density dependent so it's logistic growth
    # does operation on whole vector in one go  
    }
  return(N) 
  
}


print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))


