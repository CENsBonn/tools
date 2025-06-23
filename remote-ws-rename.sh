#!/usr/bin/env bash

set -Eeuo pipefail

get_workspace_directory() {
  workspace="$1"
  python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

source_workspace="$1"
destination_workspace="$2"
expiry_days="$3"

if [[ -z "$source_workspace" || -z "$destination_workspace" ]]; then
  >&2 echo "Usage: $0 <source_workspace> <destination_workspace>"
  exit 1
fi

source_dir_path="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$source_workspace")"
ws_allocate "$destination_workspace" "$expiry_days"
destination_dir_path="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$destination_workspace")"
rsync -av --info=progress2 "${source_dir_path%/}/" "${destination_dir_path%/}/"
ws_release "$source_workspace"
