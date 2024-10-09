locals {
  endpoint     = "${var.cluster_name}.${var.cluster_tld}"
  k8s_endpoint = "https://${local.endpoint}:6443"
}

data "hcloud_image" "talos" {
  with_selector = "os=talos"
  most_recent   = true
}

resource "hcloud_network" "this" {
  name     = var.private_network_name
  ip_range = var.private_network_ip_range
}

resource "hcloud_network_subnet" "this" {
  network_id   = hcloud_network.this.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.private_network_subnet_range
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes = [
    for controlplane in var.controlplanes : hcloud_server.controlplanes[controlplane.name].ipv4_address
  ]
  endpoints = [
    for controlplane in var.controlplanes : hcloud_server.controlplanes[controlplane.name].ipv4_address
  ]
}

# create the talos client config
data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = concat(
    [for controlplane in var.controlplanes : hcloud_server.controlplanes[controlplane.name].ipv4_address],
  )
  nodes = concat(
    [for controlplane in var.controlplanes : hcloud_server.controlplanes[controlplane.name].ipv4_address],
    [for worker in var.workers : hcloud_server.workers[worker.name].ipv4_address]
  )
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = hcloud_server.controlplanes[var.controlplanes[0].name].ipv4_address
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = hcloud_server.controlplanes[var.controlplanes[0].name].ipv4_address
}

