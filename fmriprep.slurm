#!/usr/bin/env bash

#SBATCH --partition=intelsr_short
#SBATCH --cpus-per-task=32
#SBATCH --mem=32000
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --time=01:00:00

set -Eeuo pipefail

NCORES=32
PARTICIPANT_LABEL="sub-001"

input_dir="$1"
output_dir="$2"
work_dir="$3"

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
	--participant-label "$PARTICIPANT_LABEL" \
	--work-dir "/work" \
	--fs-license-file "/resources/$(basename "$fs_license")" \
	--write-graph \
	--ignore slicetiming \
	--nprocs "$NCORES"
