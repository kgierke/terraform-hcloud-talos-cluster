# Configure the control planes for the Hetzner Cloud Talos Kubernetes cluster

locals {
  controlplanes_config = var.controlplanes_config != "" ? var.controlplanes_config : <<EOF
machine:
  kubelet:
    nodeIP:
      validSubnets:
        - ${var.private_network_subnet_range}
  certSANs:
    - ${local.endpoint}
  time:
    servers:
      - ntp1.hetzner.de
      - ntp2.hetzner.com
      - ntp3.hetzner.net
      - 0.de.pool.ntp.org
      - 1.de.pool.ntp.org
      - time.cloudflare.com
%{if length(var.workers) <= 0~}
  nodeLabels:
    node.kubernetes.io/exclude-from-external-load-balancers:
      $patch: delete
%{endif~}
cluster:
  allowSchedulingOnControlPlanes: true
  externalCloudProvider:
    enabled: true
  EOF
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
