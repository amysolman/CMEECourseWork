# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice 
source("asolman_HPC_2019_main.R")

# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  rm(list=ls())
  graphics.off()
  

octave_500 <- list()
richness_500 <- list()
octave_1000 <- list()
richness_1000 <- list()
octave_2500 <- list()
richness_2500 <- list()
octave_5000 <- list()
richness_5000 <- list()


##########LOAD SPECIES OCTAVES AND RICHNESS BY SIMULATION SIZE###########
  for (i in 1:20) {
    loaded <- load(paste0("../Code/PracticeSims/simulation_",i,".rda"))
    if (size == 500) {
    octave_500[[i]] <- species_octaves_list
    richness_500[[i]] <- species_richness_list
    
    } else {
      if (size == 1000) {
        octave_1000[[i]] <- species_octaves_list
        richness_1000[[i]] <- species_richness_list
      } else {
        if (size == 2500) {
          octave_2500[[i]] <- species_octaves_list
          richness_2500[[i]] <- species_richness_list
        } else {
          if (size == 5000) {
            octave_5000[[i]] <- species_octaves_list
            richness_5000[[i]] <- species_richness_list
          }
        }
      }
    }
    
  }

##########REMOVE NULL VALUES#########

l1 <- lapply(octave_1000, function(x) x[lengths(x) > 0])
octave_1000 <- l1[lengths(l1) >  0]

l1 <- lapply(octave_2500, function(x) x[lengths(x) > 0])
octave_2500 <- l1[lengths(l1) >  0]

l1 <- lapply(octave_500, function(x) x[lengths(x) > 0])
octave_500 <- l1[lengths(l1) >  0]

l1 <- lapply(octave_5000, function(x) x[lengths(x) > 0])
octave_5000 <- l1[lengths(l1) >  0]

l1 <- lapply(richness_1000, function(x) x[lengths(x) > 0])
richness_1000 <- l1[lengths(l1) >  0]

l1 <- lapply(richness_2500, function(x) x[lengths(x) > 0])
richness_2500 <- l1[lengths(l1) >  0]

l1 <- lapply(richness_500, function(x) x[lengths(x) > 0])
richness_500 <- l1[lengths(l1) >  0]

l1 <- lapply(richness_5000, function(x) x[lengths(x) > 0])
richness_5000 <- l1[lengths(l1) >  0]
  
    
  
  # #this loads the files as a list
  # rda2list <- function(file) {
  #   e <- new.env()
  #   load(file, envir = e)
  #   as.list(e)
  # }
  # 
  # folder <- "../Code/PracticeSims"
  # files <- list.files(folder, pattern = ".rda$")
  # 
  # simulations <- Map(rda2list, file.path(folder, files))
  # names(simulations) <- tools::file_path_sans_ext(files)
  
  
  #calculate mean species abundance octaves for each simulation size AFTER burn time
  
  #Functing should also return a list of four vectors corresponding to the octave outputs
  #that plot the four bar graphs - the vectors should appear in the list in increasing size order
  #e.g. size = 500 first
  #Hint: use the load function on your .rda files and use sum_vect
  
  #Four bar graphs in a multipanel graph (one for each simulation size)
  #each showing mean species abundance octave result for simulation runs of that size
  #Only use data of abundance octave after the burn time is up
  
  par(mfcol=c(2,2)) #initialize multi-paneled plot
  par(mfg = c(1,1)) #specify which subplot to use first
  barplot(oct_500,
          xlab = "octaves", ylab = "Count", col = "lightblue", border = "pink",
          main = 'Run Size 500')
  par(mfg = c(1,2)) #Second subplot
  barplot(oct_1000, 
          xlab = "octaves", ylab = "Count", col = "lightgreen", border = "pink", 
          main = 'Run Size 1000')
  par(mfg = c(2,1)) #third subplot
  barplot(oct_2500,
          xlab = "octaves", ylab = "Count", col = "lightblue", border = "pink",
          main = 'Run Size 2500')
  par(mfg = c(2,2)) #fourth subplot
  barplot(oct_5000,
          xlab = "octaves", ylab = "Count", col = "lightblue", border = "pink",
          main = 'Run Size 5000')
  
  combined_results <- list() #create your list output here to return
  return(combined_results)
  
  
  graphics.off()
  plot(1, type="n", xlab="", ylab="", xlim=c(0, 4), ylim=c(0, 4), cex=0.2)
  
  
  
  
  # Question 24
  #Create a function turtle in R to draw a line of a given length from a given point (defined as a vector)
  #and in a given direction. So turtle will have three inputs: start_position, direction (measured in radians, 
  #not degrees) and length. As well as drawing the line, turtle should return the end point of the line
  #it just drew as a vector. Turtle should not open the plot, it should just draw the line on an already open plot.
  #(Hint: you need to use sin and cos).
  
  radians <- degrees * pi / 180 # applies 'degrees' multiplied by pie divided by 180 to radians
  #there are two radians in 360 degrees
  
  #first let's open a plot to test on:
  plot(1, type="n", xlab="", ylab="", xlim=c(-4, 4), ylim=c(-4, 4), cex=0.2)
  
  turtle(start_position = c(1,1), direction = 0.5, length = 2)
  
  turtle <- function(start_position, direction, length)  {
    #start position plus lenght plus direction = new point
    x0 <- start_position[1]
    y0 <- start_position[2]
    points(x0,y0)
    
    x1 <- length*cos(direction) + x0
    y1 <- length*sin(direction) + y0
    points(x1,y1)
    endpoint <- c(x1,y1)
    #draw a line from position 1 to position 2
    segments(x0, y0, x1 = x1, y1 = y1, col = 'blue')

    return(endpoint) # you should return your endpoint here.
  }
  
  #Now create another function elbow that calls turtle twice to draw a pair 
  #of lines that join together with a given angle between them. As with turtle, 
  #it should not open a new plot and should assume a suitable plot is already open.
  #The function elbow should accept as an input: the starting point, direction 
  #and length of the first line. The second point should start at the end point of the first line, 
  #have a direction that is 45 degrees (pi*/4 radians) to the right of that first line and have 
  #a length that is 0.95 times the length of the first line
  
  plot(1, type="n", xlab="", ylab="", xlim=c(-2, 8), ylim=c(0, 8), cex=0.2)
  

  
  spiral(start_position = c(1,1), direction = 0.5, length = 2)
  
  
  start_position = c(1,1)
  direction = 0.5
  length = 2

  
  
  spiral <- function(start_position, direction, length)  {
    
    while (length > 0.1) {
      
      first_line <- turtle(start_position, direction, length)
      
      second_line <-spiral(start_position = first_line, direction = direction + (pi/4), length = length*0.95)
    }
      
    return("This function uses turtle to draw the first line, then calls itself the draw proceeding lines from the last point, with direction angle + new angle, with gradually decreasing length.") #get return to work
  } 
    
  
  
  

  

