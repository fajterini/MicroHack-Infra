# Example usage of the storage-infra module for a single user

module "storage_infra" {
  source = "../../terraform/modules/storage-infra"

  user_number = 1
  location    = "eastus"

  tags = {
    Environment = "Hackathon"
    ManagedBy   = "Terraform"
  }
}
