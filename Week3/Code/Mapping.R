# Amy Solman amy.solman19@imperial.ac.uk
# 22nd October 2019
# Mapping.R

load("../Data/GPDDFiltered.RData")
gpdd

install.packages("maps")

require(maps)

map("world", fill=TRUE, col="white", bg="lightblue", ylim=c(-60, 90), mar=c(0,0,0,0))
points(gpdd$long, gpdd$lat, col="red", pch=1)

# From the map it seems that the majority of data points are clustered along the West coast 
# of North America and Europe. Information on biodiversity may be skewed towards developed
# countries with greater funding for research/data collection. 

