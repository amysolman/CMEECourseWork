#!/bin/bash
#Author: Amy Solman amy.solman19@imperial.ac.uk
#Script: cluster_run_timeseries.sh 
#Description: Cluster shell script for neutral simulation
#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run! Whoopie!"
cp $HOME/Thesis/SimTimeseries.R $TMPDIR
R --vanilla < $HOME/Thesis/HPC_2020_timeseries.R
mv simulation_timeseries_* $HOME
echo "R has finished running"
#this is a comment at the end of the file