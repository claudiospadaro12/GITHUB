# 🧪 RIGA DA MANDARE — **R207A** · la meta' BASSA della 2x2 parziale x breakeven

## 🖥️ BERSAGLIO: **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`** — **MAI il VPS**

🔴 Pilota **il solo MT5 di quella macchina**: `C:\Program Files\BCM Markets MT5 Terminal`, **demo `50503392`** — che **dev'essere CHIUSO e senza EA attaccati**. La riga lo
controlla e si ferma se e' aperto: **non lo chiude lei**, perche' da quella macchina il 14/08
sono partiti ordini VERI.

🟢 **NON viene toccato** (sta tutto su un'altra macchina): challenge **FTMO `541452707`** (`C:\FTMO`, sei sedie che operano) · 100k `50504263` · **REALE `10105439`** · piccolo `50503392` del VPS · Pepperstone · Tickmill · banco `50504400`.

🔴 **CLASSE 582 — NON RIAPRIRE IL DEMO `50503392` MENTRE GIRA.** La riga controlla
che il terminale sia chiuso **adesso**, ma il ramo di emergenza scatta **fra 17 minuti**: se nel
frattempo lo riapri a mano, te lo chiude.

### 🗑️ Percorsi scritti e cancellati (classe 580)
`%USERPROFILE%\abtg_round` (creata) · `%USERPROFILE%\abtg_round\RIGA_ROUND_VPS.ps1` (riscaricato) · `Desktop\ROUND_R207A\` 🔴 **cancellata ricorsivamente** dal
driver · `Desktop\ROUND_R207A.zip` (rifatto).

### ⏱️ Il tetto: **17 minuti, e non e' un numero tondo** (classe 583)
4 passate x 16,5 s x 15 = **990 s = 16,5 min** → `$tmo=17`. La base e' **appaiata**:
`R172D`/`R201A` del 21/09, stessa macchina, stesso driver, **D30EUR M5 tick
reali**, 14 passate in **3 min 51 s**. 🔴 *(La base «~23 s di questa famiglia» che avevo usato
prima era di `ABTG_EMA200` su `U30USD` H1: altro EA, altro TF — classe 583.)*


---

## 🎯 CHE COSA MISURA
La sedia DAX **`770101`** in campo ha parziale al 50% e breakeven al primo obiettivo.
Questo round spegne e riaccende la **parziale** tenendo il breakeven indipendente **spento**
(`InpBEatR=0`): 2 celle, `ClosePct = 0` e `50`.

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


---

## La riga
📌 **UNA riga fisica**, `& { ... }`, ASCII puro, zero a capo.
Pin al **commit** `52af6583`.

```powershell
& { $ErrorActionPreference='Stop'; $pin='52af6583c948e7de4d20db8ae3c380976be1ce96'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=17; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize | Out-Host; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host ('CLASSE 582 -- LA PRECONDIZIONE VALE ADESSO, IL COLTELLO CADE FRA ' + $tmo + ' MINUTI: ho appena controllato che il terminale bersaglio sia CHIUSO, ma se il tetto scatta il ramo di emergenza chiude metatester64 E terminal64 sotto C:\Program Files\BCM Markets MT5 Terminal. Finche il round gira NON riaprire a mano il demo 50503392 su questa macchina: te lo chiuderebbe. Il tetto NON e un numero tondo (classe 583): 4 passate x 16,5 s x 15 = 990 s, base appaiata R172D/R201A del 21/09 (stessa macchina, stesso driver, D30EUR M5 tick reali, 14 passate in 3 min 51 s).') -ForegroundColor Yellow; Write-Host 'CLASSE 547 -- TAGLIA DEL BANCO: il file prova pinna InpRiskPercent=1,0%, che NON e la taglia in campo della sedia 770101 (2,00%, firma del 20/09). E pinnata a 1,0 per RIPRODURRE R202B. Ogni DD va letto RADDOPPIATO, e il raddoppio e un LIMITE SUPERIORE (fattore misurato 1,956-1,990).' -ForegroundColor Yellow; Write-Host '=== ROUND R207A   EA ABTG_DAX_Apertura_EU   D30EUR M5   tick reali   deposito 80000   2 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_DAX_Apertura_EU','-Prova','R207a_parziale_e_breakeven_DAX_D30EUR.txt','-Etichetta','R207A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -and ($_.CommandLine -like '*walkforward_generico.ps1*') } | ForEach-Object { Write-Host ('   CLASSE 585 -- fermo anche il NIPOTE che esegue il driver: PID ' + $_.ProcessId) -ForegroundColor Red; Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Start-Sleep -Seconds 5; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R207A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $att=@{}; $att["$w\src_prove\ABTG_DAX_Apertura_EU.mq5"]='E33C6B8B81262FAAE561D4033559A7133FD965EA635FEC1ACF7E47CBA20C89AC'; $att["$w\src_include\ABTG_PausaGuardian.mqh"]='3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'; $div=@(); foreach($k in @($att.Keys)){ if(-not (Test-Path -LiteralPath $k)){ $div += ((Split-Path -Leaf $k) + ' [il driver non lo ha lasciato su disco]') } elseif((Get-FileHash -LiteralPath $k -Algorithm SHA256).Hash -ne $att[$k]){ $div += ((Split-Path -Leaf $k) + ' [SHA256 DIVERSO da quello del pin]') } }; if($div.Count -eq 0){ $m166='CLASSE 166 -- MOTORE: OK. Il .mq5 e l include che hanno COMPILATO sono ESATTAMENTE quelli del pin (SHA256 su src_prove e src_include). Il pin copre anche il motore, non solo la procedura: i numeri sono confrontabili con R202B.'; $c166='Green' } else { $m166=('CLASSE 166 -- MOTORE DIVERSO DAL PIN: ' + ($div -join ' ; ') + '. walkforward_generico.ps1 r.264 ha EABranch=lavoro CABLATO e la riga non gli passa nessun pin: EA e include arrivano dal RAMO. I numeri NON sono confrontabili con R202B: PRIMA di buttare il round si rifa il pin sul ramo e si rilancia.'); $c166='Red' }; Write-Host $m166 -ForegroundColor $c166; $d="$dsk\ROUND_R207A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R207A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Add-Content -LiteralPath (Join-Path $d 'REFERTO_ROUND_R207A.txt') -Value $m166 -Encoding ASCII -ErrorAction SilentlyContinue; Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R207A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R207A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R207A.txt' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_IS_R207A.csv' -ForegroundColor Gray; Write-Host '   ABTG_DAX_Apertura_EU_D30EUR_OOS_R207A.csv' -ForegroundColor Gray; Write-Host '   R207a_parziale_e_breakeven_DAX_D30EUR.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; Write-Host 'ANCORA: la cella ClosePct=50 DEVE riprodurre R202B Pass 3 -- IS n 175 PF 1.12733 DD 5.4089 Profit 3050.56 e OOS n 270 PF 1.39520 DD 7.2506 Profit 14355.32. Se non li da, PRIMA di buttare il round si legge la riga CLASSE 166 qui sopra: un motore diverso dal pin spiega lo scarto senza che il round sia sbagliato.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

### 📦 I quattro file attesi in `Desktop\ROUND_R207A.zip`
`REFERTO_ROUND_R207A.txt` · `ABTG_DAX_Apertura_EU_D30EUR_IS_R207A.csv` · `ABTG_DAX_Apertura_EU_D30EUR_OOS_R207A.csv` · `R207a_parziale_e_breakeven_DAX_D30EUR.txt`


### 🧷 L'ANCORA
🟢 La cella `ClosePct=50` **deve riprodurre R202B Pass 3**:
IS `n 175 · PF 1,12733 · DD 5,4089 · Profit 3050,56` · OOS `n 270 · PF 1,39520 · DD 7,2506 · Profit 14355,32`.
**Otto numeri su otto verificati nei CSV**, non nel referto.
🔴 Se non torna, **prima di buttare il round si legge la riga CLASSE 166**: un motore diverso
dal pin spiega lo scarto senza che il round sia sbagliato.


## ✅ IL CANCELLO
**Strato 1**: 8 PASSATI, `nessun difetto meccanico`. **Parser PowerShell vero: 0 errori.**
`controlla_prova.py`: `celle=2 problemi 0`.
**Strato 2**: 🔴 **FAIL alla prima stesura** (classe 166 non mitigata, tetto su base sbagliata),
**corretta e ri-validata**. Ancora verificata **negli otto numeri, dai CSV**. E il **magic**
dimostrato inerte: nel sorgente solo confronti di identita', e in archivio coppie di magic
diversi con PF e Trades identici.

🔵 **Niente toccato in campo. Nessuna firma chiesta.**

---

## 🔴 CORRETTA DI NUOVO IL 22/09 SERA — **classe 585: il tetto non fermava il round**

Il cancello su `R206A` ha trovato che `Stop-Process -Id $pr.Id` uccide **il figlio**
(`RIGA_ROUND_VPS.ps1`) ma **non il NIPOTE**: quel file lancia il driver a r.1085 con
`Start-Process powershell ... -Wait`, e Windows **non crea nessun job object**, quindi il
`powershell.exe` che esegue `walkforward_generico.ps1` **sopravvive**. E il driver **non muore**
se un CSV manca (r.2070: stampa un avviso e **passa alla gamba dopo**).
👉 **Risultato: dopo la spazzata il nipote rilanciava `terminal64`, il round proseguiva, e la
riga stampava «fermo il round» — che era FALSO.**

✅ **Riparato**: ① si uccide `$pr`; ② si uccidono i `powershell.exe` la cui `CommandLine`
contiene `walkforward_generico.ps1`, **stampando i PID**; ③ si aspetta 5 s; ④ si spazzano i
terminali sul percorso bersaglio; ⑤ dopo i 10 s si **rispazza**.
⚠️ **Costo dichiarato**: il filtro ② e' sul **nome del driver**, non sul percorso del terminale
— se sulla stessa macchina girasse **un altro round**, fermerebbe anche quello. Sul PC di
backtest non ce ne sono altri.

## 🔴 E un controllo NUOVO che prima non facevamo — **classe 586**
`Parser::ParseInput` dice **0 errori** anche su una riga con `-ForegroundColor` specificato
**due volte**: non e' sintassi, e' **binding**, e sarebbe esplosa **a round gia' girato**.
🟢 Ora c'e' `backtest_pipeline/controlla_binding.ps1`, collaudato **contro il contro-esempio**:
becca la riga rotta (1 binding rotto) e dice **0 rotti** su questa.

📌 Ri-validata dopo le due modifiche: **8 PASSATI** allo strato 1, **0 errori** di sintassi,
**0 binding rotti**, una riga fisica, zero a capo, graffe e tonde pari.
