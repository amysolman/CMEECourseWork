def makeabug(x):
    y = x**4 # x to the power of 4
    z = 0
    if z == 1: # An example of how to incorporate ipdb check if you got a certain answer
        import ipdb; ipdb.set_trace() 
    y = y/z # doesn't work because you can't divide by 0
    return y

makeabug(25)

