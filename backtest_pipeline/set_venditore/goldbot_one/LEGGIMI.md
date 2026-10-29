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
