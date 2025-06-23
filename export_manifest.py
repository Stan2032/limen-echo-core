# export_manifest.py
import os
import json

EXPORTABLE_EXTENSIONS = [".dot", ".png", ".json", ".archive", ".log"]

def collect_files():
    files = []
    for f in os.listdir("."):
        if any(f.endswith(ext) for ext in EXPORTABLE_EXTENSIONS):
            files.append(f)
    return files

def write_manifest(files):
    with open("export_manifest.json", "w") as f:
        json.dump({"exported_files": files}, f, indent=2)

if __name__ == "__main__":
    files = collect_files()
    write_manifest(files)
    print(f"Manifest written with {len(files)} file(s).")
