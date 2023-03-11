resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location_name
}
/// Azure Virtual Machine ///
resource "azurerm_linux_virtual_machine" "VirtualMachine" {
  name                  = var.azure_image_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = var.VirtualMachine.VM.size
  admin_username        = var.ssh_user
  network_interface_ids = [azurerm_network_interface.NIC.id]
  os_disk {
    name              = var.azure_image_name
    caching           = var.VirtualMachine.VM.caching
    storage_account_type = var.VirtualMachine.VM.storage_account_type
  }
  source_image_reference {
    publisher = var.azure_image_publisher
    offer     = var.azure_image_name
    sku       = var.azure_image_sku
    version   = var.azure_image_version
  }
  computer_name = var.azure_image_name
  admin_ssh_key {
    username = var.ssh_user
    public_key = file(var.public_key_path)
  }
}
/// Network Interface ///
resource "azurerm_virtual_network" "vnetwork" {
  name                = var.NetworkName
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "vsubnet" {
  name                 = var.VSubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_interface" "NIC" {
  name                = "vNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.vsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = var.VirtualMachine.VM.IP
  }
}

/// Network Sec & Rules ///
resource "azurerm_network_security_group" "sg" {
  name = "SG"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "ssh" {
  name = "SSH"
  priority = 1001
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}
resource "azurerm_network_security_rule" "ingress" {
  name = "Ingress"
  priority = 1002
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "30000-32767"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}