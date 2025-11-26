# Windows Server Infrastructure Outputs

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.windows_server.resource_group_name
}

output "server_name" {
  description = "Name of the Windows Server VM"
  value       = module.windows_server.server_name
}

output "server_id" {
  description = "ID of the Windows Server VM"
  value       = module.windows_server.server_id
}

output "server_private_ip" {
  description = "Private IP address of the Windows Server"
  value       = module.windows_server.server_private_ip
}

output "server_public_ip" {
  description = "Public IP address of the Windows Server (if enabled)"
  value       = module.windows_server.server_public_ip
}

output "computer_name" {
  description = "Windows computer name"
  value       = module.windows_server.computer_name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = module.windows_server.virtual_network_name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = module.windows_server.subnet_name
}
