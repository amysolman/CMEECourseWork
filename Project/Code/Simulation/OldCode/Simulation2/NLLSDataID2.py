#!/usr/bin/env python3
# Date: 11th June 2020

"""Thesis data preparation script"""

__appname__ = 'NLLSDataID2.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk'
__version__ = '0.0.1'

#Data Preparation script

#This script imports the data and prepares it for NLLS fitting
#It creates unique IDs so unique datasets can be identified

import pandas as pd

#Load the data using pandas
data = pd.read_csv("../../Data/SimData/SimModelFitData2.csv")

#Let's get unique ids for each combination of migration rate and number of niches

data.insert(0, "ID", data.migration_rates.map(str) + "_" + data.K_num.map(str))
data.insert(0, "ID2", data.migration_rates.map(str) + "_" + data.K_num.map(str) + "_" + data.K_size.map(str)) 

#These are rather ungainly IDs, can we replaces them with numbers?
data['ID'] = pd.factorize(data.ID)[0] + 1 
data['ID2'] = pd.factorize(data.ID)[0] + 1 

#Save the modified data to a csv file:
data.to_csv('../../Data/SimData/ModData2.csv')
