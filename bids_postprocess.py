#!/usr/bin/env python3

import json
import sys
from pathlib import Path

# --- CONFIGURE YOUR VALUES HERE ---
TASK_DESCRIPTION = "Social detection task"
INSTRUCTIONS = "Respond to stimuli as instructed."
COGPOID = "http://www.cogpo.org/id/some_term"
DATASET_NAME = "Social detection 7T dataset"
GENERATED_BY = [{"Name": "HeuDiConv", "Version": "1.3.3"}]

# --- PATH TO YOUR BIDS DATASET ---
bids_root = Path(sys.argv[1])

# --- PATCH dataset_description.json ---
desc_file = bids_root / "dataset_description.json"
if desc_file.exists():
    with open(desc_file, "r+") as f:
        desc = json.load(f)
        desc.setdefault("DatasetType", "raw")
        desc.setdefault("GeneratedBy", GENERATED_BY)
        desc.setdefault("Name", DATASET_NAME)
        f.seek(0)
        json.dump(desc, f, indent=4)
        f.truncate()
else:
    # Create from scratch if missing
    with open(desc_file, "w") as f:
        json.dump({
            "Name": DATASET_NAME,
            "BIDSVersion": "1.8.0",
            "DatasetType": "raw",
            "GeneratedBy": GENERATED_BY
        }, f, indent=4)

# --- PATCH README ---
readme_file = bids_root / "README"
if not readme_file.exists() or readme_file.stat().st_size < 10:
    with open(readme_file, "w") as f:
        f.write("This dataset contains 7T MRI data for a social detection task.\n")

# --- PATCH all sidecar JSON files ---
for json_file in bids_root.rglob("*.json"):
    if ".heudiconv" in json_file.parts:
        continue  # Skip internal heudiconv files
    with open(json_file, "r+") as f:
        data = json.load(f)
        # Add recommended fields where appropriate
        if "bold" in json_file.name:
            data.setdefault("TaskDescription", TASK_DESCRIPTION)
            data.setdefault("Instructions", INSTRUCTIONS)
            data.setdefault("CogPOID", COGPOID)
            data.setdefault("NumberOfVolumesDiscardedByScanner", 0)
            data.setdefault("NumberOfVolumesDiscardedByUser", 0)
        if "T1w" in json_file.name:
            data.setdefault("ParallelReductionFactorOutOfPlane", 1)
        f.seek(0)
        json.dump(data, f, indent=4)
        f.truncate()

# --- PATCH events.json if events.tsv exists ---
for tsv in bids_root.rglob("*_events.tsv"):
    json_path = tsv.with_suffix(".json")
    if not json_path.exists():
        with open(json_path, "w") as f:
            json.dump({
                "onset": {"Description": "Onset of the event in seconds"},
                "duration": {"Description": "Duration of the event in seconds"},
                "trial_type": {"Description": "Type of trial"}
            }, f, indent=4)

print("✅ BIDS post-processing complete.")
