#!/bin/bash
#SBATCH --job-name=Light_uncertainty
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Light_uncertainty/logsout/log_%a.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Light_uncertainty/logserr/log_%a.err
#SBATCH --array=1-20
#SBATCH --time=5:00:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity/3.6.3

cd /lustre/badouardv/PhD_cluster/Light_uncertainty/
singularity exec ../Singularity/cmdstanr.sif  Rscript Sampling_eigenvectors.R ${SLURM_ARRAY_TASK_ID} 2000

