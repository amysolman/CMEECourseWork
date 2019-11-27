#Data Preparation script

#This script imports the data and prepares it for NLLS fitting
#It creates unique IDs so unique datasets can be identified

import pandas as pd

#Measurements of change in biomass/number of cells of microbes over time

#Load the data using pandas
data = pd.read_csv("../data/LogisticGrowthData.csv")

#Unlike the two previous datasets there are no ID columns, so you will 
#have to infer single growth curves by combining Species, Medium, Temp 
# and Citation columns (ech species-medium-citation combination is unique):

data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)

#These are rather ungainly IDs, can we replaces them with numbers?
data['ID'] = pd.factorize(data.ID)[0] + 1

#data[data.values.sum(axis=1) != 0]
#data[(data.sum(axis=1) != 0.0)]

#Save the modified data to a csv file:
data.to_csv(r'../Data/modified_data.csv')