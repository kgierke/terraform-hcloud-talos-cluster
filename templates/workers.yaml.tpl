machine:
  kubelet:
    nodeIP:
      validSubnets:
        - ${private_network_subnet_range}
    extraArgs:
      cloud-provider: external
      rotate-server-certificates: true
  certSANs:
    - ${endpoint}
  time:
    servers:
      - ntp1.hetzner.de
      - ntp2.hetzner.com
      - ntp3.hetzner.net
      - 0.de.pool.ntp.org
      - 1.de.pool.ntp.org
      - time.cloudflare.com
cluster:
  externalCloudProvider:
    enabled: true
    manifests:
      - https://raw.githubusercontent.com/siderolabs/talos-cloud-controller-manager/main/docs/deploy/cloud-controller-manager.yml
  network:
    cni:
      name: none
