# 🎫 MISSIONE A DUKASCOPY — download TICK del Dow — DA MANDARE

**Che cos'e'.** Il **PASSO 1** del piano di `DUKASCOPY_PASSO0.md`: scarica i
**tick Dukascopy del Dow** (`USA30IDXUSD`) sulla finestra **DICHIARATA
PRIMA la TRANCHE-SONDA 2024-10-01 → 2025-06-16, POI la storica** (corretto
31/08 dal verificatore: la vecchia finestra 2019→2024-09-25 era costruita per
NON sovrapporsi al nativo, ma il CANCELLO di validazione vive proprio sulla
sovrapposizione — 0/10 giorni-sonda coperti. NB: diverge anche dal PASSO0
par.4b, dichiarato). La tranche-sonda copre 6/10 giorni campione congelati e
DUE finestre DST sfasate; la storica 2019-01-01 → 2024-09-30 (confini di MESE:
mai spezzare un mese fra tranche, i CSV sono mensili) parte SOLO a cancello
passato. (nota storica: la finestra originale si saldava al tick nativo BCM che parte il
2024-09-26) e li converte in **CSV mensili `U30USD_DK_ticks_AAAA-MM.csv`**
in ora server (calendario DST `usa`, il default del progetto — il
**discriminante congelato** si esegue DOPO, alla sonda dell'import; se vince
"europa" si riconverte con `-SoloCache -Dst europa`, **zero riscarichi**).

**Solo download + conversione. NON importa in MT5, non promuove niente,
non tocca nessun numero.** L'import e la sonda sono il passo dopo.

## 🖥️ SI LANCIA SUL PC DI BACKTEST — e MT5 PUO' RESTARE APERTO

> Questa riga e' **puro HTTP** verso `datafeed.dukascopy.com`: **non tocca
> MT5** (niente guardia MT5-chiuso, apposta). Le sedie in forward
> continuano a girare. Il proxy del cloud invece **blocca** Dukascopy
> (misurato il 18/08): quindi PC di backtest, non cloud.

## 🚀 MOTORE CURL (v3 — la cura misurata del 31/08)

> Il server **strozza l'impronta TLS di python-urllib** (WinError
> 10060/10054 + 503 a raffica, anche con User-Agent Mozilla) ma **fa
> passare curl.exe** — MISURATO il 31/08 pomeriggio: `curl.exe` sul
> canarino EURUSD = HTTP 200, 24043 byte, **nello stesso minuto** in cui
> lo script urllib moriva. Percio' questa riga passa **SEMPRE
> `--motore curl`** al `.py` (marcatore `DUKA-TICK-v2`) e ha un **gate
> nuovo**: `curl.exe` deve esserci (su Windows 10 1803+ sta gia' in
> `C:\Windows\System32`). NB: in PowerShell `curl` senza `.exe` e' un
> alias di `Invoke-WebRequest` e NON conta — il gate lo sa. La pipeline
> a valle e' SANA (feed Dow gia' misurato nella corsa 15:18: ordine campi
> p1_ask coerenza 100% su 108108 tick, divisore 1000): cambia SOLO il
> motore di rete.

## 🌙 E' UNA CORSA DA NOTTI — leggere PRIMA di lanciare

- **Durata**: ~1.790 giorni iterati × ~4 min/giorno (ritmo **misurato** il
  18/08) = TRANCHE-SONDA **~15 ore = una notte + una mattina**; la tranche
storica (dopo il cancello) ~120 ore = **5 GIORNI di PC acceso, giorno e
notte**. Il ritmo vero lo stampa il `.py`
  ogni 25 giorni ("`RESTANO ~N ORE`"): se e' molto peggio, CTRL+C e si
  ridiscute — non si insiste.
- **RIPRENDIBILE, gratis**: cache per ora scaricata (anche i 404),
  scritture atomiche, CSV mensili scritti appena il mese e' completo.
  **Rilanciare la stessa riga riprende da dove era senza riscaricare.**
  CTRL+C non butta via niente.
- **Il PC NON deve andare in SOSPENSIONE** (la corsa morirebbe — si
  riprende, ma la notte e' persa). Prima della prima notte:
  ```powershell
  powercfg /change standby-timeout-ac 0
  ```
  (0 = mai sospendere con alimentazione. Per rimettere com'era:
  `powercfg /change standby-timeout-ac 30`.)
- **Disco**: il gate pretende **12 GB liberi** (stima PASSO 0 ~10 GB +
  margine). Sotto soglia si ferma con errore onesto PRIMA di partire.

## 📁 Dove finisce cosa (misurato nel `.py`, non supposto)

Il `.py` ha una struttura fissa sotto `%USERPROFILE%\dukascopy_lavoro`:
- `raw\` — la cache, **la stessa di `dukascopy_m1.py`**: i giorni gia'
  scaricati il 20/08 restano buoni;
- `tick\` — i CSV mensili `U30USD_DK_ticks_*.csv` + il referto del `.py`.

(Il progetto aveva ipotizzato `duka_cache\` e `duka_csv\`: il `.py` non li
prevede e spostare la cache butterebbe via il gia' scaricato. Dichiarato.)

---

## 🧪 PRIMA: IL GIRO A VUOTO (obbligatorio, 1-2 minuti, ZERO download)

Verifica python (pattern misurato della riga M1: niente stub del Microsoft
Store), i 12 GB di disco, la cache scrivibile, **curl.exe presente** (gate
nuovo della v3) e fa girare l'**autotest 10/10** del `.py`. Se qualcosa e'
rosso, si ferma PRIMA di toccare la rete.

`<PIN>` = l'hash del commit che contiene QUESTO pacchetto, dato in chat.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_DUKA_A.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DUKA_A.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DUKA_A_v3' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Da '2024-10-01' -A '2025-06-16' -SoloControllo;
    if($LASTEXITCODE -eq 0){ Write-Host 'GIRO A VUOTO: VERDE - tutti i gate passati, si puo lanciare la corsa' -ForegroundColor Green }
    else { Write-Host 'GIRO A VUOTO: ROSSO - NON lanciare la corsa, leggi REFERTO_DUKA_A.txt sul Desktop' -ForegroundColor Red } }
```

## ▶️ POI: LA CORSA VERA (identica, senza `-SoloControllo`)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_DUKA_A.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DUKA_A.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DUKA_A_v3' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Da '2024-10-01' -A '2025-06-16';
    if($LASTEXITCODE -eq 0){ Write-Host 'ESITO: CORSA COMPLETA - manda a Claude SOLO lo zip DUKA_A_*.zip dal Desktop' -ForegroundColor Green }
    elseif($LASTEXITCODE -eq 3){ Write-Host 'ESITO: RIPRENDIBILE - RILANCIA ESATTAMENTE QUESTA STESSA RIGA, la cache non riscarica niente' -ForegroundColor Yellow }
    else { Write-Host 'ESITO: FERMATA - leggi REFERTO_DUKA_A.txt sul Desktop: se dice ban 503 aspetta e RILANCIA la stessa riga' -ForegroundColor Red } }
```

**Per riprendere dopo una notte / un'interruzione: si rilancia ESATTAMENTE
questa stessa riga.** La cache fa il resto.

---

## 📤 Cosa arriva sul Desktop (e cosa mandare a Claude)

- Cartella `DUKA_A_<data_ora>` con:
  - **`REFERTO_DUKA_A.txt`** — data/modo, finestra, strumento, **giorni
    completati/totali, MB scaricati, CSV prodotti** (elenco con i MB),
    prime/ultime righe campione, e la scritta
    "IL DOWNLOAD E' RIPRENDIBILE: rilancia la stessa riga per continuare";
  - `console_duka_a_<data_ora>.txt` — la console col ritmo e le proiezioni;
  - `autotest.txt`, `referto_py_<data_ora>.txt`.
- **Zip LEGGERO `DUKA_A_<data_ora>.zip`** pronto da mandare.
- `STATO_DUKA_A.txt` — le istruzioni di ripresa, scritte PRIMA che la
  corsa parta (se il PC muore, restano li').

**A Claude va SOLO lo zip leggero** (qualche KB/MB). **MAI zippare i GB di
CSV**: quelli restano in `dukascopy_lavoro\tick\` per il passo di import.

## 🔢 Codici d'uscita

- `0` → corsa **completa** (o giro a vuoto passato).
- `3` → **riprendibile**: con buchi (rc 3 del `.py`) o interrotta a mano.
  Referto e zip ci sono lo stesso. **Rilanciare la stessa riga.**
- `1` → fermata: pin non valido, gate fallito (python/disco/cache),
  autotest rosso, o corsa fallita (controllo positivo / ban 503 /
  divisore). Il referto dice quale.

## 🛤️ Il passo DOPO (non questa riga)

CSV mensili → `MQL5\Files` del terminale di backtest → Script
`ABTG_ImportaTickEsterno` (clone `U30USD_DK` + `CustomTicksReplace`) →
**SONDA** coi criteri congelati (mediana ≤0,05%, copertura ≥80%,
discriminante DST sulle 4 settimane sfasate) → solo dopo, il verdetto
NY Retest a parametri congelati. Tutto in `DUKASCOPY_PASSO0.md` par. 4.

## 🌙 TRANCHE STORICA (SOLO dopo che import+sonda passano il cancello)
Identica alla corsa vera ma con `-Da '2019-01-01' -A '2024-09-30'` (~120 ore =
5 giorni di PC acceso). NON lanciarla prima del cancello: 0/10 giorni-sonda
starebbero nella finestra, e i confini sono di MESE per non riscrivere i CSV
mensili della tranche-sonda.

## ⚠️ DUE ZIP SUL DESKTOP
A fine corsa ci saranno DUE zip: **`DUKA_A_<data_ora>.zip` (QUESTO va mandato)**
e `dukascopy_tick.zip` (lo lascia il `.py`: ignoralo). E nel referto la riga
`data :` deve essere di OGGI. Prima della notte: `powercfg /change
standby-timeout-ac 0` (per rimettere com'era: `... 30`).
