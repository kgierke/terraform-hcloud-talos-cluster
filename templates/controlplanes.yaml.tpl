machine:
  kubelet:
    nodeIP:
      validSubnets:
        - ${private_network_subnet_range}
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
%{if workers_length <= 0~}
  nodeLabels:
    node.kubernetes.io/exclude-from-external-load-balancers:
      $patch: delete
%{endif~}
cluster:
  allowSchedulingOnControlPlanes: true
  externalCloudProvider:
    enabled: true
  extraManifests:
%{if ccm_enabled~}
    - ${ccm_manifest_url}
%{endif~}
%{if csi_enabled~}
    - ${csi_manifest_url}
%{endif~}
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
