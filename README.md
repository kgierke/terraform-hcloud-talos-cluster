# terraform-hcloud-talos

Terraform module for bootstrapping a Kubernetes Cluster on Hetzner Cloud infrastructure using Talos as OS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >=1.43.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.15.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.32.0 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | >=0.6.0 |

## Resources

| Name | Type |
|------|------|
| [hcloud_image.talos](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/data-sources/image) | data source |
| [talos_client_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/client_configuration) | data source |
| [talos_machine_configuration.controlplane](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration) | data source |
| [talos_machine_configuration.worker](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Define the name of the cluster. | `string` | n/a | yes |
| <a name="input_cluster_tld"></a> [cluster\_tld](#input\_cluster\_tld) | Define the top-level domain for the cluster. | `string` | n/a | yes |
| <a name="input_cloud_controller_manager_enabled"></a> [cloud\_controller\_manager\_enabled](#input\_cloud\_controller\_manager\_enabled) | Define if the hcloud-cloud-controller-manager Helm chart should be enabled. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager | `bool` | `true` | no |
| <a name="input_cloud_controller_manager_hcloud_token"></a> [cloud\_controller\_manager\_hcloud\_token](#input\_cloud\_controller\_manager\_hcloud\_token) | Define the Hetzner Cloud API token for the cloud-controller-manager. | `string` | `""` | no |
| <a name="input_cloud_controller_manager_values"></a> [cloud\_controller\_manager\_values](#input\_cloud\_controller\_manager\_values) | Define the values for the hcloud-cloud-controller-manager Helm chart. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager/blob/main/chart/values.yaml | `string` | `""` | no |
| <a name="input_cloud_controller_manager_version"></a> [cloud\_controller\_manager\_version](#input\_cloud\_controller\_manager\_version) | Define the version of the hcloud-cloud-controller-manager Helm chart. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager | `string` | `"1.20.0"` | no |
| <a name="input_controlplanes"></a> [controlplanes](#input\_controlplanes) | List of controlplane nodes, should be either 1 or 3 nodes. | <pre>list(object({<br/>    name        = string<br/>    server_type = string<br/>    location    = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "location": "hel1",<br/>    "name": "columbia",<br/>    "server_type": "cx22"<br/>  }<br/>]</pre> | no |
| <a name="input_controlplanes_config"></a> [controlplanes\_config](#input\_controlplanes\_config) | Define the configuration for the controlplane nodes. | `string` | `""` | no |
| <a name="input_csi_enabled"></a> [csi\_enabled](#input\_csi\_enabled) | Define if the hcloud-csi Helm chart should be enabled. See: https://github.com/hetznercloud/csi-driver | `bool` | `true` | no |
| <a name="input_csi_values"></a> [csi\_values](#input\_csi\_values) | Define the values for the hcloud-csi Helm chart. See: https://github.com/hetznercloud/csi-driver/blob/main/chart/values.yaml | `string` | `""` | no |
| <a name="input_csi_version"></a> [csi\_version](#input\_csi\_version) | Define the version of the hcloud-csi Helm chart. See: https://github.com/hetznercloud/csi-driver | `string` | `"2.9.0"` | no |
| <a name="input_ingress_certmanager_email"></a> [ingress\_certmanager\_email](#input\_ingress\_certmanager\_email) | Define the email address for the cert-manager. | `string` | `""` | no |
| <a name="input_ingress_certmanager_values"></a> [ingress\_certmanager\_values](#input\_ingress\_certmanager\_values) | Define the values for the cert-manager. | `string` | `""` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Define if the traefik ingress controller should be enabled. | `bool` | `true` | no |
| <a name="input_ingress_load_balancer_location"></a> [ingress\_load\_balancer\_location](#input\_ingress\_load\_balancer\_location) | Define the location of the load balancer for the ingress controller. | `string` | `"hel1"` | no |
| <a name="input_ingress_load_balancer_type"></a> [ingress\_load\_balancer\_type](#input\_ingress\_load\_balancer\_type) | Define the type of the load balancer for the ingress controller. | `string` | `"lb11"` | no |
| <a name="input_ingress_traefik_values"></a> [ingress\_traefik\_values](#input\_ingress\_traefik\_values) | Define the values for the traefik ingress controller. | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Define the version of Kubernetes to use. | `string` | `"1.31.1"` | no |
| <a name="input_network_zone"></a> [network\_zone](#input\_network\_zone) | Define the zone of the network. | `string` | `"eu-central"` | no |
| <a name="input_private_network_ip_range"></a> [private\_network\_ip\_range](#input\_private\_network\_ip\_range) | Define the IP range of the private network. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_private_network_name"></a> [private\_network\_name](#input\_private\_network\_name) | Define the name of the private network. | `string` | `"internal"` | no |
| <a name="input_private_network_subnet_range"></a> [private\_network\_subnet\_range](#input\_private\_network\_subnet\_range) | Define the subnet range of the private network. | `string` | `"10.0.0.0/24"` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Define the version of Talos to use. | `string` | `"1.8.0"` | no |
| <a name="input_workers"></a> [workers](#input\_workers) | List of worker nodes. | <pre>list(object({<br/>    name        = string<br/>    server_type = string<br/>    location    = string<br/>  }))</pre> | `[]` | no |
| <a name="input_workers_config"></a> [workers\_config](#input\_workers\_config) | Define the configuration for the worker nodes. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controlplanes"></a> [controlplanes](#output\_controlplanes) | List of controlplane nodes. Can be used to create DNS records for the controlplane nodes. |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubeconfig for the cluster. |
| <a name="output_servers"></a> [servers](#output\_servers) | List of all nodes including controlplanes and workers. |
| <a name="output_talosconfig"></a> [talosconfig](#output\_talosconfig) | Talos configuration for the cluster. |
| <a name="output_workers"></a> [workers](#output\_workers) | List of worker nodes. Can be used to create DNS records for the worker nodes. |
<!-- END_TF_DOCS -->

## Documentation

The documentation is automatically generated with the help of [terraform-docs](https://terraform-docs.io/). To generate the documentation, run the following command:

```shell
terraform-docs .
```
