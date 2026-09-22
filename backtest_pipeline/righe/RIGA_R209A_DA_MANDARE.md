# 🧪 RIGA DA MANDARE — ROUND **R209A** · il dominio di `InpBEatR` mai misurato

## 🖥️ BERSAGLIO: **finestra PowerShell sul PC DI BACKTEST `DESKTOP-H4D7CAJ`**

🔴 **Pilota il solo MT5 di quella macchina**: `C:\Program Files\BCM Markets MT5 Terminal`, **demo `50503392`** — che **dev'essere
CHIUSO e senza EA attaccati** prima di incollare. La riga lo controlla e si ferma se e' aperto:
**non lo chiude lei**, perche' da quella macchina il **14/08/2026 sono partiti ordini VERI**
(#3160534/#3160535, −104,60).

### 🟢 Che cosa NON viene toccato
Niente di tutto questo sta su quella macchina, e la riga non lo raggiunge:
challenge **FTMO `541452707`** (`C:\FTMO`, **sei sedie che operano adesso**) · **100k `50504263`** ·
**REALE `10105439`** · **piccolo `50503392` del VPS** · Pepperstone · Tickmill · **banco `50504400`**.
E la guardia e' **fail-closed**: se il nome della macchina non e' `DESKTOP-H4D7CAJ`, la riga muore
**prima** di creare cartelle, **prima** del download, **prima** di qualunque processo.

### 🗑️ Che cosa scrive e cancella (classe 580: per nome, non "tocca il Desktop")
| percorso | che cosa gli succede |
|---|---|
| `%USERPROFILE%\abtg_round` | cartella di lavoro: creata |
| `%USERPROFILE%\abtg_round\RIGA_ROUND_VPS.ps1` | **riscaricato** dal pin a ogni corsa |
| `Desktop\ROUND_R209A\` | 🔴 **cancellata ricorsivamente** dal driver prima di riempirla |
| `Desktop\ROUND_R209A.zip` | creato/sovrascritto |

---

## 🎯 CHE COSA MISURA, in tre righe

La sedia Nasdaq **`770260`** ha in campo `InpTP1_R=0,5` + `InpBreakevenAtTP1=true`, quindi lo
stop va a pari gia' a **0,5 R**. I due breakeven condividono la marca `gBETk` e **il primo
gira prima**: percio' `InpBEatR` puo' agire **solo fra 0 e 0,5**.
🔴 **R199A aveva misurato 0 / 0,5 / 1,0 / 1,5 — tutti fuori o al bordo di quel dominio.**
R209A e' la **prima** misura che ci entra: 5 celle a `0 / 0,125 / 0,25 / 0,375 / 0,5`.

🟢 **E l'ancora sta dentro la riga**: la cella `0` **deve** riprodurre la Pass 2 di R199B.
Se non la riproduce, **il round si butta** — e la riga te lo stampa in coda, cosi' lo leggi
prima del resto.
🧪 **Contro-esempio dichiarato prima dei numeri**: se **tutte** le celle escono identiche
alla `0`, il verdetto e' *"manopola spenta per costruzione"*, **non** *"nessun effetto
misurato"*. Sono due cose diverse e il criterio per distinguerle e' a macchina.

---

## La riga
📌 **UNA riga fisica**, `& { ... }`, **4290 byte**, ASCII puro, **zero a capo**. Pin al
**commit** `52af6583`.

```powershell
& { $ErrorActionPreference='Stop'; $pin='52af6583c948e7de4d20db8ae3c380976be1ce96'; if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama ' + $env:COMPUTERNAME + '. Sul VPS operano le sei sedie della challenge FTMO e un backtest a tick reali lo inchioda: firma di Claudio del 21/09.') }; $w="$env:USERPROFILE\abtg_round"; $p="$w\RIGA_ROUND_VPS.ps1"; $dsk=[Environment]::GetFolderPath('Desktop'); $tmo=60; New-Item -ItemType Directory -Force -Path $w | Out-Null; Remove-Item $p -Force -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop; if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ROUND_VPS_v2' }; Write-Host 'BERSAGLIO: il solo MT5 di questo PC, C:\Program Files\BCM Markets MT5 Terminal, demo 50503392. Tutto il resto (challenge FTMO 541452707, 100k 50504263, REALE 10105439, Pepperstone, Tickmill, banco 50504400) sta su una macchina diversa e questa riga non la raggiunge.' -ForegroundColor Cyan; $mt=@(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id,MainWindowTitle,Path); Write-Host '--- MT5 APERTI SU QUESTA MACCHINA (PID / titolo / cartella) ---'; $mt | Format-Table -AutoSize; if(@($mt | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') }).Count -gt 0){ throw 'MT5 E APERTO: chiudilo A MANO (il PID sta nella tabella qui sopra), dopo aver guardato che non abbia EA attaccati, poi reincolla la riga. Non lo chiudo io: quel terminale e loggato sul demo 50503392 e da questa macchina il 14/08 sono partiti ordini veri.' }; Write-Host '=== ROUND R209A   EA ABTG_Nasdaq_Apertura_US   NASUSD M5   tick reali   deposito 80000   5 celle x 2 gambe ===' -ForegroundColor Cyan; $a=@('-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$p+'"'),'-Expert','ABTG_Nasdaq_Apertura_US','-Prova','R209a_breakeven_nasdaq_NASUSD.txt','-Etichetta','R209A','-Pin',$pin,'-TerminaleBacktest','"C:\Program Files\BCM Markets MT5 Terminal"','-Modello','4','-Deposito','80000'); $pr=Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru; if(-not $pr.WaitForExit($tmo*60*1000)){ Write-Host ('TETTO DI ' + $tmo + ' MINUTI SFONDATO: fermo il round. E UN RISULTATO, NON UN GUASTO: il referto che resta e PARZIALE.') -ForegroundColor Red; Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue; Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -and ($_.CommandLine -like '*walkforward_generico.ps1*') } | ForEach-Object { Write-Host ('   CLASSE 585 -- fermo anche il NIPOTE che esegue il driver: PID ' + $_.ProcessId) -ForegroundColor Red; Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Start-Sleep -Seconds 5; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue; try{ $pr.WaitForExit() }catch{}; Start-Sleep -Seconds 10; Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like 'C:\Program Files\BCM Markets MT5 Terminal\*') } | Stop-Process -Force -ErrorAction SilentlyContinue }; $rc=$pr.ExitCode; if($null -eq $rc){ $rc='NON LEGGIBILE' }; Write-Host ('   esito R209A: codice ' + $rc + '   (0=GIRATO  2=NON MISURATO  3=GIRATO CON RILIEVI  1=non e partito)') -ForegroundColor Yellow; $att=@{}; $att["$w\src_prove\ABTG_Nasdaq_Apertura_US.mq5"]='7F243CAC18EC5C955C1DF5B8F0CE0CB2AF564ADAF2B88E3A8F79F798C59AF744'; $att["$w\src_include\ABTG_PausaGuardian.mqh"]='3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737'; $div=@(); foreach($k in @($att.Keys)){ if(-not (Test-Path -LiteralPath $k)){ $div += ((Split-Path -Leaf $k) + ' [il driver non lo ha lasciato su disco]') } elseif((Get-FileHash -LiteralPath $k -Algorithm SHA256).Hash -ne $att[$k]){ $div += ((Split-Path -Leaf $k) + ' [SHA256 DIVERSO da quello del pin]') } }; if($div.Count -eq 0){ $m166='CLASSE 166 -- MOTORE: OK. Il .mq5 e l include che hanno COMPILATO sono ESATTAMENTE quelli del pin (SHA256 su src_prove e src_include): i numeri sono confrontabili con R199B.'; $c166='Green' } else { $m166=('CLASSE 166 -- MOTORE DIVERSO DAL PIN: ' + ($div -join ' ; ') + '. walkforward_generico.ps1 r.264 ha EABranch=lavoro CABLATO e la riga non gli passa nessun pin: EA e include arrivano dal RAMO. I numeri NON sono confrontabili con R199B: PRIMA di buttare il round si rifa il pin sul ramo e si rilancia.'); $c166='Red' }; Write-Host $m166 -ForegroundColor $c166; $d="$dsk\ROUND_R209A"; if(-not (Test-Path $d)){ Write-Host 'MANCA la cartella ROUND_R209A sul Desktop: il round NON ha prodotto raccolta.' -ForegroundColor Red } else { Compress-Archive -Path "$d\*" -DestinationPath "$dsk\ROUND_R209A.zip" -Force; Write-Host 'ZIP PRONTO DA MANDARE: Desktop\ROUND_R209A.zip' -ForegroundColor Green }; Write-Host 'FILE ATTESI NELLO ZIP (4):' -ForegroundColor Gray; Write-Host '   REFERTO_ROUND_R209A.txt' -ForegroundColor Gray; Write-Host '   ABTG_Nasdaq_Apertura_US_NASUSD_IS_R209A.csv' -ForegroundColor Gray; Write-Host '   ABTG_Nasdaq_Apertura_US_NASUSD_OOS_R209A.csv' -ForegroundColor Gray; Write-Host '   R209a_breakeven_nasdaq_NASUSD.txt' -ForegroundColor Gray; Write-Host 'NEL REFERTO LEGGI LA RIGA  data:  -- DEVE ESSERE DI OGGI, altrimenti stai guardando un file vecchio.' -ForegroundColor Yellow; Write-Host 'E LA PRIMA COSA DA GUARDARE E LANCORA: la cella InpBEatR=0 DEVE dare IS PF 1.22116 DD 7.3069 n 135 e OOS PF 1.21546 DD 7.8576 n 172. Se non li da, PRIMA di buttare il round si legge la riga CLASSE 166 qui sopra: un motore diverso dal pin spiega lo scarto senza che il round sia sbagliato.' -ForegroundColor Yellow; if(Test-Path $d){ Get-ChildItem $d -Recurse -File | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize } }
```

⏳ **Tempo atteso: 3-6 minuti** (10 passate; misurato: ~23 s/passata su questa famiglia).
Il tetto e' a **60 minuti** = 10-20x il costo misurato. Se sfora, si ferma e il referto che
resta e' **PARZIALE**: e' un risultato dichiarato, non un guasto.

### 📦 I quattro file attesi nello zip `Desktop\ROUND_R209A.zip`
| file |
|---|
| `REFERTO_ROUND_R209A.txt` |
| `ABTG_Nasdaq_Apertura_US_NASUSD_IS_R209A.csv` |
| `ABTG_Nasdaq_Apertura_US_NASUSD_OOS_R209A.csv` |
| `R209a_breakeven_nasdaq_NASUSD.txt` |

🔴 **Nel referto leggi la riga `data:`: dev'essere di OGGI**, altrimenti stai guardando un
file vecchio.

---

## ✅ IL CANCELLO — che cosa ha detto

**Strato 1** (`controlla_riga.py`): **8 PASSATI**, `ESITO: nessun difetto meccanico`. Parser PowerShell
vero: **0 errori, 423 token**. `controlla_prova.py`: `pin=26 celle=5 problemi 0 OK`.

**Strato 2**: **PASS**, e ha verificato alla fonte — non sul riassunto:
- 🟢 i **sei numeri dell'ancora** contro il **CSV** di R199B (colonna `InpTP1_ClosePct`
  letta **per nome**, non per posizione): `1.22116 / 7.3069 / 135` e `1.21546 / 7.8576 / 172`;
- 🟢 il diff dei pin R209a vs R199b: **esattamente due righe**, lo scambio di ruolo
  dichiarato. Gli altri **24** identici carattere per carattere;
- 🟢 `git diff --stat` fra il pin di R199B e questo su EA, `Include/` e i due driver: **VUOTO**.
  Nessun byte cambiato ⇒ **l'ancora puo' tornare**;
- 🟢 i quattro nomi dei file attesi **letti dal driver** (r.1051-1053), non dedotti;
- 🟢 il filtro di `Stop-Process` e' una **costante** e per prefisso **non raggiunge
  il 100k**: dopo `Terminal` c'e' uno spazio, non un `\`.

### 🟠 E una cosa che ho CAMBIATO dopo il PASS, e la dico
Il cancello ha segnalato una crepa reale: **la precondizione "il terminale e' chiuso" e'
verificata a t=0, ma l'uccisione avviene a t=TETTO**. Con 240 minuti era una finestra di
quattro ore in cui tu potevi riaprire a mano quell'MT5.
👉 **Ho portato il tetto da 240 a 60 minuti** e ho rifatto il cancello (stessi 8 PASSATI,
parser 0 errori). Resta **10-20x il costo misurato** e dimezza due volte l'esposizione.
📌 Catalogata come **classe 582**.

🔵 **Niente toccato in campo. Nessuna firma chiesta: il verdetto si scrivera' sui CSV, coi
cancelli c0-c5 gia' congelati dentro il file prova.**

---

## 🔴 AGGIORNATA IL 22/09 SERA — aggiunta la guardia della **classe 166**

Il cancello di `R207A` ha trovato un difetto che vale **per tutte le righe di round**, questa
compresa: `backtest_pipeline/walkforward_generico.ps1` r.264 ha `$EABranch="lavoro"` **cablato**,
e `RIGA_ROUND_VPS.ps1` **non passa `-Pin` al driver**.
👉 **Il pin copre la procedura e il file prova, NON il sorgente dell'EA che compila**: quello
arriva dal **ramo**. Se qualcuno committa su `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` fra adesso
e l'incollata, **l'ancora salta e il round si butterebbe per un motivo falso**.

🟢 La riga qui sopra adesso calcola lo **SHA256** di cio' che ha davvero compilato
(`7F243CAC...` per l'EA, `3EC97115...` per l'include) e lo confronta con quello del pin,
stampandolo e **scrivendolo dentro il referto** che finisce nello zip.
⚠️ Non chiude la finestra: la **rende leggibile**. Il rimedio vero (`-Pin` propagato al driver)
resta da fare.

📌 Ri-validata dopo la modifica: strato 1 **8 PASSATI**, parser PowerShell **0 errori**,
una riga fisica, zero a capo, 20 graffe aperte e 20 chiuse.

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
