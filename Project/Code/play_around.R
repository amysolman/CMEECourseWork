rm(list=ls())
graphics.off()

##Me attempting to play around with the concenpts in Ryan's paper

library("ggplot2")
area <- seq(1, 100)
#niches <- area**3
#migration <- area**0.6
migration <- area**2
niches <- area**0.3
total <- vector()

for (i in 1:length(niches)) {
  x <- sum(niches[[i]], migration[[i]])
  total[[i]] <- x
}

df <- cbind.data.frame(area, niches, migration, total)


ggplot(df, aes(area)) + 
  ylab("Species Richness") +
  xlab("Island Area") +
  geom_line(aes(y = niches, colour = "Niches")) + 
  geom_line(aes(y = migration, colour = "Immigration")) +
  geom_line(aes(y = total, colour = "Total")) +
  theme(legend.title = element_blank())

