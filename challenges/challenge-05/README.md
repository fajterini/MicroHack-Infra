# Výzva 05: Vytvoření Terraform modulů pro nasazení VNet, Subnet a VM

## Overview

V této výzvě si vyzkoušíte, jak vytvořit **znovupoužitelné Terraform moduly** pro síť a virtuální stroj. Vezmete konfiguraci z výzvy 04 (kde jste měli vše v jednom `main.tf`) a rozdělíte ji tak, aby byla logika nasazení **Virtual Network + Subnet + VM** schovaná ve třech modulech, které lze použít v různých prostředích (dev/test/prod) jen změnou vstupních proměnných.

## Cíle

- Pochopit strukturu a přínosy Terraform modulů
- Vytvořit znovupoužitelné moduly pro nasazení VNet, Subnet a VM
- Pracovat s **module inputs a outputs**
- Umět volat modul z „root“ konfigurace
- Použít základní best practices pro moduly (naming, struktura, README)
- Připravit modul tak, aby byl použitelný pro více prostředí

## Předpoklady

- Dokončená **Výzva 04** (Terraform nasazení VM)
- Základní znalost Terraformu (provider, resource, variables, outputs, state)
- Existující Terraform konfigurace z výzvy 04 

## Pozadí

**Terraform module** je „balíček“ více resources, které patří logicky k sobě (např. VNet + Subnet, nebo VM + NIC + Public IP + NSG). Moduly jsou hlavní způsob, jak v Terraformu **balit a znovu používat** konfigurace.

Výhody modulů:

- **Reusability** – jednou napíšete, použijete mnohokrát
- **Organization** – lepší struktura kódu, menší `main.tf`
- **Abstraction** – schování složitosti za jednoduché rozhraní (vstupy/výstupy)
- **Standardization** – sjednocení způsobu, jak se v organizaci nasazují VM
- **Testing** – modul lze testovat samostatně
- **Versioning** – moduly lze verzovat (např. v Git repozitáři)

Typická struktura modulu:

```text
module/
├── main.tf        # definice resources
├── variables.tf   # vstupní proměnné modulu
├── outputs.tf     # výstupní hodnoty
└── README.md      # dokumentace modulu
```

## Architektura

Ve výzvě 04 jste měli vše v jednom `main.tf`. V této výzvě vytvoříte **tři samostatné moduly** – pro VNet, Subnet a VM – a root konfiguraci, která tyto moduly volá.

**Před (Výzva 04):**

```text
terraform/
├── provider.tf
├── variables.tf
├── main.tf        # všechny resources v jednom souboru
├── outputs.tf
└── terraform.tfvars
```

**Po (modulární přístup, 3 moduly):**

```text
terraform/
├── modules/
│   ├── azure-vnet/             # modul pro vytvoření Virtual Network
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── azure-subnet/           # modul pro vytvoření Subnetu v uvedeném VNetu
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── azure-vm/               # modul pro VM (NIC, Public IP, asociace NSG)
│       ├── main.tf
│       ├── variables.tf        # vstupy modulu (název VM, RG, subnet, NSG...)
│       ├── outputs.tf          # výstupy (IP adresy, ID resource...)
│       └── README.md           # krátký popis modulu
├── provider.tf
├── variables.tf                # vstupy pro root konfiguraci
├── main.tf                     # volání modulů (VNet, Subnet, VM)
├── outputs.tf                  # agregované výstupy (např. IP, název VM)
└── terraform.tfvars            # konkrétní hodnoty pro prostředí
```

## Kritéria úspěchu

- [ ] Vytvořeny adresáře `terraform/modules/azure-vnet`, `terraform/modules/azure-subnet`, `terraform/modules/azure-vm`
- [ ] Každý modul obsahuje soubory `main.tf`, `variables.tf`, `outputs.tf`, `README.md`
- [ ] Resource pro VNet byly přesunuty do modulu `azure-vnet`
- [ ] Resource pro Subnet byly přesunuty do modulu `azure-subnet`
- [ ] Resource pro VM (VM, NIC, Public IP, asociace NSG) byly přesunuty z root `main.tf` do modulu `azure-vm`
- [ ] Root `main.tf` volá všechny tři moduly ve správném pořadí a propojuje jejich výstupy
- [ ] Terraform `plan` a `apply` běží úspěšně
- [ ] Výsledný VM v Azure je funkční (stejně jako ve výzvě 04)
- [ ] V `outputs.tf` modulů jsou vystaveny alespoň základní údaje (např. ID VNet, ID Subnetu, veřejná IP, název VM)

## Otázky k zamyšlení

1. Jaký je rozdíl mezi modulem a obyčejným `main.tf` souborem?
2. Jak byste modul upravili, aby podporoval více typů OS (Windows i Linux) podle vstupní proměnné?
3. Jak byste modul připravili pro použití v různých prostředích (dev/test/prod)?
4. Jaké další výstupy modulu by byly užitečné pro monitoring nebo integraci (např. ID disku, ID resource group)?
5. Jak byste modul verzovali, pokud by byl uložen v samostatném Git repozitáři?

## Co jste se naučili

V této výzvě jste si procvičili:

- návrh a vytvoření **Terraform modulu**
- práci se vstupy a výstupy modulů
- rozdělení zodpovědností mezi root konfiguraci a modul
- refaktoring existující Terraform konfigurace do modulární podoby
- přípravu Terraform kódu na znovupoužitelnost v různých prostředích

## Další zdroje

- [Terraform Modules Documentation](https://www.terraform.io/language/modules)
- [Module Creation Best Practices](https://www.terraform.io/language/modules/develop)
- [Terraform Registry](https://registry.terraform.io/)
- [Module Composition Patterns](https://www.terraform.io/language/modules/develop/composition)
- [Publishing Modules](https://www.terraform.io/registry/modules/publish)
