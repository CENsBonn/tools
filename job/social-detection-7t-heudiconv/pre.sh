#!/usr/bin/env bash

# Counts the number of directories starting with "sub-" within the input directory.
#
# Input: Path to a directory containing data to be processed by SLURM.
# Output: Files: `subjects.txt` and `sbatch_parameters.txt`.

set -Eeuo pipefail

input_directory="input"

find "${input_directory%/}/" -maxdepth 1 -type d -name 'sub-*' | cut -d '-' -f2 > subjects.txt
task_count="$(wc -l < subjects.txt)"

if [ "$task_count" -eq 0 ]; then
  echo "No subjects found in the input directory."
  exit 1
fi

if [ "$task_count" -eq 1 ]; then
  echo -n "" > sbatch_parameters.txt
else
  echo -n "--array=1-$task_count" > sbatch_parameters.txt
fi
