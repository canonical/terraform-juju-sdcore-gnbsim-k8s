# SD-Core GNBSIM K8s Terraform Module

This SD-Core GNBSIM K8s Terraform module aims to deploy the [sdcore-gnbsim-k8s charm](https://charmhub.io/sdcore-gnbsim-k8s) via Terraform.

## Getting Started

### Prerequisites

The following software and tools needs to be installed and should be running in the local environment.

- `microk8s`
- `juju 3.x`
- `terrafom`

### Deploy sdcore-gnbsim-k8s using Terraform

Make sure that `storage`, `multus` and `metallb` plugins are enabled for Microk8s:

```console
sudo microk8s enable hostpath-storage multus
sudo microk8s enable metallb:10.0.0.2-10.0.0.4
```

Add a Juju model:

```console
juju add model <model-name>
```

Initialise the provider:

```console
terraform init
```

Customize the configuration inputs under `terraform.tfvars` file according to requirement.

Replace the `model-name` and `amf-application-name` in the `terraform.tfvars` file:

```yaml
model_name =<your model-name>
amf_application_name =<your nrf app name>
```

Run Terraform Plan by providing var-file:

```console
terraform plan -var-file="terraform.tfvars" 
```

Deploy the resources, skip the approval:

```console
terraform apply -auto-approve 
```

### Check the Output

Run `juju switch <juju model>` to switch to the target Juju model and observe the status of the applications.

```console
juju status --relations
```

### Clean up 

Remove the applications:

```console
terraform destroy -auto-approve
```

