# 📮 R101 — LE DUE RIGHE DA MANDARE A CLAUDIO

**Pin:** `e4c1afac63f0d094e7895d5f0626a183c43f0566`  _(era `bdd77e9`: ripinnato dal verificatore dopo il FIX della virgola finale in `$VIVA` — con `bdd77e9` lo script **non parsava**)_
**Marcatore di versione:** `MARCATORE_RIGA_R101_v1`
**Driver:** `backtest_pipeline/righe/RIGA_R101_ABLAZIONE.ps1`
**Criteri:** `backtest_pipeline/risultati_archivio/R101_CRITERI.md` — ✍️ **FIRMATI**
(Claudio 23/08: *"FIRMO TUTTE E 6 CON LE PROPOSTE, POI FACCIO I 2 CONTROLLI"*)

> ⚠️ **QUESTE RIGHE NON SONO ANCORA STATE MANDATE.** Passano prima dal
> verificatore.
>
> ## 🔴 E LA RIGA 2 ASPETTA ANCORA UNA COSA, CHE NON È UNA FIRMA
>
> Claudio ha firmato *"POI FACCIO I 2 CONTROLLI"*. Sono le **due verifiche sul
> grafico** del § 10.1 dei criteri, e **il lancio della corsa vera aspetta
> quelle**:
>
> 1. **Dow** — `InpMinStopPts` = **500**? `InpSkipIfTight` = **false**?
>    `InpMinRangePts` / `InpMaxRangePts` = **0 / 0**?
> 2. **DAX** — `InpAllowShort` = **0**? *(il sorgente dice ancora `true`: il
>    lato è spento **sul grafico**)*
>
> **Se uno dei due non torna, la cella viva scritta nei 20 file prova non è la
> sedia viva**, e i file vanno corretti PRIMA — non dopo aver visto i numeri.
> Nessuno script può leggere un grafico: quello lo fa Claudio, sul VPS, in
> cinque minuti.
>
> ✅ **La riga 1 (giro a vuoto) invece si può mandare subito**: non dipende dai
> due controlli, e serve proprio a scoprire prima gli errori di sintassi.

---

## ✅ Cosa è stato verificato PRIMA di scrivere queste righe (checklist 1-4)

| # | controllo | esito |
|---|---|---|
| **1** | **Ho aperto lo script.** L'ho scritto io, e l'ho comunque riletto | ✅ |
| **2** | **Difetti gemelli.** Cercati `fermoDa -ge`, `-eq $null` col null a destra, `$` multilinea senza `\r?`, `Desktop` nella raccolta | ✅ trovati **6** `-eq/-ne $null` con l'array a sinistra e **corretti** (trappola PS: `@(1,2) -eq $null` è un confronto elemento per elemento) |
| **3** | **Il file dei parametri è quello giusto?** Questa riga **VERIFICA**, non cerca: 20 file prova, ognuno con **un solo asse Y** (`InpMagic`, le due gemelle). Nessuna griglia | ✅ |
| **4** | **Il SHA contiene la correzione?** `git log -1 -- <file>` su tutti e 8 i file scaricati dal driver: driver, criteri, 20 prova, `walkforward_generico.ps1`, i 2 `.mq5`, l'include | ✅ **tutti antenati del pin** |
| **+** | **ASCII puro** nel `.ps1` (regola di casa 4, PS 5.1 legge i `.ps1` come ANSI) | ✅ **0 byte > 127** |
| **+** | **Marcatori pretesi dal driver** esistono davvero: `RigaSpread`, `$EABranch="lavoro"`, 2× `[Experts]`, `ABTG_GuardiaIngresso` (82.941 byte), `#property version "1.01"` ×2, `ABTG_DEF_MAGIC 770202/770101` | ✅ |
| **+** | **Bilanciamento** graffe/tonde/quadre e stringhe non chiuse | ✅ 0/0/0 |
| **+** | **Diff a stella** sui 20 file prova: 1 riga di differenza (2 su `04_corso_or`, **4 sui due `09_corso_pieno`** — dichiarate) + `InpMagic`, e **ogni nome esiste nel sorgente** | ✅ **rifatto meccanicamente dal verificatore** |

> ✅ **PARSE VERO FATTO, e ha trovato un errore FATALE.** Il preparatore aveva
> dichiarato che in questo ambiente non c'era PowerShell e che il `.ps1` non era
> mai stato parsato da un interprete vero. Il verificatore ha **installato
> pwsh 7.4.6** e ha lanciato
> `[System.Management.Automation.Language.Parser]::ParseFile`:
> **2 errori di parse**, righe 306 e 315 — una **virgola a fine riga** dentro
> l'hashtable `$VIVA` continuava l'espressione e faceva leggere `"DAX" = @(...)`
> come un'assegnazione a una stringa letterale.
> **Su PS 5.1 il `.ps1` sarebbe morto prima di eseguire una sola riga.**
> Corretto nel pin `e4c1afa`; riparsato: **0 errori**.
>
> Verificato inoltre **ESEGUENDO** i gate veri sui 20 file prova (con il
> download stubbato sul repo locale) e il parser del CSV **sotto cultura
> it-IT**: `1.27013` letto `1,27013` e non `127013`, colonne ignote → `null`,
> una riga sola → `NON VALIDO`.
> 👉 **La riga 1 resta il GIRO A VUOTO e va mandata per prima**: qui non si può
> provare né MT5, né il tester, né i percorsi Windows.

---

## ⚙️ REGOLE DI TRAFFICO — da dire in chat insieme alla riga

- 🖥️ **PC DI BACKTEST**, non il VPS.
- 🔒 **MetaTrader E MetaEditor CHIUSI.** Il driver si rifiuta di partire se li
  trova aperti (MT5 aperto = zero CSV; MetaEditor è single-instance e la
  compilazione tornerebbe subito senza compilare).
- 🚦 **UNA MACCHINA, UN LAVORO.** Prima di lanciare la riga 2 deve essere
  **finito** qualunque altro round che apre MT5.
- ⏱️ **Durata riga 2: [STIMA], non una previsione.** 80 passate a tick reali
  su mezza finestra l'una. Il driver misura la prima cella e stampa il tetto
  teorico. `-OreMax 12` è un tetto sull'**inizio** di nuovi file, non
  un'interruzione.

---

# 1️⃣ RIGA 1 — IL GIRO A VUOTO (si manda SUBITO, non serve nessuna firma)

**Cosa fa:** scarica tutto al pin, verifica i 20 file prova uno per uno,
**compila i due EA**, e scrive le 20 anteprime `.ini` che girerebbero —
confrontando da solo la finestra IS che il driver generico calcola con quella
scritta nei criteri. **Non apre il tester, non produce nessun numero.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='e4c1afac63f0d094e7895d5f0626a183c43f0566'; $p="$env:USERPROFILE\RIGA_R101.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R101_ABLAZIONE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R101_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
```

**Sul Desktop esce:** `R101_ABLAZIONE_CONTROLLO_<data>.zip`
🚫 **Questo zip NON è il round** e non va letto come risultato: lo dice anche
il suo referto, alla riga `modo:`.

---

# 2️⃣ RIGA 2 — LA CORSA VERA (⛔ **solo DOPO i 2 controlli sul grafico**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='e4c1afac63f0d094e7895d5f0626a183c43f0566'; $p="$env:USERPROFILE\RIGA_R101.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R101_ABLAZIONE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R101_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
```

### ✅ Il `-CriteriFirmati` NON SERVE PIÙ — e va detto perché

Il driver scarica `R101_CRITERI.md` **al pin** e cerca la stringa del lucchetto.
Con la firma del 23/08 quella stringa è stata tolta da **tutte e sei** le
posizioni in cui compariva: **verificato sul file AL PIN `e4c1afa` → 0
occorrenze**, quindi **il gate si apre da solo**.

`-CriteriFirmati` resta nel codice come **scialuppa**: se qualcuno riscrivesse
quella stringa nei criteri — anche dentro una frase storica — il gate si
richiuderebbe a sproposito, e quello switch permette di superarlo
**dichiarandolo nel referto**. Non serve oggi.

⚠️ **Il gate non è stato tolto**, ed è voluto: il round tocca due sedie che
stanno sui soldi del conto 100k, e la regola di casa è che i criteri si
congelano PRIMA dei numeri. Un driver che parte comunque rende la regola un
ornamento.

---

# 3️⃣ LA RIGA DI RACCOLTA (regola di casa: sempre, a fine test)

Il driver la cartella e lo zip li fa **da solo**. Questa riga serve a
**verificare in console** che ci sia tutto e a ricreare lo zip se serve.

```powershell
& { $d="$env:USERPROFILE\Desktop"; $c=Get-ChildItem $d -Directory -Filter 'R101_ABLAZIONE_*' | Sort-Object LastWriteTime -Desc | Select-Object -First 1;
    if(-not $c){ Write-Host 'NESSUNA CARTELLA R101 SUL DESKTOP' -ForegroundColor Red; return };
    $z=Join-Path $d ($c.Name + '.zip'); if(Test-Path $z){ Remove-Item $z -Force }; Compress-Archive -Path (Join-Path $c.FullName '*') -DestinationPath $z -Force;
    Write-Host ''; Write-Host ('CARTELLA : ' + $c.FullName) -ForegroundColor Cyan; Write-Host ('ZIP      : ' + $z + '   <- mandami QUESTO') -ForegroundColor Cyan;
    $csv=@(Get-ChildItem $c.FullName -Filter '*.csv'); $prv=@(Get-ChildItem $c.FullName -Filter 'R101_*.txt'); $ini=@(Get-ChildItem $c.FullName -Filter 'anteprima_*.ini');
    Write-Host ('  CSV dei risultati ... ' + $csv.Count + '   (attesi 40 nella CORSA, 0 nel giro a vuoto)');
    Write-Host ('  file prova .......... ' + $prv.Count + '   (attesi 20)');
    Write-Host ('  anteprime .ini ...... ' + $ini.Count + '   (attese 20 nel giro a vuoto, 0 nella corsa)');
    Write-Host ('  REFERTO_R101.txt .... ' + $(if(Test-Path (Join-Path $c.FullName 'REFERTO_R101.txt')){'c/e'}else{'MANCA!'}));
    Write-Host ''; Write-Host 'LE TRE RIGHE DA GUARDARE NEL REFERTO:' -ForegroundColor Yellow;
    Get-Content (Join-Path $c.FullName 'REFERTO_R101.txt') -EA SilentlyContinue | Select-String -Pattern '^modo:|^data:|VERDETTO G0' | ForEach-Object { Write-Host ('   ' + $_.Line) -ForegroundColor Yellow } }
```

**Cosa deve tornare in console:**

| | giro a vuoto (riga 1) | corsa vera (riga 2) |
|---|---|---|
| CSV dei risultati | **0** | **40** |
| file prova | **20** | **20** |
| anteprime `.ini` | **20** | **0** |
| `REFERTO_R101.txt` | c'è | c'è |
| riga `modo:` | `CONTROLLO` | `CORSA` |
| riga `data:` | **di adesso** | **di adesso** |
| `VERDETTO G0` | *non misurato* (giusto così) | **`RIPRODOTTO`** su tutte e due le famiglie |

> 🔴 **Se `VERDETTO G0` non dice `RIPRODOTTO`, il round non si legge.** Vuol
> dire che la cella viva del backtest non è la sedia che gira coi soldi, e
> tutti i gradini sarebbero misurati sopra un motore diverso. Il driver in quel
> caso **non lancia nemmeno i gradini** di quella famiglia — e l'altra va
> avanti.

---

## 🔁 SE LA CORSA SI FERMA A METÀ — la ripresa

Non serve rifare tutto. **Il METRO della famiglia rigira sempre** (è la cella
`00_viva`, cioè il denominatore: costa 2 CSV, non una passata sprecata).

```powershell
# una famiglia sola
... & $p -Pin $pin -SoloEa DAX

# una cella sola (il metro della sua famiglia rigira da solo)
... & $p -Pin $pin -SoloCella R101_DOW_03_atr.txt

# rifare anche i CSV gia' presenti
... & $p -Pin $pin -Rifai
```

⚠️ **Senza `-Rifai` il driver generico SALTA la finestra il cui CSV esiste
già.** Il driver di R101 se ne accorge **dalla data del file** e la marca
`SALTATA DAL DRIVER` fra i **PROBLEMI**, non fra gli OK: *un CSV di ieri non è
un risultato di oggi*, e se fra i due lanci fosse cambiato il pin metà round
verrebbe da un altro motore.

---

## 📊 I NUMERI ATTESI, dichiarati PRIMA (corsa vera)

| | |
|---|---|
| celle | **20** (10 Dow + 10 DAX) |
| CSV | **40** (IS + OOS per cella) |
| righe per CSV | **2** — le due gemelle, che devono uscire **identiche al centesimo** |
| passate | **80** |
| IS | 2024.09.26 → 2025.06.09 |
| OOS | 2025.06.10 → 2026.06.30 |
| modello | **4 = tick reali** · deposito 100.000 · rischio **1,00%** |

🔵 **Il metro che il gate G0 deve riprodurre:**
- **Dow** — OOS `PF 1,27013 · DD 4,3941% · n 130` (R54 riga *"solo LONG"*, che
  riproduce R46 riga *"A = LIVE"*)
- **DAX** — OOS `PF 1,40 · DD 7,23%` (R46 riga *"A = LIVE"*). 🟠 **Il `n` del
  DAX non è agli atti**: `NAtti = -1` e **il gate sul n non si applica al DAX**.
  Lo misura questa corsa, e va scritto nei criteri.

🟡 **E il gradino 09 "IL CORSO PIENO" (decisione 4, firmata SÌ) va letto a
parte:** è l'unica cella **cumulativa** del round — muove quattro interruttori
insieme e **non attribuisce niente a nessun filtro**. Atteso, scritto prima dei
numeri: **il n crolla**, probabilmente sotto la soglia G1 di 30 → *"NON
MISURABILE"*. **Che è già una risposta**, non un fallimento: vorrebbe dire che
il metodo del corso applicato alla lettera non produce un campione su cui si
possa giudicare. ⛔ **Nessuna soglia si abbassa per farla "funzionare".**

🟠 **E ogni DD di questo round è all'1%.** Il forward del 100k gira a **0,65%**:
per confrontarli si moltiplica per **0,65** (criteri § 2.4). Chi salta la
conversione confronta due cose diverse.

---

_Scritto il 23/08/2026. **Nessuna riga mandata, nessuna passata lanciata,
nessun sorgente EA toccato, nessuna modifica al forward.**_
