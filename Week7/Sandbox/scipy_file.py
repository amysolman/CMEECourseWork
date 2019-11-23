#!usr/bin/env python 3

import scipy as sc

#a = sc.array(range(5)) #a one-dimensional array
# a

print(type(a))
print(type(a[0]))

#You can also specify the data type of the array:
a = sc.array(range(5), float)
a
a.dtype #Check type

#You can also get a 1-D array as follows:
x = sc.arange(5)
x
x = sc.arange(5.) #Directly specify float using decimal
x
#As with other Python variables (e.g., created as a list or a dictionary),
#you can apply methods to variables vreated as numpy arrays.
#For example, type x. and hit TAB to see all methods you can apply to x. 
# To see dimentions of x:
x.shape
#Remember, you can type :?x.methodname to get into on a particular
#method. For example, try ?x.shape.
b = sc.array([i for i in range(10) if i % 2 == 1]) #Odd mnumbers between 1 and 10
b
c = b.tolist() #Convert back to list
c
#To make a matrix, you need a 2-D numpy array:
mat = sc.array([[0,1], [2, 3]])
mat
mat.shape

#Indexing and accessing arrays
#As with other Python data objects such as lists, numpy array elements can be accessed
#using square brackets [] with the usual [row, column] reference. Indexing of numpy arrays
#works like that for other data structures, with index values starting at 0.
#So you can obtain all the elements of a particular row as:
mat[1] #accessing whole 2nd row, remember indexing starts at 0
mat[:,1] #accessing whole second column
#And accessing particular elements:
mat[0,0] #1st row, 1st column element
mat[1,0] #2nd row, 1st column element
#Note that (like all other programming languages) row index always comes before 
#column index. That is, mat[1] is always going to mean "whole second row", and mat[1,1]
#means 1st row and 1st column element.
#Therefore, to access the whole second column you need:
mat[:,0] #accessing the whole first column
#Python indexing also accepts negative values for going back to the start
#from the end of an array.
mat[0,1]
mat[0,-1]
mat[-1,0]
mat[0,-2]

#MANIPULATING ARRAYS
#Replacing, adding or deleting elements
#Let's look at how you can replace, ass or delete an array element (a single entry, 
# or whole row(s) or whole columns(s)):
mat[0,0] = -1 #replace a single element
mat
mat[:,0] = [12,12] #replace whole column
mat
sc.append(mat, [[12,12]], axis = 0) #append row, note axis specification
sc.append(mat, [[12],[12]], axis = 1) #append column
newRow = [[12,12]] #create new row
mat = sc.append(mat, newRow, axis = 0)
mat
sc.delete(mat, 2, 0) #delete 3rd row
#And concatenation:
mat = sc.array([[0,1], [2,3]])
mat0 = sc.array([[0,10], [-1,3]])
sc.concatenate((mat, mat0), axis = 0)

#FLATTENING OR RESHAPING ARRAYS
#You can also "flatten" or "melt" arrays, that is, change array dimensions
#(e.g., from a matrix to a vector):
mat.ravel() #NOTE: ravel is row-priority - happens row by row
mat.reshape((4,1)) #this is different from ravel
mat.reshape((1,4)) #NOTEW: reshaping is also row-priority
mat.reshape((3,1)) #But total elements must remain the same

#PRE-ALLOCATING ARRAYS
#As in other computer languages, it is usually more efficient to preallocate
#an array rather than append/insert/concatenate
#additional elements, rows or columns because you might run out of contiguous
#space in the specific system memory (RAM) address where the current array is stored.
#Preallocation allocates all the RAM memory you need in one call, while resizing
#the array (through append, insert, concatenate, resize etc.) may require
#copying the array to a larger block of memory, slowing this down, and sigificantly so
#if the matrix/array is very large.

#For example, if you know the size of the matrix or array you can initialize
#it with ones or zeros
sc.ones((4,2)) #(4,2) are the row, col array dimensions
sc.zeros((4,2)) #or zeros
m = sc.identity(4) #create an identity matrix
m
m.fill(16) #fill the matrix with 16
m

#NUMPY MATRICES
#Scipy/numpy also has a matrix data structure class. Numpy matrices are strictly
#2-dimensional, while numpy arrays are N-dimensional. Matrix objects are a subclass of numpy arrays, 
#so they inherit all the attributes and methods of numpy arrays (ndarrays).
#The main advantage of scipy matrices is that they provide a convenient notation for
#matrix multiplication: for example, if a and b are matrices, then a * b is their matrix product.

#Matrix-vector operations
#Now let's perform some common matrix-vector operations on arrays (you can also try the same using
# matrixes instead of arrays):
mm = sc.arange(16)
mm = mm.reshape(4,4) #convert to matrix
mm
mm.transpose()
mm + mm.transpose()
mm - mm.transpose()
mm * mm.transpose() #Note: Elementwise multiplication!
mm // mm.transpose()
#Note that we used integer division //. Not also the warning you get
#(because of zero division). So let's avoid the divide by zero:
mm // (mm + 1).transpose()
mm * sc.pi 
mm.dot(mm) #MATRIX MULTIPLICATION, OR DOT PRODUCT
mm = sc.matrix(mm) #convert to scipy matrix class
mm
print(type(mm))
mm * mm #now matrix multiplication is suntactically easier

#NUMERICAL INTEGRATION USING SCIPY
#The Lotka-Volterra model
import scipy.integrate as integrate 

def dCR_dt(pops, t=0):
    
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return sc.array([dRdt, dCdt])

type(dCR_dt)

#So dCR_dt has been stored as a function object in the current Python session,
#all ready to go.
#Now assign some paramter values:
r = 1.
a = 0.1
z = 1.5
e = 0.75
#Define the time vector, let's integrate from time point 0 to 15, suing
#1000 subdivisions of time.
t = sc.linspace(0, 15, 1000)

R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
pops

type(infodict)
infodict.keys()
infodict['message']

#PLOTTING IN PYTHON

import matplotlib.pylab as p 

f1 = p.figure()

p.plot(t, pops[:,0], 'g-', label='Resource density') #Plot
p.plot(t, pops[:,1], 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource popualtion dynamics')
p.show() #To display the figure

#Finally save the figure as a pdf:
f1.savefig('../results/RV_model.pdf')




