#!/bin/bash
set -euo pipefail

echo "Starting export pipeline..."

echo "Installing required Python packages: networkx and pydot..."
python3 -m pip install --quiet networkx pydot

echo "Verifying Graphviz 'dot' command is available..."
if ! command -v dot &> /dev/null; then
  echo "ERROR: 'dot' command not found. Please install Graphviz."
  exit 1
fi

echo "Running Python script to generate DOT file..."
python3 create_dot_export.py

echo "Checking for echo_full_network.dot file..."
if [ -f "echo_full_network.dot" ]; then
  echo "DOT file found. Generating PNG image from DOT file..."
  dot -Tpng echo_full_network.dot -o echo_full_network.png
  echo "PNG file generated: echo_full_network.png"
else
  echo "ERROR: echo_full_network.dot file not found! Exiting pipeline."
  exit 1
fi

ARTIFACT_FILES=(
  "echo_full_network.dot"
  "echo_full_network.png"
  "checkpoint_bridge.json"
  "checkpoint_bus.json"
  "export_manifest.json"
  "export_pipeline.log"
  "echo.whisperbus.archive"
)

echo "Checking existence of expected artifact files:"
for FILE in "${ARTIFACT_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    echo "  FOUND: $FILE"
  else
    echo "  MISSING: $FILE"
  fi
done

echo "Export pipeline completed successfully."
