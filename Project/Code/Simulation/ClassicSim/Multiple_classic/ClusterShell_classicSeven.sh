#!/bin/bash
#Author: Amy Solman amy.solman19@imperial.ac.uk
#Script: ClusterShell_classicSeven.sh 
#Description: Cluster shell script for neutral simulation
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run! Whoopie!"
cp $HOME/Thesis/Simulation_classic.R $TMPDIR
R --vanilla < $HOME/Thesis/RunSim_classicSeven.R
mv simulation_classic_seven_* $HOME
echo "R has finished running"
#this is a comment at the end of the file