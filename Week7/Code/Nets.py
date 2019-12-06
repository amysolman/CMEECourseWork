#!/usr/bin/env python3
# Date: 3rd December 2019

"""Network visualisation script converted from R to python.
Visualises the QMEE CDT collaboration network"""

__appname__ = 'Nets.py'
__author__ = 'Amy Solman (amy.solman19@imperial.ac.uk'
__version__ = '0.0.1'

#library(igraph) # Load the igraph package
import networkx as nx
import pandas as pd
import scipy as sc
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

#Import CSV files
links = pd.read_csv('../data/QMEE_Net_Mat_edges.csv')
nodes = pd.read_csv('../data/QMEE_Net_Mat_nodes.csv')

links_new = links.rename(index={0:'ICL', 1:'UoR', 2:'CEH', 3:'ZSL', 4:'CEFAS', 5:'NonAc'} ) 

#A = nx.DiGraph(links_new.values, with_labels = True)
#nx.draw(A)

edges = links_new.stack().reset_index()
#remove 0s
edges = edges[edges.iloc[:,2] != 0]
#remove third column
del edges[0]
#make into array
AdjL = sc.array(edges)
AdjL
#Get unique nodes names
Sps = sc.unique(AdjL)
#LEt's use a circular confirguration. 
#For this we need to calculate the coordiantes:
pos = nx.circular_layout(Sps)
G = nx.DiGraph()
G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))
NodSize = 10000
f1 = plt.figure()
nx.draw_networkx(G, pos, nodesize = NodSize, nodelist=['CEH', 'ZSL', 'CEFAS'], node_color='lawngreen', arrows=True)
nx.draw_networkx(G, pos, nodesize = NodSize, nodelist=['UoR', 'ICL'], node_color='dodgerblue', arrows=True)
nx.draw_networkx(G, pos, nodesize = NodSize, nodelist=['NonAc'], node_color='r', arrows=True)
green_patch = mpatches.Patch(color='lawngreen', label = 'Hosting Partner')
blue_patch = mpatches.Patch(color='dodgerblue', label = 'University')
red_patch = mpatches.Patch(color='r', label = 'Non-Hosting Partner')
plt.legend(handles=[green_patch, red_patch, blue_patch], loc='upper left')
f1.savefig('../results/QMEENet.svg')