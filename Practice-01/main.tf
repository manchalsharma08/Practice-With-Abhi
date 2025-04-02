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
    storage_account_name = "avixxstorage"          # Ensure it meets Azure's naming rules.
    container_name       = "avixx2"                 # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "abhi.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  }

  


provider "azurerm" {
  features {}

  subscription_id = var.subscription_id

}



variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "abhivar" {
   
    type = map(any)
    default = {
        name = "test"
        location = "westus" 
    }
}

resource "azurerm_resource_group" "rg" {
    name     = "${var.abhivar["name"]}-rg"  # "${var.abhivar["name"]}-rg"
    location = "${var.abhivar["location"]}"  # "${var.abhivar["location"]}"
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
  


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.abhivar["name"]}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.abhivar["name"]}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.abhivar["name"]}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.abhivar["name"]}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  disable_password_authentication =false
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("${path.module}/id_rsa.pub") # Ensure the file exists in the module directory.
  # }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}