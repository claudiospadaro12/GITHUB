# 📬 CRT TURTLE SOUP — **LA RIGA DA MANDARE**

**Che cos'è:** lo **screening walk-forward IS/OOS** del **fade strutturato di
falsa rottura** (wick di rifiuto ≥ K× il corpo, richiusura, gate del 50%). EA
`ABTG_CRT_TurtleSoup`, **NUOVO — mai compilato da nessuno**, su **NASUSD M15**,
**TICK REALI (Modello 4)**, sweep a **3 assi**. Motore CRT Turtle Soup da Neo
Malesa (n30dyn4m1c), licenza MIT.

> 🔴 **QUESTO È UNO SCREENING. NON PROMUOVE NIENTE E NON DÀ UN VERDETTO.**
> Il campione **21 mesi (2024.09 → 2026)** è **un solo regime (toro)**: il
> **MERITO** è formalmente **sospeso se n<150** (valvola R59). Il **RISCHIO no**:
> DD e peggior giornata contro il muro prop, **sempre**. Il verdetto **orso** a
> tick BCM è **impossibile** (serve Dukascopy) — limite noto dallo shortgate.

> ⚠️ **EA NUOVO, MAI COMPILATO.** Il giro a vuoto `-SoloControllo` **lo compila
> lui**: se la compilazione fallisce, **quello è il risultato del passo** (come
> per `ABTG_OutOfNoise`) — gli errori finiscono in `COMPILAZIONE_FALLITA.log`
> dentro lo zip.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_CRT_TurtleSoup.mq5` (**nuovo**, compilato dal giro a vuoto) |
| **Driver** | `righe/RIGA_CRT.ps1` (marcatore `MARCATORE_RIGA_CRT_v1`) |
| **File prova** | `prove/ABTG_CRT_TurtleSoup.txt` (sweep 3 assi + 2 fissi) |
| **Include** | **nessuno** (solo `Trade\Trade.mqh`, di serie) |

---

## 🎯 LO SWEEP — **3 assi** (griglia congelata)

| asse | default | griglia | cosa misura |
|---|---|---|---|
| `InpWickFactor` | 3.0 | 2.0 → 4.0 (passo 0.5) | quanto lungo il wick di rifiuto vs corpo di C1 |
| `InpUseMidGate` | 1 | 0 / 1 | gate del 50% (entry oltre metà del range di C1) ON/OFF |
| `InpSide` | 2 | 0 / 1 / 2 | **censimento dei due lati** (long / short / entrambi) |

**Fissi (non spazzolati):** `InpMinStopPts=500` (pavimento SL R109),
`InpCloseHour=21` / `InpCloseMin=0` (flat **RTH NASUSD 21:00 server**, non il
default US-afterhours 22:00 → **zero overnight**). Il **magic** `769100` è
**VERGINE** (blocco `7691xx`, verificato repo-wide il 2026-08-30).

---

## 🗺️ PERCHÉ NASUSD E NON D30EUR (il lead dichiarato)

Su **NASUSD** ogni specifica è **misurata**: conversione **100** pti MT5/pt indice
(R97), muro tick **26/09/2024**, chiusura RTH **21:00 server**. I default US del
CRT ci **calzano**. Su **D30EUR** il flat DAX (16:30 server) e la conversione
punti **NON sono misurati**: il default 22:00 terrebbe il DAX **in overnight**.
**DAX e Dow seguono DOPO un PASSO-0** sulle loro specifiche. È un affinamento
**PRIMA dei numeri** (regola di casa), scritto nel prova.

---

## 🧱 I GATE che questo driver fa rispettare, prima di MT5

- 🛑 **Pavimento SL (R109):** `InpMinStopPts=500`, **mai 0**. Il fade entra
  **contro** una spinta: il pavimento è load-bearing. Il gate **rifiuta 0**.
- 🕘 **Flat intraday:** `InpCloseHour=21`/`InpCloseMin=0` — il gate **rifiuta 22**
  (il default US dell'EA terrebbe overnight su NASUSD).
- 🎛️ **3 assi esatti:** esattamente `{InpWickFactor, InpUseMidGate, InpSide}`,
  nessun altro asse `Y`. Un asse in più o in meno = griglia diversa → **stop**.
- 🚫 **Sweep non degenere:** per ogni asse `start != stop` (l'errore dei 4 CSV
  vuoti del 07/08).
- 📐 **Geometria:** `@SIMBOLO NASUSD`, `@PERIODO M15`, `@DAQUANDO 2024.09.26`.
- 🪪 **Pin:** il driver **pinna anche `$EABranch`** dentro
  `walkforward_generico.ps1`, altrimenti il pin varrebbe per il driver e **non
  per l'EA misurato**.

---

## 📐 FINESTRA — walk-forward **IS/OOS 40/60**

Finestra **2024.09.26 → 2026.06.30** (~21 mesi, sotto il tetto ~100k barre di
M15 a tick), **un solo regime (toro)**. Il generico spezza in **40% IS** (dove si
sceglie la cella — **CENTRO dell'altopiano, MAI il picco**) e **60% OOS** (il
fuori campione). La lettura per **REGIME/concentrazione** si fa dal per-trade CSV
in `Common\Files`: `abtg_trades_ABTG_CRT_TurtleSoup_NASUSD_<magic>.csv`.

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ Il driver, il prova e l'EA vanno **committati e pushati**; poi si **rilegge
> il pin DOPO il push** (mai prima) e lo si scrive al posto di `<PIN>` in **tutti
> i punti d'uso** (`$pin='...'`). **La riga NON va lanciata con `<PIN>` dentro.**

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** La riga si rifiuta di partire in
  entrambi i casi (tester non gira / compilazione torna senza compilare).
- 🧮 **Modello 4 (TICK REALI): è comunque uno SCREENING** (un solo regime toro).
  L'EA è **nuovo**: la compilazione qui **è il passo** — se fallisce, quello è il
  risultato. **NON tocca il forward.**
- ⏱️ **Durata [STIMA, non una previsione]: dell'ordine di 20-60 minuti** più la
  compilazione (sweep a 3 assi × 2 gambe, a tick reali = più lento dell'OHLC).

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine: `pin`; `driver generico scaricato e PINNATO`;
`prova scaricato`; **`geometria, 3 assi, sweep non degenere, pavimento SL (R109),
flat intraday 21:00: TUTTI PASSATI`**; `terminale scelto`; **`compilato
ABTG_CRT_TurtleSoup: OK (<n> KB, <ora>)`** — o, se non compila, **`COMPILAZIONE
FALLITA`** col log; infine `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **`-SoloControllo` non apre MT5.** Nessun `n`, nessun PF, nessun DD. Conferma
> gli **artefatti** (inclusa la **compilazione dell'EA nuovo**), mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. `$p` e `$pin` nascono
**dentro** il `& { ... }` (scope figlio): ogni ripresa è un **blocco intero col
suo `irm`**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `CRT_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_CRT.txt`** ← è questo che conta (come si legge + puntatore al
  per-trade CSV per regime/concentrazione);
- il **file prova** `ABTG_CRT_TurtleSoup.txt`;
- nella CORSA, i **CSV** `ABTG_CRT_TurtleSoup_NASUSD_IS.csv` e `..._OOS.csv`;
- se l'EA nuovo non compila, **`COMPILAZIONE_FALLITA.log`**.
