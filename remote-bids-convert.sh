#!/usr/bin/env bash

get_workspace_directory() {
	workspace="$1"
	python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

input_workspace="social-detection-7t-bids"
output_dir="/lustre/scratch/data/sebelin2_hpc-social-detection-7t-bids/"

ws_allocate "$input_workspace" 50

input_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$input_workspace")"

heudiconv \
	--files "${input_dir}/sub-130/*.dcm" \
	-s 130 \
	--bids \
	-f heuristics/7t.py \
	-o "$output_dir"
