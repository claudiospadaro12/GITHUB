# 🖥️ PACCHETTO VPS v2 — 12/09/2026

> ⚠️ **Questo file SOSTITUISCE `report/PACCHETTO_VPS_2026-09-11.md`.**
> Quello di ieri **non si lancia piu'**: la RIGA 1B morirebbe su
> *"IMPRONTA DIVERSA sulla riga sottile"*. Non e' un guasto — e' il
> sistema che funziona: la riga sottile e' cambiata due volte dopo che
> quel pacchetto era stato scritto, e l'impronta se ne accorge. Ma
> costerebbe a Claudio un giro a vuoto, quindi il pacchetto si rifa'.

---

## 1. 🔴 PERCHE' IL PACCHETTO DI IERI NON VA PIU'

| | ieri | oggi |
|---|---|---|
| pin **esterno** (quale FILE si scarica) | `e8b937f7…` | **`7b8a44f1…`** |
| impronta della riga sottile | `2DA274EE…` | **`79D7DFD5…`** |
| pin **interno** (che cosa scarica LEI) | `a895dbc…` poi `7991c562…` | **`c2b157c3…`** |
| impronta del driver `walkforward` | `6DB57DF1…` | **`0DFB3B23…`** |
| impronta di `RIGA_ROUND_VPS.ps1` | `348ED533…` | **`348ED533…` (INVARIATA)** |
| impronta del `runner_abtg.ps1` | `21AC6672…` | **`21AC6672…` (INVARIATA)** |

Due cose sono cambiate, e **una delle due era bloccante**:

### 🔴 (a) Senza il pin nuovo, R133 NON SI PUO' LANCIARE
La riga sottile passa `-Pin $PIN` al driver, e **il driver prende IL FILE
PROVA da quello stesso pin**. Al pin interno di ieri i tre file prova
`R133{a,b,c}` **non esistono** — sono stati scritti dopo. Verificato file
per file con `git cat-file -e`: tre volte *"MANCA"*.
👉 Lanciati cosi', i tre round R133 sarebbero morti sullo scarico del file
prova. Non un numero sbagliato: proprio niente.

### 🔴 (b) I tre file R132 dicevano `-Modello 1` scrivendoci accanto "TICK REALI"
**E' il contrario**: `walkforward_generico.ps1:172` documenta
*"4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai verdetti"*.
Corretto nel commit `1764a0e`. Lanciato com'era, **R132c avrebbe girato in
OHLC e il suo cancello di riproduzione sarebbe fallito PER COSTRUZIONE**,
annullando R132a e R132b insieme (i tre sono in cascata).

> 🧪 **Il contro-esempio che chiude la verifica.** Con `Modello != 4` il
> driver appende `_ohlc` al nome del CSV (`:1347`), e i due CSV di
> riferimento R123D **non ce l'hanno**. Ma l'assenza di un suffisso e'
> una prova solo se quel suffisso **spara davvero**: e spara — ci sono
> **10 CSV `_ohlc`** in `risultati_archivio/r82_csv/`. Senza quel secondo
> controllo, *"non c'e' `_ohlc`"* poteva voler dire solo *"quel pezzo di
> codice non ha mai funzionato"*.

### 🟡 (c) E per strada e' saltata fuori una terza cosa — piu' piccola di come sembrava
Il tag **`@FINOA`** (data di FINE della finestra) finiva nelle direttive
del driver generico **e poi non veniva MAI usato**. Sta in **111 file
prova**, **44** con una data diversa dal default.

🟢 **Danno misurato: ZERO, e non per fortuna.** Prima di gridare ho
cercato il contro-esempio e l'ho trovato: **la casa aveva gia' risolto
il 31/08**, in **32 script dedicati**. Ognuno dichiara il proprio `$Fino`,
lo passa al generico **e** gatta `@FINOA` del file prova contro quel
valore, con tanto di messaggio *"la finestra si dichiara nel prova, non si
eredita dal default del generico (classe 31/08)"*. Piu' `R113`, che il
generico non lo usa nemmeno: si scrive gli `.ini` da solo.

👉 Quello che ho chiuso e' **l'ULTIMA porta**: la **riga sottile**, nata
l'11/09, e' l'unico percorso che `-Fino` non lo passa. Da li' — e solo da
li' — un `@FINOA` sarebbe stato ignorato in silenzio.
Per i sei file prova di stanotte **non cambia niente**: dichiarano tutti
`@FINOA 2026.06.30`, identica al default. Verificato scaricandoli.

---

## 2. ✅ LA CATENA, VERIFICATA DAGLI URL VERI (non dal blob git)

Non basta che `git` sia contento: il VPS non parla con git, parla con
`raw.githubusercontent.com`. Quindi la verifica e' stata rifatta **dopo
l'ultimo byte**, sugli URL che il VPS colpira' davvero:

```
PIN ESTERNO 7b8a44f19b345a1d30f3a478271b6687fa5543d1
  RIGA_SOTTILE_ROUND.ps1    http=200  79D7DFD528A2AFA61C3723C3CC207A53ACF5E887EA81A3045854F3E108BF9770
  runner_abtg.ps1           http=200  21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631
PIN INTERNO c2b157c325811c44c359adf93104f9409450f3fc   <-- letto DENTRO i byte scaricati
  RIGA_ROUND_VPS.ps1        http=200  348ED5330C18DCD41D736B0709B880A8EC9BF8A4B700B044999BC7099D0A315B
  walkforward_generico.ps1  http=200  0DFB3B239D66BE3EC1D20C66782B3E7AAE8C601E815DFAAEA8B35F74D1185171
  R132a/b/c + R133a/b/c     http=200 x6, tutti con @FINOA 2026.06.30
```

**Due pin, due mestieri**, e non coincidono mai: quello **esterno**
inchioda **QUALE FILE** si scarica; quello **interno**, scritto dentro
quel file, inchioda **CHE COSA scarica LUI**.

---

## 3. 🚦 I PASSI. Il primo non tocca niente.

### PASSO 1 — COLLAUDO A SECCO (nessuna installazione, nessun MT5)
**RIGA 1A** — scarica il runner v3 e ne verifica impronta e marcatore:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $d=Join-Path $env:USERPROFILE 'abtg_collaudo'; Remove-Item -LiteralPath $d -Recurse -Force -EA SilentlyContinue; New-Item -ItemType Directory -Force -Path (Join-Path $d 'righe') | Out-Null; $r=Join-Path $d 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7b8a44f19b345a1d30f3a478271b6687fa5543d1/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA sul runner: ' + $h + ' -- NON PROSEGUIRE') }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'RUNNER VECCHIO: manca MARCATORE_RUNNER_ABTG_v3 -- NON PROSEGUIRE' }; Write-Host ('runner v3 scaricato e verificato: ' + $r) -ForegroundColor Green; Write-Host 'impronta SHA-256 uguale . marcatore MARCATORE_RUNNER_ABTG_v3 presente' -ForegroundColor Green; Write-Host 'ADESSO INCOLLA LA RIGA 1B.' -ForegroundColor Cyan }
```
**RIGA 1B** — scarica la riga sottile accanto e fa girare il collaudo dei cancelli:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $d=Join-Path $env:USERPROFILE 'abtg_collaudo'; $r=Join-Path $d 'runner_abtg.ps1'; if(-not (Test-Path -LiteralPath $r -PathType Leaf)){ throw 'MANCA IL RUNNER: lancia prima la RIGA 1A' }; $s=Join-Path (Join-Path $d 'righe') 'RIGA_SOTTILE_ROUND.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7b8a44f19b345a1d30f3a478271b6687fa5543d1/backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1" -OutFile $s -EA Stop; $h=(Get-FileHash -LiteralPath $s -Algorithm SHA256).Hash; if($h -ne '79D7DFD528A2AFA61C3723C3CC207A53ACF5E887EA81A3045854F3E108BF9770'){ throw ('IMPRONTA DIVERSA sulla riga sottile: ' + $h + ' -- NON PROSEGUIRE') }; if(-not (Select-String -LiteralPath $s -SimpleMatch -Pattern 'MARCATORE_RIGA_SOTTILE_ROUND_v1' -Quiet)){ throw 'RIGA SOTTILE VECCHIA: manca MARCATORE_RIGA_SOTTILE_ROUND_v1 -- NON PROSEGUIRE' }; Write-Host 'riga sottile scaricata: impronta uguale, marcatore presente' -ForegroundColor Green; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('COLLAUDO_CANCELLI_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $log=Join-Path $cart 'collaudo.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-CollaudoCancelli') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'collaudo_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ''; Write-Host ('CODICE DI USCITA DEL COLLAUDO: ' + $p.ExitCode); $n=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'COLLAUDO: 50 giusti, 0 sbagliati su 50').Count; if($p.ExitCode -eq 0 -and $n -eq 1){ Write-Host 'ESITO: 50 SU 50 -- SI PUO PASSARE AL PASSO 2' -ForegroundColor Green } else { Write-Host 'ESITO: NON E 50 SU 50 -- FERMATI QUI, MANDA LO ZIP, NON FARE IL PASSO 2' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
📋 **Deve tornare:** `COLLAUDO: 50 giusti, 0 sbagliati su 50` e
`CODICE DI USCITA DEL COLLAUDO: 0`, piu' lo zip.
🔴 **Qualunque altro numero: ci si ferma qui.** Niente passo 2.

### PASSO 2 — L'INSTALLAZIONE DEL RUNNER v3
**RIGA 2A** — la foto di com'e' adesso (e il modo di tornare indietro):
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('PRIMA_DI_INSTALLARE_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $rif=Join-Path $cart 'runner_v3_dal_pin.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7b8a44f19b345a1d30f3a478271b6687fa5543d1/backtest_pipeline/runner_abtg.ps1" -OutFile $rif -EA Stop; $hRif=(Get-FileHash -LiteralPath $rif -Algorithm SHA256).Hash; if($hRif -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA sul runner del pin: ' + $hRif) }; if(-not (Select-String -LiteralPath $rif -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'IL FILE DEL PIN NON E LA v3 -- NON PROSEGUIRE' }; Write-Host ('riferimento v3 dal pin: impronta ' + $hRif) -ForegroundColor Green; Write-Host '=== I TERMINALI MT5 VIVI ADESSO (PID + titolo + cartella programma) ===' -ForegroundColor Cyan; $t=@(Get-Process -Name terminal64 -EA SilentlyContinue | Select-Object Id, MainWindowTitle, Path); if($t.Count -eq 0){ Write-Host '  nessun terminal64 in esecuzione' } else { $t | Format-List }; $t | Out-File -LiteralPath (Join-Path $cart 'terminali_vivi.txt') -Encoding ASCII; Write-Host '=== IL RUNNER GIA INSTALLATO SUL VPS ===' -ForegroundColor Cyan; $inst='C:\ABTG\runner_abtg.ps1'; if(Test-Path -LiteralPath $inst -PathType Leaf){ $hIns=(Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash; Write-Host ('  file     : ' + $inst); Write-Host ('  data     : ' + (Get-Item -LiteralPath $inst).LastWriteTime); Write-Host ('  impronta : ' + $hIns); if($hIns -eq $hRif){ Write-Host '  VERDETTO : GIA AGGIORNATO alla v3 -- il PASSO 2B non serve' -ForegroundColor Green } else { Write-Host '  VERDETTO : DIVERSO dalla v3 del pin -- e la copia VECCHIA che gira alle 03:30' -ForegroundColor Yellow }; Write-Host ('  ha il marcatore v3: ' + (Select-String -LiteralPath $inst -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)); Copy-Item -LiteralPath $inst -Destination (Join-Path $cart 'runner_INSTALLATO_PRIMA.ps1') -Force } else { Write-Host ('  NON INSTALLATO: non trovo ' + $inst) -ForegroundColor Yellow }; Write-Host "=== L ATTIVITA PIANIFICATA ADESSO ===" -ForegroundColor Cyan; cmd /c 'schtasks /Query /TN ABTG_Runner /V /FO LIST 2>&1' | ForEach-Object { Write-Host ('  ' + $_) }; cmd /c 'schtasks /Query /TN ABTG_Runner /XML 2>&1' | Out-File -LiteralPath (Join-Path $cart 'ABTG_Runner_COME_E_ADESSO.xml') -Encoding ASCII; Write-Host ''; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan; Write-Host ('MODO DI TORNARE INDIETRO SALVATO: ' + (Join-Path $cart 'ABTG_Runner_COME_E_ADESSO.xml')) -ForegroundColor Green }
```
**RIGA 2B** — l'installazione vera:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('INSTALLA_RUNNER_V3_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $r=Join-Path $cart 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7b8a44f19b345a1d30f3a478271b6687fa5543d1/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $atteso='21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne $atteso){ throw ('IMPRONTA DIVERSA: ' + $h + ' -- NON INSTALLO NIENTE') }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'NON E LA v3 -- NON INSTALLO NIENTE' }; Write-Host 'runner v3: impronta uguale, marcatore presente' -ForegroundColor Green; $log=Join-Path $cart 'installazione.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-Installa') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'installazione_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ('CODICE DI USCITA: ' + $p.ExitCode); Write-Host '=== VERIFICA SULL ARTEFATTO, non sul codice di uscita ===' -ForegroundColor Cyan; $inst='C:\ABTG\runner_abtg.ps1'; $okFile=$false; if(Test-Path -LiteralPath $inst -PathType Leaf){ $hi=(Get-FileHash -LiteralPath $inst -Algorithm SHA256).Hash; Write-Host ('  installato: ' + $inst); Write-Host ('  impronta  : ' + $hi); $okFile = ($hi -eq $atteso); Write-Host ('  uguale alla v3 del pin: ' + $okFile) -ForegroundColor $(if($okFile){'Green'}else{'Red'}) } else { Write-Host ('  NON TROVO ' + $inst) -ForegroundColor Red }; $q=@(cmd /c 'schtasks /Query /TN ABTG_Runner /V /FO LIST 2>&1'); $q | ForEach-Object { Write-Host ('  ' + $_) }; $q | Out-File -LiteralPath (Join-Path $cart 'attivita_dopo.txt') -Encoding ASCII; $okTask=@($q | Where-Object { $_ -match 'ABTG_Runner' }).Count -gt 0; Write-Host ("  attivita' ABTG_Runner ritrovata: " + $okTask) -ForegroundColor $(if($okTask){'Green'}else{'Red'}); if($okFile -and $okTask){ Write-Host 'ESITO: RUNNER v3 INSTALLATO E ATTIVITA VIVA -- si puo passare al PASSO 3' -ForegroundColor Green } else { Write-Host 'ESITO: INSTALLAZIONE NON DIMOSTRATA -- RIMETTI IL VECCHIO (vedi COME SI TORNA INDIETRO) E MANDAMI LO ZIP' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
📋 Da 2B deve tornare `uguale alla v3 del pin: True` e
`attivita' ABTG_Runner ritrovata: True`.

### PASSO 3 — LA CODA DI STANOTTE
Le **quattro righe** da mettere in `backtest_pipeline/coda/CODA.txt`:
```
7b8a44f19b345a1d30f3a478271b6687fa5543d1 | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_SupRev_DOW_H1_Ottimizzato -Prova R132c_nearatr_U30USD.txt -Etichetta r132c -Modello 4 -Deposito 10000
7b8a44f19b345a1d30f3a478271b6687fa5543d1 | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_ORB_Ottimizzato -Prova R133b_filtrovolumi_U30USD.txt -Etichetta r133b -Modello 4 -Deposito 100000
7b8a44f19b345a1d30f3a478271b6687fa5543d1 | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_Nasdaq_Apertura_US -Prova R133a_livelliTF_NASUSD.txt -Etichetta r133a -Modello 4 -Deposito 10000
7b8a44f19b345a1d30f3a478271b6687fa5543d1 | backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1 | -Expert ABTG_MaxMinNotte -Prova R133c_ampiezzabox_D30EUR.txt -Etichetta r133c -Modello 4 -Deposito 10000
```
**RIGA 3B** — vaglia la coda **senza eseguire niente**:
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('CODA_A_VUOTO_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; $r=Join-Path $cart 'runner_abtg.ps1'; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7b8a44f19b345a1d30f3a478271b6687fa5543d1/backtest_pipeline/runner_abtg.ps1" -OutFile $r -EA Stop; $h=(Get-FileHash -LiteralPath $r -Algorithm SHA256).Hash; if($h -ne '21AC667285B49D631510AC9E84AF290299EEAA53270D7FE4CE389E7088006631'){ throw ('IMPRONTA DIVERSA: ' + $h) }; if(-not (Select-String -LiteralPath $r -SimpleMatch -Pattern 'MARCATORE_RUNNER_ABTG_v3' -Quiet)){ throw 'NON E LA v3 -- NON PROSEGUIRE' }; Write-Host 'runner v3 verificato. Adesso VAGLIO la coda SENZA eseguire niente.' -ForegroundColor Green; $log=Join-Path $cart 'coda_a_vuoto.txt'; $p=Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$r,'-SoloControllo','-NonPubblicare') -NoNewWindow -PassThru -Wait -RedirectStandardOutput $log -RedirectStandardError (Join-Path $cart 'coda_a_vuoto_errori.txt'); foreach($t in @(Get-Content -LiteralPath $log -EA SilentlyContinue)){ Write-Host $t }; Write-Host ('CODICE DI USCITA: ' + $p.ExitCode); $rif=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'RIFIUTATO').Count; $rnd=@(Select-String -LiteralPath $log -SimpleMatch -Pattern 'corsia  : ROUND').Count; Write-Host ('righe RIFIUTATE: ' + $rif + '   righe accettate in corsia ROUND: ' + $rnd); if($rif -eq 0 -and $rnd -eq 1){ Write-Host 'ESITO: la riga R125d passa i cancelli e NON e stata eseguita. Stanotte alle 03:30 girera.' -ForegroundColor Green } else { Write-Host 'ESITO: NON E QUELLO CHE MI ASPETTO -- mandami lo zip e NON lasciarla in coda' -ForegroundColor Red }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Cyan }
```
📋 Deve dire **`righe RIFIUTATE: 0`** e **`righe accettate in corsia ROUND: 4`**.

### LA MATTINA — la raccolta
```powershell
& { $ErrorActionPreference='Stop'; $ieri=(Get-Date).Date.AddDays(-1); $ett=@('r132c','r133a','r133b','r133c'); $cart=Join-Path ([Environment]::GetFolderPath('Desktop')) ('ROUND_NOTTE_' + (Get-Date -Format 'yyyyMMdd_HHmm')); New-Item -ItemType Directory -Force -Path $cart | Out-Null; foreach($e in $ett){ Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_round\risultati_prove') -Recurse -Include ('*' + $e + '*.csv') -EA SilentlyContinue | Copy-Item -Destination $cart -Force -EA SilentlyContinue; $rd=Join-Path ([Environment]::GetFolderPath('Desktop')) ('ROUND_' + $e); if(Test-Path -LiteralPath $rd){ Get-ChildItem -LiteralPath $rd -File -EA SilentlyContinue | Copy-Item -Destination $cart -Force -EA SilentlyContinue } }; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_sottile') -File -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $ieri } | Copy-Item -Destination $cart -Force -EA SilentlyContinue; Get-ChildItem -LiteralPath (Join-Path $env:USERPROFILE 'abtg_runner') -File -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $ieri } | Copy-Item -Destination $cart -Force -EA SilentlyContinue; $nc=@(Get-ChildItem -LiteralPath $cart -File -Filter '*.csv' -EA SilentlyContinue).Count; $nu=@(Get-ChildItem -LiteralPath $cart -File -Filter 'REFERTO_RUNNER_*.txt' -EA SilentlyContinue).Count; Write-Host ('CSV raccolti         : ' + $nc + ' su 8 attesi (IS e OOS per r132c r133a r133b r133c)') -ForegroundColor Cyan; foreach($e in $ett){ $n=@(Get-ChildItem -LiteralPath $cart -File -Filter ('REFERTO_ROUND_' + $e + '.txt') -EA SilentlyContinue).Count; Write-Host ('REFERTO_ROUND_' + $e + '.txt : ' + $n + ' su 1 atteso') -ForegroundColor Cyan }; Write-Host ('REFERTO_RUNNER_*.txt : ' + $nu + ' su 1 atteso') -ForegroundColor Cyan; if($nc -lt 8){ Write-Host 'ATTENZIONE: mancano dei CSV -- la notte e MONCA. Manda lo zip lo stesso e dillo.' -ForegroundColor Yellow }; Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length, LastWriteTime | Format-List; Compress-Archive -Path (Join-Path $cart '*') -DestinationPath ($cart + '.zip') -Force; Write-Host ('ZIP PRONTO DA MANDARE: ' + $cart + '.zip') -ForegroundColor Green }
```
📋 **8 CSV attesi** (IS e OOS per ciascuna delle quattro etichette), 4
`REFERTO_ROUND_*`, 1 `REFERTO_RUNNER_*`.
🔴 **Un round monco si manda lo stesso e si dice che e' monco.**

---

## 4. 🧮 PERCHE' QUESTI QUATTRO, E PERCHE' R132a/R132b RESTANO FUORI

| etichetta | che cosa misura | passate | perche' stanotte |
|---|---|---:|---|
| **r132c** | il pavimento dello stop sul Dow (`InpNearAtr`) | 16 | 🔑 **E' un CANCELLO DI DETERMINISMO**: cinque delle otto celle sono gia' girate in R123D, stesso binario. **Devono tornare identiche cifra per cifra.** Se non tornano, non si legge nient'altro |
| **r133b** | un filtro **scritto e mai eseguito** (`InpUseVolumeFilter`, chiuso a chiave da `InpUseCloseConfirm`) | 4 | 52 gruppi su 52 morti in archivio. Costa **20 secondi** |
| **r133a** | `InpLevelTF` — **mai messo ad asse in 0 CSV su 2.083** | 14 | ed e' l'unica cosa che decide i livelli su quella sedia |
| **r133c** | `InpMinBoxPts` — 18/18 identici, scala fuori range di **10x** | 18 | in piu' la colonna `Trades` lungo la scala **e'** la distribuzione dell'ampiezza del box |

**Totale 52 passate, ~4-5 minuti di tester** alla calibrazione di casa
(5,0 s/passata a tick reali).

🔴 **R132a e R132b NON entrano in coda stanotte, ed e' una regola loro, non
mia**: il file R132c dice *"QUESTO E' IL PRIMO FILE DA LANCIARE DEI TRE.
Costa 16 passate e, se il cancello qui sotto fallisce, gli altri due non
si lanciano."* Il runner la coda la esegue tutta senza fermarsi: il
cancello lo leggo io sui CSV. Quindi a/b partono **domani**, dopo che ho
verificato che le cinque celle si riproducono.

---

## 5. 🌙 PRIMA DI ANDARE A DORMIRE — una cosa sola, col numero di conto

🔴 **Il terminale del banco dev'essere CHIUSO.** La riga sottile **non
espone** `-ChiudiBacktest` (scelta dichiarata: *"un collaudo che uccide
processi non e' un collaudo"*): se quel terminale e' aperto il round
**muore con uscita 1** e non produce niente.

| | |
|---|---|
| **conto da chiudere** | **50504400** — demo **solo tester**, zero EA attaccati |
| **cartella programma** | `C:\MT5_Backtest` |
| **NON si toccano** | **50503392** (`BCM Markets MT5 Terminal`), **50504263** (`… -V3`), **10105439** (`C:\BCM_Reale`) |

E il riconoscimento **non si fa a occhio**: questa riga di sola lettura
stampa PID + titolo + cartella, cosi' e' un fatto stampato e non
un'inferenza:
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-List
```

---

## 6. 🛡️ E SE LE RIGHE FOSSERO INVERTITE?
Se la 1B arrivasse prima della 1A, muore con *"MANCA IL RUNNER"*. Se una
riga di coda finisse sul VPS con il **runner v2** ancora installato, la v2
la rifiuta al **primo cancello** (`G1: manca il marcatore
RUNNER_SOLA_LETTURA`): nessun round parte, nessun terminale viene toccato,
e la mattina il referto dice `RIFIUTATO` a chiare lettere.
🟢 **L'ordine sbagliato costa una notte, non un danno.**

---

## 7. 🚦 CANCELLI SU QUESTO PACCHETTO
- `controlla_riga.py` (deterministico) su **tutte e sei** le righe
  PowerShell: **nessun difetto meccanico** (5/5/6/5/5/2 controlli passati).
- `controlla_riga.py --oggetto ps1` su `RIGA_SOTTILE_ROUND.ps1` e su
  `walkforward_generico.ps1` dopo le modifiche: **4 passati ciascuno,
  ASCII puro compreso**.
- Catena dei pin verificata **via HTTP**, non solo via git (sezione 2).
- ⏳ Cancello di **giudizio** (agente `controllo-preventivo`): **in corso.**
  🔴 Finche' non torna PASS, **questo pacchetto non si lancia** — e' la
  regola del 09/09, e il 09/09 e' andata bene per fortuna, non per metodo.

---

*Pin esterno: `7b8a44f19b345a1d30f3a478271b6687fa5543d1` · pin interno: `c2b157c325811c44c359adf93104f9409450f3fc`*
