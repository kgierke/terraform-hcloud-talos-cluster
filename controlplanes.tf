# Configure the control planes for the Hetzner Cloud Talos Kubernetes cluster

locals {
  ccm_manifest_url = var.ccm_manifest_url != "" ? var.ccm_manifest_url : "https://raw.githubusercontent.com/hetznercloud/hcloud-cloud-controller-manager/refs/tags/v${var.ccm_version}/deploy/ccm-networks.yaml"
  csi_manifest_url = var.csi_manifest_url != "" ? var.csi_manifest_url : "https://raw.githubusercontent.com/hetznercloud/csi-driver/refs/tags/v${var.csi_version}/deploy/kubernetes/hcloud-csi.yml"

  controlplanes_config = var.controlplanes_config != "" ? var.controlplanes_config : templatefile("${path.module}/templates/controlplanes.yaml.tpl", {
    endpoint                     = local.endpoint,
    private_network_name         = var.private_network_name,
    private_network_subnet_range = var.private_network_subnet_range,
    workers_length               = length(var.workers),
    ccm_enabled                  = var.ccm_enabled,
    ccm_manifest_url             = local.ccm_manifest_url,
    ccm_hcloud_token             = var.ccm_hcloud_token,
    csi_enabled                  = var.csi_enabled,
    csi_manifest_url             = local.csi_manifest_url,
  })
}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.k8s_endpoint
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "controlplane"
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  config_patches = [
    local.controlplanes_config
  ]
}

resource "hcloud_placement_group" "controlplanes" {
  name = "controlplanes"
  type = "spread"
}

resource "hcloud_server" "controlplanes" {
  for_each = { for index, vm in var.controlplanes : vm.name => vm }

  name        = each.value.name
  server_type = each.value.server_type
  location    = each.value.location

  image              = data.hcloud_image.talos.id
  placement_group_id = hcloud_placement_group.controlplanes.id
  user_data          = data.talos_machine_configuration.controlplane.machine_configuration

  firewall_ids = [
    hcloud_firewall.default.id
  ]

  labels = {
    type = "k8s",
    role = "controlplane",
    os   = "talos"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.this.id
    alias_ips  = []
  }

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }
}

resource "talos_machine_configuration_apply" "controlplanes" {
  for_each = { for index, server in hcloud_server.controlplanes : server.name => server }

  node = each.value.ipv4_address

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
}
