# CENS Tools

This repository contains a collection of scripts to facilitate interaction with a remote HPC environment for neuroimaging research, particularly for BIDS data processing with fMRIPrep.

## Table of Contents

- [Initial Setup](#initial-setup)
  - [`configure-remote-connection.sh`](#configure-remote-connectionsh)
  - [`remote-setup-deps.sh`](#remote-setup-depssh)
- [Workspace Management](#workspace-management)
  - [`list-ws.sh`](#list-wssh)
  - [`get-ws-dir.sh`](#get-ws-dirsh)
  - [`rename-ws.sh`](#rename-wssh)
  - [`release-ws.sh`](#release-wssh)
- [Job Management](#job-management)
    - [`run-job.sh`](#run-jobsh)
    - [`list-jobs.sh`](#list-jobssh)
    - [`tail-output.sh`](#tail-outputsh)
    - [`download-output.sh`](#download-outputsh)
- [Data Transfer](#data-transfer)
    - [`upload-input.sh`](#upload-inputsh)
    - [`upload-input-bids.sh`](#upload-input-bidssh)
    - [`upload-license.sh`](#upload-licensesh)
    - [`rsync.sh`](#rsyncsh)
- [BIDS Data Processing](#bids-data-processing)
    - [`bids-validate.sh`](#bids-validatesh)
    - [`bids_postprocess.py`](#bids_postprocesspy)
- [fMRIPrep](#fmriprep)
    - [`build-fmriprep-image.sh`](#build-fmriprep-imagesh)
- [Remote Interaction](#remote-interaction)
    - [`exec-remote.sh`](#exec-remotesh)
    - [`browse-remote.sh`](#browse-remotesh)
- [Utilities](#utilities)
    - [`tree.py`](#treepy)
    - [`ws_list_to_json.py`](#ws_list_to_jsonpy)

## Initial Setup

### `configure-remote-connection.sh`

Configures the SSH connection to the remote HPC cluster. This script adds a new host entry to your `~/.ssh/config` file.

**Usage:**

```bash
./configure-remote-connection.sh <hpc_username> <private_key_path>
```

**Example:**

```bash
./configure-remote-connection.sh sebelin2_hpc ~/.ssh/marvin
```

### `remote-setup-deps.sh`

Sets up the necessary dependencies on the remote server, including Conda, Datalad, BIDS validator, and other tools. This script is designed to be executed on the remote server.

**Usage:**

```bash
./exec-remote.sh ./remote-setup-deps.sh
```

## Workspace Management

Workspaces are temporary storage areas on the HPC cluster.

### `list-ws.sh`

Lists all available workspaces.

**Usage:**

```bash
./list-ws.sh
```

### `get-ws-dir.sh`

Retrieves the directory path of a specified workspace.

**Usage:**

```bash
./get-ws-dir.sh <workspace_name>
```

### `rename-ws.sh`

Renames a workspace.

**Usage:**

```bash
./rename-ws.sh <source_workspace> <destination_workspace> <expiry_days>
```

### `release-ws.sh`

Releases (deletes) one or more workspaces.

**Usage:**

```bash
./release-ws.sh
```

This will open an interactive prompt to select the workspaces to release.

## Job Management

These scripts are used to run and manage jobs on the Slurm scheduler.

### `run-job.sh`

Runs a Slurm job on the remote server. It takes an input workspace and a job script (or a directory containing one) as arguments. It handles creating a job directory, uploading the script, and starting the job.

**Usage:**

```bash
./run-job.sh <input_workspace> <slurm_script|directory_containing_slurm_script> -- [<arguments_to_slurm_script>]
```

**Example:**

```bash
./run-job.sh reproin ./job/example -- my_argument
```

### `list-jobs.sh`

Lists recent jobs submitted to the Slurm scheduler.

**Usage:**

```bash
./list-jobs.sh
```

### `tail-output.sh`

Tails the output of a job on the remote server. By default, it tails the output of the latest job.

**Usage:**

```bash
./tail-output.sh [path_to_slurm_output]
```

### `download-output.sh`

Downloads the output of a job from the remote server.

**Usage:**

```bash
./download-output.sh <job_name> <destination_path>
```

## Data Transfer

### `upload-input.sh`

Uploads a directory to a new workspace on the remote server.

**Usage:**

```bash
./upload-input.sh <source_directory_path> <workspace_name> <expiry_days>
```

### `upload-input-bids.sh`

A specialized version of `upload-input.sh` that validates the presence of `dataset_description.json` before uploading, ensuring it's a BIDS dataset.

**Usage:**

```bash
./upload-input-bids.sh <source_directory_path> <workspace_name> <expiry_days>
```

### `upload-license.sh`

Uploads a FreeSurfer license file to the remote server. This is required for fMRIPrep.

**Usage:**

```bash
./upload-license.sh <path_to_license_file>
```

### `rsync.sh`

A general-purpose script for uploading or downloading files/directories using `rsync`.

**Usage:**

```bash
./rsync.sh <source> <destination>
```

**Example (download):**

```bash
./rsync.sh marvin:~/my_remote_file .
```

**Example (upload):**

```bash
./rsync.sh my_local_file.txt marvin:~/
```

## BIDS Data Processing

### `bids-validate.sh`

Validates a BIDS dataset on the remote server.

**Usage:**

```bash
./bids-validate.sh <workspace>
```

### `bids_postprocess.py`

A Python script to post-process a BIDS dataset, adding or modifying metadata in JSON and other files. This script is intended to be run on a BIDS dataset directory.

**Usage:**

```bash
python3 bids_postprocess.py <path_to_bids_dataset>
```

## fMRIPrep

### `build-fmriprep-image.sh`

Builds an fMRIPrep Singularity image on the remote server.

**Usage:**

```bash
./build-fmriprep-image.sh
```

## Remote Interaction

### `exec-remote.sh`

Executes a local script on the remote server.

**Usage:**

```bash
./exec-remote.sh <local_script_path> [arguments]
```

### `browse-remote.sh`

Starts a local web server to browse a remote directory. This is useful for inspecting HTML reports generated by fMRIPrep.

**Usage:**

```bash
./browse-remote.sh <remote_directory>
```

## Utilities

### `tree.py`

A Python script to display a directory tree, similar to the `tree` command.

**Usage:**

```bash
python3 tree.py <directory_path>
```

### `ws_list_to_json.py`

A helper script that converts the output of the `ws_list` command to JSON format. This is used internally by other scripts.
