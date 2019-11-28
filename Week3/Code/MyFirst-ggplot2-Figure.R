# Amy Solman amy.solman19@imperial.ac.uk
# 28th November 2019
# MyFirst-ggplot2-Figure.R

library(ggplot2)

rm(list=ls())
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

pdf("../results/MyFirst-ggplot2-Figure.pdf")
print(qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
            main = "Relation between predator and prey mass",
            xlab = "log(Prey mass (g)",
            ylab = "log(Predator mass (g)") + theme_bw())
dev.off()
