# Amy Solman amy.solman19@imperial.ac.uk
# 15th October 2019
# Example of control flow tools

## if statements
a <- TRUE
if (a == TRUE) {
        print ("a is TRUE")
        } else {
        print("a is FALSE")
}

## if statement on a single line
z <- runif(1) ## uniformly distributed random number
if (z <= 0.5) {print("Less than half")}

## for loop using a sequence
for (i in 1:10){ # this is an explicit input - for each number in 1 to 10
        j <- i * i # times that number by itself and assign to variable j
        print(paste(i, " squared is", j)) # print each number "is suqare by"
# assigned j variable
}

## For loop over vector of strings
for(species in c('Heliodoxa rubinoides',
                 'Bolissonneaua jardini',
                 'Sula nebouxii')){
  print(paste('The species is', species)) #paste converts arguments to character 
#strings and 
# concatenates them
}
## for loop using a vector
v1 <- c("a", "bc", "def")
for (i in v1){
        print(i)
}

## while loop
i <- 0
while (i<10){
        i <- i + 1
        print(i^2) # squared numbers up to 10
}