#plot the transition of r-squared values

library("ggplot2")

data <- read.csv("../../Results/Simulation2/LMResults.csv")

p1 <- ggplot(data, aes(x = maxArea, y = R.Squared, group = Variate)) +
  geom_point(aes(colour = Variate)) +
  geom_line(aes(colour = Variate)) + 
  xlab("Maximum Island Area") +
  ylab("R-Squared Statistic") +
  theme_bw()

pdf("../../Results/Simulation2/LMRSquared.pdf")
print(p1)
dev.off()
