# Výzva 03: Obnova virtuálního stroje z Azure Backup

## Overview

V této výzvě si vyzkoušíte obnovu virtuálního stroje z Azure Backup. Nejdříve bezpečně smažete původní VM, pro který jste v předchozí výzvě nastavili zálohování, a poté jej obnovíte z existujícího recovery pointu v Recovery Services vault. Výsledkem bude nově vytvořený VM (např. se sufixem `-restored`), ke kterému se úspěšně připojíte a ověříte, že obsahuje původní data.

## Cíle

- Pochopit možnosti obnovy VM z Azure Backup
- Spustit **restore operation** z Recovery Services vault
- Obnovit VM jako nový virtuální stroj s novým názvem
- Ověřit funkčnost obnoveného VM (připojení, data)
- Uvědomit si rozdíly mezi obnovou „create new“ a „replace existing“

## Předpoklady

- Dokončená **Výzva 02** s úspěšnou zálohou vámi vytvořeného VM
- V Recovery Services vault existuje alespoň jeden **recovery point** pro tento VM

## Pozadí

Azure Backup umožňuje obnovu virtuálního stroje dvěma základními způsoby:

- **Create new** – vytvoří nový VM (s novým jménem) na základě vybraného recovery pointu
- **Replace existing** – nahradí existující VM stavem z recovery pointu

V rámci této výzvy použijete variantu **create new**, protože původní VM nejprve smažete. Tento scénář je běžný například při havárii (disaster recovery), kdy potřebujete VM obnovit na původní konfiguraci, ale nechcete kolidovat s existujícími prostředky (disky, NIC, IP adresy).

## Klíčové pojmy (navazuje na Výzvu 02):

- **Restore operation** – proces vytvoření nového VM nebo nahrazení stávajícího pomocí backup dat
- **Recovery point** – konkrétní snapshot v čase použitý pro obnovu
- **Restore job** – úloha v Recovery Services vault, která vykonává samotnou obnovu

## Kritéria úspěchu

- [ ] Původní virtuální stroj, který jste zálohovali ve Výzvě 02, byl smazán
- [ ] Obnova (restore) byla spuštěna z Recovery Services vault pomocí existujícího recovery point
- [ ] Vznikl nový VM s novým názvem ve správné resource group
- [ ] Restore job dokončil se statusem **Completed**
- [ ] Obnovený VM běží a lze se k němu připojit (SSH/RDP)
- [ ] OS a data odpovídají stavu před smazáním původního VM

## Otázky k zamyšlení

1. Jaký je rozdíl mezi obnovou **Create new** a **Replace existing**? Kdy byste zvolili kterou variantu?
2. Jak Azure Backup zachází s konfigurací sítě (VNet, Subnet, NSG, Public IP) při obnově?
3. Jaké zvláštní aspekty musíte zohlednit při obnově VM připojených do domény (domain-joined)?
4. Jak se můžete vyhnout konfliktům názvů prostředků (disky, NIC, IP) při obnově více VM?
5. Jaká jsou omezení obnovy z Azure Backup (např. cross-region, cross-subscription, změna typu disku)?
6. Jak byste obnovu VM automatizovali pomocí Azure CLI nebo PowerShellu?

## Co jste se naučili

V této výzvě jste získali praktickou zkušenost s:

- Odstraněním virtuálního stroje a jeho následnou obnovou z Azure Backup
- Použitím Recovery Services vault k obnovení Azure Virtual Machines
- Volbou správného způsobu obnovy (create new vs. replace existing)
- Validací obnoveného VM (připojení, data, konfigurace sítě)
- Přemýšlením o scénářích disaster recovery a návratu do provozu

## Další kroky

Po dokončení této výzvy můžete pokračovat k pokročilejším scénářům:

- obnova více VM jako části jedné aplikace,
- zálohování a obnova dalších workloadů (SQL, File Shares, atd.),
- automatizace zálohování a obnovy pomocí **Azure CLI**, **PowerShellu** nebo **Bicep/Terraform**.

**Důležité:** Po ověření funkčnosti obnoveného VM zvažte úklid nepotřebných prostředků (staré disky, NIC, Public IP), abyste předešli zbytečným nákladům.


## Další zdroje

- [Obnova Azure VMs z backupu](https://docs.microsoft.com/azure/backup/backup-azure-arm-restore-vms)
- [Přehled backup a restore Azure VMs](https://docs.microsoft.com/azure/backup/backup-azure-vms-introduction)
- [Troubleshooting Azure Backup](https://docs.microsoft.com/azure/backup/backup-azure-vms-troubleshoot)
