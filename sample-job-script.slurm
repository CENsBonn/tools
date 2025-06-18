#!/usr/bin/env bash

#SBATCH --job-name=sample-cens-job
#SBATCH --output=slurm.out
#SBATCH --time=00:00:10
#SBATCH --partition=intelsr_devel
#SBATCH --ntasks=3
#SBATCH --mail-type=END,FAIL,TIME_LIMIT

set -Eeuo pipefail

echo "Running sample job script with arguments:" "$@"

ls input/ > output/generated_by_sample_job.txt
