# Configure the control planes for the Hetzner Cloud Talos Kubernetes cluster
data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.k8s_endpoint
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "controlplane"
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  config_patches = [
    templatefile("${path.module}/templates/common.yaml.tpl", {
      private_network_subnet_range = var.private_network_subnet_range,
      ccm_hcloud_token             = var.ccm_hcloud_token,
      cilium_manifest              = data.helm_template.cilium
      ccm_manifest                 = data.helm_template.hcloud_ccm
      csi_manifest                 = data.helm_template.hcloud_csi
    }),
    templatefile("${path.module}/templates/controlplanes.yaml.tpl", {
      endpoint                     = local.endpoint,
      private_network_name         = var.private_network_name,
      private_network_subnet_range = var.private_network_subnet_range,
      workers_length               = length(var.workers),
    })
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
