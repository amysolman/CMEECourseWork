Overview of directory contents


This directory contains the Classic simulation scripts. 


Directories


Multiple_classic - contains variations of the RunSim_classicXXX.R and ClusterShell_classicXXX.sh scripts used to run the Classic Model simulation with a variety of parameters.


Scripts


Analytic_classic.R

Application: Reads in simulation results and plot known parameters with mathematical model to ensure the simulation is giving results consisten with the model.

Packages: ggplot2 for plotting graphs. 


ClusterShell_classic.sh

Application: Tells the cluster to call RunSim_classic.R to run Simulation_classic.R with 48 hour limit.

Packages: None.


Mean_classic.R

Application: Reads in data from 100 repeats of each simulation and outputs the mean results to be used in NLLS fitting.

Packages: None.


NLLSFit_classic.R

Application: NLLS fitting script for the simulated data. Calculates difference between known and fitted parameters and plots as graphs.

Packages: minpack.lm for NLLS fitting algorithm. ggplot2 for creating graphs. LambertW for estimating starting parameters.


RunSim_classic.R

Application: Script to call the Simulation_classic.R functions and run the simulation with given parameters. Currently in test mode (see in script notes).

Packages: None.


Simulation_classic.R

Application: The simulation script that generates a metacommunity, and several island simulations. A neutral simulation is applied to each niche on the island until equilibrium is reached. 

Packages: None.


Timeseries_classic.R

Application: Calls three random simulations and plots species richness vectors as timeseries to ensure simulations have reach equilibrium. 

Packages: ggplot2 for creating graphs. gridExtra for multiple plots in one graph. 

 