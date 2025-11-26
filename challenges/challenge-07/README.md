# Výzva 07: Zabezpečená CI/CD pipeline s GitHub Actions a Azure Key Vault

## Overview

V této výzvě vezmete **nezabezpečený CI/CD pipeline** z výzvy 06 (s hardcoded credentials) a zrefaktorujete ho na **bezpečnější, produkci bližší pipeline**. Propojíte vše, co jste se naučili: Terraform, moduly, **Azure Key Vault**, GitHub Secrets a automatizované workflow tak, aby citlivá data už nebyla uložená přímo ve workflow souboru.

## Cíle

- Pochopit principy a přínosy CI/CD
- Vzít existující nezabezpečený pipeline a „ztvrdit“ ho (hardening)
- Automatizovat Terraform deployment pomocí GitHub Actions
- Integrovat Azure Key Vault do CI/CD pipeline
- Bezpečně používat GitHub Secrets a Key Vault secrets
- Uplatnit best practices pro infrastrukturní pipeline

## Předpoklady

- Dokončené výzvy **01–06**
- GitHub repozitář s vaším Terraform kódem
- Azure subscription a service principal pro nasazování
- Azure Key Vault se secrets (z výzvy 06)
- Základní znalost YAML syntaxe
- Základní znalost Gitu

## Pozadí

**CI/CD (Continuous Integration / Continuous Deployment)** automatizuje proces buildování, testování a nasazování infrastruktury.

Výhody:

- **Automation** – méně manuálních chyb
- **Consistency** – stejné kroky při každém nasazení
- **Speed** – rychlejší delivery
- **Auditability** – dohledatelnost všech změn
- **Collaboration** – možnost týmové spolupráce
- **Testing** – možnost validace před nasazením

Základní pojmy GitHub Actions:

- **Workflow** – automatizovaný proces definovaný v YAML
- **Job** – sada kroků, které běží na runneru
- **Step** – jednotlivý úkol (příkaz nebo action)
- **Action** – znovupoužitelná jednotka kódu
- **Runner** – server, na kterém workflow běží
- **Event** – událost, která workflow spouští
- **Secret** – šifrovaná proměnná v GitHubu

## Architektura

```text
GitHub Repository
│
├── .github/workflows/
│   ├── terraform-plan.yml     # validace PR (plan)
│   └── terraform-deploy.yml   # hlavní deployment
│
├── terraform/
│   ├── modules/azure-vnet/
│   ├── modules/azure-subnet/
│   ├── modules/azure-vm/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
Workflow Trigger (git push)
  ↓
GitHub Actions Runner
  ↓
Azure Login (service principal přes GitHub Secret)
  ↓
Načtení secrets z Key Vaultu
  ↓
Terraform Init / Plan / Apply
  ↓
Nasazení do Azure
  ↓
Verifikace a reporting
```

## Kritéria úspěchu

- [ ] Service principal je vytvořený a nakonfigurovaný
- [ ] GitHub Secrets jsou nastavené (`AZURE_CREDENTIALS`, `KEY_VAULT_NAME`, atd.)
- [ ] Service principal má přístup do Key Vaultu
- [ ] Terraform kód je v repozitáři
- [ ] Vytvořili jste všechna tři workflow (plan, deploy, destroy)
- [ ] Workflow se spouští podle očekávání
- [ ] Plan workflow komentuje výsledek do PR
- [ ] Deploy workflow úspěšně nasazuje infrastrukturu
- [ ] Dokážete se připojit k VM nasazeným pipeline
- [ ] Approval gates (pokud jsou nastavené) fungují

## Otázky k zamyšlení

1. Jaké jsou hlavní přínosy automatizovaného nasazování infrastruktury?
2. Proč je vhodné oddělit `plan` a `apply` do různých workflow?
3. Jak se liší GitHub Secrets od Key Vault secrets?
4. K čemu slouží trigger `workflow_dispatch`?
5. Proč používat approval gates pro produkční nasazení?
6. Jak pipeline zajišťuje bezpečnost citlivých dat?
7. Co se stane, když některý krok ve workflow selže?

## Co jste se naučili

V této výzvě jste získali zkušenosti s:

- tvorbou GitHub Actions workflow
- automatizací Terraform deploymentu
- integrací Azure Key Vault do CI/CD
- bezpečným používáním GitHub Secrets
- zavedením approval gates
- validací přes PR workflow (Terraform Plan)
- best practices pro produkční nasazování
- end‑to‑end automatizací infrastrukturního nasazení

## Best practices

### Návrh workflow
- oddělte validaci (plan) od nasazení (apply)
- používejte PR workflow pro validaci změn
- pro produkci zaveďte approval gates
- přidejte ruční triggery pro flexibilitu
- zahrňte rollback/destroy workflow

### Bezpečnost
- nikdy necommitujte secrets do repozitáře
- používejte GitHub Secrets pro přihlašovací údaje
- citlivá data ukládejte do Key Vaultu
- používejte service principal s minimálními nutnými oprávněními (least privilege)
- pravidelně rotujte credentials
- zapněte branch protection

### Testování
- validujte Terraform před `apply`
- kontrolujte formát (`terraform fmt`)
- spouštějte `terraform validate`
- před nasazením si vždy projděte plán
- nejdřív testujte v neprodukčním prostředí

### Monitoring
- přidávejte shrnutí nasazení (deployment summary)
- nastavte notifikace (Slack, e‑mail…)
- logujte důležité výstupy
- sledujte metriky běhu workflow
- nastavte alerty na selhání pipeline

## Troubleshooting

**Problém: „Workflow se nespouští“**
- zkontrolujte, že soubor je v `.github/workflows/`
- ověřte správnost YAML syntaxe
- zkontrolujte podmínky triggeru (branches, paths)
- ujistěte se, že jsou workflow v repozitáři povolené

**Problém: „Azure login failed“**
- ověřte, že `AZURE_CREDENTIALS` je správně nastavený
- zkontrolujte, zda service principal neexpiruje
- ověřte správný JSON formát
- zkontrolujte subscription ID

**Problém: „Cannot access Key Vault“**
- ověřte, že má service principal správnou Key Vault access policy
- zkontrolujte název Key Vaultu v secrets
- ujistěte se, že secrets v Key Vaultu existují
- zkontrolujte firewall nastavení Key Vaultu

**Problém: „Terraform init fails“**
- ověřte kompatibilitu verze Terraformu
- zkontrolujte konfiguraci provideru
- ujistěte se, že máte dostatečná oprávnění
- ověřte síťovou konektivitu

**Problém: „Terraform apply fails“**
- projděte si výstup z `plan`
- zkontrolujte kvóty v subscription / regionu
- ověřte, že jsou nastavené všechny potřebné proměnné
- přečtěte si detailní chyby v logu

**Problém: „Approval not working“**
- ověřte konfiguraci environmentu
- zkontrolujte, že jsou nastavení required reviewers
- ujistěte se, že workflow odkazuje správné environment
- uživatel, který schvaluje, musí mít potřebná oprávnění

## Úklid

Pro zrušení nasazených prostředků:

1. **Přes GitHub Actions:**
  - v repozitáři otevřete záložku **Actions**
  - vyberte workflow „Terraform Destroy“
  - klikněte na „Run workflow“
  - do vstupu napište `destroy` pro potvrzení
  - znovu klikněte na „Run workflow“

2. **Lokálně přes Terraform:**
  ```bash
  cd terraform
  terraform init
  terraform destroy
  ```

## Gratulujeme!

Dokončili jste všech 7 výzev! Máte za sebou:

✅ praktické zkušenosti s Azure Portalem  
✅ pochopení Azure sítí a virtuálních strojů  
✅ znalost Azure Backup a scénářů obnovy  
✅ dovednosti Infrastructure as Code s Terraformem  
✅ tvorbu znovupoužitelných modulů  
✅ správu secrets pomocí Key Vaultu  
✅ kompletní CI/CD pipeline pro infrastrukturu  

## Další zdroje

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform with GitHub Actions](https://learn.hashicorp.com/tutorials/terraform/github-actions)
- [Azure Service Principals](https://docs.microsoft.com/azure/active-directory/develop/app-objects-and-service-principals)
- [GitHub Actions Best Practices](https://docs.github.com/actions/security-guides/security-hardening-for-github-actions)
- [Infrastructure as Code Best Practices](https://docs.microsoft.com/azure/architecture/framework/devops/iac)
- [CI/CD for Infrastructure](https://www.terraform.io/use-cases/continuous-delivery)
