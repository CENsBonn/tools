#!/usr/bin/env bash

set -Eeuo pipefail

input_workspace=""
target=""
args_to_slurm=()
while [[ $# -gt 0 ]]; do
  case "$1" in
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
      elif [[ -z "$target" ]]; then
        target="$1"
      else
        >&2 echo "Unexpected positional argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$input_workspace" || -z "$target" ]]; then
  >&2 echo "Usage:   $0 <input_workspace> <slurm_script|directory_containing_slurm_script> -- [<arguments_to_slurm_script>]"
  >&2 echo "Example: $0 reproin ./job/example/job.slurm"
  >&2 echo "Example: $0 reproin ./job/example"
  >&2 echo "Example: $0 reproin ./job/example -- my_argument my_other_argument"
  exit 1
fi

pre_batch_hook=""
if [ -d "$target" ]; then
  slurm_script="$target/job.slurm"
  if [ ! -f "$slurm_script" ]; then
    >&2 echo "No job.slurm file found in directory '$target'. Exiting."
    exit 1
  fi
  if [ -f "${target%/}/pre.sh" ]; then
    pre_batch_hook="${target}/pre.sh"
    echo "Found pre-batch hook: ${pre_batch_hook}"
  fi
else
  slurm_script="$target"
  if [ ! -f "$slurm_script" ]; then
    >&2 echo "File '$slurm_script' does not exist. Exiting."
    exit 1
  fi
fi

SSH_HOST=marvin

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

ssh "$SSH_HOST" mkdir "${upload_dir}/scripts"
rsync -av --info=progress2 "$slurm_script" "${SSH_HOST}:~/${upload_dir}/scripts/"
if [ -n "$pre_batch_hook" ]; then
  rsync -av --info=progress2 "$pre_batch_hook" "${SSH_HOST}:~/${upload_dir}/scripts/"
fi

ssh "$SSH_HOST" ./tools/remote-run-job.sh "$input_workspace" "$upload_dir" "${args_to_slurm[@]}"
