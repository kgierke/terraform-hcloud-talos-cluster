data "helm_template" "cilium" {
  name      = "cilium"
  namespace = "kube-system"

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = var.cilium_version

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  set {
    name  = "securityContext.capabilities.ciliumAgent"
    value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
  }

  set {
    name  = "securityContext.capabilities.cleanCiliumState"
    value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
  }

  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  set {
    name  = "k8sServiceHost"
    value = "localhost"
  }

  set {
    name  = "k8sServicePort"
    value = "7445"
  }
}

data "helm_template" "hcloud_ccm" {
  name      = "hcloud-cloud-controller-manager"
  namespace = "kube-system"

  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  version    = var.ccm_version
}

data "helm_template" "hcloud_csi" {
  name      = "hcloud-csi"
  namespace = "kube-system"

  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-csi"
  version    = var.csi_version
}
