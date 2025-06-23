#!/bin/bash
set -euo pipefail

# Initialize log
echo "Starting export pipeline..." | tee export_pipeline.log

# Install Python dependencies
echo "Installing required Python packages..." | tee -a export_pipeline.log
python3 -m pip install --user networkx pydot 2>&1 | tee -a export_pipeline.log

# Generate DOT file
echo "Generating DOT file..." | tee -a export_pipeline.log
python3 create_dot_export.py 2>&1 | tee -a export_pipeline.log

# Generate bridge checkpoints
echo "Generating bridge checkpoints..." | tee -a export_pipeline.log
python3 export_bridge.py 2>&1 | tee -a export_pipeline.log

# Generate bus checkpoints
echo "Generating bus checkpoints..." | tee -a export_pipeline.log
python3 export_bus.py 2>&1 | tee -a export_pipeline.log

# Generate export manifest
echo "Generating export manifest..." | tee -a export_pipeline.log
python3 export_manifest.py 2>&1 | tee -a export_pipeline.log

# Archive whisperbus
echo "Archiving whisperbus..." | tee -a export_pipeline.log
python3 export_whisperbus_archive.py 2>&1 | tee -a export_pipeline.log

# Convert DOT to PNG
echo "Converting DOT to PNG..." | tee -a export_pipeline.log
dot -Tpng echo_full_network.dot -o echo_full_network.png 2>&1 | tee -a export_pipeline.log

# Verify artifact files
echo "Verifying artifact files:" | tee -a export_pipeline.log
FILES=(
  "echo_full_network.dot"
  "echo_full_network.png"
  "checkpoint_bridge.json"
  "checkpoint_bus.json"
  "export_manifest.json"
  "echo.whisperbus.archive"
  "export_pipeline.log"
)
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "  FOUND: $file" | tee -a export_pipeline.log
  else
    echo "  MISSING: $file" | tee -a export_pipeline.log
    exit 1
  fi
done

echo "Export pipeline finished." | tee -a export_pipeline.log
