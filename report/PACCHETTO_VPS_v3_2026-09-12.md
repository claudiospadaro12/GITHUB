# 🖥️ PACCHETTO VPS v3 — 12/09/2026

> ⚠️ **SOSTITUISCE la v2 (e la v1 dell'11/09).** Non per capriccio: la v2
> e' stata **BOCCIATA dal cancello di giudizio** con **due difetti
> bloccanti**, e tutti e due sarebbero costati una notte. Sono chiusi qui.
>
> 🟢 **E la notizia buona e' proprio questa**: il cancello ha funzionato. Uno
> dei due difetti **l'avevo creato io** poche ore prima, ed e' stato preso
> **prima** che la riga arrivasse a Claudio.

---

## 0. 🔄 AGGIORNAMENTO PIN (ultimo giro, e il motivo e' scritto)

⚠️ **I pin di questo documento sono stati rinfrescati dopo il rivaglio.**
Il file resta questo — **un indirizzo, non una collezione** — e le righe qui
sotto sono gia' quelle giuste.

Perche' sono cambiati **ancora** (settimo giro in una notte, e ogni giro ha
un motivo, non un capriccio):
1. 🔴 **classe 243**: `RIGA_DIAG_GBPUSD` ha una guardia che verifica che il
   driver **al pin** dichiari gli argomenti che sta per passargli. Ho aggiunto
   `-FinoDallaRiga` alla riga **e non alla lista**: con un pin vecchio la
   guardia passava, il driver partiva senza conoscere lo switch e moriva con
   un errore grezzo che manda a cercare il guasto **nella rete invece che nel
   pin** — cioe' il danno che quella guardia esisteva per prevenire.
2. 📎 Dentro i byte **inchiodati** c'era una **frase falsa**: il commento del
   driver diceva che il banner *"si RIPETE piu' sotto"*. **Non si ripete.**
   🔴 **L'impronta garantisce i byte, non la verita' di quello che ci sta
   scritto**: quindi si ricontrolla anche la prosa, non solo l'hash.

📋 Le **4 righe in coda** sono state riscritte col pin nuovo, committate e
pushate. Non c'e' niente da fare a mano.

---

## 1. 🔴 I DUE BLOCCANTI CHE LA v2 AVEVA, e come sono chiusi

### 🔴 (1) La RIGA 3B dava il verdetto ROSSO **con tutto perfetto**
La riga controllava `righe accettate in corsia ROUND **= 1**`, ma la coda di
stanotte ne ha **QUATTRO**. Era un numero **copiato** dal pacchetto di ieri,
quando la coda era di una riga sola — e la prosa due centimetri sotto diceva
gia' *"attese 4"*. **Codice e prosa si contraddicevano, e aveva torto il
codice.**
👉 Cosi' com'era, con tutto a posto avrebbe stampato *"NON E' QUELLO CHE MI
ASPETTO — TOGLI le righe"*, e **la notte si perdeva per un numero copiato**.
✅ Adesso la soglia sta in **una variabile sola in cima** (`$ATTESE=4`), e la
riga stampa **anche** le righe di sola lettura, cosi' un rifiuto si vede
subito.

### 🔴 (2) La mia guardia su `@FINOA` **armava una mina**
Ieri notte ho chiuso il buco per cui il tag `@FINOA` (la data di FINE della
finestra) veniva letto e **mai usato**, e ho scritto che il danno era
**ZERO**. **Era FALSO**, e il difetto e' nel mio metodo, non nel codice:

> avevo censito i **FILE PROVA** con `@FINOA` diverso dal default. Ma la
> contraddizione si crea da **DUE lati**, e il secondo e' **il CHIAMANTE che
> passa `-Fino` apposta**. Quel lato non l'ho guardato.

Il caso vero, **unico su tutto il repo**: `RIGA_DIAG_GBPUSD.ps1 -Passo C`
passa `-Fino 2013.01.01` su un file prova che dichiara `@FINOA 2026.06.30`,
**di proposito**, e lo mette agli atti nel suo stesso codice (*"qui si misura
un TEMPO, non un orologio"*). Con la mia guardia, **da oggi quel passo
moriva**.

✅ **Riparato senza ammorbidire la guardia**: interruttore **`-FinoDallaRiga`**.
Senza, due date diverse fanno **morire** la corsa come prima. Con, la riga di
lancio vince **ma il driver stampa un banner largo** che dice *"i numeri che
escono NON descrivono la cella del file prova"*. **Intento dichiarato da tutte
e due le parti**: chi lancia lo scrive, il driver lo grida.

📌 **E' esattamente la regola del 10/09**: *avevo controllato che la mia
risposta fosse COERENTE con quello che mi aspettavo, invece di provare a
ROMPERLA.*

---

## 2. ✅ QUELLO CHE IL CANCELLO HA PROVATO A ROMPERE E **NON SI E' ROTTO**

Non l'ha letto: l'ha **eseguito**.
- **Catena dei due pin** ricalcolata da zero, sia da `git` sia **via HTTP**
  sugli URL veri: **quattro impronte al byte, `http=200` su tutto**. E
  nessun `.gitattributes` nel repo → nessuna riscrittura CRLF che possa far
  divergere `Get-FileHash` sul VPS.
- **I cancelli G1-G4 fatti GIRARE** (non letti): `VagliaScript` sulla riga
  sottile → `ok=True, corsia=ROUND`; `VagliaArgomenti` su **tutte e quattro**
  le righe di coda → `G4 passato` ×4; collaudo completo → **50 su 50, uscita 0**.
- **`-Deposito` non e' invertito**: R133b = **100000** (confermato dalla cella
  di riferimento), gli altri tre 10000.
- **Il perimetro e' chiuso a chiave**: confronto **ordinale** contro
  `C:\MT5_Backtest`, lista nera su `BCM_Reale` / `-V3` / i tre numeri di
  conto, rifiuto di radici di disco, nomi 8.3 e junction. Gli argomenti non
  possono nemmeno **nominare** un percorso (lista bianca `^[A-Za-z0-9_.-]+$`).
  🔒 **Nessuna riga puo' finire sul piccolo, sul 100k o sul reale.**
- **Le ore sono tutte ORA SERVER** (R133a `InpSessionHour=14`, non 15).
- **I 7 assi enum non esplodono**: 8+7+2+9 celle → **52 passate**. Torna.
- **Tutti i 336 parametri** dei sei file prova esistono come `input` nel loro
  EA, e i magic non collidono con nessuna sedia viva.

---

## 3. 📌 LE CORREZIONI AI MIEI NUMERI (segnalate dal cancello)

| avevo scritto | il numero vero |
|---|---|
| *"10 CSV `_ohlc` in `risultati_archivio/r82_csv/`"* | **14**, e il percorso e' `backtest_pipeline/risultati_archivio/r82_csv/` (**328** in tutto il repo) |
| *"111 file prova con `@FINOA`"* | **112** |
| *"`@FINOA`: danno misurato ZERO"* | 🔴 **danno UNO, ed e' dichiarato** (vedi §1.2) |

La **sostanza** del contro-esempio regge — il suffisso `_ohlc` spara davvero,
e i CSV R123D non ce l'hanno — **ma il numero citato non era quello misurato**,
e su un contro-esempio e' proprio il numero che deve reggere.

---

## 4. ✅ LA CATENA, VERIFICATA DAGLI URL VERI

```
PIN ESTERNO 8027068f97c0e35dce6970fe15d958c410678725
  RIGA_SOTTILE_ROUND.ps1    http=200  A91B148414D9960229FA9EF9284E8570B34CC6C6D48074880321574EE8F8D20E
  runner_abtg.ps1           http=200  21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631
PIN INTERNO 9cba7a1000b97b346c8028cf43e3c3e1c8529dc2   <-- letto DENTRO i byte scaricati
  RIGA_ROUND_VPS.ps1        http=200  348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B
  walkforward_generico.ps1  http=200  02E2FE8F90CCBD079E92A7A6C74B54D96C536982927BEC06AE68ECFB9ECF3FEA
  i sei file prova          http=200 x6
```

**Due pin, due mestieri**: l'**esterno** inchioda **QUALE FILE** si scarica;
l'**interno**, scritto dentro quel file, inchioda **CHE COSA scarica LUI**.

---

## 5. 🚦 I PASSI. Il primo non tocca niente.

### PASSO 1 — COLLAUDO A SECCO
**RIGA 1A** — scarica il runner v3 e ne verifica impronta e marcatore:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $d=Join-Path $env:USERPROFILE 'abtg_collaudo'; Remove-Item -LiteralPath $d -Recurse -Force -EA SilentlyContinue; New-Item -ItemType Directory -Force -Path (Join-Path $d 'righe') | Out-Null; $r=Join-Path $d 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/8027068f97c0e35dce6970fe15d958c410678725/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA sul runner: ' + $h + ' -- NON PROSEGUIRE') }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'RUNNER VECCHIO: manca MARCATORE_RUNNER_ABTG_v3 -- NON PROSEGUIRE' }; Write-Host ('runner v3 scaricato e verificato: ' + $r) -ForegroundColor Green; Write-Host 'impronta SHA-256 uguale . marcatore MARCATORE_RUNNER_ABTG_v3 presente' -ForegroundColor Green; Write-Host 'ADESSO INCOLLA LA RIGA 1B.' -ForegroundColor Cyan }
```
**RIGA 1B** — scarica la riga sottile e fa girare il collaudo dei cancelli:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $d=Join-Path $env:USERPROFILE 'abtg_collaudo'; $r=Join-Path $d 'runner_abtg.ps1'; if(-not (Test-Path -LiteralPath $r -PathType Leaf)){ throw 'MANCA IL RUNNER: lancia prima la RIGA 1A' }; $s=Join-Path (Join-Path $d 'righe') 'RIGA_SOTTILE_ROUND.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/8027068f97c0e35dce6970fe15d958c410678725/backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1" -OutFile $s -EA Stop; $h=(Get-FileHash -LiteralPath $s -Algorithm SHA256).Hash; if($h -ne 'A91B148414D9960229FA9EF9284E8570B34CC6C6D48074880321574EE8F8D20E'){ throw ('IMPRONTA DIVERSA sulla riga sottile: ' + $h + ' -- NON PROSEGUIRE') }; if(-not (Select-String -LiteralPath $s -SimpleMatch -Pattern 'MARCATORE_RIGA_SOTTILE_ROUND_v1' -Quiet)){ throw 'RIGA SOTTILE VECCHIA: manca MARCATORE_RIGA_SOTTILE_ROUND_v1 -- NON PROSEGUIRE' }; Write-Host 'riga sottile scaricata: impronta uguale, marcatore presente' -ForegroundColor Green; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('COLLAUDO_CANCELLI_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $log=Join-Path $cart 'collaudo.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-CollaudoCancelli') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'collaudo_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ''; Write-Host ('CODICE DI USCITA DEL COLLAUDO: ' + $p.ExitCode); $n=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'COLLAUDO: 50 giusti, 0 sbagliati su 50').Count; if($p.ExitCode -eq 0 -and $n -eq 1){ Write-Host 'ESITO: 50 SU 50 -- SI PUO PASSARE AL PASSO 2' -ForegroundColor Green } else { Write-Host 'ESITO: NON E 50 SU 50 -- FERMATI QUI, MANDA LO ZIP, NON FARE IL PASSO 2' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
📋 **Deve tornare:** `COLLAUDO: 50 giusti, 0 sbagliati su 50` e
`CODICE DI USCITA DEL COLLAUDO: 0`.
🔴 **Qualunque altro numero: ci si ferma qui.**

### PASSO 2 — L'INSTALLAZIONE DEL RUNNER v3
**RIGA 2A** — la foto di com'e' adesso, **e il modo di tornare indietro**:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('PRIMA_DI_INSTALLARE_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $rif=Join-Path $cart 'runner_v3_dal_pin.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/8027068f97c0e35dce6970fe15d958c410678725/backtest_pipeline/runner_abtg.ps1" -OutFile $rif -EA Stop; $hRif=(Get-FileHash -LiteralPath $rif -Algorithm SHA256).Hash; if($hRif -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA sul runner del pin: ' + $hRif) }; if(-not (Select-String -LiteralPath $rif -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'IL FILE DEL PIN NON E LA v3 -- NON PROSEGUIRE' }; Write-Host ('riferimento v3 dal pin: impronta ' + $hRif) -ForegroundColor Green; Write-Host '=== I TERMINALI MT5 VIVI ADESSO (PID + titolo + cartella programma) ===' -ForegroundColor Cyan; $t=@(Get-Process -Name terminal64 -EA SilentlyContinue | Select-Object Id, MainWindowTitle, Path); if($t.Count -eq 0){ Write-Host '  nessun terminal64 in esecuzione' } else { $t | Format-List }; $t | Out-File -LiteralPath (Join-Path $cart 'terminali_vivi.txt') -Encoding ASCII; Write-Host '=== IL RUNNER GIA INSTALLATO SUL VPS ===' -ForegroundColor Cyan; $inst='C:\ABTG\runner_abtg.ps1'; if(Test-Path -LiteralPath $inst -PathType Leaf){ $hIns=(Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash; Write-Host ('  file     : ' + $inst); Write-Host ('  data     : ' + (Get-Item -LiteralPath $inst).LastWriteTime); Write-Host ('  impronta : ' + $hIns); if($hIns -eq $hRif){ Write-Host '  VERDETTO : GIA AGGIORNATO alla v3 -- il PASSO 2B non serve' -ForegroundColor Green } else { Write-Host '  VERDETTO : DIVERSO dalla v3 del pin -- e la copia VECCHIA che gira alle 03:30' -ForegroundColor Yellow }; Write-Host ('  ha il marcatore v3: ' + (Select-String -LiteralPath $inst -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)); Copy-Item -LiteralPath $inst -Destination (Join-Path $cart 'runner_INSTALLATO_PRIMA.ps1') -Force } else { Write-Host ('  NON INSTALLATO: non trovo ' + $inst) -ForegroundColor Yellow }; Write-Host "=== L ATTIVITA PIANIFICATA ADESSO ===" -ForegroundColor Cyan; cmd /c 'schtasks /Query /TN ABTG_Runner /V /FO LIST 2>&1' | ForEach-Object { Write-Host ('  ' + $_) }; cmd /c 'schtasks /Query /TN ABTG_Runner /XML 2>&1' | Out-File -LiteralPath (Join-Path $cart 'ABTG_Runner_COME_E_ADESSO.xml') -Encoding ASCII; Write-Host ''; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan; Write-Host ('MODO DI TORNARE INDIETRO SALVATO: ' + (Join-Path $cart 'ABTG_Runner_COME_E_ADESSO.xml')) -ForegroundColor Green }
```
**RIGA 2B** — l'installazione vera:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('INSTALLA_RUNNER_V3_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $r=Join-Path $cart 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/8027068f97c0e35dce6970fe15d958c410678725/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $atteso='21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne $atteso){ throw ('IMPRONTA DIVERSA: ' + $h + ' -- NON INSTALLO NIENTE') }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'NON E LA v3 -- NON INSTALLO NIENTE' }; Write-Host 'runner v3: impronta uguale, marcatore presente' -ForegroundColor Green; $log=Join-Path $cart 'installazione.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-Installa') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'installazione_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ('CODICE DI USCITA: ' + $p.ExitCode); Write-Host '=== VERIFICA SULL ARTEFATTO, non sul codice di uscita ===' -ForegroundColor Cyan; $inst='C:\ABTG\runner_abtg.ps1'; $okFile=$false; if(Test-Path -LiteralPath $inst -PathType Leaf){ $hi=(Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash; Write-Host ('  installato: ' + $inst); Write-Host ('  impronta  : ' + $hi); $okFile = ($hi -eq $atteso); Write-Host ('  uguale alla v3 del pin: ' + $okFile) -ForegroundColor $(if($okFile){'Green'}else{'Red'}) } else { Write-Host ('  NON TROVO ' + $inst) -ForegroundColor Red }; $q=@(cmd /c 'schtasks /Query /TN ABTG_Runner /V /FO LIST 2>&1'); $q | ForEach-Object { Write-Host ('  ' + $_) }; $q | Out-File -LiteralPath (Join-Path $cart 'attivita_dopo.txt') -Encoding ASCII; $okTask=@($q | Where-Object { $_ -match 'ABTG_Runner' }).Count -gt 0; Write-Host ("  attivita' ABTG_Runner ritrovata: " + $okTask) -ForegroundColor $(if($okTask){'Green'}else{'Red'}); if($okFile -and $okTask){ Write-Host 'ESITO: RUNNER v3 INSTALLATO E ATTIVITA VIVA -- si puo passare al PASSO 3' -ForegroundColor Green } else { Write-Host 'ESITO: INSTALLAZIONE NON DIMOSTRATA -- RIMETTI IL VECCHIO (vedi COME SI TORNA INDIETRO) E MANDAMI LO ZIP' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
📋 Deve tornare `uguale alla v3 del pin: True` e
`attivita' ABTG_Runner ritrovata: True`.

### PASSO 3 — LA CODA
🟢 **Le quattro righe sono GIA' IN CODA**, committate e pushate su `lavoro`:
non c'e' niente da incollare a mano in `CODA.txt`. (Il runner la coda la
prende dalla **testa del branch**, non dal pin: per questo dovevano essere
pushate **prima**.)
⚠️ **Si AGGIUNGONO alle 10 righe di sola lettura**, non le sostituiscono.

**RIGA 3B** — vaglia la coda **senza eseguire niente**:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $ATTESE=4; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('CODA_A_VUOTO_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $r=Join-Path $cart 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/8027068f97c0e35dce6970fe15d958c410678725/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA: ' + $h) }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'NON E LA v3 -- NON PROSEGUIRE' }; Write-Host 'runner v3 verificato. Adesso VAGLIO la coda SENZA eseguire niente.' -ForegroundColor Green; $log=Join-Path $cart 'coda_a_vuoto.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-SoloControllo','-NonPubblicare') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'coda_a_vuoto_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ('CODICE DI USCITA: ' + $p.ExitCode); $rif=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'RIFIUTATO').Count; $rnd=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'corsia  : ROUND').Count; $let=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'corsia  : LETTURA').Count; Write-Host ('righe RIFIUTATE: ' + $rif + '   accettate in corsia ROUND: ' + $rnd + ' (attese ' + $ATTESE + ')   in corsia LETTURA: ' + $let); if($rif -eq 0 -and $rnd -eq $ATTESE){ Write-Host ('ESITO: le ' + $ATTESE + ' righe di round passano i cancelli e NON sono state eseguite. Stanotte alle 03:30 girano.') -ForegroundColor Green } else { Write-Host 'ESITO: NON E QUELLO CHE MI ASPETTO -- mandami lo zip e TOGLI le righe di round dalla coda' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
📋 Deve dire **`righe RIFIUTATE: 0`** · **`ROUND: 4 (attese 4)`** ·
**`LETTURA: 10`**.

### LA MATTINA — la raccolta
```powershell
& { $ErrorActionPreference='Stop'; $ieri=(Get-Date).Date.AddDays(-1); $ett=@('r132c','r133a','r133b','r133c'); $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('ROUND_NOTTE_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; foreach($e in $ett){ Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_round\risultati_prove') -Recurse -Include ('*' + $e + '*.csv') -EA SilentlyContinue | Copy-Item -Destination $cart -Force -EA SilentlyContinue; $rd=Join-Path ([Environment]::GetFolderPath('Desktop')) ('ROUND_' + $e); if(Test-Path -LiteralPath $rd){ Get-ChildItem -LiteralPath $rd -File -EA SilentlyContinue | Copy-Item -Destination $cart -Force -EA SilentlyContinue } }; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_sottile') -File -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $ieri } | Copy-Item -Destination $cart -Force -EA SilentlyContinue; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_runner') -File -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $ieri } | Copy-Item -Destination $cart -Force -EA SilentlyContinue; $nc=@(Get-ChildItem -LiteralPath $cart -File -Filter '*.csv' -EA SilentlyContinue).Count; $nu=@(Get-ChildItem -LiteralPath $cart -File -Filter 'REFERTO_RUNNER_*.txt' -EA SilentlyContinue).Count; Write-Host ('CSV raccolti         : ' + $nc + ' su 8 attesi (IS e OOS per r132c r133a r133b r133c)') -ForegroundColor Cyan; foreach($e in $ett){ $n=@(Get-ChildItem -LiteralPath $cart -File -Filter ('REFERTO_ROUND_' + $e + '.txt') -EA SilentlyContinue).Count; Write-Host ('REFERTO_ROUND_' + $e + '.txt : ' + $n + ' su 1 atteso') -ForegroundColor Cyan }; Write-Host ('REFERTO_RUNNER_*.txt : ' + $nu + ' su 1 atteso') -ForegroundColor Cyan; if($nc -lt 8){ Write-Host 'ATTENZIONE: mancano dei CSV -- la notte e MONCA. Manda lo zip lo stesso e dillo.' -ForegroundColor Yellow }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length, LastWriteTime | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Green }
```
📋 **8 CSV attesi**, 4 `REFERTO_ROUND_*`, 1 `REFERTO_RUNNER_*`.
🔴 **Un round monco si manda lo stesso e si dice che e' monco.**

---

## 6. 🧮 I QUATTRO ROUND, E PERCHE' R132a/b RESTANO FUORI

| etichetta | che cosa misura | passate |
|---|---|---:|
| **r132c** | il pavimento dello stop sul Dow — 🔑 **e' un CANCELLO DI DETERMINISMO**: 5 celle su 8 sono gia' girate in R123D, **devono tornare identiche cifra per cifra** | 16 |
| **r133b** | un filtro **scritto e mai eseguito** — 52 gruppi su 52 morti | 4 |
| **r133a** | `InpLevelTF` — **mai ad asse in 0 CSV su 2.083** | 14 |
| **r133c** | `InpMinBoxPts` — 18/18 identici, scala fuori range di **10x** | 18 |

**52 passate, ~4-5 minuti.**

⚠️ **DA DIRE ADESSO, non dopo aver letto i numeri (rilievo del cancello):**
**R133b misura DUE cose insieme.** L'asse e' `InpUseCloseConfirm`, e
accenderlo cambia **anche il meccanismo di ingresso** (pendenti STOP →
conferma di chiusura), non solo il filtro volumi. Il disegno e' corretto —
e' **l'unico modo** di raggiungere quel filtro — ma **la differenza fra le
due celle NON e' attribuibile al solo filtro volumi**, e il referto dovra'
dirlo.

🔴 **R132a e R132b non sono in coda**, ed e' una regola loro: R132c ordina in
testa a se' stesso che gli altri due **non partano** finche' non ha
riprodotto. Il runner la coda la esegue tutta senza fermarsi: **il cancello
lo legge una persona, sui CSV.**

---

## 7. 🌙 PRIMA DI DORMIRE — una cosa sola, col numero di conto

🔴 **Il terminale del banco dev'essere CHIUSO**, se no il round muore con
uscita 1 e non produce niente.

| | |
|---|---|
| **conto da chiudere** | **50504400** — demo **solo tester**, zero EA attaccati |
| **cartella programma** | `C:\MT5_Backtest` |
| **NON si toccano** | **50503392** · **50504263** · **10105439** |

E il riconoscimento **non si fa a occhio**: questa riga di sola lettura
stampa PID + titolo + cartella.
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-List
```

---

## 8. 🕳️ BUCHI DICHIARATI (dal cancello, e sono onesti)

1. 🔴 **Il codice MQL5 non e' al pin.** Il driver prende gli `.mq5` dalla
   **testa del branch** al momento della corsa, non dal pin. I quattro EA non
   cambiano dall'08/09, quindi il cancello di R132c regge **oggi**; se
   qualcuno tocca un EA prima delle 03:30, **nessuna impronta se ne accorge**.
   Il file lo dichiara da se', ma il buco resta aperto.
2. **Nessun giro a vuoto del ROUND.** R132c ordina *"prima SEMPRE con
   `-SoloControllo`"*, e nel pacchetto quel giro **non c'e'** (il
   `-SoloControllo` della 3B e' quello del *runner*, che vaglia la coda: e'
   un'altra cosa). Il conto celle e' stato verificato **a mano**, non dalla
   macchina.
3. **Il tester non e' stato eseguito.** PF, DD, n e la riproduzione cifra per
   cifra delle 5 celle R123D **non sono verificati**: e' verificato che
   *possono* riprodursi (stesso EA, stessa finestra, stesso modello, 38
   parametri su 41 identici — le 3 differenze sono inerti). **La misura e' la
   notte.**
4. **Le 10 righe di sola lettura**: passate dai cancelli (10/10 accettate in
   LETTURA), **non rilette una per una**.
5. **`RIGA_DIAG_GBPUSD.ps1` non e' in coda stanotte** e la sua riparazione e'
   fatta, ma **non provata in esecuzione**.

---

## 9. 🚦 CANCELLI SU QUESTO PACCHETTO
- `controlla_riga.py` su **tutte e sette** le righe PowerShell: **nessun
  difetto meccanico**, ASCII puro.
- `--oggetto ps1` su `RIGA_SOTTILE_ROUND.ps1`, `walkforward_generico.ps1` e
  `RIGA_DIAG_GBPUSD.ps1`: **nessun difetto meccanico**.
- Catena dei pin verificata **via HTTP**.
- 🔒 **Repo pubblico**: nel documento ci sono numeri di conto, cartelle,
  magic e **depositi del TESTER** (10000/100000 = parametri di simulazione).
  **Zero saldi, zero equity, zero P/L** del reale o del 109k.

---

*Pin esterno `8027068f97c0e35dce6970fe15d958c410678725` · pin interno `9cba7a1000b97b346c8028cf43e3c3e1c8529dc2`*
