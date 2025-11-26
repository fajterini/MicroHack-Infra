# Výzva 04: Vytvoření VM pomocí Terraformu

## Overview

V této výzvě přejdete od ručního klikání v Azure Portalu k přístupu **Infrastructure as Code (IaC)** s využitím nástroje **Terraform**. Smažete aktuální virtuální stroj (a případně související síťové prostředky) a znovu jej vytvoříte pomocí Terraform konfigurace. Cílem je pochopit, jak automatizovat a standardizovat nasazení virtuálních strojů.

## Cíle

- Pochopit principy **Infrastructure as Code (IaC)**
- Napsat Terraform konfiguraci pro Azure prostředky
- Pomocí Terraformu vytvořit Azure Virtual Machine
- Spravovat Terraform state soubory
- Používat **variables** a **outputs** v Terraformu
- Porovnat ruční nasazení přes Portal vs. automatizované nasazení Terraformem

## Předpoklady

- Dokončené výzvy **01–03** (znalost základů Azure, VM a sítí)
- Nainstalovaný **Terraform** (verze 1.0+)
- Nainstalované a nakonfigurované **Azure CLI** (přihlášený uživatel)
- V Azure máte připravenou **resource group**, do které budete Terraformem nasazovat (např. `rg-hackathon-<yourname>`)

## Pozadí

**Infrastructure as Code (IaC)** znamená, že infrastrukturu popisujeme jako kód (konfigurační soubory), místo abychom ji ručně vytvářeli v Portalu.

Výhody:

- **Repeatability** – možnost opakovaně vytvářet totožná prostředí
- **Version control** – změny infrastruktury jsou verzované stejně jako aplikace
- **Automation** – méně ruční práce, méně chyb
- **Documentation** – kód slouží jako dokumentace infrastrukturního návrhu
- **Collaboration** – více lidí může efektivně spolupracovat nad stejným kódem

Základy Terraformu:

- **Provider** – zajišťuje komunikaci s Azure (a dalšími cloudy)
- **Resource** – popisuje konkrétní prvek infrastruktury (VNet, Subnet, NSG, VM…)
- **Variable** – vstupní parametr pro znovupoužitelnost konfigurace
- **Output** – hodnoty, které Terraform vrátí po nasazení (např. veřejná IP)
- **State** – informace o tom, jaké prostředky Terraform vytvořil a v jakém jsou stavu

## Architektura

V této výzvě bude jako **existující** pouze resource group. Vše ostatní (síťová infrastruktura a Windows virtuální stroj) vytvoří Terraform.

Co budete mít na konci:

```text
Terraform konfigurace
├── provider.tf      - konfigurace Azure provideru
├── variables.tf     - definice vstupních proměnných (např. název RG, prefixy jmen)
├── main.tf          - definice sítí a Windows VM
│   ├── data "azurerm_resource_group"         - načtení existující resource group
│   ├── azurerm_virtual_network                - Virtual Network (nový)
│   ├── azurerm_subnet                        - Subnet (nový)
│   ├── azurerm_network_security_group        - Network Security Group (nový)
│   ├── azurerm_network_security_rule        - pravidla NSG (RDP, případně další)
│   ├── azurerm_public_ip                     - Public IP pro VM (nový)
│   ├── azurerm_network_interface             - Network Interface pro VM (nový)
│   └── azurerm_windows_virtual_machine       - Windows Virtual Machine (nový)
├── outputs.tf       - definice výstupních hodnot (např. public IP)
└── terraform.tfvars - konkrétní hodnoty proměnných

Nasazení do Azure (příklad):
Resource Group (existující)
├── Virtual Network (nový)
│   └── Subnet (nový, použit pro NIC/VM)
├── Network Security Group (nový, přiřazený k Subnetu/NIC)
│   └── Security rules (např. povolený RDP z vybraného rozsahu)
├── Public IP (nový, spravovaný Terraformem)
├── Network Interface (nový, připojený do Subnetu a NSG)
└── Windows Virtual Machine (nový, připojený k NIC)
```

## Terraform workflow

### Základní Terraform příkazy

1. **`terraform init`** – inicializace pracovního adresáře
   - stáhne požadované providery
   - připraví backend a moduly

2. **`terraform fmt`** – formátování kódu
   - sjednocuje styl zápisu
   - zvyšuje čitelnost

3. **`terraform validate`** – kontrola syntaxe konfigurace
   - ověřuje, že konfigurace dává smysl
   - nekontroluje volání provider API

4. **`terraform plan`** – plán změn
   - ukáže, co se vytvoří/změní/smaže
   - reálně nic nemění
   - vhodné pro review před nasazením

5. **`terraform apply`** – provedení změn
   - vytvoří/aktualizuje/smaže prostředky podle plánu
   - vyžaduje potvrzení (pokud nepoužijete `-auto-approve`)
   - aktualizuje state soubor

6. **`terraform destroy`** – smazání všech Terraformem spravovaných prostředků
   - odstraní vše, co je ve state
   - používat opatrně :)

### Terraform state

State soubor (`terraform.tfstate`) obsahuje:

- seznam prostředků, které Terraform vytvořil
- aktuální konfiguraci a metadata
- informace o závislostech mezi prostředky

**Důležité:**

- state soubor **needitujte ručně**
- chraňte ho (může obsahovat citlivé údaje)
- v týmu používejte **remote state** (např. Azure Storage)

### Data sources vs resources

**Data sources** (`data` bloky):

- slouží k načtení existujících prostředků
- jsou pouze pro čtení
- nic nevytvářejí
- typický příklad: existující VNet, Subnet, NSG

**Resources** (`resource` bloky):

- vytvářejí nové prostředky
- jsou Terraformem spravované (lze je měnit/smazat)
- příklad: nová VM, NIC, Public IP


**Kontrola Terraform state**
   ```bash
   # Výpis všech prostředků ve state
   terraform state list

   # Spočítání prostředků
   terraform state list | wc -l
   ```

## Kritéria úspěchu

- [ ] Původní VM z předchozích výzev byl smazán (pokud existoval)
- [ ] Vytvořili jste všechny potřebné Terraform soubory (`provider.tf`, `main.tf`, `variables.tf`, `outputs.tf`, případně `terraform.tfvars`)
- [ ] `terraform init` proběhlo úspěšně
- [ ] `terraform validate` nevrací chyby
- [ ] `terraform plan` ukazuje očekávané prostředky (VNet, Subnet, NSG, Public IP, NIC, Windows VM)
- [ ] `terraform apply` doběhlo bez chyb
- [ ] Nový **Windows VM** je v Azure vytvořen a běží
- [ ] NSG obsahuje pravidlo pro RDP (TCP 3389) podle vašeho bezpečnostního požadavku
- [ ] Dokážete se na VM přihlásit přes RDP (přímo nebo přes Azure Bastion)
- [ ] Terraform outputs se zobrazují správně (např. veřejná IP, název VM)
- [ ] Byl vytvořen Terraform state soubor

## Otázky k zamyšlení

1. Co je Infrastructure as Code (IaC) a proč je užitečná?
2. Jaký je rozdíl mezi `terraform plan` a `terraform apply`?
3. Kdy má smysl použít **data sources** místo **resources** a jaký je mezi nimi rozdíl?
4. Jaké informace obsahuje Terraform state soubor?
5. Jak Terraform rozhoduje, jaké změny má proti Azure provést?
6. Co se stane, když spustíte `terraform apply` dvakrát se stejnou konfigurací?
7. Jak byste změnili velikost VM pomocí Terraformu?

## Co jste se naučili

V této výzvě jste získali praktickou zkušenost s:

- principy **Infrastructure as Code**
- tvorbou Terraform konfigurací pro Azure
- použitím Terraform provideru pro Azure
- správou prostředků pomocí Terraformu
- použitím **data sources** pro existující prostředky
- prací s **variables** a **outputs** pro flexibilitu konfigurace
- pochopením Terraform **state managementu**
- porovnáním ručního nasazení přes Portal s automatizací pomocí Terraformu

## Úklid (volitelné)

Pokud chcete prostředky vytvořené Terraformem odstranit:

```bash
# Zrušení všech Terraformem spravovaných prostředků
terraform destroy

# Terraform zobrazí plán mazání – zkontrolujte ho
# Potvrďte zadáním 'yes'
```

## Další kroky

Po dokončení této výzvy pokračujte na [Výzvu 05](../challenge-05/README.md), kde vytvoříte znovupoužitelný Terraform modul pro nasazení VM.

## Další zdroje

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Language Documentation](https://www.terraform.io/language)
- [Azure Virtual Machines](https://docs.microsoft.com/azure/virtual-machines/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Infrastructure as Code](https://docs.microsoft.com/devops/deliver/what-is-infrastructure-as-code)
