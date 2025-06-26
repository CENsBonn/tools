#!/usr/bin/env bash

set -Eeuo pipefail

get_workspace_directory() {
  workspace="$1"
  python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

if [ $# != 1 ]; then
  >&2 echo "Usage:   $0 <workspace>"
  >&2 echo "Example: $0 reproin-bids"
  exit 1
fi

SSH_HOST=marvin

workspace="$1"

script_dir="$(dirname "$(readlink -f "$0")")"

dir_path="$(ssh "$SSH_HOST" ws_list | "${script_dir}/ws_list_to_json.py" | jq -r ".\"${workspace}\".workspace_directory")"

"${script_dir}/exec-remote.sh" "${script_dir}/remote-bids-validate.sh" "$dir_path"
