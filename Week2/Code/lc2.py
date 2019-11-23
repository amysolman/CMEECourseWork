#!/usr/bin/env python3
# Date: Oct 2019

__appname__ = 'Ic2.py'
__version__ = '0.0.1'

"""In shell either run lc2.py (for ipython)
or python3 lc2.py. Script contains four modules. First two use list
comprehension to pull high and low rainfall data.
Second two modules serve the same function but using conventional loops.""" 

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

high_rainfall = [r for r in rainfall if r[1] > 100.0]
print(high_rainfall)
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

low_rainfall = [m[0] for m in rainfall if m[1] < 50.0]
print(low_rainfall)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

high_rainfall = []
for row in rainfall:
    if row[1] > 100.0:
        high_rainfall.append(row)

print(high_rainfall)

low_rainfall = []
for row in rainfall:
    if row[1] < 50.0:
        low_rainfall.append(row[0])
        
print(low_rainfall)