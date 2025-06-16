#!/usr/bin/env bash

set -Eeuo pipefail

CONDA_ENV_NAME="remote"

if [ -d main-dir ]; then
	echo "Directory 'main-dir' already exists on the remote. Skipping clone."
else
	git clone https://github.com/CENsBonn/tools main-dir
fi


if conda info --envs | grep -q -w "$CONDA_ENV_NAME"; then
	echo "Conda environment '$CONDA_ENV_NAME' already exists. Skipping conda setup."
else
	module load Miniforge3
	conda init
	source "$HOME/.bashrc"
	conda create -y -n remote
	conda activate remote
	conda install -y -c conda-forge jq
fi

ws_allocate input 1
ws_allocate output 1
ws_allocate temp 1
