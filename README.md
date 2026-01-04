# terraform-talos-bootstrap

Terraform module for bootstrapping Talos Linux Kubernetes clusters.

## Features
  - Machine secrets generation
  - Control plane and worker node configuration
  - Custom configuration patches (static YAML or templates)
  - Cluster bootstrapping
  - kubeconfig and talosconfig credential generation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.12.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >=2.5.3 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | >= 0.8.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >=2.5.3 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | >= 0.8.1 |



## Resources

| Name | Type |
|------|------|
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.talosconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [talos_cluster_kubeconfig.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/cluster_kubeconfig) | resource |
| [talos_machine_bootstrap.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_bootstrap) | resource |
| [talos_machine_configuration_apply.controlplane](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_configuration_apply) | resource |
| [talos_machine_configuration_apply.worker](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_configuration_apply) | resource |
| [talos_machine_secrets.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_secrets) | resource |
| [talos_client_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/client_configuration) | data source |
| [talos_machine_configuration.controlplane](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration) | data source |
| [talos_machine_configuration.worker](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_talos_cluster_endpoint"></a> [talos\_cluster\_endpoint](#input\_talos\_cluster\_endpoint) | Hostname or IP address for the Talos cluster endpoint (without https:// or port). Used as the Kubernetes API endpoint address. | `string` | n/a | yes |
| <a name="input_talos_cluster_name"></a> [talos\_cluster\_name](#input\_talos\_cluster\_name) | Name of the Talos cluster. Used for resource naming and configuration. | `string` | n/a | yes |
| <a name="input_talos_controlplane_config_patches"></a> [talos\_controlplane\_config\_patches](#input\_talos\_controlplane\_config\_patches) | List of machine configuration patch file paths for control plane nodes. Files ending in .tftpl are processed as templates with access to the following variables: hostname, install\_disk, node\_ip, vip, cluster\_name, cluster\_endpoint. Paths are relative to the calling module. | `list(string)` | n/a | yes |
| <a name="input_talos_vip"></a> [talos\_vip](#input\_talos\_vip) | Virtual IP address for control plane high availability. Used as the cluster API endpoint address. | `string` | n/a | yes |
| <a name="input_talos_worker_config_patches"></a> [talos\_worker\_config\_patches](#input\_talos\_worker\_config\_patches) | List of machine configuration patch file paths for worker nodes. Files ending in .tftpl are processed as templates with access to the following variables: hostname, install\_disk, node\_ip, cluster\_name, cluster\_endpoint. Paths are relative to the calling module. | `list(string)` | n/a | yes |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path where the kubeconfig file will be saved. Supports tilde expansion. Set to null to skip kubeconfig file creation. | `string` | `"~/.kube/config"` | no |
| <a name="input_talos_node_data"></a> [talos\_node\_data](#input\_talos\_node\_data) | Map of Talos nodes by IP address. Contains controlplanes and workers maps where keys are node IP addresses and values specify install\_disk (required) and hostname (optional). | <pre>object({<br/>    controlplanes = map(object({<br/>      install_disk = string<br/>      hostname     = optional(string)<br/>    }))<br/>    workers = map(object({<br/>      install_disk = string<br/>      hostname     = optional(string)<br/>    }))<br/>  })</pre> | <pre>{<br/>  "controlplanes": {<br/>    "10.5.0.2": {<br/>      "hostname": "controlplane-1",<br/>      "install_disk": "/dev/sda"<br/>    },<br/>    "10.5.0.3": {<br/>      "hostname": "controlplane-2",<br/>      "install_disk": "/dev/sda"<br/>    },<br/>    "10.5.0.4": {<br/>      "hostname": "controlplane-3",<br/>      "install_disk": "/dev/sda"<br/>    }<br/>  },<br/>  "workers": {<br/>    "10.5.0.5": {<br/>      "hostname": "worker-1",<br/>      "install_disk": "/dev/sda"<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Version of Talos features to use in the generated machine configuration. Must include a v prefix. This value should be set once at the moment of cluster creation and never changed through the lifetime of the cluster, even if the cluster is upgraded. | `string` | `null` | no |
| <a name="input_talosconfig_path"></a> [talosconfig\_path](#input\_talosconfig\_path) | Path where the talosconfig file will be saved. Supports tilde expansion. Set to null to skip talosconfig file creation. | `string` | `"~/.talos/config"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Raw Kubernetes kubeconfig for the Talos cluster, used to authenticate with the Kubernetes API server. |
| <a name="output_kubeconfig_client"></a> [kubeconfig\_client](#output\_kubeconfig\_client) | Kubernetes client configuration for programmatic API access to the Talos cluster. |
| <a name="output_talosconfig"></a> [talosconfig](#output\_talosconfig) | Talos client configuration for machine and cluster administration via the Talos API. |

