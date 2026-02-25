# Deploy Workflow

Deploy a new AI service end-to-end to Azure AKS.

## Steps

1. **Ensure Resource Group** — call `azure_ensure_resource_group()`
2. **Generate service code** — use Claude to produce FastAPI + Azure SDK code
3. **Build & push image to ACR** — `azure_acr_ensure_registry()` → `azure_acr_get_credentials()` → `docker build && docker push`
4. **Store secrets** — `azure_keyvault_set_secret("anthropic-api-key", ...)`
5. **Create K8s Deployment + Service + HPA** — apply manifests from `resources/k8s_templates/`
6. **Register in APIM** — `azure_apim_create_api()` + `azure_apim_create_backend()`
7. **Upload artefact to Blob** — `azure_blob_upload("deployments", ...)`
8. **Publish event** — `azure_servicebus_send_message("deployment-events", ...)`
9. **Create Monitor alert** — `azure_monitor_create_metric_alert()` for p99 > 200ms
10. **Validate SLIs** — `_validate_slis()` — fail deployment if p99 > 200ms
11. **Log to MLflow** — `mlflow.log_dict(deployment_result, "deployment_result.json")`

## Output

Return `deployment_result` dict with: `service_name`, `status`, `endpoint`, `image`, `replicas`, `sli_validation`, `timestamp`.
