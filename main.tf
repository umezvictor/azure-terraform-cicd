terraform {
  required_version = ">=1.9.0"
  cloud {
    organization = "victorblaze22"
    workspaces {
      name = "azure-terraform-cicd"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.8.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "West Europe"
  name     = "cicd"
}

# Random String for unique naming of resources
resource "random_string" "name" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "azurerm_storage_account" "dev_account" {
  name                     = "stgvic2012dev"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "development"
  }
}


# Create a storage container
resource "azurerm_storage_container" "dev_storage_container" {
  name                  = "appcontainer"
  container_access_type = "private"
  storage_account_id    = azurerm_storage_account.dev_account.id
}