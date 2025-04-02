resource "azurerm_storage_account" "st" {
    name                     = "${var.abhivar["name"]}1234storageaccount"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "testing"
    }
}
  
