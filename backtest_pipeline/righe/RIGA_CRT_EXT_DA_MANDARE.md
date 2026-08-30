# 📬 CRT TURTLE SOUP — TIEBREAKER DI REGIME — **LA RIGA DA MANDARE**

**Che cos'è:** il **tiebreaker** dopo il verdetto tick (CRT morto nel toro, 0/30
celle verdi). Screening **OHLC (Modello 1)** su **NASUSD_EXT M15**, finestra
**2020-2024** (crollo 2020 + toro 2021 + orso 2022 + 2023). Stesso sweep a 3 assi.
La domanda: **il CRT vive nella TEMPESTA?**

> 🔴 **SCREENING, NON UN VERDETTO. Modello 1 (OHLC) = OTTIMISTA.** Si legge la
> **FORMA**, mai i numeri fini. Se anche l'OHLC è rosso ovunque → il tick sarebbe
> peggio → **sepoltura**. Se una cella è netta verde sul totale 2020-2024 (la
> tempesta la porta nonostante il toro 2021) → stage-2 per-regime.

> 🕒 **FUSO INVERTITO (critico):** su `NASUSD_EXT` il feed è a ora **NEW YORK** →
> flat RTH **16:00 NY** (`InpCloseHour=16`), **NON** 21 (ora server, che vale solo
> per la cella tick BCM). Il gate **rifiuta 21**.

> 🗂️ **`NASUSD_EXT` è storico ESTERNO (custom).** La riga controlla
> `bases\Custom\history\NASUSD_EXT` **prima** di aprire MT5: se manca **si ferma
> con l'errore onesto** — è lo stesso feed che abbiamo già importato per InvEsaurimento
> e shortgate, quindi dovrebbe esserci.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_CRT_TurtleSoup.mq5` (già compilato dal round tick; qui si ricompila al pin) |
| **Driver** | `righe/RIGA_CRT_EXT.ps1` (marcatore `MARCATORE_RIGA_CRT_EXT_v1`) |
| **File prova** | `prove/ABTG_CRT_TurtleSoup_EXT.txt` (3 assi + fissi flat 16 NY) |

---

## ⚠️ PRIMA DI LANCIARE (sul PC DI BACKTEST, non VPS)
- **MT5 e MetaEditor CHIUSI.** La riga si rifiuta di partire altrimenti.
- Si incolla **il blocco INTERO**: è un comando solo.
- ⏱️ Durata [STIMA]: dell'ordine di 10-25 minuti (OHLC è più veloce del tick).

---

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

---

## 1️⃣ PRIMA il giro a vuoto (compila + gate, non apre MT5)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_EXT.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_EXT.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_EXT_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Deve dire:** `geometria _EXT, 3 assi, sweep non degenere, pavimento SL (R109),
FUSO NY (flat 16): TUTTI PASSATI`; `simbolo custom: NASUSD_EXT TROVATO (...)`;
`compilato ABTG_CRT_TurtleSoup: OK (...)`; `ESITO: CONTROLLO COMPLETATO`.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_CRT_EXT.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_CRT_EXT.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_CRT_EXT_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

---

## 📦 COSA TORNA
Zip sul **Desktop**: `CRT_EXT_<MODO>_<data>_<ora>.zip` → `REFERTO_CRT_EXT.txt` +
il prova + i CSV `..._NASUSD_EXT_IS_ohlc.csv` (la griglia 2020-2024) e `OOS_ohlc`
(degenere). **Mandami lo zip** e leggo la griglia per regime.
