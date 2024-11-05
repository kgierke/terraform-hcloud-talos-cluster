machine:
  kubelet:
    nodeIP:
      validSubnets:
        - ${private_network_subnet_range}
cluster:
  etcd:
    advertisedSubnets:
      - ${private_network_subnet_range}
  externalCloudProvider:
    enabled: true
  time:
    servers:
      - ntp1.hetzner.de
      - ntp2.hetzner.com
      - ntp3.hetzner.net
      - 0.de.pool.ntp.org
      - 1.de.pool.ntp.org
      - time.cloudflare.com
