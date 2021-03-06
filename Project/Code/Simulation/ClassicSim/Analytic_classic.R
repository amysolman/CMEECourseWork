#script to get analytic results of one archipelago 
#from the simulation
rm(list=ls())
graphics.off()

library("ggplot2")

##############################################################
#######################FUNCTION ONE###########################
##############################################################
#define the model function
chisholm_model <- function(area, theta, m0, K, rho) {
  rho = 1
  Js = area*rho
  J_stars = Js/K
  ms = m0 #per capita immigration rate
  gamma_stars = J_stars*ms/(1-ms)
  return(theta*(digamma(theta/K+gamma_stars*(digamma(gamma_stars+J_stars)-digamma(gamma_stars)))-digamma(theta/K)))
}

##############################################################
#######################FUNCTION TWO###########################
##############################################################
get_my_model_species <- function(data){
  model_species <- vector() #vector for storing analytic results
  
  for (i in 1:nrow(data)) {
    island <- data[i, ] 
    area = island$area
    theta = island$theta_true
    K = island$K_true
    m0 = island$m0_true
    model_species[[i]] <- round(chisholm_model(area, theta, m0, K, rho), digits = 2)
  }
  
  return(model_species)
}

##############################################################
##########RUN THE FUNCTIONS AND PLOT RESULTS##################
##############################################################

#Import the data
for (j in 1:10){

data <- read.csv(paste0("../../../Data/SimulationMeansClassic", j, ".csv"))

model_species <- get_my_model_species(data)
analytics <- data.frame(data$area, model_species)

#add analytics to dataframe
data$analytics <- analytics$model_species

#ACrit Estimate
theta = data$theta_true[[1]]
m0 = data$m0_true[[1]]
K = data$K_true[[1]]
rho = 1

ACrit <- (theta*(1-m0)*(exp(K/theta)-1))/(m0*rho*log(1/m0))

#plot simulation and analytic results
eb <- aes(ymax = species + st_error, ymin = species - st_error) #define the limits of the error ribbon
p <- ggplot(data = data, aes(x = area, y = species, colour = "Simulation")) + 
  scale_color_discrete(name="")+ #gets rid of the legend title
  scale_x_log10()+
  ylab("Species Richness")+
  xlab("Log Area")+
  labs(title = "Mean simulation results with standard error ribbon \nand analytic results")+
  geom_line(size = 1) + 
  geom_ribbon(eb, alpha = 0.5, fill="blue") +
  geom_line(data = analytics, aes(x=data.area, y=model_species, colour = "Analytic"), size = 1)+
  geom_vline(xintercept = ACrit, linetype="dotted",
             color = "red", size=1.5)+
  theme_bw()
  
#save as pdf
file_name = paste0("../../../Results/Simulation/AnalyticPlotClassic", j, ".pdf")
pdf(file_name)
print(p)
dev.off()

#save results table
write.csv(data, paste0("../../../Data/MeanAnalyticClassic", j, ".csv"))

}

