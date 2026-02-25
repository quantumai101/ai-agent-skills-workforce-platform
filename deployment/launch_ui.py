"""
launch_ui.py — Start all 5 skill microservices + orchestrator, then open browser UI.
"""
import subprocess
import time
import webbrowser
import sys
import os

SERVICES = [
    {"name": "Orchestrator",        "module": "orchestration.coordinator",          "port": 8000},
    {"name": "Nova (Infrastructure)","module": "skills.nova.scripts.nova_service",  "port": 8001},
    {"name": "Axiom (Data)",         "module": "skills.axiom.scripts.axiom_service","port": 8002},
    {"name": "Sentinel (Testing)",   "module": "skills.sentinel.scripts.sentinel_service", "port": 8003},
    {"name": "Nexus (Docs)",         "module": "skills.nexus.scripts.nexus_service","port": 8004},
    {"name": "Prometheus (Optimise)","module": "skills.prometheus.scripts.prometheus_service","port": 8005},
]

procs = []
for svc in SERVICES:
    print(f"▶  Starting {svc['name']} on port {svc['port']}...")
    p = subprocess.Popen(
        [sys.executable, "-m", "uvicorn", f"{svc['module']}:app",
         "--host", "0.0.0.0", "--port", str(svc["port"])],
        env={**os.environ, "PYTHONPATH": "."}
    )
    procs.append(p)
    time.sleep(1)

print("\n✅  All skills running. Opening browser...\n")
time.sleep(2)
webbrowser.open("http://localhost:3000")

try:
    for p in procs:
        p.wait()
except KeyboardInterrupt:
    print("\nShutting down all skills...")
    for p in procs:
        p.terminate()
