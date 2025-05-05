#!/bin/bash
#SBATCH --job-name=Topo_Light_Onto_Aggrsp_Res_Moran_array
#SBATCH --account=agap
#SBATCH --partition=agap_normal
#SBATCH --output=/lustre/badouardv/PhD_cluster/Topo_Light_Onto/Autocor_explo/logsout/log_%a.out
#SBATCH --error=/lustre/badouardv/PhD_cluster/Topo_Light_Onto/Autocor_explo/logserr/log_%a.err
#SBATCH --array=1-1
#SBATCH --time=1:30:00
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30G
#SBATCH --mail-user=vincyane.badouard@gmail.com

module purge
module load singularity/3.6.3

cd /lustre/badouardv/PhD_cluster/Topo_Light_Onto/Autocor_explo/
singularity exec /lustre/badouardv/PhD_cluster/Singularity/vincyane.sif  Rscript ResidualExplo_1sp_cluster.R ${SLURM_ARRAY_TASK_ID}

