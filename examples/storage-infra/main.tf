# Example usage of the storage-infra module

# Create storage infrastructure for User 1
module "storage_infra_user1" {
  source = "../../terraform/modules/storage-infra"

  user_number = 1
  location    = "eastus"

  tags = {
    Environment = "Hackathon"
    ManagedBy   = "Terraform"
    User        = "1"
  }
}

# Create storage infrastructure for User 2
module "storage_infra_user2" {
  source = "../../terraform/modules/storage-infra"

  user_number = 2
  location    = "eastus"

  tags = {
    Environment = "Hackathon"
    ManagedBy   = "Terraform"
    User        = "2"
  }
}
