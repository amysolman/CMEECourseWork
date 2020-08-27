Overview of directory contents


This directory contains the Classic, Depth and Perimeter model fitting scripts. 


Scripts


DataEdit.R

Application: Reads in the 57 datasets and carries out a Spearman's rank correlation test to see if there is a significant correlation between area and species. The datasets with positive correlation coefficients are exported to a second dataset.

Packages: ggpubr is used for plotting a scatter graph of the correlation tests.


CombineResults.R

Application: Binds together the results for each of the Classic, Depth and Perimeter model fittings into one dataframe.

Packages: None.


DataTable.R

Application: Creates summary table of datasets for use in final report.

Packages: dplyr is used for grouping the taxonomic groups and habitat types.


NLLSFit_Classic.R

Application: Fits datasets using Classic Model and power-law model. Compares models AIC scores. Exports fitting results and AIC scores.

Packages: minpack.lm for NLLS fitting algorithm. ggplot2 for creating graphs. LambertW for estimating starting parameters.


NLLSFit_Depth.R

Application: Fits datasets using Depth Model and power-law model. Compares models AIC scores. Exports fitting results and AIC scores.

Packages: minpack.lm for NLLS fitting algorithm. ggplot2 for creating graphs. LambertW for estimating starting parameters.


NLLSFit_Peri.R

Application: Fits datasets using Perimeter Model and power-law model. Compares models AIC scores. Exports fitting results and AIC scores.

Packages: minpack.lm for NLLS fitting algorithm. ggplot2 for creating graphs. LambertW for estimating starting parameters. lamW for estimating critical area. 


Statistical Analysis.R

Application: Reads in fitting data for Classic, Depth and Perimeter Models, as well as the power-law model outcomes. 

Packages: dplyr for grouping data into taxonomic and habitat groups. ggpubr for creating boxplots. viridis for boxplot colour palettes. 