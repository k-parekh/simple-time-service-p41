resource_group_name             = "simple-time-rg"
location                        = "West US"
vnet_name                       = "simple-time-vnet"
vnet_cidr                       = "10.1.0.0/16"
log_analytics_workspace_name    = "simple-time-log-analytics"
container_app = {
    name = "simple-time-app"
    subnet_name = "aca-private-subnet"
    env_name = "simple-time-env"
    logs_destination = "log-analytics"
    service_name = "simple-time-service"
    image = "parekhk/simple-time-service"
    tag = "latest"
    cpu = 0.5
    memory = "1Gi"
    target_port = 8080
}