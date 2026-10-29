# Goldbot One - set del venditore (zip scaricato da Wim il 2026-10-29)

Cinque set: HighRisk_Max50DD, MediumRisk_Max30DD, LowRisk_Max15DD, PropFirm_10_5, PropFirm_5_2.5.

Tutti: Risk=3, LotPerBalance_step=1000, Randomization=0, OnlyUp=0.
Differiscono per MaxRiskPerStrategy e PropFirmMaxDailyDD:

| set | MaxRiskPerStrategy | PropFirmMaxDailyDD |
|---|---|---|
| HighRisk_Max50DD | 10 | 0 |
| MediumRisk_Max30DD | 6 | 0 |
| LowRisk_Max15DD | 3 | 0 |
| PropFirm_10_5 | 2 | 4 |
| PropFirm_5_2.5 | 1 | 2 |

ATTENZIONE: la configurazione di Goldbot One testata finora da noi (PROP-ANNI SI, 2013/2018/2020) usava
Risk=9999, MaxRiskPerStrategy 6, LotPerBalance_step 6000. NON e' nessuno di questi set. Il risultato
PROP-ANNI di Goldbot One non vale per i set del venditore finche' non sono testati.

## Mappa di Risk e manuali (2026-10-29)
Mappa gia' misurata nella sonda 3 del 21/10 [PROBABILE, dai lotti]: Risk=0 use StartLots, Risk=3 use Max Risk Per Strategy,
Risk=9999 use LotsizeStep. I set del venditore usano Risk=3 (Max Risk Per Strategy), il nostro PROP-ANNI usava 9999 (step 6000).
Sonda 3 (01/2025-10/2026, 80K, Risk 3, step irrilevante): MaxRisk 3 -> DD equity 10.829 (13,5%); MaxRisk 6 -> 31.372 (39,2%); MaxRisk 10 -> 80.555.
I set PropFirm (MaxRisk 2 e 1) NON sono mai stati misurati; nessuna misura su 2013/2018/2020 con Risk=3.
Manuali caricati da Claudio: Goldbot One v3.0, Gold Phantom v2.1, Gold Trade Pro v6.74 (ottobre 2026). Novita': Virtual SL/TP, filtri tassi e CPI
(spenti di default), correzione gestione trade con sessione a cavallo di mezzanotte. Possibile differenza rispetto alle demo del Market testate.
