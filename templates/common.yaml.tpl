version: v1alpha1
machine:
  kubelet:
    nodeIP:
      validSubnets:
        - ${private_network_subnet_range}
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
  network:
    cni:
      name: none
    proxy:
      disabled: true
  inlineManifests:
    - name: cilium
      contents: ${cilium_manifest}
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
    - name: hcloud-ccm
      contents: ${ccm_manifest}
    - name: hcloud-csi
      contents: ${csi_manifest}
