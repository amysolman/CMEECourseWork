#!/bin/bash
#Author: Amy Solman amy.solman19@imperial.ac.uk
#Script: ClusterShell_periSeven.sh 
#Description: Cluster shell script for perimeter model simulation
#PBS -l walltime=48:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run! Whoopie!"
cp $HOME/Thesis/Simulation_peri.R $TMPDIR
R --vanilla < $HOME/Thesis/RunSim_periSeven.R
mv simulation_peri_seven_* $HOME
echo "R has finished running"
#this is a comment at the end of the file