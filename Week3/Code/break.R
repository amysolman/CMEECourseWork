# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# break.R: Example of breaking out of loops

i<-0 #Initialize i
     while(i < Inf) { #While i is less than infinity
            if (i == 10) { #If i is equal to 10
                    break 
            } # Break out of the while loop!
       else { 
         cat("i equals ", i, "\n") #Print i equals i, new line
         i <- i + 1 # Update 1 # add 1 to i
         }
    }