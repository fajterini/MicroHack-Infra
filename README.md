# Azure Infrastructure Hackathon

Welcome to the Azure Infrastructure Hackathon! This hands-on learning experience will guide you through Azure fundamentals, from manual portal operations to fully automated infrastructure deployment with CI/CD pipelines.

## Overview

This hackathon consists of seven progressive challenges designed to build your Azure skills from the ground up:

1. **Azure Portal Fundamentals** - Create VNet, Subnet, convert VMDK to VHD, deploy VM, configure NSG
2. **Azure Backup** - Enable and configure backup for virtual machines
3. **Disaster Recovery** - Delete and restore VM from backup
4. **Infrastructure as Code** - Recreate VM using Terraform
5. **Terraform Modules** - Create reusable infrastructure modules
6. **Azure Key Vault** - Secure secrets management for credentials
7. **CI/CD Pipeline** - Automate infrastructure deployment with GitHub Actions

## Prerequisites

Before starting the hackathon, ensure you have:

- **Azure Subscription** with Contributor or Owner access
- **Web Browser** for Azure Portal access
- **Azure CLI** installed and configured ([Install Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- **Terraform** (v1.0 or later) - required from Challenge 04 onwards ([Install Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- **PowerShell with Hyper-V** (Windows) or **qemu-img** (Linux/Mac) for VMDK to VHD conversion
- **Git** for version control
- **GitHub account** with repository access (for Challenge 07)
- **Text editor or IDE** (VS Code recommended)

See [Prerequisites Documentation](docs/prerequisites.md) for detailed setup instructions.

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/msucharda/microhacks-infra.git
   cd microhacks-infra
   ```

2. Log in to Azure:
   ```bash
   az login
   az account set --subscription <your-subscription-id>
   ```

3. Start with Challenge 01 and progress through each challenge sequentially.

## Challenges

### Challenge 01: Azure Portal Fundamentals
**Objective:** Get hands-on with Azure basics through the Portal

Navigate to `challenges/challenge-01/` to:
- Create Virtual Network and Subnet
- Set up Storage Account
- Convert VMDK to VHD format
- Deploy a Virtual Machine
- Configure Network Security Groups

**Skills:** Azure Portal navigation, Networking, Storage, VM management  
**Time:** 60-90 minutes

### Challenge 02: Enable Azure Backup
**Objective:** Protect virtual machines with Azure Backup

Navigate to `challenges/challenge-02/` to:
- Create a Recovery Services Vault
- Configure backup policies
- Enable backup for your VM
- Trigger and monitor backup jobs

**Skills:** Business continuity, Disaster recovery, Backup management  
**Time:** 30-45 minutes

### Challenge 03: Delete and Restore VM from Backup
**Objective:** Practice disaster recovery procedures

Navigate to `challenges/challenge-03/` to:
- Delete your virtual machine
- Restore VM from backup
- Verify data integrity
- Understand restore options

**Skills:** Disaster recovery, Restore operations, Data protection  
**Time:** 45-60 minutes

### Challenge 04: Recreate VM Using Terraform
**Objective:** Transition to Infrastructure as Code

Navigate to `challenges/challenge-04/` to:
- Write Terraform configuration files
- Use data sources for existing resources
- Deploy VM with Terraform
- Manage infrastructure state

**Skills:** Infrastructure as Code, Terraform basics, Automation  
**Time:** 60-75 minutes

### Challenge 05: Create Terraform Modules
**Objective:** Build reusable infrastructure components

Navigate to `challenges/challenge-05/` to:
- Create a VM deployment module
- Define module inputs and outputs
- Use the module multiple times
- Understand module composition

**Skills:** Terraform modules, Code reusability, Best practices  
**Time:** 45-60 minutes

### Challenge 06: Implement Azure Key Vault
**Objective:** Secure secrets management

Navigate to `challenges/challenge-06/` to:
- Create Azure Key Vault
- Store GitHub credentials and secrets
- Configure access policies
- Access secrets from Terraform

**Skills:** Security, Secrets management, Access control  
**Time:** 30-45 minutes

### Challenge 07: Implement CI/CD Pipeline
**Objective:** Automate infrastructure deployment

Navigate to `challenges/challenge-07/` to:
- Create GitHub Actions workflows
- Integrate with Azure Key Vault
- Automate Terraform deployments
- Implement approval gates

**Skills:** CI/CD, GitHub Actions, End-to-end automation  
**Time:** 75-90 minutes

## Learning Path

This hackathon follows a progressive learning approach:

```
Phase 1: Azure Fundamentals (Challenges 1-3)
├── Manual operations via Azure Portal
├── Understanding core Azure services
└── Disaster recovery basics

Phase 2: Infrastructure as Code (Challenges 4-5)
├── Introduction to Terraform
├── Automated resource deployment
└── Reusable infrastructure modules

Phase 3: Security & Automation (Challenges 6-7)
├── Secrets management with Key Vault
├── CI/CD pipeline implementation
└── Production-ready workflows
```

## Architecture

By the end of the hackathon, you'll have built:

```
Azure Subscription
│
├── Resource Group
│   ├── Virtual Network
│   │   └── Subnet (with NSG)
│   ├── Storage Account (VMDK/VHD storage)
│   ├── Recovery Services Vault (Backups)
│   ├── Key Vault (Secrets)
│   └── Virtual Machines (Terraform-managed)
│       ├── OS Disk
│       ├── Network Interface
│       └── Public IP
│
└── GitHub Repository
    ├── Terraform Modules
    └── CI/CD Workflows (GitHub Actions)
```

## Repository Structure

```
.
├── challenges/
│   ├── challenge-01/          # Azure Portal fundamentals
│   ├── challenge-02/          # Azure Backup setup
│   ├── challenge-03/          # VM restore from backup
│   ├── challenge-04/          # Terraform VM deployment
│   ├── challenge-05/          # Terraform modules
│   ├── challenge-06/          # Azure Key Vault
│   └── challenge-07/          # CI/CD with GitHub Actions
├── terraform/                 # Terraform configuration and modules
│   ├── main.tf                # Root infrastructure entry point
│   └── modules/               # Reusable Terraform modules
│       ├── windows-server/    # Windows Server with Entra ID module
│       └── storage-infra/     # Storage account infrastructure module
├── examples/                  # Module usage examples
│   ├── windows-server/        # Windows Server with Entra ID setup
│   ├── single-user/           # Single user storage setup
│   └── storage-infra/         # Multi-user storage setup
├── docs/                      # Additional documentation
│   ├── prerequisites.md       # Setup guide
│   └── troubleshooting.md     # Common issues
├── TERRAFORM_MODULES.md       # Terraform modules documentation
└── README.md                  # This file
```

## Terraform Modules

This repository includes reusable Terraform modules to accelerate your infrastructure deployment:

### Windows Server Module (`terraform/modules/windows-server`)

Creates an Entra ID-enabled Windows Server 2022 infrastructure that supports up to 15 concurrent users:
- **Windows Server 2022**: Datacenter edition with RDS support
- **Entra ID Authentication**: Users authenticate with their Entra ID credentials
- **System-Assigned Identity**: For secure Azure service integration
- **Network Infrastructure**: VNet, Subnet, and NSG with security rules

Users authenticate with their **Entra ID credentials** to access the server via RDP.

**Quick Start:**
```bash
cd examples/windows-server
terraform init && terraform apply
```

### Storage Infrastructure Module (`terraform/modules/storage-infra`)

Creates a complete storage infrastructure for VM images:
- **Resource Group**: Per-user resource group (`rg-user-<number>`)
- **Storage Account**: With public access enabled
- **Storage Container**: Named `vmimages` for VM image storage

**Quick Start:**
```bash
# Single user setup
cd examples/single-user
terraform init && terraform apply

# Multiple users setup
cd examples/storage-infra
terraform init && terraform apply
```

**Documentation**: See [TERRAFORM_MODULES.md](TERRAFORM_MODULES.md) for detailed usage instructions.

## What You'll Learn

By completing this hackathon, you will:

- Navigate and use the Azure Portal effectively
- Understand Azure networking concepts (VNet, Subnet, NSG)
- Work with Azure Storage and virtual disk formats
- Configure Azure Backup and practice disaster recovery
- Write Infrastructure as Code with Terraform
- Create reusable Terraform modules
- Implement secrets management with Azure Key Vault
- Build CI/CD pipelines with GitHub Actions
- Follow security best practices
- Deploy production-ready infrastructure

## Learning Resources

### Azure Documentation
- [Azure Portal Overview](https://docs.microsoft.com/en-us/azure/azure-portal/)
- [Azure Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/)
- [Azure Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [Azure Backup](https://docs.microsoft.com/en-us/azure/backup/)
- [Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/)

### Terraform
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Modules](https://www.terraform.io/language/modules)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### CI/CD
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Infrastructure as Code Best Practices](https://docs.microsoft.com/en-us/azure/architecture/framework/devops/iac)

## Estimated Time

- **Total Time**: 6-8 hours (full day workshop)
- **Minimum**: Complete Challenges 1-4 (core skills)
- **Recommended**: Complete all 7 challenges (full experience)
- **Format**: Self-paced or instructor-led

## Support

If you encounter issues during the hackathon:

1. Check the challenge-specific README troubleshooting sections
2. Review `docs/troubleshooting.md` for common issues
3. Consult the Azure documentation links provided
4. Ask facilitators for help (if in a workshop setting)

## After Completing the Hackathon

### Next Steps
- Implement these skills in your own projects
- Explore Azure Kubernetes Service (AKS)
- Learn about Azure Landing Zones
- Study multi-cloud deployments
- Prepare for Azure certifications (AZ-104, AZ-305)

### Share Your Experience
- Write a blog post about what you learned
- Share your infrastructure code on GitHub
- Help others by answering questions
- Contribute improvements to this repository

## Contributing

This hackathon is open for improvements! Contributions are welcome:

- Report issues or bugs
- Suggest new challenges
- Improve documentation
- Share best practices
- Submit pull requests

## License

This project is provided as-is for educational purposes.

## Acknowledgments

Designed to provide hands-on experience with:
- Microsoft Azure
- HashiCorp Terraform
- GitHub Actions
- Infrastructure as Code practices

---

**Ready to start your Azure journey?** Begin with [Challenge 01](challenges/challenge-01/README.md)! 🚀