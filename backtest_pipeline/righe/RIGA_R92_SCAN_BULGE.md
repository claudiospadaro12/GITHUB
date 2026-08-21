# RIGA DI LANCIO — R92-SCAN BULGE (88 passate)

**Pin PASSO 0/1: `fe430a54381ef09c0c992bcc2b09008ac4d42e3f`** (branch `lavoro`, 21/08/2026) —
gia' eseguiti e passati, non si ritoccano.

**Pin PASSO 3/4: `bdaf3601be53e2d21d38ba22cce239821be0d735`** (branch `lavoro`,
21/08/2026, dopo `b58e05a`) — **CORRETTO il 21/08 pomeriggio**: il pin vecchio
di `scan_market.ps1` per il BULGE girava a `Risk_Percent=1.0` mentre la firma
(R92_CRITERI.md) dice **0,80%**. Bug BLOCCANTE trovato PRIMA del lancio (stessa
classe dell'incidente PASSO 0 di stamattina: un pin vecchio che non porta
l'ultima correzione). Verificato: nessun'altra modifica a `scan_market.ps1` fra
i due commit oltre al rischio, e il file prova (`prove/R92_scan_BULGE.txt`) e'
identico nei due pin.

Criteri **FIRMATI**: `backtest_pipeline/risultati_archivio/R92_CRITERI.md`.

## Cosa deve essere finito PRIMA (una macchina, un lavoro)
Il PC di backtest ha **un solo MT5**. Prima del PASSO 0 e del PASSO 3 **MT5 va
chiuso**: se resta aperto escono **0 CSV** (e i blocchi si fermano da soli).
In coda ci sono ancora la misura tick U30USD e R90: R92 **non li scavalca**.

## Il limite di questo pin, dichiarato
Gli script sono pinnati al commit qui sopra. **L'EA no**: `scan_market.ps1` e
`walkforward_generico.ps1` scaricano `ABTG_Bulge.mq5` dal branch `lavoro`
**com'e' in quel momento** (sta scritto nel loro sorgente, `$EABranch="lavoro"`).
Se qualcuno tocca l'EA mentre gira il round, i numeri non sono piu' di questo pin.

---

## PASSO 0 — LA MISURA CHE MANCA (obbligatoria, MT5 CHIUSO, minuti)

Misura la profondita' delle **barre M1** dei 22 cross. Senza, i numeri di R92
sono **provvisori** (canarino 2.3 dei criteri). `-SenzaTick` perche' lo scan
gira in OHLC: i **tick** sono un'altra misura, piu' lenta, e si fara' **dopo**
e **solo sui simboli selezionati**.

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, -Auto lo pilota lui" }
  $h="fe430a54381ef09c0c992bcc2b09008ac4d42e3f"
  $p="$env:USERPROFILE\scarica_storico.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scarica_storico.ps1" -OutFile $p -EA Stop
  & powershell -ExecutionPolicy Bypass -File $p -Auto -SenzaTick -Da 2022.01.01 -Simboli "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"
}
```
**Raccolta: la fa lo script da solo** -> `Desktop\storico_bcm.zip`.
**Cosa si legge:** l'ultima colonna, riga per riga. `COMPLETO` = si puo' testare
da li'. Se per un cross la data d'inizio e' **dopo il 2022.01.01**, quel cross
gira su mezza finestra: va scritto a referto e il suo `n` non si confronta con
gli altri.

---

## PASSO 1 — GIRO A VUOTO (10 secondi, NON apre MT5)

Controlla che i 48 parametri del file prova esistano davvero nell'EA, che non
ci siano doppioni e che l'unico asse sia la variante del VIOLA (2 celle).

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $h="fe430a54381ef09c0c992bcc2b09008ac4d42e3f"
  $b="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline"
  $d="$env:USERPROFILE\r92"
  New-Item -ItemType Directory -Force -Path (Join-Path $d "prove") | Out-Null
  irm "$b/walkforward_generico.ps1" -OutFile (Join-Path $d "walkforward_generico.ps1") -EA Stop
  irm "$b/prove/R92_scan_BULGE.txt" -OutFile (Join-Path $d "prove\R92_scan_BULGE.txt") -EA Stop
  if(-not (Select-String -Path (Join-Path $d "prove\R92_scan_BULGE.txt") -SimpleMatch -Pattern "22 CROSS, 88 PASSATE" -Quiet)){ throw "file prova VECCHIO o troncato" }
  & powershell -ExecutionPolicy Bypass -File (Join-Path $d "walkforward_generico.ps1") -Expert ABTG_Bulge -Prova (Join-Path $d "prove\R92_scan_BULGE.txt") -Modello 1 -SoloControllo
}
```
**Cosa si legge, e sono tre cose:** `celle per finestra : 2` (le due varianti
del VIOLA) · **nessuna** riga rossa "QUESTI PARAMETRI L'EA NON CE LI HA" ·
**nessuno** sweep degenere. Se una delle tre non torna, **non si va avanti**.

---

## PASSO 2 — LA COMPILAZIONE E LA PASSATA SINGOLA (a mano, in MetaEditor + Tester)

Questo pezzo **non si automatizza, ed e' spiegato perche'**: in ottimizzazione
MT5 **non esegue le Print degli agent**, quindi le righe `[BULGE][AUTOTEST]` e
`[BULGE-CONTA]` **non compariranno nei log delle 88 passate**.

1. MetaEditor -> compila `ABTG_Bulge.mq5`: pretendi **0 errori e 0 warning**
   (questo file non e' mai stato compilato da nessuno: e' nato ieri).
2. Strategy Tester, **una passata singola**: `GBPUSD` · `H1` · modello
   *Ogni tick* o *OHLC M1* (qui non conta) · `Symbols_List=GBPUSD` ·
   `InpAutoTest=true` · `InpVerbose=true`.
3. **Cosa deve esserci nel Giornale**, ed e' il vero collaudo:
   - `[BULGE][AUTOTEST]` tag segnale: **5 PASS**;
   - `[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI` (**18 casi**);
   - `[BULGE][AUTOTEST] VIOLA (...=false EA): rossa=passa verde=passa impulsiva=scarta` -> **PASS**;
   - `[BULGE][AUTOTEST] gestione (b) SPENTA` (coi default);
   - a fine test `[BULGE-CONTA] ... aperture=N -> BLU=x VIOLA=y ARANCIO=z`.
4. **Il canarino:** se `BLU=0`, il round misura **il solo VIOLA**. Non e' un
   difetto del mercato: e' il banco di prova (sta scritto in cima all'EA,
   punto [DA DECIDERE] (a)). Va **detto prima** di leggere le 88 passate.
   *(Il conteggio si potra' rileggere anche dai per-trade raccolti al PASSO 4,
   colonna `signal`: e' il motivo per cui quella colonna e' stata aggiunta.)*

---

## PASSO 3 — LA PROVA DEL BANCO (MT5 CHIUSO, minuti)

Un simbolo solo, tutte e due le gestioni: **4 passate**. Serve a scoprire in
pochi minuti se la macchina produce i CSV, invece di scoprirlo dopo ore.

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="bdaf3601be53e2d21d38ba22cce239821be0d735"
  $d="$env:USERPROFILE\r92"
  New-Item -ItemType Directory -Force -Path $d | Out-Null
  $p=Join-Path $d "scan_market.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scan_market.ps1" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern "MARCATORE_SCAN_BULGE_R92_v1" -Quiet)){ throw "scan_market.ps1 VECCHIO: il BULGE non c'e' dentro" }
  if(-not (Select-String -Path $p -SimpleMatch -Pattern "Risk_Percent=0.8||0.8||0||0.8||N" -Quiet)){ throw "scan_market.ps1 ha il rischio SBAGLIATO (non 0,80%): NON lanciare" }
  & powershell -ExecutionPolicy Bypass -File $p -Robot ABTG_Bulge -SoloSimbolo GBPUSD
}
```
**Cosa si legge:** in `%USERPROFILE%\r92\risultati_scan_ABTG_Bulge\` devono
esserci **2 file** — `scan_ABTG_Bulge_GBPUSD_nuda.csv` e
`scan_ABTG_Bulge_GBPUSD_gestita.csv` — **con 2 righe di dati ciascuno**
(`Use_Purple_PineReaction` 0 e 1). Se un file ha 0 righe, **fermati**: le altre
21 corse darebbero lo stesso niente.

---

## PASSO 4 — LE 88 PASSATE + RACCOLTA (MT5 CHIUSO, lungo)

GBPUSD viene **saltato** (gia' fatto al PASSO 3: e' la ripresa, non un errore).

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  if(Get-Process -Name terminal64 -EA SilentlyContinue){ throw "MT5 E' APERTO: chiudilo, altrimenti escono 0 CSV" }
  $h="bdaf3601be53e2d21d38ba22cce239821be0d735"
  $d="$env:USERPROFILE\r92"
  $p=Join-Path $d "scan_market.ps1"
  Remove-Item $p -Force -EA SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/backtest_pipeline/scan_market.ps1" -OutFile $p -EA Stop
  if(-not (Select-String -Path $p -SimpleMatch -Pattern "MARCATORE_SCAN_BULGE_R92_v1" -Quiet)){ throw "scan_market.ps1 VECCHIO: il BULGE non c'e' dentro" }
  if(-not (Select-String -Path $p -SimpleMatch -Pattern "Risk_Percent=0.8||0.8||0||0.8||N" -Quiet)){ throw "scan_market.ps1 ha il rischio SBAGLIATO (non 0,80%): NON lanciare" }
  & powershell -ExecutionPolicy Bypass -File $p -Robot ABTG_Bulge
  $dsk=[Environment]::GetFolderPath("Desktop")
  $rac=Join-Path $dsk "R92_SCAN_BULGE"
  Remove-Item $rac -Recurse -Force -EA SilentlyContinue
  New-Item -ItemType Directory -Force -Path (Join-Path $rac "csv"),(Join-Path $rac "ini"),(Join-Path $rac "pertrade") | Out-Null
  Get-ChildItem (Join-Path $d "risultati_scan_ABTG_Bulge") -Filter "*.csv" -EA SilentlyContinue | ForEach-Object { Copy-Item $_.FullName (Join-Path $rac "csv") -Force }
  Get-ChildItem (Join-Path $d "ini_scan") -Filter "scan_ABTG_Bulge_*.ini" -EA SilentlyContinue | ForEach-Object { Copy-Item $_.FullName (Join-Path $rac "ini") -Force }
  $com=Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
  Get-ChildItem $com -Filter "abtg_trades_ABTG_Bulge_*.csv" -EA SilentlyContinue | ForEach-Object { Copy-Item $_.FullName (Join-Path $rac "pertrade") -Force }
  $nCsv=@(Get-ChildItem (Join-Path $rac "csv") -Filter "*.csv").Count
  $nIni=@(Get-ChildItem (Join-Path $rac "ini") -Filter "*.ini").Count
  $nPt =@(Get-ChildItem (Join-Path $rac "pertrade") -Filter "*.csv").Count
  $righe=0
  Get-ChildItem (Join-Path $rac "csv") -Filter "*.csv" | ForEach-Object { $righe += (@(Get-Content $_.FullName).Count - 1) }
  $ref=@()
  $ref+=("data: " + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
  $ref+=("pin:  " + $h)
  $ref+=("CSV di scan: " + $nCsv + "   (attesi 44 = 22 simboli x 2 gestioni)")
  $ref+=("righe di dati totali: " + $righe + "   (attese 88 = 44 x 2 varianti del VIOLA)")
  $ref+=("ini generati: " + $nIni + "   (attesi 44)")
  $ref+=("per-trade: " + $nPt + "   (attesi 88, uno per passata)")
  $ref | Set-Content (Join-Path $rac "REFERTO_R92_SCAN.txt") -Encoding ASCII
  $zip=Join-Path $dsk "R92_SCAN_BULGE.zip"
  Remove-Item $zip -Force -EA SilentlyContinue
  Compress-Archive -Path (Join-Path $rac "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host "=====================================================================" -ForegroundColor White
  Write-Host "  FINITO. Da verificare, uno per uno:" -ForegroundColor White
  Write-Host ("   " + (Join-Path $rac "REFERTO_R92_SCAN.txt") + "   <- leggi QUESTO per primo") -ForegroundColor White
  Write-Host ("   CSV di scan: " + $nCsv + " (attesi 44)  righe dati: " + $righe + " (attese 88)") -ForegroundColor White
  Write-Host ("   ini: " + $nIni + " (attesi 44)   per-trade: " + $nPt + " (attesi 88)") -ForegroundColor White
  Write-Host ("   " + $zip + "   <- questo si manda in chat") -ForegroundColor White
  Write-Host "=====================================================================" -ForegroundColor White
}
```

**I numeri attesi, scritti prima:** 44 CSV · 88 righe di dati · 44 ini · 88
per-trade. Se un numero non torna, **si dice quale** invece di leggere i
risultati: un CSV mancante e' un simbolo senza storico, non un simbolo senza
segnale.

---

## E DOPO: quello che il round **non** puo' fare
- **Lo scan non promuove niente** (regola zero dei criteri): seleziona chi va al
  round profondo a tick reali. Al massimo **6 simboli**, e solo in **famiglia**
  (un cross che passa da solo, coi parenti sotto, e' un picco isolato = rumore).
- Le soglie si applicano **alla cella base** (`_nuda`, `Use_Purple_PineReaction=0`).
  Le altre tre celle si leggono come **confronto**, non come candidate parallele:
  scegliere il meglio di quattro sarebbe pescare.
- **Nessun deploy**, nessun `.set`, nessuna sedia. R92 e' un banco.
