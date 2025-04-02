terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
        }
    
    }
#     backend "azurerm" {
#     subscription_id      = "64697d19-b3b6-4b14-9249-49141c1d539e"
#     resource_group_name  = "avicore00-rg"
#     storage_account_name = "avixxstorage"          # Ensure it meets Azure's naming rules.
#     container_name       = "avixx2"                 # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
#     key                  = "abhi.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
#   }
  }

  


provider "azurerm" {
  features {}

  subscription_id = "64697d19-b3b6-4b14-9249-49141c1d539e"

}