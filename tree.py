#!/usr/bin/env python3

import os
import sys

def tree(dir_path, prefix=""):
    entries = list(os.scandir(dir_path))
    entries_count = len(entries)
    for i, entry in enumerate(entries):
        connector = "├── " if i < entries_count - 1 else "└── "
        print(prefix + connector + entry.name)
        if entry.is_dir(follow_symlinks=False):
            extension = "│   " if i < entries_count - 1 else "    "
            tree(entry.path, prefix + extension)

if __name__ == "__main__":
    directory = sys.argv[1] if len(sys.argv) > 1 else "."
    print(directory)
    tree(directory)
