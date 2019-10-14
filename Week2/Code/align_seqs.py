#!/usr/bin/env python3

"""Script to take two DNA sequences from csv file, align, score and output to txt file"""

__appname__ = 'align_seqs.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk)'
__version__ = '0.0.1'

import csv

f = open('../code/align_seq_data.csv', 'r')

csvread = csv.reader(f)
seq2 = ""
seq1 = ""
for row in csvread:
    seq2 = (row[0])
    seq1 = (row[1])

l1 = len(seq1) # l1 variable is assigned the length of sequence 1
l2 = len(seq2) # l2 variable is assigned the length of sequence 2
if l1 >= l2: # if l1 is greater than or equal to l2
    s1 = seq1 # assign the longest variable (s1) to sequence 1
    s2 = seq2 # assign the shorted variable (s2) to sequence 2
else:
    s1 = seq2 # assign the longest variable (s1) to sequence 2
    s2 = seq1 # assign the shorted variable (s2) to sequence 1
    l1, l2 = l2, l1 # swap the two length values
#seq1 was linked to l1, seq2 was linked to l2.
#if length of seq1 >= seq2 then seq1 string applied to s1
#if length of seq1 >= seq2 then seq2 string applied to s2
#if length of seq1 < seq2 then seq1 string applied to s2 and l1 takes on length of l2
#if length of seq1 < seq2 then seq2 string applied to s1 and l2 takes on length of l1

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint): 
    matched = "" # to hold string displaying alignements
    score = 0 # set score value to 0
    for i in range(l2): # for item in the range of 0 to length2 (shorter length)
        if (i + startpoint) < l1: 
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

f = open('../code/align_seq_result.txt', 'w')
print(my_best_align, s1, my_best_score, file=f)

f.close()