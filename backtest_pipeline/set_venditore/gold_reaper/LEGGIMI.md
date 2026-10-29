# Set e manuale del venditore per The Gold Reaper (Profalgo / Wim), ricevuti il 29/10/2026
File di Claudio (`The_Gold_Reaper.zip` e `live_signal_settings.set`); copie conservate, non modificate; nomi sistemati (spazi e "%" tolti). Il file `live_signal_settings.set` e IDENTICO (stessa impronta) a `Gold Reaper my_live signal settings.set` del zip: una sola copia. `Gold_Reaper_V5.1.pdf` e il manuale v5.1. Impronte SHA256 (prime 16 cifre) in `SHA256_PRIMI16.txt`.
| File | TradeFrequency | MaxAllowedDD | Limite giornaliero | OnlyUp | Randomization | Altro |
|---|---|---|---|---|---|---|
| `gold_reaper_propfirm.set` | 2 | 9 | 4 | false | **50** | Virtual_expiration true |
| `gold_reaper_maxrisk10.set` | 5 (auto) | 10 | 0 | true | 0 | |
| `gold_reaper_maxrisk15_LowRisk.set` | 5 | 15 | 0 | true | 0 | chiamato "LowRisk" dal venditore |
| `gold_reaper_default_mediumRisk.set` | 5 | 30 | 0 | true | 0 | NFP: 140 min prima, 110 dopo |
| `gold_reaper_maxrisk60_HighRisk.set` | 5 | 60 | 0 | true | 0 | |
| `gold_reaper_live_signal_settings.set` | 2 | 30 | 0 | true | 0 | `FakeOutFilter=2`, `UseVariableValues` e `AdjustLotsizeToVariableValues` true, `UseHL_TrailingSL` true, `Virtual_expiration` false, NFP 100 prima / 60 dopo |
Tutti: `StartLots=0,01`, `MaxSpread=500`, `FridayStopHour=25`, `AutoGMT` con offset 2 (inverno) / 3 (estate), `MaxRiskPerStrategy_=1,0`, strategie 1-9 accese (dove presenti).
Il nostro set prop dei test a 80.000 (`TradeFrequency=2`, `MaxAllowedDD=9`, `PropFirmMaxDailyDD=4`, `OnlyUp=false`) coincide con `gold_reaper_propfirm.set` tranne `Randomization` (noi 0, il set 50, per rendere ripetibili le corse).

## Aggiunta 2026-10-29 (zip "Gold-Reaper-Set-Files" riscaricato dal sito di Wim)
Nuovi: gold_reaper_15%maxrisk.set (TF5, MaxAllowedDD 15, daily 0, OnlyUp 1, Randomization 0) e gold_reaper_default.set
(differisce dal default gia' salvato solo per sezioni omesse). Live signal, propfirm, 10% e 60% senza differenze sugli input chiave.
Il manuale PDF caricato da Claudio il 2026-10-29 ha testo identico a Gold_Reaper_V5.1.pdf gia' in cartella.
