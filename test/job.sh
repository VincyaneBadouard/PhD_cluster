#!/bin/bash
#SBATCH --job-name=cmdstanr
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/test/cmdstanr.out
#SBATCH --error=/lustre/badouardv/test/cmdstanr.err
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=4

module purge
module load singularity/3.6.3
cd /lustre/badouardv/test/
singularity exec cmdstanr.sif  Rscript script.R toto
