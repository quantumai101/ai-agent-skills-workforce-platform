# AI Agent Skills Workforce Platform — Full Documentation

> **Claude Agent Skills** (Anthropic, Oct 2025) — composable, progressive-disclosure skill directories that replace monolithic agents. This is *not* a generic "AI has skills" project. See the [Anthropic Engineering Blog](https://www.anthropic.com/engineering/equipping-claude-with-agent-skills) for the open standard.

---

## Architecture Overview

```
User request → Orchestrator (port 8000)
                    │
                    ▼
       Claude reads SKILL.md descriptions only
       (progressive disclosure — lightweight routing)
                    │
          ┌─────────┼──────────┬──────────┬──────────┐
          ▼         ▼          ▼          ▼          ▼
       Nova       Axiom    Sentinel    Nexus    Prometheus
    (AKS/ACR)  (Databricks) (Tests)   (Docs)   (FinOps)
     :8001       :8002       :8003     :8004      :8005
```

Claude loads the **full skill body only when routed to that skill** — keeping context windows lean and costs low. This is the core advantage of Claude Agent Skills over monolithic agents.

---

## Claude Agent Skill Standard

Each skill follows the [Anthropic open standard](https://www.anthropic.com/engineering/equipping-claude-with-agent-skills):

```
skills/<name>/
├── SKILL.md          ← YAML frontmatter: name + description (always loaded)
├── workflows/        ← Sub-task instructions (loaded on demand)
├── scripts/          ← FastAPI microservice code
└── resources/        ← Templates, configs, static assets
```

### SKILL.md format
```yaml
---
name: nova-infrastructure
description: >
  One-paragraph description Claude reads at routing time.
  Be specific — this is what determines whether this skill gets selected.
---
# Full skill instructions follow...
```

---

## Skill Reference

| Skill | Port | Azure Services | Databricks |
|---|---|---|---|
| **Nova** | 8001 | AKS, ACR, APIM, Monitor, Key Vault, Blob, Service Bus | MLflow tracking |
| **Axiom** | 8002 | Blob Storage, Service Bus | Delta Lake, MLflow, Spark |
| **Sentinel** | 8003 | Azure DevOps, Blob, Monitor | MLflow artefacts |
| **Nexus** | 8004 | APIM Developer Portal, Blob | — |
| **Prometheus** | 8005 | Monitor, App Config, Blob | MLflow experiments |

---

## Environment Setup

```bash
cp config/.env.example config/.env
# Fill in all AZURE_* and ANTHROPIC_API_KEY values
# See config/.env.example for the full annotated list
```

---

## Running Locally

```bash
pip install -r requirements.txt
python deployment/launch_ui.py
# All 5 skills + orchestrator start automatically
# Browser opens at http://localhost:3000
```

---

## Deploying to Azure AKS

Use the **Nova skill itself** to deploy the other skills — dogfooding the platform:

```bash
curl -X POST http://localhost:8000/task \
  -H "Content-Type: application/json" \
  -d '{"task": "deploy axiom data pipeline service to AKS"}'
```

Nova reads its `workflows/Deploy.md`, executes the 11-step Azure deployment, and returns the live endpoint.

---

## Repository

GitHub: [quantumai101/ai-agent-skills-workforce-platform](https://github.com/quantumai101/ai-agent-skills-workforce-platform)
