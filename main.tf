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
  #subscription_id = "c0239a41-ee80-487d-bb52-bc38e45b9cb5"
}

resource "azurerm_resource_group" "dev_rg" {
  location = "West Europe"
  name     = "devops"
}

resource "azurerm_storage_account" "dev_account" {
  name                     = "stgvic2012dev"
  resource_group_name      = azurerm_resource_group.dev_rg.name
  location                 = azurerm_resource_group.dev_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "development"
  }
}