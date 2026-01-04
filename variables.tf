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
  description = "Map of Talos nodes by IP address. Contains controlplanes and workers maps where keys are node IP addresses and values specify install_disk (required) and hostname (optional)."
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  default = {
    controlplanes = {
      "10.5.0.2" = {
        install_disk = "/dev/sda"
        hostname     = "controlplane-1"
      },
      "10.5.0.3" = {
        install_disk = "/dev/sda"
        hostname     = "controlplane-2"
      },
      "10.5.0.4" = {
        install_disk = "/dev/sda"
        hostname     = "controlplane-3"
      }
    }
    workers = {
      "10.5.0.5" = {
        install_disk = "/dev/sda"
        hostname     = "worker-1"
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
}

variable "talos_worker_config_patches" {
  description = "List of machine configuration patch file paths for worker nodes. Files ending in .tftpl are processed as templates with access to the following variables: hostname, install_disk, node_ip, cluster_name, cluster_endpoint. Paths are relative to the calling module."
  type        = list(string)
}
