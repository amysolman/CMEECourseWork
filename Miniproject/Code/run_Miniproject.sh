#!/bin/bash
# Author: Amy Solman amy.solman@imperial.ac.uk
# Script: FinalCompile.sh
# Desc: Script to compile data_prep, NLLSfitting, plot_analysis and LaTex scripts
# Date: Feb 2020


python3 data_prep.py 

Rscript NLLSfittingscript.R 

Rscript plot_analysis.R 

bash CompileLaTex.sh FinalReport
