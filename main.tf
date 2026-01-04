/**
 * # terraform-talos-bootstrap
 *
 * Terraform module for bootstrapping Talos Linux Kubernetes clusters.
 *
 * This module handles:
 *   - Machine secrets generation
 *   - Control plane and worker node configuration
 *   - Custom configuration patches (static YAML or templates)
 *   - Cluster bootstrapping
 *   - kubeconfig and talosconfig credential generation
 */

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.talos_cluster_name
  cluster_endpoint = "https://${var.talos_cluster_endpoint}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.talos_cluster_name
  cluster_endpoint = "https://${var.talos_cluster_endpoint}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  talos_version    = var.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.talos_cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = keys(var.talos_node_data.controlplanes)
  nodes                = concat(keys(var.talos_node_data.controlplanes), keys(var.talos_node_data.workers))
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = var.talos_node_data.controlplanes
  node                        = each.key
  config_patches = [
    for patch_path in var.talos_controlplane_config_patches :
    can(regex("\\.tftpl$", patch_path))
    ? templatefile(patch_path, {
      hostname         = each.value.hostname == null ? format("%s-cp-%s", var.talos_cluster_name, index(keys(var.talos_node_data.controlplanes), each.key)) : each.value.hostname
      install_disk     = each.value.install_disk
      node_ip          = each.key
      vip              = var.talos_vip
      cluster_name     = var.talos_cluster_name
      cluster_endpoint = var.talos_cluster_endpoint
    })
    : file(patch_path)
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = var.talos_node_data.workers
  node                        = each.key
  config_patches = [
    for patch_path in var.talos_worker_config_patches :
    can(regex("\\.tftpl$", patch_path))
    ? templatefile(patch_path, {
      hostname         = each.value.hostname == null ? format("%s-worker-%s", var.talos_cluster_name, index(keys(var.talos_node_data.workers), each.key)) : each.value.hostname
      install_disk     = each.value.install_disk
      node_ip          = each.key
      cluster_name     = var.talos_cluster_name
      cluster_endpoint = var.talos_cluster_endpoint
    })
    : file(patch_path)
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = keys(var.talos_node_data.controlplanes)[0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = keys(var.talos_node_data.controlplanes)[0]
}

resource "local_file" "talosconfig" {
  depends_on = [talos_machine_bootstrap.this]

  content  = data.talos_client_configuration.this.talos_config
  filename = pathexpand("~/.talos/config")
}

resource "local_file" "kubeconfig" {
  depends_on = [talos_machine_bootstrap.this]

  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = pathexpand("~/.kube/config")
}
