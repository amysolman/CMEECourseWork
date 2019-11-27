# Amy Solman amy.solman19@imperial.ac.uk
# 14th October 2019
# basic_io.R: A simple script to illustrate R input-output
# Run line by line and check inputs, outputs, to understand what is happening

MyData <- read.csv("../Data/trees.csv") # import with headers

write.csv(MyData, "../Results/MyData.csv") # write it out as a new file

write.table(MyData[1,], file = "../Results/MyData.csv", append=TRUE) #Append to it
#warning expected 
write.csv(MyData, "../Results/MyData.csv", row.names=TRUE) # write row names

write.table(MyData, "../Results/MyData.csv", col.names=FALSE) # ignore column names
