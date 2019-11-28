# Amy Solman amy.solman19@imperial.ac.uk
# 20th November 2019
# NLLSfittingscript.R
rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week8/Code")
graphics.off()

#remove unneccesary packages!!!!!

library("minpack.lm")
library("dplyr")
library("data.table")
library("readr")

#Open the (new, modified dataset from previous step)

data <- read.csv('../data/modified_data.csv')

data[data==0] <- NA
data<-data[complete.cases(data$PopBio),]
data <- data[data$PopBio >= 0, ]
data <- data[data$Time >= 0, ]


###############SUBSET THE DATA###############

for (i in 1:(length(unique(data$ID))-1)) { #minus 1 because length = 286, but number of datasets= 285, avoid error
  DataID<-data[which(data$ID==i),]
  print(paste0("Generating results for dataset: ",i))
  ID <- unique(DataID$ID)

DataID$LogN <- log(DataID$PopBio)
DataID$t <- DataID$Time

###########OBTAINING STARTING VALUES###########

try(a <- lm(log(PopBio) ~ t, data = DataID), silent=T) #linear model of DataID_1 data
try(a<-summary(a)$coefficients, silent=T) #store DataID_1 coefficients in a_s
new_data<-DataID[-which(DataID$t > (max(DataID$t)*.95)),] #new_data reduced DataID_1 by 5%

repeat {
  
  if(length(new_data$t) < (length(DataID$t)/10)) {break} #break if the number of values for t in new data is less than 
  b <- lm(log(PopBio) ~ t, data = new_data) #run second linear model with new_data
  b <- summary(b)$coefficients  #store coefficients second linear model in b_s
  a <- b # assign second linear model to a_s
  new_data<-new_data[-which(new_data$t > (max(new_data$t)*.95)),] #reduce the new_data by 5%
  
}

#The slope
if (nrow(a) > 1){
r_max_start <- a[2,1]
} else {
  r_max_start <- 0.1
}


# - Calculates a starting value of t_lag by intersecting the fitted line with the x(time)-axis
l <- a[1,1]
t_lag_start <- -l/r_max_start

N_0_start <- min(DataID$LogN) # Initial cell culture (Population) density (number of cells per unit volume)
N_max_start <- max(DataID$LogN) #Maximum culture density (aka "carrying capacity")

###############DEFINE MODEL NLLS MODEL FUNCTIONS###############

#Here's the function for the Gompterz model
gompertz_model <- function(t, r_max, N_max, N_0, t_lag){ # Modified gompertz growth model
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1)))
}

baranyi_model <- function(t, r_max, N_max, N_0, t_lag){ #Baryani model
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}

buchanan_model <- function(t, r_max, N_max, N_0, t_lag){ # Buchanan model - three phase logistic (Buchanan 1997)
  return(N_0 + (t >= t_lag) * (t <= (t_lag + (N_max - N_0) * log(10)/r_max)) * r_max * (t - t_lag)/log(10) +
           (t >= t_lag) * (t > (t_lag + (N_max - N_0) * log(10)/r_max)) * (N_max - N_0))
}  

###############FIT THE FIVE MODELS###############

fit_gompertz <- try(nlsLM(LogN ~ gompertz_model(t = t, r_max, N_max, N_0, t_lag), DataID,
                          list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, N_max = N_max_start)), silent=T)

fit_baranyi <- try(nlsLM(LogN ~ baranyi_model(t = t, r_max, N_max, N_0, t_lag), DataID,
                     list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start)), silent=T)

fit_buchanan <- try(nlsLM(LogN ~ buchanan_model(t = t, r_max, N_max, N_0, t_lag), DataID,
                      list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, N_max = N_max_start)), silent=T)


#We can also fit a quadratic curve:

fit_quad <- try(lm(LogN ~ poly(t, 2), data = DataID), silent=T)

#And a polynomial curve:

fit_poly <- try(lm(LogN ~ poly(t, 3), data = DataID), silent=T)

#And a linear model:

fit_lin <- try(lm(LogN ~ t, data = DataID))

#TIMEPOINTS FOR CREATING PREDICTED DATA

timepoints <- seq(0, max(DataID$t), 0.5)

################STATISTICAL MEASURES###############

#Calculate AIC, BIC, R$^{2}$, and other statistical measures of model fit (you decide what you want to include)

if(class(fit_gompertz) !="try-error"){
  RSS_Gom <- sum(residuals(fit_gompertz)^2) #Residual sum of squares of our NLLS model
  TSS_Gom <- sum((DataID$LogN - mean(DataID$LogN))^2) #Total sum of squares 
  RSq_Gom <- 1 - (RSS_Gom/TSS_Gom)
  AIC_Gom <- AIC(fit_gompertz)
  BIC_Gom <- BIC(fit_gompertz)
  df_Gom_stats <- data.frame(RSq_Gom, AIC_Gom, BIC_Gom, ID)
  df_Gom_stats$Model <- "Gompertz"
  names(df_Gom_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  gompertz_points <- gompertz_model(t = timepoints, r_max = coef(fit_gompertz)["r_max"], N_max = coef(fit_gompertz)["N_max"], 
                                    N_0 = coef(fit_gompertz)["N_0"], t_lag = coef(fit_gompertz)["t_lag"])
  df_Gom_points <- data.frame(ID, timepoints, gompertz_points)
  df_Gom_points$Model <- "Gompertz"
  names(df_Gom_points) <- c("ID", "t", "LogN", "Model")
  
} else {
  df_Gom_stats <- data.frame(RSq_Gom = NA, AIC_Gom = NA, BIC_Gom = NA,ID = ID, Model = "Gompertz")
  names(df_Gom_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  df_Gom_points <- data.frame(ID, timepoints = NA, gompertz_points = NA)
  df_Gom_points$Model <- "Gompertz"
  names(df_Gom_points) <- c("ID", "t", "LogN", "Model")
}

if(class(fit_baranyi) !="try-error"){
  RSS_Bar <- sum(residuals(fit_baranyi)^2) #Residual sum of squares of our NLLS model
  TSS_Bar <- sum((DataID$LogN - mean(DataID$LogN))^2) #Total sum of squares 
  RSq_Bar <- 1 - (RSS_Bar/TSS_Bar)
  AIC_Bar <- AIC(fit_baranyi)
  BIC_Bar <- BIC(fit_baranyi)
  df_Bar_stats <- data.frame(RSq_Bar, AIC_Bar, BIC_Bar, ID)
  df_Bar_stats$Model <- "Baranyi"
  names(df_Bar_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  baranyi_points <- baranyi_model(t = timepoints, r_max = coef(fit_baranyi)["r_max"], N_max = coef(fit_baranyi)["N_max"], 
                                  N_0 = coef(fit_baranyi)["N_0"], t_lag = coef(fit_baranyi)["t_lag"])
  df_Bar_points <- data.frame(ID, timepoints, baranyi_points)
  df_Bar_points$Model <- "Baranyi"
  names(df_Bar_points) <- c("ID", "t", "LogN", "Model")
  
} else {
  df_Bar_stats <- data.frame(RSq_Bar = NA, AIC_Bar = NA, BIC_Bar = NA, ID = ID, Model = "Baranyi")
  names(df_Bar_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  df_Bar_points <- data.frame(ID, timepoints = NA, baranyi_points = NA)
  df_Bar_points$Model <- "Baranyi"
  names(df_Bar_points) <- c("ID", "t", "LogN", "Model")
}

if(class(fit_buchanan) !="try-error"){
  RSS_Buc <- sum(residuals(fit_buchanan)^2) #Residual sum of squares of our NLLS model
  TSS_Buc <- sum((DataID$LogN - mean(DataID$LogN))^2) #Total sum of squares 
  RSq_Buc <- 1 - (RSS_Buc/TSS_Buc)
  AIC_Buc <- AIC(fit_buchanan)
  BIC_Buc <- BIC(fit_buchanan)
  df_Buc_stats <- data.frame(RSq_Buc, AIC_Buc, BIC_Buc, ID)
  df_Buc_stats$Model <- "Buchanan"
  names(df_Buc_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  buchanan_points <- buchanan_model(t = timepoints, r_max = coef(fit_buchanan)["r_max"], N_max = coef(fit_buchanan)["N_max"], 
                                    N_0 = coef(fit_buchanan)["N_0"], t_lag = coef(fit_buchanan)["t_lag"])
  df_Buc_points <- data.frame(ID, timepoints, buchanan_points)
  df_Buc_points$Model <- "Buchanan"
  names(df_Buc_points) <- c("ID", "t", "LogN", "Model")
  
} else {
  df_Buc_stats <- data.frame(RSq_Buc = NA, AIC_Buc = NA, BIC_Buc = NA, ID = ID, Model = "Buchanan")
  names(df_Buc_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  df_Buc_points <- data.frame(ID, timepoints = NA, buchanan_points = NA)
  df_Buc_points$Model <- "Buchanan"
  names(df_Buc_points) <- c("ID", "t", "LogN", "Model")
}

if(class(fit_quad) !="try-error"){
  RSS_Qua <- sum(residuals(fit_quad)^2) #Residual sum of squares of our NLLS model
  TSS_Qua <- sum((DataID$LogN - mean(DataID$LogN))^2) #Total sum of squares 
  RSq_Qua <- 1 - (RSS_Qua/TSS_Qua)
  AIC_Qua <- AIC(fit_quad)
  BIC_Qua <- BIC(fit_quad)
  df_Qua_stats <- data.frame(RSq_Qua, AIC_Qua, BIC_Qua, ID)
  df_Qua_stats$Model <- "Quadratic"
  names(df_Qua_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  quadratic_points <- predict.lm(fit_quad, data.frame(t = timepoints))
  df_Qua_points <- data.frame(ID, timepoints, quadratic_points)
  df_Qua_points$Model <- "Quadratic"
  names(df_Qua_points) <- c("ID", "t", "LogN", "Model")
  
} else {
  df_Qua_stats <- data.frame(RSq_Qua = NA, AIC_Qua = NA, BIC_Qua = NA, ID = ID, Model = "Quadratic")
  names(df_Qua_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  df_Qua_points <- data.frame(ID, timepoints = NA, quadratic_points = NA)
  df_Qua_points$Model <- "Quadratic"
  names(df_Qua_points) <- c("ID", "t", "LogN", "Model")
}

if(class(fit_poly) !="try-error"){
  RSS_Pol <- sum(residuals(fit_poly)^2) #Residual sum of squares of our NLLS model
  TSS_Pol <- sum((DataID$LogN - mean(DataID$LogN))^2) #Total sum of squares 
  RSq_Pol <- 1 - (RSS_Pol/TSS_Pol)
  AIC_Pol <- AIC(fit_poly)
  BIC_Pol <- BIC(fit_poly)
  df_Pol_stats <- data.frame(RSq_Pol, AIC_Pol, BIC_Pol, ID)
  df_Pol_stats$Model <- "Polynomial"
  names(df_Pol_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  poly_points <- predict.lm(fit_poly, data.frame(t = timepoints))
  df_Pol_points <- data.frame(ID, timepoints, poly_points)
  df_Pol_points$Model <- "Polynomial"
  names(df_Pol_points) <- c("ID", "t", "LogN", "Model")
  
} else {
  df_Pol_stats <- data.frame(RSq_Pol = NA, AIC_Pol = NA, BIC_Pol = NA, ID = ID, Model = "Polynomial")
  names(df_Pol_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  df_Pol_points <- data.frame(ID, timepoints = NA, poly_points = NA)
  df_Pol_points$Model <- "Polynomial"
  names(df_Pol_points) <- c("ID", "t", "LogN", "Model")
}

if(class(fit_lin) !="try-error"){
  RSS_Lin <- sum(residuals(fit_lin)^2) #Residual sum of squares of our NLLS model
  TSS_Lin <- sum((DataID$LogN - mean(DataID$LogN))^2) #Total sum of squares 
  RSq_Lin <- 1 - (RSS_Lin/TSS_Lin)
  AIC_Lin <- AIC(fit_lin)
  BIC_Lin <- BIC(fit_lin)
  df_Lin_stats <- data.frame(RSq_Lin, AIC_Lin, BIC_Lin, ID)
  df_Lin_stats$Model <- "Linear"
  names(df_Lin_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  linear_points <- predict.lm(fit_lin, data.frame(t=timepoints))
  df_Lin_points <- data.frame(ID, timepoints, linear_points)
  df_Lin_points$Model <- "Linear"
  names(df_Lin_points) <- c("ID", "t", "LogN", "Model")
  
} else {
  df_Lin_stats <- data.frame(RSq_Lin = NA, AIC_Lin = NA, BIC_Lin = NA, ID = ID, Model = "Linear")
  names(df_Lin_stats) <- c("R-Squared", "AIC Score", "BIC Score", "ID", "Model")
  
  df_Lin_points <- data.frame(ID, timepoints = NA, linear_points = NA)
  df_Lin_points$Model <- "Linear"
  names(df_Lin_points) <- c("ID", "t", "LogN", "Model")
}

#Bind results as dataframe

stats_results <- rbind(df_Gom_stats, df_Bar_stats, df_Buc_stats, df_Qua_stats, df_Pol_stats, df_Lin_stats)
plot_results <- rbind(df_Gom_points, df_Bar_points, df_Buc_points, df_Qua_points, df_Pol_points, df_Lin_points)

###############EXPORT RESULTS TO CSV FILE###############

write.csv(stats_results, paste0("../results/stats_results_",i,".csv"))

write.csv(plot_results, paste0("../results/plot_results_",i,".csv"))


}

stats_results <- list.files(path = "../results/", pattern=glob2rx("stats*.csv"), full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows 

plot_results <- list.files(path = "../results/", pattern=glob2rx("plot*.csv"), full.names = TRUE) %>%
  lapply(read_csv) %>%
  bind_rows

write.csv(stats_results, ("../results/total_stats_results.csv"))
write.csv(plot_results, ("../results/total_plot_results.csv"))
