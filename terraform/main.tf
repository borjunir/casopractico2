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
#Configuracion Azure Provider. Deletion de recursos para las pruebas
provider "azurerm" {
  features {
    resource_group {
	prevent_deletion_if_contains_resources = false
    }
  }
}
