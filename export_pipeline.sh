#!/bin/bash

echo "Starting export pipeline..."

# Install required Python packages
echo "Installing required Python packages..."
pip install --upgrade --user pip networkx pydot

# Verify Graphviz availability
echo "Verifying Graphviz 'dot' command..."
if ! command -v dot &> /dev/null; then
  echo "Error: 'dot' command from Graphviz is not available. Please install Graphviz."
  exit 1
fi

# Run all export scripts
echo "Generating DOT file..."
python create_dot_export.py || { echo "ERROR: create_dot_export.py failed"; exit 1; }

echo "Generating bridge checkpoints..."
python export_bridge.py || { echo "ERROR: export_bridge.py failed"; exit 1; }

echo "Generating bus checkpoints..."
python export_bus.py || { echo "ERROR: export_bus.py failed"; exit 1; }

echo "Generating export manifest..."
python export_manifest.py || { echo "ERROR: export_manifest.py failed"; exit 1; }

echo "Archiving whisperbus..."
python export_whisperbus_archive.py || { echo "ERROR: export_whisperbus_archive.py failed"; exit 1; }

# Convert DOT to PNG
echo "Converting DOT to PNG..."
if [ -f "echo_full_network.dot" ]; then
  dot -Tpng echo_full_network.dot -o echo_full_network.png
else
  echo "Warning: DOT file not found. Skipping PNG generation."
fi

# Verify artifact presence
echo "Verifying artifact files:"
for file in \
  echo_full_network.dot \
  echo_full_network.png \
  checkpoint_bridge.json \
  checkpoint_bus.json \
  export_manifest.json \
  echo.whisperbus.archive; do
  if [ -f "$file" ]; then
    echo "  FOUND: $file"
  else
    echo "  MISSING: $file"
    exit 1
  fi
done

echo "Export pipeline finished successfully."
