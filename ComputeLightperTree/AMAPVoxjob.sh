#!/bin/sh
#SBATCH --job-name=AMAPVoxrun
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=agap_normal
#SBATCH --time=10:00:00
#SBATCH --mem=16G
module purge
module load R/packages/4.3.1

set -vx

DATA_DIR="/cirad_lotois/work/users/VincyaneBadouard/Lidar/ALS2023/HighAltitudeFlight"
SCRATCH_DIR="/lustre/badouardv/ForTrees"

#mkdir ${SCRATCH_DIR}
#cp -r ${DATA_DIR}/ForTrees* ${SCRATCH_DIR}/
cd ${SCRATCH_DIR}/

Rscript AMAPVox_run.R

#mv ../ByTree_Output/* ${DATA_DIR}/ByTree_Output/