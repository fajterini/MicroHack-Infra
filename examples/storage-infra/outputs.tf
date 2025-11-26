# Outputs for User 1
output "user1_resource_group_name" {
  description = "Resource group name for User 1"
  value       = module.storage_infra_user1.resource_group_name
}

output "user1_storage_account_name" {
  description = "Storage account name for User 1"
  value       = module.storage_infra_user1.storage_account_name
}

output "user1_storage_blob_endpoint" {
  description = "Storage blob endpoint for User 1"
  value       = module.storage_infra_user1.storage_account_primary_blob_endpoint
}

output "user1_vmimages_container" {
  description = "VM images container name for User 1"
  value       = module.storage_infra_user1.storage_container_name
}

# Outputs for User 2
output "user2_resource_group_name" {
  description = "Resource group name for User 2"
  value       = module.storage_infra_user2.resource_group_name
}

output "user2_storage_account_name" {
  description = "Storage account name for User 2"
  value       = module.storage_infra_user2.storage_account_name
}

output "user2_storage_blob_endpoint" {
  description = "Storage blob endpoint for User 2"
  value       = module.storage_infra_user2.storage_account_primary_blob_endpoint
}

output "user2_vmimages_container" {
  description = "VM images container name for User 2"
  value       = module.storage_infra_user2.storage_container_name
}
