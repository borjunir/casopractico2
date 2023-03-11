/// AZURE ///
variable "resource_group_name" {
  description = "ResourceGroup creado por Terraform"
  default = "rg-ByTerraform"
}
variable "location_name" {
  type = string
  description = "Region de Azure donde crearemos la infraestructura"
  default = "uksouth"
}
/// Credenciales ///
variable "public_key_path" {
  type = string
  description = "Path clave publica acceso instancias"
  default = "~/.ssh/id_rsa.pub"
}
variable "ssh_user" {
  type = string
  description = "Admin User SSH"
  default = "AzureAdmin"
}

/// Descripcion VirtualMachine ///
variable "azure_image_name" {
  description = "Nombre de la imagen a utilizar"
  default = "centos-8-stream-free"
}
variable "azure_image_version" {
  description = "Version de la imagen a utilizar"
  default = "22.03.28"
}
variable "azure_image_publisher" {
  description = "MarketPlace Proveedor imagen"
  default = "cognosys"
}

/// Caracteristicas VirtualMachine ///
variable "VirtualMachine" {
  description = "Caracteristicas de la imagen"
  type = map(any)
  default = {
    "VM" = {
      size = "Standard_B2s"
      IP = "10.0.1.10"
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
  }
}

/// Netwrok Vars ///
variable "NetworkName" {
  description = "Azure Virtual Network name"
  default     = "vnetwork1"
}

variable "vSubnetName" {
  description = "Sub-Network name"
  default     = "subnet1"
}

/// Tags ///
variable "tag_resources" {
  description = "Tags para todos los recursos"
  type        = map(string)
  default = {
    environment = "casopractico2"
  }
}