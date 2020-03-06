# CMEE README MINIPROJECT 

This project imported a dataset comprising 285 bacterial growth curves, modified the data, performed model fitting of seven models (Logistic, Gompertz, Baranyi, Buchanan, Polynomial, Quadratic, Linear) and statistically tested them for goodness of fit. Final output is a report written in LaTex, presenting results and providing a discussion of the findings. 

Languages used:

Python 2.7.16
R 3.6.1
Bash
LaTex

Packages used:
pandas (data_prep.py) - used to import and modify original dataset
plyr (NLLSfittingscript.R, plot_analysis.R) - used to merged data frames from lists
minpack.lm NLLSfittingscript.R) - used to run non-linear least squared regression fitting with Levenberg-Marquardt  Nonlinear  Least-Squares  algorithm
ggplot2 (plot_analysis.R) - used to create plots of fitted models against the data
dplyr (plot_analysis.R) - used to 'mutate' data frame to find total and insert as new column
