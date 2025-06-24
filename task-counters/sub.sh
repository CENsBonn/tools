#!/usr/bin/env bash

# Counts the number of directories starting with "sub-" within the input directory.
#
# Input: Path to a directory containing data to be processed by SLURM.
# Output: An integer representing the number of SLURM tasks to be generated to process the data.

set -Eeuo pipefail

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <input_directory>"
	exit 1
fi

input_directory="$1"

task_count=$(find "$input_directory" -maxdepth 1 -type d -name 'sub-*' | wc -l)

echo "$task_count"
