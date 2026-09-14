# 🧾 INVENTARIO FIRMATO CAMPO-vs-REPO — CONTO PICCOLO 50503392

**Buco M43 (riga K3) di `report/PIANO_PROP.md` — pezzo in SOLA LETTURA.**
_Scritto nella notte del 13→14/09/2026._

> ## 🛑 PERIMETRO, dichiarato prima di ogni numero
> **Non è stato toccato NIENTE.** Nessun terminale aperto, nessun EA
> modificato, **nessuna ricompilazione**, nessun `.chr`, nessun preset, nessun
> round lanciato, **zero righe verso il VPS**. Questo referto **legge** file
> già raccolti la notte del 13/09 e li confronta con `git`.
> 🔴 **Il conto reale 10105439 (`C:\BCM_Reale`) non compare e non è stato
> letto in nessun modo**: qui si parla **solo** del piccolo demo **50503392**,
> cartella dati `215D85D767A1C39E22D242C8114BF9F5`, programma
> `C:\Program Files\BCM Markets MT5 Terminal` (**senza** `-V3`).
> 🔴 **Nessun saldo, equità o P/L è scritto qui.** Il repo è pubblico.
> 👤 **La parte esecutiva — F7, ricarico, una sedia per volta — resta firma di
> Claudio**, perché ricompilare **cambia i volumi** delle sedie vive.

---

# 0. 🎯 LA DOMANDA DI M43, in una riga

> *"Per ogni sedia viva sul piccolo: **quale `.mq5`/`.ex5` gira davvero**,
> **quale dovrebbe girare** (HEAD di `lavoro`), e **cosa cambia** fra i due."*

E la sotto-domanda che M43 chiamava *"la più economica"*:

> *"Sul piccolo 50503392 il Guardian è davvero attaccato a un grafico?"*
> 🟢 **RISPOSTA MISURATA, ed è NO. Vedi §4.** Non serviva nessuna corsa.

---

# 1. 🔬 LE FONTI, e cosa significa esattamente ogni colonna

| fonte | cosa dà | dove |
|---|---|---|
| **CODA_06** del **13/09 03:30:33** | per ogni `.mq5` nella cartella del terminale: **versione, righe, GUARD, data dell'`.ex5` accanto** | `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260913_033003.log` — blocco del piccolo: **righe 57–153** (intestazione r.60, EA dalle r.61 alla r.151) |
| **CODA_01** del **13/09 03:30:05** | **quali sedie sono attaccate** nel profilo attivo (`ORO`) | `.../CODA_01_sedie_attaccate_20260913_033003.log` **righe 11–54** (*"PROFILO ATTIVO: 40 sedie"*, r.14) |
| **CODA_09** del **13/09 03:31:49** | il **giornale** del terminale, 12 e 13/09 | `.../CODA_09_giornale_operativo_20260913_033003.log` **righe 25–39** |
| **lo script che genera CODA_06** | la definizione delle colonne | `backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` |
| **git** su `lavoro` | versione/righe/commit a HEAD e la storia di ogni file | repo, HEAD del **14/09** |

## 1.1 🔴 `GUARD` NON vuol dire *"include `ABTG_PausaGuardian.mqh`"*

Letto nel generatore, **riga 89**:

```powershell
if($t -and ($t -match "GuardiaIngresso" -or $t -match "InpUsaGuardian")){ $guard = "SI" }
```

👉 `GUARD = SI` significa **«nel testo del sorgente compare la stringa
`GuardiaIngresso` oppure `InpUsaGuardian`»** — cioè l'EA **nomina** la guardia
(in pratica: ha l'`input` e/o la chiama). `GUARD = no` è più forte di *"manca
l'`#include`"*: vuol dire che **la parola non c'è affatto**, quindi né
l'`input`, né la chiamata. *(La formulazione «include il .mqh» che girava è
un'approssimazione: l'ho verificata sul codice e la correggo qui.)*

## 1.2 🧮 IL `+1`: la colonna RIGHE del log **non** è `wc -l`

Generatore **riga 87**: `$righe = @($t -split "`r?`n").Count` → su un file che
finisce con `\n` questo dà **`wc -l` + 1**.

**Verificato su tre file allineati** (stessa versione dichiarata in campo e a
HEAD, quindi il confronto è pulito):

| file | RIGHE nel log | `wc -l` a HEAD | `split` a HEAD |
|---|---:|---:|---:|
| `ABTG_ORB_Ottimizzato.mq5` v1.04 | **1464** | 1463 | **1464** ✅ |
| `ABTG_PostNews.mq5` v1.10 | **667** | 666 | **667** ✅ |
| `ABTG_Guardian.mq5` | 414 *(campo)* | 899 *(HEAD)* | **900** |

👉 **Tutti gli scarti di questo referto sono già corretti del `+1`.**
🟢 Conferma indipendente: la stessa correzione è in
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md` §0 punto 3.

## 1.3 🧷 Come ho DATATO il binario in campo (e perché non è un'inferenza)

Per ogni sorgente in campo ho cercato, **su tutta la storia di git**, il commit
che produce **esattamente** quella coppia *(versione dichiarata, righe)*.
**Risultato: 24 file su 24 hanno trovato UN SOLO commit compatibile** (`n=1`),
mai due. Le date qui sotto sono quindi **lette**, non dedotte.

🟢 **E c'è una conferma incrociata che non ho cercato: la lista dei commit che
mi è uscita coincide, file per file, con quella di
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md` §2** (`0823951`, `3af47ed`,
`344a11b`, `24f4b7a`, `a766659`, `cb7dc20`, `9b1c611`, `95bc4ec`, `7246558`,
`6074126`, `19312c8`, `61dc18c`, `76c79de`), che partiva da una **foto diversa**
(06/09) e da una ricerca fatta da un'altra sessione. **Due strade indipendenti,
stesso risultato.** 👉 E dice anche una cosa operativa: **fra il 06/09 e il
13/09 sul piccolo non si è mosso un byte.**

## 1.4 ⚠️ IL LIMITE, dichiarato prima della tabella

**MT5 esegue l'`.ex5`, e l'`.ex5` non si può leggere.** Tutto quello che segue
misura il **`.mq5` che sta nella cartella** + la **data di scrittura
dell'`.ex5` accanto**. Se qualcuno avesse compilato e *poi* sostituito il
sorgente, i due non corrisponderebbero: per questo la data dell'`.ex5` è in
tabella. **Su 24 file il controllo scatta una volta sola — ed è il Guardian
(§4.2).** Sugli altri 23 l'`.ex5` è **uguale o più recente** del commit
combaciante, quindi la corrispondenza regge.

---

# 2. 🪑 LA TABELLA — 40 sedie vive sul piccolo 50503392

Ordine: quello del profilo `ORO` (CODA_01 rr.15–54).
`righe campo` = valore del log **già normalizzato** (`−1`, §1.2).
`Δ` = `righe HEAD (wc -l)` − `righe campo` (positivo = **HEAD ha più codice**).
`Guard HEAD` = esiste l'`input InpUsaGuardian` nel sorgente a HEAD.

| # | sedia (EA · magic · sym · TF) | 🏭 **CAMPO**: ver · righe · GUARD · `.ex5` del | 📚 **HEAD `lavoro`**: ver · righe · ultimo commit | **Δ righe** | **commit in campo** | **Guard HEAD** |
|---:|---|---|---|---:|---|:---:|
| 1 | `ABTG_TradeExporter` · *(nessun magic, utility)* · NZDCAD H1 | 1.00 · **211** · **no** · 06/08 19:35 | 1.00 · **211** · `76c79de` 03/08 | **0** 🟢 | `76c79de` 03/08 | — *(strumento)* |
| 2 | `ABTG_PTE` · **771321** · U30USD H1 | 1.00 · **525** · **no** · 06/08 19:34 | 1.01 · **776** · `b45dd00` 11/09 | **+251** 🔴 | `344a11b` 04/08 | ✅ |
| 3 | `ABTG_BreakingBand` · **772161** · GBPUSD H1 | 1.02 · **1577** · **no** · 13/08 07:29 | 1.05 · **1857** · `2a1fa24` 29/08 | **+280** 🔴 | `24f4b7a` 12/08 | ✅ |
| 4 | `ABTG_BreakingBand` · **772162** · EURUSD H1 | idem | idem | **+280** 🔴 | `24f4b7a` 12/08 | ✅ |
| 5 | `ABTG_BreakingBand` · **772163** · AUDUSD H1 | idem | idem | **+280** 🔴 | `24f4b7a` 12/08 | ✅ |
| 6 | `ABTG_GapFill` · **772231** · GBPUSD H1 | 1.00 · **790** · **no** · 13/08 14:30 | 1.00 · **805** · `26a1856` 19/08 | **+15** 🟠 | `a766659` 13/08 | ✅ |
| 7 | `ABTG_GapFill` · **772232** · EURUSD H1 | idem | idem | **+15** 🟠 | `a766659` 13/08 | ✅ |
| 8 | `ABTG_GapFill` · **772233** · AUDUSD H1 | idem | idem | **+15** 🟠 | `a766659` 13/08 | ✅ |
| 9 | `ABTG_GapFill` · **772234** · U30USD H1 | idem | idem | **+15** 🟠 | `a766659` 13/08 | ✅ |
| 10 | `ABTG_GapFill` · **772235** · 225JPY H1 | idem | idem | **+15** 🟠 | `a766659` 13/08 | ✅ |
| 11 | `ABTG_PunteLarry` · **772341** · U30USD H1 | 1.00 · **1199** · **no** · 13/08 18:17 | 1.00 · **1214** · `5fc0bc3` 19/08 | **+15** 🟠 | `cb7dc20` 13/08 | ✅ |
| 12 | `ABTG_PunteLarry` · **772342** · EURAUD H1 | idem | idem | **+15** 🟠 | `cb7dc20` 13/08 | ✅ |
| 13 | `ABTG_PunteLarry` · **772343** · XAUUSD H1 | idem | idem | **+15** 🟠 | `cb7dc20` 13/08 | ✅ |
| 14 | `ABTG_PunteLarry` · **772344** · GBPJPY H1 | idem | idem | **+15** 🟠 | `cb7dc20` 13/08 | ✅ |
| 15 | `ABTG_PunteLarry` · **772345** · GBPUSD H1 | idem | idem | **+15** 🟠 | `cb7dc20` 13/08 | ✅ |
| 16 | `ABTG_PunteLarry` · **772346** · EURCAD H1 | idem | idem | **+15** 🟠 | `cb7dc20` 13/08 | ✅ |
| 17 | `ABTG_CostToCost` · **772361** · EURJPY H4 | 1.00 · **1078** · **no** · 13/08 19:46 | 1.00 · **1210** · `b45dd00` 11/09 | **+132** 🔴 | `9b1c611` 13/08 | ✅ |
| 18 | `ABTG_CostToCost` · **772362** · GBPCAD H4 | idem | idem | **+132** 🔴 | `9b1c611` 13/08 | ✅ |
| 19 | `ABTG_EasyTrend` · **772421** · CHFJPY H1 | 1.00 · **1605** · **no** · 14/08 08:49 | 1.00 · **1620** · `5fc0bc3` 19/08 | **+15** 🟠 | `95bc4ec` 13/08 | ✅ |
| 20 | `ABTG_EasyTrend` · **772422** · GBPUSD H1 | idem | idem | **+15** 🟠 | `95bc4ec` 13/08 | ✅ |
| 21 | `ABTG_GapContinuation` · **774101** *(magic non stampato da CODA_01; letto nel `.chr`, vedi nota)* · 225JPY M1 | 1.50 · **1551** · **no** · 16/08 20:44 | 1.50 · **1654** · `b45dd00` 11/09 | **+103** 🔴 | `7246558` 16/08 | ✅ |
| 22 | `ABTG_PTE` · **771332** · GBPUSD H1 | 1.00 · **525** · **no** · 06/08 19:34 | 1.01 · **776** · `b45dd00` 11/09 | **+251** 🔴 | `344a11b` 04/08 | ✅ |
| 23 | `ABTG_PTE` · **771322** · GBPUSD H1 | idem | idem | **+251** 🔴 | `344a11b` 04/08 | ✅ |
| 24 | `ABTG_SuperWave` · **770531** · U30USD H4 | 1.00 · **563** · **no** · 06/08 19:33 | 1.01 · **766** · `b45dd00` 11/09 | **+203** 🔴 | `344a11b` 04/08 | ✅ |
| 25 | `ABTG_MaxMinNotte` · **770402** · XAUUSD M15 | 1.10 · **539** · **no** · 06/08 19:33 | 1.11 · **918** · `7d0da9f` 03/09 | **+379** 🔴 | `0823951` **28/07** *(il più vecchio della flotta)* | ✅ |
| 26 | `ABTG_DAX_Apertura_EU` · **770101** · D30EUR M5 | 1.00 · **2132** · **no** · 08/08 14:23 | 1.01 · **2367** · `9638318` 02/09 | **+235** 🔴 | `3af47ed` 08/08 | ✅ |
| 27 | `ABTG_Dow_Apertura_US` · **770202** · U30USD M5 | 1.00 · **2064** · **no** · 08/08 14:26 | 1.01 · **2147** · `d83c196` 19/08 | **+83** 🔴 | `3af47ed` 08/08 | ✅ |
| 28 | `ABTG_MaxMinNotte_DAX_Short_Ott` · **770411** · D30EUR M15 | 1.10 · **604** · **no** · 18/08 14:03 | 1.10 · **619** · `5fc0bc3` 19/08 | **+15** 🟠 | `6074126` 08/08 | ✅ |
| 29 | 🔴 `ABTG_EMA200` · **771531** · U30USD H1 | 1.00 · **486** · **no** · 06/08 19:33 | 1.00 · **690** · `b45dd00` 11/09 | **+204** 🔴 | `344a11b` 04/08 | ✅ |
| 30 | `ABTG_EMA200_Ottimizzato` · **971501** · XAUUSD H4 | 1.00 · **486** · **no** · 06/08 19:32 | 1.00 · **748** · `b45dd00` 11/09 | **+262** 🔴 | `344a11b` 04/08 | ✅ |
| 31 | `ABTG_SupertrendReversal` · **770924** · 225JPY H2 | 1.00 · **604** · **no** · 08/08 14:16 | 1.01 · **794** · `b45dd00` 11/09 | **+190** 🔴 | `3af47ed` 08/08 | ✅ |
| 32 | `ABTG_SupertrendReversal_Ott` · **970901** · XAUUSD H4 | 1.00 · **576** · **no** · 06/08 19:32 | 1.01 · **743** · `b45dd00` 11/09 | **+167** 🔴 | `344a11b` 04/08 | ✅ |
| 33 | `ABTG_SuperWave_DOW_H1_Ott` · **770511** · U30USD H1 | 1.00 · **563** · **no** · 06/08 19:33 | 1.01 · **774** · `b45dd00` 11/09 | **+211** 🔴 | `344a11b` 04/08 | ✅ |
| 34 | `ABTG_SupRev_DAX_H4_Ott` · **970912** · D30EUR H4 | 1.00 · **577** · **no** · 06/08 19:33 | 1.01 · **615** · `872dba8` 08/09 | **+38** 🔴 | `344a11b` 04/08 | ✅ |
| 35 | `ABTG_SupRev_NAS_H1_Ott` · **970913** · NASUSD H1 | 1.00 · **577** · **no** · 06/08 19:33 | 1.01 · **652** · `872dba8` 08/09 | **+75** 🔴 | `344a11b` 04/08 | ✅ |
| 36 | 🟢 `ABTG_ORB_Ottimizzato` · **770611** · U30USD M5 | 1.04 · **1463** · **SI** · 03/09 16:14 | 1.04 · **1463** · `19312c8` 03/09 | **0** 🟢 | `19312c8` 03/09 | ✅ |
| 37 | `ABTG_Nasdaq_Apertura_US` · **770250** · NASUSD M15 | 1.00 · **2032** · **no** · 08/08 14:25 | 1.02 · **2566** · `b5d904a` 29/08 | **+534** 🔴 *(il salto più grosso)* | `3af47ed` 08/08 | ✅ |
| 38 | 🟢 `ABTG_PostNews` · **771203** · USDJPY M5 | 1.10 · **666** · **SI** · 04/09 13:24 | 1.10 · **666** · `61dc18c` 03/09 | **0** 🟢 | `61dc18c` 03/09 | ✅ |
| 39 | 🟢 `ABTG_PostNews` · **771201** · EURJPY M5 | idem | idem | **0** 🟢 | `61dc18c` 03/09 | ✅ |
| 40 | 🟢 `ABTG_PostNews` · **771202** · EURUSD M5 | idem | idem | **0** 🟢 | `61dc18c` 03/09 | ✅ |

> 📌 **Nota sulla riga 21.** CODA_01 stampa `magic -` per `GapContinuation`
> perché il suo parser cerca `InpMagic`/`InpRiskPercent` per nome e quell'EA usa
> `InpMagicNumber`/`InpBuyRiskPercent`. Il magic **774101** è letto nel `.chr`
> da `CODA_08` ed è riportato in
> `report/CENSIMENTO_CAMPO_VS_MISURATO_2026-09-13.md` r.140. Non è un'inferenza
> mia, è una citazione — e non cambia nessuna delle colonne del codice.

---

# 3. 🧭 «COSA CAMBIA FRA I DUE» — i commit che al campo mancano, per famiglia

Non conta il numero di righe: conta **cosa** c'è dentro. Elenco dei commit
compresi fra il binario in campo e HEAD, raggruppati.

| famiglia (sedie) | commit mancanti | 💰 tocca i lotti/gli ordini? |
|---|---|:---:|
| `PTE` ×3 | `2687f13` 07/08 · **`3af47ed` 08/08 (sizing)** · `a5d36d8` 11/08 · `4c424e2` 15/08 · `26a1856` 19/08 (filo Guardian) · **`b45dd00` 11/09 (WIP)** | 🔴 **sì** (`3af47ed`) |
| `BreakingBand` ×3 | `26a1856` 19/08 · `e528527` 20/08 (v1.03 `InpMinRR` opt-in) · `40db664`+`2a1fa24` 29/08 (v1.04/1.05 modi nuovi, opt-in) | 🟢 no — tutti **opt-in a default storico** |
| `GapFill` ×5 | `26a1856` 19/08 | 🟢 no — solo il **filo** del Guardian |
| `PunteLarry` ×6 | `5fc0bc3` 19/08 | 🟢 no — solo il filo |
| `CostToCost` ×2 | `26a1856` 19/08 · **`b45dd00` 11/09 (WIP)** | 🟢 no |
| `EasyTrend` ×2 | `5fc0bc3` 19/08 | 🟢 no |
| `GapContinuation` ×1 | `26a1856` 19/08 · **`b45dd00` 11/09 (WIP)** | 🟢 no |
| `SuperWave` ×1 · `SuperWave_DOW_H1_Ott` ×1 | **`3af47ed` 08/08** · `a5d36d8`/`6074126` · `7f80a87` 17/08 (opt-in) · `f8ebc32` 19/08 · **`872dba8` 08/09 (pavimento del lotto PRIMA di `lotPend`)** · **`b45dd00` (WIP)** | 🔴 **sì** (`872dba8`, `3af47ed`) |
| `SupertrendReversal` ×1 · `..._Ott` ×1 · `SupRev_DAX_H4` ×1 · `SupRev_NAS_H1` ×1 | `3af47ed`/`6074126` · `f8ebc32` 19/08 · **`872dba8` 08/09** · *(i primi due anche `b45dd00`)* | 🔴 **sì** (`872dba8`) |
| `MaxMinNotte` **770402** ×1 | **`d4da7d7` 06/08 (breakeven staccato dal parziale)** · **`3af47ed` 08/08** · `ec518d5` 10/08 · `5fc0bc3` 19/08 · **`7d0da9f` 03/09 (`InpOneTradePerDay` letto davvero)** | 🔴 **sì, tre volte** |
| `DAX_Apertura_EU` **770101** ×1 | `6074126` 08/08 · `c88d160` 14/08 (opt-in) · **`bc11093` 14/08 (guardia A4 `storicoOk`)** · `d83c196` 19/08 · `9638318` 02/09 (`DEF_RISK` 2.0→1.0) | 🔴 **sì** (doppio armamento) |
| `Dow_Apertura_US` **770202** ×1 | `6074126` · **`8b92214` 14/08 (guardia A4)** · `d83c196` 19/08 | 🔴 **sì** |
| `Nasdaq_Apertura_US` **770250** ×1 | `6074126` · `b8947ba`/`39cc34d` 12/08 (opt-in) · **`8b92214` 14/08 (guardia A4)** · `d83c196` 19/08 · **`b5d904a` 29/08 (*"WIP FASE 2 DRIVE … build agente"*)** | 🔴 **sì** |
| `MaxMinNotte_DAX_Short_Ott` ×1 | `5fc0bc3` 19/08 | 🟢 no |
| `EMA200` ×1 · `EMA200_Ott` ×1 | **`3af47ed` 08/08** · `6074126` · `26a1856` 19/08 · *(solo l'Ott.: `6ee2ec0`+`65de32c` 11/09)* · **`b45dd00` 11/09 (WIP)** | 🔴 **sì** (`3af47ed`) |
| `ORB_Ottimizzato` · `PostNews` ×3 · `TradeExporter` | **nessuno** | 🟢 **allineate** |

🟢 **Il declassamento che va detto**, perché evita un allarme sbagliato: il
fix di sizing `3af47ed` è stato **misurato su 225JPY**, e **nessuna** delle
sedie a cui manca gira su un simbolo JPY (fonte:
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md` §0). Resta 🟠
`[NON MISURATO]`, non 🔴.

---

# 4. 🛡️ IL GUARDIAN SUL PICCOLO — due fatti, tutti e due misurati

## 4.1 🔴 Non è attaccato a nessun grafico. **Ecco perché il giornale tace.**

CODA_01 elenca **40 sedie** nel profilo attivo `ORO` (rr.15–54): **`ABTG_Guardian`
non c'è.** Sul 100k compare (r.76, `AUDNZD H1`, magic 779001) e sul reale pure
(r.101, `EURGBP H1`, 779002): **sul piccolo no.**

E il giornale lo conferma da un'altra strada — CODA_09 rr.29–39, conto
`C:\Program Files\BCM Markets MT5 Terminal`:

```
--- GIORNO 20260912   (11.8 KB ...)   righe totali: 48
    GUARDIAN: nessuna riga in questo giorno.
--- GIORNO 20260913   (1.7 KB ...)    righe totali: 7
    GUARDIAN: nessuna riga in questo giorno.
```

**Log NON vuoti (48 e 7 righe) e zero battiti.** Sullo stesso file, sul conto
reale, il battito c'è e si legge (r.137). 👉 **Il silenzio è una misura, non un
buco di log.**

🟢 **E non è un guasto: è una DECISIONE.** `report/CENSIMENTO_CONTRATTI_v2.md`
§4: *"decisione di Claudio del 06/09 — **NIENTE Guardian sul piccolo**, perché
il DD della flotta si deve vedere **NON FRENATO**"*. 👉 **La sotto-domanda di
M43 è chiusa: la risposta è "no, ed è voluto".**

## 4.2 🕳️ Il binario del Guardian è **più vecchio del sorgente che gli sta accanto**

| | ver | righe | `.ex5` | commit |
|---|---|---:|---|---|
| **campo (piccolo)** | **1.10** | **413** *(414 nel log)* | **09/08 19:23** | `a53820e` **18/08** |
| **HEAD `lavoro`** | **1.14** | **899** | — | `a21d0c0` 08/09 |

🔴 **L'`.ex5` è di NOVE GIORNI PRIMA del `.mq5` che gli sta accanto.** Al 09/08
il Guardian nel repo aveva **208 righe** `wc -l` (`6b9b8c3`, v1.00): **i cap firmati il
18/08 in quel binario non esistono**. 👉 **Che cosa contenga davvero quel
binario resta `[NON MISURATO]`** — si legge il sorgente, non l'eseguibile.
**Ininfluente oggi** (non è attaccato), **ma diventa una trappola il giorno in
cui qualcuno lo trascinasse su un grafico senza F7.**

✅ **Confermo il numero che mi era stato dato** (v1.10 / 414 / 09-08 in campo
contro 899 a HEAD): l'ho riverificato da fonte, e l'unica precisazione è il
`+1` (413 contro 899 sono i numeri confrontabili, +486 di scarto).
⚠️ Riproduce `report/DISALLINEAMENTO_CAMPO_v2_2026-09-12.md` rr.320–329: **su
70 sorgenti ABTG dei quattro terminali BCM, questo è l'UNICO caso.**

## 4.3 🔓 Le **quattro** sedie con `GUARD = SI` non sono protette lo stesso

`ORB_Ottimizzato` **770611** e `PostNews` ×3 hanno la guardia nel sorgente in
campo. **Ma la guardia è fail-open per costruzione**:
`mql5/Include/ABTG_PausaGuardian.mqh` r.765 —
`if(!ABTG_CanaleEsiste()) return(true); // nessun guardiano qui: fail-open`.
👉 **Senza Guardian sul terminale, quelle quattro chiamate dicono sempre "passa".**

---

# 5. 📊 SINTESI — i numeri, e i tre modi di sbagliarli

| misura | valore |
|---|---:|
| sedie vive sul piccolo 50503392 | **40** (CODA_01 r.14) |
| file `.mq5` distinti dietro quelle sedie | **23** (+ il Guardian, non attaccato) |
| 🟢 **allineate a HEAD** (Δ = 0) | **5** — `ORB_Ott` 770611 · `PostNews` ×3 · `TradeExporter` *(utility, senza magic)* |
| 🔴 **non allineate** | **35** |
| di cui 🟠 *"vecchie ma il comportamento sarebbe identico"* (mancano solo filo Guardian + opt-in a default storico) | **20** — `GapFill` ×5, `PunteLarry` ×6, `BreakingBand` ×3, `EasyTrend` ×2, `CostToCost` ×2 *(+WIP)*, `GapContinuation` *(+WIP)*, `MaxMinNotte_DAX_Short_Ott` |
| di cui 🔴 **manca una riparazione che tocca i lotti/gli ordini** | **15** |
| **sedie il cui sorgente in campo non nomina nemmeno la guardia** (`GUARD = no`) | **36 su 40** (90%) |
| sedie con `GUARD = SI` ma **guardia fail-open** (nessun Guardian sul terminale) | **4** |
| 🔴 **sedie per cui «quale dovrebbe girare» NON è HEAD** (HEAD porta WIP dichiarato) | **13** — §5.1 |

🟢 **I conteggi 5 / 20 / 15 coincidono con
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md` §1**, che li aveva ottenuti
da una foto del 06/09. **Non li ho copiati: ci sono arrivato e poi li ho
trovati uguali.**

## 5.1 🚨 LA COSA NUOVA, ed è quella che cambia il gesto di Claudio

> **Per 13 sedie su 40, la risposta a *«quale codice DOVREBBE girare»* NON è
> «HEAD».** Perché HEAD, per quei file, contiene lavoro **dichiarato non
> verificato dall'autore stesso del commit**.

`b45dd00` (11/09) — messaggio **testuale**, ed è la riga più importante:

> *"questi file NON sono verificati, NON sono passati dal cancello, e gli
> agenti che li stanno scrivendo NON hanno ancora consegnato. **NESSUNO DI
> QUESTI EA VA COMPILATO O CARICATO** finche' non c'e' un PASS."*
> — `~2.000 righe aggiunte` (l'*imbuto di mortalità*, solo log).

Le sedie colpite: `PTE` **771321/771332/771322** · `CostToCost`
**772361/772362** · `GapContinuation` **774101** · `SuperWave` **770531** ·
`EMA200` **771531** · `EMA200_Ott` **971501** · `SupertrendReversal` **770924**
· `SupertrendReversal_Ott` **970901** · `SuperWave_DOW_H1_Ott` **770511**
= **12**. Più `Nasdaq_Apertura_US` **770250**, il cui ultimo commit è
`b5d904a` *"WIP FASE 2 DRIVE: modifica in corso … (build agente)"* = **13**.

🔴 **Conseguenza pratica, e vale come avviso sul gesto:** *"apro MetaEditor e
faccio F7 su tutto"* **metterebbe in campo ~2.000 righe mai passate dal
cancello**, su 13 sedie vive. 👉 **Per quelle 13 il bersaglio della
ricompilazione è il commit `pre-WIP`, non HEAD** — cioè `26a1856`/`872dba8`/
`5fc0bc3` a seconda della famiglia, **oppure** HEAD ma **dopo** un PASS del
cancello sull'imbuto.
*(Il fatto era noto per **una** sedia — `report/BUONGIORNO_2026-09-13.md`
rr.202–205 su `EMA200`. **Qui è contato su tutto il piccolo: 13.**)*

## 5.2 🧪 I CONTRO-ESEMPI che ho costruito per farmi sbagliare

| ipotesi che avrebbe demolito questo referto | come l'ho provata | esito |
|---|---|---|
| *"il `+1` te lo sei inventato per far tornare gli allineati"* | se fosse falso, **i tre file con la STESSA versione in campo e a HEAD avrebbero uno scarto di 1**, cioè non esisterebbero sedie allineate. Verificato sul generatore (r.87) **e** contando i byte: `ORB` 1463/1464, `PostNews` 666/667, `Guardian` 899/900, tutti con `\n` finale | ✅ **il `+1` è nello strumento** |
| *"hai datato il campo confrontandolo col repo di OGGI"* | no: ricerca su **tutta la storia di git** della coppia (versione, righe). **24 file su 24 → un solo commit**. Se il campo fosse "il repo di oggi meno qualcosa", le coppie non sarebbero uniche | ✅ **datati, non dedotti** |
| *"`GUARD = no` vuol dire solo che manca l'`#include`"* | letto il generatore r.89: cerca **`GuardiaIngresso`** *oppure* **`InpUsaGuardian`**. `no` = **nessuna delle due stringhe**, quindi né input né chiamata | ✅ **è più forte, non più debole** |
| *"le 4 sedie con `GUARD = SI` sono protette"* | letto `ABTG_PausaGuardian.mqh` r.765: **fail-open** se il canale non esiste. E sul piccolo il Guardian non gira (CODA_09) | ❌ **non protette** |
| *"allineato a HEAD = pronto da compilare"* | letto il **messaggio** dei commit di HEAD, non solo il numero di righe: 13 sedie hanno HEAD = commit **"NON COMPILARE"** | ❌ **smentita — ed è §5.1** |
| *"la foto del 13/09 dirà cose diverse da quella del 06/09"* | confrontati i commit trovati con `RIMETTERE_IL_CAMPO_IN_PARI` (foto 06/09): **identici, file per file** | ✅ **campo fermo da una settimana** |

---

# 6. ✅ COSA È FATTO QUI · ⏳ COSA RESTA

## 🟢 FATTO (sola lettura, zero gesti sul campo)
1. **Inventario sedia per sedia**, 40 su 40, con *versione in campo · righe ·
   GUARD · data dell'`.ex5` · commit in campo · HEAD · Δ · commit mancanti*.
2. **Chiusa la sotto-domanda economica di M43**: sul piccolo il Guardian **non
   è attaccato**, ed è una **decisione del 06/09**, non un guasto.
3. **Verificato** (non ripetuto a memoria) il caso Guardian: **v1.10 / 413
   righe / `.ex5` del 09/08** contro **v1.14 / 899 a HEAD**, con l'anomalia
   `.ex5` più vecchio del `.mq5`.
4. 🆕 **Contate le 13 sedie per cui HEAD NON è il bersaglio** della
   ricompilazione.

## ⏳ RESTA — e la parte esecutiva è 👤 **di Claudio**
1. 👤 **Ricompilare**: nessun F7 è stato fatto e nessuno va fatto da un agente.
   **Ricompilare cambia i volumi** delle sedie vive.
2. 🔴 **Prima della ricompilazione servono DUE decisioni, non una**:
   **(a)** l'**ordine** (il referto del 12/09 propone *Guardian per primo, poi
   una sedia per volta col rapporto dei lotti prima/dopo*); **(b)** il
   **bersaglio** per le 13 sedie di §5.1 — commit pre-WIP **oppure** HEAD dopo
   un PASS del cancello sull'imbuto di mortalità.
3. 🤖 **Lavoro da agente ancora aperto**: far passare dal cancello le ~2.000
   righe di `b45dd00` (+ `b5d904a` sul Nasdaq), così HEAD torna a essere un
   bersaglio legittimo. **Finché non succede, HEAD non è "quello che dovrebbe
   girare" per 13 sedie.**
4. 🔴 `[NON MISURATO]` **e lo resta**: il **contenuto dei binari `.ex5`**. Si
   legge il sorgente accanto e la data, non l'eseguibile. Per il Guardian del
   piccolo quella data **contraddice** il sorgente (§4.2).
5. 🔓 **Fuori perimetro qui**: 100k **50504263** e reale **10105439**. Il log
   CODA_06 li contiene (blocchi rr.251–301 e rr.346–396), ma M43 chiede il
   **piccolo** e il reale non si tocca senza firma dedicata.

---

_Fonti di questo referto, tutte in repo:
`backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260913_033003.log`
(rr.57–153) · `.../CODA_01_sedie_attaccate_20260913_033003.log` (rr.11–54) ·
`.../CODA_09_giornale_operativo_20260913_033003.log` (rr.25–39) ·
`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` (rr.87, 89) ·
`mql5/Include/ABTG_PausaGuardian.mqh` (r.765) · `git log`/`git show` su
`lavoro` · e i tre referti gemelli citati per confronto:
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md`,
`report/DISALLINEAMENTO_CAMPO_v2_2026-09-12.md`,
`report/CENSIMENTO_CAMPO_VS_MISURATO_2026-09-13.md`._
