terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">=1.43.0"
    }

    http = {
      source  = "hashicorp/http"
      version = ">=3.4.5"
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

provider "helm" {
  kubernetes {
    host       = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
    client_key = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)

    client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
  }
}
