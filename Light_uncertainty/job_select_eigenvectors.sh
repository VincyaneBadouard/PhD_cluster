#!/bin/bash
#SBATCH --job-name=Select_eigenvectors
#SBATCH --account=dedicated-cpu@cirad-long
#SBATCH --partition=cpu-dedicated
#SBATCH --output=logsout/log_%a.out
#SBATCH --error=logserr/log_%a.err
#SBATCH --array=1-200
#SBATCH --time=50:00:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity

cd /scratch/users/badouardv/PhD_cluster/Light_uncertainty/
singularity exec ../Singularity/glmnet.sif  Rscript Select_eigenvectors_per_sp.R ${SLURM_ARRAY_TASK_ID}

