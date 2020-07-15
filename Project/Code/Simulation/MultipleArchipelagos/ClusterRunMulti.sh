#!/bin/bash
#Author: Amy Solman amy.solman19@imperial.ac.uk
#Script: ClusterRunMulti.sh 
#Description: Cluster shell script for neutral simulation
#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run! Whoopie!"
cp $HOME/Thesis/ClusterSimMulti.R $TMPDIR
R --vanilla < $HOME/Thesis/ClusterCodeMulti.R
mv simulation_timeseries_* $HOME
echo "R has finished running"
#this is a comment at the end of the file