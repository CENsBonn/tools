#!/usr/bin/env bash

set -Eeuo pipefail

input_workspace="$1"
upload_dir="$2"

job_name="$(basename "$upload_dir")"

output_workspace="${input_workspace}_${job_name}_out"
work_workspace="${input_workspace}_${job_name}_work"

ws_allocate "$output_workspace" 7
ws_allocate "$work_workspace" 1

cd "$upload_dir"
slurm_script="$(ls ./*.slurm)"
echo "HOY[${@:3}]"
sbatch "$slurm_script"
