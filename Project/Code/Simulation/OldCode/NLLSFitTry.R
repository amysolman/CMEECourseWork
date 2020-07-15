rm(list=ls())
graphics.off()

#install nlls fitting package
#install.packages("minpack.lm") <- if you've never installed minpack before
library("minpack.lm") #for nlls fitting
library("ggplot2")

#############################################
##########IMPORT SIMULATION RESULTS##########
#############################################

ImportMe <- function() {
  SimData <- read.csv("../../Data/SimData/SimModelFitData2.csv") #import data
  return(SimData)
}

data <- ImportMe()


#############################################
##########DEFINE THE MODEL FUNCTION##########
#############################################

chisholm_model <- function(area, theta, m0, K) {
  rho = 1
  K = K
  Js = area*rho
  J_stars = Js/K
  ms = m0/sqrt(area)
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

###########################################################
##########GET THETA VALUES FOR SIMULATION ISLANDS##########
###########################################################

#for each island in my simulation, I caluclated the value of theta as 
# 2 x size of niche in the metacommunity (2500) x number of niches on the island * speciation rate 
#because size of each niche in the metacommunity x number of niches on the island = the total size of the metacommunity from which
#the island recieves immigrants 

store_my_theta <- list()

for (i in 1:nrow(data)) {
  nu = 0.001
  K = data[i, ]$K_num
  J_meta = 50000
  meta_niche_size = J_meta/20
  theta = 2*(meta_niche_size*K)*nu
  store_my_theta[[i]] <- theta
   
}

data$theta <- unlist(store_my_theta)

##############################################################
##########GET SPECIES ESTIMATES FROM THE MODEL################
##############################################################

#I can check that the model is giving the right values - and that I've accurately
#calculated theta - by giving it the parameters of each simulated island 
#E.g. migration rate (0.012), number of niches (20), theta (100), area (40), 
#and seeing if it's estimation is similar to my simulation results (22 species) 

store_my_species <-list()

for (i in 1:nrow(data)) {
  x <- data[i, ]
  m0 = x$migration_rates*sqrt(x$area)
  species <- chisholm_model(area = x$area, theta = as.numeric(x$theta), m0 = m0, K = x$K_num)
  store_my_species[[i]] <- round(species)
  
}

data$modelspecies <- unlist(store_my_species)

#REARRANGE THE COLUMNS
data <- data[c(1,2,3,4,5,7,6,8)]

#How similar are the model estimations to my results?
t.test <- t.test(data$island_species, data$modelspecies, paired = TRUE, alternative = "two.sided")

#paired t test shows that the model is getting different results from the simulation
#but only a mean difference of -1.5 species, so the model is estimating, on average 1.5 more species
#per island - this is a relatively small difference so I conclude the model is giving 
#approximately the right values

#most of the differences are at higher areas
#if I subset the data to include only islands with smaller areas
small_data <- data[data$area < 14, ]
t.test2 <- t.test(small_data$island_species, small_data$modelspecies, paired = TRUE, alternative = "two.sided")

#if the data is subset to islands less than 14 units in area, the difference between
#the simulation and the model is 0

########################################################################################
##########SUBSET DATA BY MIGRATION RATE AND K NUM FOR NLLS FITTING######################
########################################################################################

#to see if we can recover the known island parameters (migration rate, number of niches, theta)
#I subset the 800000 simulated islands into groups that share migration rate, number of niches 
#and theta, this gives me 400 datasets

migration_values <- unique(data$migration_rates)
K_values <- unique(data$K_num)

#function to divide islands by migration rate

migration_rate_function <- function(data) {
  
  m_cut_data <- list()
  
  for (m in 1:length(migration_values)) {
    m_cut_data[[m]] <- data[data$migration_rates == migration_values[[m]], ]
  }
  
  return(m_cut_data)
}

m_cut_data <- migration_rate_function(data = data)

#function to divide islands by niches

niche_function <- function(data) {
  
  n_cut_data <- list()
  
  for (n in 1:length(K_values)) {
    n_cut_data[[n]] <- data[data$K_num == K_values[[n]], ]
  }
  
  return(n_cut_data)
}

#divide up all the data 20 x 20 = 400 

cut_data <- list()

for (i in 1:length(m_cut_data)) {
  data <- m_cut_data[[i]]
  cut_data[[i]] <- niche_function(data = data)
}

#merge my lists into one list of 400 datasets
my_lists <- list()
for (i in 1:length(cut_data)) {
  my_lists <- append(my_lists, cut_data[[i]])
}

#######################################################################################
######FOR EACH DATASET WE'LL FIND THE MEAN SPECIES RICHNESS FOR EACH ISLAND AREA#######
#######################################################################################

my_mean_lists <- list()

for (i in 1:length(my_lists)) {
  x <- my_lists[[i]] #for each dataset 
  
  areas <- unique(x$area) #these are the unique areas in the dataset
  species <-vector() #create empty vector for storing mean species for this dataset
  
  for (a in 1:length(areas)) { #for each unqiue area find the mean species
    y <- x[x$area == areas[[a]], ] 
    species <- c(species, mean(y$island_species))
  }
  
  df <- data.frame(x$migration_rates[[1]], areas, species, x$K_num[[1]], x$theta[[1]])
  names(df) <- c("MigrationRate", "area", "island_species", "Niches", "Theta")
  
  my_mean_lists[[i]] <- df
}

#############################################################################
##########GET STARTING ESTIMATES FOR MIGRATION RATE AND THETA################
#############################################################################

get_my_starts <- function(nlls_data) {
  
  nu = 0.001
  m_start = nu*median(nlls_data$area)/10
  m0_start = m_start*sqrt(median(nlls_data$area))
  theta_start = signif(median(nlls_data$area), 1)
  
  starts <- data.frame(nu, m_start, m0_start, theta_start)
  
  return(starts)
}

##########################################################################################
##RUN NLLS FITTING ON EACH OF THE 400 DATA SETS TO GET THETA, M RATE AND NICHE ESTIMATES##
##########################################################################################

#function to perform NLLS fitting on each dataset and store best fit coefficients

NLLSfits <- function() {
  
  data <- my_mean_lists
  
  #empty lists for storing our results
  
  RSq_store <- list()
  theta_store <- list()
  m0_store <- list()
  K_store <- list()
  all_results <- list()
  
  for (i in 1:length(data)) { #for each dataset
    
    nlls_data <- data[[i]]
  
  starts <- get_my_starts(nlls_data)
    
    this_result = 0
    
    for (k in 1:ceiling(max(nlls_data$island_species))) { #for num of niches from 1 to max number of species
      
      #fit the model
      try(fit_chisholm <- nlsLM(island_species ~ chisholm_model(area, theta, m0, K), data = nlls_data, 
                            start = list(theta = starts$theta_start, m0 = starts$m0_start, K=k)), silent=T)
      
      #Get the R-squared value of the fitting
      
      RSS <- sum(residuals(fit_chisholm)^2) #Residual sum of squares of our NLLS model
      TSS <- sum((nlls_data$island_species - mean(nlls_data$island_species))^2) #Total sum of squares 
      RSq <- 1 - (RSS/TSS) #R-squared value
      
      #if this RSq value is higher than the last one, we store the results
      
      if (RSq >= this_result) {
        
        RSq_store[[i]] <- round(RSq, digits = 3)
        theta_store[[i]] <- round(coef(fit_chisholm)["theta"], digits = 3)
        m0_store[[i]] <- round(coef(fit_chisholm)["m0"], digits = 4)
        K_store[[i]] <- round(coef(fit_chisholm)["K"])
        this_result <- RSq
        
      }
      
    }
    
    
  }
  
  RSq_store <- unlist(RSq_store)
  theta_store <- unlist(theta_store)
  m0_store <- unlist(m0_store)
  K_store <- unlist(K_store)
  
  all_results <- data.frame(RSq_store, theta_store, m0_store, K_store)
  
  return(all_results)
  
}

##########################################################################################
####LET'S BIND OUR SIMULATION PARAMETERS AND NLLS PARAMETER ESTIMATES INTO A DATAFRAME#######
##########################################################################################

#Simulation Results
my_data <- list()

for (i in 1:length(my_lists)) {
  x <- my_lists[[i]]
  theta <- x[1,]$theta
  m_rate <- x[1, ]$migration_rates
  k_num <- x[1, ]$K_num
  median_area <- round(median(x[1, ]$area))
  m0 <- round(as.numeric(m_rate/sqrt(median_area)), digits = 4)
  my_data[[i]] <- data.frame(i, median_area, theta, m_rate, m0, k_num)
}

#Bind with NLLS results
my_data <- do.call("rbind", my_data)
total_data <- cbind(my_data, all_results)
total_data$ms_nlls <- round(total_data$m0_store*sqrt(total_data$median_area), digits =4)
total_data <- total_data[c(1,4,11,5,9,3,8,6,10,7)]
names(total_data) <- c("FitNumber", "M_Rate", "M_NLLS", "M0", "M0_NLLS", "Theta", "Theta_NLLS", "Niches", "Niche_NLLS", "RSquared")

#################################################
############PLOT PARAMETER DIFFERENCES###########
#################################################

#Migration rates

p1 <- ggplot(total_data, aes(x = M_Rate, y = M_NLLS)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  xlim(0, 3) +
  ylim(0, 3)

#M0 rates
p2 <- ggplot(total_data, aes(x = m0, y = M0_NLLS)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  xlim(0, 0.6) +
  ylim(0, 0.6)

#Theta

p3 <- ggplot(total_data, aes(x = Theta, y = Theta_NLLS)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  xlim(-100, 100000) +
  ylim(-100, 100000)

#Niches

p4 <- ggplot(total_data, aes(x = Niches, y = Niche_NLLS)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1)

#These results show that values for migration rate, m0 and theta are extremely overestimated through nlls fitting
#whilst niche number estimates are similar, but slightly less than actual results


##########################################################################################
####LET'S SEE IF THE PARAMETER ESTIMATES CAN PRODUCE THE SAME NUM OF SP AS THE SIM#######
##########################################################################################

#get a set of areas from one of the model fittings
area <- my_lists[[10]]$area
simulated_species <- my_lists[[10]]$island_species  
parameters <- total_data[10, ] 

#Get estimated species with the NLLS paramaters
species <- chisholm_model(area = area, theta = parameters$Theta_NLLS, m0 = parameters$M0_NLLS, K = parameters$Niche_NLLS)

#get estimated species with the known parameters
other_species <- chisholm_model(area = area, theta = parameters$Theta, m0 = parameters$M0, K = parameters$Niches)

#bind simulation species with nlls parameter estimates and known parameter estimates
estimated_modelled <- cbind(simulated_species, round(species), round(other_species))

#difference between sim results and nlls parameters
t.test3 <- t.test(estimated_modelled[, 1], estimated_modelled[, 2], paired = TRUE, alternative = "two.sided")
#-0.15

#difference between sin results and estimates with true parameters
t.test4 <- t.test(estimated_modelled[, 1], estimated_modelled[, 3], paired = TRUE, alternative = "two.sided")
# 0.65

