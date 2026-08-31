# 📬 DAX REENTRY — **LA RIGA DA MANDARE** (PASSO 0 + misura a tick)

**Che cos'è:** primo giro in assoluto di **`ABTG_DaxReEntry`** (sweep+reclaim del
range mattutino DAX, meccanica da KepiroG/TradingView reimplementata, **mai
compilato né testato**): **PASSO 0 + MISURA a TICK REALI (Modello 4)** su
**D30EUR BCM M5**, **2024.09.26 → 2026.06.30**, con gli **ASSI VERI del prova**:
`InpBreakPts {20,30,40}` × `InpSide {0,1,2}` (+ `InpSlFracRange` dichiarato ma di
fatto a **1 valore**, 0.454) = **9 passate**, magic **FISSO 769300**.
**È una MISURA, non un verdetto.**

> 🎯 **La domanda:** quante false rotture rientrate fa DAVVERO il mezzogiorno DAX
> su M5 (frequenza, cella per cella), e il **lordo medio/operazione copre ≥ 3×
> lo spread** della fascia sottile (cancello S0, congelato nel prova PRIMA dei
> numeri)? Se non copre → **STOP senza leggere nessun PF**. 21 mesi = un solo
> regime: **merito sospeso se n<150 (R59), rischio SEMPRE**. Zero overnight o il
> file è **invalido** (soglia 5%, misurata dalla riga da sola).

> 🕒 **FUSO DI CASA (regola fissa):** D30EUR BCM = ora **SERVER** (IT−1) → range
> **08:35–11:05**, trading **11:05–14:15**, flat **16:30** server (= cash close
> 17:30 IT). Il gate **rifiuta il 9 e il 17** (le ore ITALIANE) per nome.
> 🟢 D30EUR è **nativo BCM** (niente import storico). Conversione
> `InpMT5PerPuntoIndice=100` **MISURATA** (Breakin 31/08), non più da verificare.
> ⚠️ La riga **compila l'EA** (cancellando l'.ex5 vecchio): se la compilazione
> fallisce, **quello È il risultato del passo** — manda lo zip lo stesso.
> 🧲 **Niente gemelli InpMagic** qui: i gemelli sono il disegno della **cella
> fissa**; con assi veri il magic resta fisso (769300) e il gate lo pretende.

| | |
|---|---|
| **Driver** | `righe/RIGA_DAXREENTRY.ps1` (marcatore `MARCATORE_RIGA_DAXREENTRY_v1`) |
| **File prova** | `prove/ABTG_DaxReEntry.txt` (direttive NUDE + @FINOA, assi veri, fissi pinnati, fuso server) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.** ⏱️ **~45 min – 3 h** (tick
M5, 21 mesi, **9 passate**: è il giro DAX più pesante finora — lanciarlo quando
il PC può restare tranquillo). La gamba OOS del generico è **degenere**
(FrazioneIS 1.0): il rosso sul CSV `*_OOS` è **atteso**, NON rilanciare.

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_DAXREENTRY.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DAXREENTRY.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DAXREENTRY_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_DAXREENTRY.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DAXREENTRY.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DAXREENTRY_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `DAXREENTRY_...zip` → `REFERTO_DAXREENTRY.txt` + il prova + il
**per-trade CSV** `abtg_trades_ABTG_DaxReEntry_D30EUR_769300.csv` + la **griglia
IS a 9 righe** (tick — con Trades, Autotest Falliti, Flat Giorni/Chiusure e la
diagnostica dei cancelli in colonna). **Mandami lo zip `DAXREENTRY_CORSA_...zip`**
(quello `_CONTROLLO_` è solo il giro a vuoto) e da lì esce il verdetto S0.

🕐 **PRIMA DI LEGGERE:** apri `REFERTO_DAXREENTRY.txt` e controlla:
- riga `data:` → deve essere **l'ora di adesso** (un referto vecchio = giro stantio);
- riga `modo:` → deve dire **CORSA**, non CONTROLLO;
- riga `cache tester:` → deve dire **svuotata** (un pass ripescato non chiama
  OnTester: CSV senza righe);
- riga `griglia IS:` → **9 passate** contate (non un Test-Path: righe vere);
- riga `per-trade CSV:` → `OPERAZIONI magic 769300 -> N` — in griglia è **SOLO
  l'ultima passata con uscite** (magic fisso), dichiarato: la frequenza vera
  sta nella colonna **Trades** del CSV IS, cella per cella;
- riga `overnight veri:` → open_time vs close_time, **>5% = file invalido**,
  sotto = rilievo col gap-risk dichiarato.

## ⚠️ AVVISI
- **Il rosso del generico sul CSV `*_OOS` è ATTESO** (FrazioneIS 1.0 = gamba
  OOS degenere, 0 giorni): NON rilanciare, non è un errore.
- **Nessuna promozione da questo giro**: l'altopiano/centro-mai-picco e la
  spazzolata vera dell'SL (`InpSlFracRange` qui è di fatto un valore solo)
  sono del **round di griglia successivo**, se il cancello S0 passa.
- L'incrocio giorni-segnale con `MaxMinNotte_DAX_Short` (vincolo di
  scorrelazione, congelato) si misura **dopo, sui CSV** — non lo produce il banco.

## 🌙 CLASSI 31/08 GIÀ DENTRO (dal gemello NySessionRetest, ora obbligatorie)
- L'EA scrive **`open_time`** nel per-trade CSV e ha il **flat di RECUPERO**
  (una posizione di un giorno precedente si chiude al primo tick disponibile,
  con `GiornoChiave_Calc` robusta a cavallo di mese/anno — autotestata).
- **Guardia anti-troncamento**: una passata senza uscite NON riscrive il
  per-trade già scritto con lo stesso magic.
- Il prova ha le **direttive @ NUDE** (il batch del 30/08 le aveva commentate:
  il difetto n.1) e **@FINOA dichiarato** — il wrapper le gatta tutte e 4.
