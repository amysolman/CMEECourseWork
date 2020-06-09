#script to plot our nlls results with my sim results

rm(list=ls())
graphics.off()

library("ggplot2")

data <- read.csv("../../Results/Simulation/NLLSMeanPlotPoints.csv")

p1 <- ggplot(data, aes(x = Area, y = Species, group = ModelOrSim)) +
  geom_point(aes(colour = ModelOrSim)) +
  geom_line(data = data[data$ModelOrSim == "Chisholm Model", ], aes(x = Area, y = Species, colour = "Chisholm Model")) +
  theme(legend.title = element_blank()) +
  labs(title="NLLS Fitting of Chisholm Model \nto Solman Simulation Data")

pdf("../../Results/Simulation/NLLSFit.pdf")
print(p1)

