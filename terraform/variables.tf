#####################################
# Resource Group
#####################################

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = "resource-group"

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 2
    error_message = "Resource group name must be at least 3 characters long."
  }
}

#####################################
# Location
#####################################

variable "location" {
  type        = string
  description = "Location for the Resources in Azure"
  default     = "East US"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "Location must not be empty."
  }
}

#####################################
# Virtual Network
#####################################

variable "vnet_name" {
  type        = string
  description = "Name for the Virtual Network which will have all the subnets"
  default     = "vnet"

  validation {
    condition     = length(trimspace(var.vnet_name)) >= 2
    error_message = "VNet name must be at least 2 characters long."
  }
}

variable "vnet_cidr" {
  type        = string
  description = "Virtual Network CIDR address space"
  default     = "10.0.0.0/16"

  # Valid CIDR
  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0))
    error_message = "The VNet CIDR must be a valid IPv4 CIDR block (e.g. 10.0.0.0/16)."
  }

  # RFC1918 private ranges
  validation {
    condition = (
      startswith(var.vnet_cidr, "10.") ||
      startswith(var.vnet_cidr, "172.16.") ||
      startswith(var.vnet_cidr, "172.17.") ||
      startswith(var.vnet_cidr, "172.18.") ||
      startswith(var.vnet_cidr, "172.19.") ||
      startswith(var.vnet_cidr, "172.2")  || # 172.20–172.29
      startswith(var.vnet_cidr, "172.30.") ||
      startswith(var.vnet_cidr, "172.31.") ||
      startswith(var.vnet_cidr, "192.168.")
    )
    error_message = "VNet CIDR must be within RFC1918 private ranges."
  }

  # Prefix size constraint
  validation {
    condition = (
      tonumber(split("/", var.vnet_cidr)[1]) >= 16 &&
      tonumber(split("/", var.vnet_cidr)[1]) <= 24
    )
    error_message = "VNet CIDR prefix must be between /16 and /24."
  }
}

variable "subnet_newbits" {
  type        = number
  description = "Additional bits for subnetting (e.g. 8 = /24 from /16)"
  default     = 8

  validation {
    condition     = var.subnet_newbits >= 2 && var.subnet_newbits <= 10
    error_message = "subnet_newbits must be between 2 and 10."
  }
}

#####################################
# Public Subnets
#####################################

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets"
  default     = 2

  validation {
    condition     = var.public_subnet_count >= 0 && var.public_subnet_count <= 20
    error_message = "Public subnet count must be between 0 and 20."
  }
}

variable "public_subnet_prefix" {
  type        = string
  description = "Prefix for all public subnet(s)"
  default     = "sts"

  validation {
    condition     = var.public_subnet_prefix == "" || length(var.public_subnet_prefix) >= 2
    error_message = "Public subnet prefix must be empty or at least 2 characters long."
  }
}

#####################################
# Private Subnets
#####################################
variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets (excluding Container App subnet)"
  default     = 1

  validation {
    condition     = var.private_subnet_count >= 0 && var.private_subnet_count <= 50
    error_message = "Private subnet count must be between 0 and 50."
  }
}

variable "private_subnet_prefix" {
  type        = string
  description = "Prefix for all private subnet(s)"
  default     = "sts"

  validation {
    condition     = var.private_subnet_prefix == "" || length(var.private_subnet_prefix) >= 2
    error_message = "Private subnet prefix must be empty or at least 2 characters long."
  }
}

#####################################
# Log Analytics
#####################################

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace"
  default     = "log-analytics"

  validation {
    condition     = length(trimspace(var.log_analytics_workspace_name)) >= 3
    error_message = "Log Analytics workspace name must be at least 3 characters long."
  }
}

#####################################
# Container App Configuration
#####################################

variable "container_app" {
  type = object({
    name              = string
    subnet_name       = string
    env_name          = string
    logs_destination  = string
    service_name      = string
    image             = string
    tag               = string
    cpu               = number
    memory            = string
    target_port       = number
  })
  description = "This variable will determine all the container app related things"
  default = {
    name = "app"
    subnet_name = "aca-private-subnet"
    env_name = "app-env"
    logs_destination = "log-analytics"
    service_name = "app-service"
    image = "parekhk/simple-time-service"
    tag = "latest"
    cpu = 0.5
    memory = "1Gi"
    target_port = 8080
  }

  validation {
    condition     = var.container_app.cpu > 0 && var.container_app.cpu <= 4
    error_message = "Container App CPU must be between 0.25 and 4 vCPU."
  }

  validation {
    condition     = contains(["0.5Gi", "1Gi", "2Gi", "4Gi", "8Gi"], var.container_app.memory)
    error_message = "Container App memory must be one of: 0.5Gi, 1Gi, 2Gi, 4Gi, 8Gi."
  }

  validation {
    condition     = var.container_app.target_port > 0 && var.container_app.target_port <= 65535
    error_message = "Target port must be a valid TCP port (1-65535)."
  }
}

#####################################
# Tags
#####################################

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
  default     = {}

  validation {
    condition     = length(var.tags) <= 20
    error_message = "A maximum of 20 tags is allowed."
  }
}
