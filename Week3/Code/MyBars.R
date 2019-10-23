# Amy Solman amy.solman19@imperial.ac.uk
# 22nd October 2019
# MyBars.R

require(ggplot2)

#Annotating plots with geom and text
a <- read.table("../Data/Results.txt", header = TRUE) #Where is the data??

head(a)

a$ymin <- rep(0, dim(a)[1]) #append a column of zeros

#print the first linerange
p <- ggplot(a)
p <- p + geom_linerange(data = a, aes(
                        x = x,
                        ymin = ymin,
                        ymax = y1,
                        size = (0.5)
                        ),
                        colour = "#E69F00",
                        alpha = 1/2, show.legend = FALSE)

#print the second linerange:
p <- p + geom_linerange(data = a, aes(
                        x = x,
                        ymin = ymin,
                        ymax = y2,
                        size = (0.5)
                        ),
                        colour = "#56B4E9",
                        alpha = 1/2, show.legend = FALSE)

#print the third linerange:
p <- p + geom_linerange(data = a, aes(
                        x = x,
                        ymin = ymin,
                        ymax = y3,
                        size = (0.5)
                        ),
                        colour = "#D55E00",
                        alpha = 1/2, show.legend = FALSE)

#Annotate the plot with labels:
p <- p + geom_text(data = a, aes(x=x, y = -500, label = Label))

#Now set the axis labels, remove the legend, and prepare for bw printing
p <- p + scale_x_continuous("My x axis",
                            breaks = seq(3, 5, by = 0.05)) +
                            scale_y_continuous("My y axis") +
                            theme_bw() +
                            theme(legend.position = "none")
p

pdf("../Results/MyBars.pdf")
print(p)
dev.off()