# Amy Solman amy.solman19@imperial.ac.uk
# 2nd December 2019
# get_TreeHeigh.R: This function takes a csv file name from the command
#line, calculates heights of trees given distance to each tree
# base and angle to its top, using the trigonometric formula

#Write another R script called get_TreeHeight.R that takes a csv file 
#name from the command line (e.g., get_TreeHeight.R Trees.csv) and outputs 
#the result to a file just like TreeHeight.Rabove, but this time includes 
#the input file name in the output file name as InputFileName_treeheights.csv. 
#Note that you will have to strip the .csvor whatever the extension is from 
#the filename, and also ../etc., if you are using relative paths. (Hint: 
#Command-line parameters are accessible within the R running environment via 
#commandArgs() — so help(commandArgs) might be your starting point.)
#Write a Unix shell script called run_get_TreeHeight.sh that tests get_TreeHeight.R. 
#Include trees.csvas your example file. Note that sourcewill not work in this case 
#as it does not allow scripts with arguments to be run; you will have to use Rscriptinstead.

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
