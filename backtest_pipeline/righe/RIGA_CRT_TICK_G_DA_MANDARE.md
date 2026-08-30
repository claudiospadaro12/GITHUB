# 📬 CRT GATED TICK BCM — **LA RIGA DA MANDARE** (il verdetto vero)

**Che cos'è:** la cella vincente + **GATE ON ADX(D1)≤30** a **TICK REALI (Modello 4)**
su **NASUSD BCM** M15, **2024.09.26 → 2026.06.30** (il toro attuale). Unico asse Y =
gemelli magic 769105/769106. **È un VERDETTO tick, non OHLC.**

> 🎯 **La domanda:** l'ungated a tick nel toro era **PF 0.5** (morto, 0/30). Il gate
> taglia i trend-trade → **porta il tick a PF ≥ 1 nel toro di OGGI?** Se sì → edge
> **tick-verificato nel regime attuale** → **deployabile piccolo, SENZA Dukascopy**.

> 🕒 **FUSO DI CASA (non invertito):** NASUSD BCM = ora **SERVER** → flat RTH **21:00
> server** (`InpCloseHour=21`), **NON 16** (che è l'ora NY del feed _EXT). Il gate
> **rifiuta 16, pretende 21** — è l'opposto dei round _EXT.
> 🟢 NASUSD è **nativo BCM** (niente import storico).

| | |
|---|---|
| **Driver** | `righe/RIGA_CRT_TICK_G.ps1` (marcatore `MARCATORE_RIGA_CRT_TICK_G_v1`) |
| **File prova** | `prove/ABTG_CRT_TurtleSoup_TICK_G.txt` (cella + gate ADX≤30, gemelli, flat 21) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.** ⏱️ ~15-40 min (tick, 21 mesi).

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_TICK_G.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_TICK_G.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_TICK_G_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_TICK_G.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_TICK_G.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_TICK_G_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `CRT_TICK_G_...zip` → `REFERTO_CRT_TICK_G.txt` + il prova + **i due
per-trade CSV** `abtg_trades_..._769105/769106.csv` + la griglia gemelli (tick).
**Mandami lo zip** e leggo il verdetto tick.
