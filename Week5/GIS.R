install.packages("raster")
install.packages("units")
install.packages("rgdal", repos = "http://cran.us.r-project.org", type = "source")
install.packages("sf")
install.packages("rgeos")
install.packages("lwgeom") 
install.packages("viridis")

library(raster)
library(sf)
library(viridis)
library(units)
library(rgdal)

pop_dens <- data.frame(n_km2 = c(260, 67,151, 4500, 133), 
                       country = c('England','Scotland', 'Wales', 'London', 'Northern Ireland'))
print(pop_dens)

#Create coordinates for each country
# - this is a list of sets of coordiantes forming the edge of the polygon.
# - note that they have to _close_ (have the same coordinates at either end)

scotland <- rbind(c(-5, 58.6), c(-3, 58.6), c(-4, 57.6), 
                  c(-1.5, 57.6), c(-2, 55.8), c(-3, 55), 
                  c(-5, 55), c(-6, 56), c(-5, 58.6))
england <- rbind(c(-2,55.8),c(0.5, 52.8), c(1.6, 52.8), 
                 c(0.7, 50.7), c(-5.7,50), c(-2.7, 51.5), 
                 c(-3, 53.4),c(-3, 55), c(-2,55.8))
wales <- rbind(c(-2.5, 51.3), c(-5.3,51.8), c(-4.5, 53.4),
               c(-2.8, 53.4),  c(-2.5, 51.3))
ireland <- rbind(c(-10,51.5), c(-10, 54.2), c(-7.5, 55.3),
                 c(-5.9, 55.3), c(-5.9, 52.2), c(-10,51.5))

# Convert these coordinates into feature geometries
# - these are simple coordinate sets with no projection information
scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

# Combine geometries into a simple feature column
uk_eire <- st_sfc(wales, england, scotland, ireland, crs=4326)
plot(uk_eire, asp=1)

#Another approach to creating point vector data sources is used below to create point locations
# for capital cities 
uk_eire_capitals <- data.frame(long= c(-0.1, -3.2, -3.2, -6.0, -6.25),
                               lat=c(51.5, 51.5, 55.8, 54.6, 53.30),
                               name=c('London', 'Cardiff', 'Edinburgh', 'Belfast', 'Dublin'))

uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords=c('long','lat'), crs=4326)

#Use a buffer operation to create a polygon for London (anything within 1 degree of st. pauls)
st_pauls <- st_point (x=c(-0.098056, 51.513611))
london <- st_buffer(st_pauls, 0.25)

#We need to remove London from the England polygon fo that we can set different
#population densities for the two regions. This uses the difference operation.
#Note that the order matters here: we want the bits of England that are different from London
england_no_london <- st_difference(england, london)

# Count the points and show the number of rings within the polygon features
lengths(scotland)

lengths(england_no_london)

#We can use the same operation to tidy up Wales: in this case we want the bits of Wales that
#are different from England
wales <- st_difference(wales, england)

#Now we use the intersection operation to seperate N. Ireland fromt eh island of Ireland
#First we create a rough polygon that includes N.I and sticks out into the sea
#then we find the intersection and difference of that with the Ireland polygon to get N.I and Eire

#A rough polygon that includes Northern Ireland and surrounding sea.
# - not the alternative way of providing the coordinates
ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1), y=c(54.4, 56, 55, 54, 54.4))))
northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

#Combine the final geometrics
uk_eire <- st_sfc(wales, england_no_london, scotland, london, northern_ireland, eire, crs=4326)

#Make the UK into a single feature
uk_country <- st_union(uk_eire[-6])

#Compare six polygon features with one multipolygon feature
print(uk_eire)

print(uk_country)

#Plot them
par(mfrow=c(1, 2), mar=c(3,3,1,1))
plot(uk_eire, asp=1, col=rainbow(6))
plot(st_geometry(uk_eire_capitals), add=TRUE)
plot(uk_country, asp=1, col='lightblue')

#SF package introduces the sf object type: basically this is just a normal data frame with an
#simple feature column. We can do that here:
uk_eire <- st_sf(name=c('Wales', 'England', 'Scotland', 'London', 'Northern Ireland', 'Eire'), 
                 geometry=uk_eire)
plot(uk_eire, asp=1)


#Since an sf object is an extended dataframe, we can add attributes by adding fields directly:
uk_eire$capital <- c('London', 'Edinburgh', 'Cardiff', NA, 'Belfast', 'Dublin')

#We can also use the merge command to match data in. Note that we need to use by.x and by.y 
#to say which columns we expect to match. We also use all.x=TRUE, otherwise Eire
#will be dropped fromt eh spatial data because it has no population density
#estimate int eh dataframe.

uk_eire <- merge(uk_eire, pop_dens, by.x='name', by.y='country', all.x=TRUE)
print(uk_eire)

#One common thing that people want to know are spatial attributes of geometries and
#there are a range of commands to find these things out. One thing we might want are the
#centroids of features.

uk_eire_centroids <- st_centroid(uk_eire)
st_coordinates(uk_eire_centroids)

#The sf package warns us here that this isn't a sensible thing to do. There isn't a good way to
#calculate a true centroid for geographic coordinates - we'll come back to this in the section on reprojection.

#Two other simple ones are the length of a feature and its area. Note that here sf is able to do something 
# clever behind the scenes. Rather than give us answers in units of degrees, it notes that we have a 
#geographic coordinate system and instead uses internal transformations to give us back accurate distances
#and areas using metres. 

uk_eire$area <- st_area(uk_eire)
# The length of a polygon is the perimeter length 
#- note that this includes the length of internal holes.
uk_eire$length <- st_length(uk_eire)
# Look at the result
print(uk_eire)

#The fields have units after the values! The sf package often creates data with explitic units, using
#the units package
#You can change units in a neat way
uk_eire$area <- set_units(uk_eire$area, 'km^2')
uk_eire$length <- set_units(uk_eire$length, 'km')

#And it won't let you make silly errors like turning a length into a weight
uk_eire$area <- set_unit(uk_eire, 'kg')

#Or you can simply convert the units version to simple numbers 
uk_eire$length <- as.numeric(uk_eire$length)
print(uk_eire)

#A final useful example is the distance between objects: sf gives us the closest distance between
#geometries, which might be zero if two features are touching

st_distance(uk_eire)

st_distance(uk_eire_centroids) 

#If you plot an sf object, the default is to plot a map for every attribute. You can pick
#a column to show using square brackets.

plot(uk_eire['n_km2'], asp=1, logz=TRUE)

#Reprojecting vector data
#In the examples above we have been asserting that we have data with a particular projection (4326)
#This is not reprojection: we are simply saying that we know these coordinates are in this projection.
#That mysterious 4326 is just a unique numeric code

#Reporjection is moving data from one set of coordiantes to another. For vector data, this is a 
#relatively straightforward process. The spatial information in a vector dataset are coordinates 
#in space, and projections are just sets of equations, so it is simple to apply the equations to the coordiantes.

#Convert from geographic coordinate survey with units of degrees, to projected coordinate system with linear units

#British National Grid (EPSG: 27700)
uk_eire_BNG <- st_transform(uk_eire, 27700)
#The bounding box of the data shows the change in units
st_bbox(uk_eire)

st_bbox(uk_eire_BNG)

#UTM50N (EPSG: 32650)
uk_eire_UTM50N <- st_transform(uk_eire, 32650)
#Plot the results
par(mfrow=c(1,3), mar=c(3,3,1,1))
plot(st_geometry(uk_eire), asp=1, axes=TRUE, main='WGS 84')
plot(st_geometry(uk_eire_BNG), asp=1, axes=TRUE, main='OSGB 1936')
plot(st_geometry(uk_eire_UTM50N), asp=1, axes=TRUE, main='UTM 50N')

#Degrees are not constant

#Set up some points seperated by 1 degree latitude and longitude from St. Pauls
st_pauls <- st_sfc(st_pauls, crs=4326)
one_deg_west_pt <- st_sfc(st_pauls - c(1,0), crs=4326) #Near Goring
one_deg_north_pt <- st_sfc(st_pauls + c(0,1), crs=4326) #Near Peterborough
#Calculate the distance between St PAuls and each point
st_distance(st_pauls, one_deg_west_pt)
st_distance(st_pauls, one_deg_north_pt)

st_distance(st_transform(st_pauls, 27700), st_transform(one_deg_west_pt, 27700))

#Our feature of London would be far better if it used a constant 25km
#buffer around St. Pauls rather than the poor attempt using degrees

#Transform St Pauls to BNG and buffer using 25km
london_bng <- st_buffer(st_transform(st_pauls, 27700), 25000)
#In one line, transform england to BNG and cut out London
england_not_london_bng <- st_difference(st_transform(st_sfc(england, crs=4326), 27700), london_bng)
#Project the other features and combine everything together
others_bng <- st_transform(st_sfc(eire, northern_ireland, scotland, wales, crs=4326), 27700)
corrected <- c(others_bng, london_bng, england_not_london_bng)
#Plot that and marvel at the nice circular feature around London
par(mar=c(3,3,1,1))
plot(corrected, main='25km radius London', axes=TRUE)

#Creating a rasta

#Create an empty rasta object covering the UK and Eire
uk_raster_WGS84 <- raster(xmn=-11,  xmx=2,  ymn=49.5, ymx=59, res=0.5, crs="+init=epsg:4326")
hasValues(uk_raster_WGS84)

# Add data to the raster: just the number 1 to number of cells
values(uk_raster_WGS84) <- seq(length(uk_raster_WGS84))

plot(uk_raster_WGS84)
plot(st_geometry(uk_eire), add=TRUE, border='black', lwd=2, col='#FFFFFF44')


#Changing raster resolution
#Define a simple 4x4 square raster
m <- matrix(c(1,1,3,3,
              1,2,4,3,
              5,5,7,8,
              6,6,7,7), ncol=4, byrow=TRUE)
square <- raster(m)

#Aggregating rasters
#With aggregating we choose an aggregation factor - how many cells to group -
#and then lump sets of cells together. So, for example, a factor of 2 with aggregate blocks 
#of 2x2 cells

#The question is then, what value should we assign? If the data is continuous
#(e.g. height) then a mean or a maximum might make sense. However, if the raster values represent 
#categories (like land cover), then mean doesn't make sense at all: the average of Forest (2) 
#and Moorland (3) is easy to calculate but what does it actually mean?

#Average values
square_agg_mean <- aggregate(square, fact=2, fun=mean)
values(square_agg_mean)

#Maximum values
square_agg_max <- aggregate(square, fact=2, fun=max)
values(square_agg_max)

#Modal values for categories
square_agg_modal <- aggregate(square, fact=2, fun=modal)
values(square_agg_modal)

#Disaggreagting rasters
#This again requires a factor, but this time the factor is the square root of the number of cells
#to create from each cell rather than the number to merge. There is again a choice to make on what 
#values to put in the cell. The obvious answer is simply to copy the parent cell value into each 
#of the new cells: this is pretty simple and is fine for both continuous and categorical values. 
#Another option is to interpolate between the values to provide a smoother gradient between cells. 
#This does not make sense for a categorical variable.

#Copy parents
square_disagg <- disaggregate(square, fact=2)
#Interpolate
square_disagg_inter <- disaggregate(square, fact=2, method='bilinear')

#Reprojecting a raster
#make two simple 'sfc' objects containing points in the
#lower left and top right of the two grids
uk_pts_WGS84 <- st_sfc(st_point(c(-11, 49.5)), st_point(c(2, 59)), crs=4326)
uk_pts_BNG <- st_sfc(st_point(c(-2e5, 0)), st_point(c(7e5, 1e6)), crs=27700)

#Use st_make_grid to quickly create a polygon grid with the right cellsize
uk_grid_WGS84 <- st_make_grid(uk_pts_WGS84, cellsize=0.5)
uk_grid_BNG <- st_make_grid(uk_pts_BNG, cellsize=1e5)

#Reproject the BNG grid into WGS84
uk_grid_BNG_as_WGS84 <- st_transform(uk_grid_BNG, 4326)

#Plot the features
par(mfrow=c(1, 1))
plot(uk_grid_WGS84, asp=1, border='grey', xlim=c(-13, 4))
plot(st_geometry(uk_eire), add=TRUE, border='darkgreen', lwd=2)
plot(uk_grid_BNG_as_WGS84, border='red', add=TRUE)

#We will use the projectRaster function, which gives us the choice
#of interpolating a representative value from the source data (method = 'bilinear')
#or picking the cell value from the nearest neighbour to the new cell centre (method='ngb')
#We first create the target raster - we don't have to put any data into it - and use
#that as a template for the reprojected data.

#Create the target raster
uk_raster_BNG <- raster(xmn=-200000, xmx=700000, ymn=0, ymx=1000000,
                        res=100000, crs='+init=epsg:27700')
uk_raster_BNG_interp <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method='bilinear')
uk_raster_BNG_ngb <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method='ngb')

#Compare the values in the top row
round(values(uk_raster_BNG_interp)[1:9], 2)

values(uk_raster_BNG_ngb)[1:9]

#Note that for the cells in the top right and left, projectRaster
#has assigned an NA value. In the plot above, you can see that the
#centres of those red cells do not overlie the original grey grid. 
#IF we plot the two outputs you can see the more abrupt changes when
#using nearest neighbour projection

par(mfrow=c(1,3), mar=c(1,1,2,1))
plot(uk_raster_BNG_interp, main='Interpolated', axes=FALSE, legend=FALSE)
plot(uk_raster_BNG_ngb, main='Nearest Neighbour', axes=FALSE, legend=FALSE)

#Converting between vector and raster data types
#Sometimes you want to represent raster data in vector format or vice versa.
#It is usually worth thinging if you really want to do this - data usually comes in
#one format or another for a reason - but there are plenty of valid reasons to do it.

#Vector to raster
#Provide target raster and vector data and put it all through the rasterize function

#Create the target raster
uk_20km <- raster(xmn=-200000, xmx=650000, ymn=0, ymx=1000000,
                  res=20000, crs='+init=epsg:27700')

#Rasterizing polygons
uk_eire_poly_20km <- rasterize(as(uk_eire_BNG, 'Spatial'), uk_20km,
                               field='name')

#Rasterizing lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')

st_agr(uk_eire_BNG) <- 'constant'

#Rasterizing lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')
uk_eire_line_20km <- rasterize(as(uk_eire_BNG_line, 'Spatial'), uk_20km, field='name')

