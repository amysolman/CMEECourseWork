#!/usr/bin/env Rscript
# Amy Solman amy.solman19@imperial.ac.uk
# 2nd December 2019
# get_TreeHeigh.R: This function takes a csv file name from the command
#line, calculates heights of trees given distance to each tree
# base and angle to its top, using the trigonometric formula
# with input filename included in output filename


args <- commandArgs(TRUE)
  
MyTrees <- read.table(args[1], sep=",", stringsAsFactors = FALSE, header=TRUE) # read trees.csv to MyTrees data frame

TreeDistance <- as.numeric(MyTrees[[2]]) # assign second column of MyTrees data frame to TreeDistance numerical vector

TreeDegrees <- as.numeric(MyTrees[[3]]) # assign third column of MyTrees data frame to TreeDegrees numerical vector

TreeHeight <- function(degrees, distance){ # defines the function and the two arguments it will take
  radians <- degrees * pi / 180 # applies 'degrees' multiplied by pie divided by 180 to radians
  height <- distance * tan(radians) 
  print(paste(height))
}

Tree.Height <- TreeHeight(TreeDegrees, TreeDistance)

# Add height to MyTrees data frame
MyTrees$"Tree.Height.m" <- Tree.Height

filename <- paste0(tools::file_path_sans_ext(args[1]),"_treeheights.csv")
output_folder <- paste0("../Results/",filename) 

write.table(MyTrees, output_folder, row.names=FALSE, col.names=TRUE)
