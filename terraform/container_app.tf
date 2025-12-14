resource "azurerm_container_app" "app" {
  name                          = var.container_app.name
  container_app_environment_id  = azurerm_container_app_environment.container_app_env.id
  resource_group_name           = azurerm_resource_group.rg.name
  revision_mode                 = "Single"

  ingress {
    allow_insecure_connections = false
    traffic_weight {
      percentage = 100
      latest_revision = true
    }
    external_enabled = true
    target_port      = var.container_app.target_port
  }

  template {
    container {
      name   = var.container_app.service_name
      image  = "${var.container_app.image}:${var.container_app.tag}"
      cpu    = var.container_app.cpu
      memory = var.container_app.memory
    }
  }
  tags = local.all_tags
}
