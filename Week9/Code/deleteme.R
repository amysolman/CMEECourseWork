# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  y <- c() #initialising empty vector
  y2 <-c()
  upper <- c()
  lower <- c()
  upper2 <- c()
  lower2 <- c()
  sim = 10 #simualtion size
  duration = 200 #number of generations
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
  yav <- y/sim
  y2av <- y2/sim
  error <- qnorm(.028, lower.tail=FALSE) #calculate error
  upper <- (yav + error)
  #  upper <- apply(upper, 1, function(x)length(unique(x)))
  lower <- (yav - error)
  #lower <- apply(lower, 1, function(x)length(unique(x)))
  upper2 <- (y2av + error)
  #upper2 <- apply(upper2, 1, function(x)length(unique(x)))
  lower2 <- (y2av - error)
  #lower2 <- apply(lower2, 1, function(x)length(unique(x)))
  
  #we want to plot how many unique species are present at each generation against generation
  #so, how many unique species are present at each time step

  # x <- 1:(duration + 1)
  # y <- apply(yav, 1, function(x)length(unique(x)))
  # plot(y~x, pch=20, col = "blue", type = "l", xlab = "Number of Generations",
  #      ylab = "Species diversity",
  #      main = "Neutral Time Series Speciation, Average of 10 Simulations", ylim = c(0, 100))
  #
  # x <- 1:(duration + 1)
  # y <- apply(y2av, 1, function(x)length(unique(x)))
  # lines(y~x, pch=20, col = "red")
  # legend('topright', pch = c(2,2), c('Initial maximum diversity', 'Initial minimum diversity'), col = c("blue", "red"))
  
  xpol <- c(seq(0, duration), seq(duration, 0))
  ypol <- c(c(upper), rev(c(lower)))
  ypol2 <- c(c(upper2), rev(c(lower2)))
  par(mfrow=c(2,1))
  plot(yav, col='black', ylim=c(5,70), xlab="Generations", ylab="Species Richness")
  title(main="Maximum initial community richness", line=0.5, cex.main=0.5)
  polygon(xpol, ypol, col=adjustcolor("tomato", alpha.f=0.5), border = "black")
  lines(yav, col = 'black', lwd=0.5)
  abline(v=80, col="red", lwd = 2)
  
  
  
  plot(duration, col="black", ylim = c(15, 35), pch = 8, type = 'l')
  plot(1, type="l", xlab="", ylab="", xlim=c(0, 200), ylim=c(0, 100), cex=0.2) #open graph
  
  
  
  polygon(xpol, ypol, col = 'grey75', border = FALSE)
  
  polygon(xpol, ypol2,col ="grey75", border = FALSE)
  lines(upper, col="green",lty=2)
  lines(lower, col="green",lty= 2)
  lines(upper2, col="red",lty=2)
  lines(lower2, col="red", lty = 2)
  
}