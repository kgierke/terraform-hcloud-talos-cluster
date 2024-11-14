variable "cluster_tld" {
  type        = string
  description = "Define the top-level domain for the cluster."
}

variable "cluster_name" {
  type        = string
  description = "Define the name of the cluster."
}

variable "talos_version" {
  type        = string
  description = "Define the version of Talos to use."
  default     = "1.8.0"
}

variable "kubernetes_version" {
  type        = string
  description = "Define the version of Kubernetes to use."
  default     = "1.31.2"
}

# Network related variables
variable "private_network_name" {
  type        = string
  description = "Define the name of the private network."
  default     = "internal"
}

variable "network_zone" {
  type        = string
  description = "Define the zone of the network."
  default     = "eu-central"
}

variable "private_network_ip_range" {
  type        = string
  description = "Define the IP range of the private network."
  default     = "10.0.0.0/16"
}

variable "private_network_subnet_range" {
  type        = string
  description = "Define the subnet range of the private network."
  default     = "10.0.0.0/24"
}

# Controlplane related variables
variable "controlplanes" {
  type = list(object({
    name        = string
    server_type = string
    location    = string
  }))

  description = "List of controlplane nodes, should be either 1 or 3 nodes."

  default = [
    {
      name        = "columbia",
      server_type = "cx22"
      location    = "hel1"
    },
    # {
    #   name        = "challenger",
    #   server_type = "cx22"
    #   location    = "hel1"
    # },
    # {
    #   name        = "discovery",
    #   server_type = "cx22"
    #   location    = "hel1"
    # }
  ]

  validation {
    condition     = length(var.controlplanes) == 1 || length(var.controlplanes) == 3
    error_message = "Controlplane nodes should be either 1 or 3 nodes."
  }
}

variable "controlplanes_config" {
  type        = string
  description = "Define the configuration for the controlplane nodes."
  default     = ""
}

# Worker related variables
variable "workers" {
  type = list(object({
    name        = string
    server_type = string
    location    = string
  }))

  description = "List of worker nodes."

  default = [
    # {
    #   name        = "enterprise",
    #   server_type = "cx22"
    #   location    = "hel1"
    # },
  ]
}

variable "workers_config" {
  type        = string
  description = "Define the configuration for the worker nodes."
  default     = ""
}

variable "cilium_version" {
  type        = string
  description = "Define the version of the cilium Helm chart. See: https://docs.cilium.io/en/stable/installation/k8s-install-helm/"
  default     = "1.16.3"

  // make sure the version is a valid semantic version and without the 'v' prefix
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.cilium_version))
    error_message = "The version should be a valid semantic version. (It should not contain the 'v' prefix)"
  }
}

# Cloud Controller Manager related variables
variable "ccm_hcloud_token" {
  type        = string
  description = "Define the Hetzner Cloud API token for the cloud-controller-manager."
  default     = ""
  sensitive   = true
}

variable "ccm_version" {
  type        = string
  description = "Define the version of the hcloud-cloud-controller-manager Helm chart. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager"
  default     = "1.20.0"

  // make sure the version is a valid semantic version and without the 'v' prefix
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.ccm_version))
    error_message = "The version should be a valid semantic version. (It should not contain the 'v' prefix)"
  }
}

# Container Storage Interface related variables
variable "csi_version" {
  type        = string
  description = "Define the version of the hcloud-csi Helm chart. See: https://github.com/hetznercloud/csi-driver"
  default     = "2.10.0"

  // make sure the version is a valid semantic version and without the 'v' prefix
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.csi_version))
    error_message = "The version should be a valid semantic version. (It should not contain the 'v' prefix)"
  }
}

# Metrics Server related variables
variable "metrics_server_version" {
  type        = string
  description = "Define the version of the metrics-server Helm chart. See: https://artifacthub.io/packages/helm/metrics-server/metrics-server"
  default     = "3.12.2"

  // make sure the version is a valid semantic version and without the 'v' prefix
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.metrics_server_version))
    error_message = "The version should be a valid semantic version. (It should not contain the 'v' prefix)"
  }
}
