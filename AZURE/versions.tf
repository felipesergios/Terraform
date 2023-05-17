terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.56.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  tenant_id       = "ad53d7d5-77ac-4727-a43c-c4d65b6bd57c"
}