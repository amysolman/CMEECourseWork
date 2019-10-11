#!/usr/bin/env python3

__appname__ = 'dictionary.py'
__version__ = '0.0.1'

"""In shell either run dictionary.py (for ipython)
or python3 dictionary.py. Script will populate a dictionary dervied from taxa,
so that order names are mapped to taxa.""" 

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

taxa_dic = dict()

for s in taxa:
    if s[1] in taxa_dic:
        taxa_dic[s[1]].append(s[0])
    else:
        taxa_dic[s[1]] = [s[0]]
print(taxa_dic)

