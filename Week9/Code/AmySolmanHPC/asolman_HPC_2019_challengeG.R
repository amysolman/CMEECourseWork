# CMEE 2019 HPC excercises R code challenge G proforma

rm(list=ls()) # nothing written elsewhere should be needed to make this work

name <- "Amy Solman"
preferred_name <- "Amy"
email <- "amy.solman19@imperial.ac.uk"
username <- "abs119"

# don't worry about comments for this challenge - the number of characters used will be counted starting from here

t <- function(s, d, l)  {
  segments(s[1], s[2], (x <- l*cos(d) + s[1]), (y <- l*sin(d) + s[2]))
  return(c(x,y))
}

f <- function(s=c(1,1), d=1.58, l=2, c=1)  {
  if (l > 0.005) {
    f <- t(s, d, l) 
    a <-f(s = f, d = d + (pi/4) * c, l = l*0.38, c)
    b <-f(s = f, d, l = l*0.87, c = c * -1) 
  } 
} 

plot(1, xaxt='n', yaxt='n', ann=FALSE, xlim=c(-3, 5), ylim=c(0, 16))
f()