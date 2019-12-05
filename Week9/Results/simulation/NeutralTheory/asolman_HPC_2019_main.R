# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Amy Solman"
preferred_name <- "Amy"
email <- "amy.solman19@imperial.ac.uk"
username <- "abs119"
personal_speciation_rate <- 0.002 # will be assigned to each person individually in class and should be between 0.002 and 0.007

# Question 1
species_richness <- function(community){
  result <- length(unique(community))
  print(result)
}

# Question 2
init_community_max <- function(size){
  result <- c(seq(1, size, 1))
  print(result)
  
}

# Question 3
init_community_min <- function(size){
  result <- c(rep(1, size))
  print(result)
}

# Question 4
choose_two <- function(max_value){
  result <- sample(max_value, 2, replace = FALSE)
  return(result)
  
}

# Question 5
neutral_step <- function(community){
  index <- choose_two(length(community)) #chooses two from the population
  x <- index[1] 
  y <- index[2]
  community[y] <- community[x] #the second individual takes the value of the first individual
  return(community)
}

# Question 6
neutral_generation <- function(community){
  size <- (length(community)/2)#find half the pop size of the community (generation length)
  
  if (size %% 2 != 0) { #if size is odd
    seed <- runif(1) #generate a random number
    if (seed > 0.5) { #if the random number is greater than 0.5
      ceiling(size) #round size up
    } else { 
      floor(size) #else round size down
    } 
  }
  
  for (i in 1:size) { #for each i in 1 to half the size of the community
    x <- neutral_step(community)#perform the neutral_step and store the results in x
    community <- x #replace community with x
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  series <- community
  for (i in 1:duration) {
    x <- neutral_generation(community)
    series <- rbind(series, x)
    community <- x
  }
  return(series)
}

# Question 8
question_8 <- function() {
  graphics.off() 
  data <- neutral_time_series(community = init_community_max(100), duration = 200)
  x <- 1:nrow(data) 
  y <- apply(data, 1, function(i)length(unique(i)))
  plot(y~x, pch=20, col = "red", xlab = "Number of Generations", ylab = "Species diversity (number of species)")
  return("Over a long enough timescale the system will always converge to a state of homogeneity.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  index <- choose_two(length(community))
  x <- index[1] #assign index 1 to x
  y <- index[2] #assign index 2 to y
  
  num <- runif(1) #generate a random number
  
  max <- (max(community) + 1) #set maximum number that could be chosen,
  #plus 1 incase there is 1 individual per species (e.g. community = 1,2,3,4 etc)
  a <- 1:max 
  b <- setdiff(a, community) 
  c <- sample(b, 1, replace = FALSE)
  
  if (num <= speciation_rate) { #if the random number is less than or equal to speciation rate
    #generate a random number between the lowest and highest species value
    community[x] <- c #replace species at index x with a unique number
  } else { 
    community[y] <- community[x] #the individual at index y is replaced by the offspring of the individual at index x
  }
  
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  size <- (length(community)/2)#find half the pop size of the community (generation length)
  
  if (size %% 2 != 0) { #if size is odd
    seed <- runif(1) #generate a random number
    if (seed > 0.5) { #if the random number is greater than 0.5
      ceiling(size) #round size up
    } else { 
      floor(size) #else round size down
    } 
  }
  
  for (i in 1:size) { #for each i in 1 to half the size of the community
    x <- neutral_step_speciation(community, speciation_rate)#perform the neutral_step and store the results in x
    community <- x #replace community with x
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  series <- community
  for (i in 1:duration) {
    x <- neutral_generation_speciation(community, speciation_rate)
    series <- rbind(series, x)
    community <- x
  }
  return(series)
}

# Question 12
question_12 <- function(community_1, community_2, speciation_rate, duration)  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  community_1 <- init_community_max(100)
  community_2 <- init_community_min(100)
  speciation_rate <- 0.1
  duration <- 200
  
  data <- neutral_time_series_speciation(community_1, speciation_rate, duration)
  x <- 1:nrow(data)
  y <- apply(data, 1, function(i)length(unique(i)))
  plot(y~x, pch=20, col = "blue", type = "l", xlab = "Number of Generations", 
       ylab = "Species diversity (number of species)",
       main = "Neutral Theory Simulation with Speciation (0.1)", ylim = c(0, 100))
  
  data <- neutral_time_series_speciation(community_2, speciation_rate, duration)
  x <- 1:nrow(data)
  y <- apply(data, 1, function(i)length(unique(i)))
  lines(y~x, pch=20, col = "red")
  legend('topright', pch = c(2,2), c('Initial maximum diversity', 'Initial minimum diversity'), col = c("blue", "red"))
  return("OVer a long enough timescale initially species diversity will reach equilibrium.")
}

# Question 13
species_abundance <- function(community)  {
  x <- sort(table(community), decreasing = TRUE)
  return(as.numeric(x))
}

# Question 14
octaves <- function(abundance_vector) {
  x <- log2(abundance_vector)
  y <- floor(x)
  for (i in 1:length(y)) {
    y[i] <- y[i] + 1
  }
  tabulate(y)
}

# Question 15
sum_vect <- function(x, y) {
  
  while (length(x) != length(y)) {
    if (length(x) > length(y)) {
      y <- append(y, 0)
    } else {
      x <- append(x, 0)
    }
  }
  return (x + y)
}

# Question 16 
question_16 <- function()  {
  #######DEFINE INITIAL COMMUNITIES, MAX AND MIN DIVERSITY########
  community_1 <- init_community_max(100)
  community_2 <- init_community_min(100)
  speciation_rate <- 0.1
  
  #Two foor loops
  #first one doing 200 generations
  
  for (i in 1:200) { 
    new_com1 <- neutral_generation_speciation(community_1, speciation_rate) #advance one generation with speciation
    community_1 <- new_com1 
    
    new_com2 <- neutral_generation_speciation(community_2, speciation_rate) #advance one generation with speciation
    community_2 <- new_com2 
    
  }
  
  ############SPECIES ABUNDANCE OCTAVE VECTOR##########
  a <- species_abundance(community_1)
  b <- species_abundance(community_2)
  
  octave_max_list <- list(octaves(a))
  octave_min_list <- list(octaves(b))
  
  j <- 2 #assign value to j for use in indexing in for loop
  
  
  for (i in 1:2000) {
    
    new_com1 <- neutral_generation_speciation(community_1, speciation_rate) #advance one generation with speciation
    #using the community at 200 generations
    community_1 <- new_com1 #replace the last community with the next
    
    new_com2 <- neutral_generation_speciation(community_2, speciation_rate) #advance one generation with speciation
    
    community_2 <- new_com2 
    
    if (i %% 20 == 0) {
      a <- species_abundance(community_1) 
      b <- octaves(a)
      octave_max_list[[j]] <- b
      
      
      c <- species_abundance(community_2)
      d <- octaves(c)
      octave_min_list[[j]] <- d
      
      j <- j + 1 
      
    }
    
  }
  
  ###use octave_max_list and octave_min_list to create two bar charts of average species abundance 
  
  i <- 1
  x <- octave_max_list[[i]]
  y <- octave_max_list[[i+1]]
  x <- sum_vect(x, y)
  
  for (i in 2:100) {
    y <- octave_max_list[[i+1]]
    x <- sum_vect(x, y)
    
  }
  
  oct_max_total <- x/(length(octave_max_list)) #divide the totalled octave values by the number of octave values
  
  i <- 1
  x <- octave_min_list[[i]]
  y <- octave_min_list[[i+1]]
  x <- sum_vect(x, y)
  
  for (i in 2:100) {
    y <- octave_min_list[[i+1]]
    x <- sum_vect(x, y)
    
  }
  
  oct_min_total <- x/(length(octave_max_list)) #divide the totalled octave values by the number of octave values
  
  graphics.off() 
  
  par(mfcol=c(2,1)) #initialize multi-paneled plot
  par(mfg = c(1,1)) #specify which subplot to use first
  barplot(oct_max_total,
          xlab = "octaves", ylab = "Count", col = "lightblue", border = "pink",
          main = 'Initial Maximum Diversity') #Add title
  par(mfg = c(2,1)) #Second sub-plot
  barplot(oct_min_total, xlab = "octaves", ylab = "Count", col = "lightgreen", 
          border = "pink", main = 'Initial Minimum Diversity')
  return("The initial condition of the system fails to have a significant effect on the final species abundance distribution. 
               Regardless of the initial species richness of a community, over a long enough time period the community reaches equilibrium.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  
  community <- init_community_min(size) #set initial community
  j <- 1 #initialise value for j for appending to lists
  i <- 1 #initialise value of i for counting number of generations
  species_richness_list <- list() #create empty list for species_richness
  species_octaves_list <- list() #create empty list for species_octaves
  
  ptm <- proc.time()[3] #set start of timer
  
  while (proc.time()[3] - ptm < wall_time*60){ #while the third element in proc.time minus starting time is less than wall_time
    
    community <- neutral_generation_speciation(community, speciation_rate)#run the simulation
    
    if (i <= burn_in_generations) { #if the number of loops is less/equal to the number of burn_generations
      if (i %% interval_rich == 0) { #if generation number divided by interval_rich has no remainder 
        a <- species_richness(community) #save species richness of the current community to a
        species_richness_list[[as.character(j)]] <- a #append a to species_richness_list
      }
    }
    
    if (i %% interval_oct == 0) { #if generation number divided by interval_oct has no remainder
      c <- species_abundance(community) #save species abundance of current community to a
      d <- octaves(c) #calculate octaves
      species_octaves_list[[as.character(j)]] <- d #append octaves to species_octave_list
      
    }
    
    j <- j + 1 #add 1 to j to update count of loops (generations)
    i <- i + 1 #add 1 to i to update count of loops (generations)
    
  }
  
  #save to file
  
  total_time <- proc.time()[3] - ptm
  
  save(community, species_richness_list, species_octaves_list, total_time, 
       speciation_rate, size, interval_oct, interval_rich, burn_in_generations,
       file = output_file_name)
  
  
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  combined_results <- list() #create your list output here to return
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {

  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 29
fern <- function(start_position, direction, length)  {
  
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 30
fern2 <- function(start_position, direction, length)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


