#!/usr/bin/env python3
# Date: 11th November 2019

"""Script for timing functions"""

__appname__ = 'timeitme.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk'
__version__ = '0.0.1'
###########################################################
# loops vs. list comprehension: which is faster?
###########################################################

iters = 1000000

import timeit #import the timeit module

from profileme import my_squares as my_squares_loops #from our first script import the slower module
from profileme2 import my_squares as my_squares_lc #from our second script import the faster module

# %timeit my_squares_loops(iters)
# %timeit my_squares_lc(iters)

###########################################################
# loops vs. the join method for strings: which is faster?
###########################################################

mystring = "my string"

from profileme import my_join as my_join_join
from profileme2 import my_join as my_join 

# %timeit(my_join_join(iters, mystring))
# %timeit(my_join(iters, mystring))

