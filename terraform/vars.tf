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
  description = "User SSH"
  default = "<SSH USER>"
}
/// Descripcion Imagenes ///
variable "image_name" {
  description = "Nombre de la imagen a utilizar"
  default = "centos-8-stream-free"
}
variable "image_version" {
  description = "Version de la imagen a utilizar"
  default = "latest"
}
variable "image_publisher" {
  description = "MarketPlace Proveedor imagen"
  default = "Cognosys"
}