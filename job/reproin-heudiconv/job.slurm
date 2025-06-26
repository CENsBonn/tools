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

flatten_bids_dir_structure() {
  # Copy output/Patterson/Coben/* to output/*
  dataset_description_path="$(find "$output_dir/" -type f -name dataset_description.json | head -n 1)"
  if [[ -z "$dataset_description_path" ]]; then
    >&2 echo "Error: Cannot find a subdirectory containing dataset_description.json in $output_dir"
    exit 1
  fi
  bids_dir="$(dirname "$dataset_description_path")"
  if [[ "$output_dir" != "$bids_dir" ]]; then
    intermediate_dir="$(echo "$bids_dir" | cut -d/ -f1-2)"
    temp_dir="${output_dir}/__temp_bids_dir"
    rm -rf -- "$temp_dir" # In case it already exists for some reason
    mv "$intermediate_dir" "$temp_dir"
    dataset_description_path="$(find "$temp_dir/" -type f -name dataset_description.json | head -n 1)"
    bids_dir="$(dirname "$dataset_description_path")"
    rsync -av --info=progress2 "$bids_dir/" "$output_dir/"
    rm -rf -- "$temp_dir"
  fi
}

source activate base
conda activate "$CONDA_ENV_NAME"

heudiconv \
    --files "${input_dir}" \
    -c dcm2niix \
    --bids \
    -f "$heuristic" \
    --outdir "${output_dir}"

echo "heudiconv exited with code: $?"

flatten_bids_dir_structure

echo "Finished job successfully."
