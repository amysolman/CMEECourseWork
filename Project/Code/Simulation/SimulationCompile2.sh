#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: SimulationCompile.sh
# Desc: Script to compile simulation analysis scripts
# Date: June 2020


Rscript DataPrep2.R
Rscript TimeseriesPlot2.R 
Rscript Analysis2.R 
Rscript ResultsBind2.R
Rscript MeanPlot2.R 
python3 NLLSDataID2.py
Rscript NLLSFit2.R
Rscript RSquaredPlot2.R
Rscript Parameters2.R

bash CompileLaTex.sh Simulation2