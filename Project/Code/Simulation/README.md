# Final Project README

#Put info here about each script


MultiArchIslandData.R

Script to read in island data from 100 simulation repeats of multiple archipelagos

Function 1. Import the 100 simulations
Function 2. From the simulations get the immigration rates and number of niches
Function 3. Subset the islands by one specified immigration rate
Function 4. Subset the islands by one specified number of niches
Function 5. Subset the islands by each unique number of niches
Function 6. Get the immigration rate and number of niches for each archipelago
Function 7. Get the unique number of species on each island
Function 8. Get the total number of species on each island in the archipelago
Function 9. Get the areas of each island in the archipelago
Function 10. Call function 2-9 and return a data frame detailing the archipelago number, number of species, area, immigration rate and number of niches for each island in each archipelago in the simulation
Function 11. Imports the data. For each simulation, removes timeseries data to keep only island info. Calls function 10 on each simulation. Returns list of 100 data frames with archipelago info for each simulation.
Function 12. Isolates an archipelago for each simulation and finds mean species richness. Function 13. Calls function 12 and repeats for each archipelago. Returns list of mean data frames for each archipelago.
Final script call the various function to import and process the data, then bind the mean results into one list for exporting. 