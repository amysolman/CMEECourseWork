# clear any existing graphs and plot your graph within the R window
rm(list=ls())
graphics.off()


octave_500 <- list()
octave_1000 <- list()
octave_2500 <- list()
octave_5000 <- list()


##########LOAD SPECIES OCTAVES AND RICHNESS BY SIMULATION SIZE###########
for (i in 1:100) {
  loaded <- load(paste0("simulation_",i,".rda"))
  if (size == 500) {
    octave_500[[i]] <- species_octaves_list
  } else {
    if (size == 1000) {
      octave_1000[[i]] <- species_octaves_list
    } else {
      if (size == 2500) {
        octave_2500[[i]] <- species_octaves_list
      } else {
        if (size == 5000) {
          octave_5000[[i]] <- species_octaves_list
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

#For octave_500 we need to work out the average species abundance octaves AFTER 4000 generations

#for simulation 1-25 in octave_5000 we want to save only results after 4000 generations (column 1)

#removes species abundance octaves before burn in time
for (i in 1:25) {
  octave_500[[i]][1:80] <- NULL
  octave_1000[[i]][1:80] <- NULL
  octave_2500[[i]][1:80] <- NULL
  octave_5000[[i]][1:80] <- NULL
}

###use octave_500, octave_1000, octave_2500 and octave_5000 to create four bar charts of average species abundance 

i <- 1 #assign value of 1 to i
x <- octave_500[[1]][i]
y <- octave_500[[1]][i+1]
x <- sum_vect(x[[1]], y[[1]])

for (i in 2:25) {
  y <- octave_500[[1]][i+1]
  x <- sum_vect(x[[1]], y[[1]])
  
}

oct_500_total <- x/(length(octave_500)) #divide the totalled octave values by the number of octave values

i <- 1 #assign value of 1 to i
x <- octave_1000[[1]][i]
y <- octave_1000[[1]][i+1]
x <- sum_vect(x[[1]], y[[1]])

for (i in 2:25) {
  y <- octave_1000[[1]][i+1]
  x <- sum_vect(x[[1]], y[[1]])
  
}

oct_1000_total <- x/(length(octave_1000)) 

i <- 1 #assign value of 1 to i
x <- octave_2500[[1]][i]
y <- octave_2500[[1]][i+1]
x <- sum_vect(x[[1]], y[[1]])

for (i in 2:25) {
  y <- octave_2500[[1]][i+1]
  x <- sum_vect(x[[1]], y[[1]])
  
}

oct_2500_total <- x/(length(octave_2500)) 

i <- 1 #assign value of 1 to i
x <- octave_5000[[1]][i]
y <- octave_5000[[1]][i+1]
x <- sum_vect(x[[1]], y[[1]])

for (i in 2:25) {
  y <- octave_5000[[1]][i+1]
  x <- sum_vect(x[[1]], y[[1]])
  
}

oct_5000_total <- x/(length(octave_5000)) 


graphics.off() 

par(mfcol=c(2,2)) #initialize multi-paneled plot
par(mfg = c(1,1)) #specify which subplot to use first
barplot(oct_500_total,
        xlab = "octaves", ylab = "Count", col = "blue", border = "pink",
        main = 'Community Size 500') #Add title
par(mfg = c(1,2)) #Second sub-plot
barplot(oct_1000_total, xlab = "octaves", ylab = "Count", col = "green", 
        border = "pink", main = 'Community Size 1000')
par(mfg = c(2,1)) #Second sub-plot
barplot(oct_2500_total, xlab = "octaves", ylab = "Count", col = "red", 
        border = "pink", main = 'Community Size 2500')
par(mfg = c(2,2)) #Second sub-plot
barplot(oct_5000_total, xlab = "octaves", ylab = "Count", col = "yellow", 
        border = "pink", main = 'Community Size 5000')


combined_results <- list(oct_500_total, oct_1000_total, oct_2500_total, oct_5000_total) #create your list output here to return
return(combined_results)