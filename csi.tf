# Install Hetzner CSI Driver
# See: https://github.com/hetznercloud/csi-driver/tree/main/chart

locals {
  csi_values = var.csi_values != "" ? var.csi_values : ""
}

# Install the Hetzner CSI Driver Helm chart
resource "helm_release" "hcloud_csi" {
  count      = var.csi_enabled ? 1 : 0
  name       = "hcloud-csi"
  namespace  = "kube-system"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-csi"
  version    = var.csi_version

  values = [
    local.csi_values
  ]
}
