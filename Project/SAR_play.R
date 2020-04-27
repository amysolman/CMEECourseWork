#playing around with species-area curves in R
rm(list=ls())
graphics.off()

#let's generate our data
#we've sampled the following plots
plots <- array(dim=c(5,20))
#these are 20 different species we have found
species <- c(letters[1:20])
#we need to give each species a probability of occuring
#where all species probabilities add up to 1!
probs <- numeric(20) #vector of 20 '0s'
probs[1:8] <- runif(8, 0, 0.1) #for the first 8 elements in
#the vector, give them random numbers between 0 and 0.1
for(i in 9:20){
  probs[i] <- runif(1, 0, 1-sum(probs[1:i-1]))
}
#this states that for the remaining 9 to 20 elements
#each should be randomly assigned a value between 0 and
#1 minus the sum of all the other probabilities
#so the total probability of finding all species never
#goes above 1!
sum(probs) #should equal one, more or less

#Now for each plot in our array we want to sample five individuals
#randomly using the probabilities we just created
for(i in 1:20){
  plots[,i] <- sample(species, size=5, replace=T, prob=probs)
}

#we sample with replacement to account for the possibility
#that species can occur multiple times within a plot
#essentially the probability of an individual in a plot
#belonging to a given species is equal to the relative abundance
#of each species

#So we've simulated our data
#Now we work on generating our random SAR curve
#Let's assume we will randomly sample plots 20 times
#And that we will increase the number of plots sampled 
#i.e. we will sample 1 plot 20 times, then 2 plots 20 times
#For each sampling event we will calculate species richness

#We set up an empty 20 x 20 container
#so we've got 20 sampling events for 20 plot numbers

SAR.mat <- array(dim=c(20,20))

#We use a nested for() loop to simulate the sampling
#plot index = the number of plots to be sampled at each of the 20 sampling events
#this is equivalent to area i.e. 1 plot = 1km, 3 plots = 3km sampling area
#SAR.plot - this gets written over in each iteration of the loop
#it says, for that size area (number of plots = plot.index)
#record all the individuals present
#SAR.mat = number of unique species in each SAR.plot
for(j in 1:20){ 
  for(i in 1:20){
    plot.index <- sample(1:20, j, replace = F) #randomly sample 1-20 without replacing
    SAR.plot <- c(plots[,plot.index]) #
    SAR.mat[i,j] <- length(unique(SAR.plot))
  }
}

SAR.mat[,1] #the number of species recorded each
#time 1 units was sampled (in each of 20 sampling events)
SAR.mat[,2] #the number of species recorded each
#time 2 units was sampled (in each of 20 sampling events)

#So SAT.mat is a 20x20 array containing 20 sampling events (rows)
#for each possible area (columns)
#We're going to set up a vector relation the columns to areas,
#calculate the mean species richness of each column (area),
#calculate the 95% confidence interval and then plot

areas <- 1:20 
means <- apply(SAR.mat, MARGIN=2, mean) #find the mean species richness of each area
lower.95 <- apply(SAR.mat, MARGIN=2, function(x) quantile(x, 0.025)) 
#95% confidence intervals for species richenss in each increasingly sized habitat
upper.95 <- apply(SAR.mat, MARGIN=2, function(x) quantile(x, 0.975))

#plot everything!
par(mar=c(4, 4, 1, 1)+0.2)
plot(areas, means, type='n', xlab=expression('Area '*(m^-2)),
     ylab = 'Species Richness', cex.lab=1.2,
     ylim=c(0,12))
polygon(x=c(areas, rev(areas)),
        y=c(lower.95, rev(upper.95)),
        col='grey90')
lines(areas, means, lwd=2)

#Now we want to fit a model to our data
#Here we fit a standard linear model to the log mean
#species richness of each area and the log of each area
SAR.mod <- lm(log(means) ~ log(areas))
summary(SAR.mod)
#very low p values suggest that mean species richness is 
#significantly explained by area

#we can plot the linear model curve with our data
#y (species richness) = exponential of the intercept coefficient of the model multiplied by x (area) to the power of the area coefficient
curve(exp(coef(SAR.mod)[1])*x^coef(SAR.mod)[2], add=T, from=0, to=20, col='red', lwd=2)

#Now we will try using non-linear least squares to fit 
#a power-law model to the data i.e. y = a*x^b
#we're going to use the intercept and area coefficients gained
#using the linear model, as starting values for our nlls
SAR.nls <- nls(means ~ a*areas^b, start=list('a'=exp(coef(SAR.mod)[1]),
                                             'b'=coef(SAR.mod)[2]))
summary(SAR.nls)
curve(coef(SAR.nls)[1]*x^coef(SAR.nls)[2], add=T, from=0, to=20, col='blue', lwd=2)
legend('topleft', lty=1, col=c('black', 'red', 'blue'),
       legend=c('Median Species Richness', 'Linear Model Fit', 'Nonlinear Model Fit'),
       cex=0.8,
       bty='n')
