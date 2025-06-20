#!/usr/bin/env bash

set -Eeuo pipefail

CONDA_ENV_NAME="fmri"

if conda info --envs | grep -q -w "$CONDA_ENV_NAME"; then
  echo "Conda environment '$CONDA_ENV_NAME' already exists. Skipping conda setup."
else
  module load Miniforge3
  conda init
  source "$HOME/.bashrc"
  conda create -y -n "$CONDA_ENV_NAME"
  conda activate "$CONDA_ENV_NAME"
  conda install -c conda-forge dcm2niix
  conda install -y -c conda-forge datalad
  conda install -y -c conda-forge bids-validator
  conda install -y -c conda-forge deno
  pip install heudiconv
  pip install fmriprep-docker
fi
