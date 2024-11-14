machine:
  kubelet:
    nodeIP:
      validSubnets:
        - ${private_network_subnet_range}
    extraArgs:
      cloud-provider: external
      rotate-server-certificates: true
  features:
    kubernetesTalosAPIAccess:
      enabled: true
      allowedRoles:
        - os:reader
      allowedKubernetesNamespaces:
        - kube-system
  certSANs:
    - ${endpoint}
%{if workers_length <= 0~}
  nodeLabels:
    node.kubernetes.io/exclude-from-external-load-balancers:
      $patch: delete
%{endif~}
  time:
    servers:
      - ntp1.hetzner.de
      - ntp2.hetzner.com
      - ntp3.hetzner.net
      - 0.de.pool.ntp.org
      - 1.de.pool.ntp.org
      - time.cloudflare.com
cluster:
  etcd:
    advertisedSubnets:
      - ${private_network_subnet_range}
%{if workers_length <= 0~}
  allowSchedulingOnControlPlanes: true
%{endif~}
  externalCloudProvider:
    enabled: true
    manifests:
      - https://raw.githubusercontent.com/siderolabs/talos-cloud-controller-manager/main/docs/deploy/cloud-controller-manager.yml
  network:
    cni:
      name: none
  proxy:
    disabled: true
  inlineManifests:
    - name: hcloud-secret
      contents: |-
        apiVersion: v1
        kind: Secret
        metadata:
          name: hcloud
          namespace: kube-system
        type: Opaque
        data:
%{if ccm_hcloud_token != ""~}
          token: ${base64encode(ccm_hcloud_token)}
%{endif~}
          network: ${base64encode(private_network_name)}
