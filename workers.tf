# Configure the workers for the Hetzner Cloud Talos Kubernetes cluster
data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.k8s_endpoint
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = "worker"
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version

  config_patches = [
    templatefile("${path.module}/templates/common.yaml.tpl", {
      private_network_name         = var.private_network_name,
      private_network_subnet_range = var.private_network_subnet_range,
      ccm_hcloud_token             = var.ccm_hcloud_token,
      cilium_manifest              = data.helm_template.cilium
      ccm_manifest                 = data.helm_template.hcloud_ccm
      csi_manifest                 = data.helm_template.hcloud_csi
    }),
    templatefile("${path.module}/templates/workers.yaml.tpl", {})
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
