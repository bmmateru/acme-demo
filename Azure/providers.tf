terraform {
 cloud {
    organization = "BidiiCloud"

    workspaces {
      name = "acm-azure"
    }
  }  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

}

