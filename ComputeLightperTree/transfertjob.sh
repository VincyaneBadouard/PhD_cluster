#!/bin/sh
#SBATCH --job-name=transfert
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=agap_normal
#SBATCH --time=01:00:00

module purge

set -vx

SCRATCH_DIR="/lustre/badouardv/lightpertree"
OUTPUT_DIR="/nfs/work/agap/AMAP/badouardv/ByTree_Output"

mv $SCRATCH_DIR/ByTree_Output/Tree_Light/* ${OUTPUT_DIR}/Tree_Light/
mv $SCRATCH_DIR/ByTree_Output/Tree_Vox/* ${OUTPUT_DIR}/Tree_Vox/
mv $SCRATCH_DIR/ByTree_Output/Tree_XML/* ${OUTPUT_DIR}/Tree_XML/
