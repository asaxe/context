#!/bin/bash
#SBATCH --job-name=d8_%a_150
#SBATCH --output=/n/home13/asaxe/context/results/expt8/d8_%a_150.out
#SBATCH --error=/n/home13/asaxe/context/results/expt8/d8_%a_150.err
#SBATCH -t 3-0:00
#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=asaxe@fas.harvard.edu
#SBATCH --mem=6000

cd /Users/asaxe/Documents/postdoctoralwork/context
module load matlab/R2015a-fasrc01
cd /Users/asaxe/Documents/postdoctoralwork/context; matlab-default -nodisplay -nojvm -nodesktop -nosplash -r "addpath('~/context/'),startup,run_ctxt_combined("${SLURM_ARRAY_TASK_ID}",8),exit"
