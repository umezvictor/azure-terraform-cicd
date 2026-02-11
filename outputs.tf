output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "sa_name" {
  value = azurerm_storage_account.dev_account.name
}

output "asp_name" {
  value = azurerm_service_plan.dev_service_plan.name
}

output "fa_name" {
  value = azurerm_linux_function_app.app.name
}

output "fa_url" {
  value = "https://${azurerm_linux_function_app.app.name}.azurewebsites.net"
}