# Storage Infrastructure Example

This example demonstrates how to use the `storage-infra` module to create storage infrastructure for multiple users.

## What This Example Creates

For each user (in this case, User 1 and User 2):
- Resource Group: `rg-user-1`, `rg-user-2`
- Storage Account: `stuser1<random>`, `stuser2<random>`
- Storage Container: `vmimages` (in each storage account)

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Terraform >= 1.0 installed
- Azure subscription with permissions to create resources

## Usage

1. Navigate to this directory:
   ```bash
   cd examples/storage-infra
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
user1_resource_group_name = "rg-user-1"
user1_storage_account_name = "stuser1abc123"
user1_storage_blob_endpoint = "https://stuser1abc123.blob.core.windows.net/"
user1_vmimages_container = "vmimages"

user2_resource_group_name = "rg-user-2"
user2_storage_account_name = "stuser2def456"
user2_storage_blob_endpoint = "https://stuser2def456.blob.core.windows.net/"
user2_vmimages_container = "vmimages"
```

## Accessing the Storage

Once created, you can access the storage in several ways:

### Via Azure Portal
1. Go to Storage Accounts
2. Find `stuser1<random>` or `stuser2<random>`
3. Navigate to Containers → vmimages

### Via Azure CLI
```bash
# List blobs in User 1's vmimages container
az storage blob list \
  --account-name $(terraform output -raw user1_storage_account_name) \
  --container-name vmimages \
  --auth-mode login

# Upload a file
az storage blob upload \
  --account-name $(terraform output -raw user1_storage_account_name) \
  --container-name vmimages \
  --name my-vm-image.vhd \
  --file /path/to/vm-image.vhd \
  --auth-mode login
```

### Via Public URL
Since public access is enabled, blobs can be accessed directly:
```
https://stuser1abc123.blob.core.windows.net/vmimages/my-vm-image.vhd
```

## Customization

To customize the example:

1. Change the number of users by adding/removing module blocks
2. Modify the location (e.g., "westus", "northeurope")
3. Add additional tags for organization
4. Adjust storage account tier or replication type in the module call

Example with customization:
```hcl
module "storage_infra_user3" {
   source = "../../terraform/modules/storage-infra"

  user_number                      = 3
  location                         = "westus"
  storage_account_tier             = "Premium"
  storage_account_replication_type = "ZRS"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    User        = "3"
    Department  = "Engineering"
  }
}
```

## Cleanup

To destroy all created resources:
```bash
terraform destroy
```

This will remove:
- All storage containers
- All storage accounts
- All resource groups
- All associated resources

## Notes

- Storage account names are globally unique and include a random suffix
- Public access is enabled for easy blob access
- Each user gets their own isolated resource group
- The vmimages container is created with blob-level public access
