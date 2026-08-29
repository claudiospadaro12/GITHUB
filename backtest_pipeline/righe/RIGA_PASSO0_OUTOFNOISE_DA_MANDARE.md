# 📬 PASSO 0 — OUT OF THE NOISE — **LA RIGA DA MANDARE**

**Che cos'è:** il **PASSO 0** del candidato **P3** "Out of the Noise Intraday con
VWAP" (porting del Pine di Yuri Lopukhov, MIT, TradingView `gJeM3LZ5` — scheda
`caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md`, voto **7/10 — in coda**).
Si misura **QUANTE OPERAZIONI** produce il **cono di rumore orario** su
`NASUSD M15`, a **tick reali**, su tre celle. Stessa macchina dei PASSO 0
gemelli **FVGRET** e **VWAPREV**.

> 🔴 **NON È UN ROUND E NON DÀ NESSUN VERDETTO.** È un **conta-operazioni**.
> Il Profit Factor che esce dal CSV **si legge ma non si giudica**: non ci sono
> criteri firmati, non c'è ablazione, e tre celle non sono un round.
> **G5 non tocca il forward: è una MISURA, non una promozione.**

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_OutOfNoise.mq5` (v1.00, porting Pine `gJeM3LZ5`) |
| **Driver** | `righe/RIGA_PASSO0_OUTOFNOISE.ps1` (marcatore `MARCATORE_RIGA_PASSO0_OUTOFNOISE_v1`) |
| **File prova** | `prove/ABTG_OutOfNoise.txt` · `prove/PASSO0_OUTOFNOISE_01_long.txt` · `prove/PASSO0_OUTOFNOISE_02_short.txt` |
| **Include** | `mql5/Include/ABTG_PausaGuardian.mqh` (l'EA lo `#include`; il driver lo installa) |

---

## 🎯 LE TRE CELLE

| cella | file prova | lati | magic gemelli |
|---|---|---|---|
| **00_nudo** | `ABTG_OutOfNoise.txt` | long **+** short | 767700 / 767701 |
| **01_long** | `PASSO0_OUTOFNOISE_01_long.txt` | **solo long** | 767710 / 767711 |
| **02_short** | `PASSO0_OUTOFNOISE_02_short.txt` | **solo short** | 767740 / 767741 |

Ogni cella differisce dal `00_nudo` di **due righe sole** (il lato + il magic),
e il driver **lo verifica prima di aprire MT5**. I **sei magic sono VERGINI**:
blocco `7677xx`, cercati uno per uno in tutto il repo il **2026-08-29** → **zero
occorrenze**. Il magic del **sorgente** (`773500`) è nella lista dei **vietati**,
insieme ai blocchi già usati (R103 `760xxx`, R107 `761xxx`, R108 `762xxx`,
R112 `7634xx`, Bulge `765xxx`, R115 `766xxx`).

---

## 🕒 IL FUSO — la regola di casa che questo driver fa rispettare

**NASUSD apre 15:30 IT = 14:30 SERVER**, chiude ~21:00 server (fuso di casa:
**ora italiana − 1 = ora server BCM**). Gli input di sessione dell'EA vanno in
**ORA SERVER**:

| input | valore (SERVER) | = ora IT |
|---|---|---|
| `InpSessionStartHour` / `InpSessionStartMin` | **14 / 30** | 15:30 |
| `InpSessionEndHour` / `InpSessionEndMin` (flat) | **21 / 0** | 22:00 |

⚠️ **Il default del sorgente è il DAX (08:00–16:30):** il driver generico blinda
tutto al default, quindi **senza le righe di sessione l'EA girerebbe NASUSD con
gli orari del DAX**. I file prova le dichiarano, e il driver del PASSO 0
**RIFIUTA un file con `InpSessionStartHour=15`** (ora italiana) o qualunque
valore ≠ 14 / 30 / 21 / 0.

---

## ❓ LA DOMANDA — e i tre esiti, congelati PRIMA di vedere il numero

| esito | lettura |
|---|---|
| **A** — n per lato **≥ 150** | il campione c'è, **Emendamento regola A soddisfatto**: il round vero si può disegnare |
| **B** — n per lato **< 150** | **valvola R59 / regola B**: il **MERITO resta SOSPESO**, il **RISCHIO si giudica lo stesso** (un drawdown è un fatto accaduto). **Non si allarga il motore per fare campione** |
| **C** — n **enorme** | il cono è troppo stretto: si muove **`InpConeDays` / la geometria del cono**, **NON** il rischio e **NON** un filtro nuovo |

### 💰 IL CANCELLO S0 (il costo) — la seconda misura, vale quanto la prima

Mediana del **take LORDO in PUNTI INDICE ≥ ~3-4× lo spread tipico** — è il
cancello che ha **bocciato R98**. Si legge nell'export per-trade in
`Common\Files`: `abtg_trades_ABTG_OutOfNoise_NASUSD_<magic>.csv`, colonna
`take_idx_pts`.

✅ **Su NASUSD la conversione È AGLI ATTI** (a differenza del DAX): **1 punto
indice = 100 punti MT5** (R97), già il default `InpMT5PerPuntoIndice=100`. La
colonna `take_idx_pts` è **già in punti indice**: **nessuna conversione a mano**.
Spread NASUSD ≈ **1-2 punti indice** `[INCERTO, DICHIARATO NON MISURATO]` →
soglia di ordine **~6 punti indice**. Sotto soglia = il motore muore di costo.
⚠️ Quel file porta il **MAGIC** nel nome, non la finestra: la gamba **OOS
sovrascrive la IS** dello stesso magic — resta a disco l'**ultima finestra**.

---

## 📐 FINESTRA E SPLIT

Finestra **2024.09.26 → 2026.06.30** (642 giorni), split **40/60** del driver
generico → **IS `2024.09.26 → 2025.06.09`**, **OOS `2025.06.10 → 2026.06.30`**.
Tick reali (`Model=4`), deposito **100.000**, rischio **0.65%** (default di
`InpRiskPercent` letto nel `.mq5` al pin). **12 passate** (3 celle × 2 finestre ×
2 gemelle).

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ **Questa pagina è pronta ma NON ancora lanciabile.** I cinque artefatti
> (driver + tre file prova + questa pagina) e l'EA `ABTG_OutOfNoise.mq5` con
> l'include `ABTG_PausaGuardian.mqh` devono essere **committati e pushati**;
> poi si **rilegge il pin DOPO il push** (mai prima) e lo si scrive qui al posto
> di `<PIN>`, in **tutti e tre** i punti d'uso (`$pin='...'`).
> **La riga NON va lanciata con `<PIN>` dentro.**

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per l'EA misurato**.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🔴 **L'EA NON È MAI STATO COMPILATO DA NESSUNO.** In questo ambiente non
  esiste MetaEditor. **Se la compilazione fallisce, il risultato del PASSO 0 è
  quello** e va riportato così com'è — le righe rosse finiscono in console e in
  `COMPILAZIONE_FALLITA.log` dentro lo zip.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare. `walkforward_generico.ps1` **non lo fa**, e senza quel file l'EA
  non compila.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini `7677xx`,
  `AllowLiveTrading=false` negli `.ini` (lo scrive il driver generico).
- **Zero parametri spazzolati.** L'unico asse `Y` è `InpMagic` (i gemelli di
  controllo), e il driver **si ferma** se in un file prova ne trova un secondo.
- ⏱️ **Durata [STIMA, non una previsione]: 10-30 minuti** più la compilazione.

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_PASSO0_OUTOFNOISE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_OUTOFNOISE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_OUTOFNOISE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine: `pin` e `celle ....... 3 su 3`; `driver generico
scaricato e PINNATO`; `file prova scaricati: 3`; `include scaricato:
ABTG_PausaGuardian.mqh (<n> byte)`; **`geometria, valori dei lati, FUSO (ora
server), baseline S0, stella e magic: TUTTI PASSATI`**; `include: INSTALLATO e
VERIFICATO`; **`compilato ABTG_OutOfNoise: OK (<n> KB, <ora>)`** — è il primo
risultato vero; poi tre volte l'anteprima dell'`.ini` e `ESITO: CONTROLLO
COMPLETATO`. Se esce `COMPILAZIONE FALLITA`, le righe rosse **sono il
risultato**.

> ⚠️ **`-SoloControllo` non apre MT5.** Nessun `n`, nessun PF, nessun DD,
> **nessun controllo sui gemelli**. Conferma gli **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_PASSO0_OUTOFNOISE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_OUTOFNOISE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_OUTOFNOISE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

### 🔁 Se serve riprendere una cella sola

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_PASSO0_OUTOFNOISE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_OUTOFNOISE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_OUTOFNOISE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloCella '02_short' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PASSO0_OUTOFNOISE_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PASSO0_OUTOFNOISE.txt`** ← **è questo che conta**;
- i **file prova** delle celle che hanno girato;
- i **CSV** `ABTG_OutOfNoise_NASUSD_IS_<cella>.csv` e `_OOS_<cella>.csv`.

Le due righe da guardare per prime: **`modo:`** (`CORSA` o `CONTROLLO`) e
**`data:`** (deve essere di ADESSO).

---

## ✅ COSA È GIÀ STATO VERIFICATO — in questo ambiente, prima dell'invio

- ✅ il `.ps1` **parsa**: `[Parser]::ParseFile` → **0 errori**, **5.542 token**;
  **ASCII puro** (0 byte non-ASCII, regola del 17/08);
- ✅ **audit collisioni CASE-INSENSITIVE sui token del codice**: **zero
  collisioni** (la coppia `$R`/`$r` di R109 è evitata con `$RefTxt`; niente
  `$args`, si usa `$argv`);
- ✅ **i gate girano DAVVERO sui tre file veri**: controllo positivo passato
  (3 celle, **6 magic unici** `767700/701/710/711/740/741`);
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno**:

  | corruzione | il gate ha detto |
  |---|---|
  | `InpSessionStartHour=15` (**ora italiana**) | `InpSessionStartHour=15 e' ORA ITALIANA` |
  | `InpSessionEndHour=16` (**orari DAX**) | `SessionEndHour '16'` (atteso 21) |
  | `InpSessionStartMin=0` | `SessionStartMin '0'` (atteso 30) |
  | `InpMT5PerPuntoIndice=1` (rompe S0) | `InpMT5PerPuntoIndice '1'` (atteso 100) |
  | i due file dei lati **scambiati** | `InpAllowShort vale 1, atteso 0` |
  | magic **vietato** (773500, il sorgente) | `magic 773500 VIETATO` |

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione** dell'EA (qui non c'è MetaEditor), il comportamento del tester,
la durata reale, e **ogni singolo numero**. Il giro a vuoto copre gli
artefatti; **i numeri li può dare solo la corsa**.
