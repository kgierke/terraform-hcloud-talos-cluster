# Install the Hetzner Cloud Controller Manager
# See: https://github.com/hetznercloud/hcloud-cloud-controller-manager/tree/main/chart

locals {
  cloud_controller_manager_values = var.cloud_controller_manager_values != "" ? var.cloud_controller_manager_values : <<EOF
networking:
  enabled: true
  EOF
}

# Add the Hetzner Cloud API token and network name as a Kubernetes secret
resource "kubernetes_secret" "hcloud" {
  count = var.cloud_controller_manager_enabled ? 1 : 0

  metadata {
    name      = "hcloud"
    namespace = "kube-system"
  }

  data = {
    token   = var.cloud_controller_manager_hcloud_token
    network = var.private_network_name
  }
}

# Install the Hetzner Cloud Controller Manager Helm chart
resource "helm_release" "hcloud_cloud_controller_manager" {
  count      = var.cloud_controller_manager_enabled ? 1 : 0
  name       = "hcloud-cloud-controller-manager"
  namespace  = "kube-system"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  version    = var.cloud_controller_manager_version

  values = [
    local.cloud_controller_manager_values
  ]
}
