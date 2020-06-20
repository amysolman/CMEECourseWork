#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: SimulationCompile.sh
# Desc: Script to compile simulation analysis scripts
# Date: June 2020


Rscript DataPrep.R
Rscript TimeseriesPlot.R 
Rscript Analysis.R 
Rscript ResultsBind.R
Rscript MeanPlot.R 
python3 NLLSDataID.py
Rscript NLLSFit.R
Rscript RSquaredPlot.R

bash CompileLaTex.sh Simulation