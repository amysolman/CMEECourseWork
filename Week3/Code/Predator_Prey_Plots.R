# Amy Solman amy.solman19@imperial.ac.uk
# 21st October 2019
# Predator_Prey_plots.R

rm(list=ls())
graphics.off()

require(dplyr)
library(lattice)

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
dim(MyDF)

str(MyDF)
head(MyDF)

dplyr::glimpse(MyDF)

plot(MyDF$Predator.mass, MyDF$Prey.mass)

plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass))

plot(log10(MyDF$Predator.mass), log10(MyDF$Prey.mass))

plot(log10(MyDF$Predator.mass), log10(MyDF$Prey.mass), pch=20) #change marker

plot(log10(MyDF$Predator.mass), log10(MyDF$Prey.mass), pch=20, xlab = "Predator Mass (g)", ylab = "Prey Mass (g)") #Add labels

hist(MyDF$Predator.mass)

hist(log10(MyDF$Predator.mass), xlab = "log10(Predator Mass (g))", ylab = "Count") #include labels

hist(log10(MyDF$Predator.mass), xlab = "log10(Predator Mass (g))", ylab="Count",
     col = "lightblue", border = "pink") #change bar and borders colors

graphics.off()

par(mfcol=c(2,1)) #initialize multi-paneled plot
par(mfg = c(1,1)) #specify which subplot to use first
hist(log10(MyDF$Predator.mass),
     xlab = "log10(Predator Mass (g))", ylab = "Count", col = "lightblue", border = "pink",
     main = 'Predator', breaks = 20) #Add title
par(mfg = c(2,1)) #Second sub-plot
hist(log10(MyDF$Prey.mass), xlab = "log10(Prey Mass (g))", ylab = "Count", col = "lightgreen", 
     border = "pink", main = 'Prey', breaks = 20)


#Overlaying plots

graphics.off()

hist(log10(MyDF$Predator.mass), #Predator histogram
     xlab = "log10(Body Mass (g))", ylab = "Count",
     col = rgb(1, 0, 0, 0.5), #Note 'rgb', fourth value is transparent
     main = "Predator-prey size Overlap",
     breaks = 20)
hist(log10(MyDF$Prey.mass), col = rgb(0, 0, 1, 0.5), add = T,
     breaks = 20) #Plot prey
legend('topleft', c('Predators', 'Prey'), #Add legend
       fill = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5))) #Define legend colours

#Boxplots

boxplot(log10(MyDF$Predator.mass), xlab = "Location", ylab = "log10(Predator Mass)", main = "Predator mass")

boxplot(log10(MyDF$Predator.mass) ~ MyDF$Location, #why the tilde?
 xlab = "Location", ylab = "Predator Mass",
 main = "Predator mass by location")

boxplot(log(MyDF$Predator.mass) ~ MyDF$Type.of.feeding.interaction,
        xlab = "Location", ylab = "Predator Mass",
        main = "Predator mass by feeding interaction type")

#Combining plot types

par(fig=c(0,0.8,0,0.8)) #Specify figure size as proportion
plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass), xlab = "Predator Mass (g)", ylab = "Prey Mass (g)") #Add labels
par(fig=c(0,0.8,0.4,1), new=TRUE)
boxplot(log(MyDF$Predator.mass), horizontal = TRUE, axes = FALSE)
par(fig=c(0.55,1,0,0.8), new=TRUE)
boxplot(log(MyDF$Prey.mass), axes=FALSE)
mtext("Fancy Predator-prey scatterplot", side=3, outer=TRUE, line=-3)

#Lattice plots 

#densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF)

#Saving your graphics

pdf("../results/Pred_Prey_Overlay.pdf", #Open a blank pdf using a relative path
   11.7, 8.3)
hist(log(MyDF$Predator.mass),
     xlab = "Body Mass (g)", ylab = "Count", col = rgb(1, 0, 0, 0.5), main = "Predator-Prey Size Overlap")
hist(log(MyDF$Prey.mass),
     col = rgb(0, 0, 1, 0.5),
     add = T) #Add to the same plot = True
legend('topleft', c('Predators', 'Prey'), #Add legend
       fill = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)))
graphics.off(); 
