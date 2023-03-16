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

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  source_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.os_image.sku
    version   = var.os_image.version
  }
  tags = var.tag_resources
}

/// MarketPlace Agreement ///
resource "azurerm_marketplace_agreement" "canonical" {
  publisher = var.os_image.publisher
  offer     = var.os_image.offer
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

/// Azure Kubernetes Service ///
resource "azurerm_kubernetes_cluster" "aksOnlyMe" {
  name                = var.aks_description.name
  kubernetes_version  = var.aks_specs.kub_version
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  dns_prefix          = var.aks_description.name

  default_node_pool {
    name                = var.aks_specs.name
    node_count          = var.aks_specs.node_count
    vm_size             = var.aks_specs.vm_size
    type                = var.aks_specs.type
    enable_auto_scaling = var.aks_specs.enable_auto_scaling
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = var.aks_specs.load_balancer_sku
    network_plugin    = var.aks_specs.network_plugin
  }
}
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acrOnlyMe.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aksOnlyMe.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
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
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgassociation" {
  network_interface_id      = azurerm_network_interface.vNIC.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}