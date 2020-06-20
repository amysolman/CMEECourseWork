###Script to plot three simulation timeseries
#to make sure extinction-migration dynamic equilibrium has been reached

rm(list=ls())
graphics.off()

library("ggplot2")
library("gridExtra") #for multiplots on one graph

#read in our plotting data

PlottingData <- read.csv("../../Data/SimData/SimTimeseriesPlotData2.csv")

#plot three of our simulations to check they reached equilibrium

my_plots <- list()

for (p in 1:3) {
  
  plot_data <- PlottingData[PlottingData$sim_number == p*25, ]
  plot_data <- plot_data[plot_data$island_num %% 100 == 0, ]

  
  plot <- ggplot(plot_data, aes(x=timestep, y=SpRichTimeseries, group=island_num)) +
    geom_line(aes(color=island_num, group=island_num))+
    geom_point(aes(color=island_num, group=island_num)) +
    scale_colour_gradientn(colours=rainbow(10)) +
    ggtitle("Simulation", p*25)

  my_plots[[p]] <- plot
}

# Print the plot to a pdf file
pdf("../../Results/Simulation2/TimeseriesPlot.pdf")
myplot <- do.call(grid.arrange,my_plots)
print(myplot)
dev.off()
