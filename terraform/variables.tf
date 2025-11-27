variable "location" {
  description = "Azure region where resources will be created"
  type        = string
default     = "swedencentral"
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the Windows VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the Windows VM"
  type        = string
  sensitive   = true
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "rdp_source_address" {
  description = "Source address or range allowed for RDP (TCP 3389)"
  type        = string
  default     = "168.63.129.16"
}
