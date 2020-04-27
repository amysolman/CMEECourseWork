#!/usr/bin/env python3
# Date: 26th April 2020

"""Thesis data preparation script"""

__appname__ = 'solman_data_prep.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

#Data prepation script

import pandas as pd
import statistics as st 

#import the dataset

mydata = pd.read_csv("../Data/Solman2020/Solman2020_CellCount.csv")

mydata = mydata[~mydata.immigration_rate.str.contains("PBS")]
mydata = mydata[~mydata.immigration_rate.str.contains("Soil Wash")]

#Assign unique IDs to each tube (1, 2 or 3) for each immigration rate.
#This identifys the unique 'islands'.
mydata.insert(0, "ID", mydata.immigration_rate + "_" + mydata.Tube_number.astype(str)) 

#Let's replace the IDs with numbers
mydata['ID'] = pd.factorize(mydata.ID)[0] + 1

#split by data

UniqueDates = mydata.Date.unique() #find the unique dates

#create dataframe dictionary to store dataframes
DataFrameDict = {elem : pd.DataFrame for elem in UniqueDates}

for key in DataFrameDict.keys():
    DataFrameDict[key] = mydata[:][mydata.Date == key]

#define the unique dataframes
Feb27 = DataFrameDict['27-Feb']
Mar05 = DataFrameDict['05-Mar']
Mar12 = DataFrameDict['12-Mar']

#27 FEBRUARY 2020
#define columns for our dataframe and an empty list
cols = ['Date', 'ID', 'Immigration_Rate', 'Mean_Cell_Count']
lst = []

#find the mean cell count of each 'island'
for i in range(1, (len(Feb27.ID.unique())+1)):
    x = Feb27.loc[Feb27['ID'] == i, 'count_cells per ml']
    a = i
    b = Feb27.loc[Feb27['ID'] == i, 'immigration_rate']
    b = b.iloc[0]
    c = st.mean(x)
    lst.append(['Feb27', a, b, c])
Feb27df = pd.DataFrame(lst, columns=cols)

#05 MARCH 2020
#define columns for our dataframe and an empty list
cols = ['Date', 'ID', 'Immigration_Rate', 'Mean_Cell_Count']
lst = []

#find the mean cell count of each 'island'
for i in range(1, (len(Mar05.ID.unique())+1)):
    x = Mar05.loc[Mar05['ID'] == i, 'count_cells per ml']
    a = i
    b = Mar05.loc[Mar05['ID'] == i, 'immigration_rate']
    b = b.iloc[0]
    c = st.mean(x)
    lst.append(['Mar05', a, b, c])
Mar05df = pd.DataFrame(lst, columns=cols)

#define columns for our dataframe and an empty list
cols = ['Date', 'ID', 'Immigration_Rate', 'Mean_Cell_Count']
lst = []

# 12 MARCH 2020
#find the mean cell count of each 'island'
for i in range(1, (len(Mar12.ID.unique())+1)):
    x = Mar12.loc[Mar12['ID'] == i, 'count_cells per ml']
    a = i
    b = Mar12.loc[Mar12['ID'] == i, 'immigration_rate']
    b = b.iloc[0]
    c = st.mean(x)
    lst.append(['Mar12', a, b, c])
Mar12df = pd.DataFrame(lst, columns=cols)


#Save the modified data to csv files:
Feb27df.to_csv('../Data/Solman2020/Modified/Feb27_data.csv')
Mar05df.to_csv('../Data/Solman2020/Modified/Mar05_data.csv')
Mar12df.to_csv('../Data/Solman2020/Modified/Mar12_data.csv')