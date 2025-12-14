resource "azurerm_container_app_environment" "container_app_env" {
  name                        = var.container_app.env_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  logs_destination            = var.container_app.logs_destination
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.log_analytics.id
  tags = local.all_tags
}
