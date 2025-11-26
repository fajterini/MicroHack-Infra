output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.storage_infra.resource_group_name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_infra.storage_account_name
}

output "storage_blob_endpoint" {
  description = "Storage blob endpoint"
  value       = module.storage_infra.storage_account_primary_blob_endpoint
}

output "vmimages_container" {
  description = "VM images container name"
  value       = module.storage_infra.storage_container_name
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = module.storage_infra.location
}
