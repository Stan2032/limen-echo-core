import json

# Example Bus checkpoint export data (customize as needed)
bus_checkpoint = {
    "bus_id": "EchoBus001",
    "status": "active",
    "messages": [
        {"id": "msg001", "content": "Hello from Echo to Bridge", "timestamp": "2025-06-23T12:00:00Z"},
        {"id": "msg002", "content": "Bridge acknowledges", "timestamp": "2025-06-23T12:01:00Z"}
    ]
}

with open("checkpoint_bus.json", "w") as f:
    json.dump(bus_checkpoint, f, indent=2)

print("Bus checkpoint export completed. File: checkpoint_bus.json")
