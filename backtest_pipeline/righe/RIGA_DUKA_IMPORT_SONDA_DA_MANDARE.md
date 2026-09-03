# 🎫 DUKASCOPY IMPORT + SONDA — U30USD_DK dentro MT5 + cancello — DA MANDARE

**Che cos'e'.** Il **PASSO 4-5** di `DUKASCOPY_PASSO0.md`: prende i **CSV
mensili** prodotti dalla corsa DUKA (`U30USD_DK_ticks_AAAA-MM.csv` in
`%USERPROFILE%\dukascopy_lavoro\tick`), li **importa in MT5** come **custom
symbol `U30USD_DK`** con tick veri (`CustomTicksReplace` a blocchi, clonando
le proprieta' da `U30USD` nativo), e poi fa la **SONDA di sovrapposizione**
coi criteri **congelati** del par. 4a. Un solo verdetto: **OK / RICONVERTI
(DST) / CANCELLO CHIUSO**.

> **Da lanciare quando la corsa DUKA (tranche-sonda 2024-10-01 → 2025-06-16)
> ha finito** e i CSV mensili sono in `dukascopy_lavoro\tick`.

## 🖥️ SOLO SUL PC DI BACKTEST — e con MT5 CHIUSO

> Lo script MQL5 e' uno **SCRIPT** (`OnStart`): **non gira nel tester**, gira
> **nel terminale** su un grafico. Percio' questa riga **apre** `terminal64`
> con `/config [StartUp] Script=...` (stesso pattern collaudato di
> `scarica_storico.ps1`) e **pretende MT5 e MetaEditor CHIUSI**: un secondo
> avvio sulla stessa cartella dati non esegue lo startup script.
> **E' il PC di BACKTEST, non il VPS**: chiudere MT5 qui non spegne nessun
> forward. La config mette `[Experts] AllowLiveTrading=false` cosi' aprire il
> terminale (collegato al conto vivo 50503392) **non riarma gli EA su
> grafico** (lezione 14/08). L'import scrive un **custom symbol di backtest**,
> non tocca il forward.

## 🧊 LA BOZZA SI COMPILA QUI (primo compile = un passo del lancio)

> `mql5/Scripts/ABTG_ImportaTickEsterno.mq5` e' una **BOZZA MAI COMPILATA**
> (come nacque l'importer M1 v2). La riga la scarica al pin, la mette in
> `MQL5\Scripts` e la **compila con `metaeditor64` diretto** (lezione 22/08):
> se non produce l'`.ex5`, si ferma **prima** di aprire MT5 e stampa le
> ultime righe del log di compilazione.

## 🔎 GLI INPUT PASSATI (allineati al sorgente, verificati)

| input | valore | perche' |
|---|---|---|
| `InpSimboloSorgente` | `U30USD` | nativo BCM da cui clonare le proprieta' e per la sonda |
| `InpSimboloNuovo` | `U30USD_DK` | esplicito (mai stringa vuota come argomento) |
| `InpMascheraCsv` | `U30USD_DK_ticks_*.csv` | = nome file del `.py` (misurato riga 448) |
| `InpSoloSonda` | `false` | l'OnStart fa import **e** sonda nella stessa corsa |
| `InpCancellaEsistente` | `true` | azzera i tick del custom prima di riempirlo (idempotente) |
| `InpBloccoTick` | `100000` | tick per `CustomTicksReplace` |
| `InpGiorniSonda` | 6 giorni **dentro** la tranche | 2 normali + 4 nelle DUE finestre DST sfasate interne |
| `InpSogliaDiffPct` | `0.05` | cancello par. 4a (mediana \|diff bid\| al minuto) |
| `InpSogliaCopertura` | `80.0` | cancello par. 4a (copertura minuti) |

**Giorni sonda** = `2024.11.20;2025.06.10;2024.10.29;2024.10.31;2025.03.12;2025.03.25`.
I 2024.10.29/31 stanno nella settimana sfasata 27/10→03/11/2024; i 2025.03.12/25
nella 09/03→30/03/2025: sono il **discriminante DST** interno alla tranche. Le
altre due settimane sfasate del par. 3b (ott-2025, mar-2026) sono **fuori** dalla
tranche-sonda e si misureranno sulla tranche storica.

---

## 🧪 PRIMA: IL GIRO A VUOTO (obbligatorio, ~1 min — compila, prepara, NON apre MT5)

Compila la bozza, copia i CSV in `MQL5\Files`, scrive il preset. Non lancia
MT5. Se la compilazione e' rossa o mancano i CSV, si ferma qui.

`<PIN>` = l'hash del commit che contiene QUESTO pacchetto (dato in chat).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='2f56afb67aff5e199b858d4791aa63e02d351fd4'; $p="$env:USERPROFILE\RIGA_DUKA_IMPORT_SONDA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DUKA_IMPORT_SONDA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DUKA_IMPORT_SONDA_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -eq 0){ Write-Host 'GIRO A VUOTO: VERDE - compilazione OK, CSV pronti, preset scritto' -ForegroundColor Green }
    else { Write-Host 'GIRO A VUOTO: ROSSO - NON lanciare la corsa, leggi REFERTO_DUKA_IMPORT_SONDA.txt sul Desktop' -ForegroundColor Red } }
```

## ▶️ POI: IMPORT + SONDA (MT5 CHIUSO — la riga lo apre da sola)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='2f56afb67aff5e199b858d4791aa63e02d351fd4'; $p="$env:USERPROFILE\RIGA_DUKA_IMPORT_SONDA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DUKA_IMPORT_SONDA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DUKA_IMPORT_SONDA_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -eq 0){ Write-Host 'ESITO: CANCELLO PASSATO - U30USD_DK usabile per verdetti a parametri congelati. Manda lo zip DUKA_IMPORT_SONDA_*.zip' -ForegroundColor Green }
    elseif($LASTEXITCODE -eq 3){ Write-Host 'ESITO: QUASI - 1-2 giorni fuori. Leggi il referto: se sono SOLO i giorni DST, riconverti (vedi sotto)' -ForegroundColor Yellow }
    elseif($LASTEXITCODE -eq 2){ Write-Host 'ESITO: SONDA NON MISURABILE - vedi NOTA native ticks nel referto, poi -SoloSonda' -ForegroundColor Yellow }
    else { Write-Host 'ESITO: CANCELLO CHIUSO o FERMATA - leggi REFERTO_DUKA_IMPORT_SONDA.txt sul Desktop' -ForegroundColor Red } }
```

---

## 📤 Cosa arriva sul Desktop (e cosa mandare a Claude)

- Cartella `DUKA_IMPORT_SONDA_<data_ora>` con:
  - **`REFERTO_DUKA_IMPORT_SONDA.txt`** — data/modo/pin, compilazione, CSV
    copiati, **ESITO SONDA** e **VERDETTO**, i criteri, la nota native-ticks;
  - **`ABTG_ImportTick_referto.csv`** — il referto CSV dello script (tick
    scritti, righe scartate, fuori ordine, esito sonda, verdetto);
  - gli ultimi 2 `*.log` di MT5 (li' c'e' il dettaglio **per giorno**:
    diff mediana %, copertura %, tick nat/DK, **spread nat/DK dichiarato**).
- **Zip** `DUKA_IMPORT_SONDA_<data_ora>.zip` pronto da mandare.

> **Quale data leggere** per capire se il referto e' nuovo: la riga `data:`
> del `REFERTO_DUKA_IMPORT_SONDA.txt` e' l'**ORA DI AVVIO** della riga (non
> l'ora attuale) — dev'essere di **oggi**. E nel `ABTG_ImportTick_referto.csv`
> conta **l'ULTIMA riga** (il referto e' cumulativo/append: la corsa nuova
> aggiunge una riga in fondo).

## 🧭 COME SI LEGGE IL VERDETTO (criteri congelati, par. 4a)

- **OK: CANCELLO PASSATO** → tutti i giorni misurati dentro soglia →
  `U30USD_DK` e' usabile per **VERDETTI A PARAMETRI CONGELATI** (NY Retest
  slope75, cella gia' tarata su BCM). **Non si tara nulla sul feed esterno.**
- **QUASI** (codice 3) → 1-2 giorni fuori: leggi **QUALI**. Se sono **SOLO**
  i giorni DST (2024.10.29/31 e/o 2025.03.12/25), il calendario e' sbagliato:
  **RICONVERTI** (sotto) e **rilancia questa stessa riga** (import+sonda).
- **CANCELLO CHIUSO** (codice 1) → giorni fuori anche NON-DST → i `_DK` vanno
  **in frigo** come gli `_EXT` HistData. Nessun "pero' quasi".
- **SONDA NON MISURABILE** (codice 2) → vedi nota sotto.

### 🔁 Se il verdetto e' RICONVERTI (DST)
1. `RIGA_DUKA_A` con `-SoloCache -Dst europa` (zero riscarichi, la cache basta);
2. i CSV in `dukascopy_lavoro\tick` cambiano → **rilancia QUESTA riga**
   (import+sonda, **non** `-SoloSonda`: i CSV sono cambiati, va ri-importato).

### ⚠️ NOTA RUNTIME — tick nativi per la sonda
La sonda confronta il custom con i **tick nativi** di `U30USD` via
`CopyTicksRange`. Se un giorno esce **`tick nativi=0 → NON confrontabile`**, il
terminale non aveva ancora scaricato la storia tick nativa di quel giorno:
apri un grafico `U30USD` M1, lascia che MT5 la scarichi, poi **rilancia la
sola sonda** con `-SoloSonda` (non ri-importa, ri-misura soltanto):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='2f56afb67aff5e199b858d4791aa63e02d351fd4'; $p="$env:USERPROFILE\RIGA_DUKA_IMPORT_SONDA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DUKA_IMPORT_SONDA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DUKA_IMPORT_SONDA_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloSonda }
```

## 🔢 Codici d'uscita

- `0` → **OK**: cancello passato (o giro a vuoto passato).
- `3` → **QUASI**: 1-2 giorni fuori (leggi quali; se DST → riconverti).
- `2` → **SONDA NON MISURABILE** / referto non fresco / timeout (parziale).
- `1` → **FERMATA** (pin non valido, MT5 aperto, compilazione fallita, CSV
  mancanti) **o CANCELLO CHIUSO** (i `_DK` in frigo). Il referto dice quale.

## 🛤️ Il passo DOPO (non questa riga)

Solo se **OK**: il verdetto **NY Retest a parametri congelati** su `U30USD_DK`
(cella slope75, n da 114 a stima ~600+) e, a cancello passato, la **tranche
storica** 2019-01-01 → 2024-09-30 (`RIGA_DUKA_A` con `-Da/-A`). Tutto in
`DUKASCOPY_PASSO0.md` par. 4-6.
