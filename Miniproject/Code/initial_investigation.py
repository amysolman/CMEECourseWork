#########Python using Population Growth Data#########

#Some imports to explore the datasets
import pandas as pd
import scipy as sc 
import matplotlib.pylab as pl 
import seaborn as sns #You might need to install this
import numpy


#Measurements of change in biomass/number of cells of microbes over time

#Load the data using pandas
data = pd.read_csv("../data/LogisticGrowthData.csv")

#Print the number of data columns
print("Loaded {} columns.".format(len(data.columns.values)))

#Print the data columns
print(data.columns.values)

#Show the contents of LogisticGrowthMetaData file with pandas
#This gives us explicit description of each column value
pd.read_csv("../data/LogisticGrowthMetaData.csv")

#Print the first 5 rows
data.head()

#Print the unique units of the response variable (PopBio_units)
print(data.PopBio_units.unique())

#Print the unique units of the independent variable (Time_units)
print(data.Time_units.unique())

#Unlike the two previous datasets there are no ID columns, so you will 
#have to infer single growth curves by combining Species, Medium, Temp 
# and Citation columns (ech species-medium-citation combination is unique):

data.insert(0, "ID", data.Species + "_" + data.Temp.map(str) + "_" + data.Medium + "_" + data.Citation)

#Note that the map() method converts temperature values to string (str) for concatenation

print(data.ID.unique())

#These are rather ungainly IDs, can we replaces them with numbers?

data['ID'] = pd.factorize(data.ID)[0] + 1

#Here we are creating a subset of the data for the first ID...
data_subset = data[data['ID']==1]
data_subset.head()

#Now let's plot this subset of data
sns.lmplot("Time", "PopBio", data = data_subset, fit_reg = False) #Will give a warning - you can ignore it

#The simplest mathematical models you can use are phenomenological quadratic 
# and cubic polynomial models. A polynomial model may be able to capture decline in pop size
#after some maximum value (the carrying capacity) has been reached
#(the death phase of population growth).

#Quadratic model
# y = ax^2 + bx + c 

#Cubic polynomial model
# y = ax^3 + bx^2 + cx + d