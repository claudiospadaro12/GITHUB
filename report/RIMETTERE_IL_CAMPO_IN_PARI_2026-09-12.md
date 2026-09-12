# 🧰 RIMETTERE IL CAMPO IN PARI — 12/09/2026

> **PERIMETRO: SOLA LETTURA. Non ho toccato niente.** Nessun EA modificato,
> nessun `#define`, nessun preset, nessuna sedia staccata, nessuna
> compilazione. Questo referto **misura** e **prepara**. Le firme sono di
> Claudio.
>
> **Cosa aggiunge a quello che avevamo già:** `DISALLINEAMENTO_CAMPO_v2` e
> `IL_CAMPO_SEDIA_PER_SEDIA` avevano datato il campo sedia per sedia e trovato
> **tre** difetti riparati-e-non-in-campo (tutti sul 100k). Io ho **rifatto la
> datazione da zero** (e torna, commit per commit) e poi ho cercato **le
> riparazioni che nessun referto aveva ancora nominato**. Sono **quattro**, e
> **tre toccano i soldi**. Una è stata **osservata in campo con l'orologio**.

---

# 🟢 PRIMA LE COSE ANDATE BENE, che sono tre e sono grosse

1. 💰 **Il conto REALE 10105439 (`C:\BCM_Reale`) è PULITO.** Ri-verificato da me,
   per una strada indipendente: le 4 sedie combaciano con commit del repo di
   oggi (`9638318` DAX, `19312c8` ORB, `1b6a095` Guardian v1.12, SlippageLogger
   v1.00). **Non è un problema da risolvere e in questo referto non si tocca.**
2. 🎯 **La datazione del campo regge al ricontrollo.** Ho rifatto il match
   cercando, per ogni sorgente in campo, il commit della **storia intera di git**
   con esattamente quel conteggio di righe: **ogni** sorgente ha trovato **un
   solo** commit (`n=1`), tranne uno. Nessuna ambiguità → le date non sono
   inferenze.
3. 🧮 **Il `+1` dello strumento è confermato**: `CODA_06` conta `wc -l + 1`
   (verificato su 6 file: Guardian 899/900, DAX 2367/2368, ORB 1463/1464,
   PostNews 666/667, TradeExporter 211/212, Nasdaq 2566/2567). Tutti i numeri
   qui sotto sono **già corretti** di quel +1.

### 🟢 E una notizia che DECLASSA un allarme (vedi §5.5)
Il fix di sizing `3af47ed` manca a **11 sedie del piccolo** — ma il difetto che
ripara è stato misurato **su 225JPY**, e **nessuna delle 11 gira su un simbolo
JPY**. Le sedie vive su 225JPY (3) hanno tutte il fix. 👉 Quell'allarme scende
da 🔴 a 🟠 `[NON MISURATO]`.

---

# 1. 🔴 LA TABELLA MAESTRA — riparazione → commit → diff → sedie → conto → soldi → danno

Ordinata per **danno potenziale MISURATO**, non per anzianità.
`cod±` = righe **non-commento** (una riparazione da 11 righe di cui 9 di
commento è una riparazione da **2 righe**).

| # | riparazione | commit | data | diff | 💰 soldi | sedie affette | conto | danno misurato |
|---:|---|---|---|---|:---:|---|---|---|
| **1** | **ORB hedge-safe**: `PositionClose/Modify(_Symbol)` → **per TICKET** | `19312c8` | 03/09 | +554/−49 (cod **+322/−16**) | 🔴 **SÌ** | `ORB_Ottimizzato` U30USD M5 · **770611** · 0,3% | **100k 50504263** | l'EA **scrive sulla posizione del VICINO** (chiude, sposta lo SL). Vicino `Dow_Apertura_US` 770202 su U30USD **confermato**, conto **hedging** |
| **2** | **Lotto doppio**: pavimento del lotto **prima** di `lotPend` | `872dba8` | 08/09 | **+11/−2** per file (cod **+2/−1**) | 🔴 **SÌ** | **7**: `SupertrendReversal` 225JPY **770901** (0,65%) · + 6 sul piccolo (`SuperWave` 770531, `SuperWave_DOW_H1_Ott` 770511, `SupRev_DAX_H4_Ott` 970912, `SupRev_NAS_H1_Ott` 970913, `SupertrendReversal` 770924, `SupertrendReversal_Ott` 970901) | **100k** (1) + **piccolo** (6) | **fino a 2× il rischio dichiarato**. Misurato in campo 20/08: **1,42% contro un contratto 1,0%** |
| **3** | 🆕 **Guardia A4 `storicoOk`**: non timbrare la giornata se lo storico **non ha risposto** | `bc11093` (DAX) + `8b92214` (Dow/Nasdaq/Marco) | **14/08** | +34/−6 · +~30/−6 (cod **+11/−2** l'uno) | 🔴 **SÌ** | `DAX_Apertura_EU` **770101** · `Dow_Apertura_US` **770202** · `Nasdaq_Apertura_US` **770250** | **piccolo 50503392** | **SECONDO armamento nello stesso giorno** → doppio trade, doppia esposizione. **OSSERVATO col ticket e il millisecondo**: 14/08 **16:17:43**, lotto **1,90**, stessi prezzi del giro delle 09:25 |
| **4** | 🆕 **Breakeven staccato dal parziale** | `344a11b` (17 EA) + `d4da7d7` (altri 11) | 04/08 + 06/08 | intero blocco riscritto | 🔴 **SÌ** | `MaxMinNotte` XAUUSD M15 · **770402** | **piccolo 50503392** | a lotto minimo `NormVol(vol×50%)`→0, il parziale non parte **e il breakeven salta con lui**. Misurato: da **+79,88 a −32,90** = **112,78 EUR** di oscillazione **con lo stop ancora all'originale dopo 1,28R a favore** |
| **5** | **Guardian: baseline dall'EQUITÀ, non dal bilancio** (+ GV `_V2`) | `d884f7e` | 06/09 | +42/−11 | 🔴 **SÌ** (protezione) | `Guardian` **779001** | **100k 50504263** | metà neutralizzata (`InpStartBalance=100000` esplicito); **la baseline GIORNALIERA no**: `GlobalVariableSet(GV_DAYSTART,bal)` resta `bal` in v1.11. Errore = **il flottante alle 23:00 server**. In euro: `[NON MISURATO]` |
| **6** | **`DEF_RISK` 2.0 → 1.0** | `9638318` | 02/09 | +17/−5 (**cod +2/−2**) | 🟠 **SÌ, LATENTE** | `DAX_Apertura_EU` **770101** (100k **e** piccolo) | 100k + piccolo | oggi **0**: il preset (0,65 / 1,0) vince. Un **Ripristina** → **2,0%** |
| **7** | 🆕 **`InpOneTradePerDay` letto davvero** | `7d0da9f` | 03/09 | cod +~90 | 🔴 **SÌ** | `MaxMinNotte` XAUUSD **770402** | **piccolo 50503392** | il pannello promette 1 trade/giorno e il binario **non lo applica**. Sul gemello `ORB` è misurato: **20 operazioni in 16 giornate = +25% di frequenza** sul contratto |
| **8** | 🆕 **Sizing: `OrderCalcProfit` al posto del tick value nudo** | `3af47ed` | 08/08 | +22/−4 (cod **+15/−4**) per file | 🟠 **SÌ ma `[NON MISURATO]` qui** | **11** sedie del piccolo (3× `PTE`, `SuperWave`, `EMA200`, `EMA200_Ott`, `STREV_Ott`, `SW_DOW_H1_Ott`, `SupRev_DAX_H4`, `SupRev_NAS_H1`, `MaxMinNotte`) | **piccolo 50503392** | misurato **solo su 225JPY** (lotto ~0 → **sempre al minimo**; a deposito 100k risultati identici al 10k). **Nessuna delle 11 è su JPY** → vedi §5.5 |
| **9** | Filo del Guardian (`#include` + `input` + 1 chiamata) | `26a1856` `5fc0bc3` `f8ebc32` `d83c196` | 19/08 | **+3/−0** | 🟢 **NO** | 20 sedie | piccolo | **zero**: l'include è **fail-open** e su quel terminale il Guardian **non gira** (§5.1) |
| **10** | Opt-in a default neutro: `BreakingBand` v1.03/1.04/1.05, `SuperWave` `7f80a87`, `InpSlippagePts` `4c424e2`, filtri Nasdaq `39cc34d`, `ExportTrades` ×3, export `OnTester` `6074126` | vari | 08–29/08 | vario | 🟢 **NO** | — | — | **zero**: verificato input per input, tutti a **0 / false / modo 0 = comportamento storico** |

## 🔢 Il conto delle sedie, rifatto da me

| conto | sedie | 🟢 allineate | 🟠 vecchie ma **indistinguibili** | 🔴 manca una riparazione che **tocca i soldi** |
|---|---:|---:|---:|---:|
| **REALE 10105439** `C:\BCM_Reale` | **4** | **4** | 0 | **0** 🟢 |
| **100k 50504263** `...MT5 Terminal -V3` | **7** (profilo 06/09) | **3** (Dow, MaxMinNotte_DAX_Short, TradeExporter) | 0 | **4** (ORB, STREV, Guardian, DAX-latente) |
| **piccolo 50503392** `...BCM Markets MT5 Terminal` | **40** | **5** (ORB, 3× PostNews, TradeExporter) | **20** | **15** |

✏️ **ERRATA sul referto di stanotte, e la dico io:** `IL_CAMPO_SEDIA_PER_SEDIA`
scriveva **5 / 17 / 18** sul piccolo. Io conto **5 / 20 / 15**, e l'elenco
nominale sedia-per-sedia è in §2. La differenza sono **3 sedie `BreakingBand`**
che quel referto teneva in rosso: ho verificato **input per input** che
`InpMinRR=0`, `InpContEntryMode=0` e le manopole della v1.05 sono **opt-in a
default storico** → vanno in arancione. 🔴 **Il totale 40 torna in tutti e due
i conteggi**: non è un file trovato o perso, è una **classificazione** diversa,
e la mia è verificabile riga per riga.

---

# 2. 🪑 IL PICCOLO 50503392, SEDIA PER SEDIA (40 su 40, per nome)

`C:\Program Files\BCM Markets MT5 Terminal` · conto **50503392** · profilo
fotografato il 06/09 22:55, sorgenti del **28/07 – 03/09**.

### 🔴 ROSSO — manca una riparazione che tocca i soldi (15)

| sedia | simbolo | campo @ | riparazioni MONEY mancanti |
|---|---|---|---|
| `MaxMinNotte` **770402** | XAUUSD M15 | `0823951` **28/07** | **#4 breakeven** · **#7 OneTradePerDay** · #8 sizing |
| `DAX_Apertura_EU` **770101** | D30EUR M5 | `3af47ed` 08/08 | **#3 guardia A4** · #6 DEF_RISK 2.0 |
| `Dow_Apertura_US` **770202** | U30USD M5 | `3af47ed` 08/08 | **#3 guardia A4** |
| `Nasdaq_Apertura_US` **770250** | NASUSD M15 | `3af47ed` 08/08 | **#3 guardia A4** · 🔴 **DEF_RISK 2.0 ancora nel REPO** (§3) |
| `SuperWave` **770531** | U30USD H4 | `344a11b` 04/08 | **#2 lotto doppio** · #8 sizing |
| `SuperWave_DOW_H1_Ott` **770511** | U30USD H1 | `344a11b` 04/08 | **#2 lotto doppio** · #8 sizing |
| `SupertrendReversal` **770924** | 225JPY H2 | `3af47ed` 08/08 | **#2 lotto doppio** |
| `SupertrendReversal_Ott` **970901** | XAUUSD H4 | `344a11b` 04/08 | **#2 lotto doppio** · #8 sizing |
| `SupRev_DAX_H4_Ott` **970912** | D30EUR H4 | `344a11b` 04/08 | **#2 lotto doppio** · #8 sizing |
| `SupRev_NAS_H1_Ott` **970913** | NASUSD H1 | `344a11b` 04/08 | **#2 lotto doppio** · #8 sizing |
| `PTE` **771321** | U30USD H1 | `344a11b` 04/08 | #8 sizing |
| `PTE` **771332** | GBPUSD H1 | `344a11b` 04/08 | #8 sizing |
| `PTE` **771322** | GBPUSD H1 | `344a11b` 04/08 | #8 sizing |
| `EMA200` **771531** | U30USD H1 | `344a11b` 04/08 | #8 sizing |
| `EMA200_Ott` **971501** | XAUUSD H4 | `344a11b` 04/08 | #8 sizing |

### 🟠 ARANCIONE — vecchie, ma **il comportamento sarebbe identico** (20)
`BreakingBand` ×3 (GBPUSD/EURUSD/AUDUSD, `24f4b7a`) · `GapFill` ×5
(`a766659`) · `PunteLarry` ×6 (`cb7dc20`) · `CostToCost` ×2 (`9b1c611`) ·
`EasyTrend` ×2 (`95bc4ec`) · `GapContinuation` (`7246558`) ·
`MaxMinNotte_DAX_Short_Ott` **770411** (`6074126`).
👉 Tutto ciò che manca a queste 20 è **#9 (il filo fail-open)** e **#10
(opt-in a default storico)**. **Ricompilarle non muoverebbe un lotto.**

### 🟢 VERDE — allineate al repo (5)
`ORB_Ottimizzato` **770611** (v1.04 `19312c8`) · `PostNews` ×3 (`61dc18c`) ·
`TradeExporter` (`76c79de`).

---

# 3. 🎯 IL CASO `ABTG_Nasdaq_Apertura_US` — IL DANNO ESATTO, E LA RIGA DA FIRMARE

## 🔴 Il fatto, in tre righe verificate da me
- `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` **riga 47**: `#define ABTG_DEF_RISK 2.0`
  — e **anche** riga 119 (il ramo `#ifndef`, che è la seconda porta dello stesso
  numero: chi ripara solo la 47 lascia il 2.0 vivo).
- Il gemello DAX è a **1.0 dal 02/09 con la ragione scritta**
  (`ABTG_DAX_Apertura_EU.mq5:90`): *"il default compilato era il DOPPIO del
  contratto (1,0%) e della riga rossa A4: ogni RIPRISTINA rimetteva il 2%.
  FIX firmato C4."*
- `git log -S "ABTG_DEF_RISK         2.0"` sul file Nasdaq: **il numero non è
  mai stato toccato**. `9638318` lo ha corretto **solo** sul DAX.

## 📏 IL DANNO, calcolato sui numeri del contratto (non a memoria)
Sedia **770250**, `ABTG_GatedShort_NASUSD_770250_LIVE.set` r.44 →
**`InpRiskPercent=0.35`**. Contratto `report/CONTRATTO_GATEDSHORT_770250.md`:
**DD promesso ~2,4%**, scalato linearmente dal **4,54% misurato a 0,65%**.

| grandezza | oggi (preset) | dopo un click su **Ripristina** | fattore |
|---|---:|---:|---:|
| rischio per trade | **0,35%** | **2,00%** | **5,71×** |
| DD atteso (scala lineare del contratto) | ~2,4% | **~13,7%** | 5,71× |
| DD atteso (scala dal 4,54% misurato @0,65%) | — | **~13,97%** | — |
| quota del cap C1 (3,25%) presa da **UN SOLO** stop vivo | 10,8% | **61,5%** | 5,71× |
| stop pieni per arrivare alla **pausa morbida 4,0%** | **11,4** | **2,0** | — |
| stop pieni per arrivare al **blocco totale 9,9%** | 28,3 | **5,0** | — |

🔴 **E il DD atteso (~13,7–14,0%) sfonda il muro del 9,9%.** Su una challenge
prop quello non è un drawdown: è la fine della challenge.

## 🚨 E QUI C'È LA COSA CHE NESSUN REFERTO AVEVA MESSO INSIEME
Sulla **stessa** sedia **770250**, sullo **stesso** conto, si sommano **tre
guasti indipendenti**:

1. 💥 `DEF_RISK 2.0` → un Ripristina mette **2,0%** (5,71× la taglia);
2. 💥 **la guardia A4 `storicoOk` non è nel binario in campo** (#3) → al riavvio
   del terminale la sedia può **armarsi una seconda volta nello stesso giorno**;
3. 💥 **sul piccolo il Guardian NON GIRA** → **nessuna** pausa al 4,0%,
   **nessun** cap al 3,25%: non c'è niente che fermi il secondo colpo.

👉 **Messi in fila: 2 × 2,0% = 4,0% di rischio vivo in una giornata, da UNA
sola sedia, senza nessun freno a valle.** Nessuno dei tre, da solo, l'avrebbe
prodotto. 🟢 È un demo, quindi **non è un'emergenza di cassa** — ma è
**esattamente** la configurazione che stiamo per portare in prop, e il conto
piccolo è il banco da cui leggiamo le frequenze.

## ✍️ LA RIGA DA FIRMARE — **non l'ho scritta nel codice, è di Claudio**

> **FIRMA C4-bis (Nasdaq).** In `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5`
> porto `#define ABTG_DEF_RISK` da **2.0 a 1.0** in **tutti e due** i punti
> (**r.47** e **r.119**), con la stessa motivazione già firmata sul DAX il
> 02/09. Costo dichiarato e accettato: **i default dei backtest futuri di
> questo EA si dimezzano** (i backtest passati **non** cambiano: i `.set`
> portano il rischio esplicito). Rinomino il preset legacy se esiste, come
> fatto sul DAX (`..._LEGACY_2pct.set`). **Non tocco nessun preset in campo:
> la sedia 770250 continua a girare a 0,35%.**
>
> Firma: ______________________  Data: ____________

⚠️ **La firma NON basta a chiudere il caso.** Il `2.0` che gira **oggi** nel
binario del piccolo si spegne **solo ricompilando**, e ricompilare quel file
porta dentro anche `#3` (che è un bene) — e **`b5d904a`, che è un WIP mai
integrato** (§4.1). 👉 Il bersaglio di compilazione è **`d83c196`**, non HEAD.

---

# 4. 🧰 IL PACCHETTO DI RICOMPILAZIONE

## 4.1 🔴 IL BERSAGLIO NON È `HEAD`. E questa è la scoperta più importante per l'esecuzione.

`HEAD` contiene **due commit dichiarati NON compilabili dai loro stessi autori**:

| commit | data | cosa dice | file di EA toccati |
|---|---|---|---:|
| `b45dd00` | 11/09 | *"**IN CORSO D'OPERA — NON COMPILARE**: questi file NON sono verificati, NON sono passati dal cancello... NESSUNO DI QUESTI EA VA COMPILATO O CARICATO finché non c'è un PASS"* | **11** (+1.544 righe) |
| `b5d904a` | 29/08 | *"WIP FASE 2 DRIVE... Build ancora in corso"* — ed **è ancora HEAD** per il Nasdaq | **1** (+198) |

✏️ **DUE NUMERI CORRETTI DAL CANCELLO, e li dico io (classe 261).**
🔴 **(a)** questa tabella diceva *"**10** file di EA"* per `b45dd00`, copiato dal
**titolo del commit** (*"10 EA e 2 strumenti"*): il commit **ne tocca 11 di EA e
3 di strumenti** — si era contato male il suo stesso autore, e io gli ho
creduto invece di contare l'albero.
🔴 **(b)** il peso dell'F7 **non è 2.208 righe**: quello è il totale di
`git show --stat b45dd00` e comprende **664 righe** di `controlla_riga.py`,
`controesempi_cancello.py` e `CODA_08_preset_dai_chr.ps1`, **che nessun F7
compila**. Il numero giusto è **1.544** (codice EA di `b45dd00`) **+ 198**
(`b5d904a`) = **1.742 righe su 12 file**.
🟢 **La conclusione non si muove di un millimetro** — 1.742 righe non verificate
sono un motivo pieno per non compilare `HEAD` — **era il numero a essere
gonfiato del 27%**, e un numero gonfiato costa la fiducia negli altri numeri
della stessa pagina, che erano giusti.

🔴 **E I DUE INSIEMI DA 11 NON SONO LO STESSO INSIEME.** Avevo scritto *"chi
preme F7 su uno di questi 11 file compila codice non verificato"*, saltando
dagli 11 file del WIP agli 11 bersagli della riga **perché hanno lo stesso
numero**. Elencati per nome e diffati:
- **3 bersaglio che nessun WIP tocca** (per loro `HEAD` **è** il bersaglio, e la
  tabella qui sotto lo dice già): `ABTG_SupRev_DAX_H4_Ottimizzato`,
  `ABTG_SupRev_NAS_H1_Ottimizzato`, `ABTG_ORB_Ottimizzato`;
- **4 file del WIP che non sono bersagli**: `ABTG_PTE_Ottimizzato`,
  `ABTG_SuperWave_DAX_H4_Ottimizzato` (nessuna sedia viva), `ABTG_CostToCost` e
  `ABTG_GapContinuation` (🟠 arancioni, passo **11**).

👉 La frase giusta è: **chi preme F7 sui 12 file toccati dai due WIP compila
codice non verificato.** Ecco il **bersaglio giusto** per ognuno degli **11 che
questa riga collauda** — l'ultimo commit **non-WIP** che tocca quel file:

| EA | 🎯 bersaglio (commit) | data | versione | righe | contiene la riparazione |
|---|---|---|:---:|---:|---|
| `ABTG_SupertrendReversal` | **`872dba8`** | 08/09 | 1.01 | 665 | #2 lotto doppio ✅ |
| `ABTG_SupertrendReversal_Ottimizzato` | **`872dba8`** | 08/09 | 1.01 | 614 | #2 ✅ |
| `ABTG_SuperWave` | **`872dba8`** | 08/09 | 1.01 | 637 | #2 ✅ |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | **`872dba8`** | 08/09 | 1.01 | 645 | #2 ✅ |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | **HEAD** (`872dba8`) | 08/09 | 1.01 | 615 | #2 ✅ (non è nel WIP) |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | **HEAD** (`872dba8`) | 08/09 | 1.01 | 652 | #2 ✅ (non è nel WIP) |
| `ABTG_PTE` | **`26a1856`** | 19/08 | 1.01 | 649 | #8 sizing ✅ |
| `ABTG_EMA200` | **`26a1856`** | 19/08 | 1.00 | 552 | #8 ✅ |
| `ABTG_EMA200_Ottimizzato` | **`65de32c`** | 11/09 | 1.00 | 606 | #8 ✅ + il fix dell'**errore di compilazione** di `6ee2ec0` |
| `ABTG_Nasdaq_Apertura_US` | **`d83c196`** | 19/08 | 1.02 | **2382** | **#3 guardia A4** ✅ — 🔴 **ma con `DEF_RISK 2.0`**: serve prima la firma §3 |
| `ABTG_CostToCost` · `ABTG_GapContinuation` | `26a1856` | 19/08 | — | — | nessuna money (arancione) |
| `ABTG_ORB_Ottimizzato` · `ABTG_DAX_Apertura_EU` · `ABTG_Dow_Apertura_US` · `ABTG_MaxMinNotte` · `ABTG_Guardian` | **HEAD** | — | — | — | 🟢 **non toccati da nessun WIP** |

## 4.2 🔬 IL PREREQUISITO DI OGNI PASSO: la compilazione di PROVA, fuori dai terminali vivi

⚠️ **Non posso compilare qui**: in questo ambiente non c'è MetaEditor. Ogni
"compila" di questo pacchetto è un'azione **sulla macchina di Claudio**.

Il modello esiste già e ha funzionato: `backtest_pipeline/righe/RIGA_COMPILA_ORB104.ps1`
compila in un albero di lavoro sotto `%USERPROFILE%`, chiamando
`metaeditor64.exe` con `/inc`, **senza toccare il `MQL5\Experts` di nessun
terminale**, e dimostra con una foto prima/dopo di non aver scritto niente.
La riga generalizzata ai bersagli di §4.1 è preparata in
`backtest_pipeline/righe/RIGA_COLLAUDO_RICOMPILA.ps1` (+ `_DA_MANDARE.md`).

🖥️ **Bersaglio della riga: finestra PowerShell sul PC/banco di BACKTEST,
terminale `50504400` = `C:\MT5_Backtest`.** 🔴 **NON toccati:** `50503392`
(`C:\Program Files\BCM Markets MT5 Terminal`), `50504263`
(`...MT5 Terminal -V3`), `10105439` (`C:\BCM_Reale`), Pepperstone, Tickmill.
La riga **rifiuta** quei percorsi per costruzione.

📌 **Due lezioni già pagate, incorporate**: (a) `metaeditor64` **deve essere
chiuso**, altrimenti torna `rc=0` **senza compilare** (22/08); (b) **gli include
si censiscono, non si indovinano** (il primo giro del 22/08 fallì perché lo
script non portava `ABTG_PausaGuardian.mqh`).

## 4.3 🪑 QUALI SEDIE VANNO STACCATE E RIATTACCATE

**Regola meccanica di MT5, non un'opinione:** ricompilare un `.ex5` mentre l'EA
è attaccato fa fare a MT5 un `OnDeinit`/`OnInit` **conservando gli input del
grafico**. Quindi:

| caso | serve staccare? | perché |
|---|:---:|---|
| ricompilazione dello stesso file, preset già caricato sul grafico | **NO** | gli input del grafico **sopravvivono**; il reload è automatico. **Ed è la via preferita: un Ripristina è esattamente il rischio di §3** |
| `Guardian` v1.11 → v1.12+ sul 100k | **NO staccare**, ma 🔴 **NON a mercato aperto con posizioni vive**: le GV cambiano nome in `_V2` e la baseline/picco **si ricatturano da zero** | fix `d884f7e` |
| sedia con **input NUOVI** (es. `InpLogImbuto`, `InpFloorPolicy`) | **NO** | un input nuovo prende il suo default compilato; gli esistenti restano |
| 🔴 **mai** | **premere "Ripristina"** nella finestra input | rimette i default compilati → §3: sul Nasdaq **2,0%** |

👉 **Conclusione: nessuna sedia va staccata.** Il gesto è *ricompila → l'EA si
ricarica → si legge la scheda Esperti*. Lo **stacca/riattacca** serve solo se
si vuole cambiare preset, e **allora** il preset va ricaricato **da file**,
mai col Ripristina.

## 4.4 🔎 LA VERIFICA CHE CHIUDE IL BUCO PIÙ GRANDE, e non è mai stata fatta

🔴 **Tutto questo referto misura il `.mq5` accanto all'`.ex5`, non l'`.ex5`.**
MT5 esegue il **binario**. La prova diretta **esiste e costa trenta secondi**:
`872dba8` ha alzato apposta la versione **1.00 → 1.01** *"per riconoscere dal
titolo della finestra MT5 se il terminale ha l'EA corretto o quello vecchio"*.
**Quella lettura non è mai stata fatta.**

✋ **Azione a mano dentro MT5** — e **prima** di riconoscere qualsiasi finestra,
🖥️ **finestra PowerShell sul VPS** (legge e basta, non apre né chiude niente,
non tocca nessuna delle **sei** cartelle dati):

```
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```

Poi, **sul terminale che quella stampa identifica come
`C:\Program Files\BCM Markets MT5 Terminal` = conto `50503392` (demo piccolo)**:
scheda **Esperti** → cercare la riga di avvio di `ABTG_SupertrendReversal`.
🟢 Se dice **1.01** il fix del lotto doppio è già in campo (e mezzo referto va
riscritto). 🔴 Se dice **1.00**, è confermato.

---

# 5. 🧪 I CONTRO-ESEMPI — costruiti per FARMI SBAGLIARE, uno per ogni "questa morde"

> 🔴 Regola del 10/09: *per ogni "questa differenza morde" costruisco il caso in
> cui **non** morderebbe e mostro perché non si applica.* **Due su sette mi hanno
> corretto.**

### 5.1 #9, il filo del Guardian — *"+3 righe che toccano il trading"*
**Il caso in cui non morde:** se l'include è **fail-open**, le 3 righe non
cambiano niente dove il Guardian non gira.
**Verificato nel codice, riga per riga** (`ABTG_PausaGuardian.mqh`):
`ABTG_GuardiaIngresso` **r.1719** → `if(!ABTG_CanaleEsiste()) return(true); // 2. nessun guardiano su questo conto`.
E ho provato anche **l'ipotesi cattiva** ("una GlobalVariable rimasta appesa
potrebbe bloccare"): no — `ABTG_PausaAttiva_Calc` scade **da sola in 24h** se
manca `ts_fino` (r.328), `ABTG_CapAttivo_Calc` scade alla tolleranza (r.339), e
il motivo 3 richiede `pretendi_guardian=true` che **nessuna** di quelle sedie
passa. Sul piccolo il Guardian **non gira** (`CODA_09`, 10 **e** 11/09, su log
pieni). 👉 ✅ **NON MORDE. Verde confermato.**

### 5.2 #2, il lotto doppio — *"forse il regime non si presenta mai"*
**Il caso in cui non morde:** serve `InpUsePending=true` **e**
`totLot × InpFirstFraction` che normalizza a **0**, cioè `totLot < 3 × volMin`.
**Provato sui preset veri delle 7 sedie**: `InpUsePending=true` e
`InpFirstFraction=0.3333` in **tutti**.
🎯 **E l'aritmetica torna sul caso osservato**: SW DOW H2, **due gambe da 0,10**
— con `volMin=0,10` su U30USD e `totLot=0,10`, la tranche 0,0333 normalizza a 0,
`lotPend` prende tutto (0,10) e `lotMkt` risorge a 0,10: **0,20 invece di 0,10 =
esattamente 2×**, e il P/L misurato dà **1,42% su un contratto 1,0%**.
👉 🔴 **MORDE, e il meccanismo è confermato da un secondo calcolo indipendente.**

### 5.3-ante ✅ **LA PROVA DIRETTA DI #3 E #4, per grep, non per data**
Le date dei commit dicono *quando*. Ho voluto la prova che dice *cosa*:

| oggetto | comando | atteso | ottenuto |
|---|---|---|---|
| `DAX_Apertura_EU` @ `3af47ed` (**in campo**) | `grep -c storicoOk` | 0 | **0** ✅ |
| `Dow_Apertura_US` @ `3af47ed` (**in campo**) | idem | 0 | **0** ✅ |
| `Nasdaq_Apertura_US` @ `3af47ed` (**in campo**) | idem | 0 | **0** ✅ |
| `DAX_Apertura_EU` @ `9638318` (**bersaglio**) | idem | >0 | **7** ✅ |
| `Dow_Apertura_US` @ `d83c196` (**bersaglio**) | idem | >0 | **7** ✅ |
| `Nasdaq_Apertura_US` @ `d83c196` (**bersaglio**) | idem | >0 | **7** ✅ |

👉 **La guardia A4 è assente dai tre binari in campo e presente nei tre
bersagli. Non è un'inferenza dalle date: è un conteggio.**
E per **#4** la stessa cosa sul blocco del breakeven: nel blob **in campo**
(`0823951`, r.301-303) il `PositionModify` di pareggio è **dentro**
`if(cv>0 && cv<vol && PositionClosePartial(...))`; nel repo di oggi (r.422-430)
`parzOK` è un **bool separato** e `beFatto` non dipende da lui. 👉 **Il difetto
c'è nel campo e la cura c'è nel bersaglio, letti entrambi.**

### 5.3 #3, la guardia A4 — *"è un difetto solo al riavvio"*
**Il caso in cui non morde:** (a) se `InpOneTradePerDay=false` il blocco non
gira affatto; (b) serve un riavvio con lo storico non ancora sincronizzato.
- (a) **smentito**: `InpOneTradePerDay=true` in **tutti** i preset vivi di
  770101, 770202, 770250, 770411, 770611, 770402.
- (b) ⚠️ **VERO, ed è il limite**: serve un riavvio di terminale/EA. **Ma il
  caso non è ipotetico**: è nel giornale col **ticket e il millisecondo**
  (14/08 16:17:43, lotto 1,90, gli stessi due prezzi delle 09:25).
👉 🔴 **MORDE, condizionato a un riavvio — e i riavvii su quel VPS ci sono.**

### 5.4 #4, il breakeven — *"il lotto sarà sopra il minimo"*
**Il caso in cui non morde:** se `vol ≥ 2 × volMin`, `NormVol(vol×50%) > 0`, il
parziale parte e il breakeven con lui.
**Letto il blob in campo** (`0823951`, r.301-303): il `PositionModify` di
pareggio è **dentro** `if(cv>0 && cv<vol && PositionClosePartial(...))`. Il
preset vivo ha `InpTP1_R=1.0`, `InpTP1Pct=50` → parziale **attivo**.
👉 🔴 **MORDE se e solo se il lotto di 770402 è `0,01`.** Il caso misurato
(**112,78 EUR**) era **oro a 0,01 lotti**, cioè lo stesso simbolo e la stessa
taglia. ⚠️ Il lotto vivo di 770402 **oggi** è `[DA MISURARE]` — si legge dal
primo ordine nel giornale. **Non lo dichiaro misurato.**

### 5.5 ❌ #8, il sizing — **IL CONTRO-ESEMPIO MI HA CORRETTO**
**Il caso in cui non morde**, testuale dal commit `3af47ed`: *"Sui simboli sani
i due calcoli **coincidono**: il comportamento cambia **SOLO** dove il tick
value mente"*. Il difetto è misurato **su 225JPY**.
**Allora ho elencato i simboli delle 11 sedie**: U30USD ×4, GBPUSD ×2, XAUUSD
×3, D30EUR, NASUSD. 🎯 **Nessuna su un simbolo JPY.** E le tre sedie vive su
**225JPY** (`SupertrendReversal` 770924, `GapFill` 772235, `GapContinuation`
774101) hanno **tutte** un binario **successivo** a `3af47ed`.
👉 🟠 **Declassato da 🔴 a `[NON MISURATO]`.** Che il tick value BCM menta anche
su U30USD/NASUSD/XAUUSD **non è stato misurato**, e la misura è a costo zero:
sul primo trade nuovo si confronta il lotto piazzato col rischio dichiarato.
**Se avessi contato solo i commit, questa restava in rosso a torto.**

### 5.6 ❌ #6, il `DEF_RISK` — **IL CONTRO-ESEMPIO MI HA CORRETTO DI NUOVO**
**Il caso in cui non morde:** il preset del grafico **vince** sul default
compilato. Verificato: `InpRiskPercent` è esplicito in tutti i `.set` vivi.
👉 🟠 **Oggi il danno è ZERO.** È una **mina**, non un incendio. **La riga
onesta è "latente", non "sta sforando".**

### 5.7 ✅ E la prova che rende il match un FATTO (la classe di errore del 12/09)
> 🔴 Il 12/09 un Guardian è stato identificato **dal numero di righe** mentre
> `#property version` stava in un log. **Non lo rifaccio.** E la versione **da
> sola** non basta: `DAX_Apertura_EU` sul 100k è **v1.01 come il repo** e porta
> `DEF_RISK 2.0`.

| ipotesi che demolirebbe questo referto | come l'ho provata | esito |
|---|---|---|
| *"hai datato confrontando col repo di oggi"* | no: ricerca su **tutta la storia di git**, file per file, del commit con **quel** conteggio esatto | ✅ **datato** |
| *"il match è ambiguo, più commit hanno lo stesso conteggio"* | contati i match: **`n=1` su 22 EA su 23**. L'unico `n=2` è `BreakingBand` (contenuto **identico** nei due, quindi indifferente) | ✅ **non ambiguo** |
| *"versione + righe bastano per dire se morde"* | no, e lo dimostro col **diff**: `872dba8` è **+11/−2** (più piccolo del filo del Guardian, che è +3) e **raddoppia il lotto** | ✅ **serve il diff, sempre** |
| *"il campo compila `standalone/`"* | i match cadono **tutti** sul ramo principale `mql5/Experts/`; ri-verificato da me su PTE (525), SuperWave (563), Guardian 100k (467) | ❌ **smentita** |
| 🔴 *"il DEF_RISK 2.0 sta già sforando le taglie"* | letti i `.set`: l'input vince | ❌ **smentita — §5.6** |
| 🔴 *"il fix di sizing manca a 11 sedie, quindi 11 sedie sono mal dimensionate"* | elencati i **simboli**: zero JPY | ❌ **smentita — §5.5** |
| *"le 20 arancioni sono comunque un rischio"* | letti gli input **uno per uno**: `0`/`false`/`modo 0` | ❌ **smentita — §5.1** |

---

# 6. 📋 ORDINE DI ESECUZIONE — con il rischio di ogni passo

🔴 **Legenda:** ✍️ = **serve la firma di Claudio** (rischio/taglie) · 🤖 = lavoro
che può fare un agente · 👁️ = sola lettura, rischio zero.
🚫 **Nessun passo tocca il conto reale 10105439.**

| # | passo | bersaglio (in chiaro) | rischio | chi |
|---:|---|---|---|:---:|
| **0** | Leggere `Get-Process terminal64 \| Select Id, MainWindowTitle, Path` e poi, sul terminale così identificato, la **versione nella scheda Esperti** di `ABTG_SupertrendReversal` | 🖥️ PowerShell **sul VPS** (legge) + ✋ a mano nel terminale `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`) | **ZERO** | 👁️ |
| **1** | Leggere gli input del `Guardian` sul **reale** e verificare 4,9 / 9,9 / reset 23 | ✋ a mano, terminale `10105439` (`C:\BCM_Reale`) — **riconosciuto dalla stampa del passo 0, mai a occhio dal titolo** — grafico **EURGBP H1** — **solo leggere**. 🔴 **SI ESCE CON `Annulla`, MAI CON `OK`, E NON SI SFIORA `Ripristina`**: è l'**unico conto con i soldi**, e un `Ripristina`+`OK` lì rimette i **default compilati** (§3 e §4.3). Precedente di casa: 03/09, *"piccolo verificato a 1,0% e chiuso con Annulla"* | **quasi zero: l'unico rischio è il dito, e si chiude con `Annulla`** | 👁️ |
| **2** | 🔬 **Compilazione di PROVA** degli 11 bersagli di §4.1, in albero di lavoro | 🖥️ PowerShell sul **banco di backtest**, terminale `50504400` = `C:\MT5_Backtest`. 🔴 **NON** `50503392`, **NON** `50504263`, **NON** `10105439` | **ZERO** (non scrive in nessun terminale) | 🤖 |
| **3** | ✍️ **FIRMA C4-bis**: `DEF_RISK` 2.0→1.0 sul Nasdaq, r.47 **e** r.119 | repo (nessun terminale) | cambia i **default** dei backtest futuri | ✍️ |
| **4** | ✍️ **100k — `ORB_Ottimizzato` v1.02 → v1.04**: ricompilare e leggere la versione | ✋ terminale `50504263` = `C:\Program Files\BCM Markets MT5 Terminal -V3` | **il più alto beneficio della lista** (smette di gestire la posizione del vicino). Porta dentro *"atteso: MENO trade sui giorni con vicini"* — **lo dichiara il commit stesso** | ✍️ |
| **5** | ✍️ **100k — `SupertrendReversal` v1.00 → v1.01** (bersaglio `872dba8`, **non HEAD**) | ✋ terminale `50504263` (`...MT5 Terminal -V3`) | **miglior rapporto della lista**: toglie un raddoppio di taglia **misurato** e non cambia nessuna condizione d'ingresso | ✍️ |
| **6** | ✍️ **100k — `Guardian` v1.11 → v1.14** (v1.14, non v1.12: il delta v1.12→v1.14 è **spento di default**, già verificato) | ✋ terminale `50504263` (`...MT5 Terminal -V3`) | 🔴 **a mercato CHIUSO e senza posizioni vive**: le GV `_V2` ricatturano baseline e picco | ✍️ |
| **7** | ✍️ **100k — `DAX_Apertura_EU`** → `9638318` (chiude il `DEF_RISK 2.0` latente) | ✋ terminale `50504263` (`...MT5 Terminal -V3`) | basso: cod **+2/−2** | ✍️ |
| **8** | ✍️ **piccolo — la famiglia SupRev/SuperWave, 6 sedie** → `872dba8` | ✋ terminale `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`) | demo. ⚠️ porta dentro **un mese** di modifiche (+125…+161 cod l'una): **una famiglia per volta**, col rapporto dei lotti prima/dopo come prova | ✍️ |
| **9** | ✍️ **piccolo — la famiglia Apertura, 3 sedie** (DAX 770101, Dow 770202, Nasdaq 770250) → `d83c196` (+ `9638318` per il DAX) | ✋ terminale `50503392` (`...BCM Markets MT5 Terminal`) | demo. Porta la **guardia A4** (#3). 🔴 **Il Nasdaq solo DOPO il passo 3**, altrimenti si ricompila il `2.0` | ✍️ |
| **10** | ✍️ **piccolo — `MaxMinNotte` 770402** → HEAD | ✋ terminale `50503392` (`...BCM Markets MT5 Terminal`) | 🔴 **NON è un allineamento: è un EA diverso** (+533/−369 cod). Porta #4 **e** #7 (**attesi MENO trade**, lo dichiara il commit). Va trattato come **candidato che rientra nell'imbuto**, con backtest con e senza il flag | ✍️ |
| **11** | 🤖 Le **20 arancioni** del piccolo | — | ⏸️ **NON URGENTE**: comportamento identico. E il filo del Guardian serve **solo se prima si attacca il Guardian** su quel terminale (l'ordine è **l'inverso** di quello che sembra) | 🤖 |

## ✍️ I PASSI DI SOLA FIRMA DI CLAUDIO — l'elenco secco
**3, 4, 5, 6, 7, 8, 9, 10.** Tutti quelli che **cambiano una taglia, uno stop o
la gestione di un'uscita in campo**. I passi **0, 1, 2** e **11** non ne hanno
bisogno: leggono, o compilano fuori dai terminali vivi.

## ❌ E QUELLO CHE NON PROPONGO
**"Ricompila tutto"**, e ho un motivo nuovo: `HEAD` **contiene 12 file
dichiarati non compilabili dai loro stessi commit**. Un F7 largo sul repo di
oggi non sarebbe un allineamento: sarebbe portare in campo **1.742 righe di
codice EA non verificate** in un colpo solo (numero corretto dal cancello: il
`2.208` che avevo scritto comprendeva **664 righe di `.py` e `.ps1` che
MetaEditor non compila** — classe 261).

---

# 7. 🕳️ BUCHI DICHIARATI

1. 🔴 **Nessuna prova diretta del contenuto di un `.ex5`.** Si misura il `.mq5`
   accanto + la data del binario. Il passo **0** la chiude in trenta secondi.
2. 🔴 **`ABTG_MaxMinNotte` 770402: il lotto vivo è `[DA MISURARE]`** — e decide
   se #4 morde (§5.4).
3. 🔴 **Che il tick value BCM menta anche su U30USD / NASUSD / XAUUSD / D30EUR
   è `[NON MISURATO]`** (§5.5). Finché non lo è, #8 resta arancione.
4. 🔴 **La co-presenza temporale ORB/Dow su U30USD sul 100k è `[NON MISURATO]`**:
   i due sono sullo stesso simbolo e sulla stessa apertura US M5 (quindi
   l'incrocio è **atteso**), ma la sovrapposizione **su quel conto** va letta
   dal giornale. Sul **piccolo** un caso analogo è **osservato** (FOTO A, 02/09).
5. 🔴 **Il danno in euro di #5 sul 100k resta `[NON MISURATO]`**: i log stampano
   l'equity ma non bilancio e credito separati.
6. ⚠️ **`CODA_06` del 10, 11 e 12/09 sono identici byte per byte** tranne la
   data: **il campo non si muove da tre giorni**. Tutti i numeri qui valgono
   **alla foto del 12/09 03:30**.
7. ⚠️ **Non posso compilare né fare backtest in questo ambiente**: ogni "0
   errori" di questo pacchetto è una **previsione da verificare con F7**.

---

# 🧭 IN UNA RIGA

🟢 **Il conto con i soldi è pulito e resta fuori da questo lavoro.** 🔴 **Il
conto che simula la challenge è fermo al 19-22 agosto con quattro riparazioni
che tocca i soldi già scritte e mai arrivate.** 🆕 **E sul piccolo ne ho trovate
tre che nessun referto aveva nominato — una osservata in campo col
millisecondo.** 🎯 **Il bersaglio di ricompilazione NON è `HEAD`: 12 file
(1.742 righe di codice EA) sono dichiarati non compilabili dai loro stessi
commit, e adesso c'è la tabella dei bersagli giusti.** 🚀 **Non ci accontentiamo: due dei miei sette allarmi li ha
declassati il contro-esempio, e vanno letti così.**
