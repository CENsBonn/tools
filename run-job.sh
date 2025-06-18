#!/usr/bin/env bash

set -Eeuo pipefail

if [[ $# -lt 2 ]]; then
  >&2 echo "Usage:   $0 <input_workspace> <slurm_script>"
  >&2 echo "Example: $0 reproin sample-job-script.slurm"
  exit 1
fi

SSH_HOST=marvin

input_workspace="$1"
slurm_script="$2"

upload_dir="jobs/job_$(date +%Y%m%d_%H%M%S)"

ssh marvin "[ -d tools ] || git clone https://github.com/CENsBonn/tools"
ssh marvin mkdir -p "$upload_dir"
echo "Created job directory: $upload_dir"
ssh marvin rm -f "jobs/latest"
ssh marvin ln -s "$(basename "$upload_dir")" "jobs/latest"
rsync -av --info=progress2 "$slurm_script" "${SSH_HOST}:~/${upload_dir}"
ssh marvin ./tools/remote-run-job.sh "$input_workspace" "$upload_dir" "${@:3}"
