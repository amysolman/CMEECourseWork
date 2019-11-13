
def my_squares(iters): #create a function that takes the argument 'iters'
    out = [] #create empty vector
    for i in range(iters): #for each item in range of the given argument
        out.append(i ** 2) #add to our empty vector item squared
    return out #give us the content of the vector
    
def my_join(iters, string): #create a vector that takes two arguments, 'iters' and 'string'
    out = '' #create empty string
    for i in range(iters): #for each item in range of the given argument
        out += string.join(", ") # add the string argument to the empty string
    return out #give us the content of the string

def run_my_funcs(x,y): #create funtion that takes two arguments 'x' and 'y'
    print(x,y) #print the two given arguments
    my_squares(x) #run my_squares function with 'x' as the 'iters' argument
    my_join(x,y) #run my_join function with 'x' and 'y' as the 'iters' and 'string' argument
    return 0 

run_my_funcs(10000000,"My string")

# run -p profileme.py - this will profile the functions within the script
