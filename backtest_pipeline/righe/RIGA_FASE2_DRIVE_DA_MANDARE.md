# 📬 FASE 2 DRIVE — **LA RIGA DA MANDARE**

**Che cos'è:** lo **screening dell'ablazione a stella** del filtro di selezione
sul **motore delle aperture** (drive-following). EA
`ABTG_Nasdaq_Apertura_US`, già **compilato e vivo in forward**, su
`NASUSD_EXT M15`, **4 celle**. Contratto firmato:
`risultati_archivio/STUDIO_APERTURE_FASE2_CRITERI_BOZZA.md` ("FIRMO LA FASE 2",
29/08/2026). Anatomia: `risultati_archivio/LETTURA_ANATOMIA_APERTURE_2026-08-26.md`.
Amendamento de-2022: `caccia_strategie/CACCIA_NASDAQ_DRIVE_2026-08-29.md`.

> 🔴 **QUESTO È UNO SCREENING. NON PROMUOVE NIENTE E NON DÀ UN VERDETTO.**
> Gira a **MODELLO 1 (OHLC)**: si legge la **FORMA** dell'edge (verde/rosso,
> ordini di grandezza, coerenza fra le celle), **MAI i numeri fini**. Il
> **verdetto a tick** è possibile **solo sulla cassaforte 2024.09 → 2026 (BCM)**,
> che si apre **dopo**. **G5 non tocca il forward: è una MISURA, non una promozione.**

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` (già compilato/vivo in forward) |
| **Driver** | `righe/RIGA_FASE2_DRIVE.ps1` (marcatore `MARCATORE_RIGA_FASE2_DRIVE_v1`) |
| **File prova** | `prove/FASE2_NAS_00_baseline.txt` · `01_F1_k10` · `02_F1_k15` · `03_F3_ema` |
| **Include** | `mql5/Include/ABTG_PausaGuardian.mqh` (l'EA lo `#include`; il driver lo installa) |

---

## 🎯 LE QUATTRO CELLE — ablazione **a stella**

| cella | file prova | cosa cambia dal baseline | magic gemelli |
|---|---|---|---|
| **00_baseline** | `FASE2_NAS_00_baseline.txt` | **niente** — F1 **off** (0.0), F3 **off** (0) | 767200 / 767201 |
| **01_F1_k10** | `FASE2_NAS_01_F1_k10.txt` | **F1** `InpMinBreakoutRangeATR` 0.0 → **1.0** | 767210 / 767211 |
| **02_F1_k15** | `FASE2_NAS_02_F1_k15.txt` | **F1** `InpMinBreakoutRangeATR` 0.0 → **1.5** | 767220 / 767221 |
| **03_F3_ema** | `FASE2_NAS_03_F3_ema.txt` | **F3** `InpUseEmaFilter` 0 → **1** (EMA 14/200 su H1) | 767230 / 767231 |

Ogni cella muove **UN SOLO interruttore** rispetto al baseline (più il magic), e
il driver lo **verifica prima di aprire MT5** (gate della stella). **Nessuna
cella accende due feature insieme** — c'è un gate apposta. I **magic sono
VERGINI**: blocco `7672xx`, cercato in tutto il repo il **2026-08-29** → **zero
occorrenze**. L'unico asse `Y` è `InpMagic` (i gemelli di controllo): se un file
ne porta un secondo, il driver **si ferma**.

- 🎛️ **Gestione TUTTO-RUNNER, fissa in tutte e 4** (contratto §3):
  `InpRunnerTP_R=-1` (nessun cap, il residuo corre verso la coda) e
  `InpTP1_ClosePct=0` (non si chiude nulla al primo obiettivo). Il gate li
  pretende identici in ogni cella.

---

## 🕒 IL FUSO — **INVERTITO** rispetto alla regola di casa (critico)

Su `NASUSD_EXT` il feed HistData è a **ora di NEW YORK**: l'anatomia ha
**misurato** (canarino DST verde) che le **09:30 del file sono l'apertura cash
tutto l'anno**. Perciò il gate **PRETENDE**:

| input | valore | perché |
|---|---|---|
| `InpSessionHour` | **9** | apertura cash NY 09:30 sul feed `_EXT` |
| `InpSessionMin` | **30** | " |

⚠️ **Il gate RIFIUTA `InpSessionHour=14`.** Il 14:30 SERVER (regola di casa
`IT − 1 = server`) è l'apertura sul **feed tick BCM** (`NASUSD`) e vale **SOLO
per la cella di validazione a tick della cassaforte**, **non** per questo
screening `_EXT`. **Su `NASUSD_EXT` il fuso è NY cash 9:30, non 14:30 server.**

---

## 🧱 GLI ALTRI GATE che questo driver fa rispettare, prima di MT5

- 🛑 **Pavimento SL (R109):** `InpMinStopPts=500` (5 punti indice), **mai 0**;
  `InpSkipIfTight=0` (il pavimento **si applica**, non fa saltare il trade). Il
  gate **rifiuta lo 0**.
- ⭐ **Stella:** ogni cella differisce dal baseline **solo** per la feature
  dichiarata + il magic; ogni altro parametro **deve** coincidere.
- 🔢 **Feature-value:** i valori di F1/F3 sono pinnati esatti per cella — prende
  anche il caso di **due file scambiati**.
- 🪪 **Magic:** vergini, unici, mai uno **vietato** (sorgente `773500`, i blocchi
  vivi/round recenti, e i sei del PASSO 0 `7677xx`).

---

## 📐 FINESTRA — **una sola tranche**

Finestra **2017.01.01 → 2020.07.01** (~3,5 anni, sotto il tetto ~100k barre di
M15), **multi-regime**: toro 2017, orso Q4-2018, laterale 2019, crollo+V covid
2020. **Niente split IS/OOS interno** (l'OOS vero è la cassaforte 2021-2026, che
si apre dopo). Il driver generico pretende una `FrazioneIS`: la riga gli passa
**`-FrazioneIS 1.0`**, così la sua gamba **"IS" è la finestra intera** e la gamba
"OOS" è un intervallo **degenere** (0 giorni, zero passate) che **si ignora**.
La tabella legge **solo la finestra intera**.

> 📊 **La lettura per REGIME si fa A MANO dal per-trade CSV**, esportato in
> `Common\Files`: `abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_EXT_<magic>.csv`,
> colonne `close_time` (per anno/regime) e `net_profit` (l'esito). Si somma
> `net_profit` per finestra di regime e si guarda **aspettativa/trade E DD** di
> ciascun regime, feature per feature. **Il totale 2017-2020 DILUISCE.**

---

## 📌 CRITERI DI LETTURA CONGELATI (contratto §5)

- **Decide l'ASPETTATIVA PER TRADE** (non solo il PF), con coerenza fra i
  sotto-periodi. **RISCHIO MAI SOSPESO** (regola B): **DD e peggior giornata**
  contro il muro prop, **sempre**, a qualunque `n`.
- **Campione:** **≥ 150 trade** per giudicare il **MERITO**; sotto, merito
  sospeso (il rischio no).
- **Vince la FASE 2** solo se un filtro (F1 o F3) dà **aspettativa/trade positiva
  e STABILE**, con **DD sotto il muro**. Un solo periodo = **non dimostrato**.

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ **Questa pagina è pronta ma NON ancora lanciabile.** Il driver, i quattro
> file prova, l'EA e l'include devono essere **committati e pushati** (lo fa
> Claudio, dopo il gate verificatore-stringhe); poi si **rilegge il pin DOPO il
> push** (mai prima) e lo si scrive qui al posto di `<PIN>`, in **tutti i punti
> d'uso** (`$pin='...'`). **La riga NON va lanciata con `<PIN>` dentro.**

La riga passa il pin a `-Pin` e **si rifiuta di partire senza** (un default
silenzioso `lavoro` farebbe girare la punta del branch spacciandola per un commit
congelato). Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per l'EA misurato**.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare (l'altro `#include`, `Trade\Trade.mqh`, è di serie).
- 🗂️ **`NASUSD_EXT` è storico ESTERNO (custom).** Il driver controlla
  `bases\Custom\history\NASUSD_EXT` **prima** di aprire MT5: se manca **si ferma
  con l'errore onesto** — va importato con la Riga dello storico esterno, **non**
  lo costruisce questa riga.
- 🧮 **Modello 1 (OHLC): è uno SCREENING.** L'EA gira già in forward: la
  compilazione qui è **attesa riuscire** e serve solo a garantire un `.ex5` al
  pin. Questa corsa **NON tocca il forward**.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic` (i gemelli).
- ⏱️ **Durata [STIMA, non una previsione]: dell'ordine di 10-30 minuti** più la
  compilazione (4 celle × una finestra × 2 gemelle a OHLC).

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_FASE2_DRIVE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_FASE2_DRIVE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_FASE2_DRIVE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine: `pin` e `celle ....... 4 su 4`; `driver generico
scaricato e PINNATO`; `file prova scaricati: 4`; `include scaricato:
ABTG_PausaGuardian.mqh (<n> byte)`; **`geometria, FUSO NY (9/30), pavimento SL
(R109), runner fisso, valori feature, stella (una feature sola) e magic: TUTTI
PASSATI`**; `simbolo custom: NASUSD_EXT TROVATO (<n> MB ...)`; `include:
INSTALLATO e VERIFICATO`; **`compilato ABTG_Nasdaq_Apertura_US: OK (<n> KB,
<ora>)`**; poi, per cella, l'anteprima dell'`.ini`; infine `ESITO: CONTROLLO
COMPLETATO`.

> ⚠️ **`-SoloControllo` non apre MT5.** Nessun `n`, nessun PF, nessun DD,
> **nessun controllo sui gemelli**. Conferma gli **artefatti**, mai i numeri.

> 🟡 **Nell'anteprima `.ini` del giro a vuoto vedrai `Model=4` — NON allarmarti.**
> È un quirk del driver generico (scrive `Model=4` fisso solo nell'anteprima di
> controllo). **La corsa VERA gira `Model=1` (OHLC screening)**, come dichiarato
> in testa. Il numero che conta è quello della corsa, non dell'anteprima.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_FASE2_DRIVE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_FASE2_DRIVE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_FASE2_DRIVE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

### 🔁 Se serve riprendere una cella sola

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_FASE2_DRIVE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_FASE2_DRIVE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_FASE2_DRIVE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '03_F3_ema' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `FASE2_DRIVE_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_FASE2_DRIVE.txt`** ← **è questo che conta** (tabella finestra intera
  + le 4 avvertenze di lettura + il puntatore al per-trade CSV per il regime);
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_Nasdaq_Apertura_US_NASUSD_EXT_IS_ohlc_<cella>.csv` (la finestra
  intera; il suffisso `_ohlc` è del Modello 1, l'`IS` è la tranche unica).

Le due righe da guardare per prime: **`modo:`** (`CORSA` o `CONTROLLO`) e
**`data:`** (deve essere di ADESSO).

---

## ✅ COSA È GIÀ STATO VERIFICATO — in questo ambiente, prima dell'invio

- ✅ il `.ps1` **parsa**: `[Parser]::ParseFile` → **0 errori**, **5.607 token**;
  **ASCII puro** (0 byte non-ASCII, regola del 17/08);
- ✅ **audit collisioni CASE-INSENSITIVE** sulle variabili: **zero collisioni**
  (baseline in `$hBase`, niente `$args` → si usa `$argv`);
- ✅ **i gate girano DAVVERO sui 4 file veri**: controllo **positivo passato**
  (4 celle, **8 magic unici** `767200/201/210/211/220/221/230/231`);
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** (12 corruzioni):

  | corruzione | il gate ha detto |
  |---|---|
  | `InpSessionHour=14` (**ora server**, vietata su `_EXT`) | `InpSessionHour=14 ora server, su _EXT va 9` |
  | `InpSessionMin=0` | `InpSessionMin deve essere 30` |
  | `InpMinStopPts=0` (**R109**) | `InpMinStopPts=0 VIETATO (R109)` |
  | `InpSkipIfTight=1` | `InpSkipIfTight deve essere 0` |
  | `InpRunnerTP_R=1` (cap sul runner) | `InpRunnerTP_R deve essere -1` |
  | `InpTP1_ClosePct=50` (chiude al TP1) | `InpTP1_ClosePct deve essere 0` |
  | **due feature insieme** (F3 nella cella F1) | `InpUseEmaFilter vale 1, vuole 0` |
  | **baseline con F1 acceso** (stella rotta) | `InpMinBreakoutRangeATR vale 1.0, vuole 0.0` |
  | magic **vietato** `773500` (sorgente) | `magic 773500 VIETATO` |
  | param **fuori stella** (`InpBufferPoints`) | `InpBufferPoints differisce dal baseline e non e' un delta dichiarato` |
  | `@PERIODO H1` (non M15) | `@PERIODO H1` |
  | asse `Y` su `InpRiskPercent` (non `InpMagic`) | `asse Y trovati 2` |

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), la presenza reale del simbolo
custom `NASUSD_EXT` sul PC di backtest, il comportamento del tester a OHLC, la
durata reale, e **ogni singolo numero**. Il giro a vuoto copre gli artefatti; **i
numeri li può dare solo la corsa** — e sono numeri **OHLC di screening**, non un
verdetto.
