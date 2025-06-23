#!/bin/bash
set -euo pipefail

exec > >(tee export_pipeline.log) 2>&1

echo "Starting export pipeline..."

# Ensure required scripts exist
for SCRIPT in \
  create_dot_export.py \
  export_bridge.py \
  export_manifest.py \
  export_whisperbus_archive.py; do
  if [ ! -f "$SCRIPT" ]; then
    echo "ERROR: required script '$SCRIPT' not found."
    exit 1
  fi
done

echo "Installing required Python packages..."
python3 -m pip install --upgrade pip
python3 -m pip install networkx pydot

echo "Verifying Graphviz 'dot' command..."
if ! command -v dot &> /dev/null; then
  echo "ERROR: 'dot' command not found. Install Graphviz."
  exit 1
fi

echo "Generating DOT file..."
python3 create_dot_export.py

echo "Generating bridge checkpoints..."
python3 export_bridge.py --out-bridge checkpoint_bridge.json --out-bus checkpoint_bus.json

echo "Generating export manifest..."
python3 export_manifest.py --out export_manifest.json

echo "Archiving whisperbus..."
python3 export_whisperbus_archive.py --out echo.whisperbus.archive

echo "Converting DOT to PNG..."
dot -Tpng echo_full_network.dot -o echo_full_network.png

ARTIFACT_FILES=(
  echo_full_network.dot
  echo_full_network.png
  checkpoint_bridge.json
  checkpoint_bus.json
  export_manifest.json
  echo.whisperbus.archive
  export_pipeline.log
)

echo "Verifying artifact files:"
for FILE in "${ARTIFACT_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    echo "  FOUND: $FILE"
  else
    echo "  MISSING: $FILE"
    exit 1
  fi
done

echo "Export pipeline completed successfully."
