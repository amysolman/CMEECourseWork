#Numerical computing in Python

#The Python package scipy allows you to do serious number crunching, including:
#Linear algebra (matrix and vector operations) using scipy.linalg
#Sparse Eigenvalue Problems using scipy.sparse
#Numerical integration (including solving of Ordinary Differential Equations (ODEs)) using scipy.integrate
#Random number generation and using statistical functions and transformations using scipy.stats
#Optimization using scipy.optimise
#Signal Processing using scipy.signal

#In the following, we will use the numpy array data structure for data manipulations and calculations. 
#These arrays are similar in some respects to Python lists, but are homogeneous in type (the default is float),
#allow efficient (fast) manipulations, and are more naturally multidimensional
#(e.g you cans store multiple matrices in one array). Thus numpy arrays are analogous to the R matrix
#data object/structure

#We will use the scipy package, which includes numpy, and a lot more. Let's try it:

import scipy as sc 
a = sc.array(range(5)) #a one dimensional array
a

print(type(a))
print(type(a[0]))

#The last two outputs tell you that firstly, the numpy arrays belong to a data structure type (and a class)
#called numpy.ndarry, and secondly, that at position 0 (remeber python indexing starts at 0) it holds an
#64 bit integer. All elements in a are of type int because that is what range() returns (try ?range).
#You can also specify the data type of the array:
a = sc.array(range(5), float)
a
a.dtype # Check type

#You can also get a 1D array as follows:
x = sc.arange(5)
x
x = sc.arange(5.) #directly specify float using decimal
x
#As with other Python variables (e.g. created as a list or a dictionary), you can apply
#methods to variables created as numpy arrays.
#For example, type x. and hit TAB to see all methods you can apply to x.
#To see dimensions of x:
x.shape
#Remember you can type :?x.methodname to get into on a particular methods.
#For example, try ?x.shape
#You can also convert to and from Python lists
b = sc.array([i for i in range(10) if i % 2 == 1]) #odd numbers between 1 and 10
b
c = b.tolist() #convert back to list
c
#to make a matrix you need a 2D numpy array:
mat = sc.array([[0,1], [2,3]])
mat
mat.shape

#INDEXING AND ACCESSING ARRAYS
#As with other Python data objects such as lists, numpy array elements can be accessed
#using square brackets [ ] with the usual [row, column] reference. Indexing of numpy arrays
#works like that for other data structures, with index values starting at 0.
#So, you can obtain all the elements of a particular row as:
mat[1] # accesseding whole second row, remember indexing starts at 0
mat[:,1] # accessing whole second column
#And accessing particular elements:
mat[0, 0] #1st row, 1st column element
mat[1, 0] #2nd row, 1st column element
#Note that (like all other programming languages) row index always comes before column index.
#That is, mat[1] is always going to mean "whole second row", and mat [1,1] means second row
#and second column element.
mat[1, 1]
#Therefore, to access the whole second column, you need:
mat[:, 1]
#Python indexing also accepts negative values for going back to the start from the end of an array:
mat[0, 1]
mat[0, -1]
mat[-1, 0]
mat[0,-2]

#MANIPULATING ARRAYS
#Replacing, adding or deleting elements
#Let's look at how you can replace, add or delete an array element
#(a single entry, or whole row(s) or whole column(s))
mat[0,0] = -1 #replace a single element
mat
mat[:,0] = [12,12] #replaces the whole 1st column
mat
sc.append(mat, [[12,12]], axis = 0) #append row, note axis specification
sc.append(mat, [[12],[12]], axis = 1) #append column, note axis specification
newRow = [[12,12]] #create new row
mat = sc.append(mat, newRow, axis = 0) #append that existing row
mat
sc.delete(mat, 2, 0) #Delete third row
#And concatenation
mat = sc.array([[0, 1], [2,3]])
mat0 = sc.array([[0, 10], [-1, 3]])
sc.concatenate((mat, mat0), axis = 0)

#Flattening or reshaping arrays
#You can also "flatten" or "melt" arrays, that is, change array dimensions (e.g. from a matrix to a vector):
mat.ravel() #NOTE: ravel is row-priority - happens row by row
mat.reshape((4,1)) #This is different from ravel - you can specify dimensions with reshape
#ravel just transforms the data into one row
mat.reshape((1,4))
mat.reshape((3,1)) #error - cannot reshape array of size 4 into shape 3x1

#PREALLOCATING ARRAYS
#As in other computer languages, it is usually more efficient to preallocate an array
#rather than append/insert/concatenate additional elements, rows or columns. Why? 
#Because you might run out of contiguous space in the specific system memory (RAM) address where the current
#array is stored. Preallocation allocated all the RAM memory you need in one call,
#while resizing the array (through append, insert, concatenate, resize, etc.) may require copying the array
#to a larger block fo memory, slowing things down, and significantly so if the matrix/array is very large.
#For example, if you know the size of your matrix or array, you can initialze it with ones or zeros:
sc.ones((4,2)) #(4,2) are the (row, col) array dimensions
sc.zeros((4,2)) # or zeros
m = sc.identity(4) #create an identify matrix
m
m.fill(16)
m

#numpy matrices
#Scipy/Numpy also has a matrix data structure class. Numpy matrices are stricly 2-dimensional,
#while numpy arrays are N-dimensional. Matrix objects are a subclass of numpy arrays, so they inherit all the 
#attributes and methods of numpy arrays (ndarrays)
#The main advantage of scipy matrices is that they provide a convenient notation for matrix multiplication:
#For example, if a and b are matrices, then a * b is their matrix product.

#Matrix-vector operations
#Now let's perform some common matrix-vector operations on arrays (you can also try the same
# using matrices instead of arrays):
mm = sc.arange(16)
mm
mm = mm.reshape(4,4) #Convert to matrix
mm
mm.transpose()
mm + mm.transpose()
mm - mm.transpose()
mm * mm.transpose() #Note elementwise multiplication
mm // mm.transpose() #Get a warning because of zero division
mm // (mm + 1).transpose()
mm * sc.pi
mm.dot(mm) #matrix multiplication or dot product
#dot product is absolute value of a x absolute value of b x cosine
mm = sc.matrix(mm) #convert to scipy matrix class
mm
print(type(mm))
mm * mm #Now matrix multiplication is syntactically easier
#We can do a lot more things by importing the linalg sub-package: sc.linalg
#sc.linalg = linear algebra

import scipy.linalg

#TWO PARTICULARLY USEFUL SCIPY SUB-PACKAGES
#Two particularly useful scipy sub-packages are sc.integrate (what will I need this for?)
#and sc.stats. Why not use R for this? Because often you might just want to calcualte some summary
#stats of your simulation results with Python.

#Scipy stats

import scipy.stats

scipy.stats.norm.rvs(size = 10) #10 samples from N(0,1)

scipy.stats.randint.rvs(0, 10, size = 7) #Random integers between 0 and 10

#Numerical integration using scipy

#Numerical integration is the approximate computation of an integral using
#numerical techniques. You need numerical integration whenever you have a complicated
#function that cannot be integrated analytically using anti-derivatives.
#For example, calculating the area under a curve is a particularly useful application in solving ordinary differential equations (ODEs),
#commonly used for modelling biological systems.

#The Lokta-Volterra model
#Let's try numerical integration in Python for solving a classical model in biology - the Lotka-Volterra
#model for a predator-prey system in two-dimensional space (e.g. on land).

#The Lokta-Volterra model is the change in resource (prey) population dR over the change in time dt
#which is equal to the intrinsic groth rate of the resource (prey) population minus the search rate for the resource
#multiplied by the number of consumers and multiplied by the number of prey

#OR the change in consumer (predator) pop. over change in time is equal to 
#minus the mortality rate times consumer pop., plus consumer efficiency x search rate x
#consumer pop. times resource pop.

#We have already imported scipy above, so we can proceed to solve the LV model using numerical integration.
#First, import scipy's integrate submodule:

import scipy.integrate as integrate

#Now define a function that returns the growth rate of consumer and resource population at any give time step.
def dCR_dt(pops, t=0):

    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

type(dCR_dt)

#So dCR_dt has been stored as a function object in teh current Python session, all ready to go.
#Now assign some parameter values:

r = 1. #growth rate of resource pop
a = 0.1 #search rate for resource
z = 1.5 #mortality rate
e = 0.75 #consumers efficiency converting resource to consumer biomass

#Define the time vector; let's integrate from time point 0 to 15, using 1000 sub-divisions of time:

t = sc.linspace(0, 15, 1000) #sc.linspace = return evenly spaced numbers over a
#specified interval from x to y with z subdivisions
#Note that the units of time are arbitrary here.
#Set the initial conditions for the two populations (10 resources and 5 consumers per unit area)
#and convert the two into an array (because our dCR_dt function takes an array as input)

R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

#Now numerically integrate this system forward from those starting conditions:

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output = True)
pops
#So pops contains the result (the population trajectories).
#Also check what's in infodict (it's a dictionary with additional information).
type(infodict)
infodict.keys()
#check what the infodict output is by reading the help documentation with ?scipy.integrate.odeint.
#For example, you can return a message to screen about whether the integration was successful:
infodict['message']
infodict['hu']
#So it worked, great! But we would like to visualize the results. LEt's do it using the matplotlib package.

#PLOTTING IN PYTHON
#To visualize the results of your numerical simulations in Python (or for data exploration/analyses),
#you can use matplotlib which uses Matlab like plotting syntax.
#First let's import the package:

import matplotlib.pylab as p

#Now open an empty figure object (analogous to an R graphics object)

f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') #Plot
p.plot(t, pops[:,1], 'b-', label = 'Consumer densioty')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
p.show() #To display the figure

#Finally, save the figure as a pdf:

f1.savefig('../results/LV_model.pdf') #save figure

