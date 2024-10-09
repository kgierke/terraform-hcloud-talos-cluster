locals {
  controlplanes = [for server in hcloud_server.controlplanes : server]
  workers       = [for server in hcloud_server.workers : server]
}

output "controlplanes" {
  description = "List of controlplane nodes. Can be used to create DNS records for the controlplane nodes."
  value       = local.controlplanes
}

output "workers" {
  description = "List of worker nodes. Can be used to create DNS records for the worker nodes."
  value       = local.workers
}

output "servers" {
  description = "List of all nodes including controlplanes and workers."
  value = concat(
    local.controlplanes,
    local.workers
  )
}

output "talosconfig" {
  description = "Talos configuration for the cluster."
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster."
  value       = talos_cluster_kubeconfig.this
  sensitive   = true
}
