output "resource_group_id" {
  value = azurerm_resource_group.arg.id
}

output "vMachine_id" {
  value = azurerm_linux_virtual_machine.vMachine.id
}

output "vIPPublic" {
  value = azurerm_public_ip.vIPPublic.ip_address
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aksOnlyMe.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aksOnlyMe.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aksOnlyMe.node_resource_group
}

output "acr_id" {
  value = azurerm_container_registry.acrOnlyMe.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acrOnlyMe.login_server
}

output "admin_username" {
  value       = azurerm_container_registry.acrOnlyMe.admin_username
  sensitive   = true
}

output "admin_password" {
  value       = azurerm_container_registry.acrOnlyMe.admin_password
  sensitive   = true
}