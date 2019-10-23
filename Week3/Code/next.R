# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# next.R: Skipping to next iteration of a loop using next 
# Printing odd numbers 1-10

for (i in 1:10) { # for each number between 1 and 10
  if ((i %% 2) == 0) # if the remainder, when divided by 2, is 0 (modulo operation)
    next # pass to next iteration of loop
  print(i) # print the number
} 
