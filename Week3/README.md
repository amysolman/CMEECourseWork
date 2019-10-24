# CMEE README WEEK 3

Biological Computing in R and Data management, exploration and visualization (21/10/19 - 25/10/19)
This week we focused on biological computing and data management in R. Topics included:
 - R basics
 - Variable types
 - Data structures
 - Creating and manipulating data
 - Control flow tools
 - Vectorization
 - Debugging
 - Data wrangling
 - Data visualization
 - Graphics with R
 
All work was completed used Mac OS Mojave version 10.14.6, R and the code editor RStudio. Below is a comprehensive guide to all files and scripts within the WEEK2 directory of my CMEECourseWork folder.

# Code

 - apply1.R: Builds matrix of 100 normally distributed, random numbers, takes mean, and variance
 - apply2.R: Apply normally distributed, random numbers to function (times number by 100)
 - basic_io.R: Imports tree data, writes to new file
 - boilerplate.R: Boilerplate R script
 - break.R: Script showing use of 'break' function to break out of loop
 - browse.R: Simulation of exponential growth, makes console enter 'browse' mode
 - control_flow.R: Example of control flow tools
 - DataWrang.R: Load dataset and use 'reshape2' to wrangle data
 - DataWrangTidy.R: Load dataset and use dyplr/tidyr to wrangle data
 - Girko.R: Builds plot of Girko's circular law
 - Mapping.R: Generates world map with species plot points
 - MyBars.R: Generates bar chart with ggplot
 - next.R: Skipping to the next iteration of a loop using 'next'
 - PlotLin.R: Plots linear regression and produces graph
 - PP_Lattice.R: Generates lattice graphs
 - PP_Regress.R: Generates multifaceted graph of linear regressions, plus table with regression data
 - preallocate.R: Using preallocation of vectors
 - Ricker.R: Runs simulation of Ricker model, plots graph
 - sample.R: Practising loops/apply and vectorization
 - TAutoCorr.R: Exploring autocorrelation of temperature for successive years in Key West, Florida
 - TreeHeight.R: Calculates heights of trees given distance and angle
 - try.R: Simulation, sampling from synthetic population and taking mean, only if min unique samples are obtained
 - Vectorize1.R: Using vectorization to speed up computations
 - Vectorize2.R: Using vectorization to speed up computations

# Data

- EcolArchives-E089-51-D1.csv: Species interaction data used for PP_Lattice.R and PP_Regress.R
- GPDDFiltered.RData: Lat/Long species locations used for Mapping.R
- KeyWestAnnualMeanTemperature.RData: Temperature Data used for TAutoCorr.R
- PoundHillData.R: Data used for DataWrang.R and DataWrangTidy.R
- PoundHillMetaData.R: Data used for DataWrang.R and DataWrangTidy.R
- Results.txt: Data used for MyBars.R
- trees.csv: Data used for basic_io.R and TreeHeight.R

# Results

- Autocorrelation.pdf: PDF report of TAutoCorr results with source code, results, discussion and references
- Autocorrelation.tex: Text eport of TAutoCorr results with source code, results, discussion and references
