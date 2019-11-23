import pandas as pd
import scipy as sc 

#PANDAS dataframes

MyDF = pd.read_csv('../data/testcsv.csv', sep=',')
MyDF

#Creating dataframes
#You can also create dataframes using a python dictionary like syntax:

MyDF = pd.DataFrame({
    'col1': ['Var1', 'Var2', 'Var3', 'Var4'],
    'col2': ['Grass', 'Rabbit', 'Fox', 'Wolf'],
    'col3': [1, 2, sc.nan, 4]
})
MyDF 

#EXAMINING YOUR DATA
#Displays the top 5 rows. Accepts an optional int parameter - num. of rows to show
MyDF.head()
