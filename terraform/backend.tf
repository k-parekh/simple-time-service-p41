terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "p41tfstatesa"
    container_name       = "tfstate"
    key                  = "simple-time-service/terraform.tfstate"
  }
}
