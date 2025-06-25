#!/usr/bin/env bash

#SBATCH --output=slurm.out
#SBATCH --time=00:00:10
#SBATCH --partition=intelsr_devel
#SBATCH --ntasks=3
#SBATCH --mail-type=END,FAIL,TIME_LIMIT

set -Eeuo pipefail

input_dir="input"
output_dir="output"
work_dir="work"

echo "Running sample job script with arguments:" "$@"

echo "Input directory: $input_dir"
echo "Output directory: $output_dir"
echo "Work directory: $work_dir"

echo "The $input_dir directory contains $(find "$input_dir/" -type f | wc -l) files." > "$output_dir/generated_by_sample_job.txt"
