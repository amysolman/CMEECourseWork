# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  y <- c() #initialising empty vector
  y2 <-c()
  
  sim = 50 #simualtion size
  duration = 600 #number of generations
  speciation_rate <- 0.1 #speciation rate
  community_max <- init_community_max(100) #create initial community with maximum diversity
  community_min <- init_community_min(100) #create initial community with minimum diversity

  
 for(i in 1:sim){ #loop through simulations
    richness <- neutral_time_series_speciation(community_max, speciation_rate, duration)
    richness2 <- neutral_time_series_speciation(community_min, speciation_rate, duration)
    y <- sum_vect(y, richness) #add vectors of richness
    y2 <- sum_vect(y2, richness2) 
    }
  
  #averages from the simulations
  yav <- round(y/sim)
  y2av <- round(y2/sim)
  
  #we want to plot how many unique species are present at each generation against generation
  #so, how many unique species are present at each time step
  
  x1 <- 1:(duration + 1)
  y1 <- apply(yav, 1, function(x)length(unique(x)))
  plot(y1~x1, pch=20, col = "blue", type = "l", xlab = "Number of Generations",
       ylab = "Species diversity",
       main = "Neutral Time Series Speciation, Average of 50 Simulations", ylim = c(0, 40))

  x2 <- 1:(duration + 1)
  y2 <- apply(y2av, 1, function(x)length(unique(x)))
  lines(y2~x2, pch=20, col = "red")
  #lines(upper_max_to_plot, col = "pink")
  legend('topright', pch = c(2,2, 19), c('Initial maximum diversity', 'Initial minimum diversity', 'Estimated dynamic equilibrium'), col = c("blue", "red", "black"))


  #find confidence intervals and merge into data frame with y1
  
  #CONFIDENCE INTERVALS
  
  error_max <- qt(0.975,df=length(y1)-1)*sd(y1)/sqrt(length(y1))
  upper_max <- y1 + error_max
  lower_max <- y1 - error_max
  
  error_min <- qt(0.975,df=length(y2)-1)*sd(y2)/sqrt(length(y2))
  upper_min <- y2 + error_min
  lower_min <- y2 - error_min
 

  #make polygon where coordinates start with lower limit and 
  #then upper limit in reverse order
  polygon(c(x1,rev(x1)),c(lower_max,rev(upper_max)),col = "grey75", border = FALSE)
  polygon(c(x2,rev(x2)),c(lower_min,rev(upper_min)),col = "grey75", border = FALSE)
  
  #Estimate and plot number of generations needed to reach dynamic equilibrium
  points(x1[350],y1[350], col = "black", pch=19)

  
  
}