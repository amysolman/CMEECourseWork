#Diagrams for my report

rm(list=ls())
graphics.off()

library(ggplot2)

#Colonisation-Extinction Dynamic Equilibrium

Species <- seq(1, 1000, 5)
Col <- Species^2
Ext <- rev(Col)
Species <- c(Species, Species)
Event <- c(Col, Ext)
Name <- c(rep("Colonisation", 200), rep("Extinction", 200))
df <- data.frame(Species, Event, Name)

#ggplot equally spaced hues function
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}

#get my colours for plotting
n = 3
cols = gg_color_hue(n)
p1 <- ggplot() + 
  geom_point(data = df, aes(x = Species, y = Event, colour=Name))+
  #scale_colour_manual(values=c("darkorchid2", "deeppink2"))+
  scale_colour_manual(values=cols)+
  geom_vline(xintercept = 500, linetype="dotted", color = "blue", size=2)+
  ylab("Rate of change")+
  theme(legend.position = "none", 
        #panel.grid = element_blank(), 
       #axis.title.y = element_blank(), 
       axis.title.y = element_text(size = 16),
        #axis.text.x=element_blank(),
       panel.background = element_blank(), 
       axis.title.x = element_text(size = 16))+
  annotate("text", x = 170, y = 400000, label = "Extinction Rate", size=6, colour=cols[2])+
  annotate("text", x = 850, y = 400000, label = "Colonisation Rate", size=6, colour=cols[1])+
  annotate("text", x = 350, y = 900000, label = "Equilibrium", size=6, colour=cols[3])+
  scale_y_discrete(breaks=NULL)+
  scale_x_discrete(breaks=NULL)+
  theme(axis.line.x = element_line(color="black", size = 2),
        axis.line.y = element_line(color="black", size = 2))


pdf("ColonisationDynamicEquilibrium.pdf")
print(p1)
dev.off()


#######Simulation to generate graphics data

source("../../Code/Simulation/GraphicsSim.R")

i = 1
set.seed(i)

cluster_run_function(J_meta=1000, nu = 0.5, m0 = 0.03, num_islands = 3, k = 4, wall_time = 10, output_file_name = "m01.rda")
cluster_run_function(J_meta=1000, nu = 0.5, m0 = 0.9, num_islands = 3, k = 4, wall_time = 10, output_file_name = "m02.rda")

load(file="m01.rda")
sim1 <- store_my_islands

load(file="m02.rda")
sim2 <- store_my_islands

timeseries_richness <- function(focal_island) {

  species_richness <- list()

  for (n in 1:length(focal_island)) { #for each niche in the focal island
    x <- focal_island[[n]]$Niche #give the niche community to x
    niche_unique <- length(unique(x)) #the number of unique species in the niche
    species_richness[[n]] <- niche_unique

  }

  unique_sp <- sum(unlist(species_richness))

  return(unique_sp) #give number of unique species across entire island
}

# # create a dataset
# get_my_df <- function(simulation){
# Island <- c(rep("4 Units" , 4) , rep("16 Units" , 4) , rep("36 Units" , 4))
# Niche <- rep(c("NicheOne" , "NicheTwo" , "NicheThree", "NicheFour") , 3)
# my_sim1 <- simulation
# Species <- c(length(unique(my_sim1[[1]][[1]][[1]]$Niche)), length(unique(my_sim1[[1]][[1]][[2]]$Niche)),
#             length(unique(my_sim1[[1]][[1]][[3]]$Niche)), length(unique(my_sim1[[1]][[1]][[4]]$Niche)),
#             length(unique(my_sim1[[2]][[1]][[1]]$Niche)), length(unique(my_sim1[[2]][[1]][[2]]$Niche)),
#             length(unique(my_sim1[[2]][[1]][[3]]$Niche)), length(unique(my_sim1[[2]][[1]][[4]]$Niche)),
#             length(unique(my_sim1[[3]][[1]][[1]]$Niche)), length(unique(my_sim1[[3]][[1]][[2]]$Niche)),
#             length(unique(my_sim1[[3]][[1]][[3]]$Niche)), length(unique(my_sim1[[3]][[1]][[4]]$Niche)))
# data <- data.frame(Island,Niche,Species)
# 
# data <- within(data, Island <- factor(Island, levels=names(sort(table(Island), decreasing=FALSE))))
# 
# return(data)
# }
# 
# #####################################################################################
# load(file="m0002.rda")
# sim1 <- store_my_islands
# my_data <- get_my_df(simulation = sim1)
# 
# p1 <- ggplot(my_data, aes(fill=Niche, y=Species, x=Island)) + 
#   geom_bar(position="stack", stat="identity") +
#   annotate("text", x = 3, y = 6, label = "m0 = 1", size=6, colour="blue")+
#   theme_bw()
# 
# #####################################################################################
# load(file="m0004.rda")
# sim2 <- store_my_islands
# my_data <- get_my_df(simulation = sim2)
# 
# p2 <- ggplot(my_data, aes(fill=Niche, y=Species, x=Island)) + 
#   geom_bar(position="stack", stat="identity") +
#   annotate("text", x = 3, y = 6, label = "m0 = 2", size=6, colour="blue")+
#   theme_bw()
# 
# 
# #####################################################################################
# 
# load(file="m0006.rda")
# 
# sim3 <- store_my_islands
# my_data <- get_my_df(simulation = sim3)
# 
# p3 <- ggplot(my_data, aes(fill=Niche, y=Species, x=Island)) + 
#   geom_bar(position="stack", stat="identity") +
#   annotate("text", x = 3, y = 6, label = "m0 = 3", size=6, colour="blue")+
#   theme_bw()
# 
# 
# #####################################################################################
# load(file="m0008.rda")
# sim4 <- store_my_islands
# 
# my_data <- get_my_df(simulation = sim4)
# 
# p4 <- ggplot(my_data, aes(fill=Niche, y=Species, x=Island)) + 
#   geom_bar(position="stack", stat="identity") +
#   annotate("text", x = 3, y = 6, label = "m0 = 4", size=6, colour="blue")+
#   theme_bw()
# 
# 
# #####################################################################################
