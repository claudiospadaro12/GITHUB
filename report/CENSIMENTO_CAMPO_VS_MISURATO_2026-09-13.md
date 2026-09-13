# 🧬 CENSIMENTO CAMPO vs MISURATO — 51 sedie, un commit per ognuna

> **Data: 13/09/2026 (notte, Claudio dorme) · perimetro: SOLA LETTURA.**
> Non è stato toccato nessun EA, nessun preset, nessun `.chr`, nessun forward,
> nessun round è stato preparato. Questo referto **legge** e **conta**.
> Non serviva il tester: la macchina di backtest è ferma e questo lavoro non la usa.
>
> 🔴 **Nessun saldo, equità o P/L di nessun conto è scritto qui.** Il repo è
> pubblico: i **parametri** si scrivono (stanno già in `mql5/Presets/`), i
> **soldi** no. Per il reale `10105439` e per il 100k `50504263` compare **solo
> la colonna dello scarto di codice**.

---

## 🎯 LA DOMANDA, e perché vale

Stanotte, preparando `ABTG_EMA200` (`771531`), abbiamo misurato che il binario
**in campo** non è il sorgente su cui la sedia è stata promossa:

```
344a11b (04/08)  486 righe   <- il binario IN CAMPO
26a1856 (19/08)  552 righe   <- il codice che ha prodotto PF 1,52365
HEAD             690 righe   <- e dentro c'e' un commit "NON COMPILARE"
```
`[MISURATO]` — `git show 344a11b:mql5/Experts/ABTG_EMA200.mq5 | wc -l` = **486** ·
`26a1856` = **552** · `wc -l mql5/Experts/ABTG_EMA200.mq5` = **690**.

👉 **Se il binario in campo non è quello misurato, il numero su cui la sedia è
stata promossa NON LA DESCRIVE.** Nessuno aveva mai contato **quante sedie** ne
soffrono. Adesso il numero c'è, ed è **40 su 51**.

---

## ⚠️ IL LIMITE STRUTTURALE, dichiarato PRIMA dei numeri

🔴 **Un commit che NON aggiunge un input è INVISIBILE alla sonda degli input.**
La sonda confronta gli input salvati nel `.chr` con gli `input`/`sinput`
dichiarati nel sorgente a HEAD: vede solo i commit che hanno **aggiunto una
manopola**. Un fix che cambia il calcolo del lotto, lo stop o una condizione
d'ingresso **senza toccare gli input** non lascia traccia.

👉 **Quindi la colonna "età minima" è un PAVIMENTO, non un'età.** Dice *"il
binario è almeno più vecchio di questa data"*, mai *"il binario è di questa
data"*.

🟢 **E per questo ho aggiunto una SECONDA sonda, indipendente**, che quel limite
non ce l'ha (§4). Le due insieme danno un **pin esatto** per quasi ogni sedia.
Il contro-esempio di §5 mostra, con due casi reali, **esattamente quanto costa**
avere solo la prima.

---

## 🔬 LE DUE SONDE

| | **SONDA A — gli input del `.chr`** | **SONDA B — righe + versione del sorgente in cartella** |
|---|---|---|
| fonte | `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260912_033002.log` | `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260912_033002.log` |
| cosa misura | quali input l'EA **aveva quando ha scritto il grafico** | quante **righe** e che **versione** ha il `.mq5` nella cartella del terminale |
| vede | solo i commit che **aggiungono input** | **tutti** i commit che cambiano il numero di righe |
| non vede | i commit senza input nuovi | i commit a **saldo di righe zero** (nessuno trovato) |
| taratura | `.chr` del **profilo attivo**, 12/09 03:31 | `.ex5` compilati 03/08→06/09, letti 12/09 03:30 |

**Taratura della sonda B** `[MISURATO]`: il runner conta `$t -split "\r?\n"`
(`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` r.110), che su un file
terminato da a-capo dà **`wc -l` + 1**. Tutti i confronti qui sono fatti con quel
`+1` applicato. Verifica: `ABTG_Guardian.mq5` repo `wc -l` = 899, runner = 900.

### 🧹 Il difetto già pagato: gli INDICATORI dentro il `.chr`

Il `.chr` contiene l'EA **e** gli indicatori appesi allo stesso grafico. Se non
si scartano, **ogni sedia risulta "DIVERGE"** e il censimento non vale niente.

`[MISURATO]` — gli input estranei sono **32 distinti**, e **tutti e 32**
esistono in `mql5/Indicators/ABTG_Look.mq5` o `mql5/Indicators/ABTG_LivelliChiave.mq5`:
`InpMostraEma`, `InpEma1..4`, `InpBbPeriodo`, `InpBbDeviazione`, `InpMostraMaxIeri`,
`InpCol*/InpStile*/InpSpes*`, `InpMostraEtichette`, `InpFontSize`, `InpVerbose`.
Comparivano **47-48 volte su 51** sedie. Sono stati scartati con un `grep` sul
sorgente dell'EA, uno per uno.

🟢 **E c'è una conferma che il filtro è giusto, non comodo**: sul reale
`C:\BCM_Reale` gli indicatori **non sono appesi**, e infatti lì gli input
estranei sono **ZERO su 4 sedie** (`chr=82/src=82`, `54/54`, `12/12`, `16/19`).
Se il filtro fosse stato arbitrario, il reale non sarebbe tornato pulito da solo.

---

# 1. 📊 I NUMERI, in testa

| | quante |
|---|---:|
| Sedie con un EA sul grafico, sui **4 terminali BCM** | **51** (40 piccolo `50503392` · 7 100k `50504263` · 4 reale `10105439` · **0** banco `50504400`) |
| 🟢 **Allineate a HEAD, riga per riga** | **11** |
| 🔴 **Disallineate** | **40** |
| 🔴 di cui **con almeno un commit di classe SEGNALE mancante** | **38** |
| 🟠 di cui con soli commit **GESTIONE/DIAGNOSTICA** | **2** |
| 🔴 di cui con un commit che **morde al default** (non opt-in, nessuno deve accendere niente) | **19** — di cui **6** di classe SEGNALE e **15** di classe GESTIONE (2 sedie stanno in tutte e due) |

📌 **Il banco `50504400` (`C:\MT5_Backtest`) ha ZERO sedie, ed è uno zero
misurato**, non un buco: `CODA_08...log` r.16-19 — *"5 file .chr letti nel
profilo attivo, nessuno con un EA sopra"*.

📌 I due terminali **non-BCM** (Pepperstone, Tickmill) sono fuori perimetro.
Tickmill ha 2 sedie (`Gold_Ichimoku_TK_ATR_EA` `250604`, `BREAKOUT_EA_JPY_v3`),
la seconda **senza sorgente nel repo** → `[NON MISURABILE da qui]`.

---

# 2. 🗂️ LA TABELLA MADRE

**Come si legge la colonna "commit mancanti in tutto"**: è la sonda B (pin
esatto → HEAD). Ogni commit porta la sua classe — **S** = SEGNALE, **G** =
GESTIONE, **D** = DIAGNOSTICA — e 🔴 se **morde al default**, cioè se cambia il
comportamento *senza* che nessuno accenda niente.


#### piccolo 50503392

| sedia | magic | .chr (riga log) | input mancanti (sonda A) | commit che li ha introdotti | PIN del binario (sonda B) | eta' MINIMA del binario | commit mancanti in tutto | tocca il SEGNALE? |
|---|---|---|---|---|---|---|---|---|
| `ABTG_TradeExporter` NZDCAD | `-` | chart01.chr (r.27) | — (nessuno) | — | `76c79de` 2026-08-03 v1.00 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_PTE` U30USD | `771321` | chart02.chr (r.70) | `InpUsaGuardian`; `InpLogImbuto`; `InpSlippagePts` | `26a1856` (2026-08-19); `4c424e2` (2026-08-15); `b45dd00` (2026-09-11) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-15** | `b45dd00`/D, `26a1856`/S, `4c424e2`/G, `a5d36d8`/D, `3af47ed`🔴/G, `2687f13`/D | 🔴 **SI** |
| `ABTG_BreakingBand` GBPUSD | `772161` | chart03.chr (r.151) | `InpUsaGuardian`; `InpContEntryMode`; `InpTrendSlopeFactor`; `InpTrendSlopeBars`; `InpContEntryMaxRangeATR`; `InpContRequireMidFirst`; `InpMinRR` | `26a1856` (2026-08-19); `2a1fa24` (2026-08-29); `40db664` (2026-08-29); `e528527` (2026-08-20) | `24f4b7a` 2026-08-12 v1.02 | anteriore al **2026-08-19** | `2a1fa24`/S, `40db664`/S, `e528527`/S, `26a1856`/S | 🔴 **SI** |
| `ABTG_BreakingBand` EURUSD | `772162` | chart04.chr (r.259) | `InpUsaGuardian`; `InpContEntryMode`; `InpTrendSlopeFactor`; `InpTrendSlopeBars`; `InpContEntryMaxRangeATR`; `InpContRequireMidFirst`; `InpMinRR` | `26a1856` (2026-08-19); `2a1fa24` (2026-08-29); `40db664` (2026-08-29); `e528527` (2026-08-20) | `24f4b7a` 2026-08-12 v1.02 | anteriore al **2026-08-19** | `2a1fa24`/S, `40db664`/S, `e528527`/S, `26a1856`/S | 🔴 **SI** |
| `ABTG_BreakingBand` AUDUSD | `772163` | chart05.chr (r.367) | `InpUsaGuardian`; `InpContEntryMode`; `InpTrendSlopeFactor`; `InpTrendSlopeBars`; `InpContEntryMaxRangeATR`; `InpContRequireMidFirst`; `InpMinRR` | `26a1856` (2026-08-19); `2a1fa24` (2026-08-29); `40db664` (2026-08-29); `e528527` (2026-08-20) | `24f4b7a` 2026-08-12 v1.02 | anteriore al **2026-08-19** | `2a1fa24`/S, `40db664`/S, `e528527`/S, `26a1856`/S | 🔴 **SI** |
| `ABTG_GapFill` GBPUSD | `772231` | chart06.chr (r.475) | `InpUsaGuardian` | `26a1856` (2026-08-19) | `a766659` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `26a1856`/S | 🔴 **SI** |
| `ABTG_GapFill` EURUSD | `772232` | chart07.chr (r.529) | `InpUsaGuardian` | `26a1856` (2026-08-19) | `a766659` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `26a1856`/S | 🔴 **SI** |
| `ABTG_GapFill` AUDUSD | `772233` | chart08.chr (r.583) | `InpUsaGuardian` | `26a1856` (2026-08-19) | `a766659` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `26a1856`/S | 🔴 **SI** |
| `ABTG_GapFill` U30USD | `772234` | chart09.chr (r.637) | `InpUsaGuardian` | `26a1856` (2026-08-19) | `a766659` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `26a1856`/S | 🔴 **SI** |
| `ABTG_GapFill` 225JPY | `772235` | chart10.chr (r.691) | `InpUsaGuardian` | `26a1856` (2026-08-19) | `a766659` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `26a1856`/S | 🔴 **SI** |
| `ABTG_PunteLarry` U30USD | `772341` | chart11.chr (r.745) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `cb7dc20` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_PunteLarry` EURAUD | `772342` | chart12.chr (r.803) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `cb7dc20` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_PunteLarry` XAUUSD | `772343` | chart13.chr (r.861) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `cb7dc20` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_PunteLarry` GBPJPY | `772344` | chart14.chr (r.919) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `cb7dc20` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_PunteLarry` GBPUSD | `772345` | chart15.chr (r.977) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `cb7dc20` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_PunteLarry` EURCAD | `772346` | chart16.chr (r.1035) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `cb7dc20` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_CostToCost` EURJPY | `772361` | chart17.chr (r.1093) | `InpUsaGuardian`; `InpLogImbuto` | `26a1856` (2026-08-19); `b45dd00` (2026-09-11) | `9b1c611` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `b45dd00`/D, `26a1856`/S | 🔴 **SI** |
| `ABTG_CostToCost` GBPCAD | `772362` | chart18.chr (r.1148) | `InpUsaGuardian`; `InpLogImbuto` | `26a1856` (2026-08-19); `b45dd00` (2026-09-11) | `9b1c611` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `b45dd00`/D, `26a1856`/S | 🔴 **SI** |
| `ABTG_EasyTrend` CHFJPY | `772421` | chart20.chr (r.1203) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `95bc4ec` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_EasyTrend` GBPUSD | `772422` | chart21.chr (r.1291) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `95bc4ec` 2026-08-13 v1.00 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_GapContinuation` 225JPY | `774101` | chart23.chr (r.1356) | `InpUsaGuardian`; `InpLogImbuto` | `26a1856` (2026-08-19); `b45dd00` (2026-09-11) | `7246558` 2026-08-16 v1.50 | anteriore al **2026-08-19** | `b45dd00`/D, `26a1856`/S | 🔴 **SI** |
| `ABTG_PTE` GBPUSD | `771332` | chart24.chr (r.1427) | `InpUsaGuardian`; `InpLogImbuto`; `InpSlippagePts` | `26a1856` (2026-08-19); `4c424e2` (2026-08-15); `b45dd00` (2026-09-11) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-15** | `b45dd00`/D, `26a1856`/S, `4c424e2`/G, `a5d36d8`/D, `3af47ed`🔴/G, `2687f13`/D | 🔴 **SI** |
| `ABTG_PTE` GBPUSD | `771322` | chart26.chr (r.1508) | `InpUsaGuardian`; `InpLogImbuto`; `InpSlippagePts` | `26a1856` (2026-08-19); `4c424e2` (2026-08-15); `b45dd00` (2026-09-11) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-15** | `b45dd00`/D, `26a1856`/S, `4c424e2`/G, `a5d36d8`/D, `3af47ed`🔴/G, `2687f13`/D | 🔴 **SI** |
| `ABTG_SuperWave` U30USD | `770531` | chart27.chr (r.1589) | `InpUsaGuardian`; `InpPendingAtr`; `InpSLBufferAtr`; `InpLogImbuto` | `7f80a87` (2026-08-17); `b45dd00` (2026-09-11); `f8ebc32` (2026-08-19) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-17** | `b45dd00`/D, `872dba8`🔴/G, `f8ebc32`/S, `7f80a87`/S, `a5d36d8`/D, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_MaxMinNotte` XAUUSD | `770402` | chart29.chr (r.1669) | `InpUsaGuardian`; `InpAutoTest` | `5fc0bc3` (2026-08-19); `7d0da9f` (2026-09-03) | `0823951` 2026-07-28 v1.10 | anteriore al **2026-08-19** | `7d0da9f`🔴/S, `5fc0bc3`/S, `ec518d5`/D, `3af47ed`🔴/G, `d4da7d7`🔴/G | 🔴 **SI** |
| `ABTG_DAX_Apertura_EU` D30EUR | `770101` | chart30.chr (r.1759) | `InpUsaGuardian`; `InpAllowReverse` | `c88d160` (2026-08-14); `d83c196` (2026-08-19) | `3af47ed` 2026-08-08 v1.00 | anteriore al **2026-08-14** | `9638318`🔴/G, `d83c196`/S, `bc11093`🔴/S, `c88d160`🔴/S, `6074126`/D | 🔴 **SI** |
| `ABTG_Dow_Apertura_US` U30USD | `770202` | chart31.chr (r.1878) | `InpUsaGuardian` | `d83c196` (2026-08-19) | `3af47ed` 2026-08-08 v1.00 | anteriore al **2026-08-19** | `d83c196`/S, `8b92214`🔴/S, `6074126`/D | 🔴 **SI** |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` D30EUR | `770411` | chart32.chr (r.1997) | `InpUsaGuardian` | `5fc0bc3` (2026-08-19) | `6074126` 2026-08-08 v1.10 | anteriore al **2026-08-19** | `5fc0bc3`/S | 🔴 **SI** |
| `ABTG_EMA200` U30USD | `771531` | chart33.chr (r.2087) | `InpUsaGuardian`; `InpLogImbuto` | `26a1856` (2026-08-19); `b45dd00` (2026-09-11) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-19** | `b45dd00`/D, `26a1856`/S, `6074126`/D, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_EMA200_Ottimizzato` XAUUSD | `971501` | chart34.chr (r.2168) | `InpUsaGuardian`; `InpFloorPolicy`; `InpFloorVerbose`; `InpLogImbuto` | `26a1856` (2026-08-19); `6ee2ec0` (2026-09-11); `b45dd00` (2026-09-11) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-19** | `b45dd00`/D, `65de32c`/G, `6ee2ec0`/G, `26a1856`/S, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_SupertrendReversal` 225JPY | `770924` | chart35.chr (r.2249) | `InpUsaGuardian`; `InpLogImbuto` | `b45dd00` (2026-09-11); `f8ebc32` (2026-08-19) | `3af47ed` 2026-08-08 v1.00 | anteriore al **2026-08-19** | `b45dd00`/D, `872dba8`🔴/G, `f8ebc32`/S, `6074126`/D | 🔴 **SI** |
| `ABTG_SupertrendReversal_Ottimizzato` XAUUSD | `970901` | chart36.chr (r.2331) | `InpUsaGuardian`; `InpLogImbuto` | `b45dd00` (2026-09-11); `f8ebc32` (2026-08-19) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-19** | `b45dd00`/D, `872dba8`🔴/G, `f8ebc32`/S, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` U30USD | `770511` | chart37.chr (r.2411) | `InpUsaGuardian`; `InpPendingAtr`; `InpSLBufferAtr`; `InpLogImbuto` | `7f80a87` (2026-08-17); `b45dd00` (2026-09-11); `f8ebc32` (2026-08-19) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-17** | `b45dd00`/D, `872dba8`🔴/G, `f8ebc32`/S, `7f80a87`/S, `6074126`/D, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_SupRev_DAX_H4_Ottimizzato` D30EUR | `970912` | chart38.chr (r.2491) | `InpUsaGuardian` | `f8ebc32` (2026-08-19) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-19** | `872dba8`🔴/G, `f8ebc32`/S, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_SupRev_NAS_H1_Ottimizzato` NASUSD | `970913` | chart39.chr (r.2571) | `InpUsaGuardian` | `f8ebc32` (2026-08-19) | `344a11b` 2026-08-04 v1.00 | anteriore al **2026-08-19** | `872dba8`🔴/G, `f8ebc32`/S, `6074126`/D, `3af47ed`🔴/G | 🔴 **SI** |
| `ABTG_ORB_Ottimizzato` U30USD | `770611` | chart40.chr (r.2651) | — (nessuno) | — | `19312c8` 2026-09-03 v1.04 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_Nasdaq_Apertura_US` NASUSD | `770250` | chart41.chr (r.2744) | `InpUsaGuardian`; `InpRunnerTP_R`; `InpMinBreakoutRangeATR`; `InpUseVolRegime`; `InpVolAtrPeriod`; `InpVolLookback`; `InpVolLowPct`; `InpVolHighPct`; `InpVolLowOffMult`; `InpVolHighOffMult`; `InpVolLowSlMult`; `InpVolHighSlMult`; `InpVolHighSizeMult`; `InpUseSRFilter`; `InpSRProximityPts`; `InpSRUsePrevDay`; `InpSRUseRoundNumbers`; `InpSRRoundInterval` | `b5d904a` (2026-08-29); `b8947ba` (2026-08-12); `d83c196` (2026-08-19) | `3af47ed` 2026-08-08 v1.00 | anteriore al **2026-08-12** | `b5d904a`/S, `d83c196`/S, `8b92214`🔴/S, `39cc34d`/S, `b8947ba`/S, `6074126`/D | 🔴 **SI** |
| `ABTG_PostNews` USDJPY | `771203` | chart42.chr (r.2863) | — (nessuno) | — | `61dc18c` 2026-09-03 v1.10 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_PostNews` EURJPY | `771201` | chart43.chr (r.2934) | — (nessuno) | — | `61dc18c` 2026-09-03 v1.10 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_PostNews` EURUSD | `771202` | chart44.chr (r.3005) | — (nessuno) | — | `61dc18c` 2026-09-03 v1.10 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |

#### 100k 50504263

| sedia | magic | .chr (riga log) | input mancanti (sonda A) | commit che li ha introdotti | PIN del binario (sonda B) | eta' MINIMA del binario | commit mancanti in tutto | tocca il SEGNALE? |
|---|---|---|---|---|---|---|---|---|
| `ABTG_DAX_Apertura_EU` D30EUR | `770101` | chart01.chr (r.3146) | — (nessuno) | — | `d83c196` 2026-08-19 v1.01 | **[nessun pavimento dalla sonda A]** | `9638318`🔴/G | 🟠 no (GESTIONE) |
| `ABTG_Dow_Apertura_US` U30USD | `770202` | chart02.chr (r.3267) | — (nessuno) | — | `d83c196` 2026-08-19 v1.01 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` D30EUR | `770411` | chart03.chr (r.3387) | — (nessuno) | — | `5fc0bc3` 2026-08-19 v1.10 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_SupertrendReversal` 225JPY | `770901` | chart04.chr (r.3478) | `InpLogImbuto` | `b45dd00` (2026-09-11) | `f8ebc32` 2026-08-19 v1.00 | anteriore al **2026-09-11** | `b45dd00`/D, `872dba8`🔴/G | 🟠 no (GESTIONE) |
| `ABTG_TradeExporter` EURUSD | `-` | chart05.chr (r.3561) | — (nessuno) | — | `76c79de` 2026-08-03 v1.00 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_ORB_Ottimizzato` U30USD | `770611` | chart06.chr (r.3604) | `InpAutoTest` | `19312c8` (2026-09-03) | `3125e34` 2026-08-19 v1.02 | anteriore al **2026-09-03** | `19312c8`🔴/S, `ad1f024`/D | 🔴 **SI** |
| `ABTG_Guardian` AUDNZD | `779001` | chart07.chr (r.3696) | `InpDailyBaseline`; `InpMaxClusterRiskPct`; `InpClusterMappa` | `a21d0c0` (2026-09-08); `cdb2037` (2026-09-07) | `1f4c92b` 2026-08-19 v1.11 | anteriore al **2026-09-07** | `a21d0c0`/S, `cdb2037`/S, `1b6a095`/S, `d884f7e`🔴/S | 🔴 **SI** |

#### reale 10105439

| sedia | magic | .chr (riga log) | input mancanti (sonda A) | commit che li ha introdotti | PIN del binario (sonda B) | eta' MINIMA del binario | commit mancanti in tutto | tocca il SEGNALE? |
|---|---|---|---|---|---|---|---|---|
| `ABTG_DAX_Apertura_EU` D30EUR | `770101` | chart01.chr (r.3761) | — (nessuno) | — | `9638318` 2026-09-02 v1.01 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_ORB_Ottimizzato` U30USD | `770611` | chart02.chr (r.3850) | — (nessuno) | — | `19312c8` 2026-09-03 v1.04 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_SlippageLogger` EURJPY | `-` | chart03.chr (r.3911) | — (nessuno) | — | `7b2c6d2` 2026-09-05 v1.00 | **[nessun pavimento dalla sonda A]** | **0 — allineato a HEAD** | 🟢 allineata |
| `ABTG_Guardian` EURGBP | `779002` | chart04.chr (r.3930) | `InpDailyBaseline`; `InpMaxClusterRiskPct`; `InpClusterMappa` | `a21d0c0` (2026-09-08); `cdb2037` (2026-09-07) | `1b6a095` 2026-09-06 v1.12 | anteriore al **2026-09-07** | `a21d0c0`/S, `cdb2037`/S | 🔴 **SI** |

---

# 3. 🎚️ LA COLONNA CHE DECIDE — «tocca il SEGNALE?»

**Le tre classi, definite prima di usarle:**
- 🔴 **SEGNALE** — cambia **quando o se** si entra o si esce;
- 🟠 **GESTIONE** — cambia il **lotto** o lo **stop**;
- 🟡 **DIAGNOSTICA** — solo log, export, contatori.

**I 34 commit mancanti, classificati leggendo il diff, uno per uno.** La colonna
🔴 dice se il commit **morde al default**: se cambia il comportamento anche
quando nessuno accende niente.

| commit | data | classe | 🔴 morde al default? | cosa fa (dal diff) | sedie toccate |
|---|---|---|---|---|---:|
| `26a1856` | 19/08 | 🔴 SEGNALE | no (vedi §3-bis) | cancello `ABTG_GuardiaIngresso` prima dell'invio dell'ordine — 16 EA | 16 |
| `5fc0bc3` | 19/08 | 🔴 SEGNALE | no (§3-bis) | stesso cancello, straddle e rami alternativi — 11 EA | 10 |
| `f8ebc32` | 19/08 | 🔴 SEGNALE | no (§3-bis) | stesso cancello, famiglia SupRev/SuperWave — 13 EA | 6 |
| `d83c196` | 19/08 | 🔴 SEGNALE | no (§3-bis) | stesso cancello, famiglia Apertura — 8 EA, 31 punti | 3 |
| `e528527` | 20/08 | 🔴 SEGNALE | no — `InpMinRR=0` | cancello di RR minimo: `if(InpMinRR>0 && rr<InpMinRR){ return; }` — **rifiuta ingressi** | 3 |
| `40db664` | 29/08 | 🔴 SEGNALE | no — `InpContEntryMode=0` | modo d'ingresso RETEST sulla banda opposta | 3 |
| `2a1fa24` | 29/08 | 🔴 SEGNALE | no — `InpContEntryMode=0` | modo d'ingresso IN-BULGE (trend mediana + candela + range) | 3 |
| `b8947ba` | 12/08 | 🔴 SEGNALE + 🟠 GESTIONE | no — due `false` | `SRBlocked()` salta l'ingresso · regime di volatilità scala **SL e size** | 1 |
| `39cc34d` | 12/08 | 🔴 SEGNALE | no — opt-in | VolRegime/SRFilter innestati nel lab Nasdaq (v1.01) | 1 |
| `b5d904a` | 29/08 | 🔴 SEGNALE | no — `=0` | modo d'ingresso F1 (forza della rottura) + `RunnerTP()` sull'**uscita** | 1 |
| `c88d160` | 14/08 | 🔴 SEGNALE | 🔴 **SÌ** | `HaGiaOperatoOggi()` → `CicliOggi()`: al riavvio a giornata iniziata **non riarma il lato già giocato** (`gBrokeHigh=gRipristinaLong`). L'input `InpAllowReverse` è opt-in, **questa metà no** | 1 |
| `bc11093` | 14/08 | 🔴 SEGNALE | 🔴 **SÌ** | buco della guardia A4 sul DAX | 1 |
| `8b92214` | 14/08 | 🔴 SEGNALE | 🔴 **SÌ** | guardia A4: timbra la giornata **solo a storico pronto**. Prima, a storico non sincronizzato, la guardia passava **una volta sola, in silenzio** | 2 |
| `7d0da9f` | 03/09 | 🔴 SEGNALE | 🔴 **SÌ** | `InpOneTradePerDay` (default **true**) **ora è applicato davvero**: `PuoArmare_Calc()` blocca il secondo ingresso del giorno | 1 |
| `19312c8` | 03/09 | 🔴 SEGNALE | 🔴 **SÌ** | chiusure **per TICKET** invece che per `_Symbol`: su conto HEDGING cambia **quale posizione esce** | 1 |
| `d884f7e` | 06/09 | 🔴 SEGNALE | 🔴 **SÌ** | Guardian: baseline giornaliera dall'**equità**, non dal saldo → cambia **quando scatta la pausa B1** | 1 |
| `cdb2037` | 07/09 | 🔴 SEGNALE | no — `=0` / `""` | cap C2 per cluster nel Guardian | 2 |
| `a21d0c0` | 08/09 | 🔴 SEGNALE | no — `InpDailyBaseline=0` | modo dichiarato della baseline giornaliera | 2 |
| `1b6a095` | 06/09 | 🔴 SEGNALE | — | checkpoint Guardian v1.12 | 1 |
| `7f80a87` | 17/08 | 🔴 SEGNALE + 🟠 GESTIONE | no — `=0` | distanza del pendente in ATR (**è il prezzo d'ingresso**) e buffer SL in ATR | 2 |
| `3af47ed` | 08/08 | 🟠 GESTIONE | 🔴 **SÌ** | lotto da `OrderCalcProfit` invece del tick value nudo. **Su 225JPY il tick value mente**: il lotto usciva ~0 e finiva **sempre al minimo** | 11 |
| `872dba8` | 08/09 | 🟠 GESTIONE | 🔴 **SÌ** | pavimento del lotto **prima** di `lotPend`: senza, il volume totale arrivava **fino al doppio** del rischio dichiarato. Misurato in campo 20/08: **1,42% su un contratto da 1,0%** | 7 |
| `d4da7d7` | 06/08 | 🟠 GESTIONE | 🔴 **SÌ** | breakeven non più annidato nella parziale (e "solo se migliora lo stop") | 1 |
| `9638318` | 02/09 | 🟠 GESTIONE | 🔴 **SÌ** | `#define ABTG_DEF_RISK 2.0` → **1.0**: il default compilato era il **DOPPIO** del contratto della sedia | 2 |
| `4c424e2` | 15/08 | 🟠 GESTIONE | no — `=0` | slippage stimato spostato su SL/TP | 3 |
| `6ee2ec0` | 11/09 | 🟠 GESTIONE | no — `ALZA` = vecchio | politica del pavimento del lotto (ALZA / SALTA_GAMBA / RISPETTA_TOTALE) | 1 |
| `65de32c` | 11/09 | 🟠 GESTIONE | no | cancello su `6ee2ec0` (errore di compilazione + conto del costo) | 1 |
| `b45dd00` | 11/09 | 🟡 DIAGNOSTICA | no | contatori d'imbuto. **Verificato riga per riga**: ogni `return;` diventa `{ contatore++; return; }`, **nessuna condizione cambia** | 13 |
| `6074126` | 08/08 | 🟡 DIAGNOSTICA | no | export per-trade in `OnTester` | 7 |
| `a5d36d8` | 11/08 | 🟡 DIAGNOSTICA | no | `ExportTrades` in PTE e SuperWave | 4 |
| `2687f13` | 07/08 | 🟡 DIAGNOSTICA | no | metriche prop in `OnTester` (PTE) | 3 |
| `ec518d5` | 10/08 | 🟡 DIAGNOSTICA | no | `ExportTrades` nel MaxMinNotte generico | 1 |
| `ad1f024` | 02/09 | 🟡 DIAGNOSTICA | no | strumentazione del runner ORB, *"nessun cambio di logica"* (verificato) | 1 |

## 3-bis. 🟢 LA BUONA NOTIZIA GROSSA: sul piccolo il cancello del Guardian NON cambia niente, ed è misurato

Le quattro migrazioni del 19/08 (`26a1856`, `5fc0bc3`, `f8ebc32`, `d83c196`)
sono **di classe SEGNALE** — possono fermare un ingresso. Ma mordono **solo se
il Guardian gira su quel conto**: il codice è **fail-open totale** quando le sue
`GlobalVariable` non esistono (commento del commit, e `ABTG_GuardiaIngresso`).

🟢 **E sul piccolo `50503392` il Guardian NON gira** `[MISURATO]`:
`CODA_09_giornale_operativo_20260912_033002.log` r.73 e r.79 (blocco
`C:\Program Files\BCM Markets MT5 Terminal`, giorni 11/09 e 12/09):
> `GUARDIAN: nessuna riga in questo giorno.`

E in `CODA_08` **nessun `.chr` del piccolo porta `ABTG_Guardian`**: 40 sedie, zero Guardian.

👉 **Conseguenza, e va detta perché sgonfia il titolo**: per le **32 sedie del
piccolo** il cui unico difetto di classe SEGNALE è il cancello del Guardian,
**ricompilare non cambierebbe un solo ingresso**. Il loro 🔴 è **formale**.
Quello che morde davvero sul piccolo è un'**altra** lista, ed è §3-ter.

## 3-ter. 🔴 LE 19 SEDIE CHE MORDONO DAVVERO (nessuno deve accendere niente)

### 🔴 SEGNALE attivo — **6 sedie**
| sedia | magic | terminale | commit | cosa cambia |
|---|---|---|---|---|
| `ABTG_DAX_Apertura_EU` D30EUR | `770101` | piccolo `50503392` | `c88d160` + `bc11093` | al riavvio a giornata iniziata **può rifare un lato già giocato** |
| `ABTG_Dow_Apertura_US` U30USD | `770202` | piccolo `50503392` | `8b92214` | guardia A4 che passa **una volta sola, in silenzio** |
| `ABTG_Nasdaq_Apertura_US` NASUSD | `770250` | piccolo `50503392` | `8b92214` | idem |
| `ABTG_MaxMinNotte` XAUUSD | `770402` | piccolo `50503392` | `7d0da9f` | **`InpOneTradePerDay` non è applicato**: il binario in campo può fare più di un ingresso al giorno. E il preset lo chiede: `InpOneTradePerDay=true` (`CODA_08...log` r.1687) |
| `ABTG_ORB_Ottimizzato` U30USD | `770611` | **100k `50504263`** | `19312c8` | chiude **per simbolo**: su HEDGING può gestire la posizione **del vicino** (`770202` è confermato sullo stesso U30USD) |
| `ABTG_Guardian` AUDNZD | `779001` | **100k `50504263`** | `d884f7e` | baseline giornaliera dal **saldo** invece che dall'equità |

### 🟠 GESTIONE attiva — **15 sedie**
| commit | sedie | effetto |
|---|---|---|
| `3af47ed` (08/08) | `771321` `771322` `771332` (PTE) · `770531` (SuperWave) · `770402` (MaxMinNotte oro) · `771531` (**EMA200 Dow**) · `971501` · `970901` · `770511` · `970912` · `970913` — **11, tutte sul piccolo** | lotto calcolato col tick value nudo: **dove il tick value mente, il lotto va al minimo** |
| `872dba8` (08/09) | `770531` `770924` `970901` `770511` `970912` `970913` (piccolo) · `770901` (100k) — **7** | volume totale **fino al doppio** del rischio dichiarato |
| `d4da7d7` (06/08) | `770402` | breakeven perso quando la parziale non passa |
| `9638318` (02/09) | `770101` piccolo · `770101` **100k** | default compilato del rischio al **2,0%** invece dell'1,0% |

⚠️ **`9638318` sul 100k è mitigato, e va detto**: il `.chr` porta
`InpRiskPercent=0.65` **esplicito** (`CODA_08...log` r.3195, blocco `chart01.chr` che inizia a r.3146, profilo
`SQUADRA 100K`), quindi all'attacco normale il 2,0 non si vede. Morde **al
RIPRISTINA**, che è esattamente il caso descritto dal commit stesso.

---

# 4. 🧪 IL CONTRO-ESEMPIO — costruito PRIMA di consegnare, e **ha trovato due falle**

La regola di casa del 10/09 dice: *"devo costruire IO il contro-esempio che lo
farebbe sbagliare, e far vedere che non sbaglia"*. Qui **sbaglia**, e le due
volte in cui sbaglia sono la parte più utile del referto.

**Le ipotesi che smonterebbero il metodo**, e cosa ha detto la prova:

| # | ipotesi che rompe la sonda A | verifica | esito |
|---|---|---|---|
| **1** | *"un input aggiunto e poi TOLTO farebbe leggere un'età falsa"* | ricostruita la storia di presenza/assenza di **tutte e 66** le coppie (file, input) mancanti: per ognuna ho controllato `git show <c>^:file` e `git show <c>:file`. **66 su 66 hanno UN SOLO evento, ed è un ADD.** Zero rimozioni, zero re-inserimenti | ❌ **smentita** |
| **2** | *"il grafico potrebbe non aver salvato un input per un'altra ragione"* | se fosse così, il numero di input mancanti sarebbe **casuale**. Invece per **18 sedie su 51** il mancante è **esattamente e solo** `InpUsaGuardian`, per il Guardian sono **esattamente i 3** aggiunti dopo v1.12, e per il reale sono **0 su 3 sedie operative**. E in **40 casi su 51** la sonda B, indipendente, dà la **stessa risposta** | ❌ **smentita** |
| **3** | *"gli input degli INDICATORI fanno risultare tutto DIVERGE"* | 32 input estranei, **tutti e 32** verificati dentro `ABTG_Look.mq5` / `ABTG_LivelliChiave.mq5`; sul reale, dove gli indicatori non ci sono, il conteggio torna esatto da solo | ✅ **vera, ed è stata disinnescata** |
| **4** | 🔴 *"un commit che NON aggiunge input è invisibile"* | **VERA, e costa.** Due casi reali qui sotto | 🔴 **CONFERMATA** |
| **5** | *"il `.mq5` nella cartella potrebbe non essere quello compilato nell'`.ex5`"* | non verificabile da qui: l'`.ex5` non si legge dal repo | ⚠️ **`[LIMITE DICHIARATO]`** |

## 🔴 4.1 — La sonda A dichiara ALLINEATA una sedia che NON lo è: `770101` sul 100k

Ho preso le **11 sedie che la sonda A chiama allineate** e ho provato a
smentirle con la sonda B. **Una è caduta.**

`ABTG_DAX_Apertura_EU` `770101` su `C:\Program Files\BCM Markets MT5 Terminal -V3`
(**100k `50504263`**):
- **sonda A**: `chr=114` input, `src=82` input, **0 mancanti** → *"allineata"*;
- **sonda B** `[MISURATO]`: campo **2361** righe, repo **2368** → **−7**;
- pin esatto: `git show d83c196:mql5/Experts/ABTG_DAX_Apertura_EU.mq5 | wc -l` =
  **2360** (+1 = 2361 ✅). Il binario è **`d83c196`, 19/08**;
- il commit mancante è **`9638318` (02/09)**, e non aggiunge **nessun input**:
  cambia `#define ABTG_DEF_RISK` da **2.0** a **1.0** — *"il default compilato
  del rischio era il DOPPIO del contratto della sedia"*.

👉 **Un commit che dimezza la taglia, invisibile alla sonda A.** Ed è sul conto
su cui si prova la challenge.

## 🔴 4.2 — La sonda A dichiara DIAGNOSTICA una sedia che perde un fix sul LOTTO: `770901` sul 100k

`ABTG_SupertrendReversal` `225JPY` `770901`, 100k `50504263`:
- **sonda A**: manca **solo** `InpLogImbuto` → commit `b45dd00`, classe
  **DIAGNOSTICA** → verdetto *"allineata nei fatti"*;
- **sonda B**: campo **v1.00, 657** righe · repo **v1.01, 795** → pin `f8ebc32` (19/08);
- fra `f8ebc32` e HEAD ci sono **due** commit, non uno: `b45dd00` **e
  `872dba8`** — *"pavimento del lotto minimo PRIMA di lotPend"*, il fix del
  **LOTTO DOPPIO**, che non aggiunge input.

👉 **Il verdetto "DIAGNOSTICA" della sonda A era sbagliato in difetto**, sulla
sedia che sta su `225JPY` — lo stesso simbolo su cui `3af47ed` dice che *"il
tick value mente"*.

## 🟢 4.3 — E le altre nove reggono

Le altre **10 sedie** dichiarate allineate dalla sonda A sono confermate dalla
sonda B **al conteggio delle righe**, cioè **0 commit mancanti** dal pin a HEAD:
`ABTG_ORB_Ottimizzato` `770611` (piccolo, 1464=1464, v1.04) · i tre
`ABTG_PostNews` `771201/771202/771203` (667=667, v1.10) · `ABTG_TradeExporter`
piccolo e 100k (212=212) · `ABTG_Dow_Apertura_US` `770202` 100k (2148=2148,
v1.01) · `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` `770411` 100k (620=620) ·
`ABTG_DAX_Apertura_EU` `770101` reale (2368=2368) · `ABTG_ORB_Ottimizzato`
`770611` reale (1464=1464) · `ABTG_SlippageLogger` reale (1823=1823).

📌 **E questa è la notizia buona che va detta**: 🟢 **sul conto vero
`10105439` le due sedie operative e il logger girano ESATTAMENTE il repo di
oggi.** L'unico scarto del reale è il `Guardian` `779002`, e i suoi due commit
mancanti (`cdb2037`, `a21d0c0`) sono **no-op di default** — verificato riga per
riga: `mql5/Experts/ABTG_Guardian.mq5` r.147 `InpDailyBaseline = 0`, r.165
`InpMaxClusterRiskPct = 0`, r.166 `InpClusterMappa = ""`.

---

# 5. 🎯 L'INCROCIO: di quali sedie CREDIAMO di sapere il PF e non lo sappiamo

## 5.1 🔴 Il difetto di metodo, e viene prima dei singoli casi

> ## **Su 51 sedie, il PIN che ha prodotto il numero promosso è DICHIARATO per UNA.**

Quella è `ABTG_EMA200` `771531`: `report/PACCHETTO_SCHIERAMENTO_EMA200_2026-09-13.md`
r.77 (*"pin di R112 è `f33f374`"*) e `report/BUONGIORNO_2026-09-13.md` r.152
(*"`26a1856` (19/08) — **552** — il codice che ha prodotto PF 1,52365"*).
**E non coincide col binario in campo, che è `344a11b` (486 righe).**

Per le altre **50** il pin è **`[NON DICHIARATO]`**: nessun documento del
progetto scrive *quale codice* ha prodotto quel PF. `report/CONTRATTI_SEDIE.md`
ha DD, `n`, frequenza, finestra e fonte — **non ha la colonna del codice**.
👉 Per 50 sedie su 51 la domanda *"stesso pin?"* oggi **non è nemmeno
rispondibile**, e questo è il buco da chiudere.

## 5.2 📏 Quello che si può misurare lo stesso, ed è abbastanza

Il numero promosso è stato prodotto da un sorgente **non più nuovo** del referto
che lo porta; il binario in campo ha un **pin esatto** (§4). Se fra i due ci
sono commit sul file dell'EA, **il numero e il binario non sono lo stesso
programma**. `[APPROSSIMATO al giorno]` — la data del referto è quella del suo
primo commit, quindi è un **limite superiore** della data della corsa.

**Su 43 sedie per cui ho potuto agganciare un referto** (le 43 righe di
`report/CONTRATTI_SEDIE.md` con magic riconducibile a una sedia in campo; fuori
restano i due `Guardian`, la `GatedShort` `770250` — contratto in
`CENSIMENTO_CONTRATTI.md` — e le tre utility):

| | quante |
|---|---:|
| binario **più NUOVO** del numero (il campo ha roba che il numero non descrive) | **12** |
| numero **più NUOVO** del binario (il numero descrive codice che il campo non ha) | **17** |
| stesso giorno, **0 commit in mezzo** | **14** |
| 🔴 **con almeno un commit fra il numero e il binario** | **29 su 43** |

### 🔴 I casi in cui l'incrocio fa più male

| sedia | magic | terminale | numero promosso (fonte) | binario in campo | fra i due |
|---|---|---|---|---|---|
| `ABTG_EMA200` U30USD | `771531` | piccolo | **PF OOS 1,52365 · DD 7,8323% · n 517** (`CONTRATTI_SEDIE.md` r.112; pin **`26a1856`**, 552 righe) | **`344a11b`** 04/08, **486 righe** | **3 commit**, fra cui `3af47ed` 🔴 GESTIONE ATTIVA |
| `ABTG_MaxMinNotte` XAUUSD | `770402` | piccolo | DD **10,0%** da R100 (`CONTRATTI_SEDIE.md` r.95) | **`0823951`** 28/07 v1.10 | **5 commit**: `7d0da9f` 🔴 SEGNALE, `3af47ed` 🔴 e `d4da7d7` 🔴 GESTIONE |
| `ABTG_Nasdaq_Apertura_US` (GatedShort) NASUSD | `770250` | piccolo | **DD 4,54% a 0,65% · n 104** (`report/CENSIMENTO_CONTRATTI.md` r.268, contratto del **30/08**) | **`3af47ed`** 08/08 v1.00 (repo v1.02) | **6 commit**, **5 di classe SEGNALE** — fra cui `b5d904a` (29/08) e `39cc34d`/`b8947ba` (12/08), cioè i filtri e i modi d'ingresso su cui il numero è stato misurato |
| `ABTG_ORB_Ottimizzato` U30USD | `770611` | **100k** | DD **9,92%** R15 (`CONTRATTI_SEDIE.md` r.92) | **`3125e34`** 19/08 **v1.02, 823 righe** (repo v1.04, 1464) | **2 commit**, fra cui `19312c8` 🔴 SEGNALE ATTIVA |
| `ABTG_SuperWave_DOW_H1_Ott.` U30USD | `770511` | piccolo | **PF 1,52 · DD 4,0% · n 227** (`REGISTRO_TEST.md` r.526) | **`344a11b`** 04/08 | **6 commit**: `872dba8` 🔴 e `3af47ed` 🔴 GESTIONE, `7f80a87` SEGNALE |
| `ABTG_SupRev_DAX_H4_Ott.` D30EUR | `970912` | piccolo | **PF 1,96 · DD 5,7% · n 86** (`REGISTRO_TEST.md` r.170) | **`344a11b`** 04/08 | **3 commit**: `872dba8` 🔴, `3af47ed` 🔴 |
| `ABTG_SupRev_NAS_H1_Ott.` NASUSD | `970913` | piccolo | **PF 1,57 · DD 1,17% · n 155** (`REGISTRO_TEST.md` r.171) | **`344a11b`** 04/08 | **4 commit**: `872dba8` 🔴, `3af47ed` 🔴 |
| `ABTG_SupertrendReversal_Ott.` XAUUSD | `970901` | piccolo | DD **9,0%** R99, 657 op su 22 anni (`CONTRATTI_SEDIE.md` r.81) | **`344a11b`** 04/08 | **4 commit**: `872dba8` 🔴, `3af47ed` 🔴 |
| `ABTG_DAX_Apertura_EU` D30EUR | `770101` | **100k** | DD **4,3501%** a 0,65% (`CONTRATTI_SEDIE.md` r.90) | **`d83c196`** 19/08 | **1 commit**: `9638318` 🔴 GESTIONE ATTIVA (§4.1) |
| `ABTG_Guardian` | `779001` | **100k** | — (è la protezione) | **`1f4c92b`** 19/08 v1.11 | **4 commit**, fra cui `d884f7e` 🔴 SEGNALE ATTIVA |

🟢 **E i due che passano l'incrocio puliti**: sul reale `10105439`,
`ABTG_DAX_Apertura_EU` `770101` (pin `9638318`, **0 commit mancanti**) e
`ABTG_ORB_Ottimizzato` `770611` (pin `19312c8`, **0 commit mancanti**). ⚠️ Il
loro **numero** resta però più vecchio del binario (R16/R15, 09/08, con 3 e 4
commit in mezzo): **il codice è allineato al repo, il CONTRATTO no.**

---

# 6. 🧭 COSA SIGNIFICA, e cosa NON propongo

🚫 **Non propongo "ricompila tutto".** Porterebbe in campo in un colpo solo un
mese di modifiche mai girate su quei conti, comprese quelle che **cambiano le
taglie** (`3af47ed`, `872dba8`, `9638318`). Sarebbe il gesto più pericoloso
possibile, e resta la stessa raccomandazione di
`report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md`.

**Quello che questo referto aggiunge, e che prima non c'era:**
1. 🆕 **Ogni sedia ha un PIN ESATTO** (commit + data + versione), non
   un'impressione. Sono 51 righe, in §2.
2. 🆕 **Ogni scarto ha una CLASSE letta dal diff**, e una risposta alla domanda
   che conta: *morde al default?*
3. 🆕 **Le 19 sedie che mordono davvero sono elencate per nome** (§3-ter), e
   **32 🔴 formali del piccolo sono stati sgonfiati con una misura** (§3-bis),
   non con un'opinione.
4. 🆕 **Il buco di metodo è quantificato**: il pin del numero promosso è
   dichiarato per **1 sedia su 51**.

## ✍️ Le due cose che chiedo a Claudio (nessuna delle due tocca il campo)

- **Una colonna in più in `report/CONTRATTI_SEDIE.md`: il PIN del codice che ha
  prodotto il numero.** Senza, fra un mese ci ritroviamo qui. Costa una riga per
  sedia e si può riempire da questo referto per le 43 con contratto.
- **Ordine di priorità per il rimettere in pari**, se lo firma: prima le **6
  SEGNALE attive** di §3-ter (e fra queste per prime le due del **100k**, che è
  il conto su cui si prova la challenge), poi le **15 GESTIONE attive**, e le
  32 formali del piccolo **per ultime o mai** — perché lì il divario misurato è
  **zero**.

---

## 📌 DICHIARAZIONE DI ONESTÀ

- **Ponteggio, non sedia.** Questa giornata non avvicina di un metro una sedia
  schierabile il 1° ottobre: **non produce nessun PF nuovo**. Serve perché senza
  di essa i PF che abbiamo **descrivono un programma che non gira**. Va contata
  per quello che è.
- **La sonda A, da sola, sbaglia in difetto**: 2 casi su 11 fra le "allineate" e
  le "diagnostiche" (§4.1, §4.2). Chiunque la riusi **deve** affiancarle la
  sonda B.
- **Non ho letto nessun `.ex5`**: la prova più forte del contenuto del binario
  resta la data di compilazione più il sorgente in cartella. Se qualcuno avesse
  aggiornato un `.mq5` nella cartella **senza ricompilare**, il pin di §2
  sarebbe quello del sorgente, non quello del binario. `[LIMITE DICHIARATO]`
  Un caso già sospetto: `ABTG_Guardian.mq5` sul piccolo, 414 righe, `.ex5`
  compilato **09/08** ma il commit con quel conteggio è del **18/08** — e
  comunque **sul piccolo nessun grafico monta il Guardian**, quindi non è una sedia.
- **Zero saldi, zero equità, zero P/L.** Verificato prima di committare.

_Referto generato in sola lettura il 13/09/2026. Fonti: `CODA_06`/`CODA_08`/`CODA_09`
del `2026-09-12 03:30`, `git log` del repo `lavoro` a HEAD, `report/CONTRATTI_SEDIE.md`,
`backtest_pipeline/REGISTRO_TEST.md`._
