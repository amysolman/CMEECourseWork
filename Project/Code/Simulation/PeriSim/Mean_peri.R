#Script to get island means across all 100 simulations
rm(list=ls())
graphics.off()

##############################################################
#######################FUNCTION ONE###########################
##############################################################
#FUNCTION TO READ IN SIMULATIONS#
#read in 100 simulations
ImportMyData <- function(num_sim) {
  my_sims <- list()
  for (i in 1:100) {
    try(load(paste0(file="../../../Data/SimData/Perimeter/simulation_peri_", num_sim, "_", i, ".rda")))
    my_sims[[i]] <- store_my_islands
  } 
  
  return(my_sims)
}

##############################################################
#######################FUNCTION TWO###########################
##############################################################
#function to get island areas
get_my_areas <- function(data, K_true) {
  
  area <- vector() #create empty list for storing island areas
  for (i in 1:length(data[[1]])) { #from 1 to the number of islands
    area[[i]] <- K_true*(length(data[[1]][[i]][[1]][[1]]$Niche)) #area is the number of niches 
    #* size of niche
  }
  return(area)
}

##############################################################
#######################FUNCTION THREE###########################
##############################################################
#put the data for each island into a table
table_my_data <- function(data, K_true, m0_true, theta_true){
  area <- get_my_areas(data, K_true)
  
  df <- data.frame(m0_true, K_true, theta_true, area)
  for (s in 1:length(data)){
    simulation <- data[[s]]
    
    sp_rich <- vector()
    for (i in 1:length(simulation)){
      island <- simulation[[i]]
      sp_rich[[i]] <- tail(island[[2]], n=1)
    }
    df$sim <- sp_rich
    names(df)[names(df) == "sim"] <- paste0("sim_", s)
  }
  return(df)
}

##############################################################
#######################FUNCTION FOUR###########################
##############################################################
#standard error function

std <- function(x) sd(x)/sqrt(length(x))

##############################################################
#######################FUNCTION FIVE###########################
##############################################################
#get mean and standard error
mean_and_st_error <- function(df){
  
  #get data without theta, K, m0 and area
  my_data <- df[-c(1:5)]
  species <- rowMeans(my_data)
  
  st_error <- vector()
  for (r in 1:nrow(my_data)){
    island <- my_data[r, ]
    st_error[[r]] <- std(island)
  }
  
  mean_and_error <- data.frame(species, st_error)
  
  return(mean_and_error)
}

##############################################################
##################RUN THE FUNCTIONS###########################
##############################################################
#run the functions
#Import the data
for (j in 1:10){
  
  numbers <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
  data <- ImportMyData(num_sim = numbers[j])
  
  #get the migration rate and number of niches for the archipelagos
  nu_values = seq(0.00001, 0.0001, 0.00001)
  m0_true <- data[[1]][[1]][[1]][[1]]$m0
  K_true <- length(data[[1]][[1]][[1]])
  nu = nu_values[j]
  J_meta = K_true*10000
  theta_true = nu*(J_meta-1)/(1-nu)
  
  df <- table_my_data(data, K_true, m0_true, theta_true)
  mean_and_error <- mean_and_st_error(df)
  final_df <- cbind.data.frame(df, mean_and_error)
  
  
  write.csv(final_df, paste0("../../../Data/SimulationMeansPeri", j, ".csv"), row.names=FALSE)
  
}

