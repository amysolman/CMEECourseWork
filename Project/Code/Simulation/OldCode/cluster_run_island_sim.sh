#!/bin/bash
#Author: Amy Solman amy.solman19@imperial.ac.uk
#Script: cluster_run_island_sim.sh 
#Description: Cluster shell script for neutral simulation
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run! Whoopie!"
cp $HOME/Thesis/neutral_island_simulation.R $TMPDIR
R --vanilla < $HOME/Thesis/HPC_2020_cluster.R
mv simulation_* $HOME
echo "R has finished running"
#this is a comment at the end of the file
