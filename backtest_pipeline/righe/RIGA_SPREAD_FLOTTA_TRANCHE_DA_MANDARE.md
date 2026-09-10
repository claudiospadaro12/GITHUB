# 💸 SPREAD ORARIO — LE 5 TRANCHE CHE MANCANO (225JPY · oro · 10 forex) — DA MANDARE

> 🎯 **Criteri congelati PRIMA dei numeri:**
> `backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md`.
> Leggerlo prima di mandare queste righe: contiene le soglie, il verso
> dell'errore, e la lista delle **cinque sedie che ribaltano il verdetto**.

**Che cos'e'.** Le stesse identiche righe del **03/09** che hanno prodotto
`spread_orario_{D30EUR,U30USD,NASUSD}.csv`, rilanciate con una **lista di
simboli diversa**. 🟢 **Nessuno script nuovo, nessun `.mq5` nuovo, nessuna
riscrittura**: lo strumento e' gia' multi-simbolo (`ABTG_SpreadOrario.mq5`
r.54 `input string InpSimboli`) e la riga accetta gia' `-Simboli` e
`-PuntiPerIndice` nel suo `param()`.

> ✅ **Verificato prima di scrivere questa pagina**: `RIGA_SPREAD_FLOTTA.ps1` e
> `ABTG_SpreadOrario.mq5` al pin `e1c81430...` sono **byte per byte identici a
> HEAD** (`git diff` vuoto su tutti e due). Si riusa **lo stesso pin gia'
> collaudato il 03/09** — quindi nessun codice nuovo passa dal cancello, e non
> c'e' nessun `.ps1` da riscrivere (nessun rischio emoji/ANSI).
> ✅ E il pin **copre anche il motore**: la riga scarica `ABTG_SpreadOrario.mq5`
> da `$RawPin` (r.291) e ne verifica il marcatore prima di compilare — quindi
> **non c'e' la classe 24** (pin che non copre il pezzo importante).

---

## 🛑🛑🛑 SOLO SUL **PC DI BACKTEST** — MAI SUL VPS 🛑🛑🛑

La riga **apre e chiude MT5 da sola**. Sul VPS spegnerebbe il terminale che
tiene su la flotta in forward. Se trova MT5 gia' aperto **esce 1 e lo dice**
(non lo ammazza). Da lanciare **con MT5 e MetaEditor CHIUSI**.

---

## 🔴 LA REGOLA CHE NON SI PUO' SALTARE: UNA TRANCHE PER VOLTA

`InpPuntiPerIndice` e' **UNO SOLO PER CORSA** (r.57 del `.mq5`). Mescolare
simboli con `Digits` diversi nella stessa corsa **produce una tabella
plausibile e falsa** — lo stesso difetto da fattore 100 che
`CANCELLO_COSTO_FLOTTA` §3 dichiara. Quindi: **si spezza per classe di
`Digits`, e si raccoglie dopo ogni tranche.**

⚠️ **E soprattutto:** il motore riscrive `REFERTO_SPREAD_FLOTTA.txt` **da zero**
a ogni corsa. I CSV per simbolo no (nomi diversi), **il referto .txt SI'**.
👉 **Servono tutti e cinque gli zip**, uno per tranche. Non se ne salta nessuno.

| tranche | simboli | `-PuntiPerIndice` | unita' del CSV | perche' in quest'ordine |
|---|---|---:|---|---|
| **T1** | `225JPY` | **1** | punto Nikkei | 4 sedie oggi NON MISURATE, due a **13,6x/13,7x** (il pavimento DURO e' 13,3x). Base tick piccola = corsa breve. **La piu' redditizia** |
| **T2** | `EURUSD,GBPUSD,USDJPY` | **10** | **pip** | contiene `771202`, `771203`, `772422`, `772162` |
| **T3** | `EURJPY,GBPJPY,CHFJPY` | **10** | **pip** | contiene `771201`, `772361`, e **2 dei 3 simboli con `SpreadPt = 0`** |
| **T4** | `EURCAD,GBPCAD,AUDUSD,EURAUD` | **10** | **pip** | ore modali **h00-h04**: dove il verso dell'errore morde di piu' |
| **T5** | `XAUUSD` | **100** | **dollaro** | 520 operazioni, ma tutte passano con margini +216%/+490%: urgenza bassa |

> 🏷️ **All'archiviazione i CSV vanno rinominati con l'unita' dentro il nome**
> (`spread_orario_EURUSD_PIP.csv`, `spread_orario_225JPY_PTINIKKEI.csv`,
> `spread_orario_XAUUSD_USD.csv`): le colonne del CSV si chiamano `media_idx` /
> `mediana_idx` / `p95_idx` **in tutte le corse**, perche' il motore non sa in
> che unita' sta lavorando. 🔴 **Lasciarle `_idx` su un file di pip e' una
> trappola di lettura**, ed e' la classe di difetto che questo progetto ha gia'
> pagato due volte.

---

## 🧪 IL CONTROLLO DI REGRESSIONE — obbligatorio, e va fatto sul PRIMO risultato

Prima di credere a un solo numero delle tranche nuove: la stessa macchina, con
divisore **100**, **deve** riprodurre i tre indici gia' in archivio.
👉 Se in T5 (XAUUSD, divisore 100) il referto `.txt` dichiara la stessa
conversione e la stessa struttura del 03/09, la catena e' sana.
👉 E su **ogni** tranche: **`blocchi persi` deve essere 0**. Se e' > 0 la
tabella e' **PARZIALE**, il verdetto **NON si da'**, e si riscarica lo storico
con `ABTG_HistoryDownloader` prima di rifare.

---

## 1️⃣ T1 — 225JPY (divisore **1**) — LA PIU' IMPORTANTE

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='e1c81430c8ba1b4f835cbeb7927f400d54501da1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli "225JPY" -PuntiPerIndice 1 -TimeoutMin 240; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE, 1 = fermata prima): mandala lo stesso, il parziale non si butta.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    Write-Host 'T1 = 225JPY, unita del CSV = PUNTO NIKKEI (divisore 1). Controlla nel referto: blocchi persi = 0.' -ForegroundColor Gray }
```

## 2️⃣ T2 — EURUSD · GBPUSD · USDJPY (divisore **10** = pip)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='e1c81430c8ba1b4f835cbeb7927f400d54501da1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli "EURUSD,GBPUSD,USDJPY" -PuntiPerIndice 10 -TimeoutMin 600; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE): mandala lo stesso, e sotto ci sono i simboli da riprendere.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    Write-Host 'T2 = 3 major, unita del CSV = PIP (divisore 10), NON punti indice, comunque si chiamino le colonne. Controlla: blocchi persi = 0.' -ForegroundColor Gray }
```

## 3️⃣ T3 — EURJPY · GBPJPY · CHFJPY (divisore **10** = pip)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='e1c81430c8ba1b4f835cbeb7927f400d54501da1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli "EURJPY,GBPJPY,CHFJPY" -PuntiPerIndice 10 -TimeoutMin 600; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE): mandala lo stesso.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    Write-Host 'T3 = 3 cross JPY, unita del CSV = PIP (divisore 10). Sono 2 dei 3 simboli che la sonda del 17/08 leggeva ZERO. Controlla: blocchi persi = 0.' -ForegroundColor Gray }
```

## 4️⃣ T4 — EURCAD · GBPCAD · AUDUSD · EURAUD (divisore **10** = pip)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='e1c81430c8ba1b4f835cbeb7927f400d54501da1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli "EURCAD,GBPCAD,AUDUSD,EURAUD" -PuntiPerIndice 10 -TimeoutMin 600; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE): mandala lo stesso.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    Write-Host 'T4 = 4 simboli, unita del CSV = PIP (divisore 10). Le ore che contano qui sono 00-08, non 15-17. Controlla: blocchi persi = 0.' -ForegroundColor Gray }
```

## 5️⃣ T5 — XAUUSD (divisore **100** = dollaro) — e serve da REGRESSIONE

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia (questa riga apre MT5 da sola).' };
    $pin='e1c81430c8ba1b4f835cbeb7927f400d54501da1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREAD_FLOTTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_FLOTTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_FLOTTA_v3' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simboli "XAUUSD" -PuntiPerIndice 100 -TimeoutMin 480; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*\RIGA_REFERTO_SPREAD_FLOTTA.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI RIGA DI ADESSO sul Desktop: la corsa non e'' arrivata alla raccolta -- copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem (Join-Path $env:USERPROFILE 'Desktop\SPREAD_FLOTTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'MISURA NON COMPLETA (2 = PARZIALE e RIPRENDIBILE): mandala lo stesso.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    Write-Host 'T5 = XAUUSD, unita del CSV = DOLLARO (divisore 100). Attesa: ora 07 (la sedia 770402 lavora li 9 volte su 9). Controlla: blocchi persi = 0.' -ForegroundColor Gray }
```

---

## 🔁 SE UNA TRANCHE ESCE **2 = PARZIALE**

La riga stampa da sola il **BLOCCO DI RIPRESA** con i soli simboli mancanti.
Si rilancia **quello**, con **lo stesso `-PuntiPerIndice` della tranche**.
🔴 **Il `REFERTO_SPREAD_FLOTTA.txt` di una ripresa contiene SOLO i simboli
ripresi** (il motore lo riscrive da zero): servono **tutti e due** gli zip.

## 📋 COSA CONTROLLARE IN OGNI ZIP, PRIMA DI DIRE CHE E' BUONO

| controllo | dove | valore atteso |
|---|---|---|
| **blocchi persi** | `REFERTO_SPREAD_FLOTTA.txt`, per simbolo | **0**. Se > 0 → tabella parziale, verdetto sospeso |
| **% SOLO-BID** | idem, "LA RIGA CHE DECIDE" | **< 5%**. Se >= 5% le corse a `Spread=0` su quel simbolo sono **ottimiste** |
| **conversione** | riga `conversione :` | il divisore della tranche (1 / 10 / 100), **non** quello di un'altra |
| **ora d'avvio** | riga `data referto:` | vicina all'ora in cui e' partita **questa** corsa |
| **le ore che contano** | CSV per simbolo | 225JPY → **h01-h07** · forex → **h00-h08 e h13-h19** · XAUUSD → **h07** |

## 🚫 COSA QUESTE RIGHE **NON** FANNO
Non aprono, modificano o chiudono nessuna posizione. Non toccano il forward,
nessun `.set` di sedia, nessun `.chr`. Non promuovono e non spengono niente.
🔴 **E non chiudono il buco del feed REALE `10105439`**: tutto quello che
misurano viene dai tick del **demo `50503392`**. Quel confronto resta
**[NON MISURATO]** (§7 del file dei criteri).
