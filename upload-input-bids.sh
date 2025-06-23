#!/usr/bin/env bash

set -Eeuo pipefail

if [ $# != 3 ]; then
  >&2 echo "Usage:   $0 <source_directory_path> <workspace_name> <expiry_days>"
  >&2 echo "Example: $0 ./my_dataset/ my_dataset 14"
  exit 1
fi

source_path="$1"

if [ ! -f "${source_path}/dataset_description.json" ]; then
  >&2 echo "Error: Missing file: ${source_path}/dataset_description.json"
  exit 1
fi

script_dir="$(dirname "$(readlink -f "$0")")"

"${script_dir}/upload-input.sh" "$1" "$2" "$3"
