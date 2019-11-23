##!/usr/bin/env python3

#############################
# STORING OBJECTS
#############################

__appname__ = 'basic_io3.py'
__version__ = '0.0.1'

""" In shell either run basic_io3.py (for ipython)
or python3 basic_io3.py. Script will create a dictionary and
save it to testp.p then load the data again and save to another_dictionary
then print. """

# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

# pickle module implements binary protocols for serializing/
# de-serializing an object structure. 
# Converts an object in memory to a byte stream than can be stored or sent over network.
import pickle

f = open('../sandbox/testp.p', 'wb') ## note the b: accept binary files
pickle.dump(my_dictionary, f) #put the binary version of my dictionary into the file
f.close()

## Load the data again
f = open('../sandbox/testp.p', 'rb')
another_dictionary = pickle.load(f) #load the binary data from the file into another_dictionary
f.close()

print(another_dictionary)