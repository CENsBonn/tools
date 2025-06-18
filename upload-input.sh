#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

if [ $# != 3 ]; then
  >&2 echo "Usage:   $0 <source_directory_path> <workspace_name> <expiry_days>"
  >&2 echo "Example: $0 ./my_dataset/ my_dataset 14"
  exit 1
fi

source_path="$1"
workspace_name="$2"
expiry_days="$3"

if [ ! -f "${source_path}/dataset_description.json" ]; then
  >&2 echo "Error: Missing file: ${source_path}/dataset_description.json"
  exit 1
fi

script_dir="$(dirname "$0")"

input_dir_path="$(ssh "$SSH_HOST" ws_list | "${script_dir}/ws_list_to_json.py" | jq -r ".\"${workspace_name}\".workspace_directory")"

if [ "$input_dir_path" != "null" ]; then
  >&2 echo "Error: Workspace '${workspace_name}' already exists."
  exit 1
fi

ssh "$SSH_HOST" ws_allocate "$workspace_name" "$expiry_days"

input_dir_path="$(ssh "$SSH_HOST" ws_list | "${script_dir}/ws_list_to_json.py" | jq -r ".\"${workspace_name}\".workspace_directory")"

rsync -av --info=progress2 "${source_path%/}/" "${SSH_HOST}:${input_dir_path}"
