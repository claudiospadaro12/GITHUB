# 💸 IL LOGGER DELLO SPREAD VIVO — **le tre righe da mandare** (installa · corsa · raccolta)

**Che cos'è:** mettiamo finalmente in campo l'attrezzo **promosso il 23/08 e mai
usato** — il *RealCost Spread P95 Logger* del Code Base (**codice 74148**, Song Bo
Zhong, 2026.06.20). Riscritto per casa come **`ABTG_SpreadLogger`**: un EA di
**SOLA LETTURA** che osserva **dal vivo** lo spread di **sette simboli** e ne
tiene **mediana e P95 ora per ora (ora SERVER)**, accumulando per giorni.

> 🎯 **Il buco che chiude, detto con le parole del round di oggi**
> (`caccia_strategie/CACCIA_TF_M15_2026-09-05.md`, §9):
> _«tutta la tabella §5.1 poggia su spread **di convenzione**. Se lo spread vero
> del DAX fosse 1,0 invece di 1,7, la cella 4,0σ passerebbe da +0,059R a **+0,088R**
> e il verdetto cambierebbe. **Non lo so, e non lo invento.**»_
> È la **settima caccia** che chiede questo attrezzo. Oggi si accende.

> 📏 **Cosa aggiunge alla misura del 03/09** (`risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`,
> che resta valida e non si tocca): quella legge i **tick storici** di **tre indici**;
> questa osserva il **feed vivo** di **sette strumenti** — indici **e forex**, che
> lì non c'erano affatto. Se i due numeri coincidono, la misura storica diventa
> una base solida; **se non coincidono, il numero che paghiamo è questo.**

---

## 0. 🔒 LE TRE COSE CHE QUESTO ARTEFATTO **NON PUÒ** FARE

| | |
|---|---|
| **Non apre, non modifica, non chiude nessuna posizione** | non c'è nessuna funzione di trading nel sorgente, e **la riga di lancio lo verifica** prima di installare: censimento di **24 token vietati** sulle righe di codice, deve dare **0** |
| **Non tocca nessuna GlobalVariable** | il Guardian e gli EA vivi si parlano con quelle: qui non se ne legge e non se ne scrive nemmeno una, quindi **non c'è modo di interferire** |
| **Non scrive fuori dai propri 3 file** | `ABTG_SpreadLogger_stato.csv`, `_orario.csv`, `_REFERTO.txt` in `MQL5\Files`. Nessun `.set`, nessun `.chr`, nessun `.ini` — e le righe lo **fotografano** prima e dopo |

E non serve nemmeno il **trading algoritmico attivo**: il campionamento è a
timer, la spunta non c'entra.

---

## 1. 🖥️ DOVE GIRA, E PERCHÉ PROPRIO LÌ

**Sul terminale del conto PICCOLO `50503392`** (VPS, sessione **Administrator** —
misurato il 03/09: entrambi i `terminal64` girano sotto quell'utente).

| motivo | |
|---|---|
| 1 | è un conto **DEMO** |
| 2 | è lo **stesso feed BCM** su cui lavora la flotta: lo spread che misura è **quello che paghiamo** |
| 3 | il **100k / `-V3` (50504263) è in Fase 1** e **non si tocca** (HANDOFF 03/09). La riga non ha nessun percorso di scrittura fuori dalla cartella scelta, e delle cartelle col 100k **fotografa quello che riesce davvero a leggere** |
| 4 | i sette simboli sono **già nel suo Market Watch** (la flotta ci opera): il logger non deve aggiungere niente |

> ✅ **MT5 può restare APERTO**, ed è voluto — **la flotta non si ferma**. È la
> stessa scelta già pagata dalla `RIGA_CHIUDISEDIE` del 24/08: il divieto del
> punto 7 della checklist riguarda gli script che scrivono dentro `config\` e nei
> `.chr` (che MT5 riscrive all'uscita), e questa riga non li tocca. In più
> `ABTG_SpreadLogger` è un file **nuovo che non sta su nessun grafico**: la
> compilazione **non scarica nessuna sedia**.
> 🔴 **MetaEditor invece va CHIUSO**: è single-instance e con l'editor aperto la
> compilazione da riga di comando torna **muta** (misurato il 22/08). La riga si
> ferma da sola, prima di toccare qualunque cosa.

---

## 2. 📌 IL PIN — **`b314ec4ee2912d057e3be789d0a351bee3a8a0f6`** ✅ **INSERITO E VERIFICATO**

Commit di `lavoro`. **Verificato uno per uno via `raw` prima di scrivere questa
pagina** (HTTP 200 + sha256 identico al repo + presente in `git ls-tree`):

| file al pin | esito |
|---|---|
| `mql5/Experts/ABTG_SpreadLogger.mq5` | 200, identico (`b59c8bec…`, 51.703 byte), `#property version "1.00"`, **0 caratteri non-ASCII**, **0 token vietati** |
| `backtest_pipeline/righe/RIGA_SPREADLOGGER.ps1` | 200, identico (`8c95cbbf…`), marcatore `MARCATORE_RIGA_SPREADLOGGER_v1`, **ASCII puro**, `Parser::ParseFile` **0 errori** |
| `backtest_pipeline/righe/RIGA_SPREADLOGGER_RACCOLTA.ps1` | 200, identico (`424780aa…`), marcatore `MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v1`, **ASCII puro**, `Parser::ParseFile` **0 errori** |

Il pin è scritto **quattro volte** in questa pagina (qui e nei **tre** blocchi) ed
è sempre **la stessa identica stringa da 40 hex**.

---

## ▶️ BLOCCO 1 — **CONTROLLO** (giro a vuoto: non scrive niente nel terminale)

Si lancia **prima**, anche di giorno, con MT5 aperto. Torna l'elenco delle cartelle
guardate, la cartella scelta col suo **criterio**, i gate sul sorgente e le foto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='b314ec4ee2912d057e3be789d0a351bee3a8a0f6'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREADLOGGER.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREADLOGGER.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREADLOGGER_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Modo CONTROLLO; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SPREADLOGGER_INSTALLA_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SPREADLOGGER_INSTALLA_CONTROLLO_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo -- la riga ESITO DEL GIRO dice dove si e'' fermato.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

---

## ▶️ BLOCCO 2 — **CORSA** (installa e compila nel SOLO piccolo)

**Solo dopo un CONTROLLO pulito** (`ESITO DEL GIRO: COMPLETATO`, `PROBLEMI: 0`) e
con **MetaEditor CHIUSO**. **MT5 resta aperto**: la flotta continua a lavorare.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process metaeditor64 -EA SilentlyContinue){ throw 'METAEDITOR APERTO: chiudilo (MT5 puo'' restare aperto) e rilancia. Non ho scaricato e non ho toccato niente.' };
    $pin='b314ec4ee2912d057e3be789d0a351bee3a8a0f6'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREADLOGGER.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREADLOGGER.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREADLOGGER_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Modo CORSA; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SPREADLOGGER_INSTALLA_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SPREADLOGGER_INSTALLA_CORSA_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra, va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo. NON attaccare l''EA prima di aver letto la riga INSTALLAZIONE del referto.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

---

## 🖱️ PASSO 3 — **ATTACCARE L'EA, A MANO** (30 secondi, e c'è **una** cosa da non sbagliare)

> ## 🛑 SU UN **GRAFICO NUOVO**, MAI SU UNO CHE HA GIÀ UN EA
> Un grafico MT5 tiene **UN SOLO Expert Advisor**: trascinare il logger su un
> grafico dove gira una sedia **la sostituisce**, e la sedia sparisce dal campo
> senza che nessuno lo dica. Sul VPS **quasi tutti i grafici hanno un EA**.
> **`File > Nuovo grafico`** → un grafico vuoto → *lì* si trascina il logger.

1. **Navigatore → Expert Advisors → tasto destro → Aggiorna.** Deve comparire
   **`ABTG_SpreadLogger`**. Se non c'è: la CORSA non è andata su **questo**
   terminale (rileggi `cartella dati del piccolo` nel referto).
2. **`File > Nuovo grafico`** → scegli **un simbolo qualsiasi** (il simbolo del
   grafico **non conta**: i simboli misurati sono quelli dell'input `InpSimboli`).
   Consigliato **EURUSD H1**, così è evidente che è un grafico di servizio.
3. Trascina **`ABTG_SpreadLogger`** su quel grafico. Nella finestra **lascia tutto
   com'è** e premi **OK**. La spunta del trading algoritmico **non serve**.
4. **Scheda ESPERTI** (⚠️ non «Giornale»: i `Print` degli EA stanno in Esperti).
   Devono comparire, in quest'ordine:
   - `[SPREADLOG] ABTG_SpreadLogger v1.00 - logger di SOLA LETTURA, spread P95 per ora server`
   - `[SPREADLOG] SOLA LETTURA: nessun ordine, ...`
   - **`[SPREADLOG] AUTOTEST: 8 blocchi su 8 dichiarati, 36 casi su 36 dichiarati, 0 falliti.`**
   - una riga **per ogni simbolo** con `in Market Watch` e i suoi decimali
   - `[SPREADLOG] avviato: 7 simboli (7 selezionabili), campione ogni 5 s, ...`
5. Sul grafico compare un **Comment** con lo stato che si aggiorna: conto,
   campioni, e per ogni simbolo mediana e P95 **dell'ora in corso**.
6. 🛑 **Se compare `*** ROSSO SPREADLOG ***`**: l'autotest ha casi falliti, la
   misura non è affidabile — **stacca l'EA** e manda lo screenshot.
7. **Se un simbolo dice `NON SELEZIONABILE`**: quel nome non esiste su questo
   broker. Non è un guasto degli altri: gli altri sei misurano lo stesso.

> 💤 **Riavvii e fine settimana non fanno perdere niente:** lo stato è su file e
> viene **ripreso all'avvio** (`riprese dello stato` nel referto lo conta). Il
> grafico resta nel profilo, quindi al riavvio di MT5 l'EA riparte da solo.

> 🥇 **Se vuoi anche l'ORO** (ed è la cosa che consiglio, perché **12 grafici su
> 52 sono XAUUSD**: è la concentrazione più grossa della flotta e il suo spread
> non l'abbiamo mai misurato dal vivo): al punto 3, nel campo `InpSimboli`,
> aggiungi in coda **`,XAUUSD`**. Costa ~2 MB di memoria in più e nient'altro.
> **Dichiaralo in chat**, così il referto si legge sapendo quanti simboli ci sono.

---

## ⏳ PASSO 4 — **QUANTO LASCIARLO GIRARE** (la proposta, coi numeri sotto)

Il numero che conta **non è quanti campioni** ci sono in un secchio orario, ma
**quante GIORNATE distinte** ci sono entrate: campioni presi ogni 5 secondi sono
**autocorrelati**, e 720 campioni di un'ora sono **un'ora sola**, non 720
osservazioni.

| tappa | quando | cosa dà |
|---|---|---|
| **collaudo** | **il giorno dopo** l'attacco | serve solo a vedere che la macchina gira: `GG=1`, numeri **da non citare** |
| **prima lettura** | dopo **5 giornate di borsa** (una settimana piena) | `GG≈5` nelle ore di sessione: la soglia sotto cui il referto marca **SOTTILE** |
| **referto buono** | dopo **10 giornate** (due settimane) | due lunedì, due venerdì, due rollover: è quello da citare nei round |

Il **rollover** (l'ora del cambio giornaliero, tipicamente le **23-24 server**) è
il momento in cui lo spread esplode: con due settimane lo si vede **due volte**,
e due volte è il minimo per dire che è una regola e non un giorno storto.

---

## ▶️ BLOCCO 3 — **RACCOLTA** (si può lanciare quando vuoi, anche a metà)

**Non tocca niente**: legge dalla cartella dati, ricalcola mediana e P95 da solo e
li **confronta** col conto fatto dall'EA. **MT5 resta aperto**, l'EA continua ad
accumulare. Si può rilanciare tutte le volte che si vuole.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='b314ec4ee2912d057e3be789d0a351bee3a8a0f6'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREADLOGGER_RACCOLTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREADLOGGER_RACCOLTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SPREADLOGGER_RACCOLTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SPREADLOGGER_RACCOLTA_ DI ADESSO SUL DESKTOP: mandami quello che vedi qui sopra, va bene uguale.' };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'RACCOLTA CON PROBLEMI: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

**Nello zip:** `REFERTO_SPREADLOGGER_RACCOLTA.txt` (il referto leggibile) +
`ABTG_SpreadLogger_stato.csv` (l'istogramma grezzo, così i numeri si possono
rifare da capo) + `_orario.csv` + il referto scritto dall'EA.

---

## 🔎 COME SI LEGGE IL REFERTO DELLA RACCOLTA

1. **`confronto EA/ricalcolo`** — deve dire **`OK: N righe confrontate, ZERO
   differenze`**. Sono **due conti indipendenti** (MQL5 e PowerShell) sullo stesso
   istogramma grezzo: se non coincidono, **nessuno dei due numeri si cita** finché
   non si capisce perché.
2. **`campioni validi` / `scartati`** — gli **scartati** sono i momenti in cui il
   mercato era **fermo** (tick più vecchio di 90 s: notte, weekend, festa). Non
   sono un errore: sono la prova che la notte **non** è stata riempita con l'ultimo
   spread della sera ripetuto mille volte.
3. **La tabella per ora** — colonne `campioni`, **`GG`**, `mediana`, `P95`, `P99`,
   `max`. **`GG` è il numero che decide** se una riga si può citare: sotto 5
   giornate il referto la marca **`SOTTILE`**.
4. **Le righe `>>` di FASCIA** (giornata intera, cash Europa 8-15, cash USA 14-20,
   sera 21-23, notte 0-6) — calcolate **sommando gli istogrammi** delle ore, non
   facendo la media dei percentili: la media di sei P95 non è il P95 di niente.
5. **Fra parentesi quadre** c'è sempre il numero **grezzo in punti MT5**: la
   conversione in pip / punti indice è un comodo, il dato è quello.
6. **`campioni dal ripiego intero`** — quei campioni vengono dallo spread **intero**
   del terminale invece che da bid/ask (tick senza ask valido): sono arrotondati.
   Se sono tanti su un simbolo, va detto quando si cita quel numero.
7. **`campioni oltre il tetto`** — spread oltre 10.000 punti MT5 (100 punti indice
   / 1.000 pip). Contano nel totale ma non hanno un secchio: se un percentile ci
   finisce dentro, il referto scrive **`>10000`** invece di un numero comodo.

### 🧮 E poi cosa ci facciamo (i due cancelli di casa, ora per ora)
- **C2**: il **take lordo mediano** del motore deve stare **≥ 3× lo spread MEDIANO
  dell'ORA in cui lavora** (non della media di giornata).
- **S0**: **take / spread ≥ 2,5** — lo stesso cancello che ha falsificato
  `ABTG_VwapRevert` il 03/09 e che nessuna cella della caccia M15 ha passato.
Con questa tabella tutti e due si applicano **con lo spread vero dell'ora giusta**,
e i round futuri smettono di citare una convenzione.

---

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Il terminale | Cosa mandare |
|---|---|---|---|
| **MetaEditor aperto**, blocco CORSA (si ferma **prima** di scaricare) | ❌ NO | **intatto** | il messaggio rosso; chiudi MetaEditor e rilancia |
| **`SCRIPT VECCHIO`** o download fallito | ❌ NO | **intatto** | il messaggio (404 su un pin appena creato: aspetta 5 minuti e **rilancia la stessa riga**) |
| **Gate sul sorgente** (marcatore, versione ≠ 1.00, autotest, **token vietati**, `#include`, commenti a blocco) | ✅ SÌ | **intatto** | lo zip: `ESITO DEL GIRO: FERMATO ...` col motivo |
| **Cartella dati 0 o 2 candidate** | ✅ SÌ | **intatto** | lo zip + `CANDIDATE.txt` (vedi il riquadro giallo) |
| **CONTROLLO pulito** | ✅ SÌ | **intatto** (foto tutte `ASSENTE prima e dopo` o `INVARIATO`) | lo zip → si passa alla CORSA |
| **CORSA, compilazione FALLITA / MUTA / MetaEditor non parte** | ✅ SÌ (+ backup) | **RIPRISTINATO** — provato eseguendolo: la cartella `Experts` torna **come prima** | lo zip, **prima di riprovare** |
| **CORSA OK** | ✅ SÌ (+ backup) | `.mq5` + `.ex5` nuovi, **parametri INVARIATI** | lo zip → **PASSO 3** |
| **RACCOLTA senza file di stato** | ✅ SÌ | **intatto** | lo zip: dice le **tre** spiegazioni possibili (EA mai attaccato / non ha ancora salvato / prefisso diverso) |

## 🟡 SE LA RIGA SI FERMA SU «NON SO QUALE CARTELLA DATI È IL PICCOLO»
Non è un guasto: è la regola di casa (**classe 115** — l'ambiente non si indovina
dal nome, si decide con un fatto). Nel referto e in `CANDIDATE.txt` c'è **l'elenco
di tutto quello che ha guardato**, con `origin.txt`, `bases\`, i login visti nei
log e il perché di ogni scarto. Due casi tipici:
- **sessione sbagliata** → sul VPS i terminali girano sotto **Administrator**
  (misurato il 03/09): cambia sessione e rilancia **lo stesso blocco**;
- **due candidate** → riconosci quella del piccolo (login `50503392`, niente
  `-V3`) e rilancia aggiungendo al driver: `-CartellaDati "<percorso incollato>"`.
La manopola **non salta i controlli**: una cartella col 100k viene rifiutata lo
stesso.

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. Rilievo **`MT5 APERTO`** — è **atteso e voluto**: la flotta continua a lavorare.
2. Rilievo **`IL -V3 / 100k: NON MISURATO`** — la sua cartella dati sta sotto un
   profilo che la sessione può non leggere. Il perimetro qui regge **per
   costruzione** (nessun percorso di scrittura fuori dalla cartella scelta), ma
   sul 100k **non è misurato**, e il referto lo scrive con questa parola invece di
   regalare un verde (**classe 117**).
3. Rilievo **`il login 50503392 NON compare nei log degli ultimi 45 giorni`** — un
   terminale connesso da settimane può non avere una riga di login recente.
4. **`codice di uscita di metaeditor64: 1`** con `.ex5` fresco e `Result: 0 errors`
   → è il comportamento **misurato** su questo VPS (**classe 108**).
5. Nella raccolta, rilievo **`il file di stato NON finisce con la riga FINE`** → la
   copia è stata presa mentre l'EA stava salvando: si rilancia la raccolta.

---

## ⚠️ COSA QUESTA MISURA **NON** DICE — e va detto ogni volta che la si cita
- **Non è lo slippage.** Lo slippage è la differenza fra prezzo chiesto ed
  eseguito e si legge dallo **storico dei deal**: è l'**altro** attrezzo promosso
  il 23/08 (**T2**, *Round Trip Cost Reconciler*, codice **76117**), ancora da
  fare. Questa riga **non lo tocca**.
- **Non ci sono commissioni né swap.**
- **È lo spread OSSERVATO, non quello ESEGUITO**: campioni a intervallo fisso,
  quindi la distribuzione risponde a *«se entro in un istante a caso di
  quell'ora, che spread trovo?»* — non a *«che spread ho pagato sui miei
  ingressi»* (quello lo dirà T2, sui deal veri).
- **Broker singolo (BCM), un conto, un terminale.**
- Le ore del referto sono in **ora SERVER**; le schede Esperti/Giornale di MT5
  sono in **ora locale** (un'ora avanti). Non si confrontano.

---

_Sorgenti al pin: `mql5/Experts/ABTG_SpreadLogger.mq5`,
`backtest_pipeline/righe/RIGA_SPREADLOGGER.ps1`,
`backtest_pipeline/righe/RIGA_SPREADLOGGER_RACCOLTA.ps1`.
Origine dell'idea: MQL5 Code Base **74148** (Song Bo Zhong), promosso in
`report/SWEEP_MECCANISMI_2026-08-23.md` §T1 e richiamato in
`caccia_strategie/CACCIA_TF_M15_2026-09-05.md` §9._
