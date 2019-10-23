# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# Boilerplate.R: A boilerplate R script

MyFunction <- function(Arg1, Arg2){
  # statements invloving Arg1, Arg2:
  print(paste("Argument", as.character(Arg1), "is a", class(Arg1)))
  # print Arg1's type
  print(paste("Argument", as.character(Arg2), "is a", class(Arg2)))
  # print Arg2's type
  
  return (c(Arg1, Arg2)) # this is optional but very useful 
}

MyFunction(1,2) # test the function
MyFunction("Riki", "Tiki") # a different test