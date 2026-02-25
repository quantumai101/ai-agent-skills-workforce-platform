---
name: nova-infrastructure
description: >
  Deploy, scale, and monitor AI services on Azure AKS. Use this skill when the
  task involves container images (ACR), Kubernetes deployments, API Management
  (APIM), Azure Monitor alerts, Key Vault secrets, Blob Storage, or Service Bus.
  Covers full infrastructure lifecycle: provision → deploy → monitor → teardown.
---

# Nova — Infrastructure Skill

## Workflow Routing

| Workflow | Trigger phrases | File |
|---|---|---|
| **Deploy** | "deploy a service", "create deployment", "push to AKS" | `workflows/Deploy.md` |
| **Scale** | "scale up", "resize node pool", "adjust replicas" | `workflows/Scale.md` |
| **Monitor** | "check SLOs", "latency alert", "SLI dashboard" | `workflows/Monitor.md` |

## Context Files

- `resources/k8s_templates/` — reusable Kubernetes YAML manifests
- `scripts/nova_service.py` — FastAPI microservice with full Azure SDK integration

## Skill Principles

1. Always use **Managed Identity** (`DefaultAzureCredential`) — never hardcode keys.
2. Store every secret in **Azure Key Vault** before referencing it in K8s.
3. Every deployment must emit a **CloudWatch / Azure Monitor metric alarm** for p99 latency > 200ms.
4. Track all runs in **MLflow on Databricks** under `/Shared/infrastructure-deployments-azure`.
5. Upload deployment artefacts (Dockerfile, generated code) to **Azure Blob Storage** for audit trail.
6. Publish deployment events to **Azure Service Bus** queue `deployment-events`.

## SLO Targets

| Metric | Target |
|---|---|
| p99 latency | < 200 ms |
| Availability | > 99.9% |
| Error rate | < 0.1% |
