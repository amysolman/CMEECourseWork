#old non linear least squares fitting code

seperate_islands <- function() {
  islands <- list()
  more_islands <- list()
  for (m in 1:length(unique(SimData$migration_rates))) {
    df <- SimData[SimData$migration_rates == m/1000, ] #subset data by migration rate
    for (k in 1:length(unique(df$K_num))) {
      data <- df[df$K_num == k, ] #subset THAT data by number of niches
      islands[[k]] <- data
    }
    more_islands[[m]] <- islands #store all the subset data
  }
  return(more_islands)
}

#Get the mean of all results
meanie <- function() {
  
  more_islands <- seperate_islands()
  
  my_df = data.frame(matrix(vector(), 0, 4,
                            dimnames=list(c(), c("migration_rate", "area", "K_num", "mean_sp"))),
                     stringsAsFactors=F)
  
  for (m in 1:length(unique(SimData$migration_rates))) {
    for (k in 1:length(unique(SimData$K_num))) {
      my_islands <- more_islands[[m]][[k]]
      mean_sp <- mean(my_islands$island_species)
      migration_rate <- my_islands[1, ]$migration_rates
      area <- my_islands[1, ]$area
      K_num <- my_islands[1, ]$K_num
      df <- data.frame(migration_rate, area, K_num, mean_sp)
      my_df <- rbind(my_df, df)
    }
  }
  
  return(my_df)
}

#function to compare means to model
compare_my_mean <- function() {
  
  my_df <- meanie()
  
  #create empty list for storing estimated species richness
  estimated_sp_rich <- vector()
  
  for (i in 1: nrow(my_df)) {
    data <- my_df[i, ]
    m = data$migration_rate
    area = data$area
    J = area
    m0 = m*sqrt(area)
    nu = 0.001
    theta = nu*(J-1)/(1-nu)
    K = data$K_num
    estimated_sp_rich[[i]] <- round(chisholm_model(area, theta, m0, K), digits = 2)
  }
  
  #bind results to single dataframe
  MeanSimDataAndEst <- cbind.data.frame(my_df$area, my_df$migration_rate, my_df$mean_sp, estimated_sp_rich)
  names(MeanSimDataAndEst) <- c("Area", "Migration", "SimRich", "ModelRich")
  
  return(MeanSimDataAndEst)
  
}



write.csv(MeanSimDataAndEst, "../../Results/MeanNonNllsSimFit.csv", row.names = FALSE)
write.csv(SimDataAndEst, "../../Results/TotalNonNllsSimFit.csv", row.names = FALSE)
pdf("../../Results/NonNLLSFitPlot.pdf")
print(p)
dev.off()