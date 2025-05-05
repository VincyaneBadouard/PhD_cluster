#!/bin/bash
#SBATCH --job-name=Topo_Light_Onto_Aggrsp_sampling_balance
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Topo_Light_Onto/Autocor_explo/logsout/log_%a.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Topo_Light_Onto/Autocor_explo/logserr/log_%a.err
#SBATCH --array=1-75
#SBATCH --time=1:30:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity/3.6.3

cd /lustre/badouardv/PhD_cluster/Topo_Light_Onto/Autocor_explo/
singularity exec /lustre/badouardv/PhD_cluster/Singularity/cmdstanr.sif  Rscript Sampling_balance.R ${SLURM_ARRAY_TASK_ID} 2000

