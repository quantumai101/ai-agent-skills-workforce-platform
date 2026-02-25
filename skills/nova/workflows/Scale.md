# Scale Workflow

Scale AKS node pools or Kubernetes HPA for a deployed service.

## Steps

1. **Get current cluster state** — `azure_aks_get_cluster()`
2. **List node pools** — `azure_aks_list_node_pools()`
3. **Scale node pool** — `azure_aks_scale_node_pool(pool_name, node_count)`
4. **Patch HPA** — update `minReplicas` / `maxReplicas` via `k8s_autoscaling`
5. **Verify** — poll pod count until stable
6. **Log metric** — `azure_monitor_get_metrics()` post-scale latency check
