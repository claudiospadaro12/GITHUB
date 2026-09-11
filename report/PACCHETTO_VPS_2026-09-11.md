# 📦 IL PACCHETTO PER IL VPS — 11/09/2026

> **Cosa e':** tre passi, **in quest'ordine**, per portare sul VPS il runner v3 e
> far girare **UN solo round** la prima notte.
> **Cosa NON e':** non e' una promozione, non tocca EA, preset, forward o conti.
> **Stato:** ogni riga e' passata da `controlla_riga.py` — esiti riportati sotto,
> riga per riga. Le righe sono **ASCII puro** e **0 errori** al parser PowerShell.

---

## 🟢 LE VITTORIE DI OGGI, prima dei difetti (regola di casa)
- Il collaudo dei cancelli fa **50 giusti su 50, uscita 0** — girato da me qui,
  tre volte, in tre disposizioni diverse.
- Le **impronte SHA-256** dei file pinnati **tornano tutte**, misurate sul blob
  git *e* riscaricate da `raw.githubusercontent.com` (HTTP **200**, byte identici).
- `R125d` passa `controlla_prova.py`: **2 celle, 4 passate, 0 problemi**, ora
  **SERVER** intatta (`InpRangeStartHour=8` = DAX 09:00 italiane).
- La guardia positiva sul banco e' **nel driver e nel walkforward**: l'unico
  bersaglio ammesso e' `C:\MT5_Backtest`.

---

## 🔴 I TRE FATTI CHE CAMBIANO IL PIANO (misurati, non dedotti)

### 1. Sul VPS gira la **v2**, e il referto lo dice
`backtest_pipeline/coda/referti/REFERTO_RUNNER_20260911_033002.txt`, prima riga:
`marcatore : MARCATORE_RUNNER_ABTG_v2`.
👉 La copia installata in `C:\ABTG\runner_abtg.ps1` **non ha la corsia ROUND**,
non ha G3 e non ha G4. Funziona (10 righe eseguite, ESITO COMPLETO) — ma **non
puo' far girare un round**.

### 2. 🛑 IL PIN DELLA RIGA DI CODA **NON** E' `a895dbc…` — e questo era bloccante
Al commit `a895dbc5b4511b3afe4ccf2340ac0d917f141403` il file
`RIGA_SOTTILE_ROUND.ps1` contiene ancora il **segnaposto**:
`$PIN = 'PIN_DA_RIMPIAZZARE_DOPO_IL_COMMIT'` (verificato con `git show`).
Il ri-pin e' arrivato **al commit dopo**, `e8b937f7…`.
👉 Se la riga di coda puntasse ad `a895dbc`, il runner scaricherebbe il file,
**lo farebbe passare dai cancelli** (l'ho misurato: 50/50 anche con quella
versione) e poi lo script **morirebbe da solo** con *"IL PIN NON E' UN COMMIT"*.
Fallimento rumoroso e innocuo — ma un round buttato.

**I DUE PIN FANNO DUE MESTIERI DIVERSI, e vanno scritti tutti e due:**

| pin | che cosa inchioda | dove si scrive |
|---|---|---|
| `e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c` | **il file** `RIGA_SOTTILE_ROUND.ps1` (e `runner_abtg.ps1`) | **nella riga di coda** e nelle righe di lancio |
| `a895dbc5b4511b3afe4ccf2340ac0d917f141403` | il driver + il walkforward + il file prova | **dentro** `RIGA_SOTTILE_ROUND.ps1`, alla riga `$PIN` |

✅ Verificato: `runner_abtg.ps1` e' **byte per byte identico** ai due pin
(`21AC6672…88006631`), quindi usare `e8b937f7` per tutto e' sicuro e toglie un
pin dalla testa.
✅ Verificato: `$PIN` dentro il file a `e8b937f7` **e'** `a895dbc5…`, e le due
impronte scritte in cima (`348ED533…` e `BAE1A08C…`) sono **esattamente** quelle
di `RIGA_ROUND_VPS.ps1` e `walkforward_generico.ps1` ad `a895dbc`.

### 3. Il collaudo 50/50 **non gira senza la cartella `righe\`**
`-CollaudoCancelli` legge `RIGA_SOTTILE_ROUND.ps1` **dal disco**, da
`$PSScriptRoot\righe\`. Senza quel file il collaudo stampa
**`47 giusti, 1 sbagliati su 48`** ed esce **1** (misurato). Per questo il passo 1
e' spezzato in **due righe**: prima il runner, poi la riga sottile accanto.

---

## ▶️ PASSO 1 — IL COLLAUDO A SECCO (nessun rischio)

**Cosa fa:** scarica dal pin `runner_abtg.ps1` e `RIGA_SOTTILE_ROUND.ps1`, ne
verifica **impronta e marcatore**, e fa girare `-CollaudoCancelli`: 50 casi di
sola logica testuale.
**Cosa NON fa:** non apre MT5, non tocca nessun terminale, non installa niente,
non registra attivita, non pubblica niente. Scrive **solo** in
`%USERPROFILE%\abtg_collaudo` e in una cartella nuova sul Desktop.

### RIGA 1A — il runner
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $d=Join-Path $env:USERPROFILE 'abtg_collaudo'; Remove-Item -LiteralPath $d -Recurse -Force -EA SilentlyContinue; New-Item -ItemType Directory -Force -Path (Join-Path $d 'righe') | Out-Null; $r=Join-Path $d 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA sul runner: ' + $h + ' -- NON PROSEGUIRE') }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'RUNNER VECCHIO: manca MARCATORE_RUNNER_ABTG_v3 -- NON PROSEGUIRE' }; Write-Host ('runner v3 scaricato e verificato: ' + $r) -ForegroundColor Green; Write-Host 'impronta SHA-256 uguale . marcatore MARCATORE_RUNNER_ABTG_v3 presente' -ForegroundColor Green; Write-Host 'ADESSO INCOLLA LA RIGA 1B.' -ForegroundColor Cyan }
```
**Cancello:** 🟢 `PASSATI (5)`, 0 bloccanti — pin `e8b937f7` verificato commit
vero con `git cat-file`, marcatore `MARCATORE_RUNNER_ABTG_v3` incrociato col pin.

### RIGA 1B — la riga sottile accanto, e il collaudo
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $d=Join-Path $env:USERPROFILE 'abtg_collaudo'; $r=Join-Path $d 'runner_abtg.ps1'; if(-not (Test-Path -LiteralPath $r -PathType Leaf)){ throw 'MANCA IL RUNNER: lancia prima la RIGA 1A' }; $s=Join-Path (Join-Path $d 'righe') 'RIGA_SOTTILE_ROUND.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c/backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1" -OutFile $s -EA Stop; $h=(Get-FileHash -LiteralPath $s -Algorithm SHA256).Hash; if($h -ne '2DA274EE9EBD0C741ADB28D68C452FCC049B69793E17CE0E967BCB9F067F00F6'){ throw ('IMPRONTA DIVERSA sulla riga sottile: ' + $h + ' -- NON PROSEGUIRE') }; if(-not (Select-String -LiteralPath $s -SimpleMatch -Pattern 'MARCATORE_RIGA_SOTTILE_ROUND_v1' -Quiet)){ throw 'RIGA SOTTILE VECCHIA: manca MARCATORE_RIGA_SOTTILE_ROUND_v1 -- NON PROSEGUIRE' }; Write-Host 'riga sottile scaricata: impronta uguale, marcatore presente' -ForegroundColor Green; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('COLLAUDO_CANCELLI_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $log=Join-Path $cart 'collaudo.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-CollaudoCancelli') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'collaudo_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ''; Write-Host ('CODICE DI USCITA DEL COLLAUDO: ' + $p.ExitCode); $n=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'COLLAUDO: 50 giusti, 0 sbagliati su 50').Count; if($p.ExitCode -eq 0 -and $n -eq 1){ Write-Host 'ESITO: 50 SU 50 -- SI PUO PASSARE AL PASSO 2' -ForegroundColor Green } else { Write-Host 'ESITO: NON E 50 SU 50 -- FERMATI QUI, MANDA LO ZIP, NON FARE IL PASSO 2' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
**Cancello:** 🟢 `PASSATI (5)`, 0 bloccanti.

### 📋 COSA DEVE TORNARE INDIETRO CLAUDIO
- La riga **`COLLAUDO: 50 giusti, 0 sbagliati su 50`**, e
  **`CODICE DI USCITA DEL COLLAUDO: 0`**.
- Lo zip `Desktop\COLLAUDO_CANCELLI_<data>_<ora>.zip`.
- 🔴 **Qualunque altro numero = ci si ferma qui.** Niente passo 2.
  (`47 su 48` vuol dire che la riga 1A/1B sono state invertite o che la cartella
  `righe` non c'e'.)

### 🔙 COME SI ANNULLA
Niente da annullare: non e' stato cambiato nulla sul sistema. Se si vuole pulire:
`Remove-Item "$env:USERPROFILE\abtg_collaudo" -Recurse -Force` e si cestina la
cartella sul Desktop.

---

## ▶️ PASSO 2 — L'AGGIORNAMENTO DEL RUNNER (solo se il passo 1 ha dato 50/50)

**Come viene installato — letto nel codice, non supposto** (`runner_abtg.ps1`,
ramo `-Installa`):
1. `New-Item -Force $DestDir` con **`$DestDir = "C:\ABTG"`**;
2. `Copy-Item $PSCommandPath -> C:\ABTG\runner_abtg.ps1`;
3. `schtasks /Delete /TN ABTG_Runner /F` **(cancella quella che gira oggi)**;
4. `schtasks /Create /TN ABTG_Runner /TR "powershell -NoProfile -ExecutionPolicy Bypass -File C:\ABTG\runner_abtg.ps1" /SC DAILY /ST 03:30 /F`;
5. **verifica sull'artefatto**: `schtasks /Query` deve **ritrovare** l'attivita',
   altrimenti esce 1.

🔴 **IL RISCHIO VERO, ed e' il passo 3 dell'elenco**: fra il `/Delete` e il
`/Create` c'e' una finestra in cui l'attivita' **non esiste**. Se il `/Create`
fallisce (permessi), il VPS resta **senza runner notturno**: cioe' **peggio di
adesso**, perche' oggi la v2 gira e produce il censimento ogni notte.
👉 Per questo la **riga 2A salva l'XML dell'attivita' attuale** *prima* di
toccare qualunque cosa. Quel file **e'** il modo di tornare indietro.

### RIGA 2A — la fotografia e il paracadute (non installa niente)
**Cosa fa:** stampa **PID + titolo + cartella programma** di ogni `terminal64`
vivo (regola dei terminali multipli: nessun riconoscimento a occhio), confronta
**l'impronta** del runner installato con quella della v3 del pin, e salva su
Desktop **l'XML dell'attivita' pianificata** + una copia del runner installato.
**Cosa NON fa:** non cancella, non crea, non installa, non tocca MT5.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('PRIMA_DI_INSTALLARE_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $rif=Join-Path $cart 'runner_v3_dal_pin.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c/backtest_pipeline/runner_abtg.ps1" -OutFile $rif -EA Stop; $hRif=(Get-FileHash -LiteralPath $rif -Algorithm SHA256).Hash; if($hRif -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA sul runner del pin: ' + $hRif) }; if(-not (Select-String -LiteralPath $rif -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'IL FILE DEL PIN NON E LA v3 -- NON PROSEGUIRE' }; Write-Host ('riferimento v3 dal pin: impronta ' + $hRif) -ForegroundColor Green; Write-Host '=== I TERMINALI MT5 VIVI ADESSO (PID + titolo + cartella programma) ===' -ForegroundColor Cyan; $t=@(Get-Process -Name terminal64 -EA SilentlyContinue | Select-Object Id, MainWindowTitle, Path); if($t.Count -eq 0){ Write-Host '  nessun terminal64 in esecuzione' } else { $t | Format-List }; $t | Out-File -LiteralPath (Join-Path $cart 'terminali_vivi.txt') -Encoding ASCII; Write-Host '=== IL RUNNER GIA INSTALLATO SUL VPS ===' -ForegroundColor Cyan; $inst='C:\ABTG\runner_abtg.ps1'; if(Test-Path -LiteralPath $inst -PathType Leaf){ $hIns=(Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash; Write-Host ('  file     : ' + $inst); Write-Host ('  data     : ' + (Get-Item -LiteralPath $inst).LastWriteTime); Write-Host ('  impronta : ' + $hIns); if($hIns -eq $hRif){ Write-Host '  VERDETTO : GIA AGGIORNATO alla v3 -- il PASSO 2B non serve' -ForegroundColor Green } else { Write-Host '  VERDETTO : DIVERSO dalla v3 del pin -- e la copia VECCHIA che gira alle 03:30' -ForegroundColor Yellow }; Write-Host ('  ha il marcatore v3: ' + (Select-String -LiteralPath $inst -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)); Copy-Item -LiteralPath $inst -Destination (Join-Path $cart 'runner_INSTALLATO_PRIMA.ps1') -Force } else { Write-Host ('  NON INSTALLATO: non trovo ' + $inst) -ForegroundColor Yellow }; Write-Host "=== L ATTIVITA PIANIFICATA ADESSO ===" -ForegroundColor Cyan; cmd /c 'schtasks /Query /TN ABTG_Runner /V /FO LIST 2>&1' | ForEach-Object { Write-Host ('  ' + $_) }; cmd /c 'schtasks /Query /TN ABTG_Runner /XML 2>&1' | Out-File -LiteralPath (Join-Path $cart 'ABTG_Runner_COME_E_ADESSO.xml') -Encoding ASCII; Write-Host ''; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan; Write-Host ('MODO DI TORNARE INDIETRO SALVATO: ' + (Join-Path $cart 'ABTG_Runner_COME_E_ADESSO.xml')) -ForegroundColor Green }
```
**Cancello:** 🟢 `PASSATI (6)`, 0 bloccanti.

### RIGA 2B — l'installazione vera
**Cosa fa:** riscarica il runner dal pin, riverifica impronta e marcatore, lancia
`-Installa`, e poi **verifica sull'artefatto**: l'impronta del file in
`C:\ABTG` deve essere quella del pin **e** `schtasks /Query` deve ritrovare
`ABTG_Runner`.
**Cosa NON fa:** non esegue nessuna coda, non apre MT5, non tocca i terminali.
⚠️ Se dice *"Accesso negato"*: chiudere, riaprire **PowerShell come
Amministratore** e rilanciare la stessa riga.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('INSTALLA_RUNNER_V3_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $r=Join-Path $cart 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $atteso='21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne $atteso){ throw ('IMPRONTA DIVERSA: ' + $h + ' -- NON INSTALLO NIENTE') }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'NON E LA v3 -- NON INSTALLO NIENTE' }; Write-Host 'runner v3: impronta uguale, marcatore presente' -ForegroundColor Green; $log=Join-Path $cart 'installazione.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-Installa') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'installazione_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ('CODICE DI USCITA: ' + $p.ExitCode); Write-Host '=== VERIFICA SULL ARTEFATTO, non sul codice di uscita ===' -ForegroundColor Cyan; $inst='C:\ABTG\runner_abtg.ps1'; $okFile=$false; if(Test-Path -LiteralPath $inst -PathType Leaf){ $hi=(Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash; Write-Host ('  installato: ' + $inst); Write-Host ('  impronta  : ' + $hi); $okFile = ($hi -eq $atteso); Write-Host ('  uguale alla v3 del pin: ' + $okFile) -ForegroundColor $(if($okFile){'Green'}else{'Red'}) } else { Write-Host ('  NON TROVO ' + $inst) -ForegroundColor Red }; $q=@(cmd /c 'schtasks /Query /TN ABTG_Runner /V /FO LIST 2>&1'); $q | ForEach-Object { Write-Host ('  ' + $_) }; $q | Out-File -LiteralPath (Join-Path $cart 'attivita_dopo.txt') -Encoding ASCII; $okTask=@($q | Where-Object { $_ -match 'ABTG_Runner' }).Count -gt 0; Write-Host ("  attivita' ABTG_Runner ritrovata: " + $okTask) -ForegroundColor $(if($okTask){'Green'}else{'Red'}); if($okFile -and $okTask){ Write-Host 'ESITO: RUNNER v3 INSTALLATO E ATTIVITA VIVA -- si puo passare al PASSO 3' -ForegroundColor Green } else { Write-Host 'ESITO: INSTALLAZIONE NON DIMOSTRATA -- RIMETTI IL VECCHIO (vedi COME SI TORNA INDIETRO) E MANDAMI LO ZIP' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
**Cancello:** 🟢 `PASSATI (5)`, 0 bloccanti.

### 📋 COSA DEVE TORNARE INDIETRO CLAUDIO
- Da 2A: la riga **`VERDETTO :`** (mi aspetto *"DIVERSO dalla v3 del pin"*) e lo
  zip `Desktop\PRIMA_DI_INSTALLARE_<data>.zip`.
- Da 2B: **`uguale alla v3 del pin: True`** e
  **`attivita' ABTG_Runner ritrovata: True`**, piu' lo zip.

### 🔙 COME SI ANNULLA (disinstallazione e ritorno alla v2)
1. **Rimettere l'attivita' com'era** (dall'XML salvato da 2A):
   `schtasks /Create /TN ABTG_Runner /XML "<Desktop>\PRIMA_DI_INSTALLARE_<data>\ABTG_Runner_COME_E_ADESSO.xml" /F`
2. **Rimettere il file com'era**:
   `Copy-Item "<Desktop>\PRIMA_DI_INSTALLARE_<data>\runner_INSTALLATO_PRIMA.ps1" "C:\ABTG\runner_abtg.ps1" -Force`
3. **Spegnere del tutto il runner** (se si vuole tornare a zero):
   `schtasks /Delete /TN ABTG_Runner /F` — e da quella notte il VPS non esegue
   piu' nessuna coda. 🟢 **Nessun EA, nessuna sedia, nessun conto ne risente**:
   il runner legge e fotografa, non opera.

---

## ▶️ PASSO 3 — LA CODA DI R125: **UNA RIGA SOLA**, ed e' `r125d`

### 🎯 PERCHE' PROPRIO `r125d` (e non una delle altre cinque)
| | `r125a` | `r125b` | `r125c` | **`r125d`** | `r125e` | `r125f` |
|---|---:|---:|---:|---:|---:|---:|
| celle | 7 | 5 | 7 | **2** | 5 | 7 |
| passate (celle x 2 finestre) | 14 | 10 | 14 | **4** | 10 | 14 |
| costo tester (0,101 min/passata, misurato su R88) | ~1,4 min | ~1,0 | ~1,4 | **~0,4 min** | ~1,0 | ~1,4 |

1. 📏 **E' la piu' corta che esista nel round**: 2 celle, 4 passate, **~0,4
   minuti** di tester. Se la notte va storta, si perde il round piu' economico.
2. 🧪 **Le sue due celle sono GEMELLE per costruzione** (`InpMagic=779860||779860||10||779870||Y`,
   asse tecnico dichiarato nel file prova): devono uscire **identiche al
   centesimo**. Cioe' `r125d` non e' solo il round piu' corto, e' anche
   **l'unico che verifica se il banco e' pulito**: se le due passate differiscono,
   il percorso nuovo ha un problema e lo dice **prima** di qualunque numero.
   👉 Per un percorso mai percorso, un round **auto-diagnostico** vale piu' di
   un round grande.
3. ⚖️ **Chiude un buco di regola**: e' il **lato short del DAX**, che nel
   censimento dei lati **non esiste** (regola dei due lati, 25/08).
4. ✅ `controlla_prova.py`: **`OK` — 2 celle, 4 passate, 0 problemi**.
5. 🕐 **Ora SERVER verificata**: `InpRangeStartHour=8` = DAX **09:00 italiane**.
   (Se leggessi `9` sarebbe da cestinare.)

### 📌 LA RIGA DI CODA — va in fondo a `backtest_pipeline/coda/CODA.txt`
> 🔴 **La aggiunge la sessione principale con un commit + push su `lavoro`. Io
> non committo niente.** Va messa **in FONDO**, dopo le dieci righe di sola
> lettura: cosi' il censimento notturno esce comunque, anche se il round si
> impunta.

```
e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_ORB_Ottimizzato -Prova R125d_lato_short_D30EUR.txt -Etichetta r125d -Modello 4 -Deposito 100000
```

**Cancello `controlla_riga.py`:** 🔴 **FAIL — e il FAIL e' dello strumento, non
della riga.** Testuale:
`X [PIN] nessun pin trovato` · `X [MARCATORE] la riga non verifica il MARCATORE`.
👉 Il motivo, letto nel codice (`controlla_riga.py`, r.433-443 e r.513-516): il
cancello sa trattare `riga | ps1 | prova | md`, **non esiste l'oggetto `coda`**;
e cerca il pin solo dentro una URL `githubusercontent.com/.../<pin>/` o in un
`$PIN=`. Una riga di coda ha il pin nel **primo campo**, e il marcatore **lo
controlla il runner, non la riga**. 🔴 **Non l'ho aggirato e non ho toccato lo
strumento**: ho verificato la riga con **l'autorita' che la leggera' davvero**,
piu' `git` e `HTTP`. E' una **classe nuova** da scrivere in checklist.

**Quello che HO verificato, e come:**
| controllo | come | esito |
|---|---|---|
| il pin e' un commit vero | `git cat-file -t e8b937f7…` | 🟢 `commit` |
| il file esiste a quel pin ed e' servito | `curl` su `raw.githubusercontent.com` | 🟢 **HTTP 200**, 22.045 byte |
| i byte serviti = i byte letti | SHA-256 scaricato vs blob git | 🟢 `2DA274EE…F067F00F6` |
| formato del percorso accettato dal runner | regex `^backtest_pipeline/righe/[A-Za-z0-9_.-]+\.ps1$` | 🟢 |
| **G1+G2+G3 sul file vero** | `VagliaScript` del runner v3, eseguito | 🟢 `ok=True corsia=ROUND` — *"bersaglio dichiarato e coerente"* |
| **G4 sugli argomenti veri** | `VagliaArgomenti` del runner v3, eseguito | 🟢 `ok=True — G4 passato` |
| lista bianca della riga sottile | `^[A-Za-z0-9_.-]+$` su Expert/Prova/Etichetta | 🟢 tutti e tre |
| il file prova c'e' al pin **interno** | `git cat-file -e a895dbc:…/R125d_…txt` | 🟢 |
| il file prova regge il cancello semantico | `controlla_prova.py` | 🟢 `OK`, 2 celle |

### RIGA 3B — il giro a vuoto della coda, **da fare SUBITO dopo il push**
**Cosa fa:** scarica il runner v3 dal pin, gli fa scaricare **la coda vera** e la
**vaglia riga per riga**, e si ferma li'.
**Cosa NON fa:** con `-SoloControllo` **non esegue nessuna riga**; con
`-NonPubblicare` **non scrive niente sul repo**. Non apre MT5.
👉 E' il modo di vedere il cancello dire di **si** alla riga R125d **su Windows
PowerShell 5.1**, senza far partire niente. Il collaudo del passo 1 gira su casi
finti; questo gira sulla coda vera.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('CODA_A_VUOTO_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $r=Join-Path $cart 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/e8b937f7fdfc963ee09e24f3b717a3b8f6a2991c/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA: ' + $h) }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'NON E LA v3 -- NON PROSEGUIRE' }; Write-Host 'runner v3 verificato. Adesso VAGLIO la coda SENZA eseguire niente.' -ForegroundColor Green; $log=Join-Path $cart 'coda_a_vuoto.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-SoloControllo','-NonPubblicare') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'coda_a_vuoto_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ('CODICE DI USCITA: ' + $p.ExitCode); $rif=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'RIFIUTATO').Count; $rnd=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'corsia  : ROUND').Count; Write-Host ('righe RIFIUTATE: ' + $rif + '   righe accettate in corsia ROUND: ' + $rnd); if($rif -eq 0 -and $rnd -eq 1){ Write-Host 'ESITO: la riga R125d passa i cancelli e NON e stata eseguita. Stanotte alle 03:30 girera.' -ForegroundColor Green } else { Write-Host 'ESITO: NON E QUELLO CHE MI ASPETTO -- mandami lo zip e NON lasciarla in coda' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
**Cancello:** 🟢 `PASSATI (5)`, 0 bloccanti.
**Cosa deve stampare:** `righe di coda: 11`, per la riga R125d
`corsia  : ROUND` e `(SoloControllo: non lo eseguo)`, e **`righe RIFIUTATE: 0`**.

### 🌙 PRIMA DI ANDARE A DORMIRE — una cosa sola, e va detta col numero di conto
🔴 **Il terminale del banco dev'essere CHIUSO.** La riga sottile **non espone**
`-ChiudiBacktest` (scelta dichiarata: *"un collaudo che uccide processi non e' un
collaudo"*), quindi se quel terminale e' aperto il round **muore con uscita 1** e
non produce niente.

| | |
|---|---|
| **conto da chiudere** | **50504400** (demo **solo tester**, zero EA attaccati) |
| **cartella programma** | `C:\MT5_Backtest` |
| **cosa NON si tocca** | **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`), **50504263** (`… -V3`), **10105439** (`C:\BCM_Reale`) |

La riga **2A** stampa gia' **PID + titolo + cartella** di ogni terminale: si
chiude **solo** quello la cui colonna `Path` comincia con `C:\MT5_Backtest`.
🚫 **Non do nessuna riga che chiuda processi**: la finestra la chiude Claudio, a
mano, riconosciuta da una stringa **stampata**, non a occhio.

### RIGA 3C — LA RACCOLTA, la mattina dopo
**Cosa fa:** mette in una cartella sul Desktop i CSV di `r125d`, il referto del
round, il referto del runner e i log, conta quello che trova e fa lo zip.
**Cosa NON fa:** non cancella niente, non tocca terminali ne' preset.

```powershell
& { $ErrorActionPreference='Stop'; $ieri=(Get-Date).Date.AddDays(-1); $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('R125d_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_round\risultati_prove') -Recurse -Include '*r125d*.csv' -EA SilentlyContinue | Copy-Item -Destination $cart -Force -EA SilentlyContinue; $rd=Join-Path ([Environment]::GetFolderPath('Desktop')) 'ROUND_r125d'; if(Test-Path -LiteralPath $rd){ Get-ChildItem -LiteralPath $rd -File -EA SilentlyContinue | Copy-Item -Destination $cart -Force -EA SilentlyContinue }; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_sottile') -File -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $ieri } | Copy-Item -Destination $cart -Force -EA SilentlyContinue; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_runner') -File -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $ieri } | Copy-Item -Destination $cart -Force -EA SilentlyContinue; $nc=@(Get-ChildItem -LiteralPath $cart -File -Filter '*.csv' -EA SilentlyContinue).Count; $nr=@(Get-ChildItem -LiteralPath $cart -File -Filter 'REFERTO_ROUND_r125d.txt' -EA SilentlyContinue).Count; $nu=@(Get-ChildItem -LiteralPath $cart -File -Filter 'REFERTO_RUNNER_*.txt' -EA SilentlyContinue).Count; Write-Host ('CSV raccolti            : ' + $nc + ' su 2 attesi (IS e OOS di r125d)') -ForegroundColor Cyan; Write-Host ('REFERTO_ROUND_r125d.txt : ' + $nr + ' su 1 atteso') -ForegroundColor Cyan; Write-Host ('REFERTO_RUNNER_*.txt    : ' + $nu + ' su 1 atteso') -ForegroundColor Cyan; if($nc -lt 2){ Write-Host 'ATTENZIONE: mancano dei CSV -- il round e MONCO. Mandalo lo stesso e dimmelo.' -ForegroundColor Yellow }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length, LastWriteTime | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Green }
```
**Cancello:** 🟢 `PASSATI (2)`, 0 bloccanti, **1 rilievo (classe 235)**: *"la riga
SCRIVE … ma e' una RACCOLTA"* — e' la forma che la regola di casa **impone**.

**File attesi:** **2 CSV** (`ABTG_ORB_Ottimizzato_D30EUR_IS_r125d.csv` e
`…_OOS_r125d.csv`), **`REFERTO_ROUND_r125d.txt`**, **`REFERTO_RUNNER_<data>.txt`**.
ℹ️ Il driver fa gia' da solo `Desktop\ROUND_r125d.zip`; e il runner pubblica
referto e log da solo in `backtest_pipeline/coda/referti/`. Questa riga serve
perche' i pezzi stanno in **tre posti diversi** (classe 218).

### 📋 COSA DEVE TORNARE INDIETRO CLAUDIO
- Da 3B: `righe RIFIUTATE: 0` e `righe accettate in corsia ROUND: 1`.
- La mattina: lo zip `Desktop\R125d_<data>_<ora>.zip` **e** le tre righe di
  conteggio. 🔴 **Un round monco si manda lo stesso e si dice che e' monco**:
  non si legge come se fosse intero.

### 🔙 COME SI SVUOTA LA CODA
- **Il modo pulito:** la sessione principale rimette un `#` davanti alla riga
  R125d in `CODA.txt` e pusha. Il runner salta tutte le righe che cominciano con
  `#` (r.729 del runner). **Nessuna corsa parte** dalla notte dopo.
- **Il modo d'emergenza, dal VPS, senza aspettare nessuno:**
  `schtasks /Delete /TN ABTG_Runner /F` — spegne il runner del tutto.
- **Se un round e' gia' partito e si e' piantato:** il runner aspetta il figlio
  **senza timeout** (vedi NON COPERTO). Si chiude a mano la finestra
  `powershell.exe` della corsa; i terminali in forward non c'entrano e non vanno
  toccati.

---

## 🔀 L'ORDINE, E COSA SUCCEDE SE SI SBAGLIA

### ✅ L'ordine giusto
**1A → 1B → (se 50/50) 2A → 2B → push della coda → 3B → chiudere il banco → la notte → 3C**

### ❓ "E se Claudio fa il PASSO 3 senza il PASSO 2?"
**Risposta misurata, non supposta.** Ho estratto i cancelli della **v2** (il
commit `0fb87d2`, quello installato) e ho dato loro in pasto il file vero:
```
v2 su RIGA_SOTTILE_ROUND: ok=False
motivo=G1: manca il marcatore 'RUNNER_SOLA_LETTURA'. Uno script non entra in coda per sbaglio.
```
👉 La v2 **rifiuta la riga al primo cancello**. Nessun round parte, nessun
terminale viene toccato, il censimento delle altre 10 righe gira come sempre, e
la mattina il referto pubblicato dice **`RIFIUTATO`** a chiare lettere.
🟢 **Quindi l'ordine sbagliato costa una notte, non un danno.**

### ❓ "C'e' un ordine che lascia il VPS PEGGIO di adesso?"
**Sì, uno solo: fare 2B senza 2A.** E' l'unico punto del pacchetto che
**distrugge** qualcosa (il `/Delete` dell'attivita' che oggi funziona) prima di
ricrearlo. Senza l'XML salvato da 2A, se il `/Create` fallisce per permessi si
resta senza runner notturno e senza il modo rapido di rimetterlo com'era.
👉 **2A non e' un preliminare gentile: e' il paracadute.**

Tutto il resto e' reversibile o innocuo: il passo 1 non tocca il sistema; il
passo 3 senza il 2 viene rifiutato; il passo 3 con il 2 gira **solo** sul banco
`C:\MT5_Backtest` (guardia **positiva** nel driver **e** nel walkforward: e'
l'**unico** bersaglio ammesso, gli altri fanno morire lo script).

---

## 🧠 I CONTROLLI DI GIUDIZIO — cosa ho aperto e letto davvero

| file | letto | verdetto |
|---|---|---|
| `backtest_pipeline/runner_abtg.ps1` | intero, 48.620 byte | fa quello che promette. `-CollaudoCancelli` **esce prima** di creare cartelle o toccare la rete: e' davvero a secco |
| `backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1` | intero | fa quello che promette; **dichiara da solo** il proprio buco (il codice MQL5 viene dalla testa del branch, non dal pin) |
| `backtest_pipeline/righe/RIGA_ROUND_VPS.ps1` | le guardie e la corsa | la chiusura processi e' **chirurgica**: bersaglio = solo cio' che sta sotto `C:\MT5_Backtest\*`; tutto il resto e' esplicitamente *"LASCIATI VIVI (forward e CONTO REALE: NON li tocco)"* |
| `backtest_pipeline/walkforward_generico.ps1` | selezione del terminale | `-TerminaleBacktest` passa da `MotivoRifiutoBanco`: **unico bersaglio ammesso `C:\MT5_Backtest`** |
| `backtest_pipeline/prove/R125d_lato_short_D30EUR.txt` | intero | misura **una** cosa (esiste il lato short del DAX?), attesa dichiarata **prima** dei numeri, finestra `@DAQUANDO 2024.09.26`, ora **server** |
| `backtest_pipeline/coda/CODA.txt` | intero | 10 righe di sola lettura, tutte con pin a 40 esadecimali |

### 🪦 IL CERTIFICATO DI MORTE — **non si applica**
Questo pacchetto **non archivia nessun candidato**. Anzi: `r125d` va nella
direzione opposta — e' la **prima misura in assoluto** del lato short del DAX, cioe'
va a riempire la casella 4 del certificato (*"i simboli/lati gemelli sono stati
provati?"*) per la famiglia ORB. 🟢 Nessun verdetto di morte viene emesso qui.

---

## 🆕 CLASSI NUOVE DA SCRIVERE IN `CHECKLIST_RIGA_DI_LANCIO.md`
(le lascio qui pronte: **non modifico la checklist**, non e' il mio file)

### 240. 📌 IL FILE CHE CONTIENE IL PIN NON PUO' ESSERE PRESO DA QUEL PIN (11/09/2026)
`RIGA_SOTTILE_ROUND.ps1` porta dentro di se' `$PIN = 'a895dbc…'`. Ma al commit
`a895dbc` quel file conteneva ancora `PIN_DA_RIMPIAZZARE_DOPO_IL_COMMIT`: il
ri-pin e' **per forza** un commit successivo. Chi scrive la riga di coda vede il
valore giusto guardando `HEAD` e lo usa **anche come pin del file**, e la riga
muore. 🔴 **Regola:** quando un file contiene il proprio pin, servono **due**
pin, e vanno verificati **separatamente** con `git show <pin>:<file> | grep PIN`.
**Costo evitato qui:** un round buttato alla prima notte.

### 241. 🤖 IL CANCELLO INCROCIA PIN x PERCORSI x MARCATORI **SENZA APPAIARLI** (11/09/2026)
`controlla_riga.py` r.541-563: con **due** file scaricati e **due** marcatori
costruisce il prodotto cartesiano e **blocca** sulle 2 coppie sbagliate, anche
quando la riga e' giusta. Misurato: la versione unica del passo 1 usciva
`BLOCCANTI (4)` tutti di classe 187, **tutti falsi**. 🟢 **Correzione applicata
oggi senza toccare lo strumento**: una riga = **un** file scaricato = **un**
marcatore. E' anche piu' leggibile. **Da sistemare nello strumento**: appaiare
marcatore e percorso per posizione nella riga.

### 242. 📋 IL CANCELLO NON HA UN OGGETTO PER LA **RIGA DI CODA** (11/09/2026)
Una riga `<pin> | <percorso> | <argomenti>` non e' PowerShell, ma
`esegue_uno_script()` la classifica come tale (contiene `.ps1`) e pretende un
`irm` e un `Select-String -Pattern MARCATORE` che li' **non possono esistere**:
il marcatore lo controlla il **runner**, dopo. Esito: `FAIL` su una riga
corretta. 🔴 **Serve `--oggetto coda`**: pin nel primo campo, percorso dentro
`backtest_pipeline/righe/`, argomenti passati da G4. Finche' non c'e', una riga
di coda si verifica **con i cancelli del runner eseguiti**, e lo si **dichiara**.

### 243. 🔎 IL COLLAUDO CHE LEGGE UN FILE **DAL DISCO** E NON DICE DI AVERLO PERSO (11/09/2026)
`-CollaudoCancelli` PARTE 4 legge `$PSScriptRoot\righe\RIGA_SOTTILE_ROUND.ps1`.
Se manca stampa `47 giusti, 1 sbagliati su 48` — un numero **plausibile**, che
chi si aspetta "circa 50" puo' leggere come "quasi tutto bene". 🟢 L'uscita e'
`1` (misurata), quindi la macchina se ne accorge; **l'occhio no**. Per questo la
riga 1B non guarda "circa 50": cerca la **stringa esatta**
`COLLAUDO: 50 giusti, 0 sbagliati su 50` **e** `ExitCode -eq 0`.

---

## 🧪 IL CONTRO-ESEMPIO, costruito prima della consegna (regola del 10/09)
Non mi sono limitato a far girare la cosa e vedere che tornava. Ho costruito i
casi che l'avrebbero fatta sbagliare:

| contro-esempio | ipotesi alternativa che doveva rompere | esito misurato |
|---|---|---|
| collaudo con la riga sottile presa da **`a895dbc`** (pin segnaposto) | *"tanto 50/50 dimostra che la riga di coda va bene"* | 🔴 **50/50 LO STESSO.** Il collaudo e' **cieco** al pin interno: e' testuale. 👉 **Il 50/50 NON dimostra che la riga di coda e' pinnata bene.** Sono due prove diverse e servono tutte e due |
| collaudo **senza** la cartella `righe\` | *"il collaudo e' autoconsistente"* | 🔴 `47 su 48`, uscita 1 |
| riga sottile col banco **riassegnato** a `D:\MT5_Altro` | *"G3 se ne accorge?"* | 🟢 `G3: riga 267 nomina un terminale senza puntare al banco` |
| riga sottile col banco cambiato nel **100k** | *"G2 vede la cartella `-V3`?"* | 🟢 `G2: riga 131 contiene 'MT5 Terminal -V3'` |
| argomenti che nominano `C:\BCM_Reale` | *"G4 e' decorativo?"* | 🟢 `G4: … tocca il terminale del CONTO REALE 10105439` |
| la riga di coda data ai cancelli della **v2** | *"tanto la v2 la esegue lo stesso"* | 🟢 `ok=False — G1: manca il marcatore 'RUNNER_SOLA_LETTURA'` |
| le due righe del passo 1 **eseguite davvero** (pwsh, con `powershell.exe`→`pwsh` e i percorsi sostituiti) | *"la riga e' sintatticamente giusta ma non gira"* | 🟢 girate fino in fondo: `50 giusti`, `CODICE DI USCITA: 0`, zip creato |

---

## 🚫 NON COPERTO — quello che NON ho potuto verificare, e perche'
1. 🔴 **Windows PowerShell 5.1.** Qui gira `pwsh 7.4.6` su **Linux**. Le righe
   sono ASCII pure e passano il **parser** PowerShell con 0 errori, ma
   `schtasks`, `Get-FileHash` su percorsi `C:\`, `Start-Process -NoNewWindow` e
   il comportamento di `cmd /c` su **stderr** li ho letti, non provati. **E' il
   motivo per cui il passo 1 esiste separato e il passo 2 salva l'XML.**
2. 🔴 **`-Installa` non l'ho mai eseguito.** Nessuno l'ha eseguito nella v3. Il
   commento nel file lo ammette da solo: la correzione dello `schtasks /Delete`
   e' *"una IPOTESI ben motivata, non una riparazione dimostrata"*.
3. 🟠 **Il runner aspetta il figlio SENZA TIMEOUT** (`Start-Process … -Wait`,
   r.774, nessun `-Timeout`). Se il tester si pianta, il runner resta appeso e
   l'attivita' `DAILY` la notte dopo ne avvia **una seconda**. Non e' un difetto
   introdotto oggi, ma con la corsia ROUND diventa **raggiungibile**, perche' ora
   il figlio apre MT5. **Da sistemare prima di mettere sei righe in coda.**
4. 🟠 **Il codice MQL5 NON e' pinnato.** `walkforward_generico.ps1` ha
   `$EABranch="lavoro"` cablato: l'EA e gli include arrivano dalla **testa del
   branch** al momento della corsa. E `ABTG_PausaGuardian.mqh` e' stato toccato
   il **07/09** con un commit intitolato *"LAVORO IN CORSO -- tetto cluster C2
   collegato, SPENTO di default"*. `R125d` gira con **`InpUsaGuardian=1`**.
   👉 Il round girera' su **quella** versione. Non e' bloccante (il round e' una
   misura e il referto dice cosa ha girato), ma i numeri **non sono
   automaticamente confrontabili** con R88, che giro' con un Guardian di prima.
   **Va scritto nel referto del round, non scoperto dopo.**
5. 🟠 **Nessuno verifica che in `C:\MT5_Backtest` ci sia il conto 50504400.** La
   guardia controlla il **percorso**, non il **conto**. Il legame
   cartella↔conto e' misurato dal giornale (`CODA_03`, 11/09: cartella dati
   `04C7A32B…`, `CONTO 50504400`, HEDGING), quindi oggi e' vero — ma e' una
   **misura di ieri notte**, non un controllo dentro la riga.
6. 🟠 **Lo `stderr` del round non viene pubblicato.** Il runner pubblica solo
   `*.log`; il file degli errori si chiama `<nome>.log.err` e **non e' preso dal
   filtro**. Se il round morisse su un errore di PowerShell, il messaggio
   resterebbe solo sul VPS. La riga **3C** lo recupera dal Desktop: **per questo
   3C non e' facoltativa.**
7. 🟠 **Non ho misurato quanto ci mette il round.** `~0,4 minuti` sono il
   **tester**; compilazione dell'EA e avvio di MT5 su un'installazione nuova
   **non sono quotati**. Stima onesta: **sotto i 10 minuti**, ma e' una stima.
8. 🟢 **Non ho toccato niente**: nessun commit, nessun preset, nessun EA, nessun
   forward, nessun conto. `git status` resta pulito.

---

## ✅ IL VERDETTO

> ## 🟢 **PASS — si manda**, con **due condizioni scritte, non facoltative**:
> 1. **la riga di coda usa il pin `e8b937f7…`, NON `a895dbc…`** (difetto
>    bloccante trovato e corretto: ad `a895dbc` il file ha ancora il segnaposto);
> 2. **il passo 1 e' un cancello vero**: se sul VPS non esce
>    `50 giusti, 0 sbagliati su 50` con uscita 0, **ci si ferma li'**.

**E il motivo per cui NON dico "oggi non si manda niente":** ogni passo o non
tocca il sistema (1), o si porta dietro il proprio paracadute (2A prima di 2B),
o viene **rifiutato dai cancelli** se arriva fuori ordine (3 senza 2, misurato).
Il pezzo davvero non provato — Windows PowerShell 5.1 — e' **esattamente quello
che il passo 1 va a provare, a secco, prima di toccare qualunque cosa**.

🎯 **E la bussola:** questo pacchetto e' **ponteggio**, e va detto. Non schiera
nessuna sedia. Quello che compra e' concreto: da domani mattina il VPS puo'
girare i round **da solo**, e il primo che gira e' la **prima misura in assoluto
del lato short del DAX** — una casella del certificato che oggi e' vuota, su una
famiglia che deve essere schierabile il **1 ottobre**. 💪
