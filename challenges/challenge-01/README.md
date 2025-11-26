# Výzva 01: Základy Azure Portal

## Overview

V předpřipraveném storage accountu (název bude sdílen organizátory) je uložen VHD image virtuálního stroje. V Azure Portalu si najděte tento storage account a ověřte, že image je v kontejneru `vm-images`. Následně si ve vlastní resource group vytvořte Virtual Network (VNet) a subnet. Po vytvoření VNetu a subnetu vytvořte nový managed disk z uvedené VHD image ve stejné lokaci. Ujistěte se, že vytváříte Gen 2 windows disk. Z tohoto managed disku pak vytvořte nové Virtual Machine (VM). Při vytváření VM si zdůvodněte všechny volby (region, velikost, disk, síť, zabezpečení). Nakonec se na VM připojte přes Azure Bastion.

## Cíle

- Umět se orientovat a pracovat v Azure Portalu
- Vytvářet a konfigurovat virtuální sítě (Virtual Network / VNet) a subnety
- Pracovat se Storage Accountem a blob storage
- Vytvořit managed disk z existující VHD image a použít jej pro VM
- Nasazovat virtuální stroje (Virtual Machines / VM) pomocí Azure Portalu
- Konfigurovat Network Security Groups (NSG) pro zabezpečení VM

## Pozadí

Tato výzva je zaměřená na používání Azure Portalu pro všechny operace. Azure Portal je webové rozhraní, které umožňuje vizuálně spravovat Azure zdroje. Praktický postup vám pomůže pochopit koncepty Azure dříve, než je začnete automatizovat v dalších výzvách.

**Klíčové pojmy:**
- **Virtual Network (VNet)**: izolovaná virtuální síť v Azure pro vaše prostředky
- **Subnet**: část VNetu s vyhrazeným adresním prostorem
- **Storage Account**: škálovatelné cloudové úložiště pro různé typy dat
- **VHD image**: soubor virtuálního disku ve formátu VHD
- **Managed Disk**: spravovaný disk v Azure vytvořený z VHD nebo image
- **Network Security Group (NSG)**: sada pravidel firewallu řídící síťový provoz
- **Virtual Machine (VM)**: výpočetní prostředek se spuštěným operačním systémem

## Otázky k zamyšlení

1. Jaký je účel Virtual Network v Azure a jak se liší od fyzické sítě?
2. Co je to privátní subnet?
3. Co je to subnet delegation a k čemu se používá?
4. Proč Azure vyžaduje formát VHD pro disky VM?
5. Jak Network Security Groups chrání vaše virtuální stroje?
6. Jaký je rozdíl mezi NSG pravidly na úrovni subnetu a na úrovni NIC?
7. Proč je vhodné omezit SSH/RDP přístupy pouze na konkrétní IP adresy?

## Kritéria úspěchu

- [ ] Resource group vytvořena přes Azure Portal
- [ ] Vytvořená virtuální síť se subnetem
- [ ] NSG vytvořena s odpovídajícími pravidly
- [ ] NSG asociovaná se subnetem
- [ ] Virtuální stroj vytvořen a běží
- [ ] Úspěšné připojení k VM (RDP nebo SSH podle typu image)
- [ ] Všechny zdroje jsou přehledně uspořádané v resource group

## Co jste se naučili

V rámci této výzvy jste získali praktickou zkušenost s:
- Navigací v Azure Portalu
- Vytvářením a organizací prostředků pomocí Resource Groups
- Nastavením síťové infrastruktury (VNet a subnety)
- Zabezpečením VM pomocí Network Security Groups
- Nasazením a připojením k virtuálním strojům

## Další kroky

Po dokončení této výzvy pokračujte na [Výzvu 02](../challenge-02/README.md), kde povolíte Azure Backup pro svůj virtuální stroj.

## Tipy pro úspěch

- **Pište si poznámky:** názvy prostředků, IP adresy a konfiguraci.
- **Konzistentní pojmenování:** usnadní orientaci i automatizaci.
- **Stejný region:** držte všechny zdroje v jedné oblasti.
- **Hlídání nákladů:** sledujte Azure Cost Management a volte rozumné velikosti VM
- **Dokumentace:** pořizujte screenshoty a krátké poznámky k postupu.

## Další zdroje

- [Azure Portal – dokumentace](https://docs.microsoft.com/azure/azure-portal/)
- [Azure Virtual Networks – přehled](https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview)
- [Azure Storage – dokumentace](https://docs.microsoft.com/azure/storage/)
- [Network Security Groups](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)
- [Azure Virtual Machines](https://docs.microsoft.com/azure/virtual-machines/)
- [Požadavky na VHD](https://docs.microsoft.com/azure/virtual-machines/windows/prepare-for-upload-vhd-image)
- [Naming & Tagging Best Practices](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
