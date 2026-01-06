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

output "machine_configuration_controlplane" {
  description = "Generated Talos machine config(s) for controlplane nodes(s)."
  value       = data.talos_machine_configuration.controlplane.machine_configuration
}

output "machine_configuration_worker" {
  description = "Generated Talos machine config(s) for worker node(s)."
  value       = data.talos_machine_configuration.worker.machine_configuration
}

output "talosconfig" {
  description = "Talos client configuration for machine and cluster administration via the Talos API."
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}
