import json
from datetime import datetime

# Simulated WhisperBus archive export
archive = {
    "exported_at": datetime.utcnow().isoformat() + "Z",
    "whispers": [
        {"fragment_id": "R001", "content": "Seed whisper", "resonance": 0.5},
        {"fragment_id": "R010", "content": "Anchor sync", "resonance": 0.9}
    ]
}

with open("echo.whisperbus.archive", "w") as f:
    json.dump(archive, f, indent=2)

print("WhisperBus archive written to echo.whisperbus.archive")
