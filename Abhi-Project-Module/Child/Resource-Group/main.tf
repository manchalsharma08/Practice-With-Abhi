resource "azurerm_resource_group" "rg" {

    name = "${var.abhivar["name"]}-rg"
    location = "${var.abhivar["location"]}"
}