#!/usr/bin/env python3
#Date: 27th April 2020

"""csv binding script"""

__appname__ = 'solman_data_prep.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import pandas as pd

data = pd.read_csv("../Results/Stats_Results/TotalResults.csv")
data = data.assign(Type='NoLog')

LogArea = pd.read_csv("../Results/Stats_Results/LogAreaTotalResults.csv")
LogArea = LogArea.assign(Type='LogArea')

LogAreaSpecies = pd.read_csv("../Results/Stats_Results/LogAreaSpeciesTotalResults.csv")
LogAreaSpecies = LogAreaSpecies.assign(Type='LogAreaSpecies')

dataSolman = pd.read_csv("../Results/Stats_Results/TotalResultsSolman.csv")
dataSolman = dataSolman.assign(Type='NoLog')

LogAreaSolman = pd.read_csv("../Results/Stats_Results/LogAreaTotalResultsSolman.csv")
LogAreaSolman = LogAreaSolman.assign(Type='LogArea')

LogAreaSpeciesSolman = pd.read_csv("../Results/Stats_Results/LogAreaSpeciesTotalResultsSolman.csv")
LogAreaSpeciesSolman = LogAreaSpeciesSolman.assign(Type='LogAreaSpecies')

total = [data, LogArea, LogAreaSpecies, dataSolman, LogAreaSolman, LogAreaSpeciesSolman]
result = pd.concat(total)

result = result.sort_values(by=['Author', 'Type'])
df = result.loc[:, ~result.columns.str.contains('^Unnamed')] #remove unnamed collumn

df.to_csv('../Results/Stats_Results/FinalResults.csv')