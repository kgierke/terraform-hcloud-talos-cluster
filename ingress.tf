# Install traefik as an Ingress Controller and setup Cert-Manager for Let's Encrypt

locals {
  ingress_traefik_values = var.ingress_traefik_values != "" ? var.ingress_traefik_values : <<EOF
service:
  enabled: true
  type: LoadBalancer
  annotations:
    "load-balancer.hetzner.cloud/name": "${var.cluster_name}-traefik"
    "load-balancer.hetzner.cloud/use-private-ip": "true"
    "load-balancer.hetzner.cloud/disable-private-ingress": "true"
    "load-balancer.hetzner.cloud/location": "${var.ingress_load_balancer_location}"
    "load-balancer.hetzner.cloud/type": "${var.ingress_load_balancer_type}"
    "load-balancer.hetzner.cloud/uses-proxyprotocol": "true"
    "load-balancer.hetzner.cloud/algorithm-type": "round_robin"
ports:
  web:
    proxyProtocol:
      trustedIPs:
        - 127.0.0.1/32
        - 10.0.0.0/8
    forwardedHeaders:
      trustedIPs:
        - 127.0.0.1/32
        - 10.0.0.0/8
  websecure:
    proxyProtocol:
      trustedIPs:
        - 127.0.0.1/32
        - 10.0.0.0/8
    forwardedHeaders:
      trustedIPs:
        - 127.0.0.1/32
        - 10.0.0.0/8
  EOF

  ingress_certmanager_values = var.ingress_certmanager_values != "" ? var.ingress_certmanager_values : <<EOF
crds:
  enabled: true
  keep: true
  EOF

  ingress_certmanager_email = var.ingress_certmanager_email != "" ? var.ingress_certmanager_email : "${var.cluster_name}@${var.cluster_tld}"
}

# Install Traefik as an Ingress Controller
resource "helm_release" "traefik" {
  count      = var.ingress_enabled ? 1 : 0
  name       = "traefik"
  namespace  = "kube-system"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "32.1.0"

  values = [
    local.ingress_traefik_values
  ]

  depends_on = [
    data.talos_cluster_health.this
  ]
}

# Install Cert-Manager
resource "helm_release" "cert_manager" {
  count      = var.ingress_enabled ? 1 : 0
  name       = "cert-manager"
  namespace  = "kube-system"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.16.0"

  values = [
    local.ingress_certmanager_values
  ]

  depends_on = [
    data.talos_cluster_health.this
  ]
}

# Create a Let's Encrypt ClusterIssuer
resource "helm_release" "cert_manager_clusterissuer" {
  count       = var.ingress_enabled ? 1 : 0
  name        = "cert-manager-clusterissuer"
  namespace   = "kube-system"
  chart       = "${path.module}/charts/cert-manager-clusterissuer"
  max_history = 1

  set {
    name  = "acme_email"
    value = local.ingress_certmanager_email
  }

  set {
    name  = "solvers_ingress_class_name"
    value = "traefik"
  }

  depends_on = [
    data.talos_cluster_health.this,
    helm_release.cert_manager
  ]
}
