# 📜 I CONTRATTI DELLE NOVE SEDIE FTMO — che cosa il backtest ha PROMESSO, sedia per sedia

**20/09/2026** · challenge FTMO **lunedì 21/09** · branch `lavoro`
🛑 **SOLA LETTURA**: nessun EA, nessun preset, nessun parametro toccato. Niente sul conto
reale **10105439**. Nessuna taglia e nessun rischio proposti: restano firma di Claudio.

> ## 🎯 PERCHÉ ESISTE, e perché OGGI e non domani
> Il criterio di uscita firmato il **18/08** (`report/FIRME_2026-08-18.md`) dice:
> *«DD forward > DD **promesso** dal backtest della cella promossa → revisione IMMEDIATA»*.
> 🔴 Fino a stamattina quel **DD promesso non era scritto da nessuna parte per queste nove
> sedie insieme**. Senza, lunedì il criterio che abbiamo firmato **non è applicabile**: non
> esiste il numero contro cui confrontare.
>
> 👉 **Adesso c'è.** Sei sedie hanno un contratto **misurato**, tre ce l'hanno
> **`[NON MISURATO]` e dichiarato tale**. Ogni numero porta **file + riga**, e i numeri che
> decidono li ho **riverificati io al sorgente**, non ricopiati dai referti.

---

# 0️⃣ LE CINQUE RIGHE CHE CONTANO

1. 🏁 **Il conflitto di DD sulla `771531` è ATTRIBUITO e CHIUSO** (azione **A3**, classe **226**):
   i tre numeri — **6,48 · 7,21 · 7,83** — sono **la stessa cella**, lo **stesso simbolo**, lo
   **stesso rischio (1,00%)**. Differiscono per **modello di barre**, **deposito** e **finestra**.
   👉 **Il contratto è `7,8323%` @1,00%**, e l'ho verificato campo per campo contro il preset
   che vola: **39 `Inp*` su 43 identici**, i 4 diversi sono magic, rischio e due ore **inerti**.
2. 🔴 **La `771531` IS in posizioni NON è ricontabile dal repo.** Il per-trade non c'è
   (verificato su **tutti e 130** i file per-trade in repo). Il **132** che gira nei referti è
   **misurato fuori repo** e non riverificabile qui. 🧪 **E la scorciatoia che avrebbe potuto
   salvarci NON funziona su questa sedia — l'ho provata e si rompe** (§3.2).
3. 🟢 **Due buchi chiusi stamattina, contando io**: la **`770411` ha 14 POSIZIONI** (non
   «21 → `[NON MISURATO]`»), e il suo **DD di contratto è `1,9213%`, non `1,27%`** — il 1,27 è
   un'aggregazione per giornata, non l'Equity DD del tester (§4).
4. 🔴 **La `770511` ha un contratto CONTESO, e non per colpa dei parametri**: la stessa cella,
   stesso deposito, **43 input identici su 43**, misurata due volte dà **n 143 / DD 3,9082%** e
   **n 131 / DD 4,1675%**. Il delta è **fuori dal `.set`**. Finché non è isolato, il suo DD
   promesso va letto come **banda 3,91–4,21% @1,00%** (§5).
5. 🔴 **Le tre PostNews entrano senza PF, senza DD e senza campione**, ed è un fatto, non un
   giudizio: i CSV in archivio hanno **`Trades = 0`**. Contratto `[NON MISURATO]` su tutta la
   riga, con il solo **tetto aritmetico** al posto del DD (§7).

---

# 1️⃣ ⚖️ LE UNITÀ DI MISURA — dichiarate prima dei numeri

| cosa | come si legge qui |
|---|---|
| **DD** | `Equity DD %` del tester, **sempre con deposito + rischio% + modello di barre**. `tick` = Modello 4 (tick reali) · `OHLC` = Modello 1 = **limite INFERIORE del DD, mai un permesso** |
| **scala del rischio** | 🔴 **CONVENZIONE DI CASA, lineare, `[APPROSSIMATO]`**. Tutte e sei le sedie indice sono misurate a **1,00%** e volano a **2,00%** → fattore **×2,0000**. Forbice nota dell'errore del metro lineare: **0,28% – 6%** (`CENSIMENTO_CONTRATTI_v2.md` §1.1). ⚠️ La linearità è **pessimistica** su una striscia perdente a size frazionale e **ottimistica** sul resto |
| **`n`** | la colonna `Trades` dell'OPTFRAME conta i **DEAL DI USCITA**. Col parziale al 50% una posizione chiude in due deal. **Forbice di casa misurata: 1,00 – 2,31.** Dove ho potuto **ho contato i `position_id`**; dove no, la cella dice `[NON MISURATO]` + la forbice |
| **frequenza** | **posizioni ÷ giorni di borsa della finestra**, calcolati da me: OOS `walkforward_generico` **2025.06.10→2026.06.30 = 276 gg** · OOS `walkforward_aperture` **2025.07.01→2026.06.30 = 261 gg** |
| **pavimento** | **1,00 op/giorno per FAMIGLIA** (firma 07/09), non per sedia |

---

# 2️⃣ 📋 LA TAVOLA DEI NOVE CONTRATTI

> 🔴 **Il DD della colonna «@2,00%» è quello che fa scattare la revisione lunedì.** È il DD
> misurato ×2. Non è una misura nuova: è la stessa misura, riletta alla taglia che vola.

| sedia | **DD PROMESSO @1,00% (come misurato)** | **DD @2,00% (la taglia che vola)** | banco della misura | **`n` OOS / IS** | finestra · OOS vero? | **freq. PROMESSA** | **PF IS / OOS** | fonte (file + riga) |
|---|---:|---:|---|---|---|---:|---|---|
| **`770101`** DAX Apertura EU · D30EUR M5 | **OOS 7,2328%** · IS 5,4362% | 🔴 **14,47%** · IS 10,87% | **100.000 €** · 1,00% · **tick** | **193 pos** (270 deal) / **132 pos** (175 deal) — **CONTATE** | IS 2024.09.26→2025.06.09 · OOS 2025.06.10→2026.06.30 · ✅ **OOS vero** · 🔴 **un solo regime (toro)** | **0,699 op/g** | 1,12634 / **1,39709** | `risultati_prove/aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_OOS_r47a.csv` **r.2** · `..._IS_r47a.csv` r.2 · posizioni: `abtg_trades_..._772501.csv` (270 righe, 193 `position_id`) e gemella senza parziale `..._IS/OOS_r47b.csv` (132 / 193) |
| **`770202`** Dow Apertura US · U30USD M5 | **OOS 4,3941%** · IS 5,6692% | 🔴 **8,79%** · IS **11,34%** | **100.000 €** · 1,00% · **tick** | **96 pos** (130 deal) / **56 pos** (74 deal) — **CONTATE** | idem · ✅ **OOS vero** · 🔴 un solo regime | **0,348 op/g** | 1,22247 / **1,27013** | `.../aperture_r47/ABTG_Dow_Apertura_US_U30USD_OOS_r47c.csv` **r.2** · `..._IS_r47c.csv` r.2 · posizioni: `abtg_trades_..._772505.csv` (130/96) e gemella `..._IS/OOS_r47d.csv` (56 / 96) |
| **`770260`** Nasdaq RETEST · US100.cash M5 | **OOS 3,6753%** · IS **5,9528%** | 🟠 **7,35%** · IS 🔴 **11,91%** | 🔴 **10.000 €** · 1,00% · **tick** | **94 pos / 91 pos** 🟢 (`InpTP1_ClosePct=0`: deal = posizioni, **verificato nel CSV**) | IS 2024.09.26→2025.06.30 (9,1 m) · OOS 2025.07.01→2026.06.30 (12,0 m) · ✅ **OOS vero** | **0,360 op/g** | 1,14498 / **1,10936** | `risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv` **Pass 8** (r.13) · `..._IS.csv` **Pass 8** (r.13) · deposito: `backtest_pipeline/walkforward_aperture.ps1` **r.583** |
| **`770411`** MaxMin DAX Short · D30EUR M15 | 🆕 **OOS 1,9213%** · IS 3,0977% | 🟢 **3,84%** · IS 6,20% | **100.000 €** · 1,00% · **tick** | 🆕 **14 pos** (21 deal) — **CONTATE DA ME** / IS **`[NON MISURATO]`**, forbice **9-20** | idem · ✅ **OOS vero** | 🔴 **0,051 op/g** | 1,87803 / **2,15985** | `risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/..._OOS_ptb.csv` **r.2** · `..._IS_ptb.csv` r.2 · posizioni: `trades_portafoglio/abtg_trades_..._770413.csv` (21 righe, **14** `position_id`, 14 giornate) · deposito: `prove/R16b_pertrade_MaxMinNotte.txt` r.3 |
| **`770511`** SuperWave DOW · U30USD H1 | 🔴 **CONTESO: 3,9082% ↔ 4,1675%** · IS 3,7267% ↔ 4,0393% | 🟠 **7,82% – 8,34%** · IS 7,45–8,08% | **10.000 €** · 1,00% · **tick** (e **100.000 €**: 4,2149% → **8,43%**) | 🔴 **143 deal / 84 deal** *(o 131 / 72)* → posizioni **`[NON MISURATO]`**, forbice **62-143** | idem · ✅ **OOS vero** | 🔴 **0,518 op/g in DEAL** · **~0,294 in posizioni [STIMATO]** · forbice dura **0,224-0,518** | 1,84892 / **1,32770** *(o 1,48166 / 1,24312)* | `risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._U30USD_OOS.csv` **Pass 3 (r.3)** · `..._IS.csv` **Pass 3 (r.7)** ⚔️ contro `risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/..._OOS_r120b11.csv` e `..._IS_r120b11.csv` |
| **`771531`** EMA200 Dow · U30USD H1 | **OOS 7,8323%** · IS 5,7325% | 🔴 **15,66%** · IS **11,47%** | **100.000 €** · 1,00% · **tick** | **257 pos** (517 deal) — **CONTATE** / IS **237 deal → posizioni `[NON MISURATO] in repo`** (dichiarato **132** fuori repo; forbice dura **103-237**) | idem · ✅ **OOS vero, a tick** — 🥇 l'unica partizione IS/OOS vera con OOS sopra 150 **in posizioni** di tutto il progetto | **0,931 op/g** | 1,20110 / **1,52365** | `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_OOS_00_metro.csv` **r.2** · `..._IS_00_metro.csv` **r.2** · posizioni: `pertrade_00_metro_763400.csv` (517 righe, **257** `position_id`) · deposito: `righe/RIGA_R112_EMADOW_CONTRATTO.ps1` **r.204** |
| **`771202`** PostNews FOMC · EURUSD M5 | 🔴 **`[NON MISURATO]`** | 🔴 **`[NON MISURATO]`** | — | 🔴 **`[NON MISURATO]`** (`Trades = 0`) | 🔴 nessuna | **~8 eventi/anno = 0,03 op/g** *(conteggio del calendario, non del backtest)* | 🔴 **`[NON MISURATO]`** | `risultati_prove/ABTG_PostNews/*.csv` (**tutte le righe `Trades 0`, verificate da me**) · frequenza: `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md` §1 |
| **`771203`** PostNews NFP · USDJPY M5 | 🔴 **`[NON MISURATO]`** | 🔴 **`[NON MISURATO]`** | — | 🔴 **`[NON MISURATO]`** | 🔴 nessuna | **~12 eventi/anno = 0,05 op/g** | 🔴 **`[NON MISURATO]`** | idem · ⚠️ preset punta a `abtg_news_postnews_2010_2025_UTC.csv`, **ultima riga 2025.07.03** (verificato) → **cieca in campo** |
| **`771204`** PostNews ECB · EURUSD M5 | 🔴 **`[NON MISURATO]`** | 🔴 **`[NON MISURATO]`** | — | 🔴 **`[NON MISURATO]`** | 🔴 nessuna | **~8 eventi/anno = 0,03 op/g** | 🔴 **`[NON MISURATO]`** | idem · `report/CONTRATTO_POSTNEWS_ECB_771201_2026-09-10.md` §2 (*«non posso promettere un DD che nessuno ha misurato»*) |

### 🔑 Come ho verificato che ogni cella è **QUELLA CHE VOLA** — diff campo per campo contro il `.set` FTMO
Non ho preso la cella dai referti: ho **diffato il preset contro la riga del CSV**, per nome di
input. Risultato, e le differenze sono **tutte spiegate**:

| sedia | input uguali | input diversi | spiegazione delle differenze |
|---|---:|---:|---|
| `770101` | **75** su 80 | 5 | `InpSessionHour` 8→**10** e `InpCloseHour` 17→**19** = **rimappatura oraria FTMO** (FTMO = BCM+2) · `InpCorrSymbol` `SPXUSD`→`US500.cash` = **nome BCM → nome FTMO** · `InpRiskPercent` 1→**2,00** · `InpMagic` |
| `770202` | **75** su 80 | 5 | idem (`InpSessionHour` 14→**16**) |
| `770260` | **73** su 78 | 5 | idem (`InpSessionHour` 14→**16**, `InpCloseHour` 17→**19**) |
| `770411` | **44** su 51 | 7 | 5 ore rimappate (`BoxStart` 23→**1**, `BoxEnd` 4→**6**, `Place` 7→**9**, `EntryCutoff` 8→**10**, `Close` 17→**19**) + `InpCorrSymbol` + rischio |
| `770511` | **40** su 41 | **1** | 🟢 **solo `InpRiskPercent` 1→2,00.** Nessuna ora da rimappare (la sedia non ha finestra oraria: `InpUseTimeWindow=0`) · **e zero input nuovi nel `.set`** |
| `771531` | **39** su 43 | 4 | `InpMagic` · `InpRiskPercent` 1→**2,00** · `InpCutoffHour` 19→**21** e `InpFridayCloseHour` 20→**22**, 🟢 **tutte e due INERTI** (`InpUseCutoff=false`, `InpFridayClose=false`, identici nei due) |

🔴 **E l'avvertenza che vale per tutte e sei**: i `.set` FTMO contengono **input che il banco
non aveva**. Sul `770260` sono **20** (`InpUseVolRegime`, `InpUseSRFilter`, `InpMaxPosSimbolo`,
`InpTrailStartR`, `InpRunnerTP_R`, `InpMinBreakoutRangeATR`, `InpVol*`, `InpSR*`, `InpUsaGuardian`);
sul `770101` sono **2** (`InpUsaGuardian`, `InpAllowReverse`); su `770202` e `770411` **1**
(`InpUsaGuardian`); sul `771531` **1** (`InpLogImbuto`); sul `770511` **zero**. Sono **a default inerte** (`false` / `0`) **tranne
`InpUsaGuardian=true`**. 👉 **Il binario che vola non è il binario con cui il DD è stato
misurato.** Non invalida i numeri; li marca **`descrive la sedia che gira? = NON MISURATO`**.

---

# 3️⃣ 🏁 AZIONE **A3** — IL CONFLITTO DI DD SULLA `771531`, ATTRIBUITO

## 3.1 I tre numeri **non sono tre stime della stessa cosa**

| round | **DD** | `n` (deal) | **deposito** | **modello** | **finestra** | fonte verificata da me |
|---|---:|---:|---:|---|---|---|
| **R103** (24/08) | **6,48%** | 712 | 100.000 | 🔴 **1 = OHLC M1** | 🔴 **PIENA 2024.09.26→2026.06.30, nessuno split** | `risultati_archivio/R103_REFERTO_BLOCCO1_INDICI.md` **r.13** · modello e deposito: `R103_CRITERI.md` **r.211-212** |
| **R29b** (12/08) | **7,2138%** | 444 | 🔴 **10.000** | 4 = tick reali | OOS 2025.06.10→2026.06.30 | `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_OOS_r29b.csv` **r.19** (`Pass 17`) · deposito: default `walkforward_generico.ps1` **r.190** |
| **R112** (26/08) | **7,8323%** | 517 | **100.000** | 4 = tick reali | OOS 2025.06.10→2026.06.30 | `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_OOS_00_metro.csv` **r.2** · deposito: `righe/RIGA_R112_EMADOW_CONTRATTO.ps1` **r.204** |

### ✅ È LA STESSA CELLA — misurato, non dedotto
Ho diffato le righe **per nome di input**, non per riassunto:
- **R29b `Pass 17` contro R112 `r.2`**: gli unici campi `Inp*` diversi sono **`InpMagic`**
  (771501 vs 763401) e **`InpComment`** (`EMA200` vs `EMA200 DOW`). `InpOrder1Atr` (`0.20` vs
  `0.2`) e `InpTP_RR` (`2.0` vs `2`) sono **la stessa cifra scritta diversamente**.
  👉 **Tutti e 39 gli altri input — motore, gestione, lato, rischio, TF — sono IDENTICI.**
- **R103 contro R112**: il file prova `prove/R103_ABTG_EMA200_U30USD_771531.txt` porta **43
  parametri**; **42 su 43 coincidono** con la riga R112. L'unico diverso è `InpMagic`
  (`760290/760291`). Stesso `@SIMBOLO U30USD`, stesso `@PERIODO H1`, stesso `@DAQUANDO 2024.09.26`.
- **Il rischio è 1,00% in tutti e tre.** Letto nella colonna `InpRiskPercent`, non assunto.

> ## 🏁 IL VERDETTO — **il contratto della `771531` è `7,8323%` a rischio 1,00%**
> È l'unico dei tre misurato **(a)** a **tick reali**, **(b)** su una finestra **fuori
> campione**, **(c)** alla **taglia del banco della challenge (100.000 €)**.
> 🟢 **Ed è riprodotto QUATTRO volte da corse indipendenti**, tutte verificate da me al
> quarto decimale: **R31** (`ABTG_EMA200_U30USD_OOS_r31.csv`, magic 771521/771522) ·
> **R112** (`00_metro`) · **r136a/b/c/d** (`dal_vps/..._OOS_r136*.csv`) · **cemad05**
> (`dal_vps/..._OOS_cemad05.csv` Pass 3). Stessi `517` deal, stesso `PF 1,52365`, stesso
> profitto `23.321,47`.

### 🏷️ E gli altri due non si buttano: si ETICHETTANO
- **7,2138% = la stessa sedia RIMPICCIOLITA DAL PAVIMENTO DEL LOTTO.** Su un banco da 10.000 €
  `MathFloor` sullo step taglia il lotto: il rischio effettivo scende a **0,9231** del
  dichiarato, e `7,2138 / 7,8323 = 0,9210` — **accordo allo 0,2%**
  (`report/A3_IL_DD_DELLA_771531_2026-09-12.md` §2).
- **6,48% = un LIMITE INFERIORE, non un verdetto.** OHLC M1 non vede il percorso dentro la
  barra, e la finestra **non ha nessun fuori campione**. È **screening**.

### 🧪 IL CONTRO-ESEMPIO, costruito prima del verdetto — e non cade
L'ipotesi alternativa era: *«il 6,48% è più basso perché la finestra di R103 è più LUNGA e
diluisce»*. 🔴 **Sarebbe il contrario**: la finestra di R103 è **il doppio** (21 mesi contro
12,6) e **contiene anche l'OOS**, quindi il massimo drawdown su un superinsieme **non può
essere più piccolo** di quello sul sottoinsieme — a parità di banco. Esce **più basso**.
👉 Quindi *«è OHLC»* **non è una spiegazione di comodo: è l'unico termine che possa spingere in
quella direzione con quella forza**, e il verso complessivo regge:
**`OHLC 6,48 < tick@10k 7,21 < tick@100k 7,83`**.

🔵 **Secondo contro-esempio, più cattivo**: *«e se le tre celle fossero diverse e il diff mi
ingannasse perché il CSV non stampa tutti gli input?»* — Falsificabile: il CSV di R112 stampa
**43 colonne `Inp*`**, e il `.set` che vola ne ha **44**. L'unica in più è `InpLogImbuto`
(solo log). 👉 **Non esiste un input di motore che sfugga al confronto.** Se ne esistesse uno,
sarebbe comparso come `SOLO SET` nel diff: ne è comparso **uno**, ed è un flag di stampa.

## 3.2 🔴 SECONDA RICHIESTA: le POSIZIONI IS della `771531` — **non si contano dal repo**

**Ho cercato, e ho cercato esaurientemente.** Ho scandito **tutti e 130** i file per-trade del
repository (`abtg_trades_*.csv` + `pertrade_*.csv`) leggendo la finestra delle `close_time`:

| esito | dettaglio |
|---|---|
| file per-trade con `close_time` **prima del 2025.06.10** | **14**, e sono **tutti** `pertrade_r82{a..g}_7791*.csv` → `ABTG_BreakoutCorso` **USDJPY**, un altro EA |
| file per-trade di **EMA200** in repo | **4**: `trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_{771521,771522}.csv` e `R112_CORSA_20260826/pertrade_00_metro_{763400,763401}.csv` |
| finestra di **tutti e quattro** | `2025.06.12 13:44:51` → `2026.06.26 15:07:28` = **interamente dentro l'OOS** |

🔴 **Causa nominata, ed è di disegno**: l'EA costruisce il nome del file per-trade con **EA +
simbolo + magic e nient'altro**; il driver corre la gamba IS e poi la gamba OOS nella stessa
chiamata con lo stesso magic → **la seconda sovrascrive la prima**.

### 📌 Il `132` che gira nei referti: **esiste, ma non è in casa**
`report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` **r.80-81** scrive:
*«L'IS della sedia 771531 ha **132 POSIZIONI** (237 deal, rapporto **1,7955**), finestra
2024.10.22 → 2025.06.06»*, e lo attribuisce al per-trade del round **`cemad02`**
(magic 766620/766621), ripreso da `PIANO_PROP.md` **L3**.

🔎 **Che cosa ho potuto verificare io, e che cosa no:**
- ✅ **`cemad02` è reale e riproduce**: `dal_vps/ABTG_EMA200_U30USD_OOS_cemad02.csv` porta
  `PF 1,20110 · DD 5,7325 · n 237 · profitto 4.585,40` = **l'IS di R112 al centesimo**. Il suo
  file `_IS_` è **0 byte**, ed è **voluto** (`@FRAZIONEIS 0,002`).
- ✅ **Il 132 è internamente coerente**: `237 / 1,7955 = 131,99`.
- 🔴 **Il per-trade di `cemad02` NON è nel repository.** `grep -rl "766620\|766621" --include=*.csv`
  su tutto il repo restituisce **un solo file: il CSV di riepilogo**. Nessun per-trade.

> ### 🏷️ L'etichetta onesta è: **IS = 132 posizioni `[MISURATO FUORI REPO, artefatto assente]`**.
> Dal repo posso solo dire **`[NON MISURATO]` con forbice dura 103 – 237**.
> ✅ **In tutti e due i casi la conclusione operativa NON cambia: l'IS è SOTTO 150**, quindi il
> **merito in campione resta SOSPESO** (valvola R59 + Emendamento B) e **il rischio si legge
> lo stesso** — un DD accaduto vale a qualunque `n`.

### 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO PER ROMPERE LA MIA STESSA SCORCIATOIA — **e si rompe**
Per `770101` e `770202` ho contato le posizioni **senza** per-trade, con un trucco: la
**gemella senza parziale** (`InpTP1_ClosePct=0`) ha `deal = posizioni`, e se gli ingressi sono
gli stessi il suo `n` **è** il conteggio delle posizioni. Funziona, ed è verificato:

| sedia | `n` della gemella **OOS** senza parziale | `position_id` distinti contati sul per-trade **con** parziale | esito |
|---|---:|---:|---|
| `770101` | **193** (`..._OOS_r47b.csv`) | **193** (`abtg_trades_..._772501.csv`) | 🟢 **combaciano** |
| `770202` | **96** (`..._OOS_r47d.csv`) | **96** (`abtg_trades_..._772505.csv`) | 🟢 **combaciano** |

👉 Quindi gli `n` IS **132** e **56** di quelle due sedie sono **posizioni vere**, non stime.

🔴 **E poi ho provato lo stesso trucco sulla `771531`. NON REGGE, ed è misurato:**
`dal_vps/ABTG_EMA200_U30USD_OOS_r136c.csv` **Pass 0** ha `InpTP1Pct = 0` e fa **`n = 165`**.
Ma le posizioni OOS di quella sedia sono **257, contate una per una**. **165 ≠ 257.**

> ## 👉 **Su `EMA200` togliere il parziale CAMBIA GLI INGRESSI**, non solo le uscite: con la
> posizione che resta aperta più a lungo, i segnali successivi vengono mangiati. Quindi la
> gemella **non** misura le posizioni di questa sedia, **e chi la usasse sbaglierebbe del 36%.**
> 🔵 **Ecco perché non posso consegnare un `132` come "ricontato da me": l'unica via che avevo
> l'ho provata e l'ho vista rompersi.** La via vera resta una sola, ed è in §8.

## 3.3 🧮 La **classe 226** chiusa su questa sedia
Il `n` dei nostri CSV sono **deal di uscita**. Il fattore uscite/posizioni **non è una
costante**: sulla `771531` vale **2,0117 in OOS** (517/257, contato) e — secondo la misura
fuori repo — **1,7955 in IS** (237/132). Sullo stesso EA, stessa finestra, stesso banco, le
celle short fanno **2,16 · 2,25 · 2,31** (contate da me sui `pertrade_0{1,2,3}_*`).
👉 **Dividere per due è inventare.** Dove non ho contato, ho scritto la forbice.

---

# 4️⃣ 🆕 IL BUCO CHIUSO SULLA `770411` — e la correzione del suo DD

## 4.1 🟢 Le posizioni: **14**, contate
`CENSIMENTO_CONTRATTI_v2.md` dava *«21 → `[NON MISURATO]`, forbice 9-21»*.
**Il per-trade c'è**, e l'ho letto:
`risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv`
→ **21 righe · 14 `position_id` distinti · 14 giornate · netto +6.143,38** · finestra
`2025.08.19 09:31:57 → 2026.06.24 08:47:07`. Fattore **1,50**, dentro la forbice di casa.

## 4.2 🔴 E il DD di contratto **non è 1,27%**
Il **1,27%** che sta in `REFERTO_PORTAFOGLIO_R16.md` (tabella serie, magic 770413) e che
`DD_PORTAFOGLIO_FTMO_2026-09-20.md` r.44 usa come DD della sedia è **un'aggregazione per
GIORNATA del per-trade**, non l'`Equity DD %` del tester.

**Il tester, sulla stessa identica corsa, dice 1,9213%** — e lo so che è la stessa corsa perché
il **profitto combacia all'euro**: `..._OOS_ptb.csv` porta `Profit = 6143.38`, che è **esattamente**
la somma dei `net_profit` del per-trade `770413`.

| lettura | DD OOS | DD @2,00% | fonte |
|---|---:|---:|---|
| **Equity DD % del tester** ✅ **è questo il contratto** | **1,9213%** | **3,84%** | `..._D30EUR_OOS_ptb.csv` r.2 (dep. **100.000**) |
| aggregazione per giornata del per-trade | 1,27% | 2,54% | `REFERTO_PORTAFOGLIO_R16.md` tab. serie |
| stessa cella su banco da **10.000 €** | 1,8768% | 3,75% | `..._D30EUR_OOS.csv` r.2 (profitto 618,31 = 1/9,94 del 100k) |

🔵 **Perché la differenza esiste e non è un errore**: l'aggregazione per giornata **non vede il
flottante dentro la giornata**. 🔴 **E il muro giornaliero FTMO è su EQUITY**, cioè include
proprio quel flottante. **Prendere l'1,27% come DD promesso sarebbe prendere il numero più
comodo**, ed è esattamente ciò che l'Emendamento vieta.

> 📌 Resta il **secondo** contratto storico di questa sedia, e va citato accanto:
> **3,1% @1,00% su n 41, PF 2,05** (promozione del 26/07, `REGISTRO_TEST.md` **r.476**).
> A 2,00% sono **6,20%**. 🟠 **Se lunedì il forward passasse il 3,84% ma restasse sotto il
> 6,20%, i due contratti darebbero verdetti opposti.** Lo dichiaro adesso, non dopo.

---

# 5️⃣ 🔴 LA `770511` — il contratto è CONTESO, e la causa **non è nei parametri**

## 5.1 Il fatto, verificato campo per campo
La cella del preset FTMO è, senza ambiguità, `..._U30USD_OOS.csv` **Pass 3**
(`InpStMult=2.5`, `InpTP_RR=3.0`): **40 input su 41 identici**, l'unico diverso è il rischio.
Ma **la stessa cella, misurata due volte, dà due risultati**:

| corsa | deposito | **`n` IS / OOS** | **PF IS / OOS** | **DD IS / OOS** | differenze di input dalla cella |
|---|---:|---:|---|---|---|
| **archivio 26/07** (`..._IS.csv` / `..._OOS.csv` Pass 3) | 10.000 | **84 / 143** | 1,84892 / **1,32770** | 3,7267 / **3,9082** | — |
| **r120b11** (12/09, `dal_vps/`) | 10.000 | **72 / 131** | 1,48166 / **1,24312** | 4,0393 / **4,1675** | 🔴 **NESSUNA. Zero.** |
| **r120e11** (12/09, `dal_vps/`) | **100.000** | **106 / 184** | 1,39744 / 1,22034 | 3,4846 / **4,2149** | 🔴 **NESSUNA** |

🔴 **`r120b11` ha lo stesso deposito, lo stesso simbolo, lo stesso TF e TUTTI E 41 gli input
identici alla cella di contratto — e produce 12 operazioni in meno e un DD più alto di
0,26 punti.** Il delta è **fuori dal `.set`**: resta il **binario dell'EA** (il contratto
d'archivio è del **26/07**, `a4107cf`; oggi vola il pin **`872dba82`** compilato il **19/09**,
che contiene proprio il **fix del pavimento del lotto**) oppure lo **storico tick**, ricaricato
fra luglio e settembre.

## 5.2 🧪 I DUE CONTRO-ESEMPI CHE HO COSTRUITO — e che **assolvono due accuse sbagliate in repo**

**(a) «Due corse danno due DD diversi sulla stessa `n`» — 🔴 FALSO, e la correggo.**
`DD_PORTAFOGLIO_FTMO_2026-09-20.md` **r.50 (riga 5b)** scrive che `..._OOS_r3.csv` Pass 3 dà
`PF 1,09636 · DD 5,1118` sulla stessa `n 143`, e ne conclude *«due corse danno due DD diversi
sulla stessa cella»*. **Ho diffato le due righe**: `..._OOS_r3.csv` **Pass 3** ha
**`InpStMult = 3.0`**, la cella ha **`2.5`**. 🟢 **È un'altra cella.** La cella vera in quel
file è **Pass 2**, e riproduce **ZERO differenze di input** e **PF 1,32770 · DD 3,9082 · n 143**
— **identica al quarto decimale**.

**(b) «La corsa `r3` dà IS PF 1,44 su n 75» — 🔴 anche questa è di un'altra cella.**
`report/ALLARGARE_LA_ROSA_2026-09-19.md` **r.255** attribuisce alla corsa `r3` un
*«IS PF 1,44 n 75 DD 4,77%»*. Quello è `..._IS_r3.csv` **Pass 4**, `InpStMult = 3.5`.
La cella di contratto in `r3` è **Pass 2**: **PF 1,84892 · DD 3,7267 · n 84**, **diff = nessuna**.

> 👉 **Conclusione: la cella del 26/07 è perfettamente riproducibile CONTRO SÉ STESSA (corsa `r3`,
> stesso binario). Quello che NON riproduce è il binario di settembre.** Le due accuse in repo
> puntavano al bersaglio sbagliato; il problema vero è più serio e sta altrove.

## 5.3 🏷️ Come va scritto il contratto di questa sedia, oggi
> **DD promesso `770511` = banda `3,91% – 4,21%` @1,00% → `7,82% – 8,43%` @2,00%.**
> 🔴 **Per far scattare la revisione lunedì si usa il PIÙ STRETTO: 7,82%.** Motivo di casa: la
> corsia RISCHIO non sceglie il numero comodo. Un forward che supera il 7,82% va guardato
> **anche** se resta sotto l'8,43%.
> 🔴 **E `n` in posizioni resta `[NON MISURATO]`**: non esiste per-trade di questa sedia in repo
> (verificato). Forbice dura **62-143**; stima col fattore della gemella `770531` (88→50 = 1,76)
> **~81 posizioni = 0,294 op/g**.

---

# 6️⃣ ⏱️ LA FREQUENZA PROMESSA CONTRO QUELLA DI CAMPO

Calcolata da me: **posizioni ÷ giorni di borsa della finestra**. Il campo viene da
`data/statements/trades_auto.csv` (piccolo **50503392**) e `trades_100k.csv` (**50504263**),
contando i `pid` distinti fra la prima e l'ultima apertura di quel magic.

| sedia | **promessa (OOS)** | campo **piccolo 50503392** | campo **100k 50504263** | lettura |
|---|---:|---:|---:|---|
| `770101` | **0,699** | **0,886** (39 pos / 44 gg) | 0,536 (15 / 28) | 🟢 sopra il promesso sul piccolo ⚠️ include **NASUSD**: il magic è doppio |
| `770202` | **0,348** | 0,250 (4 / 16) | 0,200 (3 / 15) | 🔴 **57% del promesso**, ultima operazione **28/08** |
| `770260` | **0,360** | 🔴 **0** | 🔴 **0** | 🔴 **mai operata**: nessun forward, il contratto è **solo di banco** |
| `770411` | 🔴 **0,051** | 0,500 (5 / 10) | 0,571 (4 / 7) | 🟢 in campo va **10× il promesso** — ma su 10 giorni: **campione che non decide** |
| `770511` | **~0,294** *(stimato)* | 0,516 (16 / 31) | 🔴 **0** | 🟠 sopra il promesso ⚠️ prodotto dal binario **col difetto di sizing dentro** |
| `771531` | **0,931** | **1,312** (21 / 16) | 🔴 **0** | 🟢 la più veloce della rosa |
| `771202` · `771203` · `771204` | **0,03 · 0,05 · 0,03** | 1 · 1 · 0 posizioni in assoluto | **0** | 🔴 **campione zero** |

### 🧮 Il conto per FAMIGLIA (l'unità firmata il 07/09)
| famiglia | promesso, sommato | pavimento | esito |
|---|---:|---:|---|
| **Aperture** (`770101` + `770202` + `770260`) | **1,407 op/g** | 1,00 | 🟢 **SOPRA (+41%)** |
| **EMA200** (`771531`) | **0,931** | 1,00 | 🟠 **sotto del 7%** |
| **SuperWave** (`770511`) | ~0,294 | 1,00 | 🔴 **sotto di 3,4×** |
| **MaxMinNotte** (`770411`, da sola nella rosa FTMO) | 0,051 | 1,00 | 🔴 **sotto di 20×** |
| **PostNews** (`771202`+`771203`+`771204`) | **0,11** | 1,00 | 🔴 **sotto di 9×** |

---

# 7️⃣ 📰 LE TRE POSTNEWS — contratto `[NON MISURATO]`, e perché non è pigrizia

**Il fatto, verificato da me riga per riga:** gli unici CSV di backtest di `ABTG_PostNews` in
repo sono **quattro** (`risultati_prove/ABTG_PostNews/ABTG_PostNews_{EURUSD,EURJPY}_{IS,OOS}_ohlc.csv`)
e **ogni riga ha `Profit 0.00 · Profit Factor 0.00000 · Equity DD % 0.0000 · Trades 0`**.

🔴 **Quattro file con `Trades 0` non misurano una strategia debole: non misurano niente.**
Causa già accertata e corretta (`REGISTRO_TEST.md` §2-ter): il calendario non arrivava nella
sandbox dell'agente del tester, e il filtro si spegneva **in silenzio**. Il verdetto *«PostNews:
nessun edge»* del 07/08 è **RITIRATO** — non ribaltato: **inesistente**.

## 🧾 Che cosa si può scrivere lo stesso, e con che etichetta

| voce | `771202` FOMC | `771203` NFP | `771204` ECB |
|---|---|---|---|
| **DD promesso** | 🔴 `[NON MISURATO]` | 🔴 `[NON MISURATO]` | 🔴 `[NON MISURATO]` |
| **tetto ARITMETICO** *(non è una previsione: è un tetto)* | 0,65%/evento × ~8 = **~5,2%/anno** se le sbagliasse tutte | **1,30%/evento** (🔴 `InpUseOCO=false`: le due gambe **possono sommarsi**) × ~12 = **~15,6%/anno** | 0,65%/evento × ~8 = **~5,2%/anno** |
| **frequenza promessa** | ~8/anno = **0,03 op/g** | ~12/anno = **0,05 op/g** | ~8/anno = **0,03 op/g** |
| **`n` / PF / finestra** | 🔴 tutti `[NON MISURATO]` | 🔴 idem | 🔴 idem |
| ⚠️ **rilievo che ho verificato io** | — | 🔴 il preset punta a `abtg_news_postnews_2010_2025_UTC.csv`, **ultima riga `2025.07.03`** → **in campo è CIECA** | — |
| ⚠️ **calendario del forward** | `mql5/Files/abtg_news.csv` ha **FOMC 28/10 e 09/12** ✅ | 🔴 **nessuna riga NFP dopo il 06/03/2026** | `abtg_news.csv` ha **ECB 29/10 e 17/12** ✅ |

## 🧪 IL CONTRO-ESEMPIO — *«forse un backtest NFP esiste e non l'hai trovato»*
Ipotesi legittima: il preset NFP punta a un calendario **2010-2025 da 599 eventi**, che
esisterebbe solo se qualcuno avesse **preparato** una corsa storica. **L'ho verificata:**
- il file **esiste** (`mql5/Files/abtg_news_postnews_2010_2025_UTC.csv`, **600 righe**);
- il file prova **esiste** (`backtest_pipeline/prove/POSTNEWS_NFP_00_conta.txt`);
- 🔴 **ma dichiara di sé, alla riga 6: *«Scritto il 03/09/2026. NON LANCIATO»***;
- e nella cartella dei risultati **non c'è nessun CSV** con quel tag.

👉 **La preparazione c'è, la corsa no.** L'ipotesi alternativa è stata cercata e **non regge**.
🟢 **E il file prova stesso dichiara in anticipo che da lì non può uscire una promozione**:
*«12 eventi l'anno × 2 gambe = 24 ordini piazzati l'anno… il campione IS non arriva a 150.
DA QUESTA CELLA NON PUÒ USCIRE NESSUNA PROMOZIONE»*.

> ## 🔴 COSA SIGNIFICA PER LUNEDÌ, detto chiaro
> Per queste tre sedie **la corsia RISCHIO del criterio del 18/08 NON PUÒ SCATTARE**: non
> esiste un DD promesso da superare. **L'unico cancello che resta acceso è il Guardian**
> (pausa 4,0% / emergenza 4,9% e 9,9%) e il cap **C1 al 3,25%**.
> 👉 **Non è un motivo per spegnerle** — sono tre misure di un meccanismo, e costano poco.
> **È un motivo per non contarle come sedie della challenge** e per sapere che, se vanno male,
> ce ne accorgiamo da un'altra parte.

---

# 8️⃣ 🕳️ I BUCHI, PER NOME — e la via più corta per chiuderli

*(regola del 09/09: un candidato senza certificato non è morto, è non misurato; e ogni buco
va con il suo costo in tempo macchina)*

| # | buco | via più corta | costo |
|---|---|---|---|
| **B1** | 🔴 **`771531` IS in posizioni**: il per-trade non esiste in repo, e la gemella senza parziale **NON serve** (§3.2, misurato: 165 contro 257) | **UNA corsa**: cella `00_metro`, **solo la gamba IS** (2024.09.26→2025.06.09), tick, `-Deposito 100000`, con l'export per-trade e un **magic vergine**. Oppure: **ricaricare dal VPS il per-trade di `cemad02`** (magic 766620/766621), che **esiste già e non è mai stato committato** | **~45 s** di tester · oppure **zero macchina** (è un trasferimento) |
| **B2** | 🔴 **`770511` non riproduce fra binario di luglio e binario di settembre** (§5.1) | rilanciare la cella **`00`** sul binario **`872dba82`** (quello che vola) alla stessa finestra e allo stesso deposito, e **dichiarare quale dei due numeri è il contratto** | ~1 min di tester |
| **B3** | 🔴 **`770511` posizioni `[NON MISURATO]`** | la stessa corsa di B2 **con l'export per-trade acceso** | **gratis dentro B2** |
| **B4** | 🔴 **`770411` IS in posizioni `[NON MISURATO]`** (forbice 9-20) | idem: l'export per-trade della gamba IS | ~30 s |
| **B5** | 🔴 **`770260` è misurata a deposito 10.000 €, ma il banco FTMO è 100.000** — e sappiamo che il deposito morde (sulla `770101` vale **+7,8%** a parità di trade) | una corsa `Pass 8` a `-Deposito 100000` | ~1 min |
| **B6** | 🔴 **Nessuna delle sei misure descrive il BINARIO CHE VOLA**: i `.set` FTMO portano input che il banco non aveva (20 sul `770260`, 1 sul `771531`), e `InpUsaGuardian=true` non era della partita | confronto dei **lotti** fra binario vecchio e nuovo nel Tester `C:\MT5_Backtest` (**50504400**), stesso simbolo/TF | ~10 min, **e non tocca nessun conto** |
| **B7** | 🔴 **Le tre PostNews non hanno NESSUN numero** (§7) | `POSTNEWS_NFP_00_conta.txt` **esiste ed è pronto**: va solo lanciato, col calendario copiato in `Common\Files` | ~2 min · ⚠️ **non può promuovere nulla**, vale solo sul RISCHIO |
| **B8** | 🟠 **Doppio contratto sulla `770411`**: 1,9213% (R16) contro 3,1% (promozione 26/07, n 41) — **danno verdetti opposti fra 3,84% e 6,20% @2,00%** | riprodurre la cella del 26/07 sul banco di R16 e tenere **uno solo** dei due | ~1 min |
| **B9** | 🟠 **Magic doppio `770101` sul piccolo**: il campo porta operazioni su **D30EUR e NASUSD** con lo stesso magic. Ogni frequenza letta per solo magic **mescola due sedie** | filtrare **sempre** per `magic + simbolo + conto` | zero |
| **B10** | 🟠 **`770101`: esiste una firma pronta che CAMBIEREBBE il contratto.** `r137c` (`InpTP1_ClosePct` 50→0) alza il PF OOS a **1,49140** e abbassa il DD a **6,2719%** (**12,54% @2,00%**) a parità di 193 posizioni. 🔴 **Il preset FTMO porta ancora `50`** | è una **firma di Claudio**, non un lavoro | zero macchina |

---

# 9️⃣ ✅ COSA È ANDATO BENE — perché un elenco di difetti senza le vittorie descrive male la realtà

- 🥇 **Sei contratti su nove sono MISURATI**, con fonte al file e alla riga, e li ho verificati
  io contro i preset che volano: **non uno solo dei sei è "la cella sbagliata"**. Tre mesi fa
  questa frase non si poteva scrivere.
- 🟢 **La `771531` è riprodotta QUATTRO volte** da corse indipendenti, identica al quarto
  decimale. Nel progetto non c'è nient'altro di così solido.
- 🟢 **Due numeri migliorati contando, non discutendo**: `770411` da *«21 → non misurato»* a
  **14 posizioni**, e il suo DD da un'aggregazione per giornata all'**Equity DD vero**.
- 🟢 **Due accuse sbagliate ritirate col numero in mano** (§5.2): la `770511` **riproduce**
  contro sé stessa. Il problema vero era un altro, ed è più utile saperlo.
- 🟢 **La rimappatura oraria FTMO tiene**: le 27 ore spostate su 10 preset sono coerenti con
  `FTMO = BCM + 2` **in tutte e sei** le sedie indice, verificato input per input.
- 🟢 **La famiglia Aperture passa il pavimento di frequenza** (1,407 contro 1,00).

---

# 🔟 🛡️ LA COSA CHE NON POSSO NON DIRE, e non è una mia decisione

Tutti i DD di questa pagina sono **misurati a 1,00%** e la challenge parte a **2,00%**.
Rimessi alla taglia che vola:

| | DD @2,00% | muro FTMO |
|---|---:|---|
| `771531` EMA200 Dow | 🔴 **15,66%** | **10% statico** |
| `770101` DAX Apertura | 🔴 **14,47%** | **10% statico** |
| `770202` Dow Apertura | 🟠 8,79% *(IS **11,34%**)* | |
| `770511` SuperWave | 🟠 7,82–8,43% | |
| `770260` Nasdaq RETEST | 🟠 7,35% *(IS **11,91%**)* | |
| `770411` MaxMin DAX Short | 🟢 3,84% | |

🔴 **Due sedie sfondano il muro del 10% DA SOLE, e altre due lo sfondano sulla finestra IS.**
Non è una scoperta di questo documento — `report/DD_PORTAFOGLIO_FTMO_2026-09-20.md` l'ha già
misurato sul portafoglio (13,91% combinato, 12,4% di sequenze Monte Carlo che sfondano) — ma è
la **conseguenza diretta dei contratti scritti qui**, e un censimento dei contratti che la
tacesse sarebbe un censimento fatto male.

✋ **Non propongo nessuna taglia e non tocco nessun rischio: è firma di Claudio.** Il mio
compito era scrivere il numero contro cui si misura lunedì. **È scritto.**

---

## 📌 RIEPILOGO OPERATIVO — la riga da tenere sotto mano lunedì

> **Revisione IMMEDIATA se il DD forward supera:**
> `770101` **14,47%** · `770202` **8,79%** · `770260` **7,35%** · `770411` **3,84%** ·
> `770511` **7,82%** · `771531` **15,66%**
> · `771202`/`771203`/`771204` 🔴 **nessuna soglia: contratto `[NON MISURATO]`, vale solo il
> Guardian e il cap C1**.

---

*Misura prodotta in sola lettura il 20/09/2026. I numeri che decidono — le tre righe del
conflitto `771531`, le 257 e le 14 posizioni contate, il diff dei sei preset contro le celle,
la non-riproduzione della `770511` e i `Trades 0` delle PostNews — sono stati letti da me al
file sorgente, non ripresi dai referti. Dove un numero viene da fuori repo (il `132` dell'IS),
è scritto che viene da fuori repo.*
