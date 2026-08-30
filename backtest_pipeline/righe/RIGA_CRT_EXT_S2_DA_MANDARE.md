# 📬 CRT — STAGE-2 (cella robusta per regime) — **LA RIGA DA MANDARE**

**Che cos'è:** la conferma **per regime** della cella robusta del tiebreaker
(wick 2.0, mid 0, side 2 → n=320, PF 1.18, +5744, DD 5.9%). **UNA cella sola**
(nessuno sweep) su NASUSD_EXT M15 OHLC 2020-2024 → il per-trade CSV esce **pulito**
e lo segmento per regime (crollo 2020 / toro 2021 / orso 2022 / 2023).

> 🔴 **SCREENING OHLC (ottimista).** La domanda: il verde viene dalla **TEMPESTA**
> (crollo 2020 e/o orso 2022) o è un artefatto? Il toro 2021 rosso/piatto è
> **atteso** per un fade. Se il verde è tutto nella tempesta → **storm-gated
> confermato**. Se viene dal toro o da un mese outlier → **sepoltura**.

> 🕒 **Fuso INVERTITO:** flat RTH **16:00 NY** (`InpCloseHour=16`), non 21 server.

| | |
|---|---|
| **Driver** | `righe/RIGA_CRT_EXT_S2.ps1` (marcatore `MARCATORE_RIGA_CRT_EXT_S2_v1`) |
| **File prova** | `prove/ABTG_CRT_TurtleSoup_EXT_S2.txt` (cella singola, 0 assi Y) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.** ⏱️ ~5-15 min (una cella sola).

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_EXT_S2.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_EXT_S2.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_EXT_S2_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_EXT_S2.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_EXT_S2.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_EXT_S2_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `CRT_EXT_S2_...zip` → `REFERTO_CRT_EXT_S2.txt` + il prova + **il
per-trade CSV** `abtg_trades_ABTG_CRT_TurtleSoup_NASUSD_EXT_769100.csv` (l'artefatto
che conta) + la griglia a 1 riga. **Mandami lo zip** e lo segmento per regime.
