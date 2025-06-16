#!/usr/bin/env bash

set -Eeuo pipefail

fs_license_source="$1"

FMRIPREP_VERSION=20.2.0

basedir="$HOME/maindir"
workdir="$basedir/work"
datadir="$basedir/data"
outdir="$basedir/derivatives"
fmriprep_dir="$basedir/fmriprep"
fs_license_destination="$fmriprep_dir/license.txt"
img="$fmriprep_dir/fmriprep-${FMRIPREP_VERSION}.simg"

mkdir -p "$workdir" "$datadir" "$outdir" "$fmriprep_dir"

cp "$fs_license_source" "$fs_license_destination"

if [ ! -f "$img" ]; then
	cd "$fmriprep_dir"
	singularity build "$img" "docker://poldracklab/fmriprep:${FMRIPREP_VERSION}"
else
	echo "$img is already built."
fi
