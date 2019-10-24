# Amy Solman amy.solman19@imperial.ac.uk
# 17th October 2019
# TreeHeigh.R: This function calculates heights of trees given distance of each tree
# from its case and angle to its top, using the trigonometric formula
#
# height = distance + tan(radians)
#
# ARGUMENTS
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

MyTrees <- read.csv("../Data/trees.csv", header=TRUE) # read trees.csv to MyTrees data frame

TreeDistance <- MyTrees[[2]] # assign second column of MyTrees data frame to TreeDistance numerical vector

TreeDegrees <- MyTrees[[3]] # assign third column of MyTrees data frame to TreeDegrees numerical vector

TreeHeight <- function(degrees, distance){ # defines the function and the two arguments it will take
  radians <- degrees * pi / 180 # applies 'degrees' multiplied by pie divided by 180 to radians
  height <- distance * tan(radians) 
  print(paste(height))
  
  #return (height)
}

Tree.Height <- TreeHeight(TreeDegrees, TreeDistance)

# Add height to MyTrees data frame - WRONG!
MyTrees$"Tree.Height.m" <- Tree.Height

write.table(MyTrees, file = "../Results/TreeHts.csv", row.names=FALSE, col.names=TRUE)

# TreeHeight (37, 40) # gives tree height with two supplied arguments