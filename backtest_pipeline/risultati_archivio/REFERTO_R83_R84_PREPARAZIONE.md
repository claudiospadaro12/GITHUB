# 🧰 R83 + R84 — LA PREPARAZIONE (18/08/2026 sera)

_Due round sulle APERTURE, preparati insieme perche' si incastrano: R84
chiude un debito vecchio (i filtri), R83 apre la domanda nuova di Claudio
(gli ingressi). **Nessuno dei due ha ancora prodotto un numero**: qui c'e'
solo la macchina, con i criteri congelati PRIMA._

> 🎯 **IN TRE RIGHE:** **R84** misura, un filtro alla volta, se le condizioni
> del corso aggiungono o tolgono sul Nasdaq (**9 celle**, EA vivo, zero righe
> di codice toccate). **R83** e' il duello degli ingressi firmato da Claudio
> (**7 celle**, EA NUOVO a tre modalita', Nasdaq + DAX). Tutto e' committato
> e pinnabile; **le righe di lancio qui dentro sono BOZZE** e passano dal
> verificatore prima di arrivare a Claudio.

---

## 1. 📦 COSA E' PRONTO (percorsi esatti)

| pezzo | file |
|---|---|
| criteri R84 (congelati) | `backtest_pipeline/prove/R84_ABLAZIONE_CRITERI.md` |
| criteri R83 (congelati) | `backtest_pipeline/prove/R83_INGRESSI_CRITERI.md` |
| file prova R84 (9) | `backtest_pipeline/prove/R84a_base_NASUSD.txt` ... `R84i_completo_NASUSD.txt` |
| file prova R83 (7) | `backtest_pipeline/prove/R83n0_stop_NASUSD.txt` ... `R83v_vivo_D30EUR.txt` |
| EA nuovo del duello | `mql5/Experts/ABTG_Apertura_3Ingressi.mq5` |
| driver R84 | `backtest_pipeline/lancia_r84.ps1` |
| driver R83 | `backtest_pipeline/lancia_r83.ps1` |

**SHA da pinnare: `2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b`** — contiene
tutti e sette i pezzi (verificato file per file con `git log -1 -- <file>`,
punto 4 della checklist). `walkforward_generico.ps1` e' fermo a `51922fa`
(14/08), quindi piu' vecchio: il pin va bene.

## 2. 🔬 R84 — L'ABLAZIONE DEI FILTRI (Nasdaq, 9 celle)

**La domanda:** *"i filtri che il corso prescrive come CONDIZIONI aggiungono
o tolgono, misurato, un filtro alla volta, a parita' di tutto il resto?"*

**Perche' esiste:** l'audit del 02/08 spense i filtri promettendo di
misurarli; la misura non e' mai finita. Oggi i filtri sono spenti **non
perche' misurati inutili, ma perche' la misura non c'e'**. Quello che e'
morto nei walk-forward e' lo **scheletro nudo**; il metodo del corso, coi
suoi filtri, **non e' mai stato messo alla prova fino in fondo**.

| cella | filtro acceso | magic |
|---|---|---|
| A | nessuno (il metro) | 776010/11 |
| B | volumi >= 1,5 x media 20 barre | 776020/21 |
| C | ATR >= media 20 barre | 776030/31 |
| D | volumi **O** ATR (la conferma come la scrive il PDF) | 776040/41 |
| E | trend EMA 14/200 H1 | 776050/51 |
| F | Supertrend 10/2.5 H1 | 776060/61 |
| G | tre Supertrend concordi 2.5/3.0/3.5 | 776070/71 |
| H | indice guida SPXUSD | 776080/81 |
| I | **metodo completo** (D+E+G+H) | 776090/91 |

Ogni file prova e' la cella A con **UNA riga cambiata**: `diff R84a... R84g...`
mostra esattamente quella riga. I nomi dei 71-77 parametri pinnati sono stati
**verificati uno per uno contro i 95 `input` del sorgente vivo** (un nome
sbagliato MT5 lo ignora in silenzio e il round risponde a un'altra domanda).

**Esclusi apposta e dichiarati:** filtro **news** (si alimenta da un CSV la
cui copertura sulla finestra non e' misurata: una cella che non filtra niente
sembrerebbe "filtro neutro" — falso), `InpUseRoundLevels` (e' una regola di
**uscita**, non un filtro), leve R30 (non vengono dal corso).

## 3. 🥊 R83 — IL DUELLO DEGLI INGRESSI (Nasdaq + DAX, 7 celle)

**Firma 6, parole di Claudio:** *"SI, FIRMO R83BIS"*. Un solo EA con
`InpEntryMode` **0 = stop / 1 = limit sul retest / 2 = market alla conferma
di chiusura**, un magic per modalita', mai segnali miscelati.

| cella | mercato | modalita' | magic | ruolo |
|---|---|---|---|---|
| N0 | NASUSD | 0 stop | 777010/11 | baseline Nasdaq **+ canarino (a)** |
| N1 | NASUSD | 1 limit retest | 777020/21 | sfidante |
| N2 | NASUSD | 2 market conferma | 777030/31 | sfidante (**codice nuovo**) |
| D0 | D30EUR | 0 stop | 777110/11 | sfidante |
| D1 | D30EUR | 1 limit retest | 777120/21 | **baseline DAX** |
| D2 | D30EUR | 2 market conferma | 777130/31 | sfidante (**codice nuovo**) |
| V | D30EUR | EA **vivo** | 777190/91 | **canarino (b)**: equivalenza |

### 3.1 🐤 I due canarini, e perche' senza di loro il duello non conta
- **(a)** N0 e' configurata **riga per riga** come la cella A di R84, che gira
  sull'**EA vivo del Nasdaq**: i numeri **devono coincidere**. Verificato qui
  a tavolino che gli unici scarti fra i due file prova sono il magic e
  `InpAutoTest` (che nell'EA vecchio non esiste); i tre parametri che N0 pinna
  in piu' (`InpOCTimeframe`, `InpDelayMinutes`, `InpDelayDirMode`) valgono
  **esattamente i default** su cui il driver blinda la cella A. **Costo
  macchina in piu': zero.**
- **(b)** D1 (EA nuovo) e V (EA vivo) devono coincidere.
- **Se un canarino fallisce, il round si FERMA** e si cerca la divergenza nel
  codice. Non si spiega a posteriori.

### 3.2 ⚠️ Tre cose trovate leggendo i sorgenti, che cambiano le premesse

1. **Sul DAX la baseline NON e' il breakout stop.** La sedia viva 770101 gira
   **gia' in retest** dal 06/08 — riga del sorgente:
   `input ENUM_ABTG_ENTRY InpEntryMode = ABTG_RETEST;` con
   `InpRetestOffsetPts=200`. Quindi sul DAX le sfidanti sono la 0 e la 2.
   Sul Nasdaq invece la baseline e' davvero la 0.
2. **I due motori vivi sono GIA' divergenti fra loro.** Il core del **DAX** ha
   `InpAllowReverse` (R51) e **non** ha le leve R30; il core del **Nasdaq** ha
   le leve R30 e **non** ha `InpAllowReverse`. L'EA nuovo e' un fork del core
   **Nasdaq**: percio' esiste il canarino (b).
3. **La modalita' 2 e' codice nuovo, non un alias.** Il motore vivo ha
   `OPENCONFIRM` (la candela **APRE** oltre il livello); la firma chiede la
   **CHIUSURA** oltre il livello. Sulle aperture di sessione, dove il salto fra
   chiusura e apertura e' la norma, **le due regole non coincidono**.

### 3.3 🧯 L'asimmetria dichiarata: lo slippage
`InpSlippagePts` nel motore peggiora l'entry **dei soli ordini STOP** (righe
930 e 955 del sorgente vivo). In R83 e' **0 su tutte le celle**: quindi **la
modalita' 0 e' avvantaggiata**. Se vince lei, serve un **giro 2** con un
valore **misurato** (non inventato), altrimenti la vittoria resta con
l'asterisco. Se vincono la 1 o la 2, hanno vinto **nonostante** il vantaggio
dell'avversaria e il giro 2 e' inutile.

## 4. 🧪 L'EA NUOVO — cosa e' stato scritto, e cosa NON e' verificato

`mql5/Experts/ABTG_Apertura_3Ingressi.mq5` (fork del tutto-in-uno del Nasdaq):
- nuovo enum a **tre** membri (`InpEntryMode` 0/1/2) tradotto in `OnInit`
  nella modalita' interna del motore (`gEntryMode`), come **prima** istruzione;
- **modalita' 2 nuova**: `ArmCloseConfirm` + `MonitorCloseConfirm`, con la
  decisione isolata in una funzione **pura** (`DirezioneDaChiusura`) proprio
  per poterla provare con numeri finti;
- **autotest `[3ING][AUTOTEST]`** in `OnInit`: sei controlli sulla modalita' 2
  (chiusura sopra / dentro / sotto / **esattamente sul livello** / bias
  contrario / lato vietato) piu' la riga che dice quale modalita' e' attiva;
- **guardia sui magic**: l'EA **si rifiuta di partire** su un magic di una
  sedia di apertura (770101/103/121/201/202/203/204). Senza, un magic
  sbagliato lo farebbe gestire (parziale, breakeven, trailing, flat) le
  posizioni di quella sedia;
- **avviso filtri**: se in R83 qualcuno accende un filtro, l'EA lo scrive nel
  log e la cella si butta;
- **ASCII puro**, zero emoji (regola di casa, imparata sui `.ps1`).

> 🔴 **NON VERIFICATO, e va detto per primo: l'EA NON E' STATO COMPILATO.**
> Qui non c'e' MetaEditor. Sono stati fatti solo controlli meccanici (parentesi
> e graffe bilanciate a parita' col sorgente d'origine, zero byte non-ASCII,
> nessun nome di parametro inventato). **Il primo gesto sul PC e' compilare**:
> se non compila, tutto il resto di R83 non esiste.

## 5. 📋 LE RIGHE DI LANCIO

> 🔴 **BOZZA BOCCIATA DAL VERIFICATORE (18/08 notte, FAIL).** Le quattro righe
> della prima stesura avevano **9 difetti**, tutti nella CONSEGNA (i due driver
> e i 16 file prova sono risultati puliti: 0 byte non-ASCII, tutti i nomi dei
> parametri esistono davvero nei tre EA, un solo asse `Y`, ore in ora server).
> I difetti erano: **blocchi multi-riga** (punto 21: un `throw` alla riga 5 non
> ferma la riga 6, che parte lo stesso); **PASSO 0 senza `$LASTEXITCODE`**
> (punto 13) e **senza controllo dell'artefatto** (punto 19.2: il timeout e i
> "15 minuti di silenzio" di `scarica_storico.ps1` ammazzano MT5 a meta' e
> **escono 0**); **il referto storico vecchio sul Desktop non veniva
> cancellato**, e il PASSO 0 dei driver lo riaccetta senza guardare la data;
> **il canarino annullato** (5.2 e 5.3 incollavano canarino e corsa completa di
> fila: la corsa da nove celle partiva da sola un'ora dopo, senza che nessuno
> avesse letto il canarino); **nessuna riga compilava l'EA nuovo**, mentre il
> par. 7 lo mette come passo 2 (punto 20: il gesto chiesto non produce
> l'output); **MT5 chiuso non era detto nelle righe** (punto 7); **il pin non
> copre gli EA** (vedi qui sotto).

> ⚠️ **IL PIN `2458b33` NON COPRE GLI EA, ed e' il pezzo che conta di piu'.**
> `walkforward_generico.ps1` (riga 78-79, `$EABranch="lavoro"`) **riscarica il
> `.mq5` dal branch `lavoro` HEAD ignorando `-Rif`**, e se il download fallisce
> **usa in silenzio la copia locale** in `src_prove\`. Conseguenze: (1) un push
> su `lavoro` **durante** i round cambia l'EA fra una cella e l'altra e i
> canarini non vogliono piu' dire niente; (2) la cache di `raw` puo' servire
> una versione vecchia. Due contromisure, ed entrambe sono nelle righe:
> il **PASSO 1 confronta byte a byte** i tre EA su `lavoro` con quelli del pin
> e si ferma se differiscono; e **dall'inizio del PASSO 0 alla fine di R83 non
> si pusha NIENTE su `lavoro`** (soprattutto in `mql5/Experts/`).

> 🔴 **AVVISO DEL 19/08, PRIMA DI LANCIARE QUALUNQUE PASSO.** La **migrazione
> Guardian** (decisione n.1 del PIANO_PROP) ha modificato su `lavoro`
> **`ABTG_Nasdaq_Apertura_US`** (cella A di R84 e metro del canarino di R83) e
> **`ABTG_DAX_Apertura_EU`** (cella V di R83): il congelamento del branco e'
> stato rotto e **il PASSO 1a qui sotto ora fallisce apposta**. Non e' un bug
> della riga: e' la guardia che funziona. Prima si porta a casa il **criterio 4**
> della migrazione (`REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`, FASE 2:
> backtest identico al centesimo prima/dopo). Se passa, si **ri-pinna R83/R84
> all'hash nuovo** dicendolo nel referto; se non passa, R83/R84 non partono
> comunque, perche' misurerebbero un motore cambiato.

**Come si incollano:** ogni passo e' **UN SOLO blocco `& { ... }`**, graffe
comprese, si incolla **tutto insieme**. Cosi' un `throw` a meta' ferma davvero
quello che viene dopo. **Fra un passo e l'altro ci si ferma e si legge.**
**MT5 deve essere CHIUSO** in tutti i passi tranne l'autotest del PASSO 1b (e i
blocchi lo verificano da soli).

### PASSO 0 — la profondita' dei TICK (viene PRIMA di tutto, 30-180 min [STIMA])

> 🔴 **QUESTA RIGA E' STATA GIRATA IL 18/08 ALLE 21:17 ED E' FALLITA — ed e' il
> blocco stesso ad averlo detto.** Il `throw` sulla riga `TICK` mancante ha
> fermato tutto invece di far partire i round su un CSV da 0 byte. Causa,
> trovata e riprodotta: `Coda-Log-Storico` in `scarica_storico.ps1`, quando un
> log **non era cresciuto** (quello di IERI), saltava il `Seek` e lo
> **rileggeva da capo** — il `=== FINITO` delle 23:54 del 17/08 e' stato preso
> per quello di oggi, MT5 ammazzato **15 secondi** dopo l'avvio col download
> appena partito. Curato in `a4369f1` (`$da -ge $fs.Length -> continue`), e
> **questa riga ora punta a quell'hash**. Tutti gli altri passi restano a
> `2458b33`: `git diff 2458b33..a4369f1` sui driver, sui 16 file prova e sui
> `.mq5` e' **vuoto**, sono gli stessi byte.

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, poi rilancia (con -Auto lo script si rifiuta di partire)" }
  $h="a4369f18d7fd93b954ed657c0ebcf602feb5bdfa"
  $p="$env:USERPROFILE\scarica_storico.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  $csv=Join-Path $dsk 'storico_bcm\ABTG_StoricoScaricato.csv'
  Remove-Item $p -Force -EA SilentlyContinue
  Remove-Item $csv -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scarica_storico.ps1" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'file non cresciuto = NIENTE da leggere' -Quiet)){ throw "SCRIPT VECCHIO (senza la cura del 18/08): aspetta 5 minuti e rilancia" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p -Simboli "NASUSD,D30EUR" -Da 2024.01.01 -TimeoutMin 180 -Auto
  if($LASTEXITCODE -ne 0){ throw "PASSO 0 FALLITO (codice $LASTEXITCODE): non si va oltre" }
  if(-not (Test-Path -LiteralPath $csv)){ throw "PASSO 0 MONCO: il referto non e' arrivato sul Desktop. RILANCIA." }
  $t=@(@(Import-Csv -LiteralPath $csv) | Where-Object { $_.Timeframe -eq 'TICK' })
  $t | Format-Table Simbolo,Timeframe,Barre,PrimaDataLocale,Verdetto -AutoSize
  foreach($s in @('NASUSD','D30EUR')){
    $x=@($t | Where-Object { $_.Simbolo -eq $s })
    if($x.Count -eq 0){ throw "PASSO 0 MONCO: manca la riga $s,TICK - MT5 e' stato ammazzato a meta' (timeout 180 min o 15 minuti di silenzio). RILANCIA." }
    $d=($x[0].PrimaDataLocale + '').Trim()
    if($d -eq '' -or $d -eq '-'){ throw "PASSO 0: $s NON HA TICK REALI. I due round girano a -Modello 1 -SaltaPassoZero e OGNI numero porta scritto 'OHLC, non tick'." }
  }
  Write-Host "PASSO 0 OK: leggi le due righe TICK qui sopra, colonna PrimaDataLocale." -ForegroundColor Green
  Write-Host "(sulle righe TICK la colonna PrimaDataServer vale SEMPRE '-': non e' quella)" -ForegroundColor Green
  Write-Host "Se una delle due date e' DOPO il 2024.09.26: FERMATI, la finestra dei file prova va riscritta." -ForegroundColor Yellow
  Write-Host "Da mandare in chat: Desktop\storico_bcm.zip" -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio.** `-TimeoutMin 180` non e' decorativo (il default e' 90
e la stima e' 30-180: difetto n.19) — ma **un timeout non esce 1**: per questo
il blocco controlla le due righe `TICK` a mano.

### PASSO 1a — COMPILAZIONE dell'EA nuovo + congelamento degli EA (5-10 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo (questo passo scrive in MetaQuotes\Terminal\...\MQL5\Experts)" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB"
  foreach($e in @('ABTG_Apertura_3Ingressi','ABTG_Nasdaq_Apertura_US','ABTG_DAX_Apertura_EU')){
    $a=[string](irm "$b/lavoro/mql5/Experts/$e.mq5" -EA Stop)
    $c=[string](irm "$b/$h/mql5/Experts/$e.mq5" -EA Stop)
    if($a -ne $c){ throw "L'EA $e su 'lavoro' NON e' quello del pin: qualcuno ha pushato. FERMATI e riallinea." }
    Write-Host ("    congelato e uguale al pin: " + $e) -ForegroundColor Green
  }
  $t=@(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter terminal64.exe -EA SilentlyContinue | Where-Object { $_.DirectoryName -like "*BCM Markets*" })
  if($t.Count -eq 0){ throw "terminale BCM non trovato" }
  $inst=$t[0].DirectoryName
  $df=@(Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory -EA SilentlyContinue | Where-Object { $o=Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $inst) })
  if($df.Count -eq 0){ throw "cartella dati MT5 non trovata (origin.txt)" }
  $exp=Join-Path $df[0].FullName "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $exp | Out-Null
  $mq=Join-Path $exp "ABTG_Apertura_3Ingressi.mq5"
  $ex5=[IO.Path]::ChangeExtension($mq,'.ex5')
  $log=[IO.Path]::ChangeExtension($mq,'.log')
  Remove-Item $mq,$ex5,$log -Force -EA SilentlyContinue
  irm "$b/$h/mql5/Experts/ABTG_Apertura_3Ingressi.mq5" -OutFile $mq -EA Stop
  if(-not (Select-String -Path $mq -SimpleMatch -Pattern 'AutoTest3Ingressi' -Quiet)){ throw "SORGENTE VECCHIO O TRONCO" }
  & (Join-Path $inst "metaeditor64.exe") "/compile:$mq" "/log" | Out-Null
  $fine=(Get-Date).AddMinutes(2)
  while((-not (Test-Path $ex5)) -and ((Get-Date) -lt $fine)){ Start-Sleep -Seconds 2 }
  $dsk=[Environment]::GetFolderPath('Desktop')
  $rac=Join-Path $dsk 'R83_COMPILAZIONE'
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  if(Test-Path $log){ Copy-Item $log $rac -Force }
  @(("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')), ("pin : " + $h), ("ex5 : " + (Test-Path $ex5))) | Set-Content (Join-Path $rac 'REFERTO_COMPILAZIONE.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'R83_COMPILAZIONE.zip') -Force
  if(-not (Test-Path $ex5)){ throw "COMPILAZIONE FALLITA: gli errori sono nel .log copiato in Desktop\R83_COMPILAZIONE. R83 SI FERMA QUI." }
  Write-Host "COMPILATO: $ex5" -ForegroundColor Green
  Write-Host "Ora il PASSO 1b (a mano, in MT5). Da mandare in chat: Desktop\R83_COMPILAZIONE.zip" -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio.** E' il gesto piu' economico che puo' fermare tutto il
resto: **se non compila, R83 non esiste** e si e' perso un minuto, non una
notte. Il `.ex5` vecchio viene **cancellato prima**, cosi' "c'e' il file" non
puo' spacciarsi per "ha compilato".

### PASSO 1b — l'autotest `[3ING][AUTOTEST]` (a mano, MT5 APERTO, 5 min)
Non e' una riga di PowerShell: quelle righe le stampa `OnInit`, e **F7 compila
e basta, non esegue niente** (difetto n.20). Adesso pero' l'EA e' gia'
installato e compilato dal PASSO 1a, quindi:
1. **apri MT5**, Visualizza > Strategy Tester;
2. Expert **ABTG_Apertura_3Ingressi**, simbolo **NASUSD**, periodo **M15**,
   **Test singolo** (NON "Ottimizzazione"), qualche giorno qualsiasi;
3. nei parametri: **`InpEntryMode = 2`** (cosi' si vede anche la riga del
   motore CLOSECONFIRM) e **`InpAutoTest = true`** (e' gia' il default);
   il magic di default e' **777010**, che e' permesso — non metterne uno
   `770xxx`, l'EA si rifiuta di partire apposta;
4. **scheda Journal**: copia in chat le righe che iniziano con `[3ING][AUTOTEST]`.
   Deve esserci **`SEI SU SEI`**.
5. **richiudi MT5** prima del passo dopo.

⚠️ **Mai attaccare l'EA a un grafico**: sul PC di backtest il terminale e'
collegato al conto vivo 50503392.

### PASSO 2 — i due giri a vuoto (non aprono MT5, 2-4 min)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline"
  $dsk=[Environment]::GetFolderPath('Desktop')
  $p="$env:USERPROFILE\lancia_r84.ps1"; $q="$env:USERPROFILE\lancia_r83.ps1"
  Remove-Item $p,$q -Force -EA SilentlyContinue
  irm "$b/lancia_r84.ps1" -OutFile $p -EA Stop
  irm "$b/lancia_r83.ps1" -OutFile $q -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'ROUND 84 - ABLAZIONE DEI FILTRI' -Quiet)){ throw "lancia_r84.ps1 VECCHIO O TRONCO" }
  if(-not (Select-String -Path $q -SimpleMatch -Pattern 'ROUND 83 - DUELLO DEGLI INGRESSI' -Quiet)){ throw "lancia_r83.ps1 VECCHIO O TRONCO" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h -SoloControllo
  if($LASTEXITCODE -ne 0){ throw "R84 GIRO A VUOTO FALLITO: guarda le righe rosse sopra" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $q -Rif $h -SoloControllo
  if($LASTEXITCODE -ne 0){ throw "R83 GIRO A VUOTO FALLITO: guarda le righe rosse sopra" }
  $rac=Join-Path $dsk 'R83_R84_GIRI_A_VUOTO'
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path $rac | Out-Null
  Get-ChildItem "$env:USERPROFILE\r84","$env:USERPROFILE\r83" -Filter "anteprima_*.ini" -EA SilentlyContinue | ForEach-Object { Copy-Item $_.FullName $rac -Force }
  ("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')) | Set-Content (Join-Path $rac 'REFERTO_GIRI_A_VUOTO.txt') -Encoding ASCII
  Compress-Archive -Path (Join-Path $rac '*') -DestinationPath (Join-Path $dsk 'R83_R84_GIRI_A_VUOTO.zip') -Force
  Write-Host "GIRI A VUOTO OK. Da mandare in chat: Desktop\R83_R84_GIRI_A_VUOTO.zip" -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio**: si legge in console `celle per finestra : 2` (le due
passate gemelle) e `parametri in [TesterInputs]`. Se non torna, ci si ferma qui
— costa un minuto, non due ore.

### PASSO 3 — canarino R84, la SOLA cella A (20-60 min [STIMA])
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $p="$env:USERPROFILE\lancia_r84.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r84.ps1" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'ROUND 84 - ABLAZIONE DEI FILTRI' -Quiet)){ throw "SCRIPT VECCHIO O TRONCO" }
  $inizio=Get-Date
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h -Solo A
  if($LASTEXITCODE -ne 0){ throw "CANARINO R84 FALLITO (codice $LASTEXITCODE): NON si lancia la notte" }
  Write-Host ("DURATA VERA DI UNA CELLA: " + [int]((Get-Date)-$inizio).TotalMinutes + " minuti -> le nove celle sono ~" + [int](9*((Get-Date)-$inizio).TotalMinutes/60) + " ore") -ForegroundColor Cyan
  Select-String -Path (Join-Path $dsk 'R84_ABLAZIONE_NASDAQ\REFERTO_RACCOLTA_R84.txt') -Pattern '^data:' | ForEach-Object { $_.Line }
  Write-Host "Quella riga 'data:' deve essere di ADESSO. Da mandare in chat: Desktop\R84_ABLAZIONE_NASDAQ.zip" -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio**: qui nasce **la stima vera** (quella della tabella del
par. 6 e' [STIMA NON MISURATA]) e i numeri della **cella A**, che sono il metro
del canarino di R83.

### PASSO 4 — canarino R83, la sola N0 (20-60 min [STIMA])
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $q="$env:USERPROFILE\lancia_r83.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  Remove-Item $q -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r83.ps1" -OutFile $q -EA Stop
  if(-not (Select-String -Path $q -SimpleMatch -Pattern 'ROUND 83 - DUELLO DEGLI INGRESSI' -Quiet)){ throw "SCRIPT VECCHIO O TRONCO" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $q -Rif $h -Solo "N0"
  if($LASTEXITCODE -ne 0){ throw "CANARINO R83 (a) FALLITO (codice $LASTEXITCODE)" }
  Select-String -Path (Join-Path $dsk 'R83_DUELLO_INGRESSI\REFERTO_RACCOLTA_R83.txt') -Pattern '^data:' | ForEach-Object { $_.Line }
  Write-Host "Da mandare in chat: Desktop\R83_DUELLO_INGRESSI.zip" -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio, ed e' il momento piu' informativo dei due round:**
i numeri di **N0** devono coincidere con quelli della **cella A** del PASSO 3
(Profit, PF, DD, trades). **Se non coincidono si ferma tutto e si cerca il bug
nel codice**, non si spiega a posteriori.

### PASSO 5 — canarino R83 (b): D1 contro V (40-90 min [STIMA])
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $q="$env:USERPROFILE\lancia_r83.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  Remove-Item $q -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r83.ps1" -OutFile $q -EA Stop
  if(-not (Select-String -Path $q -SimpleMatch -Pattern 'ROUND 83 - DUELLO DEGLI INGRESSI' -Quiet)){ throw "SCRIPT VECCHIO O TRONCO" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $q -Rif $h -Solo "D1,V"
  if($LASTEXITCODE -ne 0){ throw "CANARINO R83 (b) FALLITO (codice $LASTEXITCODE)" }
  Select-String -Path (Join-Path $dsk 'R83_DUELLO_INGRESSI\REFERTO_RACCOLTA_R83.txt') -Pattern '^data:' | ForEach-Object { $_.Line }
  Write-Host "Da mandare in chat: Desktop\R83_DUELLO_INGRESSI.zip" -ForegroundColor Cyan
}
```
🛑 **Stop obbligatorio:** **D1** (EA nuovo) e **V** (EA vivo del DAX) devono
coincidere. Se no, il duello sul DAX non si legge.

### PASSO 6 — R84 completo, di NOTTE (9 celle; la durata la sa il PASSO 3)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $p="$env:USERPROFILE\lancia_r84.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r84.ps1" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'ROUND 84 - ABLAZIONE DEI FILTRI' -Quiet)){ throw "SCRIPT VECCHIO O TRONCO" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $p -Rif $h
  if($LASTEXITCODE -ne 0){ throw "R84 INCOMPLETO (codice $LASTEXITCODE): la tabella dice quali CSV mancano. Si rilancia la STESSA riga: le celle gia' fatte non si rifanno." }
  Select-String -Path (Join-Path $dsk 'R84_ABLAZIONE_NASDAQ\REFERTO_RACCOLTA_R84.txt') -Pattern '^data:' | ForEach-Object { $_.Line }
  Write-Host "R84 COMPLETO. Da mandare in chat: Desktop\R84_ABLAZIONE_NASDAQ.zip" -ForegroundColor Cyan
}
```
La cella A **non si rifa'** (l'ha gia' fatta il PASSO 3): il driver salta i CSV
gia' presenti, ed e' voluto. Per rifarla davvero servirebbe `-Rifai`.

### PASSO 7 — R83 completo, la NOTTE DOPO (le 4 celle che mancano)
```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="2458b33415f6120c3bee0cd7f0ba9b9ab26d4d1b"
  $q="$env:USERPROFILE\lancia_r83.ps1"
  $dsk=[Environment]::GetFolderPath('Desktop')
  Remove-Item $q -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/lancia_r83.ps1" -OutFile $q -EA Stop
  if(-not (Select-String -Path $q -SimpleMatch -Pattern 'ROUND 83 - DUELLO DEGLI INGRESSI' -Quiet)){ throw "SCRIPT VECCHIO O TRONCO" }
  $global:LASTEXITCODE=0
  & powershell -ExecutionPolicy Bypass -File $q -Rif $h
  if($LASTEXITCODE -ne 0){ throw "R83 INCOMPLETO (codice $LASTEXITCODE): la tabella dice quali CSV mancano. Si rilancia la STESSA riga." }
  Select-String -Path (Join-Path $dsk 'R83_DUELLO_INGRESSI\REFERTO_RACCOLTA_R83.txt') -Pattern '^data:' | ForEach-Object { $_.Line }
  Write-Host "R83 COMPLETO. Da mandare in chat: Desktop\R83_DUELLO_INGRESSI.zip" -ForegroundColor Cyan
}
```
N0, D1 e V sono gia' fatte dai PASSI 4-5 e vengono saltate: restano **N1, N2,
D0, D2**.

### E se i TICK non ci sono (lo dice il PASSO 0)
Si aggiunge **`-Modello 1 -SaltaPassoZero`** a tutte le righe dei PASSI 3-7, i
CSV escono col suffisso `_ohlc` (non sovrascrivono niente) e **ogni numero
porta scritto "OHLC, non tick"** — su un duello di INGRESSI l'OHLC e'
particolarmente bugiardo, perche' il riempimento e' proprio la cosa che
distingue uno STOP da un LIMIT.

## 6. ⏱️ LE STIME — dichiarate come STIME, e non sono misurate

> ⚠️ **In casa non esiste una misura di quanto costa un backtest a tick reali
> su un indice**: i round tick-reali documentati sono su forex. Quindi i numeri
> qui sotto sono **[STIMA NON MISURATA]** e il **canarino serve proprio a
> sostituirli con un numero vero**.

| passo | stima |
|---|---|
| PASSO 0 (storico + tick, 2 simboli) | **30-180 min** [STIMA] |
| giro a vuoto (per round) | 1-2 min |
| canarino R84 (cella A) | **20-60 min** [STIMA] |
| R84 completo (9 celle) | **3-9 ore** [STIMA] = 9 x il canarino |
| canarino R83 (N0, poi D1+V) | **40-150 min** [STIMA] |
| R83 completo (7 celle) | **2-7 ore** [STIMA] |

**Come si trasformano in numeri veri:** dopo il canarino si guarda l'orologio
e si moltiplica. **Non serve nessun `-TimeoutMin`** per i round:
`walkforward_generico.ps1` lancia MT5 con `WaitForExit()` **senza limite**
(riga 633) — e non gliene aggiungiamo uno, perche' un timeout che ammazza MT5
a meta' e' il difetto n.19 fatto in casa. Il `-TimeoutMin` serve **solo** al
PASSO 0, ed e' nella riga.

## 7. 🗺️ ORDINE CONSIGLIATO SUL PC (domani c'e' anche HistData)

**UNA MACCHINA, UN LAVORO: c'e' un solo MT5.** HistData/Dukascopy e i round
**non possono** girare insieme.

L'ordine e' **esattamente** quello dei PASSI 0-7 del par. 5, che sono numerati
apposta. In breve:

1. **PASSO 0** (MT5 chiuso, 30-180 min). Apre e chiude MT5 da solo.
2. **PASSO 1a compilazione** dell'EA nuovo (MT5 chiuso, 5-10 min) + **PASSO 1b
   autotest** nel tester (MT5 aperto, 5 min, poi si richiude). E' il gesto piu'
   economico che puo' fermare tutto il resto. **Se non compila, si riscrive
   qui e si ricomincia da 1** senza aver bruciato ore.
   ⚠️ **Nessun driver compila l'EA in anticipo**: `walkforward_generico.ps1` lo
   copia in `MQL5\Experts` e lo compila **solo quando parte una corsa vera**
   (riga 567), cioe' troppo tardi. Per questo il PASSO 1a compila da se'.
3. **PASSO 2**, giri a vuoto di R84 e R83 (2-4 min in tutto).
4. **PASSO 3**, canarino R84 cella A → da qui esce la stima vera.
5. **PASSO 4**, canarino R83 N0 → e **subito il confronto con la cella A**. Se
   i numeri non coincidono, **si ferma tutto**: e' il momento piu' informativo
   di entrambi i round e costa un'ora. Poi **PASSO 5** (D1 contro V).
6. **HistData** (se e' la finestra buona: e' lungo e non usa il tester in
   modo esclusivo solo se non tocca MT5 — se lo tocca, va **prima** o
   **dopo**, mai in mezzo a un round).
7. **PASSO 6**, R84 completo (di notte).
8. **PASSO 7**, R83 completo (la notte dopo).

🧊 **E UNA REGOLA DI TRAFFICO NUOVA, per tutta la durata:** dal PASSO 0 alla
fine del PASSO 7 **non si pusha niente su `lavoro`**, soprattutto in
`mql5/Experts/`. Il driver pinna i `.ps1` e i file prova all'hash, ma **gli EA
li riscarica da `lavoro` HEAD** (`walkforward_generico.ps1`, riga 78): un push
a meta' round cambia il motore fra una cella e l'altra, e i canarini di
equivalenza smettono di misurare qualunque cosa. Il PASSO 1a verifica che
`lavoro` e il pin coincidano; da li' in poi e' disciplina.

**Perche' R84 prima di R83:** R84 chiude un **debito gia' aperto** e la sua
cella A e' il **metro** del canarino di R83. Girare R83 per primo vuol dire
avere il duello senza il suo controllo.

## 8. ✅ AUTOVERIFICA — **rifatta dal verificatore sui 22 punti** (18/08 notte)

> 🔴 **L'autoverifica della prima stesura si fermava a 20 punti e su tre di
> quelli si dava ragione da sola.** Corretta qui sotto: le righe **VECCHIE**
> non rispettavano 7, 8, 13, 19.2, 20, 21, 22 (e il punto 6 solo a meta').
> Le righe **NUOVE** del par. 5 li rispettano tutti; **quello che resta
> scoperto e' scritto, non nascosto**:
>
> - **punto 6 (pin) resta parziale per gli EA**: nessuna riga puo' pinnarli,
>   perche' li scarica `walkforward_generico.ps1` da `lavoro` HEAD. Mitigato
>   dal confronto byte a byte del PASSO 1a + dal congelamento del branch;
>   **la correzione vera** e' un `-Rif` che il driver inoltri a
>   `walkforward_generico.ps1`, ed e' una riga di lavoro a se'.
> - **punto 19 (timeout)**: `-TimeoutMin 180` copre la stima 30-180, ma dentro
>   `scarica_storico.ps1` resta la rete dei **15 minuti di silenzio** (riga
>   302) che, proprio durante il download dei TICK, puo' scattare su una corsa
>   sana: allo scadere **ammazza MT5 e non esce 1**. Per questo il PASSO 0
>   controlla le due righe `TICK` invece del solo codice d'uscita.
> - **punto 20**: le sei righe `[3ING][AUTOTEST]` **escono solo eseguendo**.
>   PASSO 1a installa e compila, PASSO 1b le fa uscire nel tester.

| # | punto | come e' stato rispettato |
|---|---|---|
| 1 | apro lo script | letti `lancia_r81/r82`, `walkforward_generico`, i due EA vivi, `scarica_storico` |
| 2 | difetti gemelli | il difetto n.14 di `lancia_r81` (giro a vuoto che esce 0) e' corretto in **tutti e due** i driver nuovi |
| 3 | il file dei parametri e' quello giusto | i 16 file prova **VERIFICANO** una cella congelata, non cercano: unico asse `Y` = i magic gemelli |
| 4 | il SHA contiene la correzione | verificato con `git log -1 -- <file>` su tutti e sette i pezzi |
| 5 | giro a vuoto se c'e' `-Prova` | previsto e obbligatorio in entrambe le righe |
| 5b | cultura invariante | nessun numero dei CSV convertito; le uniche date parsate usano `ParseExact` + `InvariantCulture` |
| 6 | cache di raw ~5 min | pin all'**hash** + marcatore `Select-String` su **ogni** `.ps1` e sul `.mq5`. **Gli EA restano non pinnabili**: vedi il riquadro qui sopra |
| 7 | MT5 chiuso | guardia `Get-Process terminal64` nei due driver **e in ogni blocco del par. 5** (nella bozza vecchia non c'era) + detto in chiaro |
| 8 | l'`irm` che fallisce | i tre pezzi (Remove-Item / `-EA Stop` / marcatore) in **ogni** blocco, e ogni blocco e' **un solo comando** (punto 21) |
| 9 | sicurezza del gemello | i driver nuovi hanno **tutto** quello che ha `lancia_r82` (guardia MT5, pin, marcatori, pulizia anteprime, raccolta, zip, referto con `data:`) **piu'** il PASSO 0 |
| 10 | `Stop` + cicli di file | le copie sono in `try/catch`, il referto si scrive comunque |
| 11 | whitelist vs blacklist | non si sposta nessun file di Claudio |
| 12 | backup senza guardia | nessuno script qui sovrascrive backup |
| 13 | `exit 1` e coda che tira dritto | `$global:LASTEXITCODE=0` **prima**, controllo `-ne 0` **dopo**, su **tutti** i passi (nella bozza vecchia mancava sul PASSO 0 e su tre corse su cinque) |
| 14 | giro a vuoto che esce 0 lo stesso | l'uscita dipende da `$falliti` **e** dalle anteprime prodotte |
| 15 | rilancio mirato che non rilancia | `-Rifai` **inoltrato** al driver e spiegato nel messaggio finale |
| 16 | cache di ripresa avvelenata | nessuna cache di ripresa in questi script |
| 17 | interprete dato per presente | nessuna dipendenza esterna oltre PowerShell e MT5 (quest'ultimo verificato) |
| 18 | profondita' misurata sul TF sbagliato | **e' il PASSO 0**: si legge la riga `TICK`, e il driver **si ferma** se i tick partono dopo la finestra |
| 19 | timeout piu' corto della stima | `-TimeoutMin 180` sul PASSO 0 (stima 30-180); per i round non esiste timeout e il perche' e' scritto. **19.2**: il PASSO 0 non si fida del codice d'uscita e conta le due righe `TICK` |
| 20 | collaudo che con quel tasto non esce | **PASSO 1a** installa e compila (nessun driver lo fa prima di una corsa vera), **PASSO 1b** fa uscire le righe eseguendo un test singolo |
| 21 | blocco multi-riga incollato | ogni passo del par. 5 e' **un solo `& { ... }`**. La bozza vecchia erano 4 blocchi di righe indipendenti: era il difetto di HistData, rifatto |
| 22 | istruzioni sul passo dopo senza artefatti | ogni passo finisce con un **stop dichiarato** e nomina lo zip che deve esistere; i canarini non incollano piu' la corsa completa di seguito |
| 23 | artefatto di INPUT stantio | il PASSO 0 **cancella prima** `Desktop\storico_bcm\ABTG_StoricoScaricato.csv` (i driver lo riaccettano senza guardarne la data: difetto aperto, vedi par. 9) |

## 9. 🧾 COSA RESTA APERTO (dichiarato, non nascosto)

1. **L'EA nuovo non e' compilato.** Primo gesto sul PC.
2. **La profondita' dei tick degli indici e' ignota.** Se non ci sono, i due
   round si girano a `-Modello 1` **e ogni numero porta scritto "OHLC, non
   tick"** (l'illusione OHLC ha gia' revocato una promozione in questa casa).
3. **Il campione sara' sottile.** 21 mesi, un ciclo al giorno: i 150 trade
   dell'Emendamento non sono raggiungibili, e infatti **nessuno dei due round
   SELEZIONA** una cella — confrontano. Sotto 30 operazioni il merito e'
   sospeso (valvola R59), il rischio no.
4. **Un difetto trovato nei motori VIVI, non corretto** (la missione vietava
   di toccarli): in `ArmRetest` e `ArmOpenConfirm` il caso *"range fuori dai
   limiti: niente trade"* torna `true`, la fase diventa `PH_ARMED` e il
   monitor gira lo stesso. Con `InpMinRangePts`/`InpMaxRangePts` a **0** —
   cioe' come girano tutte le nostre celle e le sedie vive — **e' inerte**;
   diventerebbe vivo il giorno in cui qualcuno accendesse quei due filtri di
   ampiezza. Nel codice **nuovo** (modalita' 2) e' scritto giusto, con il
   commento che lo dice. **Va messo in coda come riga a se'.**
5. **Il preset `mql5/Presets/ABTG_Nasdaq_Apertura_US.set` e' piu' vecchio del
   sorgente** (gli mancano meta' degli input di oggi) e dice
   `InpUseNewsFilter=true` mentre in campo era spento. Per questo la cella A
   di R84 e' dichiarata come *"configurazione di riferimento del round"* e
   **non** come *"la sedia viva"*.
6. **Il PASSO 0 dei due driver accetta un referto storico di QUALUNQUE data.**
   `lancia_r84.ps1` riga 196 e `lancia_r83.ps1` riga 189 fanno `Test-Path` su
   `Desktop\storico_bcm\ABTG_StoricoScaricato.csv` e lo leggono: se la sonda e'
   fallita, il file **della settimana scorsa** e' ancora li' e il controllo
   sulla profondita' dei tick passa in silenzio su numeri vecchi. Nelle righe
   del par. 5 e' tappato (il PASSO 0 cancella il file prima di rifarlo), ma la
   correzione vera e' nel driver — **due righe**, da fare quando si ri-pinna:
   ```powershell
   $eta = (New-TimeSpan -Start (Get-Item -LiteralPath $CsvStorico).LastWriteTime -End (Get-Date)).TotalHours
   if($eta -gt 48){ Muori ("il referto storico ha " + [int]$eta + " ore: rifai il PASSO 0 (scarica_storico.ps1) prima di girare.") }
   ```
7. **Gli EA non sono pinnabili dal driver** (`walkforward_generico.ps1` riga
   78 scarica da `lavoro` HEAD e ignora `-Rif`; se il download fallisce usa in
   silenzio la copia in `src_prove\`). Oggi si tappa col confronto del PASSO 1a
   e col congelamento del branch. La correzione vera: `-Rif` inoltrato al
   driver generico, con `-EA Stop` al posto del ripiego silenzioso.
8. **Nessuno dei due round promuove niente.** Il forward passa dal processo
   completo: prova di regime, walk-forward, contratto (DD e frequenza),
   firma di Claudio. E per R83, **al massimo una modalita' per mercato**.

---

_Preparato il 18/08/2026 sera. Commit a pezzi per l'onda di 529: se manca un
pezzo, il git dice esattamente dove ci si era fermati._

---

## PASSO 0 — ESEGUITO E PROMOSSO (18/08, ~21:30, secondo lancio con la cura a4369f1)

Archivio: `risultati_archivio/passo0_tick_indici_2026-08-18.csv`. La misura che
non esisteva in casa ora esiste:

| simbolo | TICK | PrimaDataLocale | verdetto |
|---|---|---|---|
| NASUSD | **164.636.788** | **2024.09.26** | TICK REALI PARZIALI (dal limite server) |
| D30EUR | **34.322.761** | **2024.09.26** | TICK REALI PARZIALI (dal limite server) |

- Le date TICK coincidono ESATTAMENTE col limite noto dello storico BCM
  (@DAQUANDO 2024.09.26): **le finestre dei file prova R83/R84 sono VALIDE**,
  niente da riscrivere.
- Tutte le righe barre partono anch'esse dal 2024.09.26 ("IL BROKER NON HA
  PIU' STORICO" = il server non ha nulla di piu' vecchio: gia' noto, ora
  rimisurato anche per gli indici).
- I round girano a TICK REALI sul perimetro previsto. Il primo lancio delle
  21:17 (fallito per il falso FINITO del guardiano) e' agli atti sopra;
  la cura ha retto al primo colpo.

## PASSO 1a — ESEGUITO E PROMOSSO (18/08, 21:32)

Congelamento verificato (3 EA su lavoro = pin, byte a byte, via doppio irm).
Compilazione ABTG_Apertura_3Ingressi.mq5: **0 errors, 0 warnings, 1689 ms**.
ex5: True. Archivio: `r83_compilazione_2026-08-18.txt`.

## PASSO 1b — ESEGUITO E PROMOSSO (18/08, 21:40-21:45)

Test singolo NASUSD M15 (2026.05.30-06.30, visualizzatore). Journal agli atti
via screenshot in chat:
- `[3ING][AUTOTEST] InpEntryMode=2 -> motore CLOSECONFIRM (market) | magic 777010`
- sei controlli su `DirezioneDaChiusura`: tutti come atteso
- `esito modalita' 2: SEI SU SEI, la regola ragiona come la firma.`
- In campo nel test: `CLOSECONFIRM armato ... Attendo una candela che CHIUDA
  oltre` -> `CLOSECONFIRM BUY: candela chiusa a 29296.50 oltre 29153.50 ->
  entrato a mercato` + breakeven vivo (SL 29297 -> 29319.30) + reset per-giorno.
  Il motore nuovo funziona da capo a fondo nel tester.

## PASSO 2 — ESEGUITO E PROMOSSO (18/08, 21:48)

Giri a vuoto R84 e R83 usciti 0. Anteprime verificate in chat: ore server
8:00/14:30, Model=4 (tick reali), finestra 2024.09.26-2025.06.09, magic
776xxx/777xxx senza collisioni con le sedie vive.

## PASSO 3 — CANARINO R84 PROMOSSO (18/08, 21:55)

- Meccanica: 2 CSV attesi / 0 mancanti, per-trade raccolti, data: fresca.
- DETERMINISMO: magic gemelli 776010/776011 identici al centesimo.
- DURATA VERA: ~6-7 min a cella (21:48 -> 21:55) -> 9 celle ~1 ora.
  Le stime [STIMA NON MISURATA] sono sostituite dalla misura.
- Numeri cella A (scheletro nudo): IS +686,35 PF 1,254 n=156 DD 6,14% |
  OOS -795,03 PF 0,873 n=291 DD 17,07%. Conferma a tick reali del verdetto
  noto sulla 770201: la domanda del round (i filtri salvano lo scheletro?)
  resta alle celle B-I. Campioni sopra n=150 in entrambe le finestre.
- CSV in r84_csv/.

## PASSO 4 — CANARINO DI EQUIVALENZA R83 PROMOSSO (18/08, 21:59)

N0 (EA nuovo, modalita' 0) vs cella A di R84 (EA vivo):
- Totali IDENTICI a ogni decimale (IS 686,35/1,25367/156; OOS -795,03/0,87315/291).
- Per-trade: TUTTI i 291 trade OOS identici (orario al secondo, volume,
  prezzo, profitto) al netto del solo magic. Verificato con diff.
- Il fork del core Nasdaq e' un clone fedele: il duello e' ad armi pari.
  Le modalita' 1 e 2 si potranno leggere come EFFETTO DELL'INGRESSO, unica
  variabile. CSV in r83_csv/.

## PASSO 5 — CANARINO DAX (D1 vs V) PROMOSSO (18/08, 22:08)

D1 (EA nuovo, retest) = V (sedia viva 770101, core DAX) a ogni decimale:
IS 282,12/1,07810/197 | OOS 999,42/1,18776/311, e TUTTI i 311 trade OOS
identici al netto del magic (diff). Due core diversi, stessi trade: il
duello e' ad armi pari anche sul DAX. Nota: la config della sedia viva
su questa finestra e' OOS-positiva (+999, PF 1,19, DD 10,6% a rischio 1%).

## PASSO 6 — R84 COMPLETO (18/08, 22:24) — NOVE SU NOVE NEGATIVE IN OOS

18 CSV / 0 mancanti, gemelli deterministici, CSV in r84_csv/.
OOS (PF/n/DD%): A nudo 0,87/291/17,1 | B volumi 0,95/92/4,6 | C atr
0,97/180/6,7 | D vol-or-atr 0,92/201/6,9 | E ema 0,68/202/15,7 |
F supertrend 0,82/217/10,8 | G st3 0,74/169/13,0 | H corr 0,86/211/10,1 |
I completo 0,79/69/8,9. IS positive su A/C/D/E/H/I (1,25-1,54).
LETTURA (criteri congelati in R84_ABLAZIONE_CRITERI.md): nessun filtro
porta l'OOS sopra PF 1; EMA peggiora il nudo; i filtri comprimono il DD
tagliando trade. Il debito M16 e' CHIUSO: il metodo del corso sul Nasdaq
apertura, misurato a tick reali, non regge — cella I sotto n=150, le
altre no. Referto completo del round da scrivere a valle di R83.

## PASSO 7 — R83 COMPLETO (18/08, 22:30) — IL RETEST VINCE SUL DAX, NIENTE SALVA IL NASDAQ

14 CSV / 0 mancanti, n=156-325 ovunque (Emendamento ok). CSV in r83_csv/.
OOS (Profit/PF/n/DD%):
- DAX:  D0 stop +251/1,04/325/13,3 | D1 retest +999/1,19/311/10,6 (=V, VINCE)
  | D2 conferma -83/0,98/322/8,7
- NASDAQ: N0 stop -795/0,87/291/17,1 | N1 retest -2411/0,62/303/29,1
  | N2 conferma -92/0,98/313/6,2
LETTURE (criteri congelati): (1) sul DAX il duello INCORONA la config viva
(retest) - la divergenza #15 dell'audit ora e' MISURATA a favore del campo;
(2) sul Nasdaq nessuna modalita' e' positiva: con R84 il verdetto e'
unanime, l'apertura US non ha edge a prescindere da ingresso e filtri;
(3) la stessa regola cambia segno tra mercati (retest: oro sul DAX,
massacro sul Nasdaq). Nessuna promozione: il round propone, non promuove.
FINE SEQUENZA NOTTURNA: regola di traffico chiusa, la flotta puo' pushare.
Referti ufficiali R84/R83 e giro architetto v12: domattina.

## REFERTI UFFICIALI SCRITTI (19/08 mattina)

- `REFERTO_ROUND84_ABLAZIONE.md` — tabella 9 celle IS+OOS+totale, lettura
  coi 4 cancelli congelati, debito M16 chiuso. NOTA rispetto alla lettura
  rapida del PASSO 6: applicando i cancelli alla lettera, la cella D
  (volumi OR ATR) li passa tutti e quattro — come RIDUTTORE DI PERDITA
  (OOS resta negativa, PF 0,92), mai come edge. Dichiarato per esteso nel
  referto, nessuna sedia si accende.
- `REFERTO_ROUND83_INGRESSI.md` — canarini riverificati al decimale (N0=A,
  D1=V, per-trade identici al netto del magic), duello per mercato,
  autopsia per-trade del retest Nasdaq (stop pieni da 1R contro vincite da
  0,2R, 11 mesi su 13 negativi, niente code), scoperta trasversale.
  Nessuna promozione.
