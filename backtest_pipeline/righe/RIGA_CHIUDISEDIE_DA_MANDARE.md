# 🧯 RIGA DI LANCIO — ABTG_ChiudiSedie (spegnere le sedie revocate, senza toccare il resto)

**Pin: `360a36c111333e820fdc3e1124352ea4b61aa22c`** (branch `lavoro`).
Sorgente: `mql5/Scripts/ABTG_ChiudiSedie.mq5`.

> 🔒 **IL PIN E' SCRITTO** nelle **tre** occorrenze (l'intestazione qui sopra,
> il PASSO 1, il PASSO 3). Tutti e due i blocchi hanno dentro una guardia che
> si rifiuta di partire se `$h` non e' un SHA da 40 caratteri esadecimali:
> serve perche' un segnaposto non possa finire in console per distrazione
> (checklist punto 4 + punto 63, regola 2: _"se il parse/pin non si puo'
> scrivere, la riga non esce col pin scritto"_).
> **Se lo script viene ritoccato, il pin va rifatto in tutte e tre.**

---

## Che cos'e', in tre righe

Uno **Script** MQL5 che chiude le **posizioni** e cancella gli **ordini
pendenti** di una lista di **magic**, e nient'altro. Nasce dalla serata del
**24/08**: quattro sedie spente a mano, una posizione rimasta orfana, chiusa
poi dallo SL. E' finita bene per fortuna, e la fortuna non e' una procedura.

**Le tre sicure** (le prime due sono la richiesta, la terza e' emersa
scrivendolo):
1. `InpMagics` **vuoto** = solo **censimento**: stampa tutto e non tocca niente;
2. `InpEseguiDavvero = false` (default) = non tocca niente comunque;
3. `InpChiediConferma = true` (default) = finestra di conferma con conto,
   numeri ed elenco dei magic prima di agire. **Serve perche' MT5 si ricorda
   i valori dell'ultimo lancio nella finestra dello script**: al rilancio
   `InpEseguiDavvero` e' ancora `true` e i magic vecchi sono ancora scritti.

> 📛 Nota sul marcatore: nel log si legge
> `ABTG_ChiudiSedie v1.01 - due sicure + esito a tre stati`. **Due** sono le
> sicure richieste (la terza, la conferma a schermo, e' nata scrivendo lo
> script): il conteggio nel marcatore e' storico, non aritmetico.
> La **v1.01** aggiunge il terzo stato dell'esito finale — vedi il PASSO 2.

> ⚠️ **Questa riga NON ha la guardia MT5-chiuso, ed e' voluto.** Sul VPS il
> terminale **e' il forward**: non si chiude. `metaeditor64` compila
> benissimo col terminale aperto, e questa riga non scrive dentro `config\`
> ne' dentro i `.chr` (il divieto del punto 7 della checklist riguarda quelli).
> **Chiudi invece MetaEditor, se e' aperto** (punto 39-bis: MetaEditor e'
> single-instance, e il suo Navigatore non si accorge dei file nuovi).

---

## PASSO 1 — INSTALLA E COMPILA (MT5 resta APERTO)

Scarica il sorgente **dal pin**, verifica il **marcatore di versione** (contro
la cache di `raw`, ~5 minuti), **verifica che le due sicure siano davvero nel
file che si sta installando**, rifiuta qualunque `#include` che non sia la
libreria standard, copia in `MQL5\Scripts` di **ogni** cartella dati e
**compila una volta per cartella dati** (punto 27: si installa in N posti, si
compila in N posti — l'`.ex5` sta accanto al sorgente e MT5 nel Navigatore
elenca gli `.ex5`, non i `.mq5`).

**Incolla il blocco INTERO, graffe comprese** (punto 21: tre righe una sotto
l'altra non sono un programma).

```powershell
& {
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
  $h="360a36c111333e820fdc3e1124352ea4b61aa22c"
  if($h -notmatch '^[0-9a-f]{40}$'){ throw "PIN NON SCRITTO: sostituisci il segnaposto con lo SHA del commit" }
  $src="$env:USERPROFILE\ABTG_ChiudiSedie.mq5"
  Remove-Item $src -Force -ErrorAction SilentlyContinue
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$h/mql5/Scripts/ABTG_ChiudiSedie.mq5" -OutFile $src -ErrorAction Stop
  if(-not (Select-String -Path $src -SimpleMatch -Pattern 'ABTG_ChiudiSedie v1.01 - due sicure + esito a tre stati' -Quiet)){ throw "sorgente VECCHIO o troncato (cache di raw): riprova fra 5 minuti" }
  if(-not (Select-String -Path $src -Pattern '^input\s+string\s+InpMagics\s*=\s*""\s*;' -Quiet)){ throw "PRIMA SICURA ASSENTE nel sorgente: non si installa" }
  if(-not (Select-String -Path $src -Pattern '^input\s+bool\s+InpEseguiDavvero\s*=\s*false\s*;' -Quiet)){ throw "SECONDA SICURA ASSENTE nel sorgente: non si installa" }
  $inc=@(Select-String -Path $src -Pattern '^#include|^#import' | ForEach-Object { $_.Line.Trim() })
  $estranei=@($inc | Where-Object { $_ -ne '#include <Trade\Trade.mqh>' })
  if($estranei.Count -gt 0){ throw ("DIPENDENZA NON STANDARD: " + ($estranei -join ' | ')) }
  $len=(Get-Item $src).Length
  $root=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dati=@(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") })
  if($dati.Count -eq 0){ throw "nessuna cartella dati MT5 trovata" }
  Write-Host ("cartelle dati da servire: " + $dati.Count)
  $fatti=0; $saltati=@()
  foreach($d in $dati){
    $o=Join-Path $d.FullName "origin.txt"
    if(-not (Test-Path $o)){ $saltati += ($d.Name + " : niente origin.txt"); continue }
    $raw=[IO.File]::ReadAllBytes($o)
    $inst=([Text.Encoding]::UTF8.GetString($raw) -replace "[\u0000\uFEFF]","").Trim()
    if(-not (Test-Path (Join-Path $inst "metaeditor64.exe"))){ $inst=([Text.Encoding]::Unicode.GetString($raw) -replace "[\uFEFF]","").Trim() }
    $me=Join-Path $inst "metaeditor64.exe"
    if(-not (Test-Path $me)){ $saltati += ($d.Name + " : metaeditor64.exe non trovato in " + $inst); continue }
    $dst=Join-Path $d.FullName "MQL5\Scripts"
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    $mq=Join-Path $dst "ABTG_ChiudiSedie.mq5"
    Copy-Item -LiteralPath $src -Destination $mq -Force -ErrorAction Stop
    $v=Get-Item -LiteralPath $mq -ErrorAction Stop
    if($v.PSIsContainer -or $v.Length -ne $len){ throw ("COPIA NON VERIFICATA in " + $dst) }
    $ex=[System.IO.Path]::ChangeExtension($mq,".ex5")
    $exPrima=$null
    if(Test-Path -LiteralPath $ex){ $exPrima=(Get-Item -LiteralPath $ex).LastWriteTime }
    Remove-Item -LiteralPath $ex -Force -ErrorAction SilentlyContinue
    if(Test-Path -LiteralPath $ex){ throw ("EX5 VECCHIO NON CANCELLABILE in " + $dst + " (del " + $exPrima + "): qualcuno lo tiene aperto. NON compilo: un ex5 vecchio che sopravvive si spaccia per nuovo.") }
    $t0=(Get-Date).AddSeconds(-2)
    & $me ("/compile:"+$mq) "/log" | Out-Null
    while((-not (Test-Path -LiteralPath $ex)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
    if(-not (Test-Path -LiteralPath $ex)){
      Get-Content ([System.IO.Path]::ChangeExtension($mq,".log")) -ErrorAction SilentlyContinue | Select-Object -Last 40
      throw ("COMPILAZIONE FALLITA in " + $dst + " -- sopra le ultime righe del log. Se MetaEditor era aperto, chiudilo e rilancia.")
    }
    $exDopo=(Get-Item -LiteralPath $ex).LastWriteTime
    if($exDopo -lt $t0){
      Get-Content ([System.IO.Path]::ChangeExtension($mq,".log")) -ErrorAction SilentlyContinue | Select-Object -Last 40
      throw ("EX5 NON RIGENERATO in " + $dst + ": e' del " + $exDopo + ", la compilazione e' partita alle " + $t0 + ". Il binario e' VECCHIO sotto un sorgente NUOVO (checklist 54): NON usare lo script.")
    }
    $fatti++
    Write-Host ("  OK  " + $d.Name + "   sorgente " + $v.Length + " byte   ex5 " + (Get-Item $ex).Length + " byte   scritto " + $exDopo)
  }
  foreach($s in $saltati){ Write-Host ("  SALTATA  " + $s) -ForegroundColor Yellow }
  Write-Host ("INSTALLATO E COMPILATO IN: " + $fatti + " cartelle dati su " + $dati.Count)
  if($fatti -eq 0){ throw "nessuna installazione riuscita" }
  if($fatti -ne $dati.Count){ Write-Host "ATTENZIONE: non tutte le cartelle dati sono servite (elenco SALTATA qui sopra)." -ForegroundColor Yellow }
}
```

**Cosa si legge, e sono quattro cose:**
1. una riga `OK` **per ogni cartella dati**, con **byte del sorgente**, **byte
   dell'`.ex5`** e **l'ora in cui l'`.ex5` e' stato scritto** — quell'ora deve
   essere di **adesso** (punto 27-ter: la copia si verifica sul contenuto, non
   sul nome; punto 54: un `.ex5` vecchio sopravvissuto si spaccia per nuovo);
2. `INSTALLATO E COMPILATO IN: N cartelle dati su N` — **i due numeri devono
   coincidere**; se non coincidono, guarda le righe `SALTATA`;
3. **zero** righe rosse del compilatore;
4. nessun `throw`.

---

## PASSO 2 — L'USO, A MANO (ed e' spiegato perche')

Uno Script si esegue **trascinandolo su un grafico**. Non esiste un driver che
lo faccia partire senza pilotare il terminale, e il terminale del VPS **sta
operando**: pilotarlo e' esattamente il gesto che la checklist vieta
(punto 26: _"cosa tocca, oltre allo schermo?"_).

### 2a — PRIMO LANCIO: CENSIMENTO (non tocca niente)

1. In MT5: **Navigatore → Script → tasto destro → Aggiorna**. Deve comparire
   **`ABTG_ChiudiSedie`**. Se non c'e': il PASSO 1 non e' andato su **questo**
   terminale (rileggi le righe `OK`, cartella per cartella).
2. Trascinalo su **un grafico qualsiasi** — il simbolo del grafico **non
   conta**: legge posizioni e ordini del **conto**.
3. Nella finestra: **lascia tutto com'e'** e premi **OK**.
   Per il censimento la spunta del trading **non serve**.
4. Guarda la scheda **ESPERTI** (non il Giornale — punto 25, corollario: i
   `Print()` di uno script stanno in Esperti e in `MQL5\Logs\<data>.log`).

**Cosa deve esserci:**

| # | riga attesa | se manca |
|---|---|---|
| 1 | `ABTG_ChiudiSedie v1.01 - due sicure + esito a tre stati` + `conto : <login> <server> (DEMO, HEDGING)` | **fermati**: e' il terminale sbagliato o l'`.ex5` e' vecchio |
| 2 | `InpMagics e' VUOTO -> MODALITA' CENSIMENTO (default sicuro).` | se non c'e', qualcuno ha lasciato dei magic nella finestra |
| 3 | la tabella `POSIZ. / PENDEN.` con magic, ticket, tipo, volume, prezzo, P/L | conto vuoto = `NIENTE DA ELENCARE` |
| 4 | `--- RIEPILOGO PER MAGIC ---` | **e' da qui che si copiano i numeri** |
| 5 | `NON HO TOCCATO NIENTE. Servono TUTTE E DUE le sicure` | se non c'e', **non era un censimento**: leggi cos'ha fatto |

> ⚠️ Le operazioni **manuali** hanno **magic 0** e nel riepilogo sono marcate
> `<-- MANUALE`. Lo 0 si tocca **solo** se lo scrivi tu nella lista.

### 2b — SECONDO LANCIO: LO SPEGNIMENTO

Trascina di nuovo lo script e compila la finestra:

| input | valore | perche' |
|---|---|---|
| `InpMagics` | i magic della revisione firmata, es. `770611,250604` | copiati dal **riepilogo per magic** del punto 4 |
| `InpEseguiDavvero` | **true** | seconda sicura |
| `InpContoAtteso` | il **login** del terminale su cui stai lavorando | terza rete: se sbagli terminale, si ferma da solo |
| `InpChiediConferma` | **true** (lascialo) | la finestra di conferma |
| scheda **Comune** | ✅ **Consenti trading algoritmico** | senza, lo script lo dice e si ferma |

Poi: **leggi la finestra di conferma** (conto, quante posizioni, quanti
pendenti, quali magic) e solo allora **Si'**.

**Cosa si legge dopo, e sono tre cose:**
1. una riga **per ogni ticket**, con esito e **retcode**;
2. il `RIEPILOGO` — `CHIUSE / CANCELLATI / gia' spariti / MERCATO CHIUSO / FALLITI`;
3. il `CONTROLLO FINALE`, che ha **tre** esiti e non due:

| esito | vuol dire | cosa fai |
|---|---|---|
| `ESITO: PULITO` | c'era roba di quei magic e adesso non c'e' piu' | revisione chiusa (ma stacca gli EA a mano) |
| `ESITO: NON PULITO` | e' rimasto qualcosa | leggi i retcode riga per riga, **non** dichiarare chiusa la revisione |
| `ESITO: NIENTE DA FARE` | la lista **non corrispondeva a niente di aperto**: lo script non ha chiuso NULLA | o e' una **verifica** dopo una corsa gia' andata bene, **o hai sbagliato i magic**. Torna al `RIEPILOGO PER MAGIC` del censimento e **ricontrolla i numeri** |

> ⛔ **Il terzo esito e' la ragione della v1.01.** Con un magic sbagliato di una
> cifra la corsa non trova niente, non tocca niente — e fino alla v1.00
> stampava lo stesso `ESITO: PULITO`, cioe' dichiarava finito un lavoro mai
> cominciato mentre la posizione orfana della sedia vera restava viva. E' *lo
> stesso incidente del 24/08* che questo attrezzo doveva impedire.

> 🕐 **Mercato chiuso non e' un errore.** Lo script lo scrive
> (`MERCATO CHIUSO, rilancia piu' tardi`), **tira dritto con gli altri
> simboli** e lo conta nel riepilogo. Si rilancia a mercato aperto, e allora
> `ESITO: PULITO`.
> 🖥️ **Due terminali = due conti.** Se le sedie da spegnere stanno su
> entrambi, il PASSO 2 si rifa' **sul secondo terminale**, con il suo
> `InpContoAtteso`.
> 🔌 **Chiudere le posizioni NON stacca l'EA dal grafico.** Se la sedia e'
> revocata, staccare l'EA resta un gesto a mano — altrimenti riapre.

---

## PASSO 3 — RACCOLTA (subito dopo)

Controlla che il referto **esista e sia FRESCO** (non quello di una corsa
precedente: il file ha un nome fisso e viene riscritto ogni volta), lo copia
sul Desktop con un **nome proprio e datato** e crea lo zip.

```powershell
& {
  $h="360a36c111333e820fdc3e1124352ea4b61aa22c"
  if($h -notmatch '^[0-9a-f]{40}$'){ throw "PIN NON SCRITTO" }
  $root=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dati=@(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") })
  $stamp=Get-Date -Format "yyyy-MM-dd_HHmm"
  $dest=Join-Path ([Environment]::GetFolderPath("Desktop")) ("chiudi_sedie_" + $stamp)
  Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  $trovati=0
  foreach($d in $dati){
    $f=Join-Path $d.FullName "MQL5\Files\ABTG_ChiudiSedie_report.txt"
    if(-not (Test-Path -LiteralPath $f)){ continue }
    $eta=((Get-Date)-(Get-Item -LiteralPath $f).LastWriteTime).TotalMinutes
    if($eta -gt 60){ Write-Host ("  STANTIO (" + [int]$eta + " min): " + $d.Name + " -- e' di un'altra corsa, NON lo copio") -ForegroundColor Yellow; continue }
    Copy-Item -LiteralPath $f -Destination (Join-Path $dest ("report_" + $d.Name.Substring(0,[math]::Min(8,$d.Name.Length)) + ".txt")) -Force
    $trovati++
  }
  if($trovati -eq 0){ throw "NESSUN REFERTO FRESCO: lo script non e' stato eseguito, oppure e' stato eseguito piu' di un'ora fa" }
  foreach($d in $dati){
    $log=Get-ChildItem (Join-Path $d.FullName "MQL5\Logs") -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if($log){ Copy-Item $log.FullName (Join-Path $dest ("esperti_" + $d.Name.Substring(0,[math]::Min(8,$d.Name.Length)) + "_" + $log.Name)) -Force }
  }
  $zip=$dest + ".zip"
  Remove-Item $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Get-ChildItem $dest | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
  Write-Host ("referti freschi trovati: " + $trovati)
  Write-Host ("ZIP PRONTO DA MANDARE -> " + $zip)
}
```

**File attesi nella cartella** (controllali per nome, prima di mandare):
- `report_<8 caratteri>.txt` — **uno per terminale su cui hai eseguito**;
- `esperti_<8 caratteri>_<data>.log` — il log Esperti piu' recente.

> 🧭 **La data dentro il referto:** la prima riga dice `data: ...` in **ora
> LOCALE del PC** e la riga dopo `ora server`. Quella `data:` deve essere di
> **adesso** (punto 13). Se e' vecchia, stai guardando la corsa di ieri.
> 🕰️ E vale la regola di casa sulle ore: **log e Desktop = ora italiana,
> grafico e `ora server` = un'ora indietro**.

---

## ⚠️ RISCHIO RESIDUO DICHIARATO

**Il `.mq5` non e' mai stato compilato** da chi lo ha scritto: in questo
ambiente non c'e' MetaEditor. Sono state fatte solo verifiche statiche
(bilanciamento di graffe/tonde/stringhe ignorando commenti = 0/0, ASCII puro,
guardie di installazione provate **eseguendole** sul sorgente vero, compresa
la controprova negativa su una sicura manomessa). **Il primo giro a vuoto e'
la compilazione del PASSO 1**: se torna rossa, si corregge e si ripinna, e
nessuno tocca il conto prima.
