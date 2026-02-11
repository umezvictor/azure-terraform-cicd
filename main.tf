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
  storage_account_name  = azurerm_storage_account.dev_account.name
}

# Create a Log Analytics workspace for Application Insight
resource "azurerm_log_analytics_workspace" "dev_analytics" {
  name                = coalesce(var.ws_name, random_string.name.result)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create an Application Insights instance for monitoring
resource "azurerm_application_insights" "dev_app_insights" {
  name                = coalesce(var.ai_name, random_string.name.result)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.dev_analytics.id
}



resource "azurerm_service_plan" "dev_service_plan" {
  name                = "vicdev-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "FC1" #flex consumption plan
  os_type             = "Linux"
}

# resource "azurerm_function_app_flex_consumption" "app" {
#   name                = "vicdev-weatherapi"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   service_plan_id     = azurerm_service_plan.dev_service_plan.id

#   storage_container_type      = "blobContainer"
#   storage_container_endpoint  = "${azurerm_storage_account.dev_account.primary_blob_endpoint}${azurerm_storage_container.dev_storage_container.name}"
#   storage_authentication_type = "StorageAccountConnectionString"
#   storage_access_key          = azurerm_storage_account.dev_account.primary_access_key
#   runtime_name                = "dotnet-isolated"
#   runtime_version             = "8.0"
#   maximum_instance_count      = 50
#   instance_memory_in_mb       = 2048

#   site_config {}
# }

resource "azurerm_linux_function_app" "app" {
  name                = "vicdev-weatherapi"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.dev_account.name
  storage_account_access_key = azurerm_storage_account.dev_account.primary_access_key
  service_plan_id            = azurerm_service_plan.dev_service_plan.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}