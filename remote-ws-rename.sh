#!/usr/bin/env bash

set -Eeuo pipefail

get_workspace_directory() {
  workspace="$1"
  python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

if [ "$#" = 2 ]; then
  >&2 echo "Usage:   $0 <source_workspace> <destination_workspace> <expiry_days>"
  >&2 echo "Example: $0 reproin_job_20250625_150428_ilac_out reproin-bids 7"
  exit 1
fi

source_workspace="$1"
destination_workspace="$2"
expiry_days="$3"

source_dir_path="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$source_workspace")"
ws_allocate "$destination_workspace" "$expiry_days"
destination_dir_path="$(ws_list | "$HOME/tools/ws_list_to_json.py" | get_workspace_directory "$destination_workspace")"
rsync -av --info=progress2 "${source_dir_path%/}/" "${destination_dir_path%/}/"
ws_release "$source_workspace"
