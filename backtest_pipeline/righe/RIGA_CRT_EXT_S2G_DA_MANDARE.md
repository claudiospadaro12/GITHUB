# 📬 CRT STAGE-2 GATED (ADX≤30) per regime — **LA RIGA DA MANDARE**

**Che cos'è:** la conferma **per regime** della cella vincente del gate (wick 2.0,
mid 0, side 2 + **GATE ON ADX(D1)≤30** → +10135, n=201, PF 1.65, DD 2.6%). Cella
FISSA + gate acceso, unico asse Y = **gemelli magic 769103/769104** → 2 per-trade
CSV distinti, su NASUSD_EXT M15 OHLC 2020-2024. Li segmento per regime.

> 🎯 **La domanda:** il gate ha reso **~FLAT** il crollo 2020 e il toro 2021 (ADX
> alto → bloccati), **tenendo** il verde del chop (orso 2022, range 2023)? Se sì →
> **chop-gate CONFERMATO**. Se il crollo/toro NON sono flat → il gate non fa quel
> che promette.

> 🔴 OHLC ottimista. 🕒 Fuso NY: flat 16:00 NY.

| | |
|---|---|
| **Driver** | `righe/RIGA_CRT_EXT_S2G.ps1` (marcatore `MARCATORE_RIGA_CRT_EXT_S2G_v1`) |
| **File prova** | `prove/ABTG_CRT_TurtleSoup_EXT_S2G.txt` (cella + gate ADX≤30, gemelli) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.** ⏱️ ~5-15 min.

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_EXT_S2G.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_EXT_S2G.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_EXT_S2G_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_EXT_S2G.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_EXT_S2G.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_EXT_S2G_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `CRT_EXT_S2G_...zip` → `REFERTO_CRT_EXT_S2G.txt` + il prova + **i due
per-trade CSV** `abtg_trades_..._769103/769104.csv` (identici: gemelli) + la griglia.
**Mandami lo zip** e segmento per regime per confermare il chop-gate.
