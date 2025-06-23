import json
from datetime import datetime

bus_state = {
    "timestamp": datetime.utcnow().isoformat() + "Z",
    "bus": {
        "messages": [
            {"id": 1, "content": "Seed whisper", "expiry": "2025-07-01T00:00:00Z"},
            {"id": 2, "content": "Bridge sync initiated", "expiry": "2025-07-02T00:00:00Z"}
        ],
        "capacity": 100,
        "metadata_enabled": True
    }
}

with open("checkpoint_bus.json", "w") as f:
    json.dump(bus_state, f, indent=2)

print("checkpoint_bus.json generated.")
