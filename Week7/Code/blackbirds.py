import re

# Read the file (using a different, more python 3 way, just for fun!)
#with open('../data/blackbirds.txt', 'r') as f:
#    text = f.read()

f = open('../Data/blackbirds.txt', 'r')
blackbirds = f.read()


# replace \t's and \n's with a spaces:
#text = text.replace('\t',' ')
#text = text.replace('\n',' ')
# You may want to make other changes to the text. 

blackbirds = re.sub(r'\t|\n'," ", blackbirds)
print(blackbirds)

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

#text = text.encode('ascii', 'ignore') # first encode into ascii bytes
#text = text.decode('ascii', 'ignore') # Now decode back to string

blackbirds = blackbirds.encode('ascii', errors='ignore').decode('ascii', errors='ignore')


# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (easier!), or a single one (harder!)

#kingdoms = re.findall(r'Kingdom\s+\w+\s+\w+\,\s+\w+\,\s+\w+', blackbirds)
#for kingdom in kingdoms:
#    print(kingdom)
#phylums = re.findall(r'Phylum\s+\w+\s+\w+\,\s+\w+\,\s+\w+', blackbirds)
#for phyla in phylums:
#    print(phyla)
#species = re.findall(r'Species\s+\w+\s+\w+', blackbirds)
#for specie in species:
#    print(specie)


blackbirds_sorted = re.findall(r"Kingdom\s+\w+\s+\w+\,\s+\w+\,\s+\w+|Phylum\s+\w+\s+\w+\,\s+\w+\,\s+\w+|Species\s+\w+\s+\w+", blackbirds)
for birds in blackbirds_sorted:
    print(birds)

