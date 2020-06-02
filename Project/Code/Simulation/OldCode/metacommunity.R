#Script to generate meta community
rm(list=ls())
graphics.off()

#install.packages("untb") #package to generate an equilibrium metacommunity 
library(untb)


#####FUNCTION ONE######
#Generate equilibrium meta community

get_my_meta <- function(size_ecosystem, num_species, max_num_abundance_classes) {
  J_Meta = fisher.ecosystem(size_ecosystem, num_species, max_num_abundance_classes) #size of ecosystem, number of species,
  #max num species abundance classes to consider
  Meta <- vector()
  for (s in 1:nrow(J_Meta)) {
    num <- J_Meta[[s]]
    com <- rep(s, num)
    Meta <- c(Meta, com)
  }

  return(Meta)
}

J_meta = 10000
Meta = get_my_meta(size_ecosystem = J_meta, 100, 1000)

write.csv(Meta, "metacommunity.csv")

