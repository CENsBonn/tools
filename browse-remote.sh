#!/usr/bin/env bash

# Usage: ./browse-remote.sh <remote-dir>
# Example: ./browse-remote.sh /path/to/fmriprep/output

set -Eeuo pipefail

REMOTE_DIR="$1"
REMOTE_HOST="marvin"
REMOTE_PORT=8000
LOCAL_PORT=8080

# Command to run the remote HTTP server
REMOTE_CMD="cd '$REMOTE_DIR' && python3 -m http.server $REMOTE_PORT"

# Start HTTP server on remote in background
echo "[INFO] Starting HTTP server on $REMOTE_HOST:$REMOTE_PORT..."
ssh "$REMOTE_HOST" "$REMOTE_CMD" > /dev/null 2>&1 &
REMOTE_PID=$!

# Wait a moment to ensure remote server starts
sleep 1

# Handle cleanup on CTRL+C
cleanup() {
  echo
  echo "[INFO] Cleaning up..."
  echo "[INFO] Killing local tunnel (PID $TUNNEL_PID)..."
  kill "$TUNNEL_PID" 2>/dev/null || true
  echo "[INFO] Killing remote HTTP server..."
  ssh "$REMOTE_HOST" "pkill -f 'python3 -m http.server $REMOTE_PORT'" || true
  echo "[INFO] Done."
  exit
}
trap cleanup INT

# Start local port forwarding
ssh -L "$LOCAL_PORT:localhost:$REMOTE_PORT" "$REMOTE_HOST" -N &
TUNNEL_PID=$!

echo "[INFO] You can now browse http://localhost:$LOCAL_PORT"

wait "$TUNNEL_PID"

# Keep script running until interrupted
tail -f /dev/null
