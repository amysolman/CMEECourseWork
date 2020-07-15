#FOR EACH SIMULATION, THIS SCRIPT WILL SEPERATE THE ISLANDS INTO ARCHIPELAGOS
#AND PUT THE ISLAND INFO INTO A DATAFRAME, FIND THE MEANS AND EXPORT AS CSV FILE

rm(list=ls())
graphics.off()

###################################################
#################FUNCTION ONE######################
###################################################
#read in 100 simulations
ImportMyData <- function() {
  my_sims <- list()
  for (i in 21:100) {
    try(load(paste0(file="../../../Data/SimData/14thJuly/simulation_timeseries_", i, ".rda")), silent = T) 
    my_sims[[i]] <- store_my_islands
  } 
  
  return(my_sims)
}

###################################################
#################FUNCTION TWO######################
###################################################
#start by getting a list of immigration rates
#and number of niches from the simulation
get_my_rates <- function(Data){
  my_rates <- list()
  m_rates <- vector()
  k_num <- vector()
  
  for (i in 1:length(Data)) {
    m_rates[i] <- Data[[i]][[1]]$do_migration
    k_num[i] <- length(Data[[i]])
  }
  
  #extract the unique values from the vectors
  m_rates <- unique(m_rates)
  k_num <- unique(k_num)
  my_rates[[1]] <- m_rates
  my_rates[[2]] <- k_num
  return(my_rates)
}

###################################################
#################FUNCTION THREE######################
###################################################
#function to subset the data by one given m rate
subset_by_m_rate <- function(m_rate, Data){
  y = 1
  x <- list()
  for (i in 1:length(Data)) {
    if (Data[[i]][[1]]$do_migration == m_rate) { #if 
      x[[y]] <- Data[[i]]
      y = y + 1
    }
  }
  
  return(x)
}

###################################################
#################FUNCTION FOUR######################
###################################################
#function to subset data by one given number of niches
subset_by_k_num <- function(niches, islands){
  y = 1
  z <- list()
  for (i in 1:length(islands)){
    if (length(islands[[i]]) == niches) {
      z[[y]] <- islands[[i]]
      y = y + 1
    }
  }
  return(z)
}

###################################################
#################FUNCTION FIVE######################
###################################################
#run the niches subset function for each number of niches
#on one m_rate
subset_multi_k_num <- function(my_data, k_num) {
  archipelagos <- list()
  islands <- my_data
  for (k in 1:length(k_num)){
    niches <- k_num[k] 
    archipelagos[[k]] <- subset_by_k_num(niches, islands)
  }
  return(archipelagos)
}


###################################################
#################FUNCTION SIX######################
###################################################
get_my_arch_data <- function(my_archipelago) {
  info_list <- list()
  arch_k <- length(my_archipelago[[1]]) #number of niches in archipelago
  arch_m <- my_archipelago[[1]][[1]]$do_migration #immigration rate of archipelago
  info_list[[1]] <- arch_k
  info_list[[2]] <- arch_m
  return(info_list)
}

###################################################
#################FUNCTION SEVEN######################
###################################################
#get total species on an island
island_sp <- function(island){
  tot = 0
    for (j in 1:length(island)) {
      sp <- unique(island[[j]]$Niche) #number of unique species in each niche
      tot <- sum(tot, sp)
    }
    return(tot)
  }

###################################################
#################FUNCTION EIGHT######################
###################################################
#get total species on each island in archepelago

arch_sp <- function(archipelago){
  
  total_sp <- vector()
  
  for (i in 1:length(archipelago)){ 
    island <- archipelago[[i]] #isolate one island
    total_sp[i] <- island_sp(island) #get the island species 
  }
  
    return(total_sp)
  }

###################################################
#################FUNCTION NINE######################
###################################################
#get the area of each island in the archepelago

get_my_areas <- function(archipelago){
  
  area <- vector()
  arch_info <- get_my_arch_data(archipelago)

  
  for (island in 1:length(archipelago)){
    
    my_island <- archipelago[[island]]
    niches <- arch_info[[1]]
    niche_size <- length(my_island[[1]]$Niche)
    area[[island]] <- niches*niche_size
    
  }
  return(area)
}

###################################################
#################FUNCTION TEN###################
###################################################
final_function <- function(Data) {

  #get the m rates and k nums from the simultion
  my_rates <- get_my_rates(Data = Data)
  m_rates <- my_rates[[1]]
  k_num <- my_rates[[2]]
  
  #subset data by m rate
  t <- list()
  for (j in 1:length(m_rates)) {
    t[[j]] <- subset_by_m_rate(m_rates[j], Data = Data)
  }
  
  #subset data by k num
  archipelagos <- list()
  for (b in 1:length(t)){
    archipelagos[[b]] <- subset_multi_k_num(my_data = t[[b]], k_num = k_num)
  }
  
  #start archepelago counter
  arch_num <- 1
  
  #create empty dataframe
  final_data <- data.frame(arch_num=numeric(0), niches=numeric(0), immigration=numeric(0), 
                           area=numeric(0), species=numeric(0))
  
  for (c in 1:length(archipelagos)) {
    
    for (d in 1:length(archipelagos[[c]])){
      #gives data of one archipelago
      
      arch_1 <- archipelagos[[c]][[d]] #isolated one archipelago
      
      #get the archepelago parameters
      arch_info <- get_my_arch_data(my_archipelago = arch_1)
      #get the archepelago species richness and island areas 
      species <- arch_sp(archipelago = arch_1)
      area <- get_my_areas(archipelago = arch_1)
      
      #bind into dataframe
      new <- data.frame(arch_num, arch_info[[1]], arch_info[[2]], area, species)
      names(new) <- c("arch_num", "niches", "immigration", "area", "species")
      final_data <- rbind(final_data, new)
      
      arch_num = arch_num + 1
    }
    
    }
    

return(final_data)
  
}

###################################################
#################FUNCTION ELEVEN######################
###################################################

####SCRIPT TO IMPORT THE DATA AND SUBSET THE ARCHIPELAGOS####
##################FOR EACH SIMULATION #######################
##########THEN FIND THE MEANS OF EACH ARCHIPELAGO############
#############THEN EXPORT CSV WITH FINAL MEAN DATA############
get_all_my_dataframes <- function(){
  #Import the data
  MySimulations <- ImportMyData()
  
  
  #divide islands into archipelagos for each simulation
  all_my_dataframes <- list()
  
  for (s in 1:length(MySimulations)) {
    
    Data <- MySimulations[[s]] #isolate a simulation
    
    Data <- lapply(Data, `[[`, 1) #keep only the niche data, not the timeseries data
    
    all_my_dataframes[[s]] <- final_function(Data = Data)
    
  }
  
  return(all_my_dataframes)
}

###################################################
#################FUNCTION TWELVE######################
###################################################
get_my_final_means <- function(all_my_dataframes, arch_num){
  
  df <- all_my_dataframes[[1]] #isolate the first simulation
  arch <- df[df$arch_num == arch_num, ] #isolate the archipelago with that number
  
  for (d in 2:length(all_my_dataframes)){ 
    df2 <- all_my_dataframes[[d]] #get the next simulation
    arch2 <- df2[df2$arch_num == arch_num, ] #get the same arch in that sim
    sp2 <- arch2$species #get the species richness
    arch$species_2 <- sp2 #add it to the dataframe
    names(arch)[length(names(arch))]<- d #rename the column
  }
  
  #seperate out just the species data 
  n <- ncol(arch) - 6
  arch_min <- arch[,(ncol(arch)-n-1):ncol(arch)]
  #get the row means of the species data
  my_row_means <- rowMeans(arch_min)
  arch1 <- arch[, 1:4]
  arch1$species <- my_row_means
  
  return(arch1)
  
}

###################################################
#################FUNCTION THIRTEEN######################
###################################################

every_arch <- function(all_my_dataframes){
  
  arch_list <- list()
  
  for (arch_num in 1:length(all_my_dataframes)){
    arch_list[[arch_num]] <- get_my_final_means(all_my_dataframes = all_my_dataframes, arch_num = arch_num)
  }
  
  return(arch_list)
}


#####################################################################################
#################FINAL SCRIPT TO GET THE ARCH MEAN DATA AND SAVE######################
#####################################################################################
all_my_dataframes <- get_all_my_dataframes() #get the dataframes for each simulationtun

#get the mean results for each archipelago across simulations
arch_list <- every_arch(all_my_dataframes = all_my_dataframes)
total_arch_list <- do.call("rbind", arch_list)

#export as csv file
write.csv(total_arch_list, "../../../Results/total_sim_results.csv", row.names = FALSE)
