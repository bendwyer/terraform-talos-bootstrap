variable "kubeconfig_path" {
  description = "Path where the kubeconfig file will be saved. Supports tilde expansion. Set to null to skip kubeconfig file creation."
  type        = string
  default     = "~/.kube/config"
  nullable    = true
}

variable "talos_cluster_endpoint" {
  description = "Hostname or IP address for the Talos cluster endpoint (without https:// or port). Used as the Kubernetes API endpoint address."
  type        = string
}

variable "talos_cluster_name" {
  description = "Name of the Talos cluster. Used for resource naming and configuration."
  type        = string
}

variable "talos_controlplane_config_patches" {
  description = "List of machine configuration patch file paths for control plane nodes. Files ending in .tftpl are processed as templates with access to the following variables: hostname, install_disk, node_ip, vip, cluster_name, cluster_endpoint. Paths are relative to the calling module."
  type        = list(string)
}

variable "talos_node_data" {
  description = "Map of Talos nodes by hostname. Contains controlplanes and workers maps where keys are node hostnames and values specify node_ip (required) and install_disk (required)."
  type = object({
    controlplanes = map(object({
      node_ip      = string
      install_disk = string
    }))
    workers = map(object({
      node_ip      = string
      install_disk = string
    }))
  })
  default = {
    controlplanes = {
      "controlplane-1" = {
        node_ip      = "10.5.0.2"
        install_disk = "/dev/sda"
      },
      "controlplane-2" = {
        node_ip      = "10.5.0.3"
        install_disk = "/dev/sda"
      },
      "controlplane-3" = {
        node_ip      = "10.5.0.4"
        install_disk = "/dev/sda"
      }
    }
    workers = {
      "worker-1" = {
        node_ip      = "10.5.0.5"
        install_disk = "/dev/sda"
      }
    }
  }
}

variable "talos_version" {
  description = "Version of Talos features to use in the generated machine configuration. Must include a v prefix. This value should be set once at the moment of cluster creation and never changed through the lifetime of the cluster, even if the cluster is upgraded."
  type        = string
  default     = null
}

variable "talos_vip" {
  description = "Virtual IP address for control plane high availability. Used as the cluster API endpoint address."
  type        = string
  default     = null
}

variable "talos_worker_config_patches" {
  description = "List of machine configuration patch file paths for worker nodes. Files ending in .tftpl are processed as templates with access to the following variables: hostname, install_disk, node_ip, cluster_name, cluster_endpoint. Paths are relative to the calling module."
  type        = list(string)
}

variable "talosconfig_path" {
  description = "Path where the talosconfig file will be saved. Supports tilde expansion. Set to null to skip talosconfig file creation."
  type        = string
  default     = "~/.talos/config"
  nullable    = true
}
