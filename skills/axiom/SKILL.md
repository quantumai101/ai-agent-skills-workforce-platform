---
name: axiom-data-pipelines
description: >
  Build and operate data pipelines on Databricks (Delta Lake, MLflow, Spark).
  Use this skill for ingestion, transformation, feature engineering, model
  training orchestration, and Delta table management on Azure Databricks.
---

# Axiom — Data Pipelines Skill

## Workflow Routing

| Workflow | Trigger phrases | File |
|---|---|---|
| **Ingest** | "ingest data", "load to Delta", "create pipeline" | `workflows/Ingest.md` |
| **Train** | "train model", "run experiment", "MLflow run" | `workflows/Train.md` |
| **Monitor** | "data quality", "pipeline health", "drift detection" | `workflows/Monitor.md` |

## Skill Principles

1. All data lands in **Delta Lake** — no raw Parquet or CSV in production.
2. Every model training run must log params, metrics, and artefacts to **MLflow**.
3. Use **Unity Catalog** for data governance — all tables registered.
4. Pipeline configs stored in **Azure Blob Storage** under `pipelines/` container.
5. Trigger downstream notifications via **Azure Service Bus** on pipeline completion.
