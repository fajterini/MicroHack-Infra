variable "admin_password" {
  description = "Admin password for Windows Server (store in Azure Key Vault in production)"
  type        = string
  sensitive   = true
}
