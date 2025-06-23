#!/usr/bin/env bash

set -Eeuo pipefail

get_workspace_directory() {
	workspace="$1"
	python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

input_workspace="$1"
output_workspace="$2"

ws_allocate "$output_workspace" 50

input_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$input_workspace")"
output_dir="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$output_workspace")"

heudiconv \
	--files "${input_dir}/**/*.dcm" \
	-s 130 \
	--bids \
	-f heuristics/7t.py \
	-o "$output_dir"
