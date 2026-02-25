---
name: sentinel-testing
description: >
  Run automated tests, security red-teaming, and quality assurance for AI
  services. Use this skill for pytest suites, Playwright E2E tests, LLM
  adversarial probing, Azure DevOps pipeline integration, and test reporting.
---

# Sentinel — Testing & Red Team Skill

## Workflow Routing

| Workflow | Trigger phrases | File |
|---|---|---|
| **UnitTest** | "run tests", "pytest", "unit suite" | `workflows/UnitTest.md` |
| **E2ETest** | "end-to-end", "playwright", "browser test" | `workflows/E2ETest.md` |
| **RedTeam** | "red team", "adversarial", "jailbreak probe" | `workflows/RedTeam.md` |

## Skill Principles

1. All test results uploaded to **Azure Blob Storage** under `test-results/` container.
2. Failed runs trigger **Azure Monitor alert** and **Service Bus** notification.
3. Red team prompts versioned and stored in **Azure Key Vault** (sensitive).
4. Coverage reports logged as **MLflow artefacts** for trend analysis.
