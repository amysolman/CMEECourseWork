#The need for speed: profiling code

#Computational speed may not be your initial concern. 
#You should focus on developing clean, reliable, reusable code rather than worrying
#first about how fast your code runs. However, speed will become an issue when and if your analysis
#or modelling becomes complex enough (e.g. food web or large network simulations).
#In that case, knowing which paarts of your code take the most time is useful - optimizing those parts may
#save you lots of time.

#To find out what is slowing down your code you need to "profile" your code:
#locate the sections of your code where speed bottlenecks exist.

#Profiling in Python

#Profiling is easy in ipython - simply use the command:
#%run -p your_function_name

#Comparing the files profileme.py and profileme2.py, we increased speed significantly
#in the later by converting the loop to a list comprehension, and replaced the .join with an 
#explicit string concatenation.
#Another approach would be to preallocate a numpy array instead of using a list for my_squares.

def my_squares(iters):
    out = sc.zeros(1)
    for i in range(iters):
        out.fill(iters ** 2)
    return out


#You can also modify how the profiling results are displayed, and more, by using flags. For example,
#-s allows sorting the report by a particular column, -l limits the number of lines displayed or
#filters the results by function name, and -T saves the report in a text file.
#For example, try:

run -p -s cumtime profileme2.py

#This will do the profiling and display the results sorted by sumtime.


#Quick profiling with timeit
#Additionally you can use the timeit module if you want to figure out what the best
#way to do something specific as part of a larger program (say a particular
# command or loop) might be.


#Now run the two sets of comparisons using timeit() in ipython and make sure every line makes sense:

%timeit my_squares_loops(iters)
%timeit my_squares_lc(iters)
%timeit(my_join_join(iters, mystring))
%timeit(my_join(iters, mystring))


import time

start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run" % (time.time() - start))

start = time.time()
my_squares_lc(iters)
print("my_squares_lc %f s to run." % (time.time() - start))

#But you'll notice that if you run it multiple times, 
# the time taken changes each time. So timeit takes a sample of 
# runs and returns the average, which is better