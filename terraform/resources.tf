resource "azurerm_resource_group" "arg" {
  name     = var.resource_group_name
  location = var.location_name
  tags     = var.tag_resources
}
/// Azure Virtual Machine ///
resource "azurerm_linux_virtual_machine" "vMachine" {
  name                  = var.os_image.name
  location              = azurerm_resource_group.arg.location
  resource_group_name   = azurerm_resource_group.arg.name
  size                  = var.VirtualMachine.VM.size
  admin_username        = var.ssh_user
  network_interface_ids = [azurerm_network_interface.vNIC.id]

  os_disk {
    name                 = var.os_image.name
    caching              = var.VirtualMachine.VM.caching
    storage_account_type = var.VirtualMachine.VM.storage_account_type
  }

  plan {
    name      = var.os_image.name
    product   = var.os_image.name
    publisher = var.os_image.publisher
  }
  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  source_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.name
    sku       = var.os_image.name
    version   = var.os_image.version
  }
  tags = var.tag_resources
}

/// MarketPlace Agreement ///
resource "azurerm_marketplace_agreement" "cognosys" {
  publisher = var.os_image.publisher
  offer     = var.os_image.name
  plan      = var.os_image.name
}

/// Azure Container Registry ///
resource "azurerm_container_registry" "acrOnlyMe" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tag_resources
}
/// Network Interface ///
resource "azurerm_virtual_network" "vNetwork" {
  name                = var.vNetworkName
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  tags                = var.tag_resources
}
resource "azurerm_subnet" "vSubnet" {
  name                 = var.vSubnetName
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.vNetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_interface" "vNIC" {
  name                = "vNIC"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.vSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.VirtualMachine.VM.IP
    public_ip_address_id          = azurerm_public_ip.vIPPublic.id
  }
  tags = var.tag_resources
}
resource "azurerm_public_ip" "vIPPublic" {
  name                = "vIPPublic"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tag_resources
}

/// Network Sec & Rules ///
resource "azurerm_network_security_group" "nsg" {
  name                = "NSG"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  tags                = var.tag_resources

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "85.55.192.161"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Ingress"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000-32767"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgassociation" {
  network_interface_id      = azurerm_network_interface.vNIC.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}