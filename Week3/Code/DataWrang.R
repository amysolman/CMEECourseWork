# Amy Solman amy.solman19@imperial.ac.uk
# 21st October 2019
# DataWrang.R

################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../Data/PoundHillData.csv",header = F, stringsAsFactors = F)) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../Data/PoundHillMetaData.csv",header = T, sep=";", stringsAsFactors = F)

############# Inspect the dataset ###############
head(MyData) # shows top six data entries for each column
dim(MyData) # shows numnber of rows and columns
str(MyData) # shows structure of our data frame
#fix(MyData) #you can also do this 
#fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) # switches columns and rows
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############
require(reshape2) # load the reshape2 package

# ?melt #check out the melt function
# Melt function takes data in wide format and 
# stacks a set of columns into a single column of data

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")
head(MyWrangledData); tail(MyWrangledData)

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

require(dplyr)

dplyr::tbl_df(MyWrangledData) # Like head(), but nicer!

dplyr::glimpse(MyWrangledData) #like str(), but nicer!

# utils::View(MyWrangledData) # same as fix

dplyr::filter(MyWrangledData, Count > 100) # like subset(), but nicer!

dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows
