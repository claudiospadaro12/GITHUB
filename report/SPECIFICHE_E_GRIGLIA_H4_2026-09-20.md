# 🌙 DUE STRUMENTI, DUE INFERENZE CHE DIVENTANO NUMERI — notte del 20/09/2026

> **Turno di notte.** Claudio compra la challenge oggi e schiera stasera.
> Qui dentro ci sono **due strumenti pronti** e **zero numeri di mercato**:
> i numeri li producono lui (un F7) e un CSV (tre minuti di export).
> 🔴 **Niente di questo è stato eseguito su un terminale**: nessun conto reale
> toccato, nessun forward, nessun round lanciato.

---

## ✅ IN DUE RIGHE

| cosa | file | stato |
|---|---|---|
| 📐 Lettore delle specifiche FTMO (script MQL5, sola lettura) | `mql5/Scripts/ABTG_PrevoloFTMO_Specifiche.mq5` | scritto, **mai compilato** (qui non c'è MetaEditor) |
| 🕐 Analizzatore della griglia H4 BCM↔FTMO | `backtest_pipeline/analisi_griglia_h4.py` | scritto e **collaudato 7/7 su dati sintetici** |

**Il formato del CSV combacia col consumatore?** 🟢 **SÌ, ed è verificato riga per riga**, non
dedotto. **Quante caselle chiude lo script?** 🟢 **QUATTRO piene (1, 3, 4, 5) + il completamento
della 6**, e la 2 la conferma. **Il collaudo dell'analizzatore?** 🟢 **7 casi su 7 PASS**, con
dentro due contro-esempi che lo farebbero sbagliare.

---

# ① 📐 IL LETTORE DELLE SPECIFICHE FTMO

`mql5/Scripts/ABTG_PrevoloFTMO_Specifiche.mq5` — **script** (`OnStart`, niente `OnTick`).
Scrive `MQL5\Files\PREVOLO_FTMO_specifiche.csv`.

## 🔍 IL FORMATO COMBACIA? SÌ — e il consumatore è stato APERTO, non indovinato

`backtest_pipeline/righe/PREVOLO_FTMO.ps1` **r.618-628** fa **tre cose e solo tre**:

```
$fSpec = Join-Path $dati 'MQL5\Files\PREVOLO_FTMO_specifiche.csv'
if(Test-Path -LiteralPath $fSpec){
  $t = Leggi-Testo $fSpec
  $rr = @($t -split "`n" | Where-Object { $_.Trim().Length -gt 0 })
  if($rr.Count -gt 1){
    ... foreach($r in $rr){ Dillo ('    ' + ($r -replace '[^\u0020-\u007E]', '').Trim()) 'Green' }
    $specLette = $true
```

Tradotto in vincoli, e sono **quattro**, tutti rispettati:

| # | vincolo imposto dal consumatore | come lo rispetto |
|---|---|---|
| 1 | **nome esatto** `PREVOLO_FTMO_specifiche.csv` | `#define ABTG_FILE_SPEC` identico |
| 2 | **cartella `MQL5\Files` NON comune** (`Join-Path $dati`) | 🔴 **niente `FILE_COMMON`**: con quel flag MT5 scriverebbe in `Terminal\Common\Files` e la sonda non troverebbe **niente** |
| 3 | **almeno DUE righe non vuote** (`$rr.Count -gt 1`) | il file ne ha ~45 anche nel caso peggiore (tutti i mercati ASSENTI) |
| 4 | **codifica leggibile e ASCII** (`Leggi-Testo` regge BOM UTF-16 e UTF-8; poi strippa i non-ASCII) | `FILE_ANSI` = ASCII puro. **Non** il default MQL5 (UTF-16): la sonda lo reggerebbe, ma il referto lo legge un umano |

🟢 **E il separatore/intestazione NON sono vincolati**: il consumatore **non spezza sul
separatore** e **non cerca nomi di colonna**, stampa e basta. Quindi ho scelto quello di casa
(`FILE_CSV|FILE_ANSI`, virgola — identico a `ABTG_InfoBroker.mq5` r.407) e un layout a
**sezioni** `[OROLOGIO]` `[CONTO]` `[SIMBOLI]` `[FINE]`, perché **quelle righe finiscono dentro
un referto di testo una per una**: una riga CSV da 26 colonne senza intestazione sarebbe
illeggibile proprio dove serve.

⚠️ **La virgola dentro una descrizione** (`"Dow Jones Industrial Average, cash"`) sposterebbe
di una colonna tutta la riga: `FileWrite` con `FILE_CSV` **non mette le virgolette**. Per questo
ogni stringa passa da `Pulisci()` (virgola, punto e virgola, virgolette, CR/LF/TAB e tutto ciò
che sta fuori dall'ASCII stampabile → spazio). È lo stesso motivo per cui `ABTG_InfoBroker.mq5`
ha la sua.

## 📊 QUANTE CASELLE CHIUDE: **quattro piene + una completata**

| casella | prima (sonda da sola) | dopo lo script | come |
|---|---|---|---|
| **1 · orologio** | `A MANO (guidata)` | 🟢 **CHIUSA** | `TimeTradeServer() − TimeGMT()`, arrotondato a 15 min, col **verdetto già scritto** |
| **2 · nomi simboli** | `CHIUSA`/`MEZZA`/`A MANO` (dai file su disco) | 🟢 **confermata dalla FONTE** | cicla `SymbolsTotal(false)` = **l'albero vero del broker**, non parole pescate dal rumore binario |
| **3 · margine per lotto** | `A MANO` | 🟢 **CHIUSA** | `OrderCalcMargin(ORDER_TYPE_BUY, sym, 1.0, ask, m)` |
| **4 · Digits e Point** | `A MANO` | 🟢 **CHIUSA** | `SYMBOL_DIGITS`, `SYMBOL_POINT`, `SYMBOL_TRADE_TICK_SIZE` |
| **5 · spread** | `A MANO` | 🟢 **CHIUSA** | `SYMBOL_SPREAD` + `SYMBOL_SPREAD_FLOAT` (fisso/flottante) |
| **6 · conto e leva** | `MEZZA` (conto e server dal disco) | 🟢 **COMPLETATA** | `ACCOUNT_LEVERAGE`, `ACCOUNT_CURRENCY`, `ACCOUNT_BALANCE`, `ACCOUNT_TRADE_MODE` — cioè **proprio i tre pezzi che la sonda dichiarava di non poter leggere** (r.773-775) |

👉 **Risposta secca: quattro caselle chiuse per intero (1, 3, 4, 5), la 6 completata da mezza a
piena, la 2 confermata alla fonte.** Le caselle 3-4-5 la sonda le marca da sé
`CHIUSA DALLA SONDA` non appena trova il file (r.717-720): **non serve toccare `PREVOLO_FTMO.ps1`.**

## 🧪 IL CONTRO-ESEMPIO, ed è **la trappola di stasera** (classe **479**)

🔴 **Oggi è DOMENICA e il mercato è chiuso.** `TimeCurrent()` a mercato fermo **non è un
orologio**: è il timestamp dell'**ultimo tick**, cioè **venerdì sera**. Chi misurasse il fuso con
`TimeCurrent() − TimeGMT()` stanotte otterrebbe uno scarto sbagliato **di giorni, non di ore** —
ed è esattamente la casella che `PREVOLO_FTMO.ps1` (r.455-459) dichiara di **non** saper chiudere.

🟢 **Lo script la chiude lo stesso**, perché il delta lo misura con **`TimeTradeServer()`**, che il
terminale **calcola** e che vale anche a mercato fermo. `TimeCurrent()` viene scritto **comunque**,
ma etichettato `OraServer_TimeCurrent = ora dell'ULTIMO TICK`, con accanto `MercatoAperto SI/NO`
e lo scarto in secondi. 👉 **Il verdetto `VERDETTO_OROLOGIO` dichiara da solo con quale dei due
orologi è stato prodotto.**

E c'è anche la **controprova del righello**: il fuso di Windows (`DeltaLocalePC_UTC_hhmm`) e
`TimeGMTOffset_sec` finiscono nel file, perché se l'orologio del **PC** è sbagliato sono sbagliati
tutti i numeri sopra — e allora bisogna saperlo leggendo il file, non indovinarlo.

## 🚫 SOLA LETTURA — e si verifica con un grep

Nel sorgente **non esistono**: `OrderSend`, `CTrade`, `#include <Trade\...>`, `PositionModify`,
`ObjectCreate`, `FileDelete`. L'**unica** scrittura è il `FileWrite` sul CSV.
`OrderCalcMargin` **non manda niente al server**: è il calcolatore di margine del terminale.

⚠️ **L'unica manopola che NON è sola lettura è dichiarata e spenta**: `InpSelezionaSimboli`
(**default `false`**) aggiungerebbe i simboli a Market Watch — non è un ordine, ma **è un cambio
di stato del terminale**, e il mandato dice no. Il file scrive `SolaLettura = SI/NO` a seconda.

📌 **Conseguenza pratica da sapere prima di premere F7**: senza sottoscrizione, `Bid`/`Ask` e
quindi il **margine calcolato** possono uscire `n.d.` per i simboli non ancora in Market Watch.
👉 **Soluzione a costo zero: si lancia lo script DOPO aver aperto i cinque grafici.** A quel punto
i simboli sono già selezionati e il margine esce per tutti, **senza accendere la manopola**.

## 🔴 RIGHE ASSENTI: il file esce COMUNQUE

Se un mercato non ha candidati, la riga si scrive lo stesso con `Stato = ASSENTE` e 22 trattini
(`RigaSimbolo`), perché **un file parziale è utile e un file che non c'è no**. Se i candidati sono
più di uno si scrivono **tutti**, marcati `CANDIDATO`: lo script **non sceglie** al posto di
Claudio, come non sceglie la sonda.

Il dizionario dei nomi è la **traduzione fedele** delle regex di `PREVOLO_FTMO.ps1` r.108-114
(compreso il suffisso `[._#+-]XX`, riprodotto in `Combacia()` visto che MQL5 non ha le regex):
produttore e consumatore devono chiamare «simile» **la stessa cosa**.

## ⚠️ CAVEAT DICHIARATO, e non è una formalità

🔴 **NON COMPILATO. Il primo F7 è anche il primo collaudo.** Qui non c'è MetaEditor.
Quello che si poteva verificare senza compilare **è stato verificato**:

| controllo | esito |
|---|---|
| ASCII puro nel sorgente | ✅ 0 byte fuori da 32-126 |
| graffe e parentesi bilanciate | ✅ 23/23 e 354/354 |
| ogni funzione chiamata esiste in MQL5 con quella firma | ✅ 45 identificatori, tutti built-in o definiti nel file |
| ogni costante/enum esiste | ✅ 43 (`SYMBOL_*`, `ACCOUNT_*`, `FILE_*`, `ORDER_TYPE_BUY`, `TIME_*`) |
| numero di campi `FileWrite` = numero di colonne dell'intestazione | ✅ 26 = 26 = 26 (intestazione, riga piena, riga `ASSENTE`) — **il primo giro ne aveva 24: trovato e corretto prima di consegnare** |
| `%` di `StringFormat` = numero di argomenti | ✅ tutti |
| concatenazione di stringhe letterali adiacenti | 🔧 **6 occorrenze corrette**: MQL5 **non** ammette `"a" "b"` come il C — serve il `+`. Erano un errore di compilazione certo |

---

# ② 🕐 L'ANALISI DELLA GRIGLIA H4

`backtest_pipeline/analisi_griglia_h4.py`

## 🔬 IL PROBLEMA, ancorato al codice (non all'opinione)

| dove | cosa dice |
|---|---|
| `ABTG_Dow_Apertura_US.mq5` r.405-406 | `iMA(_Symbol, InpFilterTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE)` e idem con `InpEmaSlow` |
| r.1495-1502 | `CopyBuffer(..., 1, 1, ...)` = **ultima barra CHIUSA**; `e = (f>s ? +1 : (f<s ? -1 : 0))` |
| r.885-887 | `bias = TrendBias(); longOK = (bias == 0 \|\| bias == +1)` |
| preset `770202_FTMO` | `InpEmaFast=1`, `InpEmaSlow=50`, `InpFilterTF=16388` (H4), **`InpAllowShort=false`** |
| preset r.40-48 | *«BCM (UTC+1) → H4 aperte alle 23,03,07,11,15,19 UTC · FTMO (UTC+3) → 21,01,05,09,13,17 UTC»* |

Due cose che vale la pena dire ad alta voce:
- 🔎 **`EMA(1)` non è una media.** Con periodo 1 il coefficiente è `2/(1+1)=1`: **EMA(1) è la
  chiusura**. Il filtro è, alla lettera, *«chiusura dell'ultima H4 chiusa contro EMA(50)»*.
- 🔎 **Nel preset FTMO gli altri addendi del bias sono TUTTI spenti** (`InpUseSupertrend`,
  `InpUseSupertrend3`, `InpUseCorrelation`, `InpUseVwapFilter` = `false`): il bias lo decide
  **solo** la EMA su H4. Non c'è nient'altro che possa compensare.
- 🔴 E su una sedia **solo-long**, `bias = -1` non peggiora l'ingresso: **`longOK` diventa
  `false` e nessun BUY STOP viene piazzato.** L'ingresso è **cancellato**.

## 🧮 LA ROBUSTEZZA CHE RENDE LA MISURA SOLIDA (è aritmetica)

L'ingresso vero **non** è alle 13:30 UTC: `InpRangeMinutes=35`, quindi i pendenti si piazzano
alle **15:05 BCM = 14:05 UTC**. 🟢 **E non cambia niente**, ed è dimostrabile:

- griglia **BCM**: alle 14:05 UTC la barra in formazione è quella aperta alle **11:00**, quindi
  l'ultima chiusa è quella che ha chiuso alle **11:00 UTC**;
- griglia **FTMO**: la barra in formazione è quella aperta alle **13:00**, ultima chiusa →
  **13:00 UTC**.

👉 Le due barre decisive **restano le stesse per qualunque istante dentro `[13:00, 15:00) UTC`**.
Un errore di mezz'ora su quell'ora **non sposta un singolo numero** (ed è il **caso 7** del
collaudo).

## 🎯 L'ATTESA, SCRITTA PRIMA DI VEDERE I DATI

> **Attesa: bias OPPOSTO nel 10-20% delle sedute.**

**Perché**: le due griglie hanno una `EMA(50)` quasi identica (stessa serie, campionata sfalsata;
mezza vita ~17 barre H4 ≈ 2,8 giorni), quindi la differenza la fa quasi tutta **la chiusura**:
prezzo delle 11:00 UTC contro prezzo delle 13:00 UTC. Su U30USD un movimento di 2 ore attorno alla
pre-apertura USA vale tipicamente **0,25-0,40%**, mentre `|chiusura − EMA50|` sta tipicamente
attorno all'**1%**. Il disaccordo capita solo quando il prezzo è già a ridosso della EMA50 e lo
scarto di 2 ore basta a scavalcarla: ordine di grandezza `(0,3/1,0) × densità vicino allo zero ≈ 0,15`.

🔴 **E IL RISULTATO CHE MI FAREBBE DIRE «IL PROBLEMA NON ESISTE»** — scritto prima, come si deve:

| esito | verdetto |
|---|---|
| **< 3%** | 🟢 **il problema non esiste nei fatti**: meno di una seduta al mese. I preset **non si toccano** |
| **3-25%** | 🟠 si schiera **dichiarando lo scarto**, e la **frequenza attesa su FTMO va corretta** della quota di sedute perse |
| **> 25%** | 🔴 **su FTMO non è la stessa sedia**: una seduta su quattro il filtro dice il contrario. Non si schiera senza rimisurare |

Le tre soglie sono **dentro lo script**: stampa lui il verdetto, non lo do io a posteriori.

## 🧪 IL COLLAUDO SU DATI SINTETICI — **7/7 PASS**

```
$ python3 backtest_pipeline/analisi_griglia_h4.py --autocollaudo
  1. mix 20/20/20                    sedute=  60  discordi=  20 (atteso   20)  entrambe=  20 (atteso   20)  nessuna=  20 (atteso   20)  margine_min=9.11  -> PASS
  2. zero divergenze                 sedute=  60  discordi=   0 (atteso    0)  entrambe=  30 (atteso   30)  nessuna=  30 (atteso   30)  margine_min=9.61  -> PASS
  3. tutte divergenti                sedute=  40  discordi=  40 (atteso   40)  entrambe=   0 (atteso    0)  nessuna=   0 (atteso    0)  margine_min=8.16  -> PASS
  4. sfasamento 0 -> stessa griglia  sedute=  40  discordi=   0 (atteso    0)  entrambe=  40 (atteso   40)  nessuna=   0 (atteso    0)  margine_min=8.16  -> PASS
  5. sfasamento 4 -> giro intero     sedute=  40  discordi=   0 (atteso    0)  entrambe=  40 (atteso   40)  nessuna=   0 (atteso    0)  margine_min=8.16  -> PASS
  6. rifiuto del TF sbagliato        -> PASS (serie H4 rifiutata)
  7. istante di ingresso robusto     14:30+35min=20  14:30+0min=20  -> PASS
 ESITO COLLAUDO: 7/7 PASS  -> ANALIZZATORE COLLAUDATO
```

**Come è costruita la serie in cui la risposta è nota PER COSTRUZIONE** (e perché funziona —
è aritmetica, non fortuna):

- il secchio decisivo di **BCM** è `08:00-12:00` locale → la sua chiusura è **la barra H1 delle 11:00**;
- il secchio decisivo di **FTMO** è `10:00-14:00` locale → la sua chiusura è **la barra H1 delle 13:00**;
- 🔑 **ognuna delle due barre chiude UN SOLO secchio**: quella delle 11:00 sta anche dentro il
  secchio FTMO 10-14 ma **non ne è la chiusura**; quella delle 13:00 sta dentro il secchio BCM
  12-16, che però chiude alle 15:00 su una barra piatta.

👉 Quindi scrivendo **un solo numero** decido il bias di **una sola griglia**, giorno per giorno.
Tutto il resto sta a `base`, così la `EMA(50)` resta incollata a `base`.

### 🛡️ I DUE CONTRO-ESEMPI, che sono la parte che conta

- **Caso 4 — `--delta-ftmo 0`.** Con sfasamento zero le due griglie **sono la stessa griglia**.
  Se l'analizzatore trovasse una divergenza diversa da **zero** su 40 giorni costruiti apposta per
  divergere, vorrebbe dire che la divergenza che misura **non viene dallo sfasamento** ma da un
  bug (EMA, indice della barra chiusa, ciclo delle sedute). 🟢 Esce **0**.
- **Caso 5 — `--delta-ftmo 4`.** Quattro ore su un passo di quattro ore = **giro intero**, stessa
  griglia. 🟢 Esce **0**.
- **Caso 6 — il TF sbagliato.** Una serie **H4** data in pasto come H1 viene **rifiutata**: senza
  questo controllo i gruppi da 4 non sarebbero barre H4 e **tutto il risultato sarebbe falso senza
  dare il minimo segno**.
- 🔒 **E una rete in più dentro ogni caso**: `margine_min` — la distanza minima `|EMA1 − EMA50|`
  su tutte le sedute giudicate. Se la deriva della EMA si mangiasse il segnale, il test
  **fallisce** invece di passare per caso. Vale 8,16-9,61 su una perturbazione di 10: margine ampio.

### 🔴 E UN DIFETTO VERO TROVATO **DAL** COLLAUDO, prima della consegna

La **prima** stesura del collaudo dava `discordi` ed `entrambe` **esatti** in tutti e cinque i
casi… ma su **427 sedute invece di 60**: stava giudicando anche i **400 giorni piatti** di
riscaldamento. E lì `chiusura == EMA50` esattamente — **tranne che in virgola mobile**:
`1000·k + 1000·(1−k)` con `k=2/51` torna `1000.0000000000001`, quindi `EMA50 > chiusura` e il bias
usciva **−1 su tutte e 367 le sedute piatte**. 🔴 **Non 50/50: sistematico.** Il numero di testa era
giusto e il banco di prova era spazzatura. Corretto escludendo il riscaldamento (`--da` sul primo
giorno costruito) e aggiungendo `sedute == costruite` come condizione di PASS.
👉 **Nuova classe `480` in `CHECKLIST_RIGA_DI_LANCIO.md`.**

## 📥 ISTRUZIONI PER CLAUDIO — **tre minuti, non trenta**

> 🪟 **BERSAGLIO: il terminale MT5 `50504400` — il BANCO DI BACKTEST, cartella `C:\MT5_Backtest`.**
> ✋ Azione a mano dentro MT5.
> 🚫 **NON si tocca nessuno degli altri cinque terminali del VPS**: non il piccolo `50503392`
> (`BCM Markets MT5 Terminal`), non il 100k `50504263` (`... -V3`), **e soprattutto non il REALE
> `10105439` (`C:\BCM_Reale`)**, non il manuale `50503635` (`C:\MT5_MANUALE`), non FTMO.

Se serve la conferma stampata di quale finestra è quale (regola dei terminali multipli):

```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path
```

**I quattro passi, nel terminale `50504400`:**

1. **Apri il grafico**: `Ctrl+U` → cerca **`U30USD`** → doppio clic (oppure trascinalo da Market
   Watch su un grafico nuovo). Metti il timeframe su **H1** dalla barra dei periodi.
2. **Carica lo storico**: clicca sul grafico e tieni premuto **`Home`** per qualche secondo, finché
   la data in basso a sinistra non arriva al **2024.09.26** (è lì che comincia lo storico BCM sugli
   indici). Servono **almeno 6.000 barre H1** — cioè circa **un anno**; se ne carichi due, meglio.
   *(Se il grafico si ferma prima: `Strumenti → Opzioni → Grafici → Max barre nel grafico` →
   `Illimitato`, poi di nuovo `Home`.)*
3. **Esporta in CSV** — 🔵 **strada A, la più rapida**: con il grafico H1 selezionato premi
   **`Ctrl+S`** (menu: **`File → Salva con nome...`** / **`File → Save As...`**), scegli tipo
   **CSV** e salvalo sul **Desktop** come **`U30USD_H1.csv`**.
   🟠 **strada B, se `Ctrl+S` non offre il CSV**: `Visualizza → Simboli` (**`Ctrl+U`**) → seleziona
   **`U30USD`** → scheda **`Barre`** / **`Bars`** → periodo **H1** → intervallo dal **2024.09.26**
   a **oggi** → **`Richiedi`** / **`Request`** → pulsante **`Esporta barre`** / **`Export Bars`** →
   Desktop, **`U30USD_H1.csv`**.
4. **Mandami il file.** Qualunque delle due strade: l'analizzatore riconosce da solo separatore
   (TAB, `;`, `,`), intestazione presente o assente, data e ora su una o due colonne — e **rifiuta**
   il file se il passo non è di 3600 secondi.

**Poi gira (sul PC dove sta il CSV):**

```bash
python3 backtest_pipeline/analisi_griglia_h4.py --csv Desktop/U30USD_H1.csv --dettaglio Desktop/griglia_h4_dettaglio.csv
```

⚙️ Manopole, se servono: `--delta-ftmo 3` (se `PREVOLO_FTMO_specifiche.csv` dicesse che FTMO è
**BCM+3** e non **BCM+2**), `--ora-ingresso 14:30`, `--minuti-range 35`, `--da` / `--a`.

## 🛡️ IL CONTRO-ESEMPIO SUL FUSO DEL CSV

Se il CSV arrivasse da un terminale con un server in un fuso diverso, **tutto il risultato sarebbe
falso senza dare il minimo segno**. Per questo lo script stampa **le tre ore con meno barre** —
la **pausa giornaliera del feed**, che è la firma leggibile del fuso del server — con accanto il
valore atteso per BCM. 👉 È un **indizio da confrontare**, dichiarato come tale, non un verdetto:
ma è un indizio che **si legge**, invece di assumerlo.

## 🚩 CAVEAT DICHIARATI (li stampa anche lo script)

- **(a)** un solo broker di dati: il CSV viene dal banco **BCM**;
- **(b)** si misura **solo il bias del filtro EMA**, non il P/L — due sedute concordi possono
  comunque riempirsi a prezzi diversi (spread, slippage, livelli del range);
- **(c)** il delta FTMO−BCM di **+2h** è un **input**, non una misura: **va confermato con
  `PREVOLO_FTMO_specifiche.csv`** — cioè con lo strumento ①. 🟢 **I due strumenti di stanotte si
  chiudono a vicenda il cerchio.**

---

## 🎯 DOVE CI PORTA, in una riga

Stanotte non è stato prodotto **nessun numero di mercato**: è stato tolto di mezzo il motivo per
cui i numeri di stasera sarebbero stati **inventati**. Uno `F7` chiude quattro caselle e mezza
di pre-volo, un export da tre minuti trasforma *«la griglia H4 è diversa, non è verificabile da
qui»* in **una percentuale con un verdetto già scritto**. 💪 **La sedia del 1° ottobre si avvicina
di due inferenze.**
