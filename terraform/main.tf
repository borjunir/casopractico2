#Configuracion terraform Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
  required_version = ">= 1.1.0"
}
#Azure Provider con delete resources activado
provider "azurerm" {
  features {
    }
}
