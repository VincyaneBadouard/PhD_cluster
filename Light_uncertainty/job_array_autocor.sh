#!/bin/bash
#SBATCH --job-name=Light_uncertainty
#SBATCH --account=dedicated-cpu@cirad-normal
#SBATCH --partition=cpu-dedicated
#SBATCH --output=logsout/log_%a.out
#SBATCH --error=logserr/log_%a.err
#SBATCH --array=1-200
#SBATCH --time=5:00:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity

cd /scratch/users/badouardv/PhD_cluster/Light_uncertainty/
singularity exec ../Singularity/cmdstanr.sif  Rscript Sampling_eigenvectors.R ${SLURM_ARRAY_TASK_ID} 2000

