# 📬 CRT chop-GATE — **LA RIGA DA MANDARE**

**Che cos'è:** la prova del **gate di regime** del CRT. Cella robusta FISSA (wick
2.0, mid 0, side 2), **gate ACCESO**, e si **spazzano le due soglie**
(`InpAdxMax` × `InpAtrMinPts`) su NASUSD_EXT M15 OHLC 2020-2024. La griglia dice se
il gate **MORDE** — se taglia le perdite di crollo 2020 + toro 2021 tenendo il chop.

> 🔴 **SCREENING OHLC (ottimista).** Riferimento ungated (stage-2): **+5744, n=320**.
> Il gate MORDE se una cella ha **total > +5744 con n < 320** (ha tagliato i perdenti,
> tenuto i vincenti). Se muovendo le soglie total/n non cambiano → gate decorativo o
> ATR-scale fuori range → ritarare/seppellire.

> 🕒 **Fuso INVERTITO:** flat RTH **16:00 NY** (`InpCloseHour=16`).
> ⚠️ **ATR scale INCERTA** (esploratorio): il range `InpAtrMinPts` 0..300 è una stima
> (Nasdaq ~15000, ~1-2%/gg). Se il gate non morde in questo range, ritariamo.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_CRT_TurtleSoup.mq5` (col gate, `InpUseRegimeGate`) |
| **Driver** | `righe/RIGA_CRT_GATE.ps1` (marcatore `MARCATORE_RIGA_CRT_GATE_v1`) |
| **File prova** | `prove/ABTG_CRT_TurtleSoup_GATE.txt` (cella fissa + gate ON, 2 assi soglie) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.** ⏱️ ~15-40 min (20 celle a OHLC).

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_GATE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_GATE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_GATE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_GATE.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_GATE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_GATE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `CRT_GATE_...zip` → `REFERTO_CRT_GATE.txt` + il prova + la griglia
`..._IS_ohlc.csv` (le 20 celle delle soglie). **Mandami lo zip** e leggo se il gate morde.
