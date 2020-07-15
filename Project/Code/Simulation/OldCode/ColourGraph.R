rm(list=ls())
graphics.off()

#Creating colour graph

#fix area, niches
#vary theta and m rate
#and compare species richness results for analytics and NLLS

#define the model function
chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}


#given a specific migration rate, area and number of niches, 
#as we vary theta what estimations of species richness do we get analytically?

analytic_results <- function() {
  
  area = 1000 
  K = 20
  m = 0.001
  species_results <- vector()
  
  for (i in 1:100) {
    
    
    for (t in 1:1000) { #for values of theta from 1 to 1000
      
      rich <- chisholm_model(area = area, theta = t, m0 = m*sqrt(area), K = K) #store the 
      #analytic result
      species_results <- c(species_results, rich)
      
    }
    
    m = m + 0.001
    
  }
  

  
  return(species_results)
  
}

species_results <- analytic_results()

#bind our results into a dataframe
theta_values <- rep(seq(1, 1000), 100)
m_values <- rep((1:100)*0.001, each = 1000)
results <- cbind(species_results, theta_values, m_values, area = 1000, K = 20)

#get only those results that gave species richness of between 25 and 26
cut_results <- subset(results, species_results>=25 & species_results<26)
cut_results <- as.data.frame(cut_results)


#now do NLLS fitting using our analytic
fit_chisholm <- nlsLM(species_results ~ chisholm_model(area, theta, m0, K), data = results, 
                      start = list(theta = 200, m0 = 1.7, K=20))


