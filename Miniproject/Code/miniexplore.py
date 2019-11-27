#!/usr/bin/env python3

"""Exploring miniproject data"""

__appname__ = 'miniexplore.py'

#Some imports to explore the datasets
import pandas as pd
import scipy as sc 
import matplotlib.pylab as pl 
import seaborn as sns #You might need to install this

#What mathematical model best fits an empirical dataset?

data = pd.read_csv("../data/ThermRespData.csv")
print("Loaded {} columns." .format(len(data.columns.values)))
data.head()

print(data.columns.values) 

print(data.OriginalTraitUnit.unique()) #units of the response variable

print(data.ConTempUnit.unique()) #Units of independent variable

print(data.ID.unique()) #units of independent variable

data_subset = data[data['ID']==110]
sns.lmplot("ConTemp", "OriginalTraitValue", data=data_subset, fit_reg=False)
pl.savefig('../results/random.pdf')
pl.close()

new_data = data[['ID', 'StandardisedTraitName', 'OriginalTraitValue', 'StandardisedTraitValue', 'ConTemp', 'Consumer', 'Habitat', 'Location',]]

#This will generate individual plots for each ID
for i, group in data.groupby('ID'):
    p = sns.lmplot(x="ConTemp", y="OriginalTraitValue", data=group, fit_reg=False)
    p.savefig('../results/plots/ThermalRespPlot{0}.pdf'. format(i))
    pl.close()

#Can all IDs be used?








