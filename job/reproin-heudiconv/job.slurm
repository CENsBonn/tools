#!/usr/bin/env bash

#SBATCH --output=slurm.out
#SBATCH --partition=intelsr_short
#SBATCH --cpus-per-task=2
#SBATCH --mem=32000
#SBATCH --export=NONE
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --time=01:00:00

set -Eeuo pipefail

CONDA_ENV_NAME="fmri"

input_dir="input"
output_dir="output"
heuristic="reproin"

source activate base
conda activate "$CONDA_ENV_NAME"

readarray -t subjects < subjects.txt  # subjects.txt comes from the pre-batch hook

subject="${subjects[$SLURM_ARRAY_TASK_ID-1]}"

echo "Running HeuDiConv for subject: $subject (array task ID: $SLURM_ARRAY_TASK_ID)"

heudiconv \
    -d "${input_dir}" \
    -c dcm2niix \
    --bids \
    -f "$heuristic" \
    -s "$subject" \
    --outdir "${output_dir}"

echo "heudiconv exited with code: $?"
