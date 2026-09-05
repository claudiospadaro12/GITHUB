# 🧼 R116-BIS — LONDONFX: **LA GAMBA GBPUSD RIFATTA SU BANCO PULITO** (un agente solo)

**Che cos'è, in una riga:** il 03/09 la gamba **GBPUSD** di R116 è uscita con
**`PROBLEMI: 2 — GEMELLI DIVERGONO sul motore 3`** su IS *e* su OOS. Per la
sanità **5.0.1** dei criteri firmati quel banco è **SPORCO**, e **quei numeri non
si leggono**. Il **04/09** la causa è stata **CONFERMATA** (non sospettata):
**classe 129** della checklist — **più agenti locali MT5 vivi insieme fanno
divergere davvero** le celle che dovrebbero uscire identiche. Questo giro
**rifà la stessa identica misura con UN SOLO agente**.

> ### 🚫 NON è una seconda griglia su un motore morto (regola della seconda caccia, 19/08)
> Qui **non si tocca un solo parametro del motore**, non si cambia una soglia,
> non si sposta un cancello. Cambia **il banco**, che è il presupposto perché
> la misura esista. **La domanda del round resta quella firmata il 03/09**;
> quello che manca è **una misura leggibile su GBPUSD**.

---

## 📋 COSA C'È GIÀ, E COSA MANCA — perché non si rifà tutto

| pezzo | stato al 05/09 | serve rifarlo? |
|---|---|---|
| **Compilazione di `ABTG_LondonFx.mq5`** | ✅ **FATTA il 03/09**: `Result: 0 errors, 0 warnings, 1212 ms` (referto EURUSD, riga `compilazione:`) | ricompila comunque **allo stesso pin**, ma non è più il passo rischioso |
| **Gamba EURUSD** | ✅ **PROBLEMI 0**, gemelli **IDENTICI al centesimo su 3 coppie** → il gate di identità (la prova di casa che il banco era pulito) **è passato**. Verdetto: **tutti e tre i motori BOCCIATI PER RISCHIO** (motore 2: `E` OOS −0,1078R, PF 0,843, DD 37,14%) | ❌ **no, non per obbligo.** Blocco 3️⃣ facoltativo, come **conferma** |
| **Gamba GBPUSD** | ⚫ **BANCO SPORCO**: gemelli divergenti sul motore 3, IS e OOS | ✅ **SÌ — è il motivo di questa pagina** |
| **Spread misurato (F9 → chiude H12)** | ✅ già archiviato per entrambe le gambe | esce di nuovo, si confronta |
| **Fase 2 slippage (F10)** | `NON DOVUTA` su entrambe le gambe (nessun motore passa i cancelli A) | solo **se** stavolta il motore 2 passasse — lo decide il driver |

---

## 🛑 IL PASSO **MANUALE** CHE NESSUNO SCRIPT PUÒ FARE AL POSTO TUO

> ### ⚙️ PRIMA di lanciare: **UN SOLO AGENTE LOCALE**
> 1. Apri MT5 → pannello **Strategy Tester** → scheda **Agenti**
>    *(è un sotto-pannello del Tester: **non** Strumenti → Opzioni)*.
> 2. Lascia acceso **solo `Core 1`**. Spegni `Core 2`, `Core 3`, `Core 4`
>    (e tutti gli altri, se ce ne sono).
> 3. **Chiudi MT5** (le righe si lanciano con il terminale chiuso).
> 4. A fine giro, se vuoi, **riaccendi gli agenti**: servono sulle righe
>    normali, dove la velocità conta e l'identità bit-per-bit **non** è richiesta.
>
> **Perché è manuale:** la classe 129 lo dice esplicitamente — gli agenti si
> spengono **dentro** MT5, e nessuno script può farlo da fuori.
> **Cosa fa lo script al posto suo:** li **CONTA**. Un job in parallelo campiona
> ogni **400 ms** i processi `metatester64` vivi e tiene il **massimo
> contemporaneo**; il referto scrive la riga **`agenti locali durante la
> corsa`**, e se il massimo è **> 1** finisce nei **PROBLEMI** e **il round è
> fermo** — *qualunque numero sia uscito*.
> ⚠️ È un **misuratore, non un interruttore**: non può impedire la corsa
> sbagliata, può solo impedire che venga letta come buona.

---

## 🧊 COSA RESTA CONGELATO (identico al 03/09, firma per firma)

| voce | valore — **non si tocca** |
|---|---|
| criteri | `risultati_archivio/LONDONFX_TICK_CRITERI.md` + firma in `report/FIRME_2026-09-03.md` (*"FIRMO TUTTO, ANCHE LA A SU F5"*) |
| EA | `mql5/Experts/ABTG_LondonFx.mq5` **v1.01**, byte per byte lo stesso che ha girato il 03/09 |
| prova | `prove/LONDONFX_R116_TICK.txt` + `prove/LONDONFX_R116_FASE2_SLIPPAGE.txt`, **invariati** |
| finestra | **2024.07.05 → 2026.06.30**, split 40/60 → IS `2024.07.05 → 2025.04.21`, OOS `2025.04.22 → 2026.06.30`. **UN SOLO REGIME** |
| banco | **Modello 4 = tick REALI**, M15, `Spread=0` (corrente, dichiarato), deposito **100.000** |
| ora / rischio / geometria | **8 ora server** (Londra 08:00–16:00, fine esclusa) · **0,65%** · **TP 15,0 / SL 8,0 pip** su entrambe le gambe |
| F5 | soglia RSI short **20, simmetrica** (più permissiva del 10 dell'autore: se lo short passa e il long no, **va scritto**) |
| magic | **774001 / 774002** (i gemelli) |
| cancelli | A1 `E` OOS ≥ **0,075R** · A2 PF ≥ **1,15** · A3 segno IS/OOS + PF IS > 1 · A4 DD ≤ **8,0%** · A5 PG ≥ **−4,0%** · A6 n ≥ **150** |
| F11 | **niente selezione**: promuovibile **solo il motore 2**, gamba per gamba. Vietato nominare "la cella migliore" |
| F12 | **da qui NON esce una sedia**, nemmeno se passasse tutto |

**L'unica cosa che cambia oltre al banco:** l'**etichetta** dei CSV diventa
`R116B_<PFX>` (invece di `R116_<PFX>`). È voluto: i CSV del giro sporco restano
dove sono e **non possono essere riletti per sbaglio** al posto di questi, né
viceversa.

---

| | |
|---|---|
| **Driver** | `righe/RIGA_R116BIS_LONDONFX.ps1` (marcatore `MARCATORE_RIGA_R116BIS_LONDONFX_v1`, `-Pin` obbligatorio, `-Simbolo`) |
| **File prova** | `prove/LONDONFX_R116_TICK.txt` + `prove/LONDONFX_R116_FASE2_SLIPPAGE.txt` (**gli stessi del 03/09**) |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI**, e **un solo agente** (sopra) |
| **Quanto ci mette** | il 03/09, **con più agenti**: EURUSD ~**70 secondi** (avvio 17:51:17 → CSV OOS 17:52:26), GBPUSD ~**2,5 minuti**. [INFERITO] a un agente solo sale più o meno quanti agenti si spengono: **minuti, non ore**. Il numero vero lo dice questo giro |

## 📌 IL PIN — **`@@PIN@@`**

Commit di `lavoro`. I sei file che il driver scarica **al pin** (mai dalla punta
del branch): il driver **nuovo**, i **due prova** (invariati), il **generico**,
l'**EA v1.01** e l'**include** — questi ultimi quattro sono **gli stessi blob**
che hanno girato il 03/09 (verificato con `git ls-tree`: hash identici).

---

# 🔴 GAMBA DA RIFARE — GBPUSD

## 1️⃣ GBPUSD — giro a vuoto (scarica, gatta, **COMPILA**, generico `-SoloControllo`: MT5 non gira)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116BIS_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116BIS_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116BIS_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116BIS_LONDONFX_CONTROLLO_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116BIS_LONDONFX_CONTROLLO_GBPUSD_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip: compilazione: OK errori 0, celle 6 + 2, simbolo GBPUSD OVERRIDE DICHIARATO): hai gia'' spento gli agenti tranne Core 1? Allora lancia il blocco 2.' -ForegroundColor Green } }
```

## 2️⃣ GBPUSD — **la corsa vera su banco pulito** (12 passate a tick reali)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116BIS_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116BIS_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116BIS_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116BIS_LONDONFX_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116BIS_LONDONFX_GBPUSD_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice dove si e'' fermata.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'GUARDA SUBITO DUE RIGHE DEL REFERTO: "agenti locali durante la corsa" (deve dire 1) e "gemelli" (deve dire IDENTICI al centesimo su 3 coppie). Se la prima dice piu'' di 1, la seconda non vuol dire niente.' -ForegroundColor Yellow;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_R116BIS_LONDONFX_GBPUSD.txt: riga modo: = CORSA, riga simbolo di questa corsa: = GBPUSD OVERRIDE DICHIARATO, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO.') -ForegroundColor Gray }
```

---

# 🟡 3️⃣ (FACOLTATIVO) EURUSD — **la conferma**, non un obbligo

**Quando ha senso:** solo **dopo** il blocco 2, e solo se i numeri GBPUSD su
banco pulito **si spostano** rispetto al 03/09. In quel caso vale la pena
rimisurare anche l'EURUSD **allo stesso banco**, perché sapremmo che il numero
di agenti sposta i risultati **anche quando il gate dei gemelli passa**.

**Quando NON serve:** se GBPUSD torna com'era. L'EURUSD del 03/09 aveva
**PROBLEMI 0** e **gemelli identici su 3 coppie**: il gate è passato, e per la
regola di casa **quella è la prova che il banco era pulito**. Rifarlo per
scrupolo va bene, **ma va dichiarato come conferma**, non come "il vero numero".

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116BIS_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116BIS_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116BIS_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo EURUSD; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116BIS_LONDONFX_EURUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116BIS_LONDONFX_EURUSD_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'E'' UNA CONFERMA, NON IL NUMERO NUOVO: l''EURUSD del 03/09 aveva gia'' i gemelli identici.' -ForegroundColor Gray }
```

---

# 🪓 4️⃣ (solo se dovuta) LA FASE 2 DA SOLA — `-SoloFase2`

**Quando:** la corsa vera è finita, il referto dice che il **motore 2 passa
tutti i cancelli A**, ma la fase 2 accodata è morta a metà. Sostituire `GBPUSD`
con `EURUSD` per l'altra gamba. ⚠️ **Non può promuovere niente**: è una
sensibilità allo slippage (0 / 2 / 5 punti), e **il verdetto si legge a 5 punti**.
🔎 **Previsione, dichiarata prima:** il 03/09 la fase 2 è uscita `NON DOVUTA` su
entrambe le gambe, perché **nessun motore passava**. Se il banco pulito non
ribalta il segno di `E`, **questo blocco non servirà.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116BIS_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116BIS_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116BIS_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD -SoloFase2; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116BIS_LONDONFX_FASE2_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116BIS_LONDONFX_FASE2_GBPUSD_ DI ADESSO SUL DESKTOP: la fase 2 non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'FASE 2 CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

---

## 📦 COSA TORNA

Zip sul Desktop **`R116BIS_LONDONFX_GBPUSD_...zip`** con:
`REFERTO_R116BIS_LONDONFX_GBPUSD.txt` + `COMPILAZIONE.log` (UTF-16, il log vero
di MetaEditor) + `COMPILAZIONE_leggibile.txt` + i **2 prova** + i **CSV OPTFRAME**
`ABTG_LondonFx_GBPUSD_IS_R116B_GBP.csv` e `_OOS_` (**6 righe l'uno** = 3 motori ×
2 magic) + gli **`.ini VERI`** (`gen_*.ini`, con `Model=4`) + i **log del tester
cresciuti** + i **per-trade** `pertrade_*_m<motore>_<magic>.csv` (fino a 6,
rappresentano **solo l'OOS**).
⚠️ **Nessun suffisso `_ohlc`** nei nomi: è la marca del generico per i modelli
non-tick, e qui il modello è **4**. Se un CSV lo porta, **non è di questo giro**.

## 🔎 COME SI LEGGE — **la riga nuova per prima**

🥇 **PRIMA DI TUTTO, la riga che questo giro esiste per produrre:**
- **`agenti locali durante la corsa (classe 129, il motivo di questo bis):`**
  - **`1 (massimo contemporaneo…)`** → 🟢 **banco a un agente**: da qui in poi
    l'identità dei gemelli **vuol dire qualcosa**;
  - **`N processi metatester64 VIVI INSIEME`** con N > 1 → ⚫ **PROBLEMI**, round
    **fermo**: gli agenti non erano spenti. Si spengono e **si rilancia**;
  - **`0 processi…`** in una corsa vera → 🟠 **misura mancata** (cache del tester
    o campionamento troppo rado): **non è** la prova che il banco fosse pulito;
  - **`NON MISURATO`** → il monitor non è partito: sta nei **RILIEVI**, e i
    gemelli si leggono **con riserva**.

🧪 **POI LA SANITÀ (§5.0) — se cade una, il round non si legge:**
`righe 6 (attese 6)` in IS **e** OOS · **`gemelli: IDENTICI al centesimo su 3
coppie`** ← **è questo il numero che il 03/09 mancava** · `Autotest Falliti 0`,
`18 / 118` · `Canarino Torna = 1` · `Notti Attraversate = 0` · nessun
`eco … invece di …` nei PROBLEMI · `Model letto: … Model=4` dall'**.ini VERO** ·
riga del Diario **`ticks data begins from`** ricopiata · `log del tester letti: N`.

🐤 **POI IL CANARINO, PRIMA DEL CONTO ECONOMICO**, e **POI i cancelli A**, con le
fasce disgiunte già congelate:

| cancello | 🟢 PASSA | 🟠 NON PASSA (zona morta) | ⚫ BOCCIATA |
|---|---|---|---|
| **A1** `E In R` OOS | ≥ 0,075 | 0,050 ≤ E < 0,075 | < 0,050 |
| **A2** `PF` OOS | ≥ 1,15 | 1,10 ≤ PF < 1,15 | < 1,10 |
| **A3** segno IS/OOS coerente **e** PF IS > 1,00 | sì | — | IS negativo |
| **A4** `Equity DD %` OOS | ≤ 8,0 | 8,0 < DD ≤ 10,0 | > 10,0 **per RISCHIO, a qualunque n** |
| **A5** `Peggior Giornata %` OOS | ≥ −4,0 | −5,0 ≤ PG < −4,0 | < −5,0 **per RISCHIO, a qualunque n** |
| **A6** `n` IS e OOS | ≥ 150 | 30–149 **merito sospeso** | < 30 = **non misurabile** |

## ⚖️ IL CONFRONTO COL 03/09 — le tre letture, **decise prima dei numeri**

I numeri del giro sporco, per il confronto (motore 2, GBPUSD, OOS):
**`E` = −0,1726R · PF = 0,763 · DD = 55,03% · n = 719 · IS profit −52.478,32
(PF 0,688)**. Il motore 1 dava `E` −0,0870R, il motore 3 `E` −0,0956R.

| esito del bis | cosa vuol dire | cosa si fa |
|---|---|---|
| 🟢 **gemelli identici e numeri ~uguali al 03/09** | il banco sporco **non aveva spostato il verdetto**: la bocciatura GBPUSD diventa **leggibile e piena** | **R116 si chiude pulito su tutte e due le gambe**; si aggiorna `REGISTRO_TEST.md` togliendo l'asterisco procedurale |
| 🟠 **gemelli identici ma numeri DIVERSI** | il numero di agenti **sposta i risultati**: il referto del 03/09 su GBPUSD **è carta straccia** e va marcato tale | vale **solo** il numero del bis; **e diventa obbligatorio** rilanciare anche l'EURUSD (blocco 3️⃣), perché non sapremmo più fidarci di quel giro |
| ⚫ **gemelli DIVERGONO ANCORA con 1 agente solo** | 🔴 **la classe 129 non spiega tutto**: c'è un secondo meccanismo, e stavolta il sospettato è **l'EA o il tester**, non il parallelismo | round **fermo**, e si apre un'indagine sul motore 3 (`ALLINEA_5MEDIE`) — è **sempre e solo lui** a divergere |

> 🔴 **E resta vero comunque, qualunque numero esca (F12 firmata):** **da questo
> round NON esce una sedia.** Un solo regime, nessuna prova di regime, nessuna
> prova di rischio sul vecchio. Il massimo ottenibile è **una misura leggibile**.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (il blocco si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o `irm` fallito (404 su un pin appena creato: cache raw ~5 min) | ❌ **NO** | il messaggio; aspetta 5 minuti e rilancia **la stessa riga** |
| **Guardie del driver** (`-Pin` mancante/corto, `-Simbolo` fuori whitelist, MT5 riaperto nel frattempo) | ✅ **SÌ** (`!!! FERMATO:` nel referto, tutto `NON TENTATA`) | lo zip |
| **Scarico al pin fallito** (404 su uno dei sei file) | ✅ **SÌ** | lo zip; se è la cache raw, rilancia dopo 5 min |
| **Gate sul sorgente** (versione ≠ 1.01, define ≠ 18/118, magic, hedge, include) o **sui prova** | ✅ **SÌ** | lo zip: il motivo è in `!!! FERMATO:` — non si aggiusta a mano |
| **Terminale non unico** (`NON SO QUALE TERMINALE USARE`) | ✅ **SÌ** | rilancia lo stesso blocco con `-Terminale '<cartella dell'installazione>'` |
| **Compilazione FALLITA** | ✅ **SÌ** | lo zip. ⚠️ Stavolta **non è un esito atteso**: il 03/09 compilava a 0 errori |
| **Agenti > 1** (classe 129) | ✅ **SÌ** (esito `COMPLETATO CON PROBLEMI`, exit 1) | lo zip: spegni gli agenti e **rilancia** |
| **Corsa OK** | ✅ **SÌ** | lo zip |

_(Le righe di questa tabella che dipendono dallo script sono state **eseguite**,
non ricordate: su banco `pwsh`, il ramo "guardia `-Pin` mancante" arriva allo zip
col referto completo e con la riga nuova `agenti locali…` già scritta. I rami dal
terminale in poi — compilazione, corsa, fase 2 — **non sono eseguibili senza MT5**
e restano nel **NON COPERTO**, come nella riga madre.)_

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. **Giallo del generico** _"Questo EA usa PERIOD_CURRENT e non ha un input InpTF…
   adesso e' M15"_ — **corretto e voluto**.
2. **Giallo** `Spread=0 -> spread CORRENTE, dichiarato` — voluto, agli atti.
3. **Giallo** sulla riga `simbolo .....` (override GBPUSD attivo) — voluto: i
   prova restano dichiarati sul lead EURUSD e **il gate lo pretende**.
4. `include … installato AL PIN in MQL5\Include (backup …)` e poi `ripristino
   del terminale: … RIPRISTINATO/RIMOSSO` — è la **classe 116** al lavoro.
5. Ogni 10 s durante la compilazione: `... aspetto l'.ex5 da Ns` — **non interrompere**.
6. `fase 2 (slippage 2/5, motore 2): NON DOVUTA` — il motore 2 non passa i
   cancelli A: **nessuna passata spesa**, è il criterio §5.6.
7. ⚠️ **NON aprire `anteprima_*.ini`** per leggere il modello: scrive `Model=4`
   **hardcoded** (classe 96). Il modello vero si legge da `gen_*.ini` nello zip.
8. **La corsa è più lenta del 03/09**: è il prezzo di un agente solo, ed è il
   punto del giro.
9. `CODICE DI USCITA NON LETTO` a fine blocco — non è un fallimento (classe 108):
   fa fede il referto.

## 🟡 SE LA RIGA SI FERMA SU **«NON SO QUALE TERMINALE USARE»**
È la regola di casa (**classe 115**). Il selettore è quello già girato pulito il
03/09 sulla stessa macchina (`BCM Markets MT5 Terminal`, non `-V3`); se trova
zero o due candidate, **stampa l'elenco**. Copia la cartella di quella di
backtest e rilancia **lo stesso blocco** aggiungendo `-Terminale '<cartella>'`.

## 🔁 RICETTA DEL PIN (prima pinnatura) — si prova su una COPIA prima di scriverla
```bash
F=backtest_pipeline/righe/RIGA_R116BIS_LONDONFX_DA_MANDARE.md
SHA=$(git rev-parse HEAD)          # il commit che CONTIENE driver + 2 prova + EA + include + generico
TOK='@@PIN'"@@"                    # composto: la ricetta non contiene la stringa che cerca (punto 77)
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|" "$F"
grep -c "\$pin='$SHA'" "$F"        # DEVE dare 4 (blocchi 1-4)
grep -c "\$pin='$TOK'" "$F"        # DEVE dare 0
CART='segnap'"osto"'\|non funz'"iona"'\|la riga non par'"te"   # composto (punto 77)
grep -ci "$CART" "$F"              # DEVE dare 0
```
**Ri-pinnatura** (vecchio → nuovo): il pin vecchio si legge **dai punti d'uso**
(`grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1`), si sostituisce **solo lì** e
nel titolo, poi **quattro conteggi**: 4 nuovi / 0 vecchi a 40 / 0 cartelli /
**0 occorrenze del prefisso a 7** del vecchio in tutta `backtest_pipeline/`
(classe 103). Le menzioni in prosa di un pin sono storia e **non si toccano**.
