import json
import sys

def parse_ws_list(input_lines):
    workspaces = {}
    current_id = None
    current_data = {}

    for line in input_lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith("id:"):
            if current_id:
                workspaces[current_id] = current_data
            current_id = line.split(":", 1)[1].strip()
            current_data = {}
        elif ":" in line:
            key, value = line.split(":", 1)
            key = key.strip().replace(" ", "_")
            value = value.strip()
            current_data[key] = value

    if current_id:
        workspaces[current_id] = current_data

    return workspaces

def main():
    input_lines = sys.stdin.readlines()
    parsed_data = parse_ws_list(input_lines)
    json_output = json.dumps(parsed_data, indent=2)
    print(json_output)

if __name__ == "__main__":
    main()
