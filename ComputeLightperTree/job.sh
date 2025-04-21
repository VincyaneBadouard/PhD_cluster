#!/bin/sh
#SBATCH --job-name=test
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=agap_normal
#SBATCH --time=01:00:00
#SBATCH --array=1-10
#SBATCH --mem=10G
module purge
module load R/packages/4.3.1

set -vx

DATA_DIR="/cirad_lotois/work/users/VincyaneBadouard/Lidar/ALS2023/HighAltitudeFlight"
SCRATCH_DIR="/lustre/badouardv/lightpertree"

#mkdir ${SCRATCH_DIR}
cp -r ${DATA_DIR}/ByTree* ${SCRATCH_DIR}
cd ${SCRATCH_DIR}/ByTree_scripts

Rscript LightPerTree4cluster.R ${SLURM_ARRAY_TASK_ID}

#mv ../ByTree_Output/* ${DATA_DIR}/ByTree_Output/


