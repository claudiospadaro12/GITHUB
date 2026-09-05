# 🎯 IL LOGGER DELLO SLIPPAGE VERO — **le tre righe da mandare** (installa · corsa · raccolta)

**Che cos'è:** l'**altro** attrezzo promosso il 23/08 e mai costruito — il *Round
Trip Cost Reconciler* (**T2**, Code Base 76117). Scritto per casa come
**`ABTG_SlippageLogger`**: un EA di **SOLA LETTURA** che, per **ogni operazione
del conto**, mette a confronto il **prezzo che avevamo chiesto** e il **prezzo a
cui siamo stati riempiti davvero**, e tiene il conto **per simbolo, per sedia
(magic) e per motivo dell'uscita** — con la colonna che interessa a tutti:
**lo STOP LOSS**.

> 🔥 **PERCHÉ ADESSO, E PERCHÉ SU UN CONTO REALE**
> **BCM ce l'ha confermato: il conto DEMO NON simula lo slippage.** Sul demo la
> differenza fra richiesto ed eseguito è **zero per costruzione** — non è una
> buona notizia, è **l'assenza della cosa da misurare**. L'unico posto dove quel
> numero esiste è **un conto vero**. Per questo Claudio mette sul reale da 7.500 €
> le due sedie che lavorano di più: **DAX Apertura EU (770101)** e
> **ORB Ottimizzato (770611)**, a rischio di casa **0,65%/trade** (~49 € a trade,
> rischio aperto massimo simultaneo ~1,3%).

> 📏 **Cosa aggiunge a `ABTG_SpreadLogger`** (che resta valido e non si tocca):
> lo Spread Logger misura **quanto costa il libro** campionando a istanti a caso;
> questo misura **quanto costa l'esecuzione** sui **nostri** ingressi e sulle
> **nostre** uscite. Sono le **due metà** del costo vero, e lo Spread Logger
> dichiara esplicitamente di non fare questa.

> 🧨 **E ricordiamo perché la domanda non è teorica.** In R109 (26/08), sui tick
> storici, uno stop del NASUSD messo a **21660,10** è stato riempito a
> **21681,60**: **21,5 punti indice oltre**, perdita **-2159,93** invece di ~-1000.
> Il tester lo mostrava **senza modellare nessuno slippage aggiuntivo**. Quanto
> succede **dal vivo, con soldi veri**? **Non lo sappiamo. Da oggi si misura.**

---

## 0. 🔒 LE SEI COSE CHE QUESTO ARTEFATTO **NON PUÒ** FARE

Il vincolo qui è **più stretto** di quello dello Spread Logger, e non per
scrupolo: **sotto c'è capitale vero**.

| | |
|---|---|
| **Non apre, non modifica, non chiude nessuna posizione** | e non è una promessa: **in questo sorgente non esistono le strutture con cui in MQL5 si compone un ordine**. Senza quelle un ordine non si può nemmeno *scrivere*. La riga di lancio censisce **48 token vietati** sulle righe di codice e pretende **0** |
| **Non c'è nemmeno `OnTradeTransaction`** | eppure sarebbe stato comodo. La sua firma **pretende** quelle strutture, e volevamo che nel file **non comparissero affatto**. Il prezzo pagato sono **10 secondi** di ritardo nell'accorgersi di un deal nuovo: per una misura storica, **zero** |
| **Non tocca nessuna GlobalVariable** | il Guardian e le sedie vive si parlano con quelle: qui non se ne legge e non se ne scrive nemmeno una |
| **Non cancella e non sposta NESSUN file** | nemmeno i propri. Le funzioni per farlo nel sorgente non ci sono, e la riga lo verifica |
| **Non tocca il Market Watch** | a differenza dello Spread Logger, che aggiungeva i simboli. Qui i simboli arrivano dai deal: esistono già per definizione |
| **Scrive solo i propri 3 file** | in `MQL5\Files`, e **col numero di conto dentro il nome**: `ABTG_SlippageLogger_<conto>_deal.csv`, `_sintesi.csv`, `_REFERTO.txt` |

> 🧷 **Perché il numero di conto sta nel NOME del file** (e in **ogni riga** del
> registro): se una raccolta fatta sul demo e una fatta sul reale finissero nello
> stesso registro, la mediana del file misto **non descriverebbe nessuno dei due
> conti** — e siccome sul demo lo slippage è zero, quella mediana sarebbe
> **artificialmente buona**. Così non si possono mescolare, e se qualcuno ci
> riuscisse lo stesso il referto della raccolta **lo urla**.

E non serve il **trading algoritmico attivo**: il logger legge, non opera.

---

## 1. 🔑 **LA COSA CHE MI DEVI DIRE TU: IL NUMERO DEL CONTO REALE**

**Non ce l'ho scritto da nessuna parte nel repo, e non lo invento.**
Lo trovi in MT5 in alto a sinistra: **Navigatore → Conti**, oppure nella barra
del titolo della finestra.

**Va scritto nelle righe qui sotto** al posto di `SCRIVI_QUI_IL_NUMERO`. Le righe
si **rifiutano di partire** se lo lasci lì com'è.

> ## 🛡️ LA GUARDIA È PIÙ SEVERA DEL SOLITO, APPOSTA
> Nello Spread Logger «il login non si trova nei log» era un **rilievo** e si
> andava avanti. **Qui non si va avanti.** Cinque serrature:
>
> 1. **`-LoginAtteso` è obbligatorio.** Senza, la riga non parte.
> 2. **`50503392` (il piccolo) e `50504263` (il 100k) sono VIETATI PER SEMPRE**,
>    e **non c'è nessuna manopola che li sblocchi**. Se scrivi uno di quei due
>    numeri, la riga si ferma subito.
> 3. **Una cartella che ha visto uno di quei due conti nei log è SCARTATA** —
>    anche se ci fosse dentro *pure* il conto atteso. Anzi: **soprattutto
>    allora**, perché un terminale che li ha visti tutti e due non dice a quale
>    conto è collegato **adesso**. (Provato eseguendo: il caso «terminale misto»
>    viene respinto.)
> 4. **Il login atteso DEVE comparire nei log** della cartella scelta (finestra
>    di **180 giorni**, larga apposta: un conto aperto tempo fa e mai usato può
>    avere una sola riga di login vecchia).
> 5. **E c'è una SECONDA serratura dentro l'EA stesso**: l'input
>    **`InpLoginAtteso`**. Se il terminale su cui lo trascini non è quel conto,
>    **l'EA non parte** e lo scrive in Esperti. Anche se la riga sbagliasse
>    cartella, **il logger non misurerebbe il conto sbagliato**.
>    ⚠️ **Ma questa quinta serratura è l'unica delle cinque che devi CHIUDERE
>    TU**: nel sorgente `InpLoginAtteso` nasce a **`0`**, e `0` vuol dire
>    *«qualunque conto»* — cioè **serratura aperta**. Si chiude scrivendo il
>    numero nella finestra degli input quando trascini l'EA sul grafico
>    (**PASSO 3, punto 2**). Le prime quattro sono automatiche e non dipendono
>    da te; questa sì, ed è il motivo per cui il PASSO 3 la ripete in grande.

---

## 2. 📌 IL PIN — **`7b2c6d248f95306b5c8899fc802268a205edf30d`** ✅ **INSERITO E VERIFICATO**

Commit di `lavoro`. **Verificato uno per uno prima di scrivere questa pagina**:
presente in `git ls-tree`, `HTTP 200` via `raw`, e **sha256 del contenuto al pin
identico al file locale**.

| file al pin | esito |
|---|---|
| `mql5/Experts/ABTG_SlippageLogger.mq5` | 200, identico (`6f7f9f82…`, **87.774 byte**), `#property version "1.00"`, **0 caratteri non-ASCII**, **0 token vietati su 48**, **0 commenti a blocco**, **0 `#include`** |
| `backtest_pipeline/righe/RIGA_SLIPPAGELOGGER.ps1` | 200, identico (`50f39d0b…`), marcatore `MARCATORE_RIGA_SLIPPAGELOGGER_v1`, **ASCII puro**, `Parser::ParseFile` **0 errori** |
| `backtest_pipeline/righe/RIGA_SLIPPAGELOGGER_RACCOLTA.ps1` | 200, identico (`e9b41c89…`), marcatore `MARCATORE_RIGA_SLIPPAGELOGGER_RACCOLTA_v1`, **ASCII puro**, `Parser::ParseFile` **0 errori** |

Il pin è scritto **quattro volte** in questa pagina (qui e nei **tre** blocchi)
ed è sempre **la stessa identica stringa da 40 hex**.

> 🧪 **Cosa è stato provato ESEGUENDO, non leggendo** (perché qui il capitale è vero):
> - i **101 casi** dell'autotest dell'EA sono stati **portati e fatti girare su un
>   banco a terra**: 101 eseguiti, **0 rossi** — compreso il caso reale di R109
>   (stop chiesto a 21660,10, riempito a 21681,60 → **+21,5 punti indice
>   avversi**);
> - la guardia sul conto è stata provata su **quattro finti terminali** in **9
>   casi**: senza `-LoginAtteso`, con un conto vietato, con `-ConfermoConto`
>   sbagliato, sulla cartella del demo, sulla cartella **mista**, sulla cartella
>   muta con e senza attestazione, sulla cartella giusta, e in **scelta
>   automatica** (ha scelto quella giusta e scartato le altre tre, motivandolo);
> - la **raccolta** è stata provata su un registro sintetico: ricalcolo
>   indipendente **d'accordo su 4 gruppi su 4**, poi la sintesi è stata
>   **sabotata di proposito** (mediana +7,77) e la riga **l'ha beccata**, poi il
>   registro è stato **inquinato con una riga di conto demo** e la riga ha alzato
>   **due PROBLEMI**;
> - una **cantonata mia** trovata così: `$numero + " testo"` in PowerShell **non
>   concatena**, prova a convertire il testo in numero ed **esplode**. Era in una
>   riga di rilievo della raccolta, ed è **corretta**. Leggendo non si vedeva.
>
> ⚠️ **Quello che NON è provato, e va detto:** **la compilazione**. Qui non c'è
> MetaEditor. Il sorgente passa tutti i gate statici, ma il primo `Result: 0
> errors` lo vedremo **nel referto della CORSA**.

---

## ▶️ BLOCCO 1 — **CONTROLLO** (giro a vuoto: non scrive niente nel terminale)

Si lancia **prima**, anche di giorno, con MT5 aperto. Torna l'elenco delle
cartelle guardate, la cartella scelta col suo **criterio**, i gate sul sorgente
e le foto.

**🔴 Sostituisci `SCRIVI_QUI_IL_NUMERO` col numero del conto reale.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO. Non ho toccato niente.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: su demo lo slippage non e'' simulato. Serve il numero del conto REALE.' };
    $pin='7b2c6d248f95306b5c8899fc802268a205edf30d'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SLIPPAGELOGGER.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SLIPPAGELOGGER.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SLIPPAGELOGGER_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto -Modo CONTROLLO; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SLIPPAGELOGGER_INSTALLA_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SLIPPAGELOGGER_INSTALLA_CONTROLLO_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo -- la riga ESITO DEL GIRO dice dove si e'' fermato.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

---

## ▶️ BLOCCO 2 — **CORSA** (installa e compila nel SOLO terminale del reale)

**Solo dopo un CONTROLLO pulito** (`ESITO DEL GIRO: COMPLETATO`, `PROBLEMI: 0`,
e la riga `guardia sul conto` che dice **TROVATO**) e con **MetaEditor CHIUSO**.
**MT5 resta aperto**: le sedie continuano a lavorare.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process metaeditor64 -EA SilentlyContinue){ throw 'METAEDITOR APERTO: chiudilo (MT5 puo'' restare aperto) e rilancia. Non ho scaricato e non ho toccato niente.' };
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO. Non ho toccato niente.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: serve il numero del conto REALE.' };
    $pin='7b2c6d248f95306b5c8899fc802268a205edf30d'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SLIPPAGELOGGER.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SLIPPAGELOGGER.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SLIPPAGELOGGER_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto -Modo CORSA; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SLIPPAGELOGGER_INSTALLA_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SLIPPAGELOGGER_INSTALLA_CORSA_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra, va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo. NON attaccare l''EA prima di aver letto la riga INSTALLAZIONE del referto.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

> 📄 **I due referti hanno nomi DIVERSI, apposta**:
> `REFERTO_SLIPPAGELOGGER_INSTALLA_CONTROLLO.txt` e
> `REFERTO_SLIPPAGELOGGER_INSTALLA_CORSA.txt`. Si somigliano riga per riga: con
> lo stesso nome, scompattando i due zip nella stessa cartella, uno cancellerebbe
> l'altro in silenzio (checklist classe 132).

### 🟡 SE LA RIGA SI FERMA SU «NON HO TROVATO NESSUNA CARTELLA COL LOGIN…»
Non è un guasto: è la regola di casa, **inasprita** (classe 115 — l'ambiente non
si indovina dal nome, si decide con un fatto). Nel referto e in `CANDIDATE.txt`
c'è **l'elenco di tutto quello che ha guardato**, con `origin.txt`, i `bases\`
trovati, i login visti in ognuna e il perché di ogni scarto. Tre casi:
- **sessione sbagliata** → sul VPS i terminali girano sotto **Administrator**
  (misurato il 03/09): cambia sessione e rilancia **lo stesso blocco**;
- **la riconosci nell'elenco ma il login non compare** (terminale connesso da
  mesi, nessuna riga di login recente) → aprila in MT5, **guarda con gli occhi il
  numero di conto**, e poi rilancia aggiungendo al driver:
  `-CartellaDati "<percorso incollato>" -ConfermoConto <lo stesso numero>`.
  Il numero va scritto **due volte**: è una **firma**, non una scorciatoia, e il
  referto la registra come **`SCELTA ATTESTATA A MANO, NON MISURATA`**;
- **la cartella ha visto un conto demo** → **non si sblocca**, e non c'è manopola.

---

## 🖱️ PASSO 3 — **ATTACCARE L'EA, A MANO** (e qui ci sono **due** cose da non sbagliare)

> ## 🛑 (1) SU UN **GRAFICO NUOVO**, MAI SU UNO CHE HA GIÀ UN EA
> Un grafico MT5 tiene **UN SOLO Expert Advisor**: trascinare il logger su un
> grafico dove gira una sedia **la sostituisce**, e la sedia sparisce dal campo
> senza che nessuno lo dica. **`File > Nuovo grafico`** → un grafico vuoto → *lì*
> si trascina il logger.

> ## 🔑 (2) NELLA FINESTRA DEGLI INPUT, METTI **`InpLoginAtteso` = il numero del conto reale**
> È la **seconda serratura**. Se il terminale non è quel conto, **l'EA non parte**
> e lo scrive in Esperti. Lasciarlo a `0` non è un guasto — il numero finisce
> comunque nel nome dei file e in ogni riga — ma **butta via una protezione
> gratis**, e qui sotto ci sono soldi veri.

1. **Navigatore → Expert Advisors → tasto destro → Aggiorna.** Deve comparire
   **`ABTG_SlippageLogger`**. Se non c'è: la CORSA non è andata su **questo**
   terminale (rileggi `cartella dati scelta` nel referto).
2. **`File > Nuovo grafico`** → **un simbolo qualsiasi** (il simbolo del grafico
   **non conta**: il logger legge lo storico dei deal di **tutto il conto**, non
   del simbolo del grafico). Consigliato **EURUSD H1**, così è evidente che è un
   grafico di servizio.
3. Trascina **`ABTG_SlippageLogger`** su quel grafico. **Metti `InpLoginAtteso` =
   il numero del conto reale.** Gli altri input si lasciano come sono.
4. **Scheda ESPERTI** (⚠️ non «Giornale»: i `Print` degli EA stanno in Esperti).
   Devono comparire, in quest'ordine:
   - `[SLIPLOG] ABTG_SlippageLogger v1.00 - logger di SOLA LETTURA, slippage vero dai deal`
   - `[SLIPLOG] SOLA LETTURA: nessun ordine, ...`
   - `[SLIPLOG] conto <numero> @ <server>   tipo REALE   grafico ospite ...`
     👉 **quel `tipo` deve dire `REALE`.** Se dice `DEMO`, sei sul terminale
     sbagliato: **stacca** e rileggi il referto.
   - **`[SLIPLOG] AUTOTEST: 9 blocchi su 9 dichiarati, 101 casi su 101 dichiarati, 0 falliti.`**
   - `[SLIPLOG] recupero dello storico degli ultimi 30 giorni: N deal registrati…`
   - `[SLIPLOG] avviato: scansione ogni 10 s …`
5. Sul grafico compare un **Comment** con lo stato: conto, tipo, deal registrati,
   posizioni sotto foto, e **la riga delle uscite in STOP** (all'inizio dirà
   `nessuna ancora (n=0)`: è normale e giusto).
6. 🛑 **Se compare `*** ROSSO SLIPLOG ***`**: l'autotest ha casi falliti, la
   misura non è affidabile — **stacca l'EA** e manda lo screenshot.
7. 🛑 **Se l'EA dice `NON PARTO`**: sta dicendo *quale* conto ha trovato contro
   quale gli hai chiesto. **Non forzarlo**: leggi il numero e dimmelo.

> 💤 **Riavvii e fine settimana non fanno perdere niente:** il registro è un file
> **in coda** (non si riscrive mai), e all'avvio l'EA lo rilegge e **non scrive
> due volte lo stesso deal**. In più recupera **30 giorni** di storico: se il
> terminale è stato spento, i deal di quel periodo entrano lo stesso.

---

## ⏳ PASSO 4 — **QUANTO LASCIARLO GIRARE**

Qui il numero che conta **non è il tempo**: è **quante USCITE IN STOP** sono
entrate nella tabella. Uno slippage misurato su 3 stop non è una misura, è un
aneddoto.

| tappa | quando | cosa dà |
|---|---|---|
| **collaudo** | **il giorno dopo** | serve solo a vedere che la macchina gira e che il `tipo` dice `REALE`. Numeri **da non citare** |
| **prima lettura** | quando le uscite in **SL** arrivano a **~20** | si comincia a vedere la forma della distribuzione; **mediana** sì, **P95 no** |
| **numero citabile** | **≥ 50 uscite in SL per sedia** | è quello che si porta nei round e nel criterio di costo |

Le due sedie messe sul reale sono **le più frequenti della flotta** proprio per
questo: sono quelle che riempiono la tabella più in fretta. **Il ritmo vero lo
dirà la raccolta**, non una previsione fatta qui.

---

## ▶️ BLOCCO 3 — **RACCOLTA** (si può lanciare quando vuoi, anche a metà)

**Non tocca niente**: copia i file dalla cartella dati, **rifà i conti da zero**
partendo dal registro grezzo e li **confronta** con quelli scritti dall'EA.
**MT5 resta aperto**, l'EA continua ad accumulare. Rilanciabile a volontà.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: serve il numero del conto REALE.' };
    $pin='7b2c6d248f95306b5c8899fc802268a205edf30d'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SLIPPAGELOGGER_RACCOLTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SLIPPAGELOGGER_RACCOLTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SLIPPAGELOGGER_RACCOLTA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SLIPPAGELOGGER_RACCOLTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SLIPPAGELOGGER_RACCOLTA_ DI ADESSO SUL DESKTOP: mandami quello che vedi qui sopra, va bene uguale.' };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'RACCOLTA CON PROBLEMI: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

**Nello zip:** `REFERTO_SLIPPAGELOGGER_RACCOLTA.txt` (il referto leggibile) +
`ABTG_SlippageLogger_<conto>_deal.csv` (**il registro grezzo: è IL dato**, così i
numeri si possono rifare da capo) + `_sintesi.csv` + il referto scritto dall'EA +
`CANDIDATE.txt`.

---

## 🔎 COME SI LEGGE IL REFERTO DELLA RACCOLTA

1. **`CONFRONTO EA / RICALCOLO`** — deve dire **`OK: N gruppi confrontati, ZERO
   differenze`**. Sono **due conti indipendenti** (MQL5 e PowerShell) sullo stesso
   registro grezzo: se non coincidono, **nessuno dei due numeri si cita** finché
   non si capisce perché. *(Provato: sabotando la sintesi di 7,77 la riga becca
   il gruppo e alza un PROBLEMA.)*
2. **`SPIA SULLA FONTE B`** — 🔥 **è la riga che vale da sola la raccolta.** Il
   prezzo richiesto viene letto da **tre fonti**: **C** il commento del server
   (`sl 24178.20`), **B** il prezzo dell'ordine, **A** la nostra foto di SL/TP
   presa ogni secondo. La priorità è **C → B → A**, dichiarata. Se la spia dice
   **ROSSA**, vuol dire che **la fonte B coincide con l'eseguito su TUTTE le
   righe**: quel server *non riporta* il livello richiesto nell'ordine, e una
   misura fatta solo su B avrebbe detto **«slippage zero» su qualunque conto**.
   Meglio saperlo che stampare uno zero (classe 106).
3. **`LE TRE FONTI DEL RICHIESTO`** — quante righe hanno C, B, A, quante **non
   hanno nessuna fonte** (per quelle lo scarto è `n/d`, **non zero**), e quanto C
   e B vanno d'accordo fra loro.
4. **`righe del registro`** — `buone / scartate / di un altro conto`. Le
   **scartate** hanno una spiegazione normale e una sola: la copia è stata presa
   **mentre l'EA scriveva in coda**, quindi l'ultima riga è monca. Se sono tante,
   si guarda. **`di un altro conto` deve essere 0**: se non lo è, il referto lo
   urla e non si cita niente.
5. **`tipi di conto nel registro`** — deve dire **solo `REALE`**. Se compare
   `DEMO`, quelle righe sono **zeri per costruzione** e non vanno mescolate.
6. **La tabella per gruppo** (`simbolo` × `magic` × `IN/OUT` × `motivo`) —
   `n`, `mediana`, `P95`, `max`, `media`, `costo tot`. **Guarda le righe
   `OUT SL`**: sono quelle che allargano le perdite. `senza richiesto` dice
   quante operazioni di quel gruppo **non** hanno potuto essere misurate.
7. **`LE 10 SCIVOLATE PEGGIORI`** — perché **le medie non le fanno vedere**, e
   sono quelle che spostano un drawdown.
8. **Il SEGNO**: **positivo = AVVERSO** (abbiamo pagato peggio del richiesto);
   **negativo = riempimento MIGLIORE**. Un negativo non è un errore: capita.

### 🧮 E poi cosa ci facciamo
- I criteri di costo dei round (**C1**, **C2**, **S0**) oggi usano lo spread e
  **danno lo slippage per zero**. Con questa tabella lo slippage diventa un
  **addendo misurato**, per sedia e per motivo.
- Il **DD promesso** di ogni sedia nel `CENSIMENTO DEI CONTRATTI` è calcolato su
  backtest **senza slippage**: se la mediana sugli stop fosse, poniamo, 1 punto
  indice, quel DD va **rivisto verso l'alto** prima di firmarlo.
- E si chiude la domanda aperta di R109 §7.8 con un **numero vivo**, non con un
  gap sui tick storici.

---

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Il terminale | Cosa mandare |
|---|---|---|---|
| **`SCRIVI_QUI_IL_NUMERO` lasciato lì** (si ferma **prima** di tutto) | ❌ NO | **intatto** | il messaggio rosso; metti il numero e rilancia |
| **Numero di un conto DEMO** | ❌ NO | **intatto** | il messaggio rosso |
| **MetaEditor aperto**, blocco CORSA (si ferma **prima** di scaricare) | ❌ NO | **intatto** | il messaggio rosso; chiudi MetaEditor e rilancia |
| **`SCRIPT VECCHIO`** o download fallito | ❌ NO | **intatto** | il messaggio (404 su un pin appena creato: aspetta 5 minuti e **rilancia la stessa riga**) |
| **Gate sul sorgente** (marcatore, versione, autotest, **48 token vietati**, `#include`, commenti a blocco, input della guardia) | ✅ SÌ | **intatto** | lo zip: `ESITO DEL GIRO: FERMATO ...` col motivo |
| **Cartella col login non trovata / ambigua** | ✅ SÌ | **intatto** | lo zip + `CANDIDATE.txt` (vedi il riquadro giallo) |
| **Cartella che ha visto un conto demo** | ✅ SÌ | **intatto** | lo zip — e **non si forza**: non c'è manopola |
| **CONTROLLO pulito** | ✅ SÌ | **intatto** (foto tutte `ASSENTE prima e dopo` o `INVARIATO`) | lo zip → si passa alla CORSA |
| **CORSA, compilazione FALLITA / MUTA** | ✅ SÌ (+ backup) | **RIPRISTINATO** — la cartella `Experts` torna **come prima** | lo zip, **prima di riprovare** |
| **CORSA OK** | ✅ SÌ (+ backup) | `.mq5` + `.ex5` nuovi, **parametri INVARIATI** | lo zip → **PASSO 3** |
| **RACCOLTA senza registro** | ✅ SÌ | **intatto** | lo zip: dice le **tre** spiegazioni possibili (EA mai attaccato / nessun deal ancora chiuso / prefisso o conto diversi) e **elenca i file che ci sono davvero** |

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. Rilievo **`MT5 APERTO`** — è **atteso e voluto**: le sedie continuano.
2. **`codice di uscita di metaeditor64: 1`** con `.ex5` fresco e `Result: 0 errors`
   → è il comportamento **misurato** su questo VPS (**classe 108**).
3. Nella raccolta, rilievo su **righe del registro senza 30 campi** → la copia è
   stata presa mentre l'EA scriveva: si rilancia la raccolta.
4. Nei primi giorni, tabelle **vuote** e `uscite in STOP: n=0` → è giusto:
   l'EA sta aspettando che una sedia chiuda qualcosa.

---

## ⚠️ COSA QUESTA MISURA **NON** DICE — e va detto ogni volta che la si cita
- **Non è lo spread.** Quello è `ABTG_SpreadLogger`, e campiona a istanti a caso.
  Questo è pesato **sui nostri ingressi e sulle nostre uscite** — ed è la sua
  utilità, non un difetto.
- **Il costo in valuta è un comodo**, calcolato col valore del tick **di quando
  l'EA ha scritto la riga**, non di quello del momento del deal. **Il dato sono i
  punti.**
- **La fonte A (la nostra foto di SL/TP) può essere vecchia** fino a
  `InpSnapshotSec` secondi: se un trailing ha spostato lo stop un istante prima
  del riempimento, la foto è quella di prima. Per questo **la priorità è C**, e
  per questo **l'età della foto è una colonna del registro**.
- **Broker singolo (BCM), un conto, un terminale, e due sedie.** Lo slippage di
  *altri* motori, su *altri* orari, **non è questo**.
- **Un conto da 7.500 € con lotti piccoli non è un conto da 100k.** Lo slippage
  può dipendere dalla dimensione: questi numeri descrivono **queste dimensioni**.
- Le ore del registro sono in **ora SERVER**; le schede Esperti/Giornale di MT5
  sono in **ora locale** (un'ora avanti sul VPS). **Non si confrontano.**
- **La compilazione non è stata provata qui** (non c'è MetaEditor): il primo
  `Result: 0 errors` arriva col referto della CORSA.

---

_Sorgenti al pin: `mql5/Experts/ABTG_SlippageLogger.mq5`,
`backtest_pipeline/righe/RIGA_SLIPPAGELOGGER.ps1`,
`backtest_pipeline/righe/RIGA_SLIPPAGELOGGER_RACCOLTA.ps1`.
Origine dell'idea: MQL5 Code Base **76117**, promosso in
`report/SWEEP_MECCANISMI_2026-08-23.md` §T2. Il caso che l'ha resa urgente:
`backtest_pipeline/risultati_archivio/R109_INDAGINE_DEAL_2026-08-26.md` §7.8.
Gemella: `RIGA_SPREADLOGGER_DA_MANDARE.md`._
