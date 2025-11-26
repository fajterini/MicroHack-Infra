# Troubleshooting Guide

This guide covers common issues you may encounter during the hackathon and their solutions.

## Table of Contents

- [Azure Authentication Issues](#azure-authentication-issues)
- [Terraform Issues](#terraform-issues)
- [VMDK to VHD Conversion Issues](#vmdk-to-vhd-conversion-issues)
- [Network and VM Issues](#network-and-vm-issues)
- [CI/CD Pipeline Issues](#cicd-pipeline-issues)
- [General Azure Issues](#general-azure-issues)

## Azure Authentication Issues

### Problem: "az login" fails or times out

**Symptoms:**
```
Failed to connect to MSI. Please make sure MSI is configured correctly.
```

**Solutions:**
1. Clear Azure CLI cache:
   ```bash
   az account clear
   az login --use-device-code
   ```

2. Try browser-based authentication:
   ```bash
   az login
   ```

3. Check proxy settings if behind corporate firewall:
   ```bash
   export HTTP_PROXY=http://proxy:port
   export HTTPS_PROXY=http://proxy:port
   ```

### Problem: "Insufficient permissions"

**Symptoms:**
```
AuthorizationFailed: The client does not have authorization to perform action
```

**Solutions:**
1. Verify your role assignment:
   ```bash
   az role assignment list --assignee $(az account show --query user.name -o tsv)
   ```

2. Request Contributor role:
   ```bash
   # Owner can grant you access
   az role assignment create --assignee your-email@domain.com --role Contributor --scope /subscriptions/{subscription-id}
   ```

3. Use a different subscription if available:
   ```bash
   az account list --output table
   az account set --subscription "subscription-name"
   ```

### Problem: Multiple Azure accounts causing confusion

**Solution:**
```bash
# List all accounts
az account list --output table

# Clear all cached credentials
az account clear

# Login with specific account
az login --tenant "your-tenant-id"
```

## Terraform Issues

### Problem: "Error: Backend initialization required"

**Symptoms:**
```
Error: Backend initialization required, please run "terraform init"
```

**Solution:**
```bash
cd challenges/challenge-02  # or appropriate directory
terraform init
```

### Problem: "Error: Module not found"

**Solution:**
```bash
# Reinitialize with upgrade
terraform init -upgrade

# Or remove .terraform directory and reinitialize
rm -rf .terraform
terraform init
```

### Problem: "Error: State lock timeout"

**Symptoms:**
```
Error: Error acquiring the state lock
```

**Solutions:**
1. Wait for existing operation to complete
2. If stuck, force unlock (use carefully):
   ```bash
   terraform force-unlock <lock-id>
   ```

3. Check if another process is running:
   ```bash
   ps aux | grep terraform
   ```

### Problem: "Error: Resource already exists"

**Symptoms:**
```
A resource with the ID already exists
```

**Solutions:**
1. Import existing resource:
   ```bash
   terraform import azurerm_resource_group.main /subscriptions/{sub-id}/resourceGroups/{rg-name}
   ```

2. Destroy and recreate:
   ```bash
   terraform destroy
   terraform apply
   ```

3. Use different resource names in variables

### Problem: Terraform plan shows unexpected changes

**Solution:**
```bash
# Show detailed diff
terraform plan -detailed-exitcode

# Refresh state
terraform refresh

# Check for drift
terraform plan -refresh-only
```

### Problem: Provider version conflicts

**Solution:**
```bash
# Lock provider version
terraform init -upgrade

# Or clear provider cache
rm -rf .terraform
rm .terraform.lock.hcl
terraform init
```

## VMDK to VHD Conversion Issues

### Problem: qemu-img not found (Linux/Mac)

**Solutions:**

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install qemu-utils
```

**macOS:**
```bash
brew install qemu
```

**RHEL/CentOS:**
```bash
sudo yum install qemu-img
```

### Problem: Convert-VHD not available (Windows)

**Symptoms:**
```
Convert-VHD : The term 'Convert-VHD' is not recognized
```

**Solution:**
```powershell
# Run PowerShell as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

# After reboot, verify
Get-Command Convert-VHD
```

**Alternative:** If Hyper-V is not available (Windows Home edition), use qemu-img:
- Download from: https://cloudbase.it/qemu-img-windows/
- Use: `qemu-img convert -f vmdk -O vpc source.vmdk output.vhd`

### Problem: Convert-VHD does not support VMDK format

Some older versions of Convert-VHD may not support VMDK input files.

**Solution:**
Use qemu-img for VMDK to VHD conversion:
```bash
# Windows (if qemu-img installed)
qemu-img convert -f vmdk -O vpc source.vmdk output.vhd

# Linux/Mac
qemu-img convert -f vmdk -O vpc source.vmdk output.vhd
```

### Problem: VMDK file is corrupted or invalid

**Solution:**
1. Verify VMDK integrity from VMware:
   - Ensure VM is powered off before export
   - Use VMware's export/OVF tool
   - Consolidate snapshots if any exist
2. Check VMDK file info:
   ```bash
   qemu-img info source.vmdk
   ```

### Problem: VHD upload fails with "Invalid blob type"

**Symptoms:**
```
Error: Blob type is invalid for this operation
```

**Solution:**
VHD files must be uploaded as **page blobs** (not block blobs):
```bash
az storage blob upload \
    --type page \
    --account-name $STORAGE_ACCOUNT \
    --container-name $CONTAINER \
    --name file.vhd \
    --file local-file.vhd
```

Note: VMDK files can be uploaded as block blobs initially, but converted VHD files must be page blobs.

### Problem: VHD upload is very slow

**Solutions:**
1. Use AzCopy for better performance (specify blob type for VHDs):
   ```bash
   azcopy copy "file.vhd" "https://$STORAGE_ACCOUNT.blob.core.windows.net/$CONTAINER/file.vhd" --blob-type PageBlob
   ```

2. Use a region closer to your location

3. Check network bandwidth:
   ```bash
   # Test upload speed
   curl -o /dev/null https://example.com/largefile
   ```

### Problem: "VHD is not a fixed size disk" or VHD size alignment issues

Azure requires specific VHD alignment (1MB boundaries for dynamic VHDs).

**Solution - Convert VMDK to properly formatted VHD:**

**Windows:**
```powershell
# For dynamic VHD (recommended for most cases)
Convert-VHD -Path source.vmdk -DestinationPath output.vhd -VHDType Dynamic

# For fixed VHD (if required)
Convert-VHD -Path source.vmdk -DestinationPath output.vhd -VHDType Fixed
```

**Linux/Mac:**
```bash
# Dynamic VHD (recommended)
qemu-img convert -f vmdk -O vpc source.vmdk output.vhd

# Fixed VHD (if required)
qemu-img convert -f vmdk -O vpc -o subformat=fixed source.vmdk output.vhd
```

## Network and VM Issues

### Problem: Cannot connect to VM via SSH/RDP

**Symptoms:**
- Connection timeout
- Connection refused

**Solutions:**

1. Verify NSG rules:
   ```bash
   az network nsg rule list \
       --resource-group $RG_NAME \
       --nsg-name $NSG_NAME \
       --output table
   ```

2. Check public IP is assigned:
   ```bash
   az vm list-ip-addresses \
       --resource-group $RG_NAME \
       --name $VM_NAME \
       --output table
   ```

3. Verify VM is running:
   ```bash
   az vm get-instance-view \
       --resource-group $RG_NAME \
       --name $VM_NAME \
       --query instanceView.statuses
   ```

4. Test connectivity:
   ```bash
   # Test if port is open
   nc -zv <public-ip> 22    # For SSH
   nc -zv <public-ip> 3389  # For RDP
   ```

5. Check VM boot diagnostics:
   ```bash
   az vm boot-diagnostics get-boot-log \
       --resource-group $RG_NAME \
       --name $VM_NAME
   ```

### Problem: "QuotaExceeded" error when creating VM

**Symptoms:**
```
Operation results in exceeding quota limits
```

**Solutions:**
1. Check current quota usage:
   ```bash
   az vm list-usage --location eastus --output table
   ```

2. Use a different VM size:
   ```bash
   # List available VM sizes
   az vm list-sizes --location eastus --output table
   ```

3. Request quota increase:
   - Go to Azure Portal
   - Navigate to Subscriptions → Usage + quotas
   - Click "Request increase"

### Problem: VM deployment takes too long

**Solutions:**
1. Check deployment status:
   ```bash
   az deployment group list \
       --resource-group $RG_NAME \
       --output table
   ```

2. Monitor in Portal: Resource Groups → Deployments

3. Cancel and retry if stuck:
   ```bash
   # List deployments
   az deployment group list --resource-group $RG_NAME
   
   # Cancel deployment
   az deployment group cancel --name <deployment-name> --resource-group $RG_NAME
   ```

### Problem: "InvalidParameter" error for VHD URI

**Solution:**
Ensure VHD is accessible:
```bash
# Generate SAS token if needed
az storage blob generate-sas \
    --account-name $STORAGE_ACCOUNT \
    --container-name $CONTAINER \
    --name file.vhd \
    --permissions r \
    --expiry $(date -u -d "1 hour" '+%Y-%m-%dT%H:%MZ')
```

## CI/CD Pipeline Issues

### Problem: GitHub Actions workflow not triggering

**Solutions:**
1. Check workflow file syntax:
   ```bash
   # Validate YAML syntax
   yamllint .github/workflows/terraform-deploy.yml
   ```

2. Verify branch name matches trigger:
   ```yaml
   on:
     push:
       branches: [ main ]  # Check this matches your branch
   ```

3. Check workflow permissions:
   - Go to Settings → Actions → General
   - Ensure workflows have required permissions

### Problem: "Error: Azure login failed"

**Solutions:**
1. Verify AZURE_CREDENTIALS secret format:
   ```json
   {
     "clientId": "xxx",
     "clientSecret": "xxx",
     "subscriptionId": "xxx",
     "tenantId": "xxx"
   }
   ```

2. Test service principal locally:
   ```bash
   az login --service-principal \
       -u <clientId> \
       -p <clientSecret> \
       --tenant <tenantId>
   ```

3. Check service principal permissions:
   ```bash
   az role assignment list --assignee <clientId>
   ```

### Problem: Terraform state conflicts in pipeline

**Solution:**
Configure remote state backend:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate"
    container_name       = "tfstate"
    key                  = "hackathon.tfstate"
  }
}
```

### Problem: Pipeline secrets not accessible

**Solutions:**
1. Verify secret names match in workflow:
   ```yaml
   env:
     TF_VAR_admin_password: ${{ secrets.ADMIN_PASSWORD }}
   ```

2. Check secret is set in repository settings

3. Ensure secret name has no typos

## General Azure Issues

### Problem: "SubscriptionNotRegistered" error

**Solution:**
Register required providers:
```bash
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Storage

# Check status
az provider show --namespace Microsoft.Compute --query "registrationState"
```

### Problem: "LocationNotAvailableForResourceType"

**Solutions:**
1. Check available locations:
   ```bash
   az provider show --namespace Microsoft.Compute \
       --query "resourceTypes[?resourceType=='virtualMachines'].locations"
   ```

2. Use a different region:
   ```bash
   # In terraform.tfvars
   location = "westus2"  # or another available region
   ```

### Problem: Resources not visible in Portal

**Solutions:**
1. Refresh the Portal page (Ctrl+F5)

2. Check you're viewing the correct subscription

3. Verify resource was actually created:
   ```bash
   az resource list --resource-group $RG_NAME
   ```

### Problem: Cost concerns / unexpected charges

**Solutions:**
1. Check current costs:
   ```bash
   az consumption usage list --start-date $(date -d "7 days ago" +%Y-%m-%d) --end-date $(date +%Y-%m-%d)
   ```

2. Set up budget alerts in Azure Portal:
   - Navigate to Cost Management
   - Create Budget
   - Set alert thresholds

3. Clean up unused resources:
   ```bash
   # List all resources
   az resource list --output table
   
   # Delete resource group (careful!)
   az group delete --name $RG_NAME --yes
   ```

4. Stop VMs when not in use:
   ```bash
   az vm deallocate --resource-group $RG_NAME --name $VM_NAME
   ```

## Getting Additional Help

### Azure Resources
- Azure Status: https://status.azure.com/
- Azure Documentation: https://docs.microsoft.com/azure/
- Azure Support: Create a support ticket in Azure Portal

### Community Resources
- Stack Overflow: Tag questions with `azure`, `terraform`
- HashiCorp Forum: https://discuss.hashicorp.com/
- Azure Community: https://techcommunity.microsoft.com/t5/azure/ct-p/Azure

### During the Hackathon
1. Ask your facilitators
2. Check with other participants
3. Review challenge-specific README files
4. Check Azure Portal activity logs:
   ```bash
   az monitor activity-log list --max-events 50
   ```

## Preventive Measures

### Before Starting Each Challenge
1. ✓ Verify Azure CLI authentication
2. ✓ Run `terraform validate`
3. ✓ Check resource quotas
4. ✓ Review costs
5. ✓ Backup important files

### During Development
1. ✓ Commit frequently to git
2. ✓ Test in small increments
3. ✓ Review Terraform plans before applying
4. ✓ Keep notes of what you've tried

### After Each Challenge
1. ✓ Document what you learned
2. ✓ Review deployed resources
3. ✓ Consider cleanup if not proceeding immediately
4. ✓ Save any important outputs

## Emergency Recovery

### If Everything Breaks
1. Don't panic! Take a breath
2. Document what happened
3. Check git history:
   ```bash
   git log --oneline
   git diff HEAD~1
   ```

4. Revert to last working state:
   ```bash
   git reset --hard HEAD~1
   ```

5. Start fresh if needed:
   ```bash
   terraform destroy
   git checkout main
   git pull
   ```

### Contact Information
- Hackathon Support: [Your contact info]
- Azure Support: [Your organization's Azure support]

---

**Remember:** Most issues have been encountered before and have documented solutions. When in doubt, check the official documentation or ask for help!
