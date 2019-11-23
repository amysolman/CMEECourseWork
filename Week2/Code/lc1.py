#!/usr/bin/env python3
# Date: Oct 2019

__appname__ = 'Ic1.py'
__version__ = '0.0.1'

"""In shell either run lc1.py (for ipython)
or python3 lc1.py. Script will contains six modules creating different
lists from the bird data provided. Created using list comprehension and
loops.""" 

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# List comprehension containing birds latin names

birds_latin = {b[0] for b in birds}
print(birds_latin)

# List comprehension containing birds common names

birds_common = {b[1] for b in birds}
print(birds_common)

# List comprehension containing mean body masses

birds_bodymass = {b[2] for b in birds}
print(birds_bodymass)


# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

# Conventional loop printing birds latin names

birds_latin = []
for b in birds:
    birds_latin.append(b[0])
print(birds_latin)

# Conventional loop printing birds common names

birds_common = []
for b in birds:
    birds_common.append(b[1])
print(birds_common)

# Conventional loop printing birds mean body mass

birds_bodymass = []
for b in birds:
    birds_bodymass.append(b[2])
print(birds_bodymass)