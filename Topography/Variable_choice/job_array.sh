#!/bin/bash
#SBATCH --job-name=Topography_Varchoice_sp_array
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Topography/Variable_choice/logsout/log_%a.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Topography/Variable_choice/logserr/log_%a.err
#SBATCH --array=1-75
#SBATCH --time=4:30:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity/3.6.3

cd /lustre/badouardv/PhD_cluster/Topography/Variable_choice/
singularity exec ../../Singularity/cmdstanr.sif  Rscript Sampling_sp_array.R ${SLURM_ARRAY_TASK_ID} 2000

