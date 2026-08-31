# 📬 NY RETEST — **TARATURA, ESTENSIONE FINALE: LA RIGA DA MANDARE** (mappa del bordo)

**Che cos'è:** l'**ULTIMO GIRO** della taratura del gate. La griglia 48 (corsa
del 31/08, pin 606111d) ha misurato che **il gate SLOPE MORDE** (n 625→211, DD
12.9→5.8%, banda slope=45 coerente PF ~1.17 su sl 5/7) ma la **barra congelata
(PF ≥ 1.3 & DD < 8% ad altopiano) NON è raggiunta** (0 celle su 48) — e il PF
**sale ENTRANDO nel bordo** (0.99@30 → 1.17@45, con 45 tetto dichiarato). La
mappa è incompleta verso l'alto: questa estensione era **GIÀ DICHIARATA nel
referto (commit 8ca26de) PRIMA dei suoi numeri** e qui la si esegue identica:
**`InpVwapSlopeMin` 45/60/75/90 × `InpSlLookback` 5/7 = 8 celle** a **TICK
REALI (Modello 4)**, magic **FISSO 769503**.

> 🔇 **Asse spento PER MISURA, non per assunzione:** `InpExpansionMin=0.00`
> FISSO — la griglia 48 lo ha misurato **decorativo** (n 625→621→604, PF
> piatto). E **sl 3 è SCARTATO** con motivo misurato: a slope 45 faceva PF
> 0.975, mentre sl 5/7 tenevano — si porta avanti solo ciò che ha retto.

> 🎯 **Criteri GIÀ CONGELATI nel prova** (`prove/ABTG_NySessionRetest_Tar2.txt`):
> (a) **BARRA INVARIATA**: PF ≥ 1.3 su tick e DD < 8% in un **ALTOPIANO**
> (centro, mai il picco, niente cella outlier) — la barra non si abbassa a
> metà round; (b) **MURO R59**: cella con **n < 150 = merito SOSPESO**, non
> promuovibile a prescindere dal PF — se TUTTE le celle sopra slope 45 stanno
> sotto, la taratura si **CHIUDE** con mappa completa e verdetto **"gate reale
> ma edge sotto barra"**; (c) **SENTINELLE di continuità**: le celle slope=45
> devono riprodurre la griglia 48 (**sl5: n=211 PF=1.174 / sl7: n=212
> PF=1.166**, tolleranza >2% su n o >0.05 su PF = PROBLEMA); (d) confronto
> **solo per-trade/risk-adjusted, MAI profitto totale**; (e) **ULTIMO GIRO:
> comunque vada, dopo c'è solo il verdetto** — niente terza estensione
> (scritto per iscritto contro la caccia al rumore).

> 🕒 **FUSO DI CASA (non invertito):** U30USD BCM = ora **SERVER** (IT−1) →
> seduta **14:30**, flat **20:55**. Il gate **rifiuta il 9 e il 16** (ore ET/NY).
> 🗑️ **NIENTE per-trade CSV:** magic fisso, 8 passate scrivono lo stesso file
> → spazzatura dichiarata, la riga non lo raccoglie e non va letto.
> 🧹 La riga **svuota `Tester\cache` coi conteggi** — di nuovo **load-bearing**:
> le celle slope=45 sono **identiche** a passate della griglia 48 appena girata,
> senza svuotare verrebbero **ripescate** dalla cache (pass muto, sentinelle
> mute nel CSV).

| | |
|---|---|
| **Driver** | `righe/RIGA_NYRETEST_TAR2.ps1` (marcatore `MARCATORE_RIGA_NYRETEST_TAR2_v1`) |
| **File prova** | `prove/ABTG_NySessionRetest_Tar2.txt` (8 celle, exp spento, magic fisso 769503, fuso server) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **8 passate a tick su 21 mesi**: un sesto della griglia 48, quindi la stima
onesta è **~10-40 minuti** con gli agent locali (la griglia 48 ha impiegato
~1-4 ore per 48 celle). Il giro a vuoto (riga 1) resta questione di minuti.
La gamba OOS del generico è **degenere** (FrazioneIS 1.0): il rosso sul CSV
`*_OOS` è **atteso**, NON rilanciare.

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NYRETEST_TAR2.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NYRETEST_TAR2.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NYRETEST_TAR2_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NYRETEST_TAR2.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NYRETEST_TAR2.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NYRETEST_TAR2_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop `NYRETEST_TAR2_...zip` → `REFERTO_NYRETEST_TAR2.txt` + il prova
+ **la griglia** `ABTG_NySessionRetest_U30USD_IS.csv` (**8 righe**, una per
cella, con PF, Trades, Equity DD %, Autotest Falliti e le colonne dei due
assi). **Niente per-trade CSV** (dichiarato spazzatura in griglia). **Mandami
lo zip.**

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_NYRETEST_TAR2.txt` e controlla:
- riga **`data:`** = l'ora di adesso (referto stantio = giro vecchio);
- riga **`modo:`** = **CORSA** (il giro a vuoto non è il risultato);
- riga **`cache tester:`** = svuotata coi due conteggi (load-bearing qui:
  le celle slope=45 combaciano con la griglia 48 appena girata);
- riga **`griglia CSV:`** = **8 righe su 8** (la riga CONTA le celle da sola);
- riga **`sentinelle slope=45:`** = n e PF **uguali alla griglia 48**
  (sl5: n=211 PF≈1.174; sl7: n=212 PF≈1.166) — se divergono oltre la
  tolleranza (>2% n, >0.05 PF), la riga alza PROBLEMA da sola.

📊 Poi la **MAPPA DEL BORDO** stampata nel referto: n, PF e DD per ogni soglia
di slope (45/60/75/90), ai due SlLookback. Le due domande della mappa:
**dove il PF tocca il massimo** (dentro la finestra o sul bordo di nuovo?) e
**dove n scende sotto 150** (il muro R59 è marcato riga per riga: da lì in su
il merito è SOSPESO a prescindere dal PF). La fascia candidata resta quella
congelata — **PF ≥ 1.3 e DD < 8% ad ALTOPIANO, centro mai il picco** — e il
confronto è **solo per-trade/risk-adjusted (MAI profitto totale)**. Se tutte
le celle sopra 45 stanno sotto il muro: mappa completa, verdetto **"gate reale
ma edge sotto barra"**, e la taratura si chiude lì.

🛑 **Comunque vada: questo è l'ULTIMO GIRO.** Dopo lo zip c'è solo il verdetto
definitivo della taratura — niente terza estensione, niente raffinamenti.

## 🔴 AVVISO ROSSO ATTESO
Il generico stamperà rosso sul CSV **`*_OOS`**: con FrazioneIS 1.0 la gamba OOS
è **degenere (0 giorni)** per costruzione. È **atteso**: NON rilanciare, non è
un errore. Fa fede l'`ESITO:` finale della riga (verde CORSA COMPLETATO oppure
giallo/rosso coi PROBLEMI elencati nel referto).
