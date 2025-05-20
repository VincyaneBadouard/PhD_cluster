#!/bin/bash
#SBATCH --job-name=Topo_Light_Onto_sp_array
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Topo_Light_Onto/logsout/log_%a.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Topo_Light_Onto/logserr/log_%a.err
#SBATCH --array=1-75
#SBATCH --time=3:00:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity/3.6.3

cd /lustre/badouardv/PhD_cluster/Topo_Light_Onto/
singularity exec ../Singularity/cmdstanr.sif  Rscript Sampling_sp_array.R ${SLURM_ARRAY_TASK_ID} 2000

