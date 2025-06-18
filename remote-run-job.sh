#!/usr/bin/env bash

set -Eeuo pipefail

get_workspace_directory() {
	python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${output_workspace}\"][\"workspace_directory\"])"
}

input_workspace="$1"
upload_dir="$2"

job_name="$(basename "$upload_dir")"

output_workspace="${input_workspace}_${job_name}_out"
work_workspace="${input_workspace}_${job_name}_work"

ws_allocate "$output_workspace" 7
ws_allocate "$work_workspace" 1

output_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory)"
work_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory)"

cd "$upload_dir"
slurm_script="$(ls ./*.slurm)"
sbatch "$slurm_script" "$output_dir" "$work_dir" ${@:3}
