# Monitor Workflow

Run SLO watchdog and surface Azure Monitor / Prometheus metrics.

## Steps

1. **Query Log Analytics** — `azure_monitor_query_logs(kql_query)` for error rate
2. **Fetch metrics** — `azure_monitor_get_metrics(resource_id, ["ResponseTime"])`
3. **Run SLO check** — `SLOWatchdog.check(p99_latency_ms, error_rate)`
4. **If BREACH** — surface violations list and recommended action (scale / rollback)
5. **Update App Config** — `azure_app_config_set(f"slo/{service}", status)`
6. **Generate Grafana dashboard** — upload JSON to `azure_blob_upload("dashboards", ...)`
