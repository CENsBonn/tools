#!/usr/bin/env bash

set -Eeuo pipefail

input_dir="input"

participant_labels="$(cut -f1 "${input_dir}/participants.tsv" | tail -n +2)"
echo "$participant_labels" > subjects.txt
task_count="$(wc -l < subjects.txt)"

if [ "$task_count" -eq 0 ]; then
  echo "No subjects found in the input directory."
  exit 1
fi

echo -n "--array=1-$task_count" > sbatch_parameters.txt
