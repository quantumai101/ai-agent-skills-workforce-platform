---
name: prometheus-optimisation
description: >
  Optimise AI service performance and cloud spend. Use this skill for A/B test
  orchestration, auto-scaling policy tuning, Azure cost FinOps analysis,
  Databricks cluster right-sizing, and SLO improvement recommendations.
---

# Prometheus — Optimisation Skill

## Workflow Routing

| Workflow | Trigger phrases | File |
|---|---|---|
| **ABTest** | "A/B test", "canary deploy", "traffic split" | `workflows/ABTest.md` |
| **Autoscale** | "auto-scale", "scaling policy", "HPA tuning" | `workflows/Autoscale.md` |
| **FinOps** | "cost optimise", "cloud spend", "right-size" | `workflows/FinOps.md` |

## Skill Principles

1. All experiment results logged to **MLflow** with statistical significance metrics.
2. Cost data fetched from **Azure Monitor** billing metrics and tagged by service.
3. Scaling policy changes tracked in **Azure App Configuration** with rollback flags.
4. FinOps reports stored in **Azure Blob Storage** under `finops-reports/` container.
