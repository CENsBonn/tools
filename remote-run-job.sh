#!/usr/bin/env bash

set -Eeuo pipefail

get_workspace_directory() {
  workspace="$1"
  python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

input_workspace="$1"
upload_dir="$2"

job_name="$(basename "$upload_dir")"

output_workspace="${input_workspace}_${job_name}_out"
work_workspace="${input_workspace}_${job_name}_work"

ws_allocate "$output_workspace" 7
ws_allocate "$work_workspace" 1

input_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$input_workspace")"
output_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$output_workspace")"
work_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$work_workspace")"

cd "$upload_dir"
ln -s "$input_dir" input
ln -s "$output_dir" output
ln -s "$work_dir" work

slurm_script="scripts/job.slurm"
pre_batch_hook="scripts/pre.sh"

if [ -f "$pre_batch_hook" ]; then
  echo "Executing pre-batch hook..."
  bash "$pre_batch_hook"
fi

sbatch_params=""
if [ -f sbatch_parameters.txt ]; then
  sbatch_params="$(cat sbatch_parameters.txt)"
fi

set -x
sbatch --job-name "$job_name" $sbatch_params "$slurm_script" ${@:3}
set +x
