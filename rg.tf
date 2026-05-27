
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG" {
  name     = "RG1"
  location = "Central India"
}

resource "azurerm_resource_group" "RG" {
  name     = "RG2"
  location = "Central India"
}

resource "azurerm_resource_group" "RG" {
  name     = "RG3"
  location = "Central India"
}
