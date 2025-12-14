resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public" {
  for_each             = local.public_subnets
  name                 = "${var.public_subnet_prefix}-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [
    cidrsubnet(
      var.vnet_cidr,
      var.subnet_newbits,
      each.value
    )
  ]
}

resource "azurerm_subnet" "private" {
  for_each             = local.private_subnets
  name                 = "${var.private_subnet_prefix}-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [
    cidrsubnet(
      var.vnet_cidr,
      var.subnet_newbits,
      each.value
    )
  ]
}

resource "azurerm_subnet" "aca_private" {
  name                 = var.container_app.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  # /23 is recommended by Azure for Container Apps
  address_prefixes = [cidrsubnet(
      var.vnet_cidr,
      local.container_apps_newbits,
      var.public_subnet_count + var.private_subnet_count
    )]

  delegation {
    name = "containerapps-delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# Validations for the networks

resource "null_resource" "subnet_validation" {
  lifecycle {
    precondition {
      condition     = local.total_requested_subnets <= local.max_supported_subnets
      error_message = <<EOT
Requested ${local.total_requested_subnets} subnets but VNet CIDR only supports
${local.max_supported_subnets} subnets with subnet_newbits=${var.subnet_newbits}.
EOT
    }
  }
}

resource "null_resource" "container_apps_validation" {
  lifecycle {
    precondition {
      condition = (
        tonumber(split("/", var.vnet_cidr)[1]) <=
        23
      )
      error_message = "VNet CIDR must be equal to or larger than /23 to support Azure Container Apps."
    }
  }
}