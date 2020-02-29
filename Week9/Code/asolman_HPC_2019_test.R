# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
graphics.off()
  
  #define two initial communities
  community_max <- init_community_max(100)
  community_min <- init_community_min(100)
  speciation_rate <- 0.1
  
  #THIS IS ONE SIMULATION - WE NEED TO RUN THIS FOR MULTIPLE SIMULATIONS AND FIND THE AVERAGE
  
  #run the neutral_generation_speciation function for 200 generations for the two communities
  #for each generation record the mean species richness for the simulation up to that point
  
  #CREATE MATRIX WITH 100 ROWS - EACH ROW REPRESENTS A SIMULATION
  
  species_diversity_max <- list()
  max_matrix <- c(length(unique(community_max)))
  
  species_diversity_min <- list()
  species_diversity_min <- c(length(unique(community_min)))
  
  max_matrix <- matrix(, nrow = 100, ncol = n.columns)
  for(columns in 1:n.columns) {
    max_matrix[,column] <-  species_diversity_max #add each generation of the 100 simulations as a column to the matrix
  }

  
  for (i in 2:1000) { 
    new_com_max <- neutral_generation_speciation(community_max, speciation_rate) #advance one generation with speciation
    species_diversity_max[[i]] <- species_richness(new_com_max)
    
    new_com_min <- neutral_generation_speciation(community_min, speciation_rate) #advance one generation with speciation
    species_diversity_min[[i]] <- species_richness(new_com_min)
    }

  x <- 1:length(species_diversity_max)
  y <- species_diversity_max
  plot(y~x, pch=20, col = "blue", type = "l", xlab = "Number of Generations", 
       ylab = "Species diversity (number of species)",
       main = "Neutral Theory Simulation with Speciation (0.1)", ylim = c(0, 100))
  
  x <- 1:length(species_diversity_min)
  y <- species_diversity_min
  lines(y~x, pch=20, col = "red")
  legend('topright', pch = c(2,2), c('Initial maximum diversity', 'Initial minimum diversity'), col = c("blue", "red"))
}
  
  }

