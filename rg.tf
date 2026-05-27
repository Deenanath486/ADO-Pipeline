
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "Central India"
}

resource "azurerm_resource_group" "RG" {
  name     = "RG-5"
  location = "Central India"
}
