terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">=1.43.0"
    }

    talos = {
      source  = "siderolabs/talos"
      version = ">=0.6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">=2.16.1"
    }
  }
}
