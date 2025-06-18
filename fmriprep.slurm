#!/usr/bin/env bash

#SBATCH --output=slurm.out
#SBATCH --partition=intelsr_short
#SBATCH --cpus-per-task=32
#SBATCH --mem=32000
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --time=03:00:00

set -Eeuo pipefail

NCORES=32

participant_label="$1"

input_dir="input"
output_dir="output"
work_dir="work"

resources_dir="$HOME/fmriprep"
fs_license="$resources_dir/license.txt"
img="$resources_dir/fmriprep-25.1.1.simg"

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
	--participant-label "$participant_label" \
	--work-dir "/work" \
	--fs-license-file "/resources/$(basename "$fs_license")" \
	--write-graph \
	--ignore slicetiming \
	--nprocs "$NCORES"
