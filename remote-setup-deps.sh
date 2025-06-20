#!/usr/bin/env bash

set -Eeuo pipefail

CONDA_ENV_NAME="fmri"

setup_deps() {
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
}


if ! which conda; then
  setup_deps
elif ! conda info --envs | grep -q -w "$CONDA_ENV_NAME"; then
  setup_deps
else
  echo "Conda environment '$CONDA_ENV_NAME' already exists. Skipping conda setup."
fi
