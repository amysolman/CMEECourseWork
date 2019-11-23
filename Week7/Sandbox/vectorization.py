#Vectorization revisited

#The following two examples will showcase the difference in runtime 
#between a loop method and a vectorized method using numpy.
#The first is a relatively simple (if artificial) problem, intended to
#demonstrate basically at-a-glance the difference between the two approaches.
#The second is taken from current research on metabolic models of bacterial communities.

#An example
#Let us imagine we have two simple 1D arrays a=(a1, a2...aN) and b = (b1, b2...bN)
#each of length N, and that we want to calculate a new array c in which each entry is just 
# the product of the two corresponding entries in a and b.
#c = (a1xb1, a2xb2...) This operation is called the entrywise product of a and b.
#Below are a loop-based function and a vectorized function to calculate the entrywise product
#of two arrays of the same length.
#We will test them both on larger and larger 1D arrays to see how the vectorized approach is faster.

def loop_product(a, b):
    N = len(a)
    c = sc.zeros(N)
    for i in range(N):
        c[i] = a[i] * b[i]
    return c

def vect_product(a, b):
    return sc.multiply(a, b)

#The multiply function from numpy is a vectorized implementation of the elementwise
#product that we have explicitly written in the function loop_product above it.
#In general, numpy is an excellent choice for vectorized implementations of functions involving matrix maths
#(or maths using higher-dimensional analogues of matricies).

#Let's try comparing the runtimes of loop_product and vect_product on increasingly large
#randomly-generated 1D arrays:

import timeit

array_lengths = [1, 100, 10000, 1000000, 10000000]
t_loop = []
t_vect = []

for N in array_lengths:
    print("\nSet N=%d" %N)
    #randomly generate our 1D arrays of length N
    a = sc.random.rand(N)
    b = sc.random.rand(N)

    #time loop_product 3 times and save the mean execution time.
    timer = timeit.repeat('loop_product(a, b)', globals=globals().copy(), number=3)
    t_loop.append(1000 * sc.mean(timer))
    print("Loop method took %d ms on average." %t_loop[-1])

    #time vect_product 3 times and save the mean execution time.
    timer = timeit.repeat('vect_product(a, b)', globals=globals().copy(), number=3)
    t_vect.append(1000 * sc.mean(timer))
    print("Vectorized method took %d ms on average." %t_vect[-1])

p.figure()
p.plot(array_lengths, t_loop, label="loop method")
p.plot(array_lengths, t_vect, label="vect method")
p.xlabel("Array length")
p.ylabel("Execution time (ms)")
p.legend()
p.show()

#When to vectorize?
#Thus vectorizing your code can have it running in a fraction of the time it otherwise would.
#Why not always vectorize then?
#Generally, you should follow the same principles as with any code profiling: don't spend time
#speeding up code that isn't slow in the first place, or code which you will probably not need to run
#more than a small number of times.

#No free lunch!
#There are tradeoffs to vectorizing, most notably memory usage. One downside of calcualting many steps
#simultaneously is that your computer needs to hold much more in memory in order to do it.
#If you try to vectorize a problem that too large, you will probably run into memory errors. One easy example is to re-run
#the above example, but make it even bigger:

N = 1000000000

a = sc.random.rand(N)
b = sc.random.rand(N)
c = vect_product(a, b)

#if no error, remove a, b, c from memory
del a     
del b
del c

#This will almost certainly return a memory error. 