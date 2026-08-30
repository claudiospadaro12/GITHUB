# 📬 CHAOS LYAPUNOV — **LA RIGA DA MANDARE**

**Che cos'è:** lo **screening del GATE LLE** — un EMA-cross 9/21 **incatenato**
all'esponente di Lyapunov più grande (opera SOLO in regime "leggibile", flat nel
caos). EA `ABTG_ChaosLyapunov`, **NUOVO — mai compilato**, su **NASUSD_EXT M15**,
**OHLC (Modello 1)**, finestra intera **2020 → 2026**, sweep a **3 assi**. Gate
LLE da jojoale (jojoalb), MQL5 Code Base 76446.

> 🔴 **SCREENING, NON un verdetto.** Gira a **MODELLO 1 (OHLC)**: si legge la
> **FORMA** del gate (se MORDE), **MAI i numeri fini**. Il verdetto a tick è
> possibile **solo sulla cassaforte BCM 2024.09→2026**, che si apre dopo. **NON
> tocca il forward.**

> ⚠️ **EA NUOVO, MAI COMPILATO.** Il giro a vuoto `-SoloControllo` **lo compila
> lui**: se fallisce, **quello è il risultato del passo** (log in
> `COMPILAZIONE_FALLITA.log` dentro lo zip).

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_ChaosLyapunov.mq5` (**nuovo**, Guardian-free) |
| **Driver** | `righe/RIGA_CHAOS.ps1` (marcatore `MARCATORE_RIGA_CHAOS_v1`) |
| **File prova** | `prove/ABTG_ChaosLyapunov_Lya.txt` (sweep 3 assi + 2 fissi) |
| **Include** | **nessuno** (solo `Trade\Trade.mqh`, di serie) |

---

## 🎯 LO SWEEP — **3 assi Lyapunov**

| asse | default | griglia | cosa misura |
|---|---|---|---|
| `InpLyaThreshold` | 0.00 | −0.06 → 0.12 (passo 0.03) | soglia del gate: opera se LLE ≤ soglia. **È la variabile chiave** |
| `InpLyaLookback` | 100 | 50 → 150 (passo 50) | finestra phase-space per il calcolo LLE |
| `InpSlAtrMult` | 1.5 | 0.5 → 2.5 (passo 0.5) | SL = mult × ATR |

**Fissi:** `InpRiskPercent=1.0` (screening d'archivio all'1%), `InpMinStopPts=500`
(pavimento SL R109). Motore **NUDO** (`InpCloseAtEnd=false` → tiene overnight:
è lo screening del gate sul motore nudo; il flat intraday arriva allo step 2).

---

## 🧠 LA DOMANDA — il gate MORDE o è decorativo?

Se muovendo `InpLyaThreshold` **NIENTE cambia** (stessi trade, stesso PF) → il
gate è **decorativo** e il candidato **cade**. Se **stringendo il gate il PF sale
e i trade calano in modo ordinato** → il gate **morde** ed è l'edge. È tutto qui.

---

## 🧱 I GATE che questo driver fa rispettare, prima di MT5

- 🛑 **Pavimento SL (R109):** `InpMinStopPts=500`, **mai 0**. Il gate **rifiuta 0**.
- 🎛️ **3 assi esatti:** `{InpLyaThreshold, InpLyaLookback, InpSlAtrMult}`, nessun
  altro asse `Y`.
- 🚫 **Sweep non degenere:** per ogni asse `start != stop`.
- 📐 **Geometria:** `@SIMBOLO NASUSD_EXT`, `@PERIODO M15`, `@DAQUANDO 2020.01.01`.
- 🗂️ **Simbolo custom:** `NASUSD_EXT` è storico ESTERNO — il driver controlla
  `bases\Custom\history\NASUSD_EXT` **prima** di MT5: se manca **si ferma con
  l'errore onesto** (va importato con la Riga dello storico, non lo costruisce
  questa riga).
- 🪪 **Pin:** il driver **pinna anche `$EABranch`** dentro il generico.

---

## 📐 FINESTRA — **una sola tranche** (mappa il gate, non IS/OOS)

Finestra **2020.01.01 → 2026.06.30** (crollo 2020 + toro 2021 + orso 2022 +
ripartenza). Nessuno split IS/OOS: il gate si **mappa sulla finestra intera**. Il
generico pretende una `FrazioneIS`: la riga passa **`1.0`**, così la gamba "IS" è
la finestra intera e la "OOS" è degenere e si ignora. Lettura per **REGIME** dal
per-trade CSV in `Common\Files`:
`abtg_trades_ABTG_ChaosLyapunov_NASUSD_EXT_<magic>.csv`.

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ Driver, prova ed EA vanno committati e pushati; poi si **rilegge il pin DOPO
> il push** e lo si scrive al posto di `<PIN>` in **entrambe** le righe
> (`$pin='...'`). **La riga NON va lanciata con `<PIN>` dentro.**

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor CHIUSI.** La riga si rifiuta di partire in entrambi i casi.
- 🗂️ **`NASUSD_EXT` deve essere già importato** (lo usiamo dal round InvEsaurimento
  / shortgate: dovrebbe esserci). Se manca, la riga si ferma con l'errore onesto.
- 🧮 **Modello 1 (OHLC): è uno SCREENING.** L'EA è **nuovo**: la compilazione qui
  **è il passo**. **NON tocca il forward.**
- ⏱️ **Durata [STIMA]: dell'ordine di 15-45 minuti** più la compilazione (sweep a
  3 assi, a OHLC = più veloce del tick).

---

## 1️⃣ PRIMA il giro a vuoto (compila + gate, NON apre MT5)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CHAOS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CHAOS.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CHAOS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Deve dire, alla fine:** `geometria, 3 assi Lyapunov, sweep non degenere,
pavimento SL (R109): TUTTI PASSATI`; `simbolo custom: NASUSD_EXT TROVATO (...)`;
**`compilato ABTG_ChaosLyapunov: OK (<n> KB)`**; `ESITO: CONTROLLO COMPLETATO`.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CHAOS.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CHAOS.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CHAOS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

---

## 📦 COSA TORNA INDIETRO

Zip sul **Desktop**: `CHAOS_<MODO>_<data>_<ora>.zip` → dentro `REFERTO_CHAOS.txt`
+ il prova + (nella corsa) i CSV `..._IS_ohlc.csv` e `..._OOS_ohlc.csv`. **Mandami
lo zip.**
