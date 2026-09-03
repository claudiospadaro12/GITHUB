# 🛠️ COMPILAZIONE DI PROVA DELLA v1.04 DELL'ORB — **PASSO 1: LA RIGA DA MANDARE**

**Che cos'è:** la **prima** delle due mosse firmate da Claudio il **03/09 alle
11:05** — testuale: **"FIRMO IL PERIMETRO PICCOLO"** (verbale
`report/FIRME_2026-09-03.md`):

1. **si vede COMPILARE la v1.04 fuori dal terminale vivo** ← **è questa riga**
2. **solo se 0 errori**, deploy sul **SOLO** conto **piccolo 50503392** con
   `aggiorna_verifica_orb.ps1` (procedura collaudata il 22/08), con lo screenshot.

La v1.04 (`mql5/Experts/ABTG_ORB_Ottimizzato.mq5`, commit `19312c8`) è la **cura
del difetto `SelPos`/HEDGING**: selezione per **SIMBOLO + MAGIC**, scritture per
**TICKET**, log nuovo `ORB SELEZIONE:`, **autotest a tavolino di 10 blocchi / 33
casi**. **Non è mai stata compilata da nessuno.** Se non compila, **quello È il
risultato del passo** — ed è meglio scoprirlo qui che sul terminale che lavora.

> 🚫 **QUESTA RIGA NON FA NESSUN DEPLOY, e non lo dice: lo MISURA.**
> Il `.mq5` e il suo include finiscono in un **albero di lavoro**
> (`%USERPROFILE%\abtg_compila_orb104\MQL5\Experts` + `...\Include`, che è il
> path relativo che il compilatore si aspetta) e `metaeditor64.exe` viene
> chiamato con **`/inc` su quell'albero**. Il referto porta la **foto PRIMA e la
> foto DOPO** (esiste? quanti byte? che data?) dei tre file del terminale
> — `Experts\ABTG_ORB_Ottimizzato.mq5`, `.ex5`, `Include\ABTG_PausaGuardian.mqh`
> — e stampa `INVARIATO` per ognuno. **L'`.ex5` nasce e resta nella cartella di
> lavoro.**

> 🧩 **GLI INCLUDE SI CENSISCONO, NON SI INDOVINANO.** Il 22/08 il primo giro di
> ricompilazione fallì **per un include mancante** (`ABTG_PausaGuardian.mqh`, che
> il conto piccolo non aveva mai avuto —
> `report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md`). Qui la riga **legge il sorgente
> scaricato** ed elenca **tutte** le sue righe `#include`: oggi sono **due**,
> `<Trade/Trade.mqh>` (libreria standard, copiata dal terminale nell'albero di
> lavoro) e `<ABTG_PausaGuardian.mqh>` (**nostro**, scaricato allo stesso pin —
> al pin è la **v1.51**: la compilazione lega la v1.04 **a quell'include**). Se
> domani ne comparisse un terzo, la riga **si ferma prima di compilare e ne dice
> il nome**, invece di regalare un fallimento da interpretare.

> ⚙️ **Invocazione DIRETTA di MetaEditor** (`& $Me "/compile:..." "/inc:..."
> "/log:..."`): il 22/08 `Start-Process` con la stringa di argomenti montata a
> mano tornava **`rc=0` senza compilare niente** (i path di "Program Files" hanno
> gli spazi). E il verdetto **non si appoggia al codice di uscita** (classe 108:
> su PS 5.1 può essere **vuoto**): decidono l'**`.ex5` FRESCO** e la riga
> **`Result: N errors, M warnings`** del log — che viene letto **qualunque sia la
> codifica** (MetaEditor scrive in UTF-16).

| | |
|---|---|
| **Driver** | `righe/RIGA_COMPILA_ORB104.ps1` (marcatore `MARCATORE_RIGA_COMPILA_ORB104_v1`) |
| **Dove** | **PC di backtest**, non VPS |
| **MT5** | **PUÒ restare aperto** (non si scrive niente nelle cartelle del terminale). **MetaEditor NO: va CHIUSO** — con l'editor aperto la compilazione da riga di comando torna subito senza fare nulla |
| **Quanto ci mette** | copia della libreria standard + 2 download + 1 compilazione = **1–3 minuti** [STIMA] |

## 📌 IL PIN — **`@@PIN@@`**  🚧 **SEGNAPOSTO: QUESTA PAGINA NON È ANCORA LANCIABILE**

🚧 **Finché qui sopra c'è `@@PIN@@` la riga NON funziona e NON deve essere
mandata**: il driver rifiuta qualunque `-Pin` che non sia un commit di **40
caratteri esadecimali**, quindi si fermerebbe subito. Il pin vero lo mette il
commit successivo a questo.

## ▶️ IL BLOCCO (uno solo)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process metaeditor64 -EA SilentlyContinue){ throw 'METAEDITOR APERTO: chiudilo e rilancia (MT5 invece puo'' restare aperto).' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COMPILA_ORB104.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COMPILA_ORB104.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COMPILA_ORB104_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=[Environment]::GetFolderPath('Desktop'); if((-not $d) -or (-not (Test-Path $d))){ $d=Join-Path $env:USERPROFILE 'Desktop' };
    $z=@(Get-ChildItem (Join-Path $d 'COMPILA_ORB104_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP COMPILA_ORB104_CORSA_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo -- il referto dice dove si e'' fermato.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 📦 COSA TORNA
Zip sul Desktop **`COMPILA_ORB104_CORSA_...zip`** con **tre file**:
`REFERTO_COMPILA_ORB104.txt` + `COMPILAZIONE.log` (il log vero di MetaEditor,
UTF-16) + `COMPILAZIONE_leggibile.txt` (lo stesso log in ASCII, per non
litigare con la codifica). Il log manca **solo** se MetaEditor non è mai stato
lanciato (giro fermato prima da un gate): in quel caso il referto lo dice.

## 🔎 COME SI LEGGE — le righe del referto, in quest'ordine
1. **`data:`** = **l'ora in cui hai LANCIATO il blocco** (il referto si timbra
   all'**avvio**). La riga te la stampa già in console: **l'ora attuale non è il
   metro.**
2. **`modo:`** = **CORSA**.
3. **`compilazione:`** — ha **TRE STATI** e sono tutti veri:
   - **`OK (… KB, … byte, hh:mm:ss), 0 errors, 0 warning`** → **la v1.04
     compila**: si passa al PASSO 2;
   - **`FALLITA (…)`** → **quello È il risultato del passo**: gli errori veri
     sono nelle **prime 30 righe del log** stampate subito sotto nel referto (e
     il log intero è nello zip). **Il deploy NON si fa**, e i fix tornano in
     `mql5/Experts/`.
   - **`FALLITA -- METAEDITOR MUTO`** → caso a parte: MetaEditor è stato
     lanciato ed è tornato **senza scrivere né log né `.ex5`**. **Non è un
     verdetto sul codice**, è il `rc=0` muto del 22/08 (editor aperto, percorso,
     permessi): si ricontrolla che `metaeditor64` sia chiuso e si rifà.
   - **`NON TENTATA`** → non ci siamo arrivati (un gate ha fermato prima): il
     motivo è nella riga `!!! FERMATO:` in fondo.
4. **`riga Result del log:`** = `Result: 0 errors, 0 warnings, … msec elapsed`
   (è il contratto di MetaEditor, ricopiato **verbatim**).
5. **`codice di uscita di metaeditor64:`** — se dice **`NON LETTO`** non è un
   fallimento (classe 108): fa fede l'`.ex5` e il log.
6. **`versione letta dal #property:`** = **1.04**, e
   **`autotest dichiarato nel sorgente:`** = **10 blocchi / 33 casi**. Sono i
   gate di **identità**: se il file al pin non fosse la v1.04 firmata, la riga
   **non compilerebbe affatto** (un "OK" su un altro file sarebbe una misura
   vera su un oggetto sbagliato). ⚠️ L'autotest **non gira qui**: sta in
   `OnInit` e si leggerà nel Giornale dopo il deploy.
7. **`grep del difetto curato:`** = **0 occorrenze di `PositionSelect(_Symbol)`
   fuori dai commenti**.
8. **`include censiti nel sorgente:`** = **2** (`Trade/Trade.mqh`,
   `ABTG_PausaGuardian.mqh`).
9. **`NESSUN DEPLOY e' avvenuto (misurato…)`** con le **tre righe di foto
   prima/dopo**: devono dire tutte **`INVARIATO`**.
10. **`PROBLEMI:`** e **`RILIEVI:`** in fondo.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)
| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MetaEditor aperto** (il blocco si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso in console; poi chiudi MetaEditor e rilancia |
| **`SCRIPT VECCHIO`** o download della riga fallito | ❌ **NO** | il messaggio in console (se è un 404 sul pin appena creato: aspetta 5 minuti e rilancia **la stessa riga**) |
| **Gate del driver** (pin, versione ≠ 1.04, include nuovo, libreria standard, terminale ambiguo) | ✅ **SÌ** | lo zip: il referto ha `compilazione: NON TENTATA` e la riga `!!! FERMATO:` col motivo |
| **Compilazione FALLITA** (o MUTA) | ✅ **SÌ** | lo zip: **è il risultato del passo** |
| **Compilazione OK** | ✅ **SÌ** | lo zip |
_(la tabella è stata compilata **eseguendo** ogni ramo su un banco stubbato, non
a memoria: punto 94-bis.)_

## 🟡 SE LA RIGA SI FERMA SU **«NON SO QUALE TERMINALE USARE»**
Non è un guasto: è la regola di casa (**classe 115** — l'ambiente non si indovina
dal **nome**, si decide con un **fatto**). La riga stampa **l'elenco delle
installazioni MT5 che ha trovato** con `metaeditor64.exe`; copia il percorso di
quella di **backtest BCM** e rilancia **lo stesso blocco** aggiungendo il
parametro al driver: `& $p -Pin $pin -Terminale "<percorso incollato>"`.

## ➡️ E POI, IL PASSO 2 (**solo se 0 errori**) — due cose da sistemare PRIMA
Il deploy sul **solo piccolo** si fa con `backtest_pipeline/aggiorna_verifica_orb.ps1`,
**sul VPS**, con **MT5 e MetaEditor CHIUSI** (quello sì scrive in
`MQL5\Experts`). Ma quello script è del **22/08** e **oggi non rispetta il
perimetro firmato**:
1. 🔴 **aggiorna ENTRAMBE le istanze** (piccolo **e** 100k `-V3`), mentre la
   firma del 03/09 dice **SOLO il piccolo** (il 100k resta intatto fino a fine
   Fase 1, protezione D1 dei mirror). **Va ristretto prima di lanciarlo.**
2. 🟠 il suo `-VersioneAttesa` ha **default `1.02`**: con la v1.04 si fermerebbe
   da solo. Va lanciato con **`-VersioneAttesa 1.04`**.
_(Tutti e due i punti sono scritti anche nel referto, in coda, quando la
compilazione esce OK.)_

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. La riga **copia la libreria standard** (`MQL5\Include` del terminale) nella
   cartella di lavoro: sono qualche migliaio di file, ci mette qualche secondo,
   e il conteggio finisce nel referto (`libreria standard: copiata da …`).
2. Ogni 10 secondi di attesa la riga stampa **`... aspetto l'.ex5 da Ns`**:
   serve a non far sembrare un blocco una compilazione lenta. **Non
   interrompere**: si ferma da sola col suo tetto.
3. Se il referto porta un **RILIEVO sul `TENTATIVO B`**, vuol dire che la prima
   strada non ha risolto l'include e la riga ha usato la cartella dati del
   terminale, **copiandoci dentro il solo `.mqh` e rimettendo tutto com'era**
   (con backup). La foto DOPO lo dimostra, e il ripristino è scritto nel referto.
