# 🧹 LA RIGA CHE SVUOTA IL DESKTOP DEL VPS — scritta, girata 41 volte contro se stessa, e **PASS**

**19/09/2026** · branch `lavoro` · pin di tutte le righe: **`9501983db512cb94a4741bbe2afcd53495a819fc`**
Script nuovo: `backtest_pipeline/righe/RIGA_ARCHIVIO_DESKTOP.ps1` · Foto di partenza: `backtest_pipeline/coda/referti/CODA_07_desktop_20260919_033003.log`

---

## 🟢 VERDETTO IN UNA RIGA

> # **PASS. La riga porta il Desktop da 115 cartelle a UNA (`ARCHIVIO`) senza toccare un solo file, senza cancellare niente e senza sfiorare un terminale — misurato ricostruendo il Desktop vero e facendolo girare davvero.**

🎉 **E la caccia ha tirato su un pesce che non cercavamo**: il riordino a mano del **16/09** ha archiviato la cartella da cui parte l'aggiornamento delle **news**, e da tre giorni il calendario degli EA è fermo. C'è la prova numerica, sta al punto ⑥. Quella è la ragione per cui lo script nuovo ha una guardia che nessuno dei quattro gemelli aveva.

---

## ① 🖥️ DOVE VA LA STRINGA, e che cosa NON tocca

> ### 🖥️ **BERSAGLIO: finestra PowerShell sul VPS** (una qualsiasi, anche quella già aperta).
> ### ✋ **NON si apre, non si chiude e non si tocca NESSUN terminale MT5**: né il piccolo **50503392** (`BCM Markets MT5 Terminal`), né il **100k 50504263** (`...-V3`), né il **REALE 10105439** (`C:\BCM_Reale`), né il banco **50504400** (`C:\MT5_Backtest`). Fuori anche Pepperstone e Tickmill.
> ### 📁 Questa riga lavora **solo** su `C:\Users\Administrator\Desktop`, e dentro quella cartella **solo sulle CARTELLE**.
> ### 🚫 **Non cancella niente.** Nello script non esiste un `Remove-Item` su roba di Claudio: l'unico è quello che cancella la **copia scaricata dello script stesso** prima di riscaricarla. Lo spazio si libera perché la roba si **sposta**.

---

## ② 🚀 LA STRINGA — incolla il **blocco INTERO** (graffe comprese)

```powershell
& {
  $pin='9501983db512cb94a4741bbe2afcd53495a819fc';
  $w="$env:USERPROFILE\abtg_archivio"; $p="$w\RIGA_ARCHIVIO_DESKTOP.ps1";
  New-Item -ItemType Directory -Force -Path $w | Out-Null;
  Remove-Item $p -Force -ErrorAction SilentlyContinue;
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ARCHIVIO_DESKTOP.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop;
  if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' };
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1' };
  Write-Host 'BERSAGLIO: solo il Desktop di questo VPS. Nessuna finestra MT5 viene aperta, chiusa o toccata. Nessun file viene cancellato: si SPOSTA e basta.' -ForegroundColor Cyan;
  $global:LASTEXITCODE=0;
  & powershell -NoProfile -ExecutionPolicy Bypass -File $p -Esegui -OreFerme 6;
  if($LASTEXITCODE -ne 0){ throw ('ARCHIVIAZIONE NON COMPLETA, codice ' + $LASTEXITCODE + ': leggi le righe gialle qui sopra') };
  $dsk=[Environment]::GetFolderPath('Desktop');
  $r=@(Get-ChildItem -LiteralPath $dsk -Filter 'esito_archivio_desktop_*.txt' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)[0];
  if(-not $r){ throw 'REFERTO MANCANTE: la corsa non ha scritto niente sul Desktop' };
  Write-Host ('--- REFERTO SUL DESKTOP: ' + $r.Name + ' ---   la riga data: qui sotto deve essere di ADESSO') -ForegroundColor Magenta;
  Get-Content -LiteralPath $r.FullName -TotalCount 9 | ForEach-Object { Write-Host ('   ' + $_) };
  Write-Host ('CARTELLE ancora sul Desktop: ' + @(Get-ChildItem -LiteralPath $dsk -Directory -Force).Count + '   -   giorni dentro ARCHIVIO: ' + @(Get-ChildItem -LiteralPath (Join-Path $dsk 'ARCHIVIO') -Directory -ErrorAction SilentlyContinue).Count) -ForegroundColor Green
}
```

📌 **Da dire a Claudio insieme alla riga**: il referto finisce sul Desktop e la riga ne stampa le prime 9 righe. **La seconda è `data:` e deve essere di ADESSO** — se porta l'ora di un'altra corsa, sta leggendo un referto vecchio (è il difetto del 17/08, e qui è disinnescato perché la riga pesca sempre il file più recente e muore se non lo trova).

### 👀 Se prima vuole solo GUARDARE (non sposta niente)

```powershell
& {
  $pin='9501983db512cb94a4741bbe2afcd53495a819fc';
  $w="$env:USERPROFILE\abtg_archivio"; $p="$w\RIGA_ARCHIVIO_DESKTOP.ps1";
  New-Item -ItemType Directory -Force -Path $w | Out-Null;
  Remove-Item $p -Force -ErrorAction SilentlyContinue;
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ARCHIVIO_DESKTOP.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop;
  if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' };
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1' };
  Write-Host 'BERSAGLIO: solo il Desktop di questo VPS. Nessuna finestra MT5 viene aperta, chiusa o toccata. Nessun file viene cancellato: si SPOSTA e basta.' -ForegroundColor Cyan;
  $global:LASTEXITCODE=0;
  & powershell -NoProfile -ExecutionPolicy Bypass -File $p -OreFerme 6;
  if($LASTEXITCODE -ne 0){ throw ('ANTEPRIMA NON COMPLETA, codice ' + $LASTEXITCODE + ': leggi le righe gialle qui sopra') };
  $dsk=[Environment]::GetFolderPath('Desktop');
  $r=@(Get-ChildItem -LiteralPath $dsk -Filter 'anteprima_archivio_desktop_*.txt' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)[0];
  if(-not $r){ throw 'REFERTO MANCANTE: la corsa non ha scritto niente sul Desktop' };
  Write-Host ('--- REFERTO SUL DESKTOP: ' + $r.Name + ' ---   la riga data: qui sotto deve essere di ADESSO') -ForegroundColor Magenta;
  Get-Content -LiteralPath $r.FullName -TotalCount 9 | ForEach-Object { Write-Host ('   ' + $_) };
  Write-Host ('CARTELLE ancora sul Desktop: ' + @(Get-ChildItem -LiteralPath $dsk -Directory -Force).Count + '   -   giorni dentro ARCHIVIO: ' + @(Get-ChildItem -LiteralPath (Join-Path $dsk 'ARCHIVIO') -Directory -ErrorAction SilentlyContinue).Count) -ForegroundColor Green
}
```

### ↩️ Se non gli piace: **si torna indietro**, tutto com'era

```powershell
& {
  $pin='9501983db512cb94a4741bbe2afcd53495a819fc';
  $w="$env:USERPROFILE\abtg_archivio"; $p="$w\RIGA_ARCHIVIO_DESKTOP.ps1";
  New-Item -ItemType Directory -Force -Path $w | Out-Null;
  Remove-Item $p -Force -ErrorAction SilentlyContinue;
  irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ARCHIVIO_DESKTOP.ps1?cb=$([guid]::NewGuid().ToString('N'))" -OutFile $p -ErrorAction Stop;
  if(-not (Test-Path $p)){ throw 'DOWNLOAD FALLITO' };
  if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1' };
  Write-Host 'BERSAGLIO: solo il Desktop di questo VPS. Nessuna finestra MT5 viene aperta, chiusa o toccata. Nessun file viene cancellato: si SPOSTA e basta.' -ForegroundColor Cyan;
  $global:LASTEXITCODE=0;
  & powershell -NoProfile -ExecutionPolicy Bypass -File $p -Annulla;
  if($LASTEXITCODE -ne 0){ throw ('ANNULLAMENTO NON COMPLETO, codice ' + $LASTEXITCODE + ': leggi le righe gialle qui sopra') };
  $dsk=[Environment]::GetFolderPath('Desktop');
  $r=@(Get-ChildItem -LiteralPath $dsk -Filter 'annulla_archivio_desktop_*.txt' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)[0];
  if(-not $r){ throw 'REFERTO MANCANTE: la corsa non ha scritto niente sul Desktop' };
  Write-Host ('--- REFERTO SUL DESKTOP: ' + $r.Name + ' ---   la riga data: qui sotto deve essere di ADESSO') -ForegroundColor Magenta;
  Get-Content -LiteralPath $r.FullName -TotalCount 9 | ForEach-Object { Write-Host ('   ' + $_) };
  Write-Host ('CARTELLE ancora sul Desktop: ' + @(Get-ChildItem -LiteralPath $dsk -Directory -Force).Count + '   -   giorni dentro ARCHIVIO: ' + @(Get-ChildItem -LiteralPath (Join-Path $dsk 'ARCHIVIO') -Directory -ErrorAction SilentlyContinue).Count) -ForegroundColor Green
}
```

---

## ③ 📊 QUANTO SPOSTA — **misurato**, non stimato a occhio

Ho ricostruito il Desktop vero dalla foto delle 03:30 (115 cartelle, 130 file sciolti, con le date vere) e **ho fatto girare lo script su quella ricostruzione**. Risultato reale della corsa:

| | prima | dopo |
|---|---:|---:|
| **cartelle al primo livello** | **115** | **1** (`ARCHIVIO`) |
| **file sciolti (icone, .lnk, .png, .zip, pagelle)** | **130** | **130** — 🟢 **nessuno toccato** |
| cartelle in `ARCHIVIO\2026-09-18\` | — | **114** (i `ROUND_*` del runner) |
| cartelle in `ARCHIVIO\2026-09-16\` | — | **1** (`Archivio_2026-09-16_1942`, il riordino a mano) |
| **secondo lancio di fila** | — | **0 spostate, 1 saltata** (è ARCHIVIO): 🟢 **ri-eseguibile davvero** |

📦 **Roba spostata**: `5,1 MB` di cartelle `ROUND_*` + `10.349 MB` (**10,1 GB**) del vecchio archivio del 16/09 = **~10,1 GB tolti dalla vista**. ⚠️ **Spostati, NON cancellati**: è lo stesso disco, quindi `Move-Item` è una rinomina istantanea e **lo spazio su disco non cambia di un byte**. Se Claudio vuole recuperare spazio *vero*, è una decisione sua su cosa buttare — e la prende lui, non noi.

### 🔴 CORREZIONE ALLA FOTO CHE MI È STATA PASSATA
La traccia diceva *«444 cartelle `ROUND_` sciolte (più 280 in archivio), 559 `.txt`, 392 `.zip`, 27 `.xlsx`, 9 `.pdf`»*. **Rifatto il conto sullo stesso file, riga per riga, i numeri sono altri** (e la differenza conta, perché cambia cosa sposta la riga):

| | traccia | **misurato sul log del 19/09** |
|---|---:|---:|
| cartelle `ROUND_*` **sciolte sul Desktop** | 444 | **114** |
| cartelle `ROUND_*` **dentro l'archivio del 16/09** | 280 | **86** |
| **file sciolti sul Desktop** (tutti) | ~989 | **130** (114 `.zip`, 7 `.png`, 5 `.lnk`, 3 `.txt`, 1 `.xlsx`) |
| `.txt` / `.zip` / `.xlsx` / `.pdf` **ricorsivi, ovunque** | 559 / 392 / 27 / 9 | **574 / 201 / 116 / 74** |

👉 I numeri della traccia sembrano un **misto fra il conteggio ricorsivo e quello di primo livello**. Il totale che conta per questa riga — *quante cartelle stanno sul Desktop* — è quello che stampa la riga 5 del log: **«3497 file in 115 cartelle»**.

---

## ④ 🛡️ LE SEI GUARDIE, e perché ognuna esiste

| # | guardia | cosa impedisce |
|---|---|---|
| 1 | **ricorsione** | `ARCHIVIO` non entra in se stessa. Doppio controllo: l'elenco guarda **solo il primo livello**, e ogni singola mossa rifiuta una destinazione che stia dentro l'origine |
| 2 | **freschezza 6 ore, RICORSIVA** | il round a metà. La data si prende dal **file più nuovo dell'intero albero**, non dalla cartella radice (scrivere in una sottocartella non aggiorna la radice) |
| 3 | **Desktop ricavato** | non esiste **nessun parametro** per dirgli su che cartella lavorare: lo ricava, e poi pretende che stia dentro il profilo dell'utente, che si chiami `Desktop`, e che **non contenga** nessuna delle parole delle piattaforme |
| 4 | **attività pianificate** 🆕 | non archivia una cartella da cui parte un'attività — **né quella cartella, né una che la contiene**. Ed è **fail-closed**: se non riesce a leggere l'elenco, **si rifiuta** invece di procedere al buio |
| 5 | **giunzioni** | una cartella che è un collegamento/giunzione si salta: dietro ci può essere qualunque cosa |
| 6 | **gemelli** | `ABTG_ORDINE_LOG`, `ARCHIVIO_TEST`, `ABTG_*`: spostarle ammazzerebbe l'`-Annulla` degli altri tre script di riordino, che cercano il proprio log **sul Desktop** |

➕ E le sicurezze ereditate dai gemelli ci sono **tutte** (checklist punto 9): anteprima di default, log CSV `Origine,Destinazione`, `-Annulla`, `try/catch` per cartella, referto scritto **sempre** con la riga `data:`, nessun `-Force` sulla destinazione.

🔵 **Due esclusioni che sono DECISIONI, non dimenticanze** (checklist punto 11 — una whitelist nuova non ribalta in silenzio una blacklist vecchia):
- le **cartelle tematiche di Claudio** (`EASYTREND`, `INDICATORI`, `PIANO DI TRADING`, `FILE WORD`, …) **non si spostano**: è scritto nero su bianco in `riordina_desktop.ps1` dal 14/08. Se le vuole dentro, c'è `-AncheTematiche` — ma è una richiesta che deve fare lui;
- le cartelle **`GITHUB*`**: sono copie di repo da cui partono attività e righe, e finire in archivio le rompe (vedi ⑥).

---

## ⑤ 🔴 I CONTRO-ESEMPI — 41 asserzioni, tutte girate **davvero** con PowerShell

Non è analisi statica: ho scaricato `pwsh 7.4.6`, ho costruito un gemello identico allo script tranne **10 righe** (il Desktop lo detta una variabile d'ambiente, il separatore `\` diventa `/`, le attività pianificate si iniettano — su Linux non esistono) e l'ho fatto girare su Desktop finti costruiti apposta. **Esito: `TUTTE LE ASSERZIONI PASSATE`.**

### 1️⃣ La ricorsione — *non può mettere ARCHIVIO dentro se stessa*
- ✅ `ARCHIVIO` resta al primo livello, e il motivo è **stampato** (*"e' la cartella ARCHIVIO"*)
- ✅ `ARCHIVIO\2026-09-10\ARCHIVIO` **non esiste**
- ✅ il contenuto che era già in archivio **non è stato toccato**
- ✅ **dopo tre giri di fila**: una sola `ARCHIVIO`, primo livello stabile, **nessun annidamento**

### 2️⃣ Il round a metà — *5 minuti fa non si tocca*
- ✅ cartella scritta **adesso** → saltata, motivo `FRESCA` stampato
- ✅ cartella **vecchia** con un file nuovo **tre livelli sotto** → saltata lo stesso (è la prova che la freschezza è ricorsiva: guardare solo la radice l'avrebbe spostata)
- ✅ cartella davvero ferma da 9 giorni → archiviata
- ✅ `-OreFerme 0` la archivia: la soglia è un parametro vero, non un commento

### 3️⃣ Il percorso sbagliato — *cinque modi di sbagliare, cinque rifiuti*
- ✅ Desktop **fuori dal profilo utente** → `RIFIUTO`, niente spostato
- ✅ percorso con `MetaQuotes\Terminal` dentro → `RIFIUTO`, niente spostato **nel terminale**
- ✅ cartella che non si chiama `Desktop` → `RIFIUTO`
- ✅ **attività pianificate illeggibili** → `RIFIUTO` (fail-closed), niente spostato
- ✅ e con `-IgnoraAttivita` va avanti: la porta si apre **solo** se gliela apri tu

### 4️⃣ I nomi ostili — *10 su 10, nome e contenuto intatti*
`Nuova cartella (2)` · `cartella con l'apostrofo` · `ROUND [quadre]` · `cartella; echo pwn` · `dollaro $env e backtick` · `punto.finale.` · `trattino -Esegui` · `ampersand & co` · `ROUND_r1.2.3` · una con le accentate.
- ✅ tutte archiviate, contenuto verificato file per file
- ✅ 🔒 **nessuna iniezione**: il nome `cartella; echo pwn` non ha eseguito niente (tutto passa da `-LiteralPath`, mai da una stringa di comando)
- ✅ il nome che **sembra un parametro** (`trattino -Esegui`) non è stato interpretato

### ➕ E tre che non erano in lista ma pagano da sole
- ✅ **collisione**: una cartella con lo stesso nome già in archivio **non viene sovrascritta** — la nuova arriva accanto, rinominata col timbro
- ✅ **`-Annulla`** rimette la cartella al suo posto e **lascia in pace** quella che era già in archivio
- ✅ **giro a vuoto**: Desktop vuoto → nessun errore, referto scritto **lo stesso**, con la riga `data:`

---

## ⑥ 🔴🆕 IL PESCE GROSSO: **il riordino del 16/09 ha spento l'aggiornamento delle NEWS**

Mentre scrivevo la guardia 4 sono andato a vedere *quali* cartelle del Desktop servono a qualcuno. Risposta: una. E **era già stata archiviata**.

`ABTG_AggiornaNews` (07:20) parte da `Desktop\GITHUB-claude-creating-agents-SgGpD (1)\...\aggiorna_news.ps1`. Quella cartella, nella foto di stanotte, **sta dentro `Archivio_2026-09-16_1942`** — cioè il riordino a mano del **16/09 alle 19:42** se l'è portata via. Il codice d'uscita dell'attività, letto nei referti `CODA_11`:

| corsa delle 07:20 | esito | |
|---|---:|---|
| 14/09 · 15/09 · 16/09 | **0** | prima del riordino |
| **17/09** | **4294770688** | 🔴 la prima dopo |
| **18/09** | **4294770688** | 🔴 e non si è più ripresa |

👉 **Il filtro news degli EA sta leggendo un calendario fermo al 16/09.** Non è colpa di questa riga — è successo tre giorni fa — ma è **esattamente il danno che questa riga doveva imparare a non fare**, ed è diventata la **CLASSE 458** in checklist.

### 🔧 Cosa serve adesso (NON lo fa questa riga, e non lo decido io)
Il task va **ripuntato** a un posto stabile (`C:\ABTG\aggiorna_news.ps1` dal branch `lavoro`), che è la stessa riparazione già chiesta il 12/09 da `CODA_11`. 🔴 **Finché non si fa, ogni notte il calendario resta vecchio di un giorno in più.** Questa riga, se girasse oggi, sposterebbe `Archivio_2026-09-16_1942` dentro `ARCHIVIO\2026-09-16\`: il task è già rotto e non peggiora, ma il file da recuperare finisce **un livello più in basso**.

---

## ⑦ ✅ IL CANCELLO — output vero

**`python3 backtest_pipeline/controlla_riga.py --riga <ognuna delle tre>`** → *ESITO: nessun difetto meccanico*, **6 PASSATI, 0 rilievi**, per tutte e tre:

```text
    OK   la riga di lancio e' ASCII puro
    OK   pin 9501983d e' un commit vero (git cat-file)
    OK   la riga controlla il MARCATORE dello script scaricato
    OK   il marcatore MARCATORE_RIGA_ARCHIVIO_DESKTOP_v1 c'e' davvero in
         backtest_pipeline/righe/RIGA_ARCHIVIO_DESKTOP.ps1 al pin 9501983d
    OK   classe 165 disinnescata (Continue prima delle chiamate native)
    OK   la riga prevede una raccolta o punta a uno script che ce l'ha
```

**`--ps1 backtest_pipeline/righe/RIGA_ARCHIVIO_DESKTOP.ps1`** → *nessun difetto meccanico*: ASCII puro, nessun costrutto pwsh-7, formati .NET a posto, nessun `Parse` decimale senza cultura invariante.
➕ **E il parser vero c'è**: `Parser::ParseFile` su `pwsh 7.4.6` → **0 errori, 3197 token** (anche sui tre gemelli ritoccati). Il rilievo *"controllo di sintassi saltato, manca pwsh"* del cancello **non si applica più**: l'ho installato.

### 🧾 La checklist dei difetti già pagati, uno per uno
| # | difetto | esito |
|---|---|---|
| 1 | emoji/non-ASCII nel `.ps1` | ✅ **0 byte** fuori da ASCII (`grep -P '[^\x00-\x7F]'`) |
| 2 | formati .NET stile Python | ✅ nessuno: si usa `ToString("0.0", $INV)` |
| 3 | cultura su VPS it-IT | ✅ nessun `Parse`; ogni `ToString` numerico e ogni data passano `$INV`; i confronti fra nomi sono **Ordinal**, mai culture-sensitive |
| 4 | cache di GitHub raw | ✅ pin all'**hash**, `?cb=<guid>` e controllo del **marcatore** prima di eseguire |
| 5 | file non pushato | ✅ `git ls-tree origin/lavoro` lo trova, e il blob al pin ha **lo stesso md5** del file locale |
| 6 | MT5 aperto | ✅ **non si applica**: lo script non scrive in nessuna cartella di MT5 e non nomina nessun terminale |
| 7 | parametri che non sopravvivono a `-File` | ✅ solo **switch** e un `[int]`: nessuna stringa vuota |
| 8 | euristiche del silenzio | ✅ nessun `fermoDa`, nessun timeout: la riga aspetta il processo |
| 9 | ora server | ✅ non si applica (nessun `InpSessionHour`) |
| 10 | TP1 della PTE | ✅ non si applica |
| 11 | `@DAQUANDO` inventata | ✅ non si applica |
| 12 | quoting della one-liner | ✅ letta carattere per carattere **e parsata davvero**: un solo blocco `& { }` (checklist punto 21), apici singoli all'interno, `$` solo dove serve |

---

## ⑧ 🧰 LE TRE RIPARAZIONI AI GEMELLI (fatte, non proposte)

`ARCHIVIO` è una cartella nuova sul Desktop, e sul Desktop girano **altri tre** script di riordino che non la conoscevano: al primo giro se la sarebbero portata via (è la classe 142). Aggiunta alle loro liste *"mai toccare"*:
- `backtest_pipeline/riordina_desktop.ps1` (`$NonToccare`)
- `backtest_pipeline/archivia_test_desktop.ps1` (`$NomiMai`)
- `backtest_pipeline/righe/RIGA_ORGANIZZA_DESKTOP.ps1` (`$Escluse`)

Tutti e tre riparsati: **PARSE OK**.

⚠️ **E va detto in chat quando si manda la riga**: sul Desktop adesso esistono **quattro** alberi di riordino diversi (`ARCHIVIO` nuovo, `ARCHIVIO_TEST`, `ARCHIVIO_DESKTOP`, `ABTG_RISULTATI/ZIP/DOCUMENTI`). Questa riga usa **solo il primo** e non tocca gli altri — ma se un domani si lancia un gemello, la roba si divide in due posti. 👉 **Proposta**: quando `ARCHIVIO` sarà in piedi, gli altri tre si dichiarano *fuori servizio* (restano per `-Annulla` e basta).

---

## ⑨ ❓ TRE COSE CHE DEVE DIRE CLAUDIO (non le decido io)

1. 📦 **I 114 `ROUND_*.zip` restano sciolti sul Desktop.** Lui ha detto *«lascia fuori le altre icone»*, e uno zip è un'icona: quindi **v1 non li tocca**. Ma sono **114 icone su 130**: se li vuole accanto alla loro cartella basta una `v2` che sposta **solo** lo zip il cui nome è **identico** a una cartella archiviata nello stesso giro (mai le pagelle, mai gli screenshot).
2. 🗂️ **Le cartelle tematiche** (`EASYTREND`, `PIANO DI TRADING`, …) restano fuori per la decisione del 14/08. Oggi sul Desktop **non ce n'è nemmeno una** (sono già finite dentro l'archivio del 16/09), quindi la domanda è per il futuro.
3. ⏰ **Sei ore di quarantena**: è il motivo per cui *«direttamente»* diventa *«dopo sei ore»*. Un round del runner dura fino a 2-6 ore e la sua cartella viene zippata **alla fine**: sotto le sei ore si rischia di spostarla a metà scrittura. Se gli sembrano troppe, `-OreFerme 3` è una manopola — ma **sotto la durata del round più lungo non si scende**.

---

## ⑩ 🕳️ COSA NON HO POTUTO VERIFICARE, e lo dico

- ❌ **Non ho eseguito niente sul VPS** (non è il mio mestiere e non ne ho accesso): tutte le corse sono su Desktop **finti** ricostruiti dalla foto delle 03:30, con `pwsh 7.4.6` **su Linux**. Restano non provati sul campo: `Get-ScheduledTask` (su Linux non esiste, l'ho **iniettato**), gli attributi `Hidden/System` di Windows, e i permessi NTFS.
- ⚠️ **Il gemello di prova differisce dallo script vero per 10 righe** (Desktop da variabile d'ambiente, `\`→`/`, attività iniettate): il diff è stato stampato e riletto, e **nessuna delle 10 tocca la logica delle guardie**. Lo script **vero** è stato comunque **parsato** e passato al cancello.
- ⏱️ **La foto è delle 03:30**: fra allora e il lancio il runner può aver creato altre cartelle `ROUND_*`. Quelle sotto le sei ore **verranno saltate**, ed è il comportamento voluto: il numero finale sarà *115 + quelle nate oggi da più di sei ore*.
- 💾 **`Move-Item` sullo stesso disco non libera spazio su disco**: libera il **Desktop**. Se a Claudio serve spazio vero, va deciso cosa buttare — e non lo buttiamo noi.
