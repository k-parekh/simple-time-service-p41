locals {
  total_requested_subnets = (
    var.public_subnet_count +
    var.private_subnet_count +
    1 # Subnet for the container_app
  )
  
  max_supported_subnets = pow(
    2,
    var.subnet_newbits
  )

  public_subnets = {
    for i in range(var.public_subnet_count) :
    "public-${i + 1}" => i
  }

  private_subnets = {
    for i in range(var.private_subnet_count) :
    "private-${i + 1}" => i + var.public_subnet_count
  }

  container_apps_newbits = (
    23 -
    tonumber(split("/", var.vnet_cidr)[1])
  )
  
  required_tags = {
    Creator : "Kunal Parekh"
    Purpose : "Challenge"
    Company : "Particle41"
  }
  all_tags = merge(local.required_tags, var.tags)
}