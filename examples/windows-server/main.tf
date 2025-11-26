# Example usage of the Windows Server module

module "windows_server" {
  source = "../../terraform/modules/windows-server"

  # Resource Group
  resource_group_name = "rg-windows-server-demo"
  location            = "eastus"

  # Server Configuration
  server_name   = "demo-server"
  computer_name = "DEMOSRV"

  # VM Size - Standard_D4s_v5 recommended for 15 users
  vm_size      = "Standard_D4s_v5"
  os_disk_type = "Premium_LRS"

  # Admin credentials (use Azure Key Vault in production)
  admin_username = "azureadmin"
  admin_password = var.admin_password

  # Windows Server 2022 Datacenter (supports RDS for multiple users)
  vm_image_publisher = "MicrosoftWindowsServer"
  vm_image_offer     = "WindowsServer"
  vm_image_sku       = "2022-datacenter"
  vm_image_version   = "latest"

  # Disable public IP (recommended for production)
  # Set to true if you need external RDP access
  enable_public_ip = false

  tags = {
    Environment = "Demo"
    Purpose     = "Windows Server Testing"
    ManagedBy   = "Terraform"
  }
}

# Optional: Assign users to the VM for Entra ID authentication
# You'll need the AzureAD provider for this
# 
# data "azuread_users" "server_users" {
#   user_principal_names = [
#     "user1@yourdomain.com",
#     "user2@yourdomain.com"
#   ]
# }
#
# resource "azurerm_role_assignment" "server_users" {
#   for_each             = toset(data.azuread_users.server_users.object_ids)
#   scope                = module.windows_server.server_id
#   role_definition_name = "Virtual Machine User Login"
#   principal_id         = each.value
# }
#
# # Optional: Assign administrators
# data "azuread_users" "server_admins" {
#   user_principal_names = [
#     "admin@yourdomain.com"
#   ]
# }
#
# resource "azurerm_role_assignment" "server_admins" {
#   for_each             = toset(data.azuread_users.server_admins.object_ids)
#   scope                = module.windows_server.server_id
#   role_definition_name = "Virtual Machine Administrator Login"
#   principal_id         = each.value
# }
