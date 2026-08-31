# 📬 NY SESSION RETEST — **LA RIGA DA MANDARE** (PASSO 0 + misura a tick)

**Che cos'è:** primo giro in assoluto di **`ABTG_NySessionRetest`** (VWAP-retest in
trend, **primo intraday-VWAP della flotta**, mai compilato né testato):
**PASSO 0 + MISURA a TICK REALI (Modello 4)** su **U30USD BCM M15** (trend su H1),
**2024.09.26 → 2026.06.30**, **cella FISSA col gate regime OFF** (slope 0 / exp 0 =
ablazione dichiarata). Unico asse Y = **gemelli magic 769501/769502**.
**È una MISURA, non un verdetto.**

> 🎯 **La domanda:** quanti retest-VWAP fa DAVVERO il motore sul Dow in M15 (frequenza), quanto
> è grosso il take mediano in **punti indice** (per-trade CSV) e paga lo **spread
> reale U30USD** (implicito nei tick, il blocco M24)? Da qui escono le **2 tarature
> del gate** (vs OFF) del round successivo — le soglie **non si inventano prima di
> aver visto la scala**. 21 mesi = un solo regime: **merito sospeso se n<150 (R59),
> rischio SEMPRE**. Zero overnight o il file è **invalido**.

> 🕒 **FUSO DI CASA (non invertito):** U30USD BCM = ora **SERVER** (IT−1) → seduta
> RTH **14:30** server (`InpSessionHour=14/InpSessionMin=30`), flat **20:55** server
> (`InpCloseHour=20/InpCloseMin=55`, poco prima del close RTH 21:00). Il gate
> **rifiuta il 9 e il 16** (ore ET/NY dei feed _EXT) — copia del gate fuso di casa.
> 🟢 U30USD è **nativo BCM** (niente import storico).
> ⚠️ La riga **compila l'EA** (cancellando l'.ex5 vecchio): se la compilazione
> fallisce, **quello È il risultato del passo** — manda lo zip lo stesso.

| | |
|---|---|
| **Driver** | `righe/RIGA_NYRETEST.ps1` (marcatore `MARCATORE_RIGA_NYRETEST_v5`) |
| **File prova** | `prove/ABTG_NySessionRetest.txt` (cella fissa gate-OFF, gemelli, fuso server) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.** ⏱️ ~15-40 min (tick M15, 21
mesi, 2 passate). La gamba OOS del generico è **degenere** (FrazioneIS 1.0): il
rosso sul CSV `*_OOS` è **atteso**, NON rilanciare.

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NYRETEST.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NYRETEST.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NYRETEST_v5' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NYRETEST.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NYRETEST.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NYRETEST_v5' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `NYRETEST_...zip` → `REFERTO_NYRETEST.txt` + il prova + **i due
per-trade CSV** `abtg_trades_ABTG_NySessionRetest_U30USD_769501/769502.csv`
(frequenza, take in punti indice, orari per il controllo overnight, lati separati)
+ la griglia gemelli (IS, tick — 2 righe identiche, con Autotest Falliti, Flat
Giorni/Chiusure e la diagnostica dei cancelli in colonna). **Mandami lo zip** e da
lì escono le 2 tarature del gate per il round vero.

🕐 **PRIMA DI LEGGERE:** apri `REFERTO_NYRETEST.txt` e controlla la riga
`data:` — deve essere **l'ora di adesso**. Se è di un giro precedente stai
leggendo un referto stantio. E la riga `modo:` deve dire **CORSA**, non
CONTROLLO (il giro a vuoto non è il risultato).

📊 Nel referto la riga `per-trade CSV:` stampa **le operazioni per magic**
(`OPERAZIONI per magic -> 769501=N | 769502=N`): è già la frequenza del
PASSO 0, e i due numeri devono essere **UGUALI** (gemelli deterministici —
se divergono la riga alza PROBLEMA da sola).

## 🔁 PERCHÉ QUESTO ROUND È SU M15 E NON H1 (misurato, corsa H1 del 31/08 09:51)
Su H1 il motore è **strutturalmente muto**: seduta = 6 barre, la prima esclusa,
la pendenza VWAP chiede 5 barre di seduta → l'unica barra utile chiude alle
21:00, oltre il flat 20:55. **0 trade su 459 giorni, contatori esatti
(9256 = 7083+2171+2)**. Su M15 la seduta ha ~25 barre. Il trend resta su H1
(handle dedicato nell'EA, come il `request.security` del Pine sorgente).

## 🌙 NOVITÀ v5 (dal quarto giro del verificatore)
- L'EA scrive **`open_time`** nel per-trade CSV e ha il **flat di RECUPERO**
  (una posizione di un giorno precedente si chiude al primo tick disponibile).
- Il vincolo è stato **riscritto nel prova PRIMA dei numeri**: si esige che
  nessuna posizione sopravviva al primo tick dopo il flat; le chiusure a
  giorno successivo (giorni SENZA tick fra flat e mezzanotte) si **contano**:
  **> 5% delle posizioni = file INVALIDO**, sotto = rilievo dichiarato.
- La riga **svuota `Tester\cache`** (il prova è identico alla corsa v3: i
  pass sarebbero ripescati e il CSV tornerebbe vuoto) e **misura da sola**
  gli overnight veri: nel referto leggi le righe `cache tester:`,
  `overnight veri:`, oltre a `data:` e `modo:`.
