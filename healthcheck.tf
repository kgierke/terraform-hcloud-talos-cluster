data "http" "talos_health" {
  url      = "https://${hcloud_server.controlplanes[var.controlplanes[0].name].ipv4_address}:6443/version"
  insecure = true

  retry {
    attempts     = 10
    min_delay_ms = 5000
    max_delay_ms = 5000
  }

  depends_on = [
    talos_machine_bootstrap.this
  ]
}
