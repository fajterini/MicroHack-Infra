# Dev Container Configuration

This directory contains the development container configuration for the Azure Infrastructure Microhack.

## What's Included

The dev container provides a pre-configured development environment with:

- **Base Image**: Ubuntu-based development container
- **Bash Shell**: Default shell environment
- **Azure CLI**: Latest version for managing Azure resources
- **Terraform**: Latest version for Infrastructure as Code
- **VS Code Extensions**: Azure Resource Groups and HashiCorp Terraform extensions

## How to Use

### Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop) installed and running
- [Visual Studio Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Opening the Project in a Dev Container

1. Clone this repository
2. Open the repository folder in Visual Studio Code
3. When prompted, click "Reopen in Container" (or use Command Palette: `Dev Containers: Reopen in Container`)
4. Wait for the container to build and start
5. Once ready, you'll have access to bash and Azure CLI tools

### Verifying the Environment

After the container starts, open a terminal in VS Code and verify:

```bash
# Check bash version
bash --version

# Check Azure CLI version
az version

# Check Terraform version
terraform version
```

### Using Azure CLI

Login to Azure:
```bash
az login
az account set --subscription <your-subscription-id>
```

Now you're ready to work through the microhack challenges!

## Customization

You can customize this dev container by editing `.devcontainer/devcontainer.json`. See the [Dev Container specification](https://containers.dev/) for available options.
