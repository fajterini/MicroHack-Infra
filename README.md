# Azure Infrastructure Hackathon

Vítejte na Azure Infrastructure Hackathonu! Tento praktický workshop vás provede základy Azure – od manuální práce v portálu až po plně automatizované nasazení infrastruktury pomocí CI/CD pipeline.

## Overview

Hackathon se skládá ze sedmi progresivních výzev navržených tak, aby vás postupně provedly světem Azure:

1. **Základy Azure Portalu** – Vytvoření VNet, Subnet, konverze VMDK na VHD, nasazení VM, konfigurace NSG
2. **Azure Backup** – Povolení a konfigurace zálohování pro virtuální stroje
3. **Disaster Recovery** – Smazání a obnova VM ze zálohy
4. **Infrastructure as Code** – Znovuvytvoření VM pomocí Terraformu
5. **Terraform Modules** – Vytvoření znovupoužitelných infrastrukturních modulů
6. **Azure Key Vault** – Bezpečná správa tajemství (secrets)
7. **CI/CD Pipeline** – Automatizace nasazení infrastruktury pomocí GitHub Actions

## Přihlášení

Pro přihlášení do Azure použijte následující formát uživatelského jména:

```
user<číslo_uživatele>@MngEnvMCAP872133.onmicrosoft.com
```

Například: `user1@MngEnvMCAP872133.onmicrosoft.com`, `user2@MngEnvMCAP872133.onmicrosoft.com` atd.

Heslo vám bude sděleno organizátory workshopu.

## Předpoklady

Před zahájením hackathonu se ujistěte, že máte:

- **Azure Subscription** s oprávněním Contributor nebo Owner
- **Webový prohlížeč** pro přístup k Azure Portalu
- **Azure CLI** nainstalované a nakonfigurované ([Instalační příručka](https://docs.microsoft.com/cs-cz/cli/azure/install-azure-cli))
- **Terraform** (verze 1.0 nebo novější) – nutný od Výzvy 04 ([Instalační příručka](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- **PowerShell s Hyper-V** (Windows) nebo **qemu-img** (Linux/Mac) pro konverzi VMDK na VHD
- **Git** pro verzování kódu
- **GitHub účet** s přístupem k repozitáři (pro Výzvu 07)
- **Textový editor nebo IDE** (doporučujeme VS Code)

## Začínáme

1. Naklonujte tento repozitář:
   ```bash
   git clone https://github.com/msucharda/microhacks-infra.git
   cd microhacks-infra
   ```

2. Přihlaste se do Azure:
   ```bash
   az login
   az account set --subscription <vaše-subscription-id>
   ```

3. Začněte s Výzvou 01 a postupně procházejte jednotlivé výzvy.

## Výzvy

### Výzva 01: Základy Azure Portalu
**Cíl:** Prakticky se seznámit se základy Azure prostřednictvím Portalu

Přejděte do `challenges/challenge-01/` a:
- Vytvořte Virtual Network a Subnet
- Nastavte Storage Account
- Převeďte VMDK na formát VHD
- Nasaďte Virtual Machine
- Nakonfigurujte Network Security Groups

**Dovednosti:** Navigace v Azure Portalu, sítě, storage, správa VM  
**Čas:** 60–90 minut

### Výzva 02: Povolení Azure Backup
**Cíl:** Ochrana virtuálních strojů pomocí Azure Backup

Přejděte do `challenges/challenge-02/` a:
- Vytvořte Recovery Services Vault
- Nakonfigurujte zálohovací politiky
- Povolte zálohování pro vaše VM
- Spusťte a sledujte zálohovací úlohy

**Dovednosti:** Business continuity, disaster recovery, správa zálohování  
**Čas:** 30–45 minut

### Výzva 03: Smazání a obnova VM ze zálohy
**Cíl:** Procvičení postupů disaster recovery

Přejděte do `challenges/challenge-03/` a:
- Smažte váš virtuální stroj
- Obnovte VM ze zálohy
- Ověřte integritu dat
- Pochopte možnosti obnovy

**Dovednosti:** Disaster recovery, operace obnovy, ochrana dat  
**Čas:** 45–60 minut

### Výzva 04: Znovuvytvoření VM pomocí Terraformu
**Cíl:** Přechod na Infrastructure as Code

Přejděte do `challenges/challenge-04/` a:
- Napište Terraform konfigurační soubory
- Použijte data sources pro existující prostředky
- Nasaďte VM pomocí Terraformu
- Spravujte stav infrastruktury

**Dovednosti:** Infrastructure as Code, základy Terraformu, automatizace  
**Čas:** 60–75 minut

### Výzva 05: Vytvoření Terraform modulů
**Cíl:** Vytvoření znovupoužitelných infrastrukturních komponent

Přejděte do `challenges/challenge-05/` a:
- Vytvořte modul pro nasazení VM
- Definujte vstupy a výstupy modulu
- Použijte modul vícekrát
- Pochopte kompozici modulů

**Dovednosti:** Terraform moduly, znovupoužitelnost kódu, best practices  
**Čas:** 45–60 minut

### Výzva 06: Implementace Azure Key Vault
**Cíl:** Bezpečná správa tajemství (secrets)

Přejděte do `challenges/challenge-06/` a:
- Vytvořte Azure Key Vault
- Uložte GitHub credentials a secrets
- Nakonfigurujte přístupové politiky
- Přistupujte k secrets z Terraformu

**Dovednosti:** Bezpečnost, správa secrets, řízení přístupu  
**Čas:** 30–45 minut

### Výzva 07: Implementace CI/CD Pipeline
**Cíl:** Automatizace nasazení infrastruktury

Přejděte do `challenges/challenge-07/` a:
- Vytvořte GitHub Actions workflows
- Integrujte s Azure Key Vault
- Automatizujte Terraform deploymenty
- Implementujte approval gates

**Dovednosti:** CI/CD, GitHub Actions, end-to-end automatizace  
**Čas:** 75–90 minut

## Postup učení

Hackathon sleduje progresivní přístup k učení:

```
Fáze 1: Základy Azure (Výzvy 1-3)
├── Manuální operace přes Azure Portal
├── Pochopení základních Azure služeb
└── Základy disaster recovery

Fáze 2: Infrastructure as Code (Výzvy 4-5)
├── Úvod do Terraformu
├── Automatizované nasazení prostředků
└── Znovupoužitelné infrastrukturní moduly

Fáze 3: Bezpečnost a automatizace (Výzvy 6-7)
├── Správa secrets pomocí Key Vault
├── Implementace CI/CD pipeline
└── Produkčně připravené workflow
```

## Architektura

Na konci hackathonu budete mít vytvořenou následující infrastrukturu:

```
Azure Subscription
│
├── Resource Group
│   ├── Virtual Network
│   │   └── Subnet (s NSG)
│   ├── Storage Account (úložiště VMDK/VHD)
│   ├── Recovery Services Vault (zálohy)
│   ├── Key Vault (secrets)
│   └── Virtual Machines (spravované Terraformem)
│       ├── OS Disk
│       ├── Network Interface
│       └── Public IP
│
└── GitHub Repository
    ├── Terraform Modules
    └── CI/CD Workflows (GitHub Actions)
```

## Struktura repozitáře

```
.
├── challenges/
│   ├── challenge-01/          # Základy Azure Portalu
│   ├── challenge-02/          # Nastavení Azure Backup
│   ├── challenge-03/          # Obnova VM ze zálohy
│   ├── challenge-04/          # Nasazení VM pomocí Terraformu
│   ├── challenge-05/          # Terraform moduly
│   ├── challenge-06/          # Azure Key Vault
│   └── challenge-07/          # CI/CD s GitHub Actions
├── terraform/                 # Konfigurace Terraformu a moduly
│   ├── main.tf                # Hlavní vstupní bod infrastruktury
│   └── modules/               # Znovupoužitelné Terraform moduly
│       ├── windows-server/    # Modul Windows Server s Entra ID
│       └── storage-infra/     # Modul pro storage infrastrukturu
└── README.md                  # Tento soubor
```

## Terraform moduly

Tento repozitář obsahuje znovupoužitelné Terraform moduly pro urychlení nasazení infrastruktury:

### Windows Server Module (`terraform/modules/windows-server`)

Vytvoří Windows Server 2022 infrastrukturu s podporou Entra ID pro až 15 současných uživatelů:
- **Windows Server 2022**: Datacenter edice s podporou RDS
- **Entra ID Authentication**: Uživatelé se přihlašují pomocí svých Entra ID přihlašovacích údajů
- **System-Assigned Identity**: Pro bezpečnou integraci s Azure službami
- **Síťová infrastruktura**: VNet, Subnet a NSG s bezpečnostními pravidly

Uživatelé se přihlašují pomocí svých **Entra ID přihlašovacích údajů** pro přístup k serveru přes RDP.

### Storage Infrastructure Module (`terraform/modules/storage-infra`)

Vytvoří kompletní storage infrastrukturu pro VM image:
- **Resource Group**: Resource group pro každého uživatele (`rg-user-<číslo>`)
- **Storage Account**: S povoleným veřejným přístupem
- **Storage Container**: Pojmenovaný `vmimages` pro úložiště VM image

**Dokumentace**: Podrobné instrukce naleznete v [TERRAFORM_MODULES.md](TERRAFORM_MODULES.md).

## Co se naučíte

Po dokončení hackathonu budete umět:

- Efektivně navigovat a používat Azure Portal
- Rozumět síťovým konceptům v Azure (VNet, Subnet, NSG)
- Pracovat s Azure Storage a formáty virtuálních disků
- Konfigurovat Azure Backup a praktikovat disaster recovery
- Psát Infrastructure as Code s Terraformem
- Vytvářet znovupoužitelné Terraform moduly
- Implementovat správu secrets pomocí Azure Key Vault
- Budovat CI/CD pipeline pomocí GitHub Actions
- Dodržovat bezpečnostní best practices
- Nasazovat produkčně připravenou infrastrukturu

## Další zdroje

### Azure dokumentace
- [Přehled Azure Portalu](https://docs.microsoft.com/cs-cz/azure/azure-portal/)
- [Azure Virtual Machines](https://docs.microsoft.com/cs-cz/azure/virtual-machines/)
- [Azure Virtual Networks](https://docs.microsoft.com/cs-cz/azure/virtual-network/)
- [Azure Backup](https://docs.microsoft.com/cs-cz/azure/backup/)
- [Azure Key Vault](https://docs.microsoft.com/cs-cz/azure/key-vault/)

### Terraform
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Modules](https://www.terraform.io/language/modules)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### CI/CD
- [GitHub Actions dokumentace](https://docs.github.com/en/actions)
- [Infrastructure as Code Best Practices](https://docs.microsoft.com/cs-cz/azure/architecture/framework/devops/iac)

## Odhadovaný čas

- **Celkový čas**: 6–8 hodin (celodenní workshop)
- **Minimum**: Dokončete Výzvy 1–4 (základní dovednosti)
- **Doporučeno**: Dokončete všech 7 výzev (kompletní zkušenost)
- **Formát**: Vlastním tempem nebo s instruktorem

## Po dokončení hackathonu

### Další kroky
- Implementujte tyto dovednosti ve svých vlastních projektech
- Prozkoumejte Azure Kubernetes Service (AKS)
- Naučte se o Azure Landing Zones
- Studujte multi-cloud nasazení
- Připravte se na Azure certifikace (AZ-104, AZ-305)

### Sdílejte své zkušenosti
- Napište blog post o tom, co jste se naučili
- Sdílejte svůj infrastrukturní kód na GitHubu
- Pomáhejte ostatním odpovídáním na otázky
- Přispějte vylepšeními do tohoto repozitáře

## Přispívání

Hackathon je otevřený pro vylepšení! Příspěvky jsou vítány:

- Nahlašujte problémy nebo chyby
- Navrhujte nové výzvy
- Vylepšujte dokumentaci
- Sdílejte best practices
- Posílejte pull requesty

## Licence

Tento projekt je poskytován tak, jak je, pro vzdělávací účely.

## Poděkování

Navrženo pro poskytnutí praktických zkušeností s:
- Microsoft Azure
- HashiCorp Terraform
- GitHub Actions
- Infrastructure as Code praktikami

---

**Jste připraveni začít svou cestu s Azure?** Začněte s [Výzvou 01](challenges/challenge-01/README.md)! 🚀