#Variables
variable "location" {
  type = string
  description = "Region de Azure donde crearemos la infraestructura"
  default = "<YOUR REGION>"
}

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