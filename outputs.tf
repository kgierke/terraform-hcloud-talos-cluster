locals {
  controlplanes = [for server in hcloud_server.controlplanes : server]
  workers       = [for server in hcloud_server.workers : server]
}

output "controlplanes" {
  value = local.controlplanes
}

output "workers" {
  value = local.workers
}

output "servers" {
  value = concat(
    local.controlplanes,
    local.workers
  )
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this
  sensitive = true
}
