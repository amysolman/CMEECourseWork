Overview of directory contents


This directory contains the depth simulation scripts. 


Directories


Multiple_depth - contains variations of the RunSim_depthXXX.R and ClusterShell_depthXXX.sh scripts used to run the dDpth Model simulation with a variety of parameters.


Scripts


Analytic_depth.R

Application: Reads in simulation results and plot known parameters with mathematical model to ensure the simulation is giving results consisten with the model.

Packages: ggplot2 for plotting graphs. 


ClusterShell_depth.sh

Application: Tells the cluster to call RunSim_depth.R to run Simulation_depth.R with 48 hour limit.

Packages: None.


Mean_depth.R

Application: Reads in data from 100 repeats of each simulation and outputs the mean results to be used in NLLS fitting.

Packages: None.


NLLSFit_depth.R

Application: NLLS fitting script for the simulated data. Calculates difference between known and fitted parameters and plots as graphs.

Packages: minpack.lm for NLLS fitting algorithm. ggplot2 for creating graphs. LambertW for estimating starting parameters.


RunSim_depth.R

Application: Script to call the Simulation_depth.R functions and run the simulation with given parameters. Currently in test mode (see in script notes).

Packages: None.


Simulation_depth.R

Application: The simulation script that generates a metacommunity, and several island simulations. A neutral simulation is applied to each niche on the island until equilibrium is reached. 

Packages: None.


Timeseries_depth.R

Application: Calls three random simulations and plots species richness vectors as timeseries to ensure simulations have reach equilibrium. 

Packages: ggplot2 for creating graphs. gridExtra for multiple plots in one graph. 

 