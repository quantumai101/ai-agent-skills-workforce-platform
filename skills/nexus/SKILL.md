---
name: nexus-documentation
description: >
  Auto-generate and publish technical documentation. Use this skill for OpenAPI
  spec generation, runbook creation, architecture diagrams, Confluence publishing,
  and README maintenance for AI services on Azure.
---

# Nexus — Documentation Skill

## Workflow Routing

| Workflow | Trigger phrases | File |
|---|---|---|
| **OpenAPI** | "generate API docs", "openapi spec", "swagger" | `workflows/OpenAPI.md` |
| **Runbook** | "write runbook", "incident guide", "ops doc" | `workflows/Runbook.md` |
| **Architecture** | "architecture diagram", "system diagram", "C4 model" | `workflows/Architecture.md` |

## Skill Principles

1. All docs published to **Azure Blob Storage** static site under `docs/` container.
2. OpenAPI specs registered in **Azure APIM** developer portal automatically.
3. Runbooks versioned in **Azure App Configuration** with feature flags for status.
4. Architecture diagrams generated as Mermaid → PNG, stored in Blob.
