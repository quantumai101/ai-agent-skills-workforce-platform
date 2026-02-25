![AI Agent Skills Workforce Platform](images/header.png)

# AI Agent Skills Workforce Platform

[![Python](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-green.svg)](https://fastapi.tiangolo.com/)
[![Azure](https://img.shields.io/badge/Azure-AKS%20%7C%20ACR%20%7C%20APIM-blue.svg)](https://azure.microsoft.com/)
[![Databricks](https://img.shields.io/badge/Databricks-MLflow%20%7C%20Delta%20Lake-red.svg)](https://databricks.com/)
[![Claude Agent Skills](https://img.shields.io/badge/Claude-Agent%20Skills%20%7C%20Oct%202025-blueviolet.svg)](https://www.anthropic.com/engineering/equipping-claude-with-agent-skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

5 autonomous **Claude Agent Skills** for production ML operations on **Azure / AKS** and **Databricks**.  
Built on [Anthropic's Claude Agent Skills architecture](https://www.anthropic.com/engineering/equipping-claude-with-agent-skills) (Oct 2025) — composable, progressive-disclosure skills that replace monolithic agents.

> ⚠️ *This uses **Claude Agent Skills** specifically (Anthropic, Oct 2025) — not generic "AI has skills". See the [Anthropic Engineering Blog](https://www.anthropic.com/engineering/equipping-claude-with-agent-skills) for the open standard.*

Targeted at senior AI engineering roles at ASX200 enterprise companies.

---

### Why Claude Agent Skills, Not Agents?

> *"Instead of building fragmented, custom-designed agents for each use case, anyone can now specialise their agents with composable capabilities."* — Anthropic Engineering Blog, Oct 2025

| Old Pattern | This Platform |
|---|---|
| Monolithic agent per task | Composable `SKILL.md` per domain |
| Full context loaded always | Progressive disclosure — loads only what's needed |
| Hard to share / reuse | Each skill is a portable directory |
| One LLM does everything | Skills route to the right model / subagent |

Each of the five platform capabilities is implemented as a **Claude Agent Skill** under `skills/` — a `SKILL.md` plus supporting workflows and scripts — wired to a FastAPI microservice on Azure AKS.

---

### The Five Claude Agent Skills

| Skill Directory | Role | Port |
|---|---|---|
| 🛰️ `skills/nova` | Infrastructure — AKS, ACR, APIM, Azure Monitor | `:8001` |
| ⚡ `skills/axiom` | Data Pipelines — Delta Lake, MLflow, Azure Blob | `:8002` |
| 🛡️ `skills/sentinel` | Testing & Red Team — pytest, Playwright, Azure DevOps | `:8003` |
| 📖 `skills/nexus` | Documentation — OpenAPI, Runbooks, Confluence | `:8004` |
| ⚙️ `skills/prometheus` | Optimisation — A/B Testing, Auto-scaling, FinOps | `:8005` |

---

### Quick Start

```bash
git clone https://github.com/quantumai101/ai-agent-skills-workforce-platform.git
cd ai-agent-skills-workforce-platform
cp config/.env.example config/.env        # fill in your Azure + Anthropic keys
pip install -r requirements.txt
python deployment/launch_ui.py
```

Browser opens at `http://localhost:3000` — click **Deploy Skills** to launch all five.

---

### Claude Agent Skill Architecture

Each skill follows the [Anthropic Claude Agent Skills open standard](https://www.anthropic.com/engineering/equipping-claude-with-agent-skills):

```
skills/nova/
├── SKILL.md              # YAML frontmatter (name, description) + instructions
├── workflows/
│   ├── Deploy.md         # Deploy a new AI service to AKS
│   ├── Scale.md          # Scale node pools / HPA
│   └── Monitor.md        # SLI/SLO watchdog
├── scripts/
│   └── nova_service.py   # FastAPI microservice (Azure SDK, 168 azure_ refs)
└── resources/
    └── k8s_templates/    # Kubernetes manifest templates
```

Claude discovers each skill by reading its `SKILL.md` description at startup.  
It loads the full skill body only when the task matches — **progressive disclosure**.

---

### Project Structure

```
ai-agent-skills-workforce-platform/
├── skills/              # Five Claude Agent Skills
│   ├── nova/            # Infrastructure — Azure AKS/ACR/APIM (168 azure_ refs)
│   ├── axiom/           # Data pipelines — Databricks / Delta Lake
│   ├── sentinel/        # Testing — pytest / Playwright / Red Team
│   ├── nexus/           # Documentation — OpenAPI / Runbooks
│   └── prometheus/      # Optimisation — A/B / FinOps / Auto-scaling
├── orchestration/       # Central coordinator — routes tasks to skills (port 8000)
├── monitoring/          # Prometheus metrics, Azure Monitor alerts
├── deployment/          # Launch scripts, Docker, Helm charts
├── frontend/            # Browser UI
├── docs/                # Full documentation
├── tests/               # Unit, integration, red-team suites
├── config/              # .env.example with all Azure + Databricks variables
└── requirements.txt     # All Python dependencies (root level)
```

---

### Full Documentation

See [`docs/README.md`](docs/README.md) for the complete guide, [`README.html`](README.html) for the polished root page, or open the [Live Dashboard](https://htmlpreview.github.io/?https://github.com/quantumai101/ai-agent-skills-workforce-platform/blob/main/docs/index.html) to see all five skills running.


---

MIT License · [quantumai101](https://github.com/quantumai101)
