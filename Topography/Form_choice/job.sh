#!/bin/bash
#SBATCH --job-name=cmdstanr
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Topography/Form_choice/log.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Topography/Form_choice/log.err
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=4

module purge
module load singularity/3.6.3
cd /lustre/badouardv/PhD_cluster/Topography/Form_choice/
singularity exec ../../Singularity/cmdstanr.sif  Rscript Sampling.R "Symphonia_sp.1" 10

