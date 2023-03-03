#Configuracion terraform Azure provider
terraform {
  requiered_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
  required_version = ">= 1.1.0"
}
#Configuracion Azure Provider
provider "azurerm" {
  features {}
}
