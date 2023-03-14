/// AZURE ///
variable "resource_group_name" {
  description = "ResourceGroup creado por Terraform"
  default     = "rg-CP02UNIR"
}
variable "location_name" {
  type        = string
  description = "Region de Azure donde crearemos la infraestructura"
  default     = "uksouth"
}
variable "acr_name" {
  description = "Nombre Azure Container Registry"
  default     = "acrOnlyMe"
}
variable "aks_description" {
  description = "Descripcion Azure Kubernetes Service"
  type = object({
    name = string
    version = string
  })
  default = {
    name = "aksOnlyMe"
  }
}
variable "aks_specs" {
  description = "Especificaciones Azure Kubernetes Service"
  type = object({
    name = string
    version = string
    node_count = string
    vm_size = string
    type = string
    enable_auto_scaling = string
    load_balancer_sku = string
    network_plugin = string
  })
  default = {
    enable_auto_scaling = "false"
    name = "system"
    kub_version = "1.25.5"
    node_count = "value"
    type = "VirtualMachineScaleSets"
    vm_size = "Standard_DS2_v2"
    load_balancer_sku = "basic"
    network_plugin = "kubenet"
  }
}
/// Credenciales ///
variable "public_key_path" {
  type        = string
  description = "Path clave publica acceso instancias"
  default     = "~/.ssh/id_rsa.pub"
}
variable "ssh_user" {
  type        = string
  description = "Admin User SSH"
  default     = "AzureAdmin"
}

/// OS VirtualMachine ///
variable "os_image" {
  description = "Nombre de la imagen a utilizar"
  type = object({
    name      = string
    version   = string
    publisher = string
  })
  default = {
    name      = "centos-8-stream-free"
    version   = "22.03.28"
    publisher = "cognosys"
  }
}

/// Caracteristicas VirtualMachine ///
variable "VirtualMachine" {
  description = "Caracteristicas de la imagen"
  type        = map(any)
  default = {
    "VM" = {
      size                 = "Standard_B2s"
      IP                   = "10.0.1.10"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
  }
}

/// Netwrok Vars ///
variable "vNetworkName" {
  description = "Azure Virtual Network name"
  default     = "vNetwork1"
}

variable "vSubnetName" {
  description = "Sub-Network name"
  default     = "vSubnet1"
}

/// Tags ///
variable "tag_resources" {
  description = "Tags para todos los recursos"
  type        = map(string)
  default = {
    environment = "casopractico2"
  }
}