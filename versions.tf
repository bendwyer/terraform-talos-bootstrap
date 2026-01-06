terraform {
  required_version = ">= 1.12.2"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.3"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.8.1"
    }
  }
}
