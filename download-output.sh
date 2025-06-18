#!/usr/bin/env bash

set -Eeuo pipefail

SSH_HOST=marvin

if [ $# != 2 ]; then
  >&2 echo "Usage:   $0 <job_name> <destination_path>"
  >&2 echo "Example: $0 job_20250618_135407_4Frr out"
  >&2 echo "Example: $0 - out"
  exit 1
fi

job_name="$1"
destination_path="$2"

if [ "$job_name" = '-' ]; then
  job_line="$(ssh "$SSH_HOST" sacct --allocations --starttime "$(date -d '7 days ago' '+%Y-%m-%dT%H:%M:%S')" --endtime now --format=JobName%25,Start,Elapsed,State --noheader | fzf --no-sort --tac)"
  job_name=$(echo "$job_line" | awk '{print $1}')
fi

while ssh marvin squeue --me --json | jq -r -e '.jobs[].name' | grep -qx "$job_name"; do
  timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
  echo "[${timestamp}] Waiting for job $job_name to finish..."
  sleep 5
done

output_dir_path="jobs/${job_name}/output"

rsync -av --info=progress2 "${SSH_HOST}:${output_dir_path%/}/" "$destination_path"
