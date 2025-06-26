#!/usr/bin/env bash

set -Eeuo pipefail

CONDA_ENV_NAME="fmri"

get_workspace_directory() {
  workspace="$1"
  python3 -c "import sys, json; data=json.load(sys.stdin); print(data[\"${workspace}\"][\"workspace_directory\"])"
}

if [ $# != 1 ]; then
  >&2 echo "Usage:   $0 <target_directory>"
  >&2 echo "Example: $0 ./my_bids_dataset/"
  exit 1
fi

target_dir="$1"

source activate base
conda activate "$CONDA_ENV_NAME"

deno run -ERWN jsr:@bids/validator "$target_dir"
