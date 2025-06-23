#!/usr/bin/env bash

set -Eeuo pipefail

CONDA_ENV_NAME="fmri"

get_workspace_directory() {
	workspace="$1"
	python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

input_workspace="$1"
output_workspace="$2"
heuristic="$3"

ws_allocate "$output_workspace" 50

input_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$input_workspace")"
output_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$output_workspace")"

source activate base
conda activate "$CONDA_ENV_NAME"

heudiconv \
	--files "${input_dir}" \
	--bids \
	-f "$heuristic" \
	-o "$output_dir"
