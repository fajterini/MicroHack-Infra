# Prerequisites and Setup Guide

This document outlines all the prerequisites and setup steps needed to participate in the Azure Modernization Hackathon.

## Required Accounts

### 1. Azure Subscription
- Active Azure subscription with Contributor or Owner access
- Sufficient credits or budget for:
  - Storage accounts (Standard LRS)
  - Virtual networks
  - Virtual machines (Standard_B2s or similar)
  - Public IP addresses
- Recommended: Use a development/test subscription

### 2. GitHub or Azure DevOps Account
- GitHub account (free tier is sufficient) OR
- Azure DevOps organization with project access
- Repository creation permissions

## Required Software

### 1. Azure CLI

**Installation:**

**Windows:**
```powershell
# Using MSI installer
# Download from: https://aka.ms/installazurecliwindows

# Or using winget
winget install Microsoft.AzureCLI
```

**macOS:**
```bash
brew update && brew install azure-cli
```

**Linux:**
```bash
# Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# RHEL/CentOS
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install azure-cli
```

**Verify Installation:**
```bash
az --version
```

### 2. Terraform

**Installation:**

**Windows:**
```powershell
# Using Chocolatey
choco install terraform

# Or download from: https://www.terraform.io/downloads
```

**macOS:**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Linux:**
```bash
# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Verify Installation:**
```bash
terraform --version
```

**Required Version:** 1.0 or later

### 3. Git

**Installation:**

**Windows:**
```powershell
# Download from: https://git-scm.com/download/win
# Or using winget
winget install Git.Git
```

**macOS:**
```bash
brew install git
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get install git

# RHEL/CentOS
sudo yum install git
```

**Verify Installation:**
```bash
git --version
```

### 4. PowerShell with Hyper-V (Windows) or qemu-img (Linux/Mac)

**For VMDK to VHD Conversion:**

**Windows:**
- PowerShell 5.1 or later (built-in on Windows 10/11)
- Hyper-V PowerShell module with Convert-VHD cmdlet
- Windows 10 Pro/Enterprise or Windows Server (Home edition doesn't support Hyper-V)

**macOS:**
```bash
brew install qemu
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get install qemu-utils

# RHEL/CentOS
sudo yum install qemu-img
```

**Verify Installation:**

Windows:
```powershell
Get-Command Convert-VHD
```

Linux/Mac:
```bash
qemu-img --version
```

### 5. Text Editor or IDE

**Recommended:**
- Visual Studio Code with extensions:
  - Azure Terraform
  - HashiCorp Terraform
  - Azure Account
  - Azure CLI Tools
  - GitLens

**Alternatives:**
- IntelliJ IDEA with Terraform plugin
- Sublime Text with Terraform package
- Vim/Neovim with terraform-ls

## Azure Configuration

### 1. Login to Azure CLI

```bash
# Interactive login
az login

# List subscriptions
az account list --output table

# Set active subscription
az account set --subscription "Your-Subscription-Name-or-ID"

# Verify current subscription
az account show --output table
```

### 2. Register Required Resource Providers

```bash
# Register providers (if not already registered)
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Storage

# Check registration status
az provider show --namespace Microsoft.Compute --query "registrationState"
```

### 3. Check Resource Quotas

```bash
# Check VM quota for your region
az vm list-usage --location eastus --output table

# Check specific quota
az vm list-usage --location eastus --query "[?localName=='Standard BS Family vCPUs']"
```

## Git Configuration

### 1. Configure Git Identity

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. Generate SSH Key (for GitHub/Azure DevOps)

```bash
# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "your.email@example.com" -f ~/.ssh/hackathon_rsa

# Display public key
cat ~/.ssh/hackathon_rsa.pub
```

Add the public key to:
- **GitHub:** Settings → SSH and GPG keys → New SSH key
- **Azure DevOps:** User Settings → SSH public keys → Add

### 3. Clone the Repository

```bash
git clone https://github.com/msucharda/microhacks-infra.git
cd microhacks-infra
```

## Verify Your Setup

Run this verification script to check all prerequisites:

**verification-script.sh** (Linux/Mac):
```bash
#!/bin/bash

echo "=== Prerequisites Verification ==="
echo ""

# Check Azure CLI
if command -v az &> /dev/null; then
    echo "✓ Azure CLI: $(az --version | head -n 1)"
else
    echo "✗ Azure CLI: Not installed"
fi

# Check Terraform
if command -v terraform &> /dev/null; then
    echo "✓ Terraform: $(terraform --version | head -n 1)"
else
    echo "✗ Terraform: Not installed"
fi

# Check Git
if command -v git &> /dev/null; then
    echo "✓ Git: $(git --version)"
else
    echo "✗ Git: Not installed"
fi

# Check qemu-img (Linux/Mac)
if command -v qemu-img &> /dev/null; then
    echo "✓ qemu-img: $(qemu-img --version | head -n 1)"
else
    echo "✗ qemu-img: Not installed"
fi

# Check Azure login
if az account show &> /dev/null; then
    SUB_NAME=$(az account show --query name -o tsv)
    echo "✓ Azure Login: Authenticated (Subscription: $SUB_NAME)"
else
    echo "✗ Azure Login: Not authenticated"
fi

echo ""
echo "=== Verification Complete ==="
```

**verification-script.ps1** (Windows):
```powershell
Write-Host "=== Prerequisites Verification ===" -ForegroundColor Cyan
Write-Host ""

# Check Azure CLI
if (Get-Command az -ErrorAction SilentlyContinue) {
    $azVersion = (az --version | Select-String "azure-cli").ToString()
    Write-Host "✓ Azure CLI: $azVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Azure CLI: Not installed" -ForegroundColor Red
}

# Check Terraform
if (Get-Command terraform -ErrorAction SilentlyContinue) {
    $tfVersion = (terraform --version | Select-Object -First 1)
    Write-Host "✓ Terraform: $tfVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Terraform: Not installed" -ForegroundColor Red
}

# Check Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Host "✓ Git: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Git: Not installed" -ForegroundColor Red
}

# Check Convert-VHD
if (Get-Command Convert-VHD -ErrorAction SilentlyContinue) {
    Write-Host "✓ Convert-VHD: Available" -ForegroundColor Green
} else {
    Write-Host "✗ Convert-VHD: Not available (Hyper-V module needed)" -ForegroundColor Red
}

# Check Azure login
try {
    $subName = (az account show --query name -o tsv 2>$null)
    Write-Host "✓ Azure Login: Authenticated (Subscription: $subName)" -ForegroundColor Green
} catch {
    Write-Host "✗ Azure Login: Not authenticated" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Verification Complete ===" -ForegroundColor Cyan
```

## Common Setup Issues

### Issue: Azure CLI not authenticated
**Solution:**
```bash
az login
az account set --subscription "Your-Subscription-ID"
```

### Issue: Terraform not found
**Solution:** Ensure Terraform is in your PATH
```bash
# Linux/Mac
export PATH=$PATH:/path/to/terraform

# Windows (PowerShell)
$env:PATH += ";C:\path\to\terraform"
```

### Issue: Convert-VHD not available (Windows)
**Solution:** Enable Hyper-V and verify the module
```powershell
# Run as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# After reboot, verify
Get-Command Convert-VHD

# If still not available, you may need to install qemu-img as an alternative
# Download from: https://cloudbase.it/qemu-img-windows/
```

### Issue: Insufficient Azure permissions
**Solution:** Request Contributor or Owner role on the subscription or resource group

### Issue: Resource provider not registered
**Solution:**
```bash
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Storage
```

## Recommended Optional Tools

- **Azure Storage Explorer** - GUI for managing storage
- **AzCopy** - Efficient file transfer to/from Azure Storage
- **Postman** - API testing (for advanced scenarios)
- **Docker** - For containerization challenges (future extensions)

## Ready to Start?

Once all prerequisites are met:

1. ✓ All required software installed
2. ✓ Azure CLI authenticated
3. ✓ Git configured
4. ✓ Repository cloned
5. ✓ Sufficient Azure credits

**You're ready to begin Challenge 01!**

Return to the [main README](../README.md) to start the hackathon.

## Getting Help

- Check the [troubleshooting guide](troubleshooting.md)
- Review Azure documentation links in each challenge
- Ask your hackathon facilitators for assistance
- Check Azure status: https://status.azure.com/
