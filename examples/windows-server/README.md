# Windows Server Example

This example demonstrates how to use the Windows Server module to deploy an Entra ID-enabled Windows Server 2022 that supports up to 15 concurrent users.

## What This Example Creates

- Resource Group for Windows Server resources
- Virtual Network and Subnet with NSG
- Windows Server 2022 Datacenter VM with Entra ID join
- System-assigned managed identity
- Network security rules for RDP and Azure AD communication

## Prerequisites

1. Azure subscription with appropriate permissions
2. Azure CLI installed and authenticated (`az login`)
3. Terraform >= 1.0 installed
4. Users created in Entra ID who will access the server

## Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/msucharda/microhacks-infra.git
   cd microhacks-infra/examples/windows-server
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```
   
   When prompted, enter a secure password for the local admin account.
   
   Alternatively, use a variable file:
   ```bash
   echo 'admin_password = "YourSecurePassword123!"' > terraform.tfvars
   terraform apply
   ```

5. **Get the outputs**:
   ```bash
   terraform output
   ```

## Assigning Users to the Server

After deployment, you need to grant users access to the Windows Server VM for RDP authentication with Entra ID credentials.

### Option 1: Using Azure CLI

```bash
# Get the Server ID from Terraform output
SERVER_ID=$(terraform output -raw server_id)

# Get user's Object ID
USER_OBJECT_ID=$(az ad user show --id user@yourdomain.com --query id -o tsv)

# Assign the Virtual Machine User Login role (for regular users)
az role assignment create \
  --role "Virtual Machine User Login" \
  --assignee $USER_OBJECT_ID \
  --scope $SERVER_ID

# OR assign Virtual Machine Administrator Login role (for administrators)
az role assignment create \
  --role "Virtual Machine Administrator Login" \
  --assignee $USER_OBJECT_ID \
  --scope $SERVER_ID
```

### Option 2: Using Azure Portal

1. Navigate to Azure Portal
2. Go to Virtual machines
3. Select the server (e.g., `demo-server`)
4. Click on "Access control (IAM)" in the left menu
5. Click "+ Add" > "Add role assignment"
6. Select "Virtual Machine User Login" or "Virtual Machine Administrator Login"
7. Click "Next", then select users or groups
8. Click "Review + assign"

### Option 3: Extend Terraform Configuration

Uncomment the user assignment section in `main.tf` and add the AzureAD provider:

```hcl
# In provider.tf, add:
provider "azuread" {
  # Configuration options
}

# In main.tf, uncomment the user assignment section
```

## Accessing the Server

Users can connect via RDP using:

1. **Private IP** (from within VNet or via VPN/ExpressRoute):
   - Use the private IP from terraform output
   - Username: `AzureAD\user@yourdomain.com` or `user@yourdomain.com`
   - Authentication: Entra ID credentials (password + MFA if required)

2. **Azure Bastion** (recommended for secure access):
   ```bash
   az network bastion rdp \
     --name <bastion-name> \
     --resource-group <bastion-rg> \
     --target-resource-id $(terraform output -raw server_id) \
     --enable-mfa true
   ```

3. **Public IP** (if enabled):
   - Enable by setting `enable_public_ip = true` in main.tf
   - Use the public IP from terraform output

## Configuring for Multiple Users

After connecting to the server as administrator, configure Remote Desktop Services:

1. **Install RDS Session Host role**:
   ```powershell
   Install-WindowsFeature -Name RDS-RD-Server -IncludeManagementTools
   Restart-Computer
   ```

2. **Configure maximum connections** (up to 15):
   ```powershell
   Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
     -Name 'MaxInstanceCount' -Value 15
   ```

3. **Configure licensing** (consult Windows Server licensing requirements)

4. **Optimize for multiple users**:
   ```powershell
   # Enable RemoteFX
   Enable-WindowsOptionalFeature -Online -FeatureName RemoteFX-Compression
   
   # Configure power plan for best performance
   powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
   ```

## Configuration Options

You can customize the deployment by modifying `main.tf`:

### Change VM Size

```hcl
vm_size = "Standard_D8s_v5"  # Use larger VMs for more users or better performance
```

Recommended sizes for different user counts:
- 1-5 users: Standard_D2s_v5 (2 vCPUs, 8 GB RAM)
- 6-10 users: Standard_D4s_v5 (4 vCPUs, 16 GB RAM)
- 11-15 users: Standard_D4s_v5 or Standard_D8s_v5 (8 vCPUs, 32 GB RAM)

### Enable Public IP

```hcl
enable_public_ip = true  # For external RDP access (not recommended for production)
```

### Change Region

```hcl
location = "westeurope"  # Deploy to different Azure region
```

### Use Different OS

```hcl
vm_image_sku = "2022-datacenter-azure-edition"  # Use Azure Edition with advanced features
```

## Testing the Deployment

1. **Verify VM is running**:
   ```bash
   az vm get-instance-view \
     --name $(terraform output -raw server_name) \
     --resource-group $(terraform output -raw resource_group_name) \
     --query instanceView.statuses
   ```

2. **Check AAD extension**:
   ```bash
   az vm extension list \
     --resource-group $(terraform output -raw resource_group_name) \
     --vm-name $(terraform output -raw server_name) \
     --query "[].{Name:name, State:provisioningState}" -o table
   ```

3. **Test RDP connection**:
   ```bash
   # Get private IP
   terraform output server_private_ip
   
   # Connect via RDP client
   mstsc /v:<private-ip>
   ```

## Cost Estimate

Approximate monthly cost for this example (Standard_D4s_v5 VM in East US):

- VM (Standard_D4s_v5): ~$140-180/month (running 24/7)
- Storage (128GB Premium SSD): ~$20/month
- Networking: ~$5-10/month
- **Total**: ~$165-210/month

Cost can be reduced by:
- Deallocating VM during off-hours
- Using Standard SSD instead of Premium
- Implementing auto-shutdown schedules

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

When prompted, confirm with `yes`.

## Troubleshooting

### Cannot authenticate with Entra ID

1. Verify AADLoginForWindows extension is installed and succeeded:
   ```bash
   az vm extension show \
     --resource-group $(terraform output -raw resource_group_name) \
     --vm-name $(terraform output -raw server_name) \
     --name AADLoginForWindows
   ```

2. Ensure user has appropriate RBAC role assigned

3. Check VM has internet connectivity to reach Azure AD endpoints

### RDP Connection Issues

1. Verify NSG rules allow RDP traffic
2. Check VM is running
3. If using private IP, ensure you're connecting from within VNet or via VPN
4. Try using Azure Bastion for troubleshooting

### Performance Issues with Multiple Users

1. Monitor resource utilization:
   ```bash
   az vm show \
     --resource-group $(terraform output -raw resource_group_name) \
     --name $(terraform output -raw server_name) \
     --query hardwareProfile.vmSize
   ```

2. Consider upgrading VM size
3. Implement user profile management (FSLogix or roaming profiles)
4. Optimize Windows Server for RDS workloads

## Next Steps

- Configure Azure Backup for the VM
- Set up Azure Monitor for performance monitoring
- Implement Azure Bastion for secure access
- Configure Conditional Access policies in Entra ID
- Set up FSLogix for user profile management
- Configure Azure Files for shared storage
- Implement auto-shutdown schedules to reduce costs

## Additional Resources

- [Module Documentation](../../terraform/modules/windows-server/README.md)
- [Azure AD joined VMs](https://docs.microsoft.com/en-us/azure/active-directory/devices/howto-vm-sign-in-azure-ad-windows)
- [Windows Server Remote Desktop Services](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/welcome-to-rds)
- [Azure VM sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)
