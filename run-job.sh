#!/usr/bin/env bash

set -Eeuo pipefail

if [[ $# -lt 2 ]]; then
  >&2 echo "Usage:   $0 <input_workspace> <slurm_script> [<arguments_to_slurm_script>]"
  >&2 echo "Example: $0 reproin sample-job-script.slurm"
  exit 1
fi

SSH_HOST=marvin

input_workspace="$1"
slurm_script="$2"

if ! ssh "$SSH_HOST" ws_list | ./ws_list_to_json.py | jq -e "has(\"${input_workspace}\")" >/dev/null; then
  >&2 echo "Workspace '${input_workspace}' does not exist. Exiting."
  exit 1
fi

random_str="$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c4)"
upload_dir="jobs/job_$(date +%Y%m%d_%H%M%S)_${random_str}"

ssh "$SSH_HOST" "[ -d tools ] || git clone https://github.com/CENsBonn/tools"
ssh "$SSH_HOST" mkdir -p "$upload_dir"
echo "Created job directory: $upload_dir"
ssh "$SSH_HOST" rm -f "jobs/latest"
ssh "$SSH_HOST" ln -s "$(basename "$upload_dir")" "jobs/latest"
rsync -av --info=progress2 "$slurm_script" "${SSH_HOST}:~/${upload_dir}"
ssh "$SSH_HOST" ./tools/remote-run-job.sh "$input_workspace" "$upload_dir" "${@:3}"
