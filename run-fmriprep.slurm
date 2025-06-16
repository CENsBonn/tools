#!/usr/bin/env bash

#SBATCH --partition=intelsr_short
#SBATCH --cpus-per-task=32
#SBATCH --mem=32000
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --vvv
#SBATCH --time=01:00:00

set -Eeuo pipefail

participant_label="$1"

basedir="$HOME/maindir"
workdir="$basedir/work"
datadir="$basedir/data"
outdir="$basedir/derivatives"
fs_license="$basedir/fmriprep/license.txt"
img="$basedir/fmriprep/fmriprep-25.1.1.simg"

NCORES=32

apptainer run \
	--cleanenv \
	"$img" \
	"$datadir" \
	"$outdir" \
	participant \
	--participant-label "$participant_label" \
	--work-dir "$workdir" \
	--fs-license-file "$fs_license" \
	--fs-no-reconall \
	--write-graph \
	--ignore slicetiming \
	--nprocs "$NCORES"
