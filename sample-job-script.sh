#!/usr/bin/env bash
#SBATCH --job-name=sebelino-job
#SBATCH --time=00:00:10
#SBATCH --partition=intelsr_devel
#SBATCH --ntasks=3

echo "This file was created using a SLURM job" > "$HOME/generated_by_slurm.txt"
