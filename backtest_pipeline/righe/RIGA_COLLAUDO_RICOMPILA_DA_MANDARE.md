# 🔬 COLLAUDO DELLA RICOMPILAZIONE — **LA RIGA DA MANDARE (passo 2 del pacchetto)**

> 🚫 **NON CONSEGNATA.** Questa pagina esiste per passare dal **cancello**
> (`controlla_riga.py` + agente `controllo-preventivo`). Finché non c'è un
> **PASS**, non esce dalla sessione.

**Che cos'è:** il **passo 2** dell'ordine di esecuzione di
`report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md`. Compila **gli 11 bersagli
non-WIP** del §4.1 **fuori da ogni terminale vivo**, per sapere *prima* se
compilano. **Non è un deploy e non lo diventa**: i passi che portano qualcosa in
campo sono **firme di Claudio** (passi 3-10 del referto).

## 🎯 PERCHÉ NON SI COMPILA `HEAD` — e questa è la ragione per cui la riga esiste
Il repo di oggi contiene **due commit che dichiarano da soli di non essere
compilabili**:

| commit | data | file di EA | cosa dice |
|---|---|---:|---|
| `b45dd00` | 11/09 | **10** | *"**IN CORSO D'OPERA — NON COMPILARE**… NESSUNO DI QUESTI EA VA COMPILATO O CARICATO finché non c'è un PASS"* |
| `b5d904a` | 29/08 | **1** | *"WIP FASE 2 DRIVE… Build ancora in corso"* — ed **è ancora `HEAD` per il Nasdaq** |

👉 Un F7 largo sul repo di oggi porterebbe in campo **1.742 righe di codice EA
non verificate** (`b45dd00`: **1.544** su **11** file di `mql5/Experts/` +
`b5d904a`: **198** sul Nasdaq). Quindi **ogni sorgente si scarica al SUO
commit**, che è l'ultimo **non-WIP** che tocca quel file.

> ✏️ **Numero corretto dal cancello (classe 261).** Qui c'era scritto **2.208**:
> è il totale di `git show --stat b45dd00`, ma comprende **664 righe** di
> `controlla_riga.py`, `controesempi_cancello.py` e `CODA_08_preset_dai_chr.ps1`
> — **che nessun F7 compila**. E il titolo del commit dice *"10 EA"* mentre di
> EA **ne tocca 11**. 🟢 **La tesi non cambia** (1.742 righe non verificate sono
> un motivo pieno per non compilare `HEAD`): era il **numero** a essere gonfiato
> del 27%.
> 🔴 **E i due insiemi da 11 NON sono lo stesso insieme**: **3 bersagli** di
> questa riga non sono toccati da nessun WIP (`SupRev_DAX_H4_Ott`,
> `SupRev_NAS_H1_Ott`, `ORB_Ottimizzato`) e **4 file del WIP** non sono bersagli
> (`PTE_Ottimizzato`, `SuperWave_DAX_H4_Ottimizzato`, `CostToCost`,
> `GapContinuation`).

| | |
|---|---|
| **Driver** | `backtest_pipeline/righe/RIGA_COLLAUDO_RICOMPILA.ps1` (marcatore `MARCATORE_RIGA_COLLAUDO_RICOMPILA_v1`) |
| 🖥️ **DOVE MANDARE LA STRINGA** | **finestra PowerShell sul PC / banco di BACKTEST**, terminale **`50504400`** = `C:\MT5_Backtest` |
| 🔴 **CHE COSA NON VIENE TOCCATO** | il demo piccolo **`50503392`**, il dry-run **`50504263`**, il conto **REALE `10105439`**, più Pepperstone e Tickmill. Sono **sei** cartelle dati: *"gira sul VPS"* è un indirizzo, non un bersaglio — qui il bersaglio è **uno** e la riga si ferma se il percorso non è quello |
| **MT5** | **può restare aperto** (non si scrive in nessuna cartella di terminale). **MetaEditor NO: va CHIUSO** — con l'editor aperto la compilazione da riga di comando torna `rc=0` **senza compilare niente** (lezione del 22/08) |
| **Quanto ci mette** | 1 copia della libreria standard + 12 download + 11 compilazioni = **5-12 minuti** `[STIMA]` |

## 📌 IL PIN — **`c6a63026832b8ac5a6997350d1523d25fea1b252`**
Commit di `lavoro` che contiene **questo driver**. I **sorgenti EA non usano il
pin**: ognuno ha il suo commit bersaglio, scritto nella tabella del driver e
**stampato a schermo**. Il pin appunta **lo script** e **l'include condiviso**.

⚠️ **LIMITE DICHIARATO, e non lo nascondo:** `ABTG_PausaGuardian.mqh` viene
scaricato **al pin (repo di oggi)**, non alla data di ogni bersaglio. È
**voluto**: è esattamente l'accoppiata che un deploy fatto oggi produrrebbe
(EA al suo commit non-WIP + include di oggi). Il referto lo stampa fra i rilievi.

## 🧱 I GATE DI IDENTITÀ — perché un "0 errori" qui vale qualcosa
Per ogni bersaglio la riga pretende **versione** e **conteggio righe** attesi.
Se non tornano **si ferma prima di compilare**: un "compila" su un file
sbagliato sarebbe **una misura vera su un oggetto sbagliato**.

📌 **E il gate ha già lavorato**: scrivendo questa riga avevo trascritto **2360**
righe per il Nasdaq — è il numero del **DAX** allo stesso commit. Il vero è
**2382**. Verificato sul blob, corretto. **Senza quel controllo la corsa si
sarebbe fermata sul mio numero sbagliato.**

Un commit **segnaposto** (riempito di zeri) viene **rifiutato**, così non
diventa una 404 raccontata come "errore di rete".

## ▶️ IL BLOCCO (uno solo)

> 🖥️ **DOVE MANDARE QUESTA STRINGA: finestra PowerShell sul PC / banco di
> BACKTEST — terminale `50504400` = `C:\MT5_Backtest`.**
> 🔴 **CHE COSA NON VIENE TOCCATO:** il demo piccolo **`50503392`**
> (`C:\Program Files\BCM Markets MT5 Terminal`), il dry-run **`50504263`**
> (`...MT5 Terminal -V3`), il conto **REALE `10105439`** (`C:\BCM_Reale`),
> **Pepperstone** e **Tickmill**. La riga **rifiuta** quei percorsi per
> costruzione e non scrive **in nessuna** cartella di terminale.
> ✋ **MetaEditor va CHIUSO. MT5 può restare aperto.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process metaeditor64 -EA SilentlyContinue){ throw 'METAEDITOR APERTO: chiudilo e rilancia (MT5 invece puo'' restare aperto).' };
    $pin='c6a63026832b8ac5a6997350d1523d25fea1b252'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_RICOMPILA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_RICOMPILA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_RICOMPILA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=[Environment]::GetFolderPath('Desktop'); if((-not $d) -or (-not (Test-Path $d))){ $d=Join-Path $env:USERPROFILE 'Desktop' };
    $z=@(Get-ChildItem (Join-Path $d 'collaudo_ricompila_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP collaudo_ricompila_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

### 🧪 Prima, se vuoi il giro a vuoto (scarica e controlla, **non compila**)
Stesso blocco con `-SoloControllo` aggiunto dopo `-Pin $pin`.

## 📦 COSA TORNA
Zip sul Desktop **`collaudo_ricompila_<AAAAMMGG_HHmm>.zip`** con
**`REFERTO_collaudo_ricompila_*.txt`** + **un `*.compile.log` per bersaglio**
(il log vero di MetaEditor: è lì che sta il *perché* di un fallimento).

## 🔎 COME SI LEGGE, in quest'ordine
1. **`inventario PRIMA`** e **`inventario DOPO`** del `MQL5\Experts` **e** del
   `MQL5\Include` del banco: devono **coincidere** (conteggio, byte totali e
   **impronta SHA256 dell'elenco per file**). Sotto ci sono i **due elenchi per
   file** — `percorso | byte | data` — perché **l'impronta dice *se* è
   cambiato, l'elenco dice *cosa***. Se non coincidono il referto lo dice fra i
   rilievi, invece di tacere.
   > ✏️ **Corretto dal cancello (classe 260).** La prima stesura fotografava la
   > **cartella** e chiamava "prova" il fatto che la data non cambiasse. **Non
   > lo era**: il `LastWriteTime` di una directory cambia solo se una voce viene
   > **aggiunta, tolta o rinominata** — una **sovrascrittura in loco** di un
   > `.ex5` che c'era già (cioè **l'unico evento che questo collaudo esiste per
   > escludere**) la lascia **identica**. E il percorso guardato era
   > `<installazione>\MQL5\Experts`, che esiste **solo** se l'installazione è
   > *portable*: altrimenti usciva `ASSENTE` prima e `ASSENTE` dopo →
   > "coincidono" → **prova stampata avendo guardato il vuoto**. Adesso la
   > cartella dati si **risolve** da `origin.txt` e l'inventario è **per file**.
2. **`ESITI, bersaglio per bersaglio`** — quattro stati, tutti veri:
   - **`OK -- .ex5 fresco`** → quel bersaglio **compila**;
   - **`ERRORI: Result: N errors...`** → **quello È il risultato**: gli errori
     stanno nel `.compile.log` accanto. Il deploy di quel file **non si fa**;
   - **`FALLITA -- METAEDITOR MUTO`** → **non è un verdetto sul codice**: è il
     `rc=0` muto del 22/08 (editor aperto, percorso, permessi). Si ricontrolla
     che `metaeditor64` sia chiuso e si rifà;
   - nessuna riga → non ci siamo arrivati: c'è un **`FERMATO DA UNA GUARDIA`**.
3. **`PROBLEMI BLOCCANTI`** e **`RILIEVI`** in fondo.
4. **`CORSA COMPLETA`**: se quella riga **manca**, il referto è **troncato**.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)
| cosa succede | zip sul Desktop | cosa mandare |
|---|---|---|
| **MetaEditor aperto** (si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; poi chiudi MetaEditor e rilancia |
| **`SCRIPT VECCHIO`** o download fallito | ❌ **NO** | il messaggio (se è un 404 sul pin appena creato: aspetta 5 minuti e rilancia **la stessa riga**) |
| **Gate del driver** (pin, bersaglio non ammesso, versione/righe che non tornano, include nuovo) | ✅ **SÌ** | lo zip: c'è `FERMATO DA UNA GUARDIA` col motivo |
| 🆕 **`LIBRERIA STANDARD NON TROVATA`** (né nella cartella dati né nell'installazione) | ✅ **SÌ** | lo zip. **Non è un errore tuo**: il banco `C:\MT5_Backtest` è già stato *"un'installazione NUOVA E VUOTA"* (`RIGA_ANCORA_R119.ps1` r.60-64). Il messaggio porta **il comando che stampa la cartella dati vera**: incollalo e mandami l'uscita |
| **Una o più compilazioni fallite** | ✅ **SÌ** | lo zip: **è il risultato del passo** |
| **Tutto OK** | ✅ **SÌ** | lo zip, e si passa alle **firme** (passi 3-10 del referto) |

## ⚠️ CHE COSA QUESTA RIGA **NON** DIMOSTRA
- 🔴 **Non dimostra che un fix MORDA.** Dice che il sorgente bersaglio
  **compila**. Il comportamento si misura in campo.
- 🔴 **Non sostituisce la firma.** Ogni passo che cambia una **taglia**, uno
  **stop** o la **gestione di un'uscita** in campo resta di Claudio.
- 🔴 **Non guarda il conto reale `10105439`**, che oggi è l'**unico conto
  pulito**: non è un problema da risolvere.
