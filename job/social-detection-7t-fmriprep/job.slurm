#!/usr/bin/env bash

#SBATCH --output=slurm.out
#SBATCH --partition=intelsr_medium
#SBATCH --cpus-per-task=32
#SBATCH --mem=32000
#SBATCH --export=NONE
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --time=10:00:00

set -Eeuo pipefail

NCORES=32

input_dir="input"
output_dir="output"
work_dir="work"

resources_dir="$HOME/fmriprep"
fs_license="$resources_dir/license.txt"
img="$resources_dir/fmriprep-25.1.1.simg"

readarray -t subjects < subjects.txt  # subjects.txt comes from the pre-batch hook
subject="${subjects[$SLURM_ARRAY_TASK_ID-1]}"
echo "Running HeuDiConv for subject: $subject (array task ID: $SLURM_ARRAY_TASK_ID)"

apptainer run \
	--cleanenv \
	--bind "$input_dir:/data" \
	--bind "$output_dir:/output" \
	--bind "$work_dir:/work" \
	--bind "$resources_dir:/resources" \
	"$img" \
	"/data" \
	"/output" \
	participant \
	--participant-label "$subject" \
	--work-dir "/work" \
	--fs-license-file "/resources/$(basename "$fs_license")" \
	--write-graph \
	--ignore slicetiming \
	--dummy-scans 5 \
	--output-spaces MNI152NLin2009cAsym:res-1.7 \
	--nprocs "$NCORES"

echo "apptainer exited with code: $?"
