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
  default     = "1.31.1"
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

# Ingress related variables
variable "ingress_enabled" {
  type        = bool
  description = "Define if the traefik ingress controller should be enabled."
  default     = true
}

variable "ingress_traefik_values" {
  type        = string
  description = "Define the values for the traefik ingress controller."
  default     = ""
}

variable "ingress_certmanager_values" {
  type        = string
  description = "Define the values for the cert-manager."
  default     = ""
}

variable "ingress_certmanager_email" {
  type        = string
  description = "Define the email address for the cert-manager."
  default     = ""
}

variable "ingress_load_balancer_location" {
  type        = string
  description = "Define the location of the load balancer for the ingress controller."
  default     = "hel1"
}

variable "ingress_load_balancer_type" {
  type        = string
  description = "Define the type of the load balancer for the ingress controller."
  default     = "lb11"
}

# Cloud Controller Manager related variables
variable "cloud_controller_manager_enabled" {
  type        = bool
  description = "Define if the hcloud-cloud-controller-manager Helm chart should be enabled. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager"
  default     = true
}

variable "cloud_controller_manager_hcloud_token" {
  type        = string
  description = "Define the Hetzner Cloud API token for the cloud-controller-manager."
  default     = ""
}

variable "cloud_controller_manager_version" {
  type        = string
  description = "Define the version of the hcloud-cloud-controller-manager Helm chart. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager"
  default     = "1.20.0"
}

variable "cloud_controller_manager_values" {
  type        = string
  description = "Define the values for the hcloud-cloud-controller-manager Helm chart. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager/blob/main/chart/values.yaml"
  default     = ""
}

# Container Storage Interface related variables
variable "csi_enabled" {
  type        = bool
  description = "Define if the hcloud-csi Helm chart should be enabled. See: https://github.com/hetznercloud/csi-driver"
  default     = true
}

variable "csi_version" {
  type        = string
  description = "Define the version of the hcloud-csi Helm chart. See: https://github.com/hetznercloud/csi-driver"
  default     = "2.9.0"
}

variable "csi_values" {
  type        = string
  description = "Define the values for the hcloud-csi Helm chart. See: https://github.com/hetznercloud/csi-driver/blob/main/chart/values.yaml"
  default     = ""
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
