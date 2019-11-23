#Networks in Python

#ALL biological systems have a network representation, 
#consisting of nodes fro the biological entities of interest,
#and edges or links for the relationships between them. 
#Here are some examples:
#Metabolic networks
#Gene regulatory networks
#Individual-individual (e.g. social networks)
#Who-eats-whom (Food web) networks
#Mutualistic (e.g. plant-polinator) networks

#You can easily simulate, analyze and visualize biological networks
#in both python and R using some nifty packages. A full network analysis tutorial
#is out of scope of our Python module's objectives,
#but let's try a simple visualization using the networkx Python pakcage.

#Food web network example
#As an example, let's plot a food web network.
#The best was to store a food web dataset is as an "adjacency list"
#of who eats whom: a matrix with consumer name/id in 1st column
#and resource name/id in second column, and a seperate matrix of species names/ids
#and properties such as biomass (node's abundance), or average body mass.
#You will see what these data structures look like below.
#First import the necessary modules:

import networkx as nx
import scipy as sc 
import matplotlib.pylab as p 

#Let's generate a synthetic food web. We can do this with the following function that generates
#a random adjacency list of a N-species food web with connectance probability C:
#the probability of having a linkbetween any pair of species in the food web.

def GenRdmAdjList(N= 2, C = 0.5):
    """
    """
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0, 1, 1) < C:
            Lnk = sc.random.choice(Ids,2).tolist()
            if Lnk[0] != Lnk: #avoid self (e.g. cannibalistic) loops
                ALst.append(Lnk)
    return ALst

#Note that we are using a uniform random distribution between [0,1]
#to generate a connectance probability between each species pair.

#Now assign number of species (MaxN) and connectance (C):

MaxN = 30
C = 0.75

#Now generate an adjacency list representing a random food web:
AdjL = sc.array(GenRdmAdjList(MaxN, C))
AdjL

#So that's what an adjacency list looks like. The two columns of numbers correspond to the 
#consumer and resource ids, respectively.
#Now generate species (node) data:

Sps = sc.unique(AdjL) #get species ids

#Now generate body sizes for the species. We will use a log10 scale because species body
#sizes tend to be log-normally distributed.

SizRan = ([-10,10]) #use log10 scale
Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN)
Sizs

#Let's visualize the size distribution we have generated.

p.hist(Sizs) #log10 scale

p.hist(10 ** Sizs) #raw scale

#Let's now plot the network, with node sizes proportional to (log) body size.

p.close('all') #close all open plot objects

#Let's use a circular configuration. For this, we need to calculate the coordinates,
#easily done using networkx:

pos = nx.circular_layout(Sps)

#See networkx.layout for inbuilt functions to compute other types of node coordinates.
#Now generate a networkx graph object:

G = nx.Graph()

#Now add the nodes and links (edges) to it:

G.add_nodes_from(Sps)
G.add_edges_from(tuple(AdjL))

#Note that the function add_edges_from needs the adjacency list as a tuple.
#Now generate node sizes that are proportional to (log) body sizes:

NodSizs = 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs))

#Now render (plot) the graph:

nx.draw_networkx (G, pos, node_size = NodSizs)
