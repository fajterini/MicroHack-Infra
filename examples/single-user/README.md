# Single User Storage Infrastructure Example

This example demonstrates how to use the `storage-infra` module to create storage infrastructure for a single user.

## What This Example Creates

- Resource Group: `rg-user-1`
- Storage Account: `stuser1<random>` (with public access enabled)
- Storage Container: `vmimages`

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Terraform >= 1.0 installed
- Azure subscription with permissions to create resources

## Usage

1. Navigate to this directory:
   ```bash
   cd examples/single-user
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. View the outputs:
   ```bash
   terraform output
   ```

## Expected Outputs

```
resource_group_name = "rg-user-1"
storage_account_name = "stuser1abc123"
storage_blob_endpoint = "https://stuser1abc123.blob.core.windows.net/"
vmimages_container = "vmimages"
location = "eastus"
```

## Uploading VM Images

Once the infrastructure is created, you can upload VM images to the storage container:

### Using Azure Portal
1. Navigate to the storage account (shown in outputs)
2. Go to Containers → vmimages
3. Click Upload and select your VHD file

### Using Azure CLI
```bash
# Get the storage account name from Terraform output
STORAGE_ACCOUNT=$(terraform output -raw storage_account_name)

# Upload a VHD file
az storage blob upload \
  --account-name $STORAGE_ACCOUNT \
  --container-name vmimages \
  --name my-vm-image.vhd \
  --file /path/to/vm-image.vhd \
  --auth-mode login
```

### Using AzCopy
```bash
# Get the storage account name
STORAGE_ACCOUNT=$(terraform output -raw storage_account_name)

# Upload using AzCopy
azcopy copy "/path/to/vm-image.vhd" \
  "https://$STORAGE_ACCOUNT.blob.core.windows.net/vmimages/my-vm-image.vhd"
```

## Public Access

Since public access is enabled, uploaded blobs can be accessed via public URLs:

```
https://<storage_account_name>.blob.core.windows.net/vmimages/<blob_name>
```

For example:
```
https://stuser1abc123.blob.core.windows.net/vmimages/my-vm-image.vhd
```

## Customization

You can customize the configuration by modifying the module parameters in `main.tf`:

```hcl
module "storage_infra" {
   source = "../../terraform/modules/storage-infra"

  user_number                      = 1
  location                         = "westus"  # Change region
  storage_account_tier             = "Premium" # Change tier
  storage_account_replication_type = "ZRS"     # Change replication

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "MyProject"
  }
}
```

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete:
- The storage account and all blobs within it
- The vmimages container
- The resource group

## Next Steps

After creating the infrastructure:
1. Upload your VM images (VMDK or VHD files)
2. Use the images to create VMs
3. Share public URLs with team members if needed
4. Configure lifecycle policies for blob management (optional)

## Notes

- Storage account names include a random suffix for global uniqueness
- Public access is enabled by default for easy blob access
- The vmimages container has blob-level public read access
- All resources are created in a single resource group for easy management
