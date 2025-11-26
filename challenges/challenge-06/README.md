# Výzva 06: Základní CI/CD pipeline s hardcoded credentials

## Overview

V této výzvě si vytvoříte **jednoduchou CI/CD pipeline** pomocí GitHub Actions, která nasazuje vaši Terraform infrastrukturu do Azure. Záměrně začnete s **hardcoded / nezabezpečenými přihlašovacími údaji** (Azure service principal JSON a případně GitHub token) přímo ve workflow souboru nebo v běžných GitHub Secrets. V následující výzvě toto řešení refaktorujete tak, aby používalo Azure Key Vault a bezpečnější postupy.

## Cíle

- Pochopit základní strukturu CI/CD pipeline v GitHub Actions
- Zautomatizovat Terraform `init/plan/apply` z CI/CD pipeline
- Prakticky vidět použití hardcoded credentials v pipeline (anti‑pattern pro naučné účely)
- Uvědomit si, proč je ukládání secrets přímo do workflow nebezpečné
- Připravit podklad pro další výzvu, kde přidáte Key Vault a bezpečné ukládání secrets

## Předpoklady

- Dokončené výzvy **04–05** (máte připravený Terraform kód a moduly)
- GitHub repozitář s vaším Terraform kódem (z předchozích výzev)
- Azure subscription a service principal s oprávněním nasazovat prostředky
- Nainstalované **Azure CLI** (pro lokální přípravu)

## Pozadí

**CI/CD (Continuous Integration / Continuous Deployment)** automatizuje aplikaci vaší Terraform konfigurace při změnách v repozitáři.

V této výzvě budete **záměrně** dělat věci méně bezpečným způsobem:

- vložíte Azure service principal JSON přímo do workflow souboru **nebo** do jednoduchého GitHub secretu bez dalších ochran
- můžete „natvrdo“ zapsat subscription ID, tenant ID, název resource group přímo do YAML

Cílem není vytvořit produkčně připravený pipeline, ale mít něco, co **funguje**, a co v Challenge 07 zabezpečíte.

## Architektura

```text
GitHub Repository
│
├── .github/workflows/
│   └── terraform-deploy-insecure.yml   # jednoduchá CI/CD pipeline
│
├── terraform/
│   ├── modules/azure-vnet/
│   ├── modules/azure-subnet/
│   ├── modules/azure-vm/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
Workflow Trigger (push na main)
  ↓
GitHub Actions Runner
  ↓
Azure Login (hardcoded service principal credentials)
  ↓
Terraform Init/Plan/Apply
  ↓
Nasazení do Azure
```

## Kontrolní seznam (verifikace)

- [ ] Existuje GitHub repozitář s Terraform kódem z předchozích výzev
- [ ] V repozitáři je vytvořen soubor `.github/workflows/terraform-deploy-insecure.yml`
- [ ] Workflow obsahuje hardcoded Azure service principal credentials (nebo jinou zjevně nebezpečnou formu uložení tajemství)
- [ ] Po pushi na `main` se workflow spustí
- [ ] Terraform `init/plan/apply` v rámci workflow proběhne úspěšně
- [ ] Infrastruktura je v Azure nasazená pouze na základě CI/CD (bez ručního `terraform apply`)

## Otázky k zamyšlení

1. Jaká rizika vznikají při hardcodování přihlašovacích údajů do workflow souboru?
2. Co se stane, pokud někdo získá přístup k repozitáři nebo historii commitů s credentials?
3. Jak byste zlepšili tento pipeline, aniž byste ještě použili Key Vault (např. GitHub Secrets)?
4. Jak byste omezili oprávnění service principal, který pipeline používá?

## Co jste se naučili

V této výzvě jste si vyzkoušeli:

- vytvoření základního GitHub Actions workflow pro Terraform
- přihlášení do Azure z CI/CD pipeline
- spuštění Terraform `init/plan/apply` automaticky při pushi na větev `main`
- pochopení, proč jsou hardcoded credentials nebezpečné a proč je musíte odstranit

## Další kroky

V **Challenge 07** tento nezabezpečený pipeline zrefaktorujete:

- přesunete citlivá data mimo workflow soubor
- uložíte secrets do Azure Key Vault a/nebo GitHub Secrets
- nastavíte GitHub Actions tak, aby si secrets bezpečně načítal až za běhu

## Další zdroje

- [GitHub Actions – dokumentace](https://docs.github.com/en/actions)
- [Azure Login action](https://github.com/Azure/login)
- [Terraform GitHub Actions](https://learn.hashicorp.com/tutorials/terraform/github-actions)
- [Azure Service Principals](https://docs.microsoft.com/azure/active-directory/develop/app-objects-and-service-principals)
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
