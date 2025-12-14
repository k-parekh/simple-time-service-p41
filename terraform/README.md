# SimpleTimeService Terraform Deployment

This Terraform project provisions the required Azure infrastructure to host the `SimpleTimeService` container application. The setup is designed to deploy your container securely into a private subnet with a public-facing load balancer or container app endpoint.

## Project Structure

* `main.tf` - Core Terraform configuration to create resources.
* `variables.tf` - Contains all variables with descriptions, defaults, and validations.
* `outputs.tf` - Exposes outputs such as the Container App URL.
* `provider.tf` - Configures the Azure provider.
* `networks.tf` - Creates VNet, public and private subnets.
* `container_apps.tf` - Deploys the Container App environment and app.
* `locals.tf` - Calculates subnet maps and network bits.
* `terraform.tfvars` - Optional file for overriding variable defaults.

## Requirements

* Terraform >= 1.5.0
* Azure CLI installed and logged in
* Azure subscription with Contributor or Owner permissions
* `Microsoft.App` provider registered in the subscription

## How the Terraform Code Works

1. **Variables**

   * All configurable values are in `variables.tf`.
   * Includes resource group, location, VNet name, CIDR ranges, subnet counts, container app configurations, and tags.
   * Validations ensure correct CIDR ranges and subnet sizes.

2. **Locals**

   * Calculates the total requested subnets and maximum supported subnets.
   * Generates maps for public and private subnets.
   * Computes subnet sizes specifically for the container app (`/23`).

3. **VNet and Subnets**

   * A VPC (Virtual Network) is created using the `vnet_cidr`.
   * Public and private subnets are created dynamically using `for_each` loops.
   * The container app subnet is delegated to `Microsoft.App/environments` for Azure Container Apps.

4. **Container App Environment**

   * Creates a managed environment for Azure Container Apps.
   * Subnet delegation ensures that the container app runs securely in the private subnet.
   * Logs can be configured to Log Analytics workspace.

5. **Container App Deployment**

   * Deploys the `SimpleTimeService` container.
   * Configurable resources: CPU, memory, image, tag, and exposed port.
   * Public endpoint managed automatically if `external_enabled = true`.

6. **Outputs**

   * Provides the URL for the deployed container app.

## Steps to Deploy Locally

1. **Login to Azure**

```
az login
```

2. **Select Subscription**

```
az account set --subscription <your-subscription-id>
```

3. **Register Required Providers**

```
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Network
```

4. **Initialize Terraform**

```
terraform init
```

5. **Plan the Deployment**

```
terraform plan
```

6. **Apply the Deployment**

```
terraform apply
```

7. **Access the Application**

   * Once deployment completes, note the `container_app_url` output.
   * Open it in your browser or use `curl`.

## Notes

* Ensure that the subscription allows automatic provider registration; otherwise, registration must be done manually.
* Validate that the CIDR ranges in `variables.tf` do not overlap with existing networks.
* The subnet for container app is fixed as `/23` to satisfy Azure requirements.
* Use `terraform destroy` to clean up resources after testing.

## References

* [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview)
* [Subnet CIDR Calculations](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
