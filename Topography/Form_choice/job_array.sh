#!/bin/bash
#SBATCH --job-name=Topography_Formchoice_sp_array
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Topography/Form_choice/log_%a.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Topography/Form_choice/log_%a.err
#SBATCH --array=1-2
#SBATCH --time=1:00:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4

module purge
module load singularity/3.6.3

cd /lustre/badouardv/PhD_cluster/Topography/Form_choice/
singularity exec ../../Singularity/cmdstanr.sif  Rscript Sampling_sp_array.R ${SLURM_ARRAY_TASK_ID} 10

