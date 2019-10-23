# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# preallocate.R

a <- NA # vector a assigned the element 'not available'
system.time((for (i in 1:1000) { # for each element in numbers 1 to 10000
    a <- c(a, i) # concatenate a and that element and assign to vector a
    print(a) # print a
    print(object.size(a)) # print size of a
}))


# Now let's pre-allocate the vector (a) to fit all the values

a <- rep(NA, 1000) # replicates the NA value 10000 times

system.time((for (i in 1:1000) { # for each element from 1 to 10000
    a[i] <- i # add that element to the vector (a)
    print(a)
    print(object.size(a))
})) 
