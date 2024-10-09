# Configure the workers for the Hetzner Cloud Talos Kubernetes cluster

locals {
  workers_config = var.workers_config != "" ? var.workers_config : <<EOF
machine:
  time:
    servers:
      - ntp1.hetzner.de
      - ntp2.hetzner.com
      - ntp3.hetzner.net
      - 0.de.pool.ntp.org
      - 1.de.pool.ntp.org
      - time.cloudflare.com
  EOF
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.k8s_endpoint
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "worker"
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  config_patches = [
    local.workers_config
  ]
}

resource "hcloud_server" "workers" {
  for_each = { for index, vm in var.workers : vm.name => vm }

  name        = each.value.name
  server_type = each.value.server_type
  location    = each.value.location

  image     = data.hcloud_image.talos.id
  user_data = data.talos_machine_configuration.worker.machine_configuration

  firewall_ids = [
    hcloud_firewall.default.id
  ]

  labels = {
    type = "k8s",
    role = "worker",
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

resource "talos_machine_configuration_apply" "workers" {
  for_each = { for index, server in hcloud_server.workers : server.name => server }

  node = each.value.ipv4_address

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
}
