# terraform-hcloud-talos

Terraform module for bootstrapping a Kubernetes Cluster on Hetzner Cloud infrastructure using Talos as OS.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13
- [Hetzner Cloud Provider](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs) >= 1.43.0
- [Packer](https://www.packer.io/downloads) >= 1.7.0

Before you can run this module, you need to create a custom Talos image with Packer. You can find an example Packer template in the `packer` directory. The Packer template will create a Talos snapshot in your Hetzner Cloud Project.

## Features

This module will create a Kubernetes cluster on Hetzner Cloud infrastructure using Talos as the operating system. The module supports the following features:

### Controlplane nodes

You can set the number of controlplane nodes to either 1 or 3. The controlplane nodes are created with the specified server type and location.

_Example:_

```hcl
controlplanes = [
  {
    name        = "columbia"
    server_type = "cx22"
    location    = "hel1"
  }
]
```

The above example would create a single controlplane node named `columbia` with the server type `cx22` in the location `hel1`.

**Important:**

Controlplanes and Workers can only be created in the same region! Be sure to also set the `network_zone` to the correct region (By default it's set to `eu-central`).

### Worker nodes

You can add as many worker nodes as you like. The worker nodes are created with the specified server type and location. If you don't specify any worker nodes, no worker nodes will be created and the controlplanes nodes will run workloads.

_Example:_

```hcl
workers = [
  {
    name        = "worker-1"
    server_type = "cx11"
    location    = "hel1"
  },
  {
    name        = "worker-2"
    server_type = "cx11"
    location    = "hel1"
  }
]
```

The above example would create two worker nodes named `worker-1` and `worker-2` with the server type `cx11` in the location `hel1`.

**Important:**

Controlplanes and Workers can only be created in the same region! Be sure to also set the `network_zone` to the correct region (By default it's set to `eu-central`).

### Cloud Controller Manager & CSI Driver

By default the module will install the Hetzner Cloud Controller Manager and Container Storage Interface (CSI) driver. Both are installed through the `extraManifests` option of talos. You can disable the installation of the Cloud Controller Manager and CSI driver by setting the `ccm_enabled` and `csi_enabled` variables to `false`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >=1.43.0 |
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
| <a name="input_ccm_enabled"></a> [ccm\_enabled](#input\_ccm\_enabled) | Define if the hcloud-cloud-controller-manager Helm chart should be enabled. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager | `bool` | `true` | no |
| <a name="input_ccm_hcloud_token"></a> [ccm\_hcloud\_token](#input\_ccm\_hcloud\_token) | Define the Hetzner Cloud API token for the cloud-controller-manager. | `string` | `""` | no |
| <a name="input_ccm_manifest_url"></a> [ccm\_manifest\_url](#input\_ccm\_manifest\_url) | Define the URL to the Hetzner Cloud Controller Manager manifest to be deployed. Defaults to 'https://raw.githubusercontent.com/hetznercloud/hcloud-cloud-controller-manager/v<var.ccm\_version>/deploy/ccm-networks.yaml'. | `string` | `""` | no |
| <a name="input_ccm_version"></a> [ccm\_version](#input\_ccm\_version) | Define the version of the hcloud-cloud-controller-manager Helm chart. See: https://github.com/hetznercloud/hcloud-cloud-controller-manager | `string` | `"1.20.0"` | no |
| <a name="input_controlplanes"></a> [controlplanes](#input\_controlplanes) | List of controlplane nodes, should be either 1 or 3 nodes. | <pre>list(object({<br/>    name        = string<br/>    server_type = string<br/>    location    = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "location": "hel1",<br/>    "name": "columbia",<br/>    "server_type": "cx22"<br/>  }<br/>]</pre> | no |
| <a name="input_controlplanes_config"></a> [controlplanes\_config](#input\_controlplanes\_config) | Define the configuration for the controlplane nodes. | `string` | `""` | no |
| <a name="input_csi_enabled"></a> [csi\_enabled](#input\_csi\_enabled) | Define if the hcloud-csi Helm chart should be enabled. See: https://github.com/hetznercloud/csi-driver | `bool` | `true` | no |
| <a name="input_csi_manifest_url"></a> [csi\_manifest\_url](#input\_csi\_manifest\_url) | Define the URL to the Hetzner Cloud CSI Driver manifest to be deployed. Defaults to 'https://raw.githubusercontent.com/hetznercloud/csi-driver/refs/tags/v<var.csi\_version>/deploy/kubernetes/hcloud-csi.yml'. | `string` | `""` | no |
| <a name="input_csi_version"></a> [csi\_version](#input\_csi\_version) | Define the version of the hcloud-csi Helm chart. See: https://github.com/hetznercloud/csi-driver | `string` | `"2.9.0"` | no |
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
