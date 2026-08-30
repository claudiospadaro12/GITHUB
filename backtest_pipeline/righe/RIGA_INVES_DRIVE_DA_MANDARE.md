# 📬 INVERSIONE DA ESAURIMENTO — **LA RIGA DA MANDARE**

**Che cos'è:** lo **screening dell'ablazione a stella** del motore
**d'inversione da esaurimento** (fade selettivo a un livello). EA
`ABTG_InvEsaurimento`, **NUOVO — mai compilato da nessuno**, su
`NASUSD_EXT M15`, **3 celle**. Contratto firmato:
`risultati_archivio/STUDIO_INVERSIONE_ESAURIMENTO_CRITERI_BOZZA.md`
("FIRMO", 30/08/2026).

> 🔴 **QUESTO È UNO SCREENING. NON PROMUOVE NIENTE E NON DÀ UN VERDETTO.**
> Gira a **MODELLO 1 (OHLC)**: si legge la **FORMA** dell'edge (verde/rosso,
> ordini di grandezza, coerenza fra le celle), **MAI i numeri fini**. Il
> **verdetto a tick** è possibile **solo sulla cassaforte 2024.09 → 2026 (BCM)**,
> che si apre **dopo**. **G5 non tocca il forward: è una MISURA, non una promozione.**

> ⚠️ **EA NUOVO, MAI COMPILATO.** Il giro a vuoto `-SoloControllo` **lo compila
> lui**: se la compilazione fallisce, **quello è il risultato del passo** (come
> per `ABTG_OutOfNoise`) — gli errori finiscono in `COMPILAZIONE_FALLITA.log`
> dentro lo zip.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_InvEsaurimento.mq5` (**nuovo**, compilato dal giro a vuoto) |
| **Driver** | `righe/RIGA_INVES_DRIVE.ps1` (marcatore `MARCATORE_RIGA_INVES_DRIVE_v1`) |
| **File prova** | `prove/INVES_NAS_00_baseline.txt` · `01_E1` · `02_E3` |
| **Include** | `mql5/Include/ABTG_PausaGuardian.mqh` (l'EA lo `#include`; il driver lo installa) |

---

## 🎯 LE TRE CELLE — ablazione **a stella**

| cella | file prova | cosa cambia dal baseline | magic gemelli |
|---|---|---|---|
| **00_baseline** | `INVES_NAS_00_baseline.txt` | **niente** — E1 **off** (0), E3 **off** (0). E2 (il livello) **sempre attivo** | 769000 / 769001 |
| **01_E1** 🔑 | `INVES_NAS_01_E1.txt` | **E1** `InpUseE1` 0 → **1** (esaurimento ≥ 1.0× ADR14) | 769010 / 769011 |
| **02_E3** | `INVES_NAS_02_E3.txt` | **E3** `InpUseE3` 0 → **1** (2-3 barre a range calante al livello) | 769020 / 769021 |

La cella **01_E1 è la CHIAVE** di tutto lo studio: il fade "normale" è **morto**
(R108/R109/R95), l'edge — se esiste — sta **sugli estremi di esaurimento** (mosse
che hanno già speso ≥ 1.0× l'ADR14). Ogni cella muove **UN SOLO interruttore**
rispetto al baseline (più il magic), e il driver lo **verifica prima di aprire
MT5** (gate della stella). **Nessuna cella accende due feature insieme.** I
**magic sono VERGINI**: blocco `7690xx`, cercato in tutto il repo il
**2026-08-30** → **zero occorrenze** (il solo `769045` è un valore di
correlazione in un JSON). L'unico asse `Y` è `InpMagic` (i gemelli di controllo).

- 🎛️ **Uscita TUTTO-RIENTRO, fissa in tutte e 3** (contratto §2): `InpUseVwapTP=1`
  (TP = rientro verso la VWAP di seduta), `InpTP_R=1.5` (ripiego) e
  `InpCloseOnOpposite=0`. L'inversione punta al **rientro**, non a inseguire una
  coda di trend nuovo. Il gate li pretende identici in ogni cella.

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

- 🛑 **Pavimento SL (R109):** `InpMinStopPts=500` (5 punti indice), **mai 0**. Il
  gate **rifiuta lo 0**. Un'inversione entra **contro** una mossa forte: il
  "coltello che cade" è il pericolo n.1, il pavimento è **load-bearing**.
- 🚪 **Uscita fissa:** `InpUseVwapTP=1`, `InpTP_R=1.5`, `InpCloseOnOpposite=0` —
  identici in tutte e 3 le celle.
- ⭐ **Stella:** ogni cella differisce dal baseline **solo** per la feature
  dichiarata + il magic; ogni altro parametro **deve** coincidere. **Gate esplicito
  "mai due feature insieme".**
- 🔢 **Feature-value:** `InpUseE1`/`InpUseE3` pinnati esatti per cella — prende
  anche il caso di **due file scambiati**.
- 🪪 **Magic:** vergini, unici, mai uno **vietato** (sorgente `773500`, il blocco
  `7672xx` della FASE2 ormai speso, `7677xx`/`7678xx`/`7681xx`, i round recenti).

---

## 📐 FINESTRA — **una sola tranche**

Finestra **2017.01.01 → 2020.07.01** (~3,5 anni, sotto il tetto ~100k barre di
M15), **multi-regime**: toro 2017, orso Q4-2018, laterale 2019, crollo+V covid
2020. **Il 2020 è la PROVA DECISIVA**: crollo-giù e ripresa-V sono i due più
grandi esaurimenti, uno per lato — se il motore (E1 acceso) non li prende, **non
è lui**. **Niente split IS/OOS interno** (l'OOS vero è la cassaforte 2021-2026,
che si apre dopo). Il driver generico pretende una `FrazioneIS`: la riga gli
passa **`-FrazioneIS 1.0`**, così la sua gamba **"IS" è la finestra intera** e la
gamba "OOS" è un intervallo **degenere** (0 giorni, zero passate) che **si
ignora**. La tabella legge **solo la finestra intera**.

> 📊 **La lettura per REGIME si fa A MANO dal per-trade CSV**, esportato in
> `Common\Files`: `abtg_trades_ABTG_InvEsaurimento_NASUSD_EXT_<magic>.csv`,
> colonne `close_time` (per anno/regime) e `net_profit` (l'esito). Si somma
> `net_profit` per finestra di regime e si guarda **aspettativa/trade E DD** di
> ciascun regime, feature per feature. **Il totale 2017-2020 DILUISCE.**

---

## 📌 CRITERI DI LETTURA CONGELATI (contratto §5)

- **Decide l'ASPETTATIVA PER TRADE** (non solo il PF), con coerenza fra i
  sotto-periodi. **RISCHIO MAI SOSPESO** (regola B): **DD e peggior giornata**
  contro il muro prop, **sempre**, a qualunque `n` (inversione = coltello che
  cade, la peggior giornata è load-bearing).
- **Campione:** **≥ 150 trade** per giudicare il **MERITO**; sotto, merito
  sospeso (il rischio no).
- **Vince** solo se una cella (E1 o E3) dà **aspettativa/trade positiva e
  STABILE**, con **DD sotto il muro**, **E BATTE i fade caduti R108/R109/R95**.
  Un solo periodo = **non dimostrato**.

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ **Questa pagina è pronta ma NON ancora lanciabile.** Il driver, i tre file
> prova, l'EA e l'include devono essere **committati e pushati** (lo fa Claudio,
> dopo il gate verificatore-stringhe); poi si **rilegge il pin DOPO il push** (mai
> prima) e lo si scrive qui al posto di `<PIN>`, in **tutti i punti d'uso**
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
- 🧮 **Modello 1 (OHLC): è uno SCREENING.** L'EA è **nuovo**: la compilazione qui
  è **il passo** — se fallisce, quello è il risultato. Questa corsa **NON tocca il
  forward**.
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic` (i gemelli).
- ⏱️ **Durata [STIMA, non una previsione]: dell'ordine di 10-25 minuti** più la
  compilazione (3 celle × una finestra × 2 gemelle a OHLC).

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_INVES_DRIVE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_INVES_DRIVE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_INVES_DRIVE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine: `pin` e `celle ....... 3 su 3`; `driver generico
scaricato e PINNATO`; `file prova scaricati: 3`; `include scaricato:
ABTG_PausaGuardian.mqh (<n> byte)`; **`geometria, FUSO NY (9/30), pavimento SL
(R109), uscita fissa, valori feature, stella (una feature sola) e magic: TUTTI
PASSATI`**; `simbolo custom: NASUSD_EXT TROVATO (<n> MB ...)`; `include:
INSTALLATO e VERIFICATO`; **`compilato ABTG_InvEsaurimento: OK (<n> KB, <ora>)`**
— o, se l'EA nuovo non compila, **`COMPILAZIONE FALLITA`** col log; poi, per
cella, l'anteprima dell'`.ini`; infine `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **`-SoloControllo` non apre MT5.** Nessun `n`, nessun PF, nessun DD,
> **nessun controllo sui gemelli**. Conferma gli **artefatti** (inclusa la
> **compilazione dell'EA nuovo**), mai i numeri.

> 🟡 **Nell'anteprima `.ini` del giro a vuoto vedrai `Model=4` — NON allarmarti.**
> È un quirk del driver generico (scrive `Model=4` fisso solo nell'anteprima di
> controllo). **La corsa VERA gira `Model=1` (OHLC screening)**, come dichiarato
> in testa. Il numero che conta è quello della corsa, non dell'anteprima.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_INVES_DRIVE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_INVES_DRIVE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_INVES_DRIVE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

### 🔁 Se serve riprendere una cella sola

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_INVES_DRIVE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_INVES_DRIVE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_INVES_DRIVE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '01_E1' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**. Celle valide: `00_baseline`, `01_E1`, `02_E3`.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `INVES_DRIVE_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_INVES_DRIVE.txt`** ← **è questo che conta** (tabella finestra intera
  + le 4 avvertenze di lettura + il puntatore al per-trade CSV per il regime);
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_InvEsaurimento_NASUSD_EXT_IS_ohlc_<cella>.csv` (la finestra
  intera; il suffisso `_ohlc` è del Modello 1, l'`IS` è la tranche unica);
- se l'EA nuovo non compila, **`COMPILAZIONE_FALLITA.log`**.

Le due righe da guardare per prime: **`modo:`** (`CORSA` o `CONTROLLO`) e
**`data:`** (deve essere di ADESSO).

---

## ✅ COSA È GIÀ STATO VERIFICATO — in questo ambiente, prima dell'invio

- ✅ il `.ps1` **parsa**: `[Parser]::ParseFile` → **0 errori**, **5.672 token**;
  **ASCII puro** (0 byte non-ASCII, regola del 17/08); **0** occorrenze del baco
  `](if(`;
- ✅ **i gate girano DAVVERO sui 3 file veri**: controllo **positivo passato**
  (3 celle, **6 magic unici** `769000/001/010/011/020/021`);
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** (12 corruzioni):

  | corruzione | il gate ha detto |
  |---|---|
  | `InpSessionHour=14` (**ora server**, vietata su `_EXT`) | `InpSessionHour=14 ora server, su _EXT va 9` |
  | `InpSessionMin=0` | `InpSessionMin deve essere 30` |
  | `InpMinStopPts=0` (**R109**) | `InpMinStopPts=0 VIETATO (R109)` |
  | `InpUseVwapTP=0` (uscita cambiata) | `InpUseVwapTP deve essere 1` |
  | `InpCloseOnOpposite=1` | `InpCloseOnOpposite deve essere 0` |
  | **due feature insieme** (E3 nella cella E1) | `InpUseE3 vale 1, vuole 0` |
  | **baseline con E1 acceso** (stella rotta) | `InpUseE1 vale 1, vuole 0` |
  | magic **vietato** `767200` (FASE2 spento) | `magic 767200 VIETATO` |
  | param **fuori stella** (`InpLevelTolPts`) | `InpLevelTolPts differisce dal baseline e non e' un delta dichiarato` |
  | `@PERIODO H1` (non M15) | `@PERIODO H1` |
  | asse `Y` su `InpRiskPercent` (non `InpMagic`) | `asse Y trovati 2` |
  | **E1 non acceso** nella cella chiave | `InpUseE1 vale 0, vuole 1` |

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione dell'EA nuovo** (qui non c'è MetaEditor: è **il passo**, potrebbe
fallire), la presenza reale del simbolo custom `NASUSD_EXT` sul PC di backtest, il
comportamento del tester a OHLC, la durata reale, e **ogni singolo numero**. Il
giro a vuoto copre gli artefatti; **i numeri li può dare solo la corsa** — e sono
numeri **OHLC di screening**, non un verdetto.
