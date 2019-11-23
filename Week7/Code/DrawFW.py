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

f1 = p.figure()
nx.draw_networkx (G, pos, node_size = NodSizs)

f1.savefig('../results/FW.pdf')



