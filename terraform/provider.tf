terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    }
    subscription_id = "0e69818f-c535-40c9-8e93-5b1fb1228ea2"
}
