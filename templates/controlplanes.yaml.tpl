version: v1alpha1
machine:
  certSANs:
    - ${endpoint}
%{if workers_length <= 0~}
  nodeLabels:
    node.kubernetes.io/exclude-from-external-load-balancers:
      $patch: delete
%{endif~}
cluster:
  etcd:
    advertisedSubnets:
      - ${private_network_subnet_range}
%{if workers_length <= 0~}
  allowSchedulingOnControlPlanes: true
%{endif~}
