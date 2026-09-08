# 💶 LA PAGELLA DEL CONTO REALE 10105439 — tutto pronto, manca il tuo gesto

**Richiesta di Claudio, 08/09/2026 sera:**
> _"Voglio che monitori automaticamente il conto reale come fai con gli altri.
> Che ti arrivi la pagella anche di quello reale."_

👉 **Fatto tutto tranne una cosa: attaccare l'EA sul terminale del reale.**
Quello e' un gesto sul conto vero, e **lo fai tu.** Io preparo, non accendo.

---

# 🟢 PRIMA RIGA, LA DOMANDA CHE CONTA: **`ABTG_TradeExporter` NON INVIA ORDINI.**

Non e' un'impressione, e' l'**inventario completo delle chiamate** del sorgente
`mql5/Experts/ABTG_TradeExporter.mq5` (211 righe, letto tutto):

```
ArrayResize ArraySize DoubleToString EventKillTimer EventSetTimer
FileClose FileOpen FileWrite HistoryDealGetDouble HistoryDealGetInteger
HistoryDealGetString HistoryDealGetTicket HistoryDealsTotal HistorySelect
MathAbs MathMax MathMin Print StructToTime SymbolInfoInteger TimeCurrent
TimeToString TimeToStruct iBarShift iHigh iHighest iLow iLowest
```

**Zero** `OrderSend`. **Zero** `CTrade`. **Zero** `PositionOpen/Close/Modify`.
**Zero** `OrderModify`. **Zero `#include`** (non tira dentro nessuna libreria
di trading). Le uniche cose che l'EA fa sono tre:

| cosa fa | riga del sorgente |
|---|---|
| **LEGGE** lo storico dei deal chiusi | r.121 `if(!HistorySelect(from, TimeCurrent()))` |
| **APRE** un file di testo | r.175 `int fh = FileOpen(InpFile, flags, ';');` |
| **SCRIVE** una riga per posizione chiusa | r.188 `FileWrite(fh, ...)` |

E c'e' un dettaglio che vale piu' di mille rassicurazioni: **l'EA non ha
nemmeno `OnTick`.** Ha solo `OnInit`, `OnTimer`, `OnDeinit` (r.99-106). Non si
sveglia sui prezzi: si sveglia su un timer, ogni 30 minuti, scrive il CSV e
torna a dormire. Un EA che non guarda i tick non puo' reagire al mercato
nemmeno volendo. 😄

> 🔴 Se un domani qualcuno ci mettesse dentro una sola chiamata che piazza,
> modifica o chiude ordini, questa pagina va riscritta **prima** di rimetterlo
> sul reale. Oggi, 08/09/2026, **non c'e'**.

---

# ⚖️ COSA COMPORTA DAVVERO, detto in chiaro

| ✅ / ⚠️ | cosa |
|---|---|
| ⚠️ | **Occupa una finestra di grafico** sul terminale del reale. Ti serve un grafico "di scorta": un simbolo qualunque, meglio se **non** uno su cui operano le due sedie vive (D30EUR e gli indici USA). Consigliato: **EURUSD H1** (sul 100k sta li', sul piccolo su NZDCAD H1). |
| ⚠️ | **Consuma un filo di CPU**, una volta ogni 30 minuti. Rilegge lo storico e riscrive il file. E' l'equivalente di aprire un foglio Excel due volte all'ora. |
| ✅ | **NON tocca le due sedie vive** (`ABTG_DAX_Apertura_EU` 770101 e `ABTG_ORB_Ottimizzato` 770611) **ne' i loro parametri.** Non ha nemmeno un input di magic: i suoi unici quattro input sono nome file, anno di partenza, minuti fra un export e l'altro, e "scrivi in Common". |
| ✅ | **Non tocca `ABTG_SlippageLogger`**, il terzo EA gia' presente sul reale. |
| ⚠️ | **Serve Algo Trading VERDE** sul terminale (come gia' e', altrimenti le due sedie non opererebbero). L'EA non ha bisogno del permesso di trading, ma MT5 non fa girare nessun EA col pulsante rosso. |
| 🔴 | **E' IL CONTO REALE.** Qualunque gesto su `C:\BCM_Reale` e' una tua firma, non una mia. Io ho preparato preset, script e pagella: **l'attacco lo fai tu, guardando lo schermo.** |

---

# 🖥️ REGOLA DEI TERMINALI MULTIPLI — prima di toccare qualsiasi cosa

Sul VPS ci sono **quattro** terminali. Quello giusto e' **UNO SOLO**:

## ✅ IL TERMINALE DA TOCCARE
### **conto 10105439** (REALE) — cartella **`C:\BCM_Reale`** — profilo `Default`

## ❌ I TRE DA NON TOCCARE
| conto | cartella che lo identifica |
|---|---|
| **50503392** (demo piccolo) | `C:\Program Files\BCM Markets MT5 Terminal` |
| **50504263** (dry-run 100k) | `C:\Program Files\BCM Markets MT5 Terminal -V3` |
| **50504400** (backtest) | `C:\MT5_Backtest` |

## 🔍 E NON RICONOSCERE LA FINESTRA "A OCCHIO"

Incolla questa riga in PowerShell sul VPS. E' di **sola lettura**: stampa e
basta, non tocca niente.

```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```

👉 Cerca la riga il cui **`Path` comincia con `C:\BCM_Reale`**. Quello e' il
PID del terminale del **10105439**. Il riconoscimento cosi' e' un **fatto
stampato**, non un'inferenza. _(Nata da un incidente vero del 06/09: senza il
numero di conto in chiaro, un attacco EA destinato al piccolo e' stato quasi
fatto sul terminale del REALE.)_

---

# 📋 I PASSI, uno per uno

### 0. Verifica di essere sul terminale giusto
Lancia la riga qui sopra. Porta in primo piano la finestra col `Path`
`C:\BCM_Reale`. **In alto a destra / nella scheda Conto deve comparire
`10105439`.** Se leggi 50503392 o 50504263, **hai la finestra sbagliata: fermati.**

### 1. Il file dell'EA e' gia' li'?
Nella finestra **Navigatore** (Ctrl+N) -> **Consulenti Esperti**, cerca
`ABTG_TradeExporter`. Il censimento dell'08/09 dice che sul reale **non e'
attaccato a nessun grafico**, ma il file **potrebbe** esserci lo stesso (gia'
compilato in un deploy passato).
- Se **c'e'**: passa al punto 2.
- Se **non c'e'**: va copiato `mql5\Experts\ABTG_TradeExporter.mq5` nella
  cartella `MQL5\Experts` dei dati di **quel** terminale (Ctrl+Shift+D apre la
  cartella dati del terminale in primo piano) e compilato con F7 in MetaEditor.
  ⚠️ Se devi fare questo passo, **dimmelo prima**: e' un passaggio in piu' e
  preferisco guardarlo insieme.

### 2. Apri un grafico di scorta
Un grafico **nuovo**, su un simbolo che le due sedie non usano. **EURUSD H1**
va benissimo. Non serve che sia "bello": l'EA non guarda il grafico, gli serve
solo un posto dove stare.
🔴 **NON trascinarlo su un grafico dove gia' gira una sedia viva.**

### 3. Trascina `ABTG_TradeExporter` su quel grafico
Si apre la finestra dei parametri.

### 4. Carica il preset
Scheda **"Dati in ingresso"** -> pulsante **"Carica"** -> scegli
**`ABTG_TradeExporter_REALE.set`** (dal repo:
`mql5/Presets/ABTG_TradeExporter_REALE.set`).

**Controlla a schermo che dica esattamente questo:**

| input | valore |
|---|---|
| `InpFile` | **`ABTG_Trades_Reale.csv`** |
| `InpFromYear` | `2024` |
| `InpExportMinutes` | `30` |
| `InpUseCommon` | `true` |

🔴 **`InpFile` e' la riga che conta.** Se resta il default `ABTG_Trades.csv`,
il reale **sovrascrive il CSV del conto piccolo** e da domani la pagella del
piccolo racconta il reale. E' esattamente l'errore beccato per un pelo sul
100k il 09/08 ("quinto errore di deploy beccato dallo screenshot: il primo
tentativo aveva il nome file di default"). **Guarda quella riga due volte.**

### 5. OK. Fatto.
In basso a destra sul grafico deve comparire la faccina 🙂 dell'EA.
Nella scheda **Esperti** deve uscire subito una riga tipo:
```
[TradeExporter] esportati N trade chiusi in Common\Files\ABTG_Trades_Reale.csv
```
(l'export parte **all'avvio**, `OnInit` r.101, non aspetta i 30 minuti).

### 6. Salva il profilo
File -> Profili -> Salva profilo (`Default`). Cosi' l'EA c'e' ancora dopo un
riavvio del terminale.

### 7. Mandami lo screenshot della scheda Esperti
Quella riga con `ABTG_Trades_Reale.csv` dentro e' la prova che tutto il resto
si accende da solo.

---

# 🔧 COSA HO GIA' FATTO (e che si accende DA SOLO quando il CSV arriva)

### 1. `backtest_pipeline/analizza_trades.py` — il terzo blocco
Nuova sezione **"💶 Conto REALE 10105439 — soldi veri"**, stessa forma della
sezione 100k. Costante `CSV_REALE = "data/statements/trades_reale.csv"`.
- Se il file **non c'e'** (oggi), la sezione **dice perche'** non c'e' e si
  accende da sola il giorno in cui arriva. Nessuna riga da toccare.
- 🔴 **Il filtro delle operazioni SENZA COMMENTO vale anche li'** (`strategy`
  vuota **e** `magic` 0): stanno **fuori dal totale** e si mostrano a parte.
  E' la tua firma del 07/09, e non e' una regola "del piccolo": e' come si
  legge un conto.
- 🔴 **E li' sono piu' prudente che altrove**, perche' sul reale un numero
  sbagliato costa soldi. **Prima di stampare qualsiasi totale** la sezione:
  1. **controlla che ci siano tutte le colonne** (`open_time`, `close_time`,
     `profit`, `swap`, `commission`, `symbol`, `strategy`, `magic`). Se ne
     manca anche una: **lo dichiara e non stampa niente.**
  2. **pretende che OGNI riga sia leggibile** (date e importi). Se anche una
     sola non lo e', **elenca i `pid` e non stampa il totale.** Negli altri due
     conti una riga storta ripiega su zero: qui no, uno zero silenzioso al
     posto di una perdita e' il modo in cui un totale sbagliato sembra giusto.
  3. **non stampa il SALDO, solo il NETTO REALIZZATO**: il deposito iniziale
     del reale non sta nel CSV e **non me lo invento** (sul 100k il saldo si
     puo' dare perche' 100.000 e' un fatto del dry-run, non una stima).

### 2. `backtest_pipeline/pubblica_trades.ps1` — pubblica anche il terzo CSV
```
ABTG_Trades.csv       -> data/statements/trades_auto.csv    piccolo 50503392  (OBBLIGATORIO)
ABTG_Trades_100k.csv  -> data/statements/trades_100k.csv    100k    50504263  (facoltativo)
ABTG_Trades_Reale.csv -> data/statements/trades_reale.csv   REALE   10105439  (facoltativo)
```
Il terzo e' **facoltativo**: se non c'e' ancora, lo script **lo dice e
prosegue**, non fallisce e non blocca gli altri due. Nessuna riga di lancio
nuova da imparare: **e' lo stesso script dell'attivita' pianificata delle
22:45**, che da domani carichera' anche il reale senza che nessuno tocchi
niente.

### 3. `mql5/Presets/ABTG_TradeExporter_REALE.set`
Il preset del punto 4 qui sopra. ASCII puro.

---

# 🧐 PERCHE' OGGI IL REALE NON HA UNA PAGELLA (e quanto e' certo)

| conto | CSV nel repo |
|---|---|
| piccolo **50503392** | `data/statements/trades_auto.csv` ✅ |
| 100k **50504263** | `data/statements/trades_100k.csv` ✅ |
| **REALE 10105439** | ❌ **nessuno** |

👉 **L'unico conto con soldi veri e' l'unico senza pagella.** Il censimento
`CODA_01` dell'08/09 sul terminale del reale trova tre EA
(`ABTG_DAX_Apertura_EU` 770101, `ABTG_ORB_Ottimizzato` 770611,
`ABTG_SlippageLogger`) e **nessun `ABTG_TradeExporter`**.

> ⚠️ **Quanto e' certo:** quel censimento legge i file `.chr`, cioe' una **foto
> al salvataggio del profilo**. E' un **indizio forte, non un fatto certo** —
> un EA attaccato dopo l'ultimo salvataggio non comparirebbe. Il fatto certo e'
> l'altro, e basta da solo: **in `Common\Files` non esiste nessun
> `ABTG_Trades_Reale.csv`**, quindi comunque nessuno stava esportando il reale
> con un nome distinto.

---

# 🚫 COSA **NON** E' STATO VERIFICATO — da qui non posso

Qui non c'e' MT5 e non c'e' il VPS. **Niente di quanto segue e' stato provato,
e va guardato a schermo:**

1. ❌ **Il preset non e' mai stato caricato in MT5.** La sintassi `chiave=valore`
   e' quella degli altri 60 preset del repo, ma la conferma e' quando lo apri.
2. ❌ **Non ho verificato che `ABTG_TradeExporter` sia compilato e presente**
   nel Navigatore di `C:\BCM_Reale` (punto 1 dei passi).
3. ❌ **Non ho verificato che il reale scriva nella STESSA `Common\Files`** degli
   altri due. Indizio forte: il censimento legge il terminale del reale sotto
   `%APPDATA%\MetaQuotes\Terminal\...`, quindi **non e' un'installazione
   `/portable`** e la Common e' quella condivisa. **Ma e' un indizio, non una
   prova**: la prova sara' vedere `ABTG_Trades_Reale.csv` comparire in
   `%APPDATA%\MetaQuotes\Terminal\Common\Files` dopo il punto 5.
4. ❌ **`pubblica_trades.ps1` non e' stato eseguito sul VPS.** Qui ho fatto due
   controlli veri: il **parser PowerShell** sul file intero (nessun errore di
   sintassi), il **lint del progetto** (`lint_ps1.py`, pulito), l'**ASCII puro**
   (zero byte sopra 127), e ho **eseguito** la funzione `Pubblica-Csv` sul ramo
   "file mancante": stampa e prosegue, non muore. Quello che **non** posso
   provare da qui e' la chiamata all'API GitHub col token.
5. ❌ **Nessuna operazione del reale e' mai stata letta**: la sezione nuova e'
   stata provata su CSV **finti** (sano / con riga illeggibile / con colonna
   mancante / vuoto), non su dati veri del 10105439.

---

# ✅ E LA PROVA CHE NON HO ROTTO NIENTE

`analizza_trades.py` girato **oggi** sui due CSV che ci sono. L'output e'
**identico riga per riga** a quello di prima della modifica, con **in piu' solo
la sezione nuova** (`diff` fatto contro la versione in HEAD):

```
45a46,53
> ## 💶 Conto REALE 10105439 - soldi veri
> _CSV del conto reale non ancora sul repo: la sezione si accende da sola quando il file arriva._
> **Perche' non c'e' (misurato l'08/09/2026):** ... non gira nessun ABTG_TradeExporter ...
```

👉 Zero righe cambiate sul piccolo, zero sul 100k. La pagella di stasera esce
come sempre. 🎯

---

## 🎯 E perche' vale la pena, in due righe

La challenge parte ai primi di ottobre. Da qui a li' il conto reale e' l'unico
posto dove i numeri sono **veri**: slippage vero, spread vero, riempimenti
veri. Fino a stasera era anche l'unico che **non guardavamo in automatico**.
Dopo il tuo gesto di due minuti su `C:\BCM_Reale`, ogni sera alle 23:00 la
pagella parla di **tutti e tre** i conti. 💪
