# 📬 NY RETEST — **TARATURA DEL GATE, LA RIGA DA MANDARE** (griglia a tick)

**Che cos'è:** il round che segue il **PASSO 0 VALIDO** (corsa v5 del 31/08: retest
nudo su U30USD M15 tick 2024.09.26→2026.06.30 = **PF 1.002, n=625, DD 12.9%**,
take mediano WIN **+87.6 punti indice** / LOSS **−58.0**). Qui si misura **SE IL
GATE COSTITUTIVO slope+espansione MORDE**: griglia
**`InpVwapSlopeMin` 0/15/30/45 × `InpExpansionMin` 0/60/120/180 ×
`InpSlLookback` 3/5/7 = 48 celle** a **TICK REALI (Modello 4)**, magic **FISSO
769503** (vergine). La cella **OFF (slope 0 / exp 0 / sl 5) è DENTRO la
griglia**: è la baseline interna e deve **riprodurre il passo 0** (determinismo).

> 📏 **L'unità delle soglie è MISURATA nel sorgente, non assunta** (lezione
> ATR=100 del CRT): entrambe in **PUNTI INDICE** (`InpMT5PerPuntoIndice=100`).
> Slope = spostamento TOTALE della VWAP ancorata su **5 barre M15** (75 min);
> espansione = range highest−lowest su **10 barre M15** (2,5 ore). Le griglie
> sono ancorate al take mediano misurato (45 ≈ metà take; 60 ≈ loss mediana,
> 180 ≈ 2× take). SlLookback: il prova del passo 0 diceva 3/5/8 → la griglia
> MT5 è aritmetica, quindi **3/5/7 (scarto dichiarato)**.

> 🎯 **Criteri GIÀ CONGELATI nel prova** (`prove/ABTG_NySessionRetest_Tar.txt`):
> (a) il gate **MORDE** se n cala e PF si muove in modo **ORDINATO** al crescere
> delle soglie; (b) fascia candidata **PF ≥ 1.3 su tick e DD < 8% in un
> ALTOPIANO** (centro, mai il picco, niente cella outlier); (c) il confronto col
> nudo si fa su metriche **per-trade/risk-adjusted** (PF, profit/DD, peggior
> giornata) — **MAI sul profitto totale** (lezione anti-filtro del 31/08);
> (d) **OFF==ON ovunque → gate decorativo → scarto**.

> 🕒 **FUSO DI CASA (non invertito):** U30USD BCM = ora **SERVER** (IT−1) →
> seduta **14:30**, flat **20:55**. Il gate **rifiuta il 9 e il 16** (ore ET/NY).
> 🗑️ **NIENTE per-trade CSV qui:** il magic è fisso, 48 passate scrivono lo
> stesso file e sopravvive l'ultima → **spazzatura dichiarata**, la riga non lo
> raccoglie e non va letto. Niente gemelli: il determinismo lo fa la cella OFF.
> 🧹 La riga **svuota `Tester\cache` coi conteggi** — di nuovo **load-bearing**:
> la cella OFF coincide con la corsa v5 appena girata, senza svuotare verrebbe
> **ripescata** dalla cache (pass muto, griglia monca).

| | |
|---|---|
| **Driver** | `righe/RIGA_NYRETEST_TAR.ps1` (marcatore `MARCATORE_RIGA_NYRETEST_TAR_v1`) |
| **File prova** | `prove/ABTG_NySessionRetest_Tar.txt` (griglia 48 celle, magic fisso 769503, fuso server) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **48 passate a tick su 21 mesi**: il passo 0 ha fatto 2 passate in ~15-40
min totali, quindi qui la stima onesta è **~1-4 ore con gli agent locali in
parallelo, fino a 6-10 ore a singolo agent**. Lancialo quando il PC può restare
acceso (sera va benissimo); il giro a vuoto (riga 1) resta questione di minuti.
La gamba OOS del generico è **degenere** (FrazioneIS 1.0): il rosso sul CSV
`*_OOS` è **atteso**, NON rilanciare.

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NYRETEST_TAR.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NYRETEST_TAR.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NYRETEST_TAR_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NYRETEST_TAR.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NYRETEST_TAR.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NYRETEST_TAR_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `NYRETEST_TAR_...zip` → `REFERTO_NYRETEST_TAR.txt` + il prova +
**la griglia** `ABTG_NySessionRetest_U30USD_IS.csv` (**48 righe**, una per
cella, con PF, Trades, Equity DD %, Autotest Falliti, la diagnostica dei
cancelli — `Regime Ko` qui DEVE muoversi con le soglie — e le colonne dei tre
assi). **Niente per-trade CSV** (dichiarato spazzatura in griglia). **Mandami
lo zip.**

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_NYRETEST_TAR.txt` e controlla:
- riga **`data:`** = l'ora di adesso (referto stantio = giro vecchio);
- riga **`modo:`** = **CORSA** (il giro a vuoto non è il risultato);
- riga **`cache tester:`** = svuotata coi due conteggi (load-bearing qui);
- riga **`griglia CSV:`** = **48 righe su 48** (la riga CONTA le celle da sola);
- riga **`baseline OFF:`** = n e PF della cella OFF **uguali al passo 0**
  (n=625, PF≈1.002) — se diverge, la riga alza PROBLEMA da sola.

📊 Poi la **MAPPA DEL MORSO** stampata nel referto (scansioni marginali a
sl=5): **n e PF per ogni soglia di slope (a exp 0) e di espansione (a slope
0)**. Il gate **morde** se n CALA e il PF si muove in modo ordinato salendo di
soglia; **OFF==ON ovunque = gate decorativo = scarto** (criterio d). La fascia
candidata (PF ≥ 1.3, DD < 8%) si cerca **sull'altopiano** nel CSV completo —
centro, mai il picco — e il confronto col nudo è **solo per-trade/risk-adjusted
(MAI profitto totale)**.

## 🔴 AVVISO ROSSO ATTESO
Il generico stamperà rosso sul CSV **`*_OOS`**: con FrazioneIS 1.0 la gamba OOS
è **degenere (0 giorni)** per costruzione. È **atteso**: NON rilanciare, non è
un errore. Fa fede l'`ESITO:` finale della riga (verde CORSA COMPLETATO oppure
giallo/rosso coi PROBLEMI elencati nel referto).
