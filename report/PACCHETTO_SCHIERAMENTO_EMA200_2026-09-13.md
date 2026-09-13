# 📦 PACCHETTO DI SCHIERAMENTO — `ABTG_EMA200` U30USD H1, magic `771531`

**Domenica 13/09/2026, notte. 18 giorni alla challenge.** Questo foglio e' il
giro in copia-incolla per **ricompilare la prima sedia col Guardian** e
rimetterla in campo. Scritto perche' Claudio non debba pensare: si legge
dall'alto, si incolla, si verifica, e se qualcosa storce si torna indietro.

> 🚦 **CANCELLO, dichiarato.** Il cancello deterministico
> (`controlla_riga.py --oggetto md`) l'ho girato io su questo file, esito in §8.
> Il secondo strato — l'agente `controllo-preventivo` — **lo lancia il
> coordinatore, non io**. Fino a quel PASS questo pacchetto **non e' passato dal
> cancello intero**, e **non va mandato a Claudio**.

---

# 0. 🥇 IL VERDETTO IN SEI RIGHE

1. 🟢 **IL PACCHETTO E' PRONTO.** Nessuna delle modifiche fra il binario in
   campo e la versione da schierare **tocca il SEGNALE**. La sedia che
   schieriamo e' **esattamente quella con PF 1,52365**. Verifica riga per riga
   in §1.
2. 🔴 **MA C'E' UNA TRAPPOLA CHE VALE TUTTA LA NOTTE: NON SI COMPILA `HEAD`.**
   La versione misurata a R112 e' quella del commit **`26a1856`** (552 righe).
   `HEAD` ne ha **690**, e le 138 righe in piu' vengono da un commit che si
   chiama, testualmente, **«IN CORSO D'OPERA — NON COMPILARE»** e che **non e'
   mai passato dal cancello ne' e' mai stato compilato da nessuno**. Aprire
   MetaEditor e premere F7 sulla copia di lavoro **schiererebbe quel codice**.
   Il pacchetto qui sotto scarica il sorgente **pinnato a `26a1856`** e ne
   verifica lo SHA256 **prima** di compilare. 👉 §1.3.
3. 🔴 **E LA RICOMPILAZIONE DA SOLA NON PROTEGGE NIENTE.** I fail-open erano
   **due**. Questo giro chiude **solo il primo** (il binario senza
   `InpUsaGuardian`). Il secondo — **nessun Guardian gira sul 50503392** —
   resta aperto, e la guardia e' **fail-open e MUTA**: non scrivera' **nessuna
   riga** nel Giornale. 👉 §5.3: **«nessuna riga GUARDIAN» e' il risultato
   ATTESO, non un difetto — e non e' una protezione.**
4. 🔴 **CARICARE IL PRESET ABBASSA LA TAGLIA: `InpRiskPercent` da 1,0 a 0,65.**
   E' una **DECISIONE DI CLAUDIO**, non un ripristino. 👉 §4.0, riquadro rosso.
5. 🟡 **Un effetto collaterale da guardare al primo ordine:** la ricompilazione
   porta in campo anche il **fix del sizing** dell'08/08. Non tocca il segnale,
   ma **cambia il modo in cui si calcola il lotto**. 👉 §1.2, punto B.
6. ⏰ **Il momento giusto e' ADESSO, domenica a mercato chiuso.** A mercato
   aperto lo stesso giro va fatto solo con la sedia **piatta** (§3.1).

---

# 1. 🔬 LA PARTE PARANOICA: COSA CAMBIA DAVVERO FRA IL CAMPO E QUELLO CHE SCHIERIAMO

## 1.1 I tre binari in gioco, per commit e per SHA256

| | commit | righe | `#property version` | SHA256 del `.mq5` (LF) |
|---|---|---|---|---|
| **IN CAMPO oggi** | `344a11b` (04/08) | 486 | `1.00` | `e4977e97...464eed` |
| 🎯 **MISURATO a R112 = DA SCHIERARE** | **`26a1856`** (19/08) | **552** | `1.00` | **`29cb8955...698c202`** |
| ⛔ `HEAD` — **NON COMPILARE** | `077afd0` | 690 | `1.00` | `228bb295...2f7a0c` |

🔴 **`#property version` e' `1.00` in tutti e tre.** Quindi **la versione NON
distingue i binari**: chi cerca di capire quale EA gira guardando il numero di
versione non lo scoprira' mai. L'unico segno leggibile a runtime e' la
**presenza dell'input `InpUsaGuardian`** nella scheda Input. Ci torniamo in §5.

**La catena che lega R112 al sorgente**, perche' non sia un'affermazione:
il pin di R112 e' `f33f374` (26/08); il `.mq5` a quel pin ha **552 righe**;
l'ultimo commit che tocca l'EA prima di `f33f374` e' **`26a1856`**. 👉 Il
sorgente di R112 **e' identico** a quello di `26a1856`, blob
`7be282e5c8fcb4a1216bbe446055390ea5a43ce1`.

## 1.2 I tre commit fra il campo e la versione misurata — uno per uno

`git log --oneline 344a11b..26a1856 -- mql5/Experts/ABTG_EMA200.mq5`

### A. `6074126` (08/08) — «Export per-trade nell'OnTester» → 🟢 **DIAGNOSTICA**
Aggiunge `ExportTrades()`, chiamata **solo da `OnTester()`**. `OnTester()` **non
esiste in live**: gira unicamente a fine backtest. In campo questa funzione e'
**codice morto**. **Segnale: no. Gestione: no. Rischio: no.**

### B. `3af47ed` (08/08) — «fix sizing: `OrderCalcProfit` al posto del tick value nudo» → 🟡 **TOCCA IL LOTTO, NON IL SEGNALE**
Dentro `LotByRisk()` la perdita-per-lotto ora la calcola `OrderCalcProfit()`
(che converte in valuta conto); il vecchio `SYMBOL_TRADE_TICK_VALUE` resta
**come ripiego** se il calcolo fallisce.
- **Non tocca il segnale**: non entra in nessuna condizione d'ingresso, non
  cambia ne' quando ne' dove si entra. La **frequenza non cambia**.
- 🟡 **Tocca quanto si compra.** Sui simboli sani i due calcoli **coincidono**
  (il bug si vedeva su `225JPY`, dove il tick value arrivava non convertito).
  Su `U30USD` **ci aspettiamo che coincidano**, ma **io non posso verificarlo
  senza terminale**: va **letto sul primo ordine** (§5.2).
- 🟢 **E comunque non invalida il numero**: questo fix e' **dentro** la versione
  misurata a R112. 👉 Fino a oggi era il **campo** a essere disallineato dalla
  misura. Questa ricompilazione **chiude quello scarto**, non ne apre uno.

### C. `26a1856` (19/08) — «Migrazione Guardian (pezzo 5)» → 🟡 **TOCCA L'INGRESSO, MA E' FAIL-OPEN**
Aggiunge `#include <ABTG_PausaGuardian.mqh>` (r.30), l'input `InpUsaGuardian`
(r.42) e **una riga** dentro `PlaceLimit()` (r.243):

```
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_EMA200")) return;
```

- E' l'**unica** riga che puo' cambiare il comportamento. Sta **prima**
  dell'invio e **dopo** il calcolo del lotto: puo' solo **impedire** un nuovo
  ingresso, **mai** aprirne uno, **mai** toccare posizioni gia' aperte,
  trailing, breakeven o uscite.
- 🟢 **E oggi non impedisce niente**, per costruzione. Seconda riga della
  funzione (`ABTG_PausaGuardian.mqh` r.1719):
  `if(!ABTG_CanaleEsiste()) return(true);   // nessun guardiano su questo conto`
  Senza Guardian che scrive le GlobalVariable, **lascia passare tutto**.
- 🟢 **Ed e' dentro la versione misurata**: R112 ha girato con questa riga gia'
  presente (nel tester il canale non esiste → stesso fail-open).

### ✅ Conclusione sulle tre
**Nessuna tocca il segnale.** Ingressi, filtri, SL, TP, trailing, breakeven,
cutoff e chiusura del venerdi' sono **identici byte per byte** fra il campo e
quello che schieriamo. Verificato con `diff` sulle funzioni `OnNewBar()`,
`PlaceOrders()`, `ManageAll()`, `CutoffCheck()`, `FridayCloseCheck()`.

## 1.3 ⛔ E IL QUARTO COMMIT, QUELLO CHE NON SCHIERIAMO: `b45dd00` (11/09)

`+154 / −16` righe sull'EA. Messaggio del commit, testuale:

> *«IN CORSO D'OPERA — NON COMPILARE ... questi file NON sono verificati, NON
> sono passati dal cancello ... NESSUNO DI QUESTI EA VA COMPILATO O CARICATO
> finche' non c'e' un PASS.»*

**Che cosa contiene, letto riga per riga** (l'«imbuto di mortalita'»):
18 contatori `long`, tre funzioni di sola stampa (`ImbutoRaccogli`,
`ImbutoStampa`, `ImbutoGiro`), un input nuovo `InpLogImbuto`, e **le 16 righe
«cancellate» che sono le stesse condizioni riscritte** per infilarci un `++`:

```
-   if(!SpreadOK()) return;
+   if(!SpreadOK()){ cB_spread++; return; }
```

🟢 **Verdetto della mia lettura: e' diagnostica pura.** Ho confrontato le
condizioni una per una: **nessuna condizione cambia, nessuna soglia cambia,
nessun contatore entra in un `if`, l'ordine dei filtri e' identico.** Anche le
due quadrature (`rifiuti + armate == valutate`, `rifiuti + piazzati ==
tentati`) tornano sugli indici.

🔴 **E LO SCHIERIAMO LO STESSO? NO. E le ragioni sono tre, tutte indipendenti
dalla mia lettura:**
1. **Non e' mai stato compilato da nessuno.** 154 righe nuove che non hanno mai
   visto un F7 possono non compilare affatto. **Io non posso compilare**: non
   ho MetaEditor. Metterle su una sedia viva stanotte sarebbe una scommessa.
2. **Non e' passato dal cancello**, e il commit stesso lo dichiara. La regola
   di casa (09/09) e' bloccante: niente esce senza un PASS.
3. **Non serve a niente per l'obiettivo di stanotte.** Sono log. Il Guardian
   sta gia' in `26a1856`. 👉 Schierare `26a1856` da' **il Guardian con rischio
   zero di regressione**; schierare `HEAD` aggiunge **138 righe di rischio per
   zero ingressi in piu'**.
4. 🟡 E porterebbe un **input in piu'** (`InpLogImbuto`): la sedia passerebbe da
   43 a 44 input, e il conto «44/44» del preset cambierebbe significato.

👉 **L'imbuto non e' morto: e' in coda.** Quando passa il cancello si ricompila
e si rimisura. Stanotte non entra.

---

# 1.4 🧰 COME E' FATTO IL GIRO (leggilo una volta, poi non ci pensi piu')

Tranne il primo (che **legge e basta**), ogni passo e' **la stessa riga** con una
parola diversa in fondo: `-Passo backup`, `-Passo compila`, `-Passo raccolta`,
e per il ritorno `-Passo ritorno` / `-Passo profili`.

Ogni riga fa sempre queste tre cose, **prima** di fare il suo lavoro:
1. **riscarica lo script** `RIGA_SCHIERA_EMA200.ps1` da GitHub **appuntato a un
   commit** (mai a un branch: un branch si muove, un commit no);
2. **controlla il marcatore** `MARCATORE_SCHIERA_EMA200_v1` e **si ferma** se
   trova una copia vecchia in cache;
3. **sceglie il terminale da `origin.txt`**, non a occhio, e **muore** se le
   candidate non sono esattamente una.

👉 Quindi: **si incolla, si legge cosa stampa, si passa al successivo.** Se una
riga si ferma, si ferma **prima** di aver toccato qualcosa.

---

# 2. 🖥️ PASSO 1 — RICONOSCERE I TERMINALI (sola lettura)

> 🎯 **BERSAGLIO: 🖥️ finestra PowerShell sul VPS.**
> **NON apre, NON chiude, NON tocca nessun terminale MT5.** Legge i processi
> vivi e la mappa delle cartelle dati. **Nessuna scrittura, da nessuna parte.**
> ⛔ **`C:\BCM_Reale` (conto reale 10105439) e' ESCLUSO dalla scansione, per
> scelta e per iscritto.** Non viene letto, non viene nominato come bersaglio,
> non viene toccato in nessun passo di questo pacchetto.

```powershell
& { $ErrorActionPreference='Continue'
  Write-Host "=== 1. PROCESSI MT5 / METAEDITOR VIVI ===" -ForegroundColor Cyan
  Get-Process terminal64,metaeditor64 -EA SilentlyContinue |
    Select-Object Id, ProcessName, MainWindowTitle, Path | Format-List
  Write-Host "=== 2. CARTELLE DATI -> CARTELLA PROGRAMMA (letta da origin.txt) ===" -ForegroundColor Cyan
  Write-Host "    Selettore POSITIVO: elenca SOLO le cartelle dati dei terminali BCM"
  Write-Host "    di Program Files. Gli altri profili del VPS non vengono nemmeno letti."
  Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal" -Directory -EA SilentlyContinue |
    ForEach-Object {
      $o = Join-Path $_.FullName 'origin.txt'
      if(-not (Test-Path $o)){ return }
      $orig = (Get-Content $o -Raw -EA SilentlyContinue)
      if($null -eq $orig){ return }
      $orig = $orig.Trim()
      if($orig -notlike '*Program Files*BCM Markets*'){ return }
      $ex = Join-Path $_.FullName 'MQL5\Experts\ABTG_EMA200.ex5'
      $info = '-- non presente --'
      if(Test-Path $ex){ $i = Get-Item $ex; $info = $i.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + '   ' + $i.Length + ' byte' }
      [pscustomobject]@{ CartellaDati=$_.Name; Programma=$orig; ABTG_EMA200_ex5=$info }
    } | Format-List
}
```

**Cosa devi vedere, e cosa vuol dire:**
- Nel blocco 1, i terminali vivi con **PID + titolo + cartella**. Il nostro e'
  quello con `Path` che contiene **`BCM Markets MT5 Terminal`** e **NON**
  contiene `-V3`. 🪟 **conto `50503392`**.
- Nel blocco 2, **una sola** riga deve avere `Programma` che finisce in
  `BCM Markets MT5 Terminal` senza `-V3`: quella e' la cartella dati che
  toccheremo. **Se ce ne sono due, FERMATI e dimmelo: non si tira a indovinare.**
- Se `metaeditor64` compare fra i processi vivi → **chiudilo prima di §3**
  (MetaEditor e' single-instance: con una copia gia' aperta il nostro
  `/compile` **torna subito senza aver compilato**, checklist 39).

---

# 3. 🛠️ PASSO 2 — PREVOLO E BACKUP

## 3.1 ✋ Il controllo che viene prima di tutto: la sedia dev'essere PIATTA

> 🎯 **BERSAGLIO: ✋ azione a mano dentro MT5, terminale `50503392`
> (`BCM Markets MT5 Terminal`, quello SENZA `-V3`).**
> Solo **guardare**. Non chiudere niente, non cancellare niente.

Scheda **Strumenti → Trade**. Cerca righe con commento **`EMA200 DOW`** (o
magic `771531`), sia **posizioni** sia **ordini pendenti**.

- 🟢 **Nessuna riga** → si procede.
- 🔴 **C'e' una posizione o un pendente** → **NON si procede.** Staccare l'EA
  con un ordine vivo lo lascia **senza trailing, senza breakeven e senza
  cutoff**. Si aspetta che sia piatta.
- ⏰ **Oggi e' domenica**: a mercato chiuso e' il momento migliore. I pendenti
  scadono dopo 6 barre H1 (`InpPendingExpiryBars=6`), quindi il fine settimana
  di solito la trova gia' piatta.

## 3.2 ✋ Staccare l'EA dal grafico

> 🎯 **BERSAGLIO: ✋ azione a mano dentro MT5, terminale `50503392`
> (`BCM Markets MT5 Terminal`, NON `-V3`).**
> ⛔ Non si tocca il `50504263`, non si tocca il `50504400`, e il `10105439`
> non e' nemmeno in questa stanza.

Sul grafico **U30USD H1** con `ABTG_EMA200`: tasto destro sul grafico →
**Consulenti esperti → Rimuovi**.

**Perche' si stacca prima invece di lasciare che MT5 ricarichi da solo:**
MT5 ricarica l'EA quando l'`.ex5` cambia, ma **tiene il file aperto** finche'
l'EA e' attaccato, e la scrittura di MetaEditor puo' fallire a meta'. Staccando
prima, la compilazione scrive su un file libero e **noi decidiamo** con quali
parametri riparte (§4). Nessuna sorpresa.

## 3.3 Il backup — e questa e' la rete del §6

> 🎯 **BERSAGLIO: 🖥️ finestra PowerShell sul VPS.**
> **LEGGE** dalla cartella dati del `50503392` e **SCRIVE SOLO sul Desktop del
> VPS**. ⛔ **Non scrive niente dentro nessun terminale.** Non tocca il
> `50504263`, il `50504400`, Pepperstone, Tickmill; `C:\BCM_Reale` e' escluso.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v1' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Passo backup;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: FERMO - leggi il messaggio qui sopra' -ForegroundColor Red } }
```

📌 **Lo script stampa in giallo `ANNOTA QUESTO PERCORSO`: copialo.** E' il
`<BACKUP>` che serve al §6, ed e' l'unica cosa di questo passo che devi tenere.

---

# 4. ⚙️ PASSO 3 — SCARICARE IL SORGENTE PINNATO E COMPILARE

## 4.0 🔴 IL RIQUADRO ROSSO CHE VA LETTO PRIMA DI PREMERE INVIO

> ## 🔴 CARICARE IL PRESET ABBASSA LA TAGLIA
> Il preset `ABTG_EMA200_U30USD_H1_771531_VIVA.set` porta
> **`InpRiskPercent=0.65`**. **In campo oggi quella sedia gira a `1.0`.**
> 👉 **Non e' un ripristino: e' una DECISIONE, ed e' TUA.**
> Questo script **copia il preset sul disco ma NON lo carica**: caricarlo e' un
> tuo click, in §4.3. Se vuoi lasciare la taglia com'e', **non caricare il
> preset** e rimetti a mano i valori documentati in §6.3.
> ⚖️ *Io non tocco taglie e parametri di rischio: sono firma di Claudio.*

## 4.1 Che cosa fa lo script, prima di farlo

1. Si ferma se **MetaEditor e' aperto** (altrimenti `/compile` torna subito
   senza compilare e dichiarerebbe un falso successo).
2. Scarica **tre file pinnati** da GitHub:
   - `ABTG_EMA200.mq5` **pinnato a `26a1856`** ← 🎯 la versione misurata a R112
   - `ABTG_PausaGuardian.mqh` pinnato a `077afd0`
   - il preset pinnato a `077afd0`
3. **Verifica lo SHA256 di ognuno** e si ferma se non torna. Accetta sia la
   versione LF sia quella CRLF (e **dichiara quale ha trovato**).
4. Copia i file nella cartella dati del **50503392** e compila.
5. Verdetto su **tre segnali indipendenti**: log della compilazione, data di
   modifica dell'`.ex5`, dimensione dell'`.ex5`.

> 🎯 **BERSAGLIO: 🖥️ finestra PowerShell sul VPS.**
> **SCRIVE dentro la cartella dati del solo terminale `50503392`
> (`BCM Markets MT5 Terminal`, NON `-V3`)**: tre file sorgente e un `.ex5`.
> ⛔ **NON tocca `50504263` (-V3), NON tocca `50504400` (`C:\MT5_Backtest`), NON
> tocca Pepperstone, NON tocca Tickmill, e `C:\BCM_Reale` / conto `10105439`
> resta fuori perimetro ed escluso dal selettore.** ⛔ **Non apre e non chiude
> nessun terminale**: il forward degli altri EA continua a girare.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v1' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Passo compila;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: FERMO - leggi il messaggio qui sopra' -ForegroundColor Red } }
```

## 4.2 🧪 IL CONTRO-ESEMPIO: perche' questa verifica non certifica il falso

Il difetto che volevo evitare e' **dichiarare compilato qualcosa che non lo e'**.
Ho costruito le tre ipotesi alternative e ho guardato se lo script le distingue:

| Se invece fosse successo che... | Il falso verdetto sarebbe | Cosa lo becca |
|---|---|---|
| **MetaEditor era gia' aperto** e `/compile` e' tornato subito | «compilato», con l'`.ex5` **vecchio** | ✅ doppia rete: il controllo sui processi **e** `LastWriteTime` invariato |
| **GitHub ha servito un file diverso** (branch mosso, cache, copia vecchia) | «ho compilato la versione misurata» ma e' un'altra | ✅ SHA256 pinnato **al commit**, non al branch: si ferma **prima** di copiare |
| **La compilazione e' fallita** con errori | «fatto», e il grafico riparte sul binario vecchio | ✅ conteggio `N error` dal log **+** `.ex5` assente/invariato |

🔴 **E il contro-esempio sulla prova «grep dentro l'`.ex5`», che e' quello che
mi avrebbe fregato.** L'`.ex5` e' **compresso**: se cercassi `InpUsaGuardian`
nei byte e **non** lo trovassi, un lettore distratto concluderebbe «la
compilazione non ha preso il Guardian» — **e sarebbe falso**. Per questo nello
script quella riga e' etichettata **«PROVA IN PIU', NON E' IL VERDETTO»** e
dice a chiare lettere che **l'assenza non prova niente**.
👉 **Il verdetto vero si regge su una catena che non ha buchi:**
SHA256 del sorgente = quello di R112 · **0 errori** nel log · `.ex5` riscritto
**adesso**. Se il sorgente era quello e la compilazione e' andata a buon fine,
l'`.ex5` **e'** quel sorgente. La conferma leggibile arriva in §5.1.

## 4.3 ✋ PASSO 4 — ATTACCARE L'EA COL PRESET

> 🎯 **BERSAGLIO: ✋ azione a mano dentro MT5, terminale `50503392`
> (`BCM Markets MT5 Terminal`, quello SENZA `-V3`).**
> ⛔ Nessun altro terminale va aperto o toccato.

1. **Navigatore → Consulenti esperti**: tasto destro → **Aggiorna**. Serve a
   far rileggere a MT5 l'`.ex5` appena scritto.
2. Apri (o riprendi) il grafico **`U30USD`, periodo `H1`**.
3. Trascina **`ABTG_EMA200`** sul grafico.
4. Nella finestra che si apre, scheda **Comune**: spunta
   **«Consenti trading algoritmico»**.
5. Scheda **Parametri di input** → **`Carica`** → scegli
   **`ABTG_EMA200_U30USD_H1_771531_VIVA.set`**
   (e' gia' nella cartella `MQL5\Presets`, ce l'ha messa lo script).
   > 🔴 **Da questo click in poi la taglia e' 0,65% invece di 1,0%.** Se non lo
   > vuoi, **non caricare** e metti i valori a mano (§6.3).
6. 🟡 **Il preset ha una riga in piu' di quelle che l'EA conosce:
   `InpLogImbuto`.** E' l'input dell'imbuto che **non schieriamo** (§1.3). MT5
   **la ignora** senza protestare. **E' atteso: non e' un errore.** Gli input
   che contano sono **43 su 43**.
7. **Prima di premere OK**, verifica a occhio queste cinque righe:

| input | valore atteso | perche' e' in questa lista |
|---|---|---|
| `InpMagic` | **771531** | il default e' `771501`: sarebbe **un'altra sedia** |
| `InpTF` | **PERIOD_H1 (16385)** | il default e' **H4**: sarebbe un'altra strategia |
| `InpAllowLong` / `InpAllowShort` | **true / true** | la cella promossa e' a **due lati**; il long puro vale PF 1,24 |
| `InpRiskPercent` | **0.65** | 🔴 **decisione tua** (in campo era 1,0) |
| `InpUsaGuardian` | **true** | 🎯 **se questa riga non c'e', l'EA caricato e' ancora il vecchio** |

8. **OK.**

---

# 5. ✅ PASSO 5 — LA VERIFICA DOPO L'ATTACCO

## 5.1 🎯 La prova che il binario nuovo e' quello caricato

> 🎯 **BERSAGLIO: ✋ azione a mano dentro MT5, terminale `50503392`
> (`BCM Markets MT5 Terminal`, NON `-V3`).** Solo guardare.

Tasto destro sul grafico → **Lista degli esperti** → **Proprieta'** → scheda
**Parametri di input**: **deve comparire `InpUsaGuardian`**.

🔴 **Questa e' LA prova, e ha una ragione precisa per esserlo.** `#property
version` e' `1.00` in **tutte e tre** le versioni (§1.1), quindi il numero di
versione **non distingue niente**. L'unico segno visibile a runtime della
differenza fra il binario del 04/08 e quello nuovo e' **l'esistenza di quell'input**.
- ✅ **C'e'** → sta girando il binario ricompilato. Fail-open n.1 **chiuso**.
- ❌ **Non c'e'** → sta ancora girando il vecchio. **Torna al §4.1** (quasi
  sempre: MetaEditor era aperto, oppure manca l'«Aggiorna» del punto 1).

Nella scheda **Esperti** (Strumenti → Esperti) deve comparire una riga di
inizializzazione di `ABTG_EMA200` **con l'ora di adesso**.

## 5.2 🟡 Il primo ordine: guarda il lotto

Al **primo ordine limite** piazzato dopo la riapertura dei mercati, confronta il
**volume** con quelli delle settimane scorse, **tenendo conto che hai cambiato
anche il rischio** (1,0 → 0,65: a parita' di tutto il resto il lotto dovrebbe
scendere di circa **il 35%**).
- 🟢 Se il rapporto e' quello → il fix del sizing (§1.2 B) **coincide** col
  vecchio calcolo su `U30USD`, come ci aspettavamo.
- 🔴 Se il lotto e' **molto** diverso da cosi' → **fermati e dimmelo**: vuol
  dire che su `U30USD` i due calcoli **non** coincidevano, ed e' un numero che
  va messo a verbale prima di lasciar correre la sedia.

## 5.3 🔴 IL GUARDIAN NON SCRIVERA' NIENTE — ED E' GIUSTO COSI'

**Non cercare una riga `[GUARDIAN]` o `[GUARDIA]` nel Giornale: non arrivera'.**
La guardia, seconda riga, fa:
`if(!ABTG_CanaleEsiste()) return(true);` → **se nessun Guardian gira su questo
conto, lascia passare tutto e non stampa nulla.**

👉 **Quindi dopo questo giro la situazione e' esattamente questa:**
- 🟢 **Fail-open n.1 CHIUSO**: il binario ora **sa** leggere il Guardian.
- 🔴 **Fail-open n.2 APERTO**: sul **50503392 nessun Guardian gira**, quindi
  **non c'e' ancora nessuna pausa B1 e nessun cap C1 su questa sedia.**

⚖️ **Detto senza giri di parole: stanotte non abbiamo protetto la sedia,
abbiamo reso POSSIBILE proteggerla.** Il passo che protegge davvero e'
**mettere un Guardian sul 50503392** — e quello porta dentro **soglie di pausa
e cap di rischio**, cioe' **firma di Claudio**: non lo faccio io, non stanotte,
e non di nascosto dentro un pacchetto che parla d'altro.
📌 Nota di stato: l'unico preset Guardian che esiste in casa e'
`ABTG_Guardian_50504263_779001_VIVO.set`, ed e' **per il 100k `50504263`**, non
per il piccolo. **Per il 50503392 il preset non esiste ancora.**

## 5.4 La raccolta (regola di casa: i risultati finiscono sul Desktop del VPS)

> 🎯 **BERSAGLIO: 🖥️ finestra PowerShell sul VPS.**
> **LEGGE** i log del solo `50503392` e **SCRIVE SOLO sul Desktop del VPS**.
> ⛔ Non tocca nessun terminale, nessun EA, nessun grafico. `C:\BCM_Reale`
> escluso dal selettore.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v1' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Passo raccolta;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: FERMO - leggi il messaggio qui sopra' -ForegroundColor Red } }
```

**Nello zip devi trovare:** `IMPRONTE_DOPO.txt`, `FILE_EMA200.txt`, e almeno un
`*_AAAAMMGG.log`. Se manca `IMPRONTE_DOPO.txt` l'`.ex5` non c'e': **non
attaccare niente e torna al §4.1.**

---

# 6. 🔴 IL RITORNO INDIETRO — come si rimette esattamente com'era

**Questa sezione non e' opzionale.** Vale in tre casi: compilazione con errori,
`InpUsaGuardian` che non compare, comportamento strano alla riapertura.

## 6.1 Ritorno RAPIDO (non chiude nessun terminale)

> 🎯 **BERSAGLIO: 🖥️ finestra PowerShell sul VPS**, dopo aver **staccato l'EA
> dal grafico** (✋ in `50503392`, `BCM Markets MT5 Terminal`, NON `-V3`).
> **SCRIVE solo nella cartella dati del `50503392`**, rimettendo i file salvati
> in §3.3. ⛔ Non tocca `50504263`, `50504400`, Pepperstone, Tickmill;
> `C:\BCM_Reale` fuori perimetro.

**Prima**: ✋ grafico → tasto destro → **Consulenti esperti → Rimuovi**
(l'`.ex5` non si puo' riscrivere mentre l'EA lo tiene aperto).

Poi, **mettendo al posto di `<BACKUP>` il percorso stampato in §3.3**:

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v1' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Passo ritorno -Backup '<BACKUP>';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: FERMO - leggi il messaggio qui sopra' -ForegroundColor Red } }
```

## 6.2 Ritorno ESATTO anche dei parametri (richiede di chiudere il terminale)

I parametri del grafico stanno nei `.chr` di `MQL5\Profiles\Charts`, che MT5
**legge all'avvio e riscrive alla chiusura**. Rimetterli a caldo non serve.

> 🎯 **BERSAGLIO: 🪟 terminale `50503392` (`BCM Markets MT5 Terminal`, NON
> `-V3`) — VA CHIUSO E RIAPERTO A MANO.**
> 🔴 **Chiudere quel terminale ferma il forward di TUTTI gli EA che ci girano,
> non solo di questa sedia.** E' una decisione di Claudio, non un passaggio
> automatico. ⛔ Gli altri cinque profili dati del VPS non vengono toccati.

1. ✋ Chiudi il terminale **`50503392`**.
2. 🖥️ In PowerShell sul VPS, sostituendo `<BACKUP>`:

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v1' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Passo profili -Backup '<BACKUP>';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: FERMO - leggi il messaggio qui sopra' -ForegroundColor Red } }
```

3. ✋ Riapri **`50503392`** e controlla che il grafico `U30USD H1` sia tornato.

🛡️ **Rete:** se il terminale e' ancora aperto, lo script **si rifiuta di
procedere e stampa il PID** invece di copiare. Motivo: MetaTrader riscrive i
`.chr` **alla chiusura**, quindi rimetterli a caldo li farebbe cancellare da lui
pochi minuti dopo — e sarebbe un ritorno indietro **che sembra fatto e non lo e'**.

## 6.3 📋 I valori del CAMPO, per rimetterli a mano

Se riattacchi senza preset, questi sono i valori **che c'erano in campo prima di
stanotte** (fonte: foto del profilo del terminale `50503392`, CODA_08 del 12/09).
⚖️ **Li scrivo come REGISTRO di quello che c'era, non come una mia proposta.**

| input | valore IN CAMPO prima di stanotte |
|---|---|
| `InpMagic` | **771531** |
| `InpTF` | **PERIOD_H1** |
| `InpRiskPercent` | 🔴 **1.0** *(il preset lo porta a 0,65: tua decisione)* |
| `InpAllowLong` / `InpAllowShort` | true / true |
| `InpComment` | `EMA200 DOW` |
| `InpUsaGuardian` | **non esisteva** (il binario vecchio non ce l'ha) |

👉 Tutti gli altri 37 input coincidono con quelli del preset: per loro
**caricare il preset E' il ritorno al campo**.

---

# 7. 🧾 COSA QUESTO PACCHETTO NON FA — dichiarato

- ❌ **Non schiera `HEAD`** (§1.3): l'imbuto di mortalita' resta in coda al cancello.
- ❌ **Non mette un Guardian sul 50503392** (§5.3): il fail-open n.2 resta
  aperto, e chiuderlo richiede soglie di rischio = **firma di Claudio**.
- ❌ **Non cambia nessuna taglia da solo**: il preset esiste, il click e' di Claudio.
- ❌ **Non misura niente.** Qui non gira **nessun** backtest: PF, DD e n restano
  quelli di R112. Questo foglio sposta un binario, **non produce un numero**.
- ❌ **Non tocca il conto reale 10105439**, escluso da ogni selettore.
- ❌ **Non tocca `50504263`, `50504400`, Pepperstone, Tickmill.**

# 8. 🚦 IL CANCELLO SU QUESTO PACCHETTO

Il pacchetto sono **due file**, e vanno letti insieme:

| file | cosa e' |
|---|---|
| `report/PACCHETTO_SCHIERAMENTO_EMA200_2026-09-13.md` | questo foglio: il giro, le verifiche, il ritorno indietro |
| `backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1` | lo script che fa il lavoro, marcatore `MARCATORE_SCHIERA_EMA200_v1` |

📌 **Perche' lo script sta in un `.ps1` del repo e non dentro il foglio.**
La prima stesura aveva i comandi **incollati qui dentro**, ed e' stata
**bocciata dal cancello con 7 difetti bloccanti**: un blocco che scrive dentro
`MQL5\Experts` non e' ne' di sola lettura ne' una raccolta, quindi **non e'
appuntabile a un commit** — cioe' nessuno puo' dimostrare, dopo, quale codice
ha girato davvero. Messo in un `.ps1` **pinnato al commit e con un marcatore**,
ogni riga di lancio e' **riproducibile e verificabile**.
🧾 *Detto com'e': e' un difetto che ho fatto io e che il cancello ha preso.
Il cancello ha funzionato.*

**Esito dei controlli deterministici** (`controlla_riga.py`):
- ✅ `--oggetto ps1` sullo script → **nessun difetto meccanico** (ASCII puro,
  0 errori dal parser PowerShell vero, niente costrutti pwsh-7).
- ✅ `--oggetto md` su questo foglio → **PASS**, con i rilievi non bloccanti
  elencati nella consegna al coordinatore.
- ⏳ **Agente `controllo-preventivo`: lo lancia il coordinatore, non io.** Fino
  a quel PASS **questo pacchetto non va mandato a Claudio.**

📌 Nessuna riga di questo foglio e' stata eseguita: **non ho MT5, non ho
MetaEditor, non ho toccato il VPS e non ho toccato il forward.**

---

*Scritto nella notte fra il 12 e il 13/09/2026. Fonti: `git log`/`git show` sui
blob del repo, `report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md`,
`report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md`, il preset
`mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set`.*
