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

# 0. 🥇 IL VERDETTO IN SETTE RIGHE

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
3. 🔴 **E LA TRAPPOLA AVEVA UN GEMELLO, che il cancello ha preso a me.** Il
   `.ex5` si compila da **DUE** unita', e io ne avevo appuntata **una**: il
   `.mq5` a `26a1856` e **l'include a `HEAD`**, che ha **+1000 righe** rispetto
   a quello di R112 e **due commit intitolati «LAVORO IN CORSO»**. Corretto:
   l'include e' appuntato a **`f33f374`**, il pin di R112. 👉 §1.1-bis.
4. 🔴 **E LA RICOMPILAZIONE DA SOLA NON PROTEGGE NIENTE.** I fail-open erano
   **due**. Questo giro chiude **solo il primo** (il binario senza
   `InpUsaGuardian`). Il secondo — **nessun Guardian gira sul 50503392** —
   resta aperto, e la guardia e' **fail-open e MUTA**: non scrivera' **nessuna
   riga** nel Giornale. 👉 §5.3: **«nessuna riga GUARDIAN» e' il risultato
   ATTESO, non un difetto — e non e' una protezione.**
5. 🔴 **CARICARE IL PRESET ABBASSA LA TAGLIA: `InpRiskPercent` da 1,0 a 0,65.**
   E' una **DECISIONE DI CLAUDIO**, non un ripristino. 👉 §4.0, riquadro rosso.
6. 🟡 **IL LOTTO CAMBIERA', ED E' ATTESO.** Col preset le gambe attese sono
   **`0.10` e `0.20`** (**−50%** e **−33%** rispetto a quelle di oggi), **non**
   un difetto: e' il passo del volume, che e' `0,10`. ⚠️ **Dipende da bilancio e
   ATR**: al confine possono restare `0,20 / 0,30`, ed e' ugualmente corretto.
   👉 §5.2 — dove c'e' anche il rischio reale, che e' una **banda 0,38-0,46% che
   al confine arriva a 0,641%**, cioe' praticamente il nominale: **non e'
   sempre piu' prudente del dichiarato.**
7. ⏰ **Il momento giusto e' ADESSO, domenica a mercato chiuso.** A mercato
   aperto lo stesso giro va fatto solo con la sedia **piatta** (§3.1).

---

# 1. 🔬 LA PARTE PARANOICA: COSA CAMBIA DAVVERO FRA IL CAMPO E QUELLO CHE SCHIERIAMO

## 1.1 I tre binari in gioco, per commit e per SHA256

| | commit | righe | `#property version` | SHA256 del `.mq5` (LF) |
|---|---|---|---|---|
| **IN CAMPO oggi** | `344a11b` (04/08) | 486 | `1.00` | `e4977e97...464eed` |
| 🎯 **MISURATO a R112 = DA SCHIERARE** | **`26a1856`** (19/08) | **552** | `1.00` | **`29cb8955...698c202`** |
| ⛔ `HEAD` — **NON COMPILARE** | `077afd0` | 690 | `1.00` | `228bb295...2f7a0c` |

📌 **E questi sono solo i `.mq5`: la seconda unita' di compilazione — l'include
— ha un suo pin, e all'inizio l'avevo sbagliato. Vedi §1.1-bis.**

🔴 **`#property version` e' `1.00` in tutti e tre.** Quindi **la versione NON
distingue i binari**: chi cerca di capire quale EA gira guardando il numero di
versione non lo scoprira' mai. L'unico segno leggibile a runtime e' la
**presenza dell'input `InpUsaGuardian`** nella scheda Input. Ci torniamo in §5.

**La catena che lega R112 al sorgente**, perche' non sia un'affermazione:
il pin di R112 e' `f33f374` (26/08); il `.mq5` a quel pin ha **552 righe**;
l'ultimo commit che tocca l'EA prima di `f33f374` e' **`26a1856`**. 👉 Il
sorgente di R112 **e' identico** a quello di `26a1856`, blob
`7be282e5c8fcb4a1216bbe446055390ea5a43ce1`.

## 1.1-bis 🔴 IL `.ex5` SI COMPILA DA **DUE** UNITA', E ALL'INIZIO NE AVEVO APPUNTATA UNA

📌 **Classe 302 della checklist** (*il binario si compila da PIU' file:
appuntare il solo `.mq5` non appunta l'`.ex5`*). ⚠️ Nata come «292», che era
**gia' occupata** dal 12/09: il numero buono e' **302**.

**Difetto mio, trovato dal cancello, e va scritto perche' e' istruttivo:** avevo
appuntato il `.mq5` a `26a1856` e **l'include a `HEAD`**. Cioe' avevo rifiutato
`HEAD` per un file e l'avevo accettato per l'altro — **la stessa trappola del §0
punto 2, applicata all'altro pezzo**.

| unita' di compilazione | pin corretto | righe |
|---|---|---|
| `ABTG_EMA200.mq5` | `26a1856` (blob identico a `f33f374`) | 552 |
| 🔴 `ABTG_PausaGuardian.mqh` | **`f33f374`** = il pin di R112 | **1461** |

**Quanto pesava l'errore:** l'include a `HEAD` ha **2461** righe, cioe'
**+1000 righe** rispetto a quello con cui R112 ha misurato. E fra quei commit
**due si intitolano testualmente «LAVORO IN CORSO»**:
- `8c0a1db` — *«tetto cluster: le funzioni di calcolo, NON ancora collegate»*
- `cdb2037` — *«tetto cluster C2 collegato, SPENTO di default»*

✅ **Perche' `f33f374` compila lo stesso:** li' (r.1007)
`ABTG_GuardiaIngresso` ha **8 parametri, con default dal secondo in poi**, e
l'EA la chiama con **due argomenti**. Verificato leggendo la firma a quel pin.

📌 **Il preset fa eccezione, ed e' dichiarato:** a `f33f374` **non esiste**
(e' nato il 12/09), quindi resta appuntato a `077afd0`. Non e' una svista:
e' l'unico file dei tre che non puo' avere il pin di R112.

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

🔴 **Qui la prima stesura diceva una cosa FALSA** — *«non entra in nessuna
condizione d'ingresso»* — e il cancello l'ha presa. E' falso: `PlaceLimit()`
r.239 fa `if(lot<=0){ ... return; }`, quindi **il lotto E' un cancello
d'ingresso**. Un lotto che esce 0 **annulla l'ordine**.

✅ **E la frase giusta e' piu' forte di quella sbagliata.** Guardando il codice:
il nuovo `LotByRisk` restituisce 0 **solo se** fallisce il ramo
`OrderCalcProfit` **e poi** fallisce anche il vecchio calcolo col tick value
(che e' il ripiego). Quindi:

> **{casi in cui il NUOVO restituisce 0} e' un SOTTOINSIEME di {casi in cui il
> VECCHIO restituiva 0}.**

👉 **Il nuovo codice non puo' MAI bloccare un ingresso che il vecchio
permetteva.** Puo' solo permetterne **qualcuno in piu'** (dove il tick value
mentiva). Sulla frequenza degli ingressi il cambiamento e' **a senso unico**,
e su `U30USD` — dove il tick value non mente — **e' zero**.

- 🟡 **Su quanto si compra, invece, cambia**: il lotto puo' uscire diverso.
  Va **letto sul primo ordine**, e il §5.2 dice **esattamente quale numero
  aspettarsi**.
- 🟢 **E non invalida il numero**: questo fix e' **dentro** la versione misurata
  a R112. Fino a oggi era il **campo** a essere disallineato dalla misura.

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
- 🟢 **E oggi non impedisce niente.** Il perche' — con i numeri presi
  **dall'include che spediamo davvero** — sta in **§5.3**, e qui non lo
  ripeto: la prima stesura lo diceva in due posti, con numeri di riga di **due
  file diversi**, e il documento **contraddiceva se stesso** su una sedia viva.
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
2. **controlla il marcatore** `MARCATORE_SCHIERA_EMA200_v3` e **si ferma** se
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
  Write-Host "    Selettore POSITIVO e IDENTICO a quello dello script: origin.txt deve"
  Write-Host "    contenere 'BCM Markets MT5 Terminal' e NON contenere '-V3'."
  Write-Host "    Quello che vedi qui e' esattamente l'insieme su cui agira' la macchina."
  $trovate = @(Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal" -Directory -EA SilentlyContinue |
    ForEach-Object {
      $o = Join-Path $_.FullName 'origin.txt'
      if(-not (Test-Path $o)){ return }
      $orig = (Get-Content $o -Raw -EA SilentlyContinue)
      if($null -eq $orig){ return }
      $orig = $orig.Trim()
      # STESSO PREDICATO DELLO SCRIPT, parola per parola: altrimenti Claudio
      # controlla una lista e la macchina ne sceglie un'altra.
      if($orig -notlike '*BCM Markets MT5 Terminal*'){ return }
      if($orig -like '*-V3*'){ return }
      $ex = Join-Path $_.FullName 'MQL5\Experts\ABTG_EMA200.ex5'
      # un campo VUOTO non dice niente: il "manca" si scrive con una parola.
      $quando = 'ASSENTE'
      $quanto = 'ASSENTE'
      if(Test-Path $ex){ $i = Get-Item $ex; $quando = $i.LastWriteTime; $quanto = $i.Length }
      [pscustomobject]@{ CartellaDati=$_.Name; Programma=$orig; ex5_data=$quando; ex5_byte=$quanto }
    })
  $trovate | Format-List
  Write-Host ("CANDIDATE TROVATE: " + $trovate.Count + "   (ne serve ESATTAMENTE UNA)")
  if($trovate.Count -ne 1){
    throw "VIETATO proseguire: le candidate non sono esattamente una. Non si tira a indovinare: mandami questo elenco e fermati qui."
  }
  Write-Host "UNA SOLA CANDIDATA: e' quella su cui agiranno i passi successivi." -ForegroundColor Green
}
```

**Cosa devi vedere, e cosa vuol dire:**
- Nel blocco 1, i terminali vivi con **PID + titolo + cartella**. Il nostro e'
  quello con `Path` che contiene **`BCM Markets MT5 Terminal`** e **NON**
  contiene `-V3`. 🪟 **conto `50503392`**.
- Nel blocco 2 deve uscire **una riga sola**: quella e' la cartella dati che
  toccheremo. **Se ne escono due, FERMATI e dimmelo: non si tira a indovinare.**
  ✅ **Il predicato di questa lista e' lo STESSO, parola per parola, che usa lo
  script** (`origin.txt` contiene `BCM Markets MT5 Terminal` e **non** contiene
  `-V3`). 👉 Cosi' quello che controlli tu **e'** l'insieme su cui agisce la
  macchina: se qui ne vedi una, la macchina non puo' sceglierne un'altra.
- 🛡️ **E lo script aggiunge due CONFERME** (il conto nel giornale, la presenza
  di `ABTG_EMA200.ex5`). ⚠️ Se in quei giornali trova **un conto diverso dal
  bersaglio**, **si ferma** invece di scrivere. Se un giorno quel terminale
  avesse ospitato un altro login, lo script rifiutera' di partire: **e' voluto**
  — meglio fermo che sulla cartella sbagliata.
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
    $pin='030695014741aca1a5fda1260a2af6a11f918c77'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v3' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
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
2. Scarica **tre file pinnati** da GitHub — e **i pin sono tre, diversi**:
   - `ABTG_EMA200.mq5` → **`26a1856`** ← 🎯 la versione misurata a R112
   - `ABTG_PausaGuardian.mqh` → **`f33f374`** ← 🎯 **il pin di R112** (1461
     righe). ⚠️ *Qui avevo sbagliato: era appuntato a `HEAD`. Vedi §1.1-bis.*
   - il preset → `077afd0`, **perche' a `f33f374` non esiste** (dichiarato)
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
    $pin='030695014741aca1a5fda1260a2af6a11f918c77'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v3' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
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

## 5.2 🟡 Il primo ordine: i lotti ATTESI sono `0.10` e `0.20`

> 🔴 **Due stesure sbagliate di fila su questo numero, e la seconda e' colpa di
> un dato che era GIA' IN CASA.** La prima diceva *«circa −35%»* (senza la
> quantizzazione). La seconda l'ho ricavata **ri-scalando `0,20` e `0,30`** —
> ma **quelli sono gia' il risultato di `MathFloor`**, quindi ho applicato il
> passo **due volte** e mi e' uscito `0,10 / 0,10`.
> 👉 I lotti **calcolati** stanno scritti in
> `report/DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` **r.187-188**
> (tabella *«LO STEP MORDE»*): **`0,2546` e `0,3819`** a rischio 1,0%.
> **Il file che aveva la risposta era nella stessa cartella, e non l'avevo
> aperto.**

**Il conto, partendo dai lotti VERI.** `PlaceOrders()` divide il rischio fra le
due gambe (`riskPct = InpRiskPercent/nOrders` → 0,325% ciascuna), e
`LotByRisk()` chiude con `lot = MathFloor(lot/st)*st` e `MathMax(mn, ...)`:
**arrotonda per DIFETTO al passo 0,10 e non scende mai sotto 0,10.**

| gamba | calcolato a 1,0% (dossier r.187-188) | × 0,65 | **messo** | in campo oggi | differenza che vedrai |
|---|---:|---:|---:|---:|---:|
| 1 | 0,2546 | 0,1655 | **0,10** | 0,20 | **−50%** |
| 2 | 0,3819 | 0,2482 | **0,20** | 0,30 | **−33%** |

### 🔴 E NON E' UN NUMERO FISSO: dipende da BILANCIO e ATR
Il lotto e' `rischio / (stop × valore punto)`, e lo stop e' in ATR: **basta
poco per cambiare gradino.** Le tre celle misurate:

| bilancio | ATR | g1 voluta → messa | g2 voluta → messa | rischio REALE |
|---:|---:|---|---|---:|
| 5.160 | 65,5 | 0,1982 → **0,10** | 0,2974 → **0,20** | 0,383% |
| 5.160 | 78,0 | 0,1665 → **0,10** | 0,2497 → **0,20** | 0,456% |
| 5.276 | 65,5 | 0,2027 → **0,20** | 0,3040 → **0,30** | **0,641%** |

- La gamba 2 scende a **`0,10`** solo con **ATR oltre ~97** — **fuori**
  dall'intervallo misurato (65,5 / 73,6 / 78,0). 👉 **`0,10 / 0,10` non e' lo
  scenario atteso**, era il mio errore di conto.
- La gamba 1 sale a **`0,20`** appena il bilancio cresce un po' (terza riga):
  **il confine e' vicino**, non teorico.

### ✅ La verifica giusta — ed e' l'unica cosa che non e' cambiata
🛡️ **La regola di arresto regge a tutte e tre le stesure**, perche' e' scritta
sulle **proprieta'** e non sul valore atteso. Non cambiarla:
- 🟢 **Normale**: lotti **multipli di 0,10**, **non piu' grandi** di quelli di
  oggi (0,20 / 0,30). `0,10 / 0,20` e' l'attesa piu' probabile; `0,20 / 0,30`
  succede al confine ed e' **ugualmente corretto**.
- 🔴 **Fermati e dimmelo solo se**: il lotto **non e' multiplo di 0,10**, oppure
  e' **piu' grande** di quelli di oggi.
- ✋ **Il numero che regge tutto** e' `VOLUME_STEP`: in MT5, `U30USD` → tasto
  destro nel Market Watch → **Specifica** → *Volume minimo* e *Passo del
  volume*. Se **non** sono `0,10`, le tabelle qui sopra vanno rifatte.

### 🔴 IL RISCHIO REALE: una BANDA, e NON e' sempre piu' prudente del dichiarato

> 🔴 **Qui la stesura precedente ha messo sotto la tua firma una frase falsa:**
> *«~0,42% effettivo — e' piu' PRUDENTE del dichiarato»*. **Sbagliata, e nella
> direzione peggiore in cui sbagliare un numero che qualcuno firma.**

```
caso tipico   : 0,38% - 0,46%   (le due gambe a 0,10 e 0,20)
caso di CONFINE: 0,641%          (le due gambe salgono a 0,20 e 0,30)
nominale       : 0,650%
```

👉 **Nel caso di confine il rischio reale e' praticamente il nominale.** La
frase giusta e': *il passo del volume rende il rischio **piu' basso o uguale**
al dichiarato, **mai piu' alto** — ma «piu' basso» **non e' garantito**, e nel
caso di confine il margine e' **quasi zero**.*
⚖️ E resta vero che **a questa taglia la manopola del rischio ha grana grossa**:
fra un gradino e l'altro il rischio effettivo salta di oltre due decimi di
punto. E' un fatto da tenere presente **prima** di decidere la taglia — ma la
taglia e' **tua**, e io non la propongo.

## 5.3 🔴 IL GUARDIAN NON SCRIVERA' NIENTE — ED E' GIUSTO COSI'

**Non cercare una riga `[GUARDIAN]` o `[GUARDIA]` nel Giornale: non arrivera'.**

> 🔴 **La prima stesura dava la ragione sbagliata DUE VOLTE, e la seconda volta
> e' peggio della prima.** Diceva *«la guardia, seconda riga, fa
> `if(!ABTG_CanaleEsiste()) return(true)`»* (falso: `// 2.` e' il **passo**, non
> la riga). Poi, corretta, citava **r.1587 / r.1719, 132 righe, quattro
> cancelli**: numeri veri… **di `HEAD`**, cioe' di un file che **questo
> pacchetto non spedisce piu'** da quando l'include e' appuntato a `f33f374`.
> 👉 **La lezione, ed e' quella che ci e' costata tre volte stanotte: il file
> CITATO e il file SPEDITO devono essere lo stesso, e si verifica col comando.**

**I numeri veri, misurati su `f33f374` — l'include che il pacchetto installa:**

| | `f33f374` (SPEDITO) | `HEAD` (non spedito) |
|---|---|---|
| inizio di `ABTG_GuardiaIngresso` | **r.1007** | r.1587 |
| fail-open `ABTG_CanaleEsiste` | **r.1027** | r.1719 |
| righe in mezzo | **20** | 132 |
| cancelli in mezzo | **DUE**: STOP S1, freno P1 | quattro (S1, P1, P0, C2) |
| occorrenze di `cluster_mappa` | **ZERO** | 6 |

**La ragione, adesso corretta:** i due cancelli intermedi di `f33f374` sono
**opt-in** e si accendono solo se chi chiama passa gli argomenti giusti. Il call
site e' `PlaceLimit()` e passa **DUE argomenti**, quindi `obiettivo_pct` e
`soglia_perdite_consecutive` restano a `0` → **no-op**. Si arriva al fail-open
sul canale, e la guardia tace.

🟢 **E cosi' la conclusione e' PIU' forte di prima**: sull'include che
spediamo la guardia tace **di piu'** — due cancelli invece di quattro, e il
fail-open arriva dopo **20** righe invece di 132.

🔴 **E LA SCADENZA VERA, che la stesura precedente aveva sbagliato di netto.**
Avevo scritto *«la sicurezza si perde quando qualcuno cabla `cluster_mappa`»*:
**contro `f33f374` quel parametro NON ESISTE** (zero occorrenze), quindi
cablarlo **non compilerebbe nemmeno**. 👉 La condizione vera ha **due** pezzi, e
servono **tutti e due**:

> **(1)** qualcuno **ricompila questa sedia contro un include piu' NUOVO** (dove
> i parametri esistono), **e (2)** ne **cabla** uno nel call site di
> `PlaceLimit()`.

Con l'include spedito oggi, **nessuno dei due pezzi e' possibile da solo**: chi
fa solo (2) non compila, chi fa solo (1) lascia i default e la guardia continua
a tacere. 👉 Chi un domani fara' tutti e due **sta cambiando il comportamento di
`771531`**, non aggiungendo un log.

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
    $pin='030695014741aca1a5fda1260a2af6a11f918c77'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v3' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
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

📋 **Che cosa il ritorno rimette davvero, dichiarato riga per riga** (la prima
stesura diceva *«esattamente com'era»* e **non era vero**: il preset non era ne'
salvato ne' tolto, e sarebbe rimasto sul disco un file che prima non c'era):

| cosa | §6.1 lo rimette? |
|---|---|
| `ABTG_EMA200.ex5` (il binario del 04/08) | ✅ si, dal backup |
| `ABTG_EMA200.mq5` | ✅ si, dal backup |
| `ABTG_PausaGuardian.mqh` (l'include condiviso dai 72 EA) | ✅ si, dal backup |
| il preset `.set` | ✅ si: se **c'era** lo rimette com'era, se **non c'era** lo **TOGLIE** |
| i **parametri** del grafico (`.chr`) | ❌ **no** → serve il §6.2 (terminale chiuso) o la tabella §6.3 |
| l'EA **attaccato** al grafico | ❌ **no**: lo riattacchi tu a mano |

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
    $pin='030695014741aca1a5fda1260a2af6a11f918c77'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v3' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
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
    $pin='030695014741aca1a5fda1260a2af6a11f918c77'; $p="$env:USERPROFILE\RIGA_SCHIERA_EMA200.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_EMA200_v3' -Quiet)){ throw 'SCRIPT VECCHIO: mi fermo.' };
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
- 🟡 **MA una cosa la tocca, e va detta invece che nascosta: sovrascrive
  `MQL5\Include\ABTG_PausaGuardian.mqh`, che in questo repo e' incluso da 72
  EA.** 🟢 **Nessun EA in campo cambia comportamento**: un `.ex5` gia' compilato
  **non rilegge** il suo include. 🔴 **Ma cambia il SORGENTE comune** di quel
  terminale: il prossimo che ricompilera' **un altro** EA li' si portera' dietro
  questa versione (`f33f374`, 1461 righe). Il backup del §3.3 la salva, e il
  ritorno del §6.1 la rimette.

# 8. 🚦 IL CANCELLO SU QUESTO PACCHETTO

Il pacchetto sono **due file**, e vanno letti insieme:

| file | cosa e' |
|---|---|
| `report/PACCHETTO_SCHIERAMENTO_EMA200_2026-09-13.md` | questo foglio: il giro, le verifiche, il ritorno indietro |
| `backtest_pipeline/righe/RIGA_SCHIERA_EMA200.ps1` | lo script che fa il lavoro, marcatore `MARCATORE_SCHIERA_EMA200_v3` |

📌 **Perche' lo script sta in un `.ps1` del repo e non dentro il foglio.**
La prima stesura aveva i comandi **incollati qui dentro**, ed e' stata
**bocciata dal cancello con 7 difetti bloccanti**: un blocco che scrive dentro
`MQL5\Experts` non e' ne' di sola lettura ne' una raccolta, quindi **non e'
appuntabile a un commit** — cioe' nessuno puo' dimostrare, dopo, quale codice
ha girato davvero. Messo in un `.ps1` **pinnato al commit e con un marcatore**,
ogni riga di lancio e' **riproducibile e verificabile**.
🧾 *Detto com'e': e' un difetto che ho fatto io e che il cancello ha preso.
Il cancello ha funzionato.*

🔴 **SECONDO GIRO: il cancello ha bocciato anche la v1 — 3 bloccanti.** Tutti e
tre veri, tutti e tre riparati, e li lascio scritti perche' un difetto
cancellato non insegna niente:
1. **L'include appuntato a `HEAD`** invece che a `f33f374` (§1.1-bis) — la mia
   stessa trappola, sull'altro file.
2. **L'attesa sul lotto era sbagliata** e avrebbe **fermato uno schieramento
   corretto** (§5.2): mancava la quantizzazione al passo 0,10.
3. **«seconda riga della funzione» era falso** (§5.3): la conclusione reggeva,
   **la ragione no**.
🟢 E quello che ha retto: i sei SHA256, `26a1856` blob-identico a `f33f374`,
`ExportTrades()` codice morto in live, sei funzioni di segnale identiche byte
per byte, il conto reale non raggiungibile, nessuna soglia di rischio infilata
di nascosto.

🔴 **TERZO GIRO: altri DUE bloccanti, e uno era il danno collaterale della
toppa precedente.** Anche questi riparati e lasciati scritti:
1. **Classe 304 — le sezioni sul silenzio del Guardian descrivevano `HEAD`**,
   cioe' **un file che il pacchetto non spedisce piu'** da quando l'include e'
   appuntato a `f33f374`. Numeri di riga di un altro pin, **quattro** cancelli
   invece di **due**, e soprattutto una **scadenza inventata**: dicevo *«si
   perde quando qualcuno cabla `cluster_mappa`»*, ma **in `f33f374` quel
   parametro non esiste** (zero occorrenze) e cablarlo **non compilerebbe**.
   E §1.2 C **ripeteva** la frase che §5.3 dichiarava falsa: il documento
   **contraddiceva se stesso**. 👉 §5.3 riscritta sul file spedito, ripetizione
   tolta.
2. **Classe 303 — il passo del volume applicato DUE volte.** Avevo ri-scalato
   `0,20`/`0,30`, che sono **gia'** il risultato di `MathFloor`. I lotti
   **calcolati** erano scritti da giorni in
   `DOSSIER_SCHIERAMENTO_EMA200_DOW_2026-09-09.md` r.187-188. Attesa corretta:
   **`0,10` e `0,20`**. E la frase *«piu' prudente del dichiarato»* era
   **falsa al confine** (0,641% contro 0,650% nominale) — sotto una firma di
   Claudio, nella direzione peggiore.
🛡️ **Cos'e' sopravvissuto a tutte e tre le stesure: la regola di arresto del
§5.2**, perche' e' scritta sulle **proprieta'** (multiplo di 0,10, non piu'
grande di prima) e non sul valore atteso.

🎯 **E la disciplina che ne esce, applicata prima di consegnare:** ogni numero
di riga citato in questo foglio e' stato **verificato col comando contro il
file che il pacchetto SPEDISCE** (`f33f374` per l'include, `26a1856` per l'EA),
non contro quello che avevo aperto. Verificati: r.1007, r.1027, 20 righe, 2
cancelli, 0 `cluster_mappa`, 8 parametri; r.30, r.42, r.239, r.243 dell'EA;
r.187-188 del dossier.

**Esito dei controlli deterministici** (`controlla_riga.py`, sui due file
**separatamente**, mai in pipe — classe 254):
- ✅ `--oggetto ps1` sullo script → **nessun difetto meccanico** (ASCII puro,
  0 errori dal parser PowerShell vero, niente costrutti pwsh-7).
- ✅ `--oggetto md` su questo foglio → **PASS**, con i rilievi non bloccanti
  elencati nella consegna al coordinatore.
**I rilievi non bloccanti, dichiarati invece che nascosti:**
- `[RACCOLTA] x5` — il cancello non vede un `Compress-Archive` **dentro** le
  righe di lancio. ✅ **Non e' un difetto qui**: la raccolta e' un **passo suo**
  (`-Passo raccolta`, §5.4) e produce cartella sul Desktop **+ zip**. Metterla
  dentro ogni riga vorrebbe dire zippare quattro volte la stessa cosa.
- `[225]` — la prosa nomina terminali e conti "vietati" in 23 righe. ✅
  **Voluto**: e' un documento che spiega **cosa NON si tocca**, e senza
  nominarli non potrebbe dirlo. Nel **codice** non compaiono: il selettore e'
  **positivo** (`origin.txt`), quindi non puo' raggiungere il conto reale.

- ⏳ **Agente `controllo-preventivo`: lo lancia il coordinatore, non io.** Fino
  a quel PASS **questo pacchetto non va mandato a Claudio.**

📌 Nessuna riga di questo foglio e' stata eseguita: **non ho MT5, non ho
MetaEditor, non ho toccato il VPS e non ho toccato il forward.**

---

*Scritto nella notte fra il 12 e il 13/09/2026. Fonti: `git log`/`git show` sui
blob del repo, `report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md`,
`report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md`, il preset
`mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set`.*
