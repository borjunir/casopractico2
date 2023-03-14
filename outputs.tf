output "vIPPublic" {
  value = azurerm_public_ip.vIPPublic.ip_address
}
output "resource_group_id" {
  value = azurerm_resource_group.arg.id
}