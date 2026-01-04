output "kubeconfig" {
  description = "Raw Kubernetes kubeconfig for the Talos cluster, used to authenticate with the Kubernetes API server."
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "kubeconfig_client" {
  description = "Kubernetes client configuration for programmatic API access to the Talos cluster."
  value       = talos_cluster_kubeconfig.this.kubernetes_client_configuration
  sensitive   = true
}

output "talosconfig" {
  description = "Talos client configuration for machine and cluster administration via the Talos API."
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}
