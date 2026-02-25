"""
Orchestration Coordinator — Port 8000
Routes incoming tasks to the appropriate Agent Skill microservice.
Implements the Agent Skills progressive-disclosure pattern:
  1. Load skill names + descriptions (lightweight)
  2. Match user intent to the best skill
  3. Forward request to that skill's FastAPI service
"""

import os
import json
import logging
import httpx
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, Dict, Any
import anthropic

logging.basicConfig(level=logging.INFO, format="%(asctime)s [ORCHESTRATOR] %(message)s")
logger = logging.getLogger("orchestrator")

# ── Skill Registry ─────────────────────────────────────────────────────────────
# Mirrors SKILL.md frontmatter — loaded at startup (progressive disclosure stage 1)
SKILL_REGISTRY = {
    "nova-infrastructure": {
        "description": "Deploy, scale, monitor AI services on Azure AKS/ACR/APIM/Monitor/KeyVault.",
        "endpoint": os.environ.get("NOVA_URL", "http://localhost:8001"),
    },
    "axiom-data-pipelines": {
        "description": "Build data pipelines on Databricks Delta Lake, MLflow, Spark.",
        "endpoint": os.environ.get("AXIOM_URL", "http://localhost:8002"),
    },
    "sentinel-testing": {
        "description": "Run pytest, Playwright E2E tests, and LLM adversarial red-teaming.",
        "endpoint": os.environ.get("SENTINEL_URL", "http://localhost:8003"),
    },
    "nexus-documentation": {
        "description": "Generate OpenAPI specs, runbooks, architecture diagrams.",
        "endpoint": os.environ.get("NEXUS_URL", "http://localhost:8004"),
    },
    "prometheus-optimisation": {
        "description": "A/B testing, auto-scaling policy tuning, Azure FinOps cost analysis.",
        "endpoint": os.environ.get("PROMETHEUS_URL", "http://localhost:8005"),
    },
}


class TaskRequest(BaseModel):
    task: str
    payload: Optional[Dict[str, Any]] = {}


app = FastAPI(title="AI Agent Skills Workforce Platform — Orchestrator (Claude Agent Skills)", version="2.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

claude = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))


def route_to_skill(task: str) -> str:
    """
    Use Claude to match the task description to the most relevant skill.
    This is the progressive-disclosure routing step.
    """
    skill_list = "\n".join(
        f"- {name}: {info['description']}"
        for name, info in SKILL_REGISTRY.items()
    )
    response = claude.messages.create(
        model="claude-haiku-4-5-20251001",   # Fast model for routing
        max_tokens=50,
        messages=[{
            "role": "user",
            "content": (
                f"Given these skills:\n{skill_list}\n\n"
                f"Which single skill best matches this task: '{task}'?\n"
                f"Reply with only the skill name, nothing else."
            )
        }]
    )
    skill_name = response.content[0].text.strip()
    logger.info(f"Routed '{task[:60]}' → {skill_name}")
    return skill_name


@app.post("/task")
async def dispatch_task(request: TaskRequest):
    """Route a task to the appropriate skill microservice."""
    skill_name = route_to_skill(request.task)

    if skill_name not in SKILL_REGISTRY:
        raise HTTPException(status_code=400, detail=f"Unknown skill: {skill_name}")

    skill_endpoint = SKILL_REGISTRY[skill_name]["endpoint"]

    async with httpx.AsyncClient(timeout=60.0) as client:
        try:
            resp = await client.post(
                f"{skill_endpoint}/execute",
                json={"task": request.task, "payload": request.payload}
            )
            return {"skill": skill_name, "result": resp.json()}
        except Exception as e:
            logger.error(f"Skill call failed: {e}")
            raise HTTPException(status_code=503, detail=str(e))


@app.get("/skills")
async def list_skills():
    """Return the skill registry — names, descriptions, endpoints."""
    return SKILL_REGISTRY


@app.get("/health")
async def health():
    return {"status": "ok", "platform": "AI Skills Workforce Platform"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
