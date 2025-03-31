terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }

  backend "azurerm" {
    subscription_id      = "64697d19-b3b6-4b14-9249-49141c1d539e"
    resource_group_name  = "avicore00-rg"
    storage_account_name = "avixx"                  # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "avixx2"                 # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "abhi.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

provider "azurerm" {
  features {}

  subscription_id = "64697d19-b3b6-4b14-9249-49141c1d539e"

}



variable "abhivar" {
   
    type = map(any)
    default = {
        name = "test"
        location = "westus" 
    }
}

resource "azurerm_resource_group" "rg" {
    name     = "${var.abhivar["name"]}-rg"
    location = "${var.abhivar["location"]}"
}


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