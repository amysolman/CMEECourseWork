#Challenge Question D
rm(list=ls())
graphics.off()

size = 100
speciation_rate = 0.2

#Challenge_D <- function (size, speciation_rate) {
  J = size
  v = speciation_rate
  lineages = rep(1, J)
  abundances = vector()
  N = J
  fund_bio_num = v*((J-1)/(1-v))  
  
#}

