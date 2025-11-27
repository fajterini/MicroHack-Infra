output "vm_name" {
  description = "Name of the Windows virtual machine"
  value       = azurerm_windows_virtual_machine.vm.name
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = var.admin_username
}
