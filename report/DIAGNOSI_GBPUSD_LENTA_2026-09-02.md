# 🔎 DIAGNOSI — perche' la cella GBPUSD della SONDA DELL'OROLOGIO costa ~200x la cella EURUSD sullo stesso banco

_Analisi da scrivania del 02/09/2026 (nessun MT5 qui: solo codice, referti e
atti del repo). Fatti del 01/09 sera: screenshot di Claudio + righe di lancio.
Il piano diagnostico in fondo e' eseguibile in ~10 minuti sul PC di backtest,
senza toccare il forward. Le stringhe di lancio le passa il verificatore._

---

## 1. 📌 I FATTI MISURATI (01/09 sera)

| # | fatto | fonte |
|---|---|---|
| F1 | Celle 01/02 EURUSD (144 passate l'una, Modello 4, 2011.01.01→2026.06.30 split 40/60): **~43 min l'una, ~54 s/passata** (ricognizione: 218 s per 4 passate) | screenshot + referto ricognizione |
| F2 | Cella 03 GBPUSD LONG, prima corsa: **"no memory for ticks generating"** (16 GB RAM, 8 agenti, swap) | Diario MT5 |
| F3 | Dopo riavvio pulito con 4 agenti: **4 passate veloci in 5 min** ("ore leggere"), poi le 4 successive **INCAGLIATE 3,5 ore** senza completare; stima MT5: **64 ORE**. Nessun errore nel Diario dopo la partenza | screenshot |
| F4 | Diario: **"GBPUSD: ticks data begins from 2024.07.05"** — idem EURUSD, EURGBP; file tick da **43 byte = stub**. Quindi pre-2024.07.05 i tick sono **GENERATI dalle M1** per TUTTI i simboli | Diario MT5 |
| F5 | PC: i7-8550U (4 core/8 thread), 16 GB RAM | atti |
| F6 | ~200x: 64 h / 144 passate ≈ **1.600 s/passata** contro i 54 s di EURUSD (≈30x per passata a parita' di agenti; l'ordine 100-200x viene dal confronto cella intera 64 h vs 43 min) | aritmetica su F1+F3 |

---

## 2. 🧬 IL CODICE DELL'EA: NIENTE che possa costare 200x su un simbolo

Letto per intero `mql5/Experts/ABTG_SondaOrologio.mq5` (972 righe). Verdetto:
**l'EA e' escluso come causa.**

- **Nessun `CopyTicks`, nessun `CopyRates`** in tutto il file. L'unica lettura
  di serie e' `CopyBuffer(hAtr, 0, shift, 1, a)` — UN valore di ATR, e solo
  quando si valuta un ingresso (riga 707-712).
- **Nessun loop di retry** che possa girare a vuoto se la storia manca: la
  chiusura fallita "ritenta al tick successivo" (riga 588-597), non in un
  while; `AtrVal()<=0` fa semplicemente saltare la giornata (riga 647).
- **OnTick e' O(1)**: `AggiornaPeggiorGiornata()` (un TimeToStruct + un
  confronto), `GestisciPosizione()` (un PositionSelect + due confronti d'ora),
  ingresso solo a barra H1 nuova. Il ciclo su `PositionsTotal()`
  (`ContaPosizioni`/`TrovaPosizione`) gira su 0-1 posizioni.
- Nessun export per-trade, nessun FileWrite in corsa (solo in
  `OnTesterDeinit`, una volta a fine ottimizzazione).

**Conseguenza**: il costo per passata e' proporzionale al **numero di tick che
il tester fa scorrere** (piu' la loro generazione/consegna). Se GBPUSD costa
100-200x, la differenza sta nei **DATI e nel BANCO**, non nel codice — lo
stesso .ex5 su EURUSD fa 54 s/passata (F1).

---

## 3. 📚 GLI ATTI: cosa e' stato MISURATO davvero sul pavimento GBPUSD

Qui c'e' il punto piu' delicato, e va detto con precisione perche' i referti
sembrano contraddirsi:

**a) Sonda storico del 17/08 (`REFERTO_SONDA_STORICO_17-08.md`)** — la fonte
citata dalla cella 03:
- riga 65: `| GBPUSD | 1993.05.11 | 100.008 |` → **1993.05.11 e' la data che
  il BROKER dichiara**, e la colonna misurata era **`PrimaDataTF` su TF H1**
  (`R102_CRITERI.md` riga 188: _"@DAQUANDO = MISURATO nella sonda del 17/08
  (colonna `PrimaDataTF`, TF H1)"_). Le barre H1 **in locale** erano 100.008
  = **il tetto "Max barre" di MT5**, cioe' ~16 anni (righe 71-77).
- 👉 La riga 51 del prova `SONDA_OROLOGIO_03_GBPUSD_LONG.txt` ("LO STORICO DI
  QUESTO SIMBOLO: inizio 1993.05.11, sonda PrimaDataTF del 17/08") cita
  quindi una misura **fatta su H1, dichiarata dal broker** — NON una misura
  del pavimento **M1 in locale** sul terminale della sonda. L'avvertimento
  della riga di lancio ("il pavimento M1 di GBPUSD non e' mai stato misurato
  → fermati") era fondato.

**b) R102 Blocco 1 (`R102_REFERTO_BLOCCO1.md`, 24/08)** — l'atto che
INDEBOLISCE l'ipotesi "M1 mancanti": righe 16-18: _"lo scarico M1 dei tre
simboli e' COMPLETO — AUDUSD 9.614.917 barre dal 1993.04.26, EURUSD
10.014.728 dal 1971.01.03, **GBPUSD 9.863.886 dal 1993.05.11**, tutti
dichiarati COMPLETO dal confronto disco/broker"_. E la corsa OHLC-M1 di R102
ha prodotto operazioni GBPUSD dal **1999.01.14** (riga 105). Il terminale era
**lo stesso** della sonda: `RIGA_R102_CLASSIFICA_LUNGA.ps1` riga 762 seleziona
`BCM Markets MT5 Terminal` non `-V3`, identico al selettore di
`RIGA_SONDA_OROLOGIO.ps1` (righe 681-683).

**c) Cosa resta NON misurato**: che quelle M1 siano **ancora** li' oggi
(integre, senza buchi) e soprattutto **quanti tick il generatore produce da
quelle M1** su GBPUSD contro EURUSD. Il tick nativo BCM parte dal 2024
(F4 dice 2024.07.05; gli atti R109/R97 dicevano 2024.09.26): su **13,5 dei
15,5 anni** della finestra il Modello 4 **genera** i tick dalle M1 — per
TUTTI e due i simboli. La riga v3 della sonda questo lo dichiara gia' da sola
(`RIGA_SONDA_OROLOGIO.ps1` righe 131-137 e 450-460).

**d) Le celle 03/04 differiscono dalla 01/02 SOLO per simbolo, lato e magic
— VERIFICATO**, non dichiarato: il wrapper gatta ogni file contro `$Baseline`
(rischio, stop, ATR, take, posizioni, spread=0, flat — righe 364-373),
contro la `$GrigliaAttesa` letterale (`InpOraIngresso=0||0||1||23||Y`,
`InpOreDurata=4||4||4||12||Y`, righe 379-382) e contro l'elenco chiuso dei
parametri (righe 397-400). Nessuna riga `Spread` diversa: `-Spread` non e'
passato dalla riga della sonda, quindi in TUTTE le celle l'.ini non ha la
riga Spread (comportamento identico per costruzione). **La differenza di
costo non viene dalla configurazione.**

---

## 4. 🧠 LE IPOTESI, ORDINATE PER PROBABILITA', ciascuna con la predizione che la distingue

### H1 — 🥇 GENERAZIONE TICK FUORI SCALA su GBPUSD (dati M1 col tick_volume anomalo in qualche tratto) + 16 GB che non bastano → swap
Il Modello 4 senza tick reali genera i tick dalle M1 **in proporzione al
tick_volume di ogni barra M1**. Se il feed BCM di GBPUSD ha tratti (anni
vecchi, import, buchi ricuciti) con volumi per barra enormi o degeneri, il
generatore produce **ordini di grandezza piu' tick** che su EURUSD: prima
**esaurisce la memoria** (F2 — "no memory for ticks generating" e' proprio
l'errore del generatore di tick), poi, con 4 agenti, **lavora in swap** e la
passata passa da 54 s a ore (F3). E' l'unica ipotesi che spiega **TUTTI E
DUE** i sintomi (OOM + lentezza) con un solo meccanismo, ed e' coerente col
codice (costo ∝ n. tick, §2).
- **Predizione P1a**: una corsa GBPUSD ristretta a un tratto VECCHIO corto
  (es. 2011→2013, solo tick generati) e' lenta/pesante ANCHE da sola a banco
  fresco, mentre la stessa finestra su EURUSD no.
- **Predizione P1b**: una corsa GBPUSD ristretta al tratto RECENTE
  (2024.10→2026.06, solo tick reali) gira a velocita' EURUSD-simile.
- **Predizione P1c**: nel Giornale/agent di una passata singola la riga dei
  tick generati ("ticks generated") mostra per GBPUSD un numero >> EURUSD a
  parita' di finestra. Durante lo stallo il Task Manager mostra **disco al
  100% e commit sopra i 16 GB** (swap) o CPU piena con RAM satura.

### H2 — 🥈 Le M1 VECCHIE di GBPUSD non sono (piu') integre sul terminale → sync silenzioso dal server durante la corsa
Il download COMPLETO e' del 24/08 (atti §3b), ma nessuno ha misurato che
**oggi** ci sia ancora tutto (il tetto Max-barre, una pulizia, un buco). Se
al tester mancano M1, MT5 **le chiede al server in silenzio** durante la
corsa — nessun errore nel Diario (coerente con F3) — e/o genera dai TF
superiori. EURUSD non lo soffre perche' le sue serie erano appena state usate
(ricognizione 00_gemelli + celle 01/02 sono TUTTE EURUSD: banco "caldo" solo
per lei).
- **Predizione P2a**: la misura del pavimento M1 LOCALE di GBPUSD
  (`scarica_storico.ps1`, colonna `PrimaDataLocale` sulla riga M1) esce piu'
  recente del 2011 o con buchi; su EURUSD no.
- **Predizione P2b**: durante una passata incagliata c'e' **traffico di rete**
  costante del terminal64/agent e la cartella `bases\<server>\GBPUSD\history`
  cresce; il grafico GBPUSD M1 scrollato indietro si ferma prima del 2011.
- **Contro-fatto gia' agli atti** (perche' e' seconda e non prima): R102
  Blocco 1 ha dichiarato COMPLETO da 1993 sullo stesso terminale 8 giorni
  prima, e la corsa OHLC-M1 ha operato dal 1999.

### H3 — 🥉 E' il BANCO, non il simbolo (sessione satura, swap gia' pieno, agenti che si pestano)
Le celle EURUSD sono girate per prime a banco fresco; GBPUSD e' partita dopo
ore di macchina. Il "riavvio pulito con 4 agenti" indebolisce questa ipotesi
ma non la uccide: 4 agenti che generano ciascuno ~15,5 anni di tick su 16 GB
possono saturare comunque (e' il pezzo di H1 senza l'anomalia dei volumi).
- **Predizione P3**: la cella 01 EURUSD RILANCIATA adesso sarebbe lenta
  uguale (allora e' il banco); oppure una passata GBPUSD con **UN SOLO
  agente** a banco appena riavviato torna vicino ai 54 s (allora e' la
  concorrenza sulla RAM, non il simbolo).

### H4 — ❌ EA symbol-dipendente: ESCLUSA dalla lettura del codice
Vedi §2: nessun CopyTicks/CopyRates, nessun retry, OnTick O(1). Lo stesso
.ex5 fa 54 s/passata su EURUSD. Qualunque 200x sta nei dati o nel banco.

### Nota trasversale — le "4 passate veloci" (F3) sono un indizio, non un caso
A parita' di finestra OGNI passata attraversa gli stessi tick: sotto H1 le
prime 4 non avrebbero dovuto essere veloci. Due spiegazioni compatibili:
(i) erano **cache-hit** del giro ucciso (e allora nel CSV finale quelle righe
**MANCHERANNO**: un pass ripescato non chiama OnTester e la riga sparisce —
e' esattamente il conteggio F della riga v3); (ii) gli agenti hanno servito i
primi task mentre la preparazione dati (sync/generazione) era ancora in coda,
e lo stallo e' la preparazione, non la passata. **Verifica gratis**: contare
le righe del CSV parziale di GBPUSD, se esiste, e guardare `LastWriteTime`.

---

## 5. 🛠️ IL PIANO DIAGNOSTICO — 10 minuti al PC di backtest, forward MAI toccato

Tutto gira con gli strumenti di casa; i driver scrivono da soli
`AllowLiveTrading=false` e `ShutdownTerminal=1` negli .ini, quindi nessun
grafico vivo viene armato. **Ordine pensato per costo: prima le letture,
poi le due passate corte.** Le stringhe esatte le prepara il verificatore.

**PASSO A (≈1 min, non apre MT5) — rileggere l'ultimo censimento storico.**
`scarica_storico.ps1 -SoloReferto` rilegge l'ultimo
`ABTG_StoricoScaricato.csv` e stampa `PrimaDataLocale` per TF. Si guarda la
riga **M1 di GBPUSD** (e per confronto EURUSD): se il referto e' vecchio o
GBPUSD non c'e', lo dice — e la misura fresca del pavimento diventa il primo
follow-up (stesso strumento, `-Simboli "GBPUSD,EURUSD" -SenzaTick`, qualche
minuto in piu'). → decide **H2**.

**PASSO B (≈4 min) — cronometro GBPUSD SENZA storia vecchia (P1b).**
`walkforward_generico.ps1` con la prova **gia' esistente**
`SONDA_OROLOGIO_00_GEMELLI.txt` (4 passate, magic vergini 777290/91) ma con
`-Simbolo GBPUSD` e finestra `-DaQuando 2024.10.01 -Fino 2026.06.30`,
Modello 4, `-Rifai`. I parametri da riga di comando VINCONO sulle direttive
`@` del prova (`walkforward_generico.ps1` righe 303-305), quindi **non serve
nessun file nuovo**. Metro di confronto: la ricognizione EURUSD faceva 218 s
per 4 passate su 15,5 anni.
- 4 passate in pochi minuti → la storia recente e' sana: il costo sta nel
  tratto pre-2024 → si va al PASSO C.
- lente ANCHE qui → il problema non e' la storia vecchia: e' il banco o il
  download dei tick reali (H3, e si guarda il Task Manager).

**PASSO C (≈5 min, si puo' fermare a mano) — cronometro sul tratto VECCHIO corto (P1a).**
Stessa chiamata del PASSO B ma `-DaQuando 2011.01.01 -Fino 2013.01.01`
(solo tick generati, finestra 8 volte piu' corta di quella incriminata).
- Se le 4 passate impiegano molti minuti, o il Diario ridà "no memory for
  ticks generating" con un SOLO simbolo a banco fresco → **H1 confermata**:
  la generazione tick di GBPUSD e' fuori scala. Il Giornale dell'agent
  (cartella `Tester\Agent-...\logs`) riporta il conteggio dei tick: si
  fotografa e si confronta con la stessa corsa su EURUSD (facoltativa,
  altri ~3 min, stessa riga con `-Simbolo EURUSD`).
- Se invece girano in ~1-2 min → H1 e' morta per il 2011-2013: si sposta la
  finestrella (2015→2017, 2019→2021) per LOCALIZZARE il tratto malato, una
  corsa da 2-3 min l'una.

**Durante qualunque stallo: 30 secondi di Task Manager** (scheda Prestazioni):
- disco 100% + memoria committed oltre 16 GB → **swap** (H1/H3);
- CPU alta, RAM sotto controllo → sta davvero macinando tick (H1, variante
  solo-volume);
- tutto fermo ma **rete attiva** sul terminal64/metatester64 → sync storico
  dal server (H2).

**Cosa NON si fa**: niente grafici aperti a mano sul terminale del PC di
backtest (carica il profilo con gli EA: lezione 14/08) — non serve, i passi
A-C rispondono alle stesse domande dal tester; niente rilanci della cella 03
intera; niente VPS.

### Come si legge l'esito (griglia rapida)
| A: M1 GBPUSD locale | B: 2024→2026 | C: 2011→2013 | verdetto |
|---|---|---|---|
| completa dal ≤2011 | veloce | LENTA/OOM | **H1**: generazione tick fuori scala → per la sonda su GBPUSD serve un'altra strada (finestra dal pavimento tick reali, o tranche, o piu' RAM/meno agenti — decisione da prendere DOPO la misura) |
| monca / buchi | veloce | lenta con rete attiva | **H2**: pavimento M1 reale piu' corto del dichiarato → si misura il pavimento e la finestra si DICHIARA da li' (regola di casa: la profondita' si misura, non si assume) |
| completa | LENTA anche qui | — | **H3/banco**: si riprova a banco appena riavviato con 1-2 agenti prima di incolpare il simbolo |

---

## 6. 🧾 Fonti (percorsi nel repo, branch `lavoro`)
- `mql5/Experts/ABTG_SondaOrologio.mq5` (tutto; in particolare 485-496, 588-597, 624-712)
- `backtest_pipeline/righe/RIGA_SONDA_OROLOGIO.ps1` (131-137, 352-358, 364-400, 450-460, 681-683, 729-744, 917-922)
- `backtest_pipeline/prove/SONDA_OROLOGIO_03_GBPUSD_LONG.txt` (righe 44-51) e `SONDA_OROLOGIO_01_EURUSD_LONG.txt` (riga 51)
- `backtest_pipeline/risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` (righe 59-93)
- `backtest_pipeline/risultati_archivio/R102_REFERTO_BLOCCO1.md` (righe 13-26, 103-123)
- `backtest_pipeline/risultati_archivio/R102_CRITERI.md` (righe 112, 188, 585)
- `backtest_pipeline/walkforward_generico.ps1` (36-37, 303-312, 474-475, 592-595, 607-669)
- `backtest_pipeline/scarica_storico.ps1` (13-47, 108-132, 310, 445-447)
- `backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1` (riga 762)

_Questo referto DIAGNOSTICA e basta: nessun verdetto sulla sonda (criterio
C7 resta intatto), nessuna cella promossa o bocciata, nessuna sedia toccata._
