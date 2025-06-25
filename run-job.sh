#!/usr/bin/env bash

set -Eeuo pipefail

pre_batch_hook=""

input_workspace=""
slurm_script=""
args_to_slurm=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p)
      pre_batch_hook="$2"
      shift 2
      ;;
    --)
      shift
      args_to_slurm=("$@")
      break
      ;;
    -*)
      >&2 echo "Unknown option: $1"
      exit 1
      ;;
    *)
      if [[ -z "$input_workspace" ]]; then
        input_workspace="$1"
      elif [[ -z "$slurm_script" ]]; then
        slurm_script="$1"
      else
        >&2 echo "Unexpected positional argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$input_workspace" || -z "$slurm_script" ]]; then
  >&2 echo "Usage:   $0 <input_workspace> <slurm_script> [-p pre_batch_hook_script] -- [<arguments_to_slurm_script>]"
  >&2 echo "Example: $0 reproin ./job/sample-job-script.slurm"
  exit 1
fi

SSH_HOST=marvin

if ! ssh "$SSH_HOST" ws_list | ./ws_list_to_json.py | jq -e "has(\"${input_workspace}\")" >/dev/null; then
  >&2 echo "Workspace '${input_workspace}' does not exist. Exiting."
  exit 1
fi

random_str="$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c4)"
upload_dir="jobs/job_$(date +%Y%m%d_%H%M%S)_${random_str}"

if [ -z "$pre_batch_hook" ]; then
  pre_batch_hook="__NONE__"
fi

ssh "$SSH_HOST" "[ -d tools ] || git clone https://github.com/CENsBonn/tools"
ssh "$SSH_HOST" mkdir -p "$upload_dir"
echo "Created job directory: $upload_dir"
ssh "$SSH_HOST" rm -f "jobs/latest"
ssh "$SSH_HOST" ln -s "$(basename "$upload_dir")" "jobs/latest"
rsync -av --info=progress2 "$slurm_script" "${SSH_HOST}:~/${upload_dir}"
ssh "$SSH_HOST" ./tools/remote-run-job.sh "$input_workspace" "$upload_dir" "$pre_batch_hook" "${args_to_slurm[@]}"
