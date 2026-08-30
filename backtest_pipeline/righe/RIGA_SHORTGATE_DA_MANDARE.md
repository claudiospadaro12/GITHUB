# 📬 SCREENING SHORT ORSO — **LA RIGA DA MANDARE**

**Che cos'è:** lo **screening diagnostico (sì/no)** del **breakdown short GATED**
da regime H4 ribassista — l'unica strada che ci resta per chiedere *"lo short
degli indici è morto anche NELL'ORSO, o solo nel toro dove l'abbiamo sempre
testato?"*. EA `ABTG_Nasdaq_Apertura_US` (già compilato/vivo in forward, **porting
ZERO**), su `NASUSD_EXT M15`, **UNA sola cella + gemello**. Dossier firmato:
`caccia_strategie/CACCIA_SHORT_INDICI_2026-08-29.md`. File prova (criteri
congelati prima dei numeri): `prove/SHORTGATE_NAS_BREAKDOWN.txt`.

> 🔴 **QUESTO È UNO SCREENING DIAGNOSTICO. NON PROMUOVE NIENTE E NON DÀ UN
> VERDETTO.** Gira a **MODELLO 1 (OHLC)**: si legge la **FORMA** dell'edge
> (verde/rosso, ordini di grandezza), **MAI i numeri fini**. E il **verdetto a
> tick nell'orso è IMPOSSIBILE**: i tick BCM sugli indici **partono dal
> 26/09/2024**, non raggiungono nessun orso. Il **cancello ZERO qualità-feed
> indici è ancora CHIUSO**: questo screening OHLC su `_EXT` va letto con quella
> riserva.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` (già compilato/vivo in forward) |
| **Driver** | `righe/RIGA_SHORTGATE.ps1` (marcatore `MARCATORE_RIGA_SHORTGATE_v1`) |
| **File prova** | `prove/SHORTGATE_NAS_BREAKDOWN.txt` (1 cella, gemelli `767120`/`767121`) |
| **Include** | `mql5/Include/ABTG_PausaGuardian.mqh` (l'EA lo `#include`; il driver lo installa) |

---

## 🎯 LA CELLA — **una sola** (niente ablazione a stella)

| cella | file prova | configurazione | magic gemelli |
|---|---|---|---|
| **shortgate** | `SHORTGATE_NAS_BREAKDOWN.txt` | breakdown short GATED da EMA 50×200 H4, **SOLO short** | 767120 / 767121 |

È un **diagnostico sì/no**, non un'ottimizzazione: **config FISSA**, l'unico asse
`Y` è `InpMagic` (i due gemelli di controllo — due passate identiche al centesimo
= igiene del banco). **Ottimizzare uno short su dati orso = curve fitting**
(`CLAUDE.md`, Regola della seconda caccia): la griglia viene **dopo**, e **solo
se** il diagnostico è verde nell'orso. I magic sono **VERGINI** (`767120/767121`
cercati in tutto il repo il 2026-08-30 → solo il file prova).

---

## 🧭 LA DIREZIONE È COSTITUTIVA (il cuore dell'ipotesi)

Lo short qui **non è un "AllowShort" appiccicato**: è la meccanica.

| input | valore | perché |
|---|---|---|
| `InpEntryMode` | **0** (BREAKOUT) | drive-down following: SELL STOP sotto il minimo del range d'apertura che **prosegue**. Il payoff short vive nel DRIVE-DOWN (anatomia: MFE/MAE ~6:1), non nel rientro. |
| `InpAllowLong` | **false** | solo short |
| `InpAllowShort` | **true** | solo short |

⚠️ **Il gate RIFIUTA `InpEntryMode=2` (RETEST):** è il meccanismo bocciato da
**R115** (NAS 0.517). Questo round prova il **BREAKDOWN**, non il retest.

---

## 🚪 IL GATE DI REGIME **È IL MOTORE**, non un cerotto

Lo short è ammesso **solo se EMA fast < slow su H4** (regime ribassista) —
`TrendBias()` righe 1570-1571 del sorgente. Senza orso il gate tiene l'EA
**FLAT**: è il comportamento **voluto**. Il gate pretende:

| input | valore |
|---|---|
| `InpUseEmaFilter` | **true** |
| `InpEmaFast` | **50** |
| `InpEmaSlow` | **200** |
| `InpFilterTF` | **16388** (H4) |

---

## 🕒 IL FUSO — **INVERTITO** rispetto alla regola di casa (critico)

Su `NASUSD_EXT` il feed HistData è a **ora di NEW YORK**: l'anatomia lo ha
**MISURATO** (canarino DST verde,
`risultati_archivio/LETTURA_ANATOMIA_APERTURE_2026-08-26.md`: *"le 09:30 del file
sono l'apertura cash TUTTO l'anno"*). Perciò il gate **PRETENDE**:

| input | valore | perché |
|---|---|---|
| `InpSessionHour` | **9** | apertura cash NY 09:30 sul feed `_EXT` |
| `InpSessionMin` | **30** | " |

⚠️ **Il gate RIFIUTA `InpSessionHour=14`.** Il 14:30 SERVER (regola di casa
`IT − 1 = server`) è l'apertura sul **feed tick BCM** (`NASUSD`) e vale **SOLO
per la cella di validazione a tick della cassaforte**, **non** per questo
screening `_EXT`.

> 🟠 **NOTA DI CANTIERE (30/08):** la **prima stesura** del file prova portava
> `InpSessionHour=14` (assumeva un mapping *server* per il feed `_EXT`). È stata
> **corretta a 9** — coerente con la misura FASE2 sullo **STESSO feed**. Il `14`
> avrebbe dato ingressi di **metà pomeriggio NY** (spazzatura). Il gate lo blinda.

---

## 🧱 GLI ALTRI GATE che questo driver fa rispettare, prima di MT5

- 🛑 **Pavimento SL (R109):** `InpMinStopPts=500` (5 punti indice), **mai 0**;
  `InpSkipIfTight=false` (il pavimento **si applica**, non fa saltare il trade).
- 💰 **Rischio conservativo:** `InpRiskPercent=0.65` (pinnato, dossier).
- 🪪 **Magic:** vergini, unici, mai uno **vietato** (sorgente `773500`, i blocchi
  vivi/round recenti, e — aggiunti in questo round — i **magic FASE2** `7672xx`,
  ora occupati).
- 🔢 **Geometria + asse:** `@SIMBOLO NASUSD_EXT`, `@PERIODO M15`, `@DAQUANDO
  2020.01.01`, **un solo asse `Y` = `InpMagic`**.

---

## 📐 FINESTRA — **una sola tranche**

Finestra **2020.01.01 → 2024.01.01** (~4 anni, sotto il tetto ~100k barre di
M15), **multi-regime**: **crollo 2020**, toro 2021, **orso 2022**, ripartenza
2023. **Niente split IS/OOS interno** (i tick BCM non raggiungono l'orso: nessun
OOS a tick è possibile). Il driver generico pretende una `FrazioneIS`: la riga
gli passa **`-FrazioneIS 1.0`**, così la sua gamba **"IS" è la finestra intera** e
la gamba "OOS" è **degenere** (0 giorni, zero passate) e **si ignora**.

> 🟠 **Il file prova NON dichiara `@FINOA`:** la fine finestra la fissa il driver
> (`-Fino`, **default 2024.01.01**) e la **dichiara** nel referto. Se un domani
> il file aggiunge `@FINOA`, il gate lo confronta e si ferma se non combacia. Per
> coprire anche 2019 e 2025-2026 serve una **seconda tranche** o un **TF più
> alto** (il tetto 100k barre morde: M15 ~4 anni per corsa).

> 📊 **LA LETTURA SI SEGMENTA PER REGIME — a mano, dal per-trade CSV** esportato
> in `Common\Files`: `abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_EXT_<magic>.csv`,
> colonne `close_time` (per anno/regime) e `net_profit` (l'esito). **Il numero
> che conta è il comportamento nei DUE sotto-periodi ORSO** (crollo 2020-02/04 e
> orso 2022), **NON il totale** (per metà toro, diluisce). **Nel toro 2021 ci si
> aspetta FLAT: è la tesi, non un difetto.**

---

## 📌 CRITERI DI LETTURA CONGELATI (dossier §5)

- **PROMOSSO a round vero SOLO se** nelle finestre orso l'**aspettativa/trade è
  positiva** (al netto di uno spread ≥ 1.5 punti indice, R55) **E** il DD orso
  **non peggiora il rischio della flotta**. Un solo periodo = **non dimostrato**.
- **RISCHIO MAI SOSPESO** (regola B): **DD e peggior giornata** contro il muro
  prop, **sempre**, a qualunque `n`. **≥ 150 trade** per giudicare il **MERITO**.
- **Deve battere i caduti:** R98/R115 (short), R108/R109 (fade).

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ **Questa pagina è pronta ma NON ancora lanciabile.** Il driver, il file
> prova, l'EA e l'include devono essere **committati e pushati** (lo fa Claudio,
> dopo il gate verificatore-stringhe); poi si **rilegge il pin DOPO il push**
> (mai prima) e lo si scrive qui al posto di `<PIN>`, in **tutti i punti d'uso**
> (`$pin='...'`). **La riga NON va lanciata con `<PIN>` dentro.**

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
- ⏱️ **Durata [STIMA, non una previsione]: dell'ordine di 5-15 minuti** più la
  compilazione (1 cella × una finestra × 2 gemelle a OHLC).

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SHORTGATE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SHORTGATE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SHORTGATE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine: `pin` e `cella ....... 1 (shortgate, + gemello)`;
`driver generico scaricato e PINNATO`; `file prova scaricato:
SHORTGATE_NAS_BREAKDOWN.txt`; `include scaricato: ABTG_PausaGuardian.mqh (<n>
byte)`; **`geometria, FUSO NY (9/30), direzione costitutiva (BREAKOUT 0, solo
short), gate regime (EMA 50x200 H4), pavimento SL (R109), rischio 0.65 e magic
vergini: TUTTI PASSATI`**; `simbolo custom: NASUSD_EXT TROVATO (<n> MB ...)`;
`include: INSTALLATO e VERIFICATO`; **`compilato ABTG_Nasdaq_Apertura_US: OK (<n>
KB, <ora>)`**; poi l'anteprima dell'`.ini`; infine `ESITO: CONTROLLO COMPLETATO`.

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
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SHORTGATE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SHORTGATE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SHORTGATE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `SHORTGATE_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_SHORTGATE.txt`** ← **è questo che conta** (tabella finestra intera +
  le 4 avvertenze di lettura + il puntatore al per-trade CSV per il regime);
- il **file prova** della cella;
- il **CSV** `ABTG_Nasdaq_Apertura_US_NASUSD_EXT_IS_ohlc_shortgate.csv` (la
  finestra intera; il suffisso `_ohlc` è del Modello 1, l'`IS` è la tranche unica).

Le due righe da guardare per prime: **`modo:`** (`CORSA` o `CONTROLLO`) e
**`data:`** (deve essere di ADESSO). E poi, **prima di ogni numero**: il
`REFERTO` è OHLC di screening, **non un verdetto** — e **il numero che conta è
l'ORSO**, dal per-trade CSV, non il totale.

---

## ✅ COSA È GIÀ STATO VERIFICATO — in questo ambiente, prima dell'invio

- ✅ il `.ps1` **parsa**: `[Parser]::ParseFile` → **0 errori**, **5.208 token**;
  **ASCII puro** (0 byte non-ASCII, regola del 17/08); **niente baco
  if-in-espressione** (`](if(` → 0); **niente `$args`** (si usa `$argv`);
- ✅ **i gate girano DAVVERO sul file vero**: controllo **positivo passato**
  (magic `767120/767121`);
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** (22 corruzioni), fra cui:

  | corruzione | il gate ha detto |
  |---|---|
  | `InpSessionHour=14` (**ora server**, vietata su `_EXT`) | `InpSessionHour=14 ORA SERVER, su _EXT va 9` |
  | `InpEntryMode=2` (**RETEST**, R115) | `InpEntryMode=2 (RETEST) VIETATO (R115)` |
  | `InpAllowLong=true` / `InpAllowShort=false` | `deve essere false` / `deve essere true` |
  | `InpUseEmaFilter=false` (gate spento) | `InpUseEmaFilter deve essere true` |
  | `InpEmaFast=1` / `InpEmaSlow=100` / `InpFilterTF=H1` | `deve essere 50` / `200` / `16388 (H4)` |
  | `InpMinStopPts=0` (**R109**) | `InpMinStopPts=0 VIETATO (R109)` |
  | `InpSkipIfTight=true` | `InpSkipIfTight deve essere false` |
  | `InpRiskPercent=2.0` | `InpRiskPercent deve essere 0.65` |
  | magic **vietato** `773500` / magic **FASE2** `767200` | `magic ... VIETATO` |
  | magic gemello sbagliato `767999` | `magic gemelli 767120/767999, attesi 767120/767121` |
  | asse `Y` su `InpRiskPercent` / secondo asse `Y` | `ESATTAMENTE un asse Y, trovati 2` |
  | `@PERIODO H1` / `@DAQUANDO 2021` / `@FINOA` non combacia | `@PERIODO e' H1` / `@DAQUANDO ...` / `@FINOA ...` |
  | `InpMagic` su due righe | `DUE righe per 'InpMagic'` |

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), la presenza reale del simbolo
custom `NASUSD_EXT` sul PC di backtest, il comportamento del tester a OHLC, la
durata reale, e **ogni singolo numero**. Il giro a vuoto copre gli artefatti; **i
numeri li può dare solo la corsa** — e sono numeri **OHLC di screening**, non un
verdetto (e **il verdetto a tick nell'orso non esiste**, i tick BCM non lo
raggiungono).
