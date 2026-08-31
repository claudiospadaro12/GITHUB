# 📬 CHAOS ABLAZIONE — **LA RIGA DA MANDARE**

**Che cos'è:** la **baseline GATE-OFF** che mancava alla griglia CHAOS —
**2 celle secche** sullo stesso banco: `InpLyaThreshold=0.09` (il gate LLE al suo
**MEGLIO**: cella top della griglia, lb=50/sl=0.5, PF 1.789) contro
`InpLyaThreshold=999.0` (**gate sempre aperto = motore NUDO**, EMA-cross 9/21
senza filtro). EA `ABTG_ChaosLyapunov` su **NASUSD_EXT M15**, **OHLC (Modello
1)**, finestra **2020.01.01 → 2024.01.01** (identica alla griglia).

> 🪦 **L'EA È GIÀ BOCCIATO** (griglia 105 celle, referto 31/08: fascia
> PF≥1.3&DD<8 = 1 outlier, tesi "LLE basso = tradeable" **falsificata**) **e
> resta bocciato in OGNI caso**, qualunque numero esca da qui. Questa corsa
> misura **l'INGREDIENTE** (il gate LLE come attrezzo per ALTRI motori), non
> l'EA. **Niente è deployabile da questo round.**

> 🔴 **OHLC INGANNA:** si legge il **CONFRONTO tra le 2 righe** (stesso banco,
> stesso bias), **MAI i numeri assoluti**.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_ChaosLyapunov.mq5` (già compilato OK il 31/08; la riga ricompila comunque al pin) |
| **Driver** | `righe/RIGA_CHAOSABL.ps1` (marcatore `MARCATORE_RIGA_CHAOSABL_v2`) |
| **File prova** | `prove/ABTG_ChaosLyapunov_Abl.txt` (1 asse a 2 valori + fissi pinnati) |
| **Include** | **nessuno** (solo `Trade\Trade.mqh`, di serie) |

---

## 🎯 IL DISEGNO — **1 asse, 2 celle**

| asse | valori | cosa misura |
|---|---|---|
| `InpLyaThreshold` | **0.09** e **999.0** | 0.09 = gate al suo meglio; 999.0 = gate mai attivo (nel sorgente il blocco è `lle > soglia` → con 999 **non scatta mai**) |

**Fissi (pinnati dal gate del driver):** `InpLyaLookback=50`, `InpSlAtrMult=0.5`
(coordinate della **cella migliore** della griglia), `InpRiskPercent=1.0`,
`InpMinStopPts=500` (pavimento R109). Magic **769200 fisso** (mai deployato),
motore nudo come in griglia: **l'ablazione cambia UNA cosa sola, la soglia**.

---

## ⚖️ CRITERI CONGELATI (nel prova, PRIMA dei numeri)

Il LLE si **promuove in cassetta attrezzi** (da rimisurare su ALTRO motore prima
dell'uso) **solo se** la cella gated batte la nuda su **tutti e due**:
`PF_gated ≥ PF_nudo + 0.20` **E** `profit_gated ≥ profit_nudo`.
Altrimenti → **SEPOLTURA definitiva del filtro LLE**. In ogni caso l'EA resta
bocciato.

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

> ⚠️ Driver, prova ed EA vanno committati e pushati; poi si **rilegge il pin DOPO
> il push** e lo si scrive al posto di `<PIN>` in **entrambe** le righe
> (`$pin='...'`). **La riga NON va lanciata con `<PIN>` dentro.**

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor CHIUSI.** La riga si rifiuta di partire in entrambi i casi.
- 🗂️ **`NASUSD_EXT` deve essere già importato** (c'era per la griglia CHAOS del
  31/08: dovrebbe esserci ancora). Se manca, la riga si ferma con l'errore onesto.
- ⏱️ **Durata [STIMA]: pochi minuti** più la compilazione (2 celle sole, OHLC).

---

## 1️⃣ PRIMA il giro a vuoto (compila + gate, NON apre MT5)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CHAOSABL.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CHAOSABL.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CHAOSABL_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Deve dire, alla fine:** `geometria, 1 asse (InpLyaThreshold), sweep non
degenere, fissi pinnati (lb 50 / sl 0.5 / floor 500), pavimento SL (R109): TUTTI
PASSATI`; `simbolo custom: NASUSD_EXT TROVATO (...)`; `compilato
ABTG_ChaosLyapunov: OK (<n> KB)`; `ESITO: CONTROLLO COMPLETATO`.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CHAOSABL.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CHAOSABL.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CHAOSABL_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**.

---

## 📦 COSA TORNA INDIETRO

Zip sul **Desktop**: `CHAOSABL_<MODO>_<data>_<ora>.zip` → dentro
`REFERTO_CHAOSABL.txt` + il prova + (nella corsa) il CSV `..._IS_ohlc.csv` con
**2 righe**. ⚠️ Il CSV `..._OOS_ohlc.csv` **NON esiste mai** (FrazioneIS 1.0 =
gamba OOS degenere): il blocco ROSSO del generico su quel file è **ATTESO — NON
rilanciare**. **Mandami lo zip.**

### 🔍 Come si legge (2 righe, un confronto)

1. riga `InpLyaThreshold=0.09` → **GATED** (il gate al suo meglio);
2. riga `InpLyaThreshold=999.0` → **NUDO** (gate sempre aperto);
3. 🧪 **controllo di lettura meccanico:** nella riga 999 la colonna **`Gate Chaos
   Ko` deve stare a ESATTAMENTE 0** (l'LLE è un logaritmo: non può superare 999,
   quindi il conteggio è provabilmente zero). Se non è 0, la corsa **non ha
   misurato il nudo**: si butta e si indaga, non si interpreta;
4. poi i criteri congelati: `PF_gated ≥ PF_nudo + 0.20` **E** `profit_gated ≥
   profit_nudo` → LLE in cassetta attrezzi; **altrimenti sepoltura definitiva**.
   L'EA resta bocciato **comunque**.

> 📏 Il per-trade CSV di questa corsa **non si legge** (2 celle, stesso magic
> 769200 → sopravvive solo l'ultima passata), come già dichiarato per la griglia.

## 🧊 CONTROLLI DI FRESCHEZZA (aggiunti al v2, dopo il gate del 31/08)

- **Giro a vuoto e corsa**: in console deve comparire `Tester\cache svuotata:
  prima <n> file, dopo 0` — la cella gated 0.09 è GIÀ girata nella griglia di
  stamattina: senza svuotare la cache MT5 la RIPESCEREBBE e la riga sparirebbe
  dal CSV (con esito verde!).
- **Corsa**: nel referto la riga `righe CSV IS:` deve dire **2 righe dati
  (attese 2), soglie 0.09 e 999 PRESENTI** — il confronto È il round: una riga
  sola = niente ablazione, la riga alza PROBLEMA da sola.
- 🕐 Apri `REFERTO_CHAOSABL.txt` e guarda la riga `data:` in cima — se non è di
  oggi hai riaperto uno zip vecchio. E `modo:` deve dire CORSA.
