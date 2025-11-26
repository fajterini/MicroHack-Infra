# Výzva 02: Azure Backup pro virtuální stroje

## Overview

V této výzvě nastavíte zálohování pro virtuální stroj, který jste vytvořili v první výzvě,  pomocí služby Azure Backup a Recovery Services vault. Vytvoříte nový Recovery Services vault, nakonfigurujete backup policy, povolíte zálohování pro existující VM a spustíte počáteční zálohu. Na konci si ověříte, že máte k dispozici alespoň jeden recovery point a umíte v Azure Portalu sledovat stav backup jobů.

## Cíle

- Pochopit základní principy služby Azure Backup
- Vytvořit a nakonfigurovat **Recovery Services vault**
- Nastavit **backup policy** pro Azure Virtual Machines
- Povolovat zálohování pro existující VM
- Rozumět **retention policy** a plánům zálohování (backup schedule)
- Monitorovat backup jobs a ověřit úspěšnost záloh

## Předpoklady

- Dokončená **Výzva 01** s běžícím virtuálním strojem

## Pozadí

**Azure Backup** je cloudová služba pro zálohování, která chrání vaše data a virtuální stroje v Azure bez nutnosti provozovat vlastní backup infrastrukturu.

Klíčové pojmy:

- **Recovery Services vault** – logický trezor, ve kterém jsou uložena zálohovací data a recovery points
- **Backup policy** – definuje, kdy se zálohy spouští (schedule) a jak dlouho se uchovávají (retention)
- **Backup job** – konkrétní běh zálohovací úlohy, která vytvoří recovery point
- **Recovery point** – bod v čase (snapshot), do kterého lze VM obnovit
- **Retention policy** – pravidla, jak dlouho se jednotlivé recovery points uchovávají

Výhody Azure Backup:

- Application-consistent zálohy pro VM (tam, kde je to možné)
- Dlouhodobá retence (až desítky let podle policy)
- Není potřeba vlastní infrastruktura – plně spravovaná služba
- Možnost obnovy celého VM nebo pouze vybraných souborů
- Podpora pro Linux i Windows virtuální stroje

## Základní koncepty Azure Backup

### Backup schedule (plán záloh)

- Zálohy běží automaticky podle nastavené backup policy
- Kromě plánovaných záloh můžete kdykoli spustit **on-demand** manuální zálohu
- Pro většinu workloadů se doporučuje denní záloha

### Retention policy (retence)

- **Instant restore** – rychlá obnova z lokálních snapshotů (typicky 2–5 dní zpětně)
- **Daily retention** – kolik denních recovery points uchovávat (např. 7–30 dní)
- **Weekly / Monthly / Yearly retention** – volitelná dlouhodobá retence pro compliance nebo archivaci

### Typy záloh

- **Application-consistent backup** – zajišťuje konzistenci aplikací (VSS na Windows, skripty agenta na Linuxu)
- **Crash-consistent backup** – zachytí stav disku v daném okamžiku (jako při výpadku napájení)
- **File-system consistent** – zaručuje konzistenci souborového systému

### Nákladové aspekty

- **Protected instance** – účtování za každý chráněný VM (podle velikosti)
- **Backup storage** – účtování za uložená zálohovací data v Recovery Services vault
- Instant restore snapshoty mohou být dražší než dlouhodobé uložení v Recovery Services vault
- Retention policy nastavte tak, abyste našli kompromis mezi cenou a požadovanou úrovní ochrany

## Kritéria úspěchu

- [ ] Recovery Services vault vytvořen ve stejném regionu jako VM
- [ ] Backup policy nakonfigurovaná (výchozí nebo vlastní) pro Azure VMs
- [ ] Zálohování povoleno pro VM
- [ ] Počáteční backup job spuštěn ("Backup now")
- [ ] Backup job dokončen se statusem **Completed**
- [ ] V Recovery Services vault je k dispozici alespoň jeden recovery point pro VM
- [ ] V Azure Portalu vidíte stav zálohování a historii backup jobs

## Otázky k zamyšlení

1. Jaký je rozdíl mezi **instant restore** a standardní obnovou z trezoru?
2. Proč může dávat smysl mít odlišnou retention policy pro denní, týdenní a měsíční zálohy?
3. Co uděláte, když backup job selže? Jaké logy a metriky budete kontrolovat?
4. Za jakých podmínek můžete obnovit VM do jiného regionu a jaké to má dopady na dostupnost a náklady?
5. Jaký je rozdíl mezi **application-consistent** a **crash-consistent** zálohami a kdy vám to může být jedno?
6. Jak Azure Backup pracuje se šifrovanými VM (např. Azure Disk Encryption)? Jaké jsou limity?

## Co jste se naučili

V této výzvě jste získali praktickou zkušenost s:

- Tvorbou a konfigurací **Recovery Services vaultu**
- Pochopením a nastavením **backup policy** a **retention policy**
- Povolením zálohování pro Azure Virtual Machines
- Spouštěním manuálních (on-demand) záloh
- Monitoringem a čtením stavu **backup jobs**
- Prací s **recovery points** a plánováním obnovy
- Základy plánování **business continuity** a **disaster recovery (BC/DR)**

## Další kroky

Jakmile úspěšně dokončíte tuto výzvu a máte ověřenou zálohu, pokračujte na [Výzvu 03](../challenge-03/README.md), kde virtuální stroj smažete a obnovíte jej právě z vytvořeného backupu.

## Další zdroje

- [Azure Backup – přehled](https://docs.microsoft.com/azure/backup/backup-overview)
- [Zálohování Azure VMs](https://docs.microsoft.com/azure/backup/backup-azure-vms-introduction)
- [Recovery Services vaults](https://docs.microsoft.com/azure/backup/backup-azure-recovery-services-vault-overview)
- [Backup policy a retence](https://docs.microsoft.com/azure/backup/backup-azure-vms-first-look-arm)
- [Monitoring Azure Backup](https://docs.microsoft.com/azure/backup/backup-azure-monitoring-built-in-monitor)
- [Ceník Azure Backup](https://azure.microsoft.com/pricing/details/backup/)
