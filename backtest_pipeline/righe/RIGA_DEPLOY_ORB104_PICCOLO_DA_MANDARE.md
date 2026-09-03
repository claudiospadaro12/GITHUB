# 🚀 DEPLOY DELLA v1.04 DELL'ORB SUL **SOLO PICCOLO** — **PASSO 2: LE DUE RIGHE DA MANDARE**

> ## 🔴 CORREZIONE MISURATA IL 03/09 ALLE 16:08 — LA SESSIONE GIUSTA È **ADMINISTRATOR**, NON MASTER
> Fatto: `Get-CimInstance Win32_Process` sul VPS mostra **entrambi** i `terminal64` (pid 9452 piccolo,
> pid 4948 -V3/100k) eseguiti da **`VMI3047753\Administrator`**. Quindi la cartella dati VIVA del
> piccolo è `C:\Users\Administrator\...\215D85D767A1C39E22D242C8114BF9F5` (ORB v1.02 del 22/08,
> `.ex5` 80.024 byte), ed è quella che il CONTROLLO delle 16:02 ha scelto. La copia sotto
> `C:\Users\Master\...\215D85...` (v1.02 del 27/08, `.ex5` 80.872 byte, vista al PASSO 1) è una
> **copia MORTA**: nessun processo la usa. **I due blocchi si lanciano dalla sessione ADMINISTRATOR**;
> il driver, che sceglie la cartella sotto il profilo che lo lancia, così prende quella viva. Ogni
> riga qui sotto che dice "Master" è superata da questa nota (il driver e il pin NON cambiano).
> Conseguenza da annotare: qualunque deploy fatto dalla sessione Master dopo il 22/08 non è mai
> arrivato al piccolo vivo.

# 🖥️ SUL VPS, SESSIONE **MASTER** (NON Administrator), **MT5 E METAEDITOR CHIUSI**, QUANDO LA FLOTTA È FERMA (**DOPO LE 22:15 IT** O **PRIMA DELLE 07:30 IT**)

**Che cos'è:** la **seconda** delle due mosse firmate da Claudio il **03/09 alle
11:05** — testuale: **"FIRMO IL PERIMETRO PICCOLO"** (verbale
`report/FIRME_2026-09-03.md`):

1. **si vede COMPILARE la v1.04 fuori dal terminale vivo** ← ✅ **FATTO** il 03/09
   alle 14:18: `0 errors, 0 warnings`, `.ex5` 91 KB
   (`risultati_archivio/REFERTO_COMPILA_ORB104_2026-09-03.txt`)
2. **solo se 0 errori, deploy sul SOLO conto piccolo 50503392** ← **sono queste
   due righe**. Il terminale **100k / `-V3` (conto 50504263) resta INTATTO** fino a
   fine Fase 1: la riga **non ha nessun percorso di scrittura fuori dalla cartella
   scelta** (questo è per costruzione, e le foto del piccolo lo misurano), e del 100k
   **fotografa quello che la sessione Master riesce davvero a leggere**. ⚠️ Se non
   riesce a leggerne nemmeno un file, il referto scrive **`NON MISURATO`** — **non**
   `INVARIATO`: la foto di un file che non c'è non è una prova (classe **117**,
   trovata dal verificatore prima di questo invio).

La v1.04 (`mql5/Experts/ABTG_ORB_Ottimizzato.mq5`, commit del fix `19312c8`) è la
**cura del difetto `SelPos`/HEDGING**: selezione per **SIMBOLO + MAGIC**, scritture
per **TICKET**, autotest a tavolino di **10 blocchi / 33 casi** che si stampa
nell'`OnInit`. Sul piccolo oggi gira la **v1.02** (`.mq5` da 39.456 byte del 27/08,
misurato dalla foto del PASSO 1): è quella che viene sostituita.

> 🚫 **PERCHÉ NON `aggiorna_verifica_orb.ps1`.** Lo script del 22/08 **aggiorna
> ENTRAMBE le istanze** (piccolo **e** `-V3`) e ha `-VersioneAttesa` con default
> `1.02`: **viola il perimetro firmato**. Non si lancia e **non si modifica**
> (resta agli atti com'era). Questa è una riga **nuova**, `RIGA_DEPLOY_ORB104_PICCOLO.ps1`,
> col perimetro dentro.

> 🧾 **COSA SCRIVE, E DOVE (solo in CORSA):** tre file, tutti sotto la cartella dati
> del **piccolo** — `MQL5\Experts\ABTG_ORB_Ottimizzato.mq5`, il suo `.ex5`
> ricompilato, `MQL5\Include\ABTG_PausaGuardian.mqh` (v1.51, scaricata **allo
> stesso pin**). **Nient'altro**: nessun `.set`, nessun `.ini`, nessun `.chr`. I
> parametri restano quelli **salvati nel grafico** (rischio **1,0%** sul piccolo);
> l'unico input nuovo della v1.04, `InpAutoTest`, prende il default (`true`). E
> anche questo è **misurato**: conteggio + byte + ultima scrittura di `Presets\`,
> `Profiles\Charts\` e `config\` **prima e dopo** → `INVARIATI`.
>
> ⚠️ **Il terzo file NON è «dell'ORB»: `ABTG_PausaGuardian.mqh` è l'include CONDIVISO
> del Guardian**, che sul quel terminale usano **decine di EA** della flotta. Sul
> piccolo oggi c'è una versione da **82.941 byte** (foto del PASSO 1, 31/08); questo
> giro la porta a **v1.51 / 112.481 byte**. Gli **`.ex5` già in forward NON cambiano
> comportamento** — ognuno si porta dentro il Guardian con cui è stato compilato —
> ma **cambia l'ingresso di ogni compilazione futura su quel terminale**. La riga lo
> scrive nei **RILIEVI**; va saputo prima del round di ricompilazione.

> 🏷️ **LA CARTELLA DATI DEL PICCOLO SI SCEGLIE PER FATTI, NON PER NOME** (classe
> 115). La riga scandisce **largo** (cartelle dati di tutti i profili, installazioni
> in `Program Files`, processi vivi) e sceglie **stretto**: **`bases\BCMMarkets-Server`**
> presente **e nessuna traccia del 100k** (né `-V3` nell'`origin.txt`, né il login
> `50504263` nei log degli ultimi 45 giorni) **e sotto il profilo della sessione da
> cui lanci** (`%APPDATA%`: il piccolo gira sotto **Master**, misurato al PASSO 1;
> il 100k gira sotto **Administrator**, HANDOFF 03/09 — e sotto quel profilo può
> esserci anche una **copia** della stessa installazione, che passa i primi due fatti
> ma **non viene scelta da sola**). Il login `50503392` nei log è la **conferma**
> (se manca è un rilievo dichiarato, non un blocco). Se le scelte automatiche sono
> **0 o più di 1**, la riga **si ferma e stampa l'elenco completo** di cosa ha
> guardato — vedi la sezione gialla in fondo.

> 🧰 **BACKUP PRIMA, RIPRISTINO SU FALLIMENTO.** I tre file di prima finiscono in
> `Desktop\backup_orb_v102_<data>\<ora>\` (verificati per byte e sha256). Se la
> compilazione **fallisce** — o MetaEditor torna **muto** — i tre file **tornano
> com'erano** (sha256 identico, e la foto DOPO lo mostra con `INVARIATO`). Una
> **sentinella** (classe 116) copre anche il giro **interrotto a mano**: il giro
> dopo la trova, rimette a posto e lo dichiara.

> ⚙️ **Il verdetto sta sull'artefatto, non sul codice di uscita** (classe 108): sul
> VPS `metaeditor64` torna **`1`** anche quando compila (è il numero di file
> compilati — **misurato il 03/09** al PASSO 1). Decidono l'**`.ex5` fresco** e la
> riga **`Result: N errors, M warnings`** del log, letta in UTF-16.

| | |
|---|---|
| **Driver** | `righe/RIGA_DEPLOY_ORB104_PICCOLO.ps1` (marcatore `MARCATORE_RIGA_DEPLOY_ORB104_PICCOLO_v2`) |
| **Dove** | **VPS**, sessione **Master** (la cartella dati del piccolo è sotto `C:\Users\Master\...`, misurato al PASSO 1) |
| **MT5 / MetaEditor** | **CORSA: TUTTI E DUE CHIUSI**, e la riga si ferma da sola se non lo sono, **prima di scaricare qualunque cosa**. ⚠️ Il gate vede **tutti i processi della macchina**, anche il terminale del 100k che gira nella sessione **Administrator**: se lo nomina (`terminal64 pid ...`), va chiuso **da quella sessione** e riaperto dopo il PASSO 3 — chiuderlo e riaprirlo **non tocca i suoi file** (la riga li fotografa, se li vede: vedi il punto 9 di «come si legge»). È la stessa regola della procedura del 22/08 («chiudi ENTRAMBI i terminali»). **CONTROLLO: possono restare aperti** (non scrive niente; lo segna come rilievo) |
| **Quando** | flotta ferma: **dopo le 22:15 IT o prima delle 07:30 IT** (l'ORB parte alle 14:30 ora server = 15:30 IT: c'è tutta la mattina per il PASSO 3) |
| **Quanto ci mette** | scansione + 2 download + 1 compilazione = **1–3 minuti** [STIMA] |

## 📌 IL PIN — **`5d21c3bf791adfe357c352a66be4b8af5dea3ad1`**  ✅ **INSERITO**

Commit di `lavoro` (è il commit del driver, quello col quarto fatto del profilo),
**verificato uno per uno via `raw` prima di scrivere questa riga** (HTTP 200 + sha256
identico al repo):

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_DEPLOY_ORB104_PICCOLO.ps1` | 200, identico, marcatore `_v2` presente, ASCII puro (0 righe non-ASCII), parse reale `Parser::ParseFile` OK |
| `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` | 200, identico, `#property version "1.04"`, **identico al commit del fix `19312c8`** (sha256 `c14d85dd…`, gli stessi 74.103 byte del PASSO 1) |
| `mql5/Include/ABTG_PausaGuardian.mqh` | 200, identico (**v1.51**, sha256 `b7462cd5…`, gli stessi 112.481 byte del PASSO 1) |

Tutti e tre scaricati **allo stesso pin**, mai dalla punta del branch. Il pin è
scritto **quattro volte** in questa pagina (qui, nei **due** blocchi e nella nota in
fondo alla tabella delle uscite) e sono **la stessa identica stringa da 40 hex**,
zero forme abbreviate: i conteggi della ricetta (classi 101/103/104) tornano.

## ▶️ BLOCCO 1 — **CONTROLLO** (giro a vuoto: non scrive nel terminale, dice cosa farebbe)

Si lancia **prima**, anche di giorno con MT5 aperto. Torna l'elenco delle cartelle
guardate, la cartella scelta col suo **criterio**, la **versione installata** letta dal
`.mq5` del terminale, e le foto del piccolo tutte `INVARIATO` (sul 100k vedi il punto 9).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='5d21c3bf791adfe357c352a66be4b8af5dea3ad1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DEPLOY_ORB104_PICCOLO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DEPLOY_ORB104_PICCOLO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DEPLOY_ORB104_PICCOLO_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Modo CONTROLLO; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'DEPLOY_ORB104_PICCOLO_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP DEPLOY_ORB104_PICCOLO_CONTROLLO_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo -- il referto dice dove si e'' fermato.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## ▶️ BLOCCO 2 — **CORSA** (scrive nel SOLO piccolo, compila, ripristina se fallisce)

**Solo dopo un CONTROLLO pulito** (`PROBLEMI: 0`, `!!! FERMATO` assente), con **MT5 e
MetaEditor CHIUSI** e la flotta ferma. La prima riga del blocco **si rifiuta** se
uno dei due è aperto, **prima di scaricare qualunque cosa**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTI: chiudili tutti e due (flotta ferma: dopo le 22:15 IT o prima delle 07:30 IT) e rilancia. Non ho scaricato e non ho toccato niente.' };
    $pin='5d21c3bf791adfe357c352a66be4b8af5dea3ad1'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DEPLOY_ORB104_PICCOLO.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DEPLOY_ORB104_PICCOLO.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DEPLOY_ORB104_PICCOLO_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Modo CORSA; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'DEPLOY_ORB104_PICCOLO_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP DEPLOY_ORB104_PICCOLO_CORSA_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. NON riaprire MT5: mandami quello che vedi qui sopra, va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo. NON riaprire MT5 prima di aver letto la riga DEPLOY: e PROBLEMI: del referto.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '). La freschezza dello zip l''ha gia'' controllata la riga qui sopra.') -ForegroundColor Gray }
```

## 📦 COSA TORNA
- Zip sul Desktop **`DEPLOY_ORB104_PICCOLO_<MODO>_<timestamp>.zip`** con
  `REFERTO_DEPLOY_ORB104_PICCOLO.txt` + `CANDIDATE.txt` (l'elenco completo delle
  cartelle guardate) + **solo in CORSA arrivata a MetaEditor** `COMPILAZIONE.log`
  (UTF-16, il log vero) e `COMPILAZIONE_leggibile.txt` (lo stesso in ASCII).
- **Solo in CORSA**, la cartella **`Desktop\backup_orb_v102_<data>\<ora>\`** con i
  tre file di prima + `BACKUP_ORIGINE.txt` + `REFERTO_DEL_GIRO.txt`. **Non si
  cancella da sola**: resta finché il PASSO 3 non è chiuso.

## 🔎 COME SI LEGGE — le righe del referto, in quest'ordine
1. **`data:`** = **l'ora in cui hai LANCIATO il blocco** (timbro all'avvio; la riga te
   la stampa già in console). **`modo:`** = `CONTROLLO` o `CORSA`.
2. **`cartella dati del piccolo:`** + **`criterio di scelta:`** — deve dire
   `FATTO: unica cartella dati sotto il profilo di questa sessione (Master) con
   bases\BCMMarkets-Server e SENZA traccia del 100k` e, se c'è, `login 50503392
   CONFERMATO nei log`. Al PASSO 1 era
   `C:\Users\Master\AppData\Roaming\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5`:
   **nel CONTROLLO, se qui esce un'altra cartella, fermati e manda lo zip** — è per
   questo che il CONTROLLO va **prima** della CORSA.
3. **`versione INSTALLATA prima del giro:`** = **`1.02`** (letta dal `.mq5` del
   terminale, non assunta). Un numero diverso non è un guasto, ma va letto.
4. **`versione letta dal #property:`** = **1.04**, **`autotest dichiarato:`** =
   **10 blocchi / 33 casi**, **`grep del difetto curato:`** = **0 occorrenze**. Sono i
   gate di **identità** del file al pin: se non tornano, la riga **non installa**.
5. **`backup:`** — in CONTROLLO `NON FATTO (modo CONTROLLO ...)`; in CORSA `FATTO in
   <cartella>` coi tre file, byte e sha256.
6. **`compilazione:`** — ha **QUATTRO STATI**, tutti veri:
   - **`NON TENTATA`** → CONTROLLO, oppure un gate ha fermato prima (riga `!!! FERMATO:`);
   - **`OK (... KB, ... byte, hh:mm:ss), 0 errors, N warning`** → **la v1.04 è
     installata e compilata**: si passa al PASSO 3;
   - **`FALLITA (...)`** → MetaEditor ha compilato con errori: **i tre file sono
     stati RIMESSI dal backup** (riga `ripristino:`) e le prime 30 righe del log
     stanno sotto. Il PASSO 1 aveva compilato **lo stesso file** con 0 errori: se
     qui fallisce, la differenza è l'**ambiente del terminale**, non il codice;
   - **`FALLITA -- METAEDITOR MUTO`** → lanciato, tornato **senza log né `.ex5`**
     (l'`rc=0` muto del 22/08: editor aperto, percorso, permessi). Ripristinato.
     Non è un verdetto sul codice: si ricontrolla che tutto sia chiuso e si rifà.
7. **`riga Result del log:`** = `Result: 0 errors, 0 warnings, ...` verbatim;
   **`codice di uscita di metaeditor64:`** = **`1` è normale** (misurato al PASSO 1),
   `NON LETTO` non è un fallimento.
8. **`DEPLOY:`** — `AVVENUTO` / `TENTATO E RIPRISTINATO` / `NON AVVENUTO`, con il
   perché. **`ripristino:`** dice cosa è stato rimesso e da dove.
9. **`IL -V3 / 100k:`** ha **TRE STATI**, e vanno letti per quello che dicono
   (classe **117**):
   - **`INVARIATO su N foto di file REALMENTE PRESENTI`** → misurato davvero: N copie
     vere dei tre file, prima e dopo identiche;
   - **`NON MISURATO`** → la riga ha guardato le cartelle con traccia del 100k ma
     **non c'era dentro nemmeno un file vero da fotografare** (tipicamente vede solo
     la **cartella di installazione** `...-V3` in `Program Files`, mentre la sua
     **cartella dati** sta sotto **Administrator**, che la sessione Master non legge).
     **È il caso PIÙ PROBABILE sul VPS, ed è un RILIEVO, non un problema**: il
     perimetro qui regge **per costruzione** (la riga non ha nessun percorso di
     scrittura fuori dalla cartella scelta al punto 2), ma sul 100k **non è
     misurato** — e il referto lo dice con questa parola invece di regalare un verde.
     ⚠️ **Non confondere `NON MISURATO` con un guasto: non blocca e non richiede
     niente.**
   - **`ATTENZIONE: un file del -V3 RISULTA CAMBIATO`** → **PROBLEMA**: non riaprire
     il 100k, manda lo zip.
   Sotto, riga per riga, ogni copia dei tre file cercata sotto una cartella con
   traccia del 100k, `prima [...] dopo [...]`: le righe `ASSENTE ... ASSENTE` sono
   proprio quelle che **non contano** come prova.
10. **`PARAMETRI (.set/.chr/.ini):`** = **`INVARIATI`** (Presets, Charts, config).
11. Le **tre righe `PICCOLO ...`**: in CORSA OK devono dire **`CAMBIATO`** tutte e tre
    (nuovi byte: `.mq5` 74.103, `.mqh` 112.481, `.ex5` ~93.000); in CONTROLLO o
    dopo un ripristino **`INVARIATO`**.
12. **`COSA SUCCEDE DOPO:`** — è il PASSO 3, scritto nel referto.
13. **`PROBLEMI:`** e **`RILIEVI:`** in fondo, poi **l'elenco delle cartelle guardate**.

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)
| Cosa succede | Zip sul Desktop | Il terminale del piccolo | Cosa mandare |
|---|---|---|---|
| **MT5 o MetaEditor aperti**, blocco CORSA (si ferma **prima** di scaricare) | ❌ **NO** | **intatto** | il messaggio rosso in console; chiudi tutto, rilancia |
| **`SCRIPT VECCHIO`** o download della riga fallito | ❌ **NO** | **intatto** | il messaggio in console (404 su un pin appena creato: aspetta 5 minuti, rilancia **la stessa riga**) |
| **Gate del driver** (pin, MT5 aperto visto dal driver, versione ≠ 1.04, include, cartella dati **0 o 2 eleggibili**, `Trade.mqh` assente, `-CartellaDati` che non passa i gate) | ✅ **SÌ** | **intatto** (`backup: NON FATTO`) | lo zip: `!!! FERMATO:` col motivo |
| **Sentinella di un giro interrotto, trovata in CONTROLLO** (il CONTROLLO non scrive, quindi **non ripristina**) | ✅ **SÌ** | **intatto** | lo zip: qui **non** c'è `!!! FERMATO:`, c'è **`PROBLEMI: 1`** che dice di rilanciare in CORSA (che rimette a posto dal backup) |
| **CONTROLLO pulito** | ✅ **SÌ** | **intatto** (le tre righe `PICCOLO` e i `PARAMETRI` tutti `INVARIATO`) | lo zip → si passa alla CORSA |
| **CORSA, compilazione FALLITA o MUTA** | ✅ **SÌ** (+ backup) | **RIPRISTINATO** (le tre righe `PICCOLO` dicono `INVARIATO`) | lo zip, **prima di riaprire MT5** |
| **CORSA, eccezione dopo la scrittura** (es. MetaEditor non parte) | ✅ **SÌ** (+ backup) | **RIPRISTINATO** (`ripristino: ... dopo un'eccezione`) | lo zip, **prima di riaprire MT5** |
| **CORSA OK** | ✅ **SÌ** (+ backup) | **v1.04 dentro** (tre `CAMBIATO`, parametri `INVARIATI`, `-V3` `INVARIATO su N foto vere` **oppure** `NON MISURATO`: punto 9) | lo zip → **PASSO 3** |
_(la tabella è stata compilata **eseguendo** ogni ramo su un banco stubbato — 27
casi, elenco in `risultati_archivio/REFERTO_DEPLOY_ORB104_PICCOLO_PREPARAZIONE.md` —
non a memoria: punto 94-bis. Il **verificatore** ha poi rieseguito la logica delle
foto del `-V3` su quattro scenari e ha trovato la **classe 117**: driver corretto,
marcatore portato a `_v2`, pagina ri-pinnata su
`5d21c3bf791adfe357c352a66be4b8af5dea3ad1`.)_

## 🟡 SE LA RIGA SI FERMA SU **«NON SO QUALE CARTELLA DATI È IL PICCOLO»**
Non è un guasto: è la regola di casa (**classe 115** — l'ambiente non si indovina dal
nome, si decide con un fatto). Il referto e `CANDIDATE.txt` portano **l'elenco di
tutte le cartelle guardate**, con dentro `origin.txt`, `bases\`, i **login visti nei
log**, il **profilo** e il perché dello scarto. Due casi tipici:
- **«N cartelle passano i fatti ma NESSUNA sta sotto il profilo di questa
  sessione»** → quasi sempre sei nella sessione **sbagliata** (Administrator invece
  di Master): cambia sessione e rilancia **lo stesso blocco**, senza manopola;
- **«eleggibili sotto questo profilo: 2»** (o 0 con un elenco che la contiene) →
  riconosci quella del piccolo (login `50503392`, niente `-V3`, la `215D85...` del
  PASSO 1) e rilancia **lo stesso blocco** aggiungendo al driver:
  `& $p -Pin $pin -Modo CORSA -CartellaDati "<percorso incollato>"`.
La manopola **non salta i controlli**: una cartella con traccia del 100k viene
rifiutata lo stesso, e una cartella sotto un altro profilo viene accettata **con un
rilievo che lo dice**.

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. **`codice di uscita di metaeditor64: 1`** con `.ex5` fresco e `Result: 0 errors`:
   è il comportamento **misurato** al PASSO 1.
2. Rilievo **`ora di avvio ... dentro la finestra in cui la flotta di solito
   lavora`**: compare se la CORSA parte fra le 07:30 e le 22:15; MT5 chiuso è
   misurato, quindi la flotta è ferma comunque. Dichiarato, non un blocco.
3. Rilievo **`IL 100k/-V3 NON E' STATO MISURATO in questo giro`** con
   `IL -V3 / 100k: NON MISURATO`: è l'esito **atteso** se da Master non si legge il
   profilo Administrator. Vedi il punto 9: non blocca, e non è un verde mancato — è
   il verde **finto** che è stato tolto.
4. Rilievo **`ABTG_PausaGuardian.mqh e' un include CONDIVISO`**: vedi il riquadro
   «cosa scrive» qui sopra. Dichiarato, atteso.
5. Rilievo **`il login 50503392 NON compare nei log degli ultimi 45 giorni`**: un
   terminale connesso da settimane può non avere una riga di login recente; la
   scelta si regge sugli altri due fatti.
6. Rilievo **`processi aperti durante il CONTROLLO`**: tollerato solo lì.
7. Ogni 10 secondi di attesa: **`... aspetto l'.ex5 da Ns`**. Non interrompere.
8. La cartella **`backup_orb_v102_...`** resta sul Desktop: si cancella a mano, dopo.

## ✅ PASSO 3 — LA VERIFICA NEL TERMINALE (dopo una CORSA con `DEPLOY: AVVENUTO`)
1. **Riapri MT5 del piccolo** (sessione Master). I grafici ORB sono **gli stessi di
   prima**: il terminale ricarica l'`.ex5` nuovo **da solo**, coi parametri salvati
   nel grafico. **Non ricaricare preset, non toccare input.**
2. **Scheda ESPERTI** (⚠️ non «Giornale»: l'autotest è un `Print` dell'EA, e quelli
   finiscono in Esperti). Per **ogni grafico con l'ORB** cerca `ABTG_ORB_Ottimizzato`
   e la riga:
   **`ORB AUTOTEST: 10 blocchi su 10 passati, 33 casi dichiarati, 0 falliti. Nucleo di selezione hedge-safe VERIFICATO a tavolino`**
   — **quella riga è la prova che gira la v1.04**: la v1.02 **non la stampa affatto**.
   ⚠️ **L'`OnInit` NON stampa il numero di versione**: cercare `v1.04` nel Giornale
   **non trova niente**, e non è un guasto — il gate di identità è l'`AUTOTEST`
   (classe 82: un controllo che cerca un token che il codice non scrive è un
   controllo finto). Subito sopra c'è anche `ORB INIT: handle EMA veloce OK = ...`
   (righe della v1.03+, anch'esse assenti nella v1.02).
3. **Scheda GIORNALE**: `ABTG_ORB_Ottimizzato ... loaded successfully` per ogni
   grafico ORB, nessun `cannot load` / `not found`.
4. **Finestra input dell'EA** (F7 sul grafico ORB): `InpRiskPercent = 1.0`,
   `InpUsaGuardian = true`, e il nuovo `InpAutoTest = true`. Chiudi con **Annulla**.
5. **Manda lo screenshot** delle schede Esperti e Giornale.
6. 🛑 **Se l'AUTOTEST dice `falliti` diverso da 0**, o la riga **manca** su un grafico
   ORB: **non lasciare la v1.04 in forward** — manda subito lo screenshot; i tre file
   di prima sono in `Desktop\backup_orb_v102_<data>\<ora>\` e il ripristino lo
   prepariamo come riga a parte (con MT5 chiuso), non a mano.
_(Le ore dei log MT5 sono in **ora locale del VPS** = ora italiana; il grafico è in
ora server = un'ora indietro. Regola fissa del CLAUDE.md.)_
