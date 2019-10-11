#!/usr/bin/env python3

__appname__ = 'tuple.py'
__version__ = '0.0.1'

"""In shell either run tuple.py (for ipython)
or python3 tuple.py. Script prints bird data on seperate lines by species.""" 

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# Hints: use the "print" command! You can use list comprehensions!

for s in birds:
    print (s[0], s[1], s[2])