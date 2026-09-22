# 🧪 RIGA DA MANDARE — **R207B** · la meta' ALTA — 🔴 **si lancia DOPO R207A**

## 🖥️ BERSAGLIO: **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** — **MAI il VPS**

🔴 Pilota **il solo MT5 di quella macchina**: `C:\Program Files\BCM Markets MT5 Terminal`, **demo `50503392`** — che **dev'essere CHIUSO e senza EA attaccati**. La riga lo
controlla e si ferma se e' aperto: **non lo chiude lei**, perche' da quella macchina il 14/08
sono partiti ordini VERI.

🟢 **NON viene toccato** (sta tutto su un'altra macchina): challenge **FTMO `541452707`** (`C:\FTMO`, sei sedie che operano) · 100k `50504263` · **REALE `10105439`** · piccolo `50503392` del VPS · Pepperstone · Tickmill · banco `50504400`.

🔴 **CLASSE 582 — NON RIAPRIRE IL DEMO `50503392` MENTRE GIRA.** La riga controlla
che il terminale sia chiuso **adesso**, ma il ramo di emergenza scatta **fra 17 minuti**: se nel
frattempo lo riapri a mano, te lo chiude.

### 🗑️ Percorsi scritti e cancellati (classe 580)
`%USERPROFILE%\abtg_round` (creata) · `%USERPROFILE%\abtg_round\RIGA_ROUND_VPS.ps1` (riscaricato) · `Desktop\ROUND_R207B\` 🔴 **cancellata ricorsivamente** dal
driver · `Desktop\ROUND_R207B.zip` (rifatto).

### ⏱️ Il tetto: **17 minuti, e non e' un numero tondo** (classe 583)
4 passate x 16,5 s x 15 = **990 s = 16,5 min** → `$tmo=17`. La base e' **appaiata**:
`R172D`/`R201A` del 21/09, stessa macchina, stesso driver, **D30EUR M5 tick
reali**, 14 passate in **3 min 51 s**. 🔴 *(La base «~23 s di questa famiglia» che avevo usato
prima era di `ABTG_EMA200` su `U30USD` H1: altro EA, altro TF — classe 583.)*


---

## 🎯 CHE COSA MISURA
Stessa 2x2, ma col **breakeven indipendente ACCESO** (`InpBEatR=1,0`): 2 celle,
`ClosePct = 0` e `50`. Le due meta' si leggono **insieme**: da sole non rispondono.

## 🔴 CLASSE 547 — LA TAGLIA NON E' QUELLA IN CAMPO
Il file prova pinna `InpRiskPercent=1.0`, **non** il 2,00% con cui la sedia `770101` opera
su FTMO (firma del 20/09). E' a 1,0 **per riprodurre R202B**. 👉 **Ogni DD va letto
RADDOPPIATO**, e il raddoppio e' un **limite superiore** (fattore misurato 1,956-1,990).

## 🛡️ IL CONTROLLO NUOVO DENTRO LA RIGA — **classe 166, applicata per la prima volta**
🔴 `backtest_pipeline/walkforward_generico.ps1` r.264 ha `$EABranch="lavoro"` **CABLATO**,
e `RIGA_ROUND_VPS.ps1` **non passa `-Pin` al driver**. 👉 **Il pin copre la
procedura e il file prova, NON il sorgente dell'EA che compila**: quello arriva dal **ramo**.
Se qualcuno committa sul `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` fra adesso e l'incollata,
**l'ancora salta e il round si butterebbe per un motivo falso**.
🟢 La riga adesso calcola lo **SHA256** di cio' che ha davvero compilato e lo confronta con
quello del pin, **stampandolo e scrivendolo dentro il referto** che finisce nello zip.
⚠️ **Non chiude la finestra: la rende leggibile.** Il rimedio vero (`-Pin` propagato al
driver) resta da fare, ed e' un lavoro sul driver.

### 🔴 CLASSE 584 (nuova) — il suo autotest NON disambigua
Il file prova dice: *«se `(50 , 1,0)` non esce identica, la lettura del codice e'
sbagliata»*. 🔴 **Falso come esclusiva**: puo' uscire diversa anche perche' **il motore non e'
quello del pin** (classe 166). Chi segue l'istruzione va a cercare un errore nel sorgente che
non c'e'.
🟢 **Il discriminante e' l'ancora di R207A**: se `(50 , 0)` riproduce R202B,
l'ambiente e' sano e la colpa e' della lettura; se non riproduce, il motore e' ballato.
👉 **R207A non e' contesto: e' il PREREQUISITO LOGICO di R207B.**


---

## La riga
📌 **UNA riga fisica**, `& { ... }`, ASCII puro, zero a capo.
Pin al **commit** `52af6583`.

```powershell
& { $ErrorActionPreference='Stop'; $pin='52af6583c948e7de4d20db8ae3c380976be1ce96'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=17; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize | Out-Host; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host ('CLASSE 582 -- LA PRECONDIZIONE VALE ADESSO, IL COLTELLO CADE FRA ' + $tmo + ' MINUTI: ho appena controllato che il terminale bersaglio sia CHIUSO, ma se il tetto scatta il ramo di emergenza chiude metatester64 E terminal64 sotto C:\Program Files\BCM Markets MT5 Terminal. Finche il round gira NON riaprire a mano il demo 50503392 su questa macchina: te lo chiuderebbe. Il tetto NON e un numero tondo (classe 583): 4 passate x 16,5 s x 15 = 990 s, base appaiata R172D/R201A del 21/09 (stessa macchina, stesso driver, D30EUR M5 tick reali, 14 passate in 3 min 51 s).') -ForegroundColor Yellow; Write-Host 'CLASSE 547 -- TAGLIA DEL BANCO: il file prova pinna InpRiskPercent=1,0%, che NON e la taglia in campo della sedia 770101 (2,00%, firma del 20/09). E pinnata a 1,0 per RIPRODURRE R202B. Ogni DD va letto RADDOPPIATO, e il raddoppio e un LIMITE SUPERIORE (fattore misurato 1,956-1,990).' -ForegroundColor Yellow; Write-Host '=== ROUND R207B   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   2 celle x 2 gambe ===   << SI LANCIA DOPO R207A: senza l ancora di R207A questo round non si legge >>' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R207b_parziale_e_breakeven_DAX_D30EUR.txt','-Etichetta','R207B','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10 }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R207B: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $att=@{}; $att["$w\src_prove\ABTG_DAX_Apertura_EU.mq5"]='E33C6B8B81262FAAE561D4033559A7133FD965EA635FEC1ACF7E47CBA20C89AC'; $att["$w\src_include\ABTG_PausaGuardian.mqh"]='3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'; $div=@(); foreach($k in @($att.Keys)){ if(-not (Test-Path -LiteralPath $k)){ $div += ((Split-Path -Leaf $k) + ' [il driver non lo ha lasciato su disco]') } elseif((Get-FileHash -LiteralPath $k -Algorithm SHA256).Hash -ne $att[$k]){ $div += ((Split-Path -Leaf $k) + ' [SHA256 DIVERSO da quello del pin]') } }; if($div.Count -eq 0){ $m166='CLASSE 166 -- MOTORE: OK. Il .mq5 e l include che hanno COMPILATO sono ESATTAMENTE quelli del pin (SHA256 su src_prove e src_include). Il pin copre anche il motore, non solo la procedura: i numeri sono confrontabili con R202B.'; $c166='Green' } else { $m166=('CLASSE 166 -- MOTORE DIVERSO DAL PIN: ' + ($div -join ' ; ') + '. walkforward_generico.ps1 r.264 ha EABranch=lavoro CABLATO e la riga non gli passa nessun pin: EA e include arrivano dal RAMO. I numeri NON sono confrontabili con R202B: PRIMA di buttare il round si rifa il pin sul ramo e si rilancia.'); $c166='Red' }; Write-Host $m166 -ForegroundColor $c166; $d="$dsk\ROUND_R207B"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R207B sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Add-Content -LiteralPath (Join-Path $d 'REFERTO_ROUND_R207B.txt') -Value $m166 -Encoding ASCII -ErrorAction SilentlyContinue; Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R207B.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R207B.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R207B.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R207B.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R207B.csv' -ForegroundColor Gray; Write-Host '   R207b_parziale_e_breakeven_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; Write-Host 'ATTENZIONE: questo round NON HA ANCORA DI REGRESSIONE -- nessuna delle sue due celle e' gia' stata misurata. Si legge SOLO insieme a R207A, che l'ancora ce l'ha.' -ForegroundColor Yellow; Write-Host 'E LA CELLA DI CONTROLLO NON E UN ANCORA (classe 584): se (50 , 1,0) NON esce identica a (50 , 0) di R207A le spiegazioni sono DUE -- la lettura del codice e sbagliata, OPPURE il motore e ballato. Le distingue SOLO l ancora di R207A: se (50 , 0) riproduce R202B Pass 3 al centesimo, l ambiente e sano e la colpa e della lettura del codice. NESSUN VERDETTO SU R207B PRIMA DI AVER LETTO L ANCORA DI R207A.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

### 📦 I quattro file attesi in `Desktop\ROUND_R207B.zip`
`REFERTO_ROUND_R207B.txt` · `ABTG_DAX_Apertura_EU_D30EUR_IS_R207B.csv` · `ABTG_DAX_Apertura_EU_D30EUR_OOS_R207B.csv` · `R207b_parziale_e_breakeven_DAX_D30EUR.txt`


### 🔴 QUESTO ROUND **NON HA ANCORA**, e la riga lo dichiara
Nessuna delle sue due celle e' mai stata misurata. 👉 **Si legge SOLO insieme a R207A.**


## ✅ IL CANCELLO
**Strato 1**: 8 PASSATI, `nessun difetto meccanico`. **Parser PowerShell vero: 0 errori.**
`controlla_prova.py`: `celle=2 problemi 0`.
**Strato 2**: 🔴 **FAIL alla prima stesura** (classe 166 non mitigata, tetto su base sbagliata),
**corretta e ri-validata**. Ancora verificata **negli otto numeri, dai CSV**. E il **magic**
dimostrato inerte: nel sorgente solo confronti di identita', e in archivio coppie di magic
diversi con PF e Trades identici.

🔵 **Niente toccato in campo. Nessuna firma chiesta.**
