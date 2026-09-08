# 🎯 CACCIA — APERTURE (DAX / DOW / NASDAQ, DUE LATI) + ORO — 08/09/2026

**Mandato:** challenge prop **ai primi di ottobre** → restano ~3 settimane.
Non serve la strategia perfetta: serve un imbuto pieno di candidati
**misurabili in fretta**. Priorita' dichiarate: (1) motori per l'APERTURA di
DAX 08:00 server / Dow e Nasdaq 14:30 server, **sempre tutti e due i lati**
(regola firmata il 25/08); (2) motori sull'**ORO**.

🔒 **Nessun EA in forward toccato. Nessun parametro, nessun `.set`, nessun
magic sfiorato. Nessun backtest lanciato.**

---

## 🔴 LA PRIMA RIGA, che e' quella che il mandato chiede

> ## Per i due lati mancanti — **DAX SHORT** e **NASDAQ LONG** all'apertura — ho trovato **1 (UNO) candidato esterno nuovo**, e non zero.
>
> 🥇 **`Market Open Impulse [LuciTech]`** (TradingView, `fd3aaa16c57f…`,
> creato 12/08/2025, 205 righe Pine v5, **sorgente letto riga per riga oggi**).
> **Zero occorrenze in tutto il repo** — verificato con `grep -ril` su
> `.md` + `.txt`: e' materiale che questo progetto non ha mai visto.
> Il lato **non e' un input: lo decide la candela d'apertura**, quindi il
> DAX SHORT e il NASDAQ LONG escono **nativamente**, non come opzione.
>
> 🟡 **E un secondo, che e' una RIAPERTURA e la dichiaro come tale:**
> **`IU Gap Fill Strategy`** (MPL 2.0) fu scartato il 03/09 **SOLO per
> frequenza** contro il vecchio pavimento di 2 segnali/giorno **per lato**.
> Il **07/09 Claudio ha firmato che il pavimento e' 1,00 op/giorno per
> FAMIGLIA** e ha scritto: _"le esclusioni passate motivate SOLO dalla
> frequenza vanno rilette"_. Questa e' quella rilettura. Il suo ramo
> **gap-giu' → riconquista fallita → SELL** e' un generatore di **DAX SHORT
> e DOW SHORT** all'apertura.
>
> 🔴 **Sull'ORO: ZERO promossi da me, e il motivo e' aritmetico, non pigrizia.**
> Su 8 titoli oro/argento del Code Base e ~30 script oro di TradingView, i
> due unici con sorgente e con un motore leggibile (`Gold/Silver 30m Only`,
> `MAster Gold Strategy`) **non hanno nessuno stop loss**, e tutto il resto
> del Code Base e' `Recovery`, `Grid` o `Martin Gale` **nel titolo**. §5.

📊 **Il conto onesto della battuta:**

| | numero |
|---|---:|
| canali passati al controllo positivo | **8** (5 vivi, 3 murati) |
| titoli MQL5 Code Base censiti (26 pagine + 4 sonde in profondita') | **1.040** |
| di questi, filtrati per parola chiave d'apertura/gap/oro/orario | **211** |
| pagine Code Base **aperte** | **15** |
| sorgenti `.mq5` **scaricati e letti** | **8** |
| interrogazioni a TradingView (34 chiavi distinte) | **77** |
| righe di risultato TradingView viste | **~1.567** |
| **strategie open-source uniche** raccolte su TradingView | **127** |
| sorgenti **Pine scaricati e letti** oggi | **27** |
| **oggetti arrivati al SORGENTE LETTO** (totale) | **35** |
| 🥇 **PROMOSSI "PROVA SUBITO"** | **1** |
| 🟡 **RIAPERTURE motivate dalla firma del 07/09** | **1** |
| 🔴 **candidati ORO promossi** | **0** |
| EA in forward toccati | **0** |

---

## 0. 📕 LA LISTA DEI CADUTI — letta PRIMA di uscire, e ha morso

Fonti: `backtest_pipeline/REGISTRO_TEST.md` (1.827 righe),
`caccia_strategie/SETACCIO_MANUALE.md` (912 righe),
`caccia_strategie/biblioteca/sorgenti/` (elenco file),
`prove/R52_CENSIMENTO_LATI.md`, `report/ROBUSTEZZA.md`, `report/ROTTA_PROP.md`.

**Ha morso davvero: quattro oggetti che avevo gia' letto nel sorgente e che
stavo per proporre erano gia' stati setacciati.** Li elenco perche' questo e'
il valore vero della lista dei caduti:

| oggetto | quando fu setacciato | la riga che lo prova |
|---|---|---|
| `Opening Reversal - Model B` (alfredhastings_wk) | 28/08 | **e' gia' in casa**: `mql5/Experts/ABTG_OpeningReversalB.mq5` esiste, con l'attribuzione MPL 2.0 in testa, criteri congelati in `prove/ABTG_OpeningReversalB.txt` — e **non e' MAI stato girato** |
| `ICT Opening Gap — Confirmed Close` (Toddwaters72) | 28/08 | `CACCIA_APERTURA_DAX_EUROPA` r.276: _"🔴 STOP VIRTUALE. Prima del breakeven la `strategy.exit` non ha `stop=`"_ |
| `SP500 Session Gap Fade` (exlux, MPL 2.0) | 28/08 | `CACCIA_INTRADAY_FOREX_ORO` r.818: _"PROMOSSO COME SPECIFICA, SCARTO COME EA"_ |
| `002 - Inside Bar` / `003 - Weekly Day Reversal` (dj_ermoloff) | 16/08 **e** 22/08 | `SWEEP_MECCANISMI` r.417: _"GIA' SCARTATO PER ISCRITTO il 16/08 … non lo riapro per la terza volta"_ · `SWEEP_MECCANISMI_LIBERI` D1: _"ERA GIA' MORTO, E DUE VOLTE"_ |

E le famiglie chiuse che hanno guidato il primo taglio di oggi:

| famiglia | verdetto misurato |
|---|---|
| **breakout / ORB in apertura** | `REGISTRO_TEST` §2, 26.07.26: _"il breakout in apertura su M5 NON ha edge sul tick vero"_, **~210 celle** · R45 **0/48** · R12 **48/48 negative OOS** · R97 **0/4** |
| **A4 — Nasdaq apertura SOLO LONG** | **0% combo positive, best PF 0,91** → il buco "Nasdaq long" **non e' vergine**: e' gia' stato ucciso **col motore breakout** |
| **fade nudo degli estremi** | R42/R43 **0/24 IS e 0/24 OOS** · R60 MeanRevert **12/12** in perdita · R109 DD 44-68% |
| **compressione ATR → espansione** | 03/09, lapide **L3**: **9.723 segnali**, 0/8 sopra il pavimento, 7/8 sotto H8, **delta vs ingresso casuale −1,2 punti** |
| **sweep + reclaim su livello intraday** | R95 **30 passate su 30 in perdita** |
| **flusso recente del Code Base** | 06/09, su 400 titoli: _"pannelli, calcolatori, copiatori, logger"_ — 🟡 **oggi lo riconfermo su 1.040 titoli** |

---

## 1. 📡 CONTROLLO POSITIVO — fatto da me, oggi, PRIMA di cercare

| fonte | bersaglio noto | esito misurato | verdetto |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | devono comparire id che **so gia'** esserci: 76446, 76153, 77060 | HTTP **200**, 85.172 byte, **tutti e tre presenti** | 🟢 **PASSA** |
| **MQL5 Code Base — download sorgente** | `/en/code/download/74137/003-Weekly-Day-Reversal.mq5` | **200**, 11.730 byte, **318 righe di `.mq5` vero** | 🟢 **PASSA** |
| **TradingView** `pubscripts-suggest-json` | la query `opening range` deve dare `PUB;190` di ChrisMoody con >10.000 like | **200**, 50 risultati, `PUB;190` presente con **10.026 like** | 🟢 **PASSA** |
| **TradingView** `pine-facade` (sorgenti) | `PUB;da73a875…` deve rendere il Pine di `SP500 Session Gap Fade` | **200**, 7.405 byte, `scriptAccess: open_no_auth`, sorgente vero | 🟢 **PASSA** |
| **arXiv API** `export.arxiv.org` | `cat:q-fin.TR` deve tornare un feed Atom valido | **200**, 9.699 byte, feed valido | 🟢 **PASSA** (non ha prodotto candidati: §6) |
| **Quantpedia** `/strategies/` | elenco strategie | **200** dopo redirect su `/screener`, 641.789 byte, **82 slug di strategia estratti** | 🟢 **PASSA** (0 candidati utili: §6) |
| 🟠 **QuantConnect** | indice di strategie | **200**/**301**, pagine caricate ma **nessun indice estraibile** (contenuto JS) | 🟠 **raggiunta, sterile** |
| 🔴 **GitHub** | ricerca repo | **403** — coerente col mandato (_"bloccato da policy"_): non ci ho perso tempo | 🔴 **NULLA** |
| 🔴 **SSRN** `papers.ssrn.com` (bersaglio 4729284) | abstract | **403** | 🔴 **NULLA** (muro dal 29/08) |
| 🔴 **Forex Factory** `/forum/71-trading-systems` | elenco thread | **403** | 🔴 **NULLA** |

🔴 **Tre fonti su otto murate. Questa caccia e' zoppa su GitHub, SSRN e
Forex Factory, e lo dichiara.** Niente di cio' che segue viene dalla memoria:
quello che non ho aperto non e' scritto qui.

📏 **E dichiaro anche il PAVIMENTO del Code Base**: la pagina 45 risponde
**404** (fine dell'elenco), la 40 risponde 200 con 40 titoli. Ho censito
integralmente le **prime 26 pagine** (le piu' recenti) + sonde a 27/30/35/40.
Le pagine 27-44 sono la coda storica delle serie `Exp_*` russe, gia' battuta
dalle cacce del 16/08 e 22/08 (che avevano aperto proprio 17474, 19500, 17528,
23499, 42283, 43278, 44883, 49770, 52105, 59303).

---

## 2. 🥇 IL PROMOSSO — `Market Open Impulse [LuciTech]` · **PROVA SUBITO**

```
NOME            Market Open Impulse [LuciTech]
FONTE / URL     https://www.tradingview.com/script/fd3aaa16c57f4a75b712fa311c62594a/
                sorgente: pine-facade /get/PUB;fd3aaa16c57f4a75b712fa311c62594a/last/
AUTORE / DATA   @TradesLuci — creato 12/08/2025, versione 1.0     [VERIFICATO]
POPOLARITA'     209 like                                          [VERIFICATO]
LICENZA         🔴 NESSUNA licenza dichiarata nel sorgente (nessuna
                intestazione MPL/MIT: il file comincia con //@version=5).
                scriptAccess = open_no_auth (pubblico e leggibile).
                CONSEGUENZA: il .mq5 si scrive DA SPECIFICA, non si
                traduce riga per riga; attribuzione obbligatoria in testa.
                🔴 Il sorgente Pine NON e' stato archiviato in biblioteca.
RIGHE / INPUT   205 righe · **11 input funzionali** + 8 cosmetici  [CONTATI]
```

⚠️ **Non e' lo stesso oggetto** di `Breakouts With Timefilter Strategy
[LuciTech]`, gia' letto e scartato il 28/08 (`CACCIA_INTRADAY_INDICI`, r.442,
_"breakout puro al tocco … filtro orario e filtro MA entrambi OPZIONALI"_).
Qui non c'e' nessun livello da rompere e **non c'e' nessun filtro opzionale**.

### TESI IN UNA RIGA
> **"Guadagna perche' un'apertura ANOMALA e' un eccesso di ordine che il book
> non ha assorbito in mezz'ora, e chi si mette dalla parte dell'ordine residuo
> viene pagato dalla coda dell'esecuzione."**

### MECCANICA — tre righe, lette nel sorgente
- **Ingresso:** si guarda **una sola barra al giorno**, quella che comincia a
  `start_hour:start_minute` (righe 70-75, `is_market_open_candle()`). Se
  `high−low >= atr × impulse_multiplier` (1,5) **e** la chiusura sta sopra il
  punto medio **e** sopra l'apertura → **LONG**; specchiato → **SHORT**
  (righe 93-98). Se la barra non e' impulsiva, **non si opera**.
- **Stop:** `sl_type="Candle"` → **minimo/massimo della barra d'impulso**
  (strutturale, righe 125 e 144; passato in `strategy.exit` alle 138 e 157); `"ATR"` → ±0,5 ATR. Passato dentro
  `strategy.exit(..., stop=...)` → **stop vero, non virtuale**.
- **Uscita:** TP a `Risk_reward × stop_distance` (default **3R**) +
  **breakeven a 2R** implementato come **modifica** dell'ordine (righe 168-187),
  non come chiusura.

### GESTIONE RISCHIO — ed e' la sorpresa buona
🟢 **Rischio in PERCENTUALE dell'equity, scritto bene**:
`risk_amount = strategy.equity * risk_percent` → `position_size = risk_amount /
stop_distance` (righe 112-113). **Non e' lotto fisso.** E' esattamente il
sizing di casa. 🟢 Una posizione per volta (`if strategy.position_size == 0`).
🟢 `calc_on_every_tick` **non e' attivato** → decisione su barra chiusa.

### BANDIERE ROSSE (§4)
🟢 **NESSUNA.** Verificato a mano e per ricerca sul sorgente: nessun
moltiplicatore di lotto, nessun `pyramiding`, nessuna griglia, nessuna media,
nessuna copertura, nessuno stop virtuale, nessuna decisione presa sulla barra
in formazione, nessuna chiamata esterna.
🟡 **Un difetto vero, e va detto:** manca il **flat di fine seduta** —
l'originale non chiude a orario. Da mettere noi (§ "cosa rifaccio").

### COSTO DI PORTING
**Pine → MQL5 = riscrittura, non traduzione.** ~**6-8 ore** per un `.mq5` di
casa completo (rischio %, stop reale, BE, parziale+runner, gate di spread in %
dello stop, flat di seduta, `OnTester`, magic). La **logica** vera pero' e'
~40 righe: e' fra i porting piu' economici che abbia visto.

### PUNTEGGIO
| voce | voto | perche' |
|---|:--:|---|
| semplicita' | **2** | 10 input funzionali, **una regola sola**, nessun filtro opzionale |
| il filtro **E'** il motore | **2** | senza il gate `range >= K × ATR` **non esiste nessun segnale**. E' la condizione B di `ROBUSTEZZA.md`: **0 successi su 5** quando il filtro e' appiccicato, **30 celle su 30** quando e' costitutivo (`ABTG_EMA200` Dow, R29) |
| tesi di mercato scrivibile | **2** | una riga, e falsificabile: se il gate non separa, muore |
| riempie un BUCO | **2** | 🎯 **i due lati mancanti del mandato, entrambi, per costruzione**: la direzione la decide il dato, non un input |
| testabile senza riscritture | **1** | 🟡 va scritto il `.mq5`: 6-8 ore. Non e' `.mq5` pronto |
| | **9 / 10** | **PROVA SUBITO** |

**PERCHE', in una riga che deve reggere fra un mese:** e' l'unico oggetto della
battuta che ha insieme **un motore a due lati nativo**, **un gate costitutivo**
e **il sizing gia' giusto** — e il suo unico difetto (manca il flat di seduta)
e' esattamente la parte che questo progetto sa rifare.

### 🔧 COSA TENGO / COSA RIFACCIO (regola F, 16/08 — separati)
| tengo (il MOTORE) | rifaccio (la GESTIONE) |
|---|---|
| il grilletto: **la barra d'apertura e' il segnale** | orari in **ORA SERVER** (l'originale usa `Europe/London`) |
| il gate di ampiezza `range >= K × ATR`, **costitutivo** | **flat di fine seduta**, zero overnight (manca del tutto) |
| lo stop **strutturale** sulla barra d'impulso | **parziale 1R + pari + runner 2R** (la nostra gestione DAX/Dow) |
| il sizing `risk_amount / stop_distance` | **gate di spread in % dello stop** (R55, 2,5%) |
| il breakeven a **R**, non a punti | **pavimento di stop** `InpMinStopPts` (R109) + `OnTester` + magic |

### ⚠️ I TRE BUCHI, e nessuno e' nascosto
1. **L'ORA E' UN INPUT, E VA SCRITTA IN ORA SERVER.** L'originale gira su
   `Europe/London`. Il nostro server BCM e' **ora italiana − 1**:
   **DAX = 8, Nasdaq/Dow = 14:30 server**. Un'ora sbagliata qui non da'
   errore: **misura un'altra strategia** (`CLAUDE.md`, regola fissa).
2. **IL TF LO DECIDE IL CANCELLO DI COSTO, NON IL GUSTO.** Frontiera di casa:
   pavimento **DURO** `stop ≥ 13,3 × spread`, **DI LAVORO** `stop ≥ 40 ×
   spread`. Su D30EUR/NASUSD/U30USD lo stop naturale misurato e' **20 punti a
   M5** e **17,4 a M15** — **sotto** la soglia. **M30 e' il primo TF la cui
   volatilita' entra nella banda utile**, ed e' per questo che il file prova
   dice `@PERIODO M30` e non M5. Se allo screening lo stop mediano non arriva
   a 40 × spread, **si sale a H1 prima di girare la griglia, non dopo**.
3. **IL RAMO LONG POTREBBE ESSERE UN DOPPIONE, E VA MISURATO PRIMA.** Alla
   campanella gia' operano **770101** (DAX Apertura, SOLO LONG), **770202**
   (Dow Apertura, SOLO LONG) e **770611** (ORB-EMA200 Dow, SOLO LONG). Se i
   giorni-segnale del ramo long coincidono, il ramo long **non diversifica e
   va scartato** — e allora il valore di questo round e' **tutto nel ramo
   short**, dove non c'e' nessuna sedia. Cancello C4 del file prova.

### 🏛️ LA RIGA PROP (obbligatoria)
> **In ottica prop questo motore ha la forma giusta e un rischio da misurare.**
> 🟢 **Una operazione per simbolo al giorno, valutata su una sola barra**: il
> muro giornaliero (**−5.000 su 100k**) non lo puo' toccare con un trade solo
> a 0,65% (0,65% = 650 $, ~1/8 del cap). 🟢 **Stop strutturale** = il rischio
> e' noto prima. 🟢 **Sizing in % gia' nell'originale** = scalabile a 100k.
> 🔴 **Ma tre simboli che aprono lo stesso giorno nella stessa direzione sono
> UN rischio, non tre**: la nostra peggior giornata misurata (R51) e' **−2,06%**
> e due cosi' di fila sono meta' del cap giornaliero. La sovrapposizione si
> **misura** (C9), non si assume. ⚠️ E il **tetto per cluster firmato il 07/09
> NON E' ANCORA ATTIVO nel Guardian**: e' un'intenzione, non una protezione.
> 🔴 **DD trailing:** un motore che opera 1 volta al giorno per simbolo puo'
> restare settimane sotto il picco. Diverse prop usano un DD che **insegue
> l'equity** (Upcomers) e le nostre Monte Carlo sono tutte su DD **statico**:
> quei numeri col trailing **non valgono**, e non l'abbiamo ricalcolato.

📄 **File prova congelato:** `backtest_pipeline/prove/ABTG_ImpulsoApertura.txt`

---

## 3. 🟡 LA RIAPERTURA — `IU Gap Fill Strategy`, e la dichiaro come tale

```
NOME            IU Gap Fill Strategy
FONTE / URL     https://www.tradingview.com/script/9c46763fe5aa4cd9a048b3a1910944a6/
AUTORE / DATA   @Shivam_Mandrai — creato 10/03/2025                [VERIFICATO]
POPOLARITA'     186 like                                           [VERIFICATO]
LICENZA         🟢 MPL 2.0, dichiarata in testa al sorgente
RIGHE / INPUT   77 righe · **3 input**                             [CONTATI]
GIA' IN CASA    biblioteca/sorgenti/IuGapFillStrategy_ShivamMandrai-MPL2_
                tvT2ByrMw0_2026-09-03.pine  (scaricato il 03/09)
```

**Perche' torna in coda, e non e' un ripescaggio mascherato.** Il 03/09 fu
scartato con questa motivazione **testuale** (`CACCIA_FREQUENZA5_IMPLEMENTAZIONI`,
riga S18):

> _"Stesso tetto strutturale: 1 gap al giorno, e in piu' filtrato a
> `pec_gap = 0.2%` → sui nostri indici restano poche sedute l'anno."_

Cioe' fu scartato **SOLO PER FREQUENZA**, contro il pavimento di allora
(**2 segnali/giorno per lato**). Il **07/09 Claudio ha firmato** che il
pavimento e' **1,00 op/giorno per FAMIGLIA** e che _"le esclusioni passate
motivate SOLO dalla frequenza vanno rilette — tornano in coda all'imbuto, mai
in campo in automatico"_. **Questa e' quella rilettura, ed e' l'unica cosa che
la regola nuova mi autorizza a fare.**

E la stessa riga S18 chiudeva cosi': _"un pezzo da rubare, e lo scrivo perche'
e' gratis: l'ingresso NON e' all'apertura ma alla **riconquista confermata**"_.

### TESI IN UNA RIGA
> **"Guadagna perche' chi ha venduto il riempimento del gap si ritrova in
> perdita nel momento esatto in cui il livello viene riconquistato, e la sua
> uscita forzata e' il carburante della seconda gamba."**

### MECCANICA — letta nel sorgente (righe 13-38)
- Riferimenti **nativamente sulla SESSIONE CASH**: `session_first_bar_open` e
  `ta.valuewhen(session.isfirstbar, close[1], 0)` = **apertura cash di oggi** e
  **chiusura cash di ieri**. 🎯 **E' esattamente la correzione che il 06/09 ha
  reso vivo il gap del Nasdaq** — qui c'e' gia' dentro.
- Gap valido se `|gap| >= pec_gap%` (0,2%).
- **Gap SU** + una barra con `low < chiusura_ieri` **e** `close >
  chiusura_ieri` → **LONG**. **Gap GIU'** speculare → **SHORT**. Due lati
  nativi. `barstate.isconfirmed` → **solo barra chiusa**.
- Stop: **trailing ATR × 2 dal prezzo d'ingresso** → e' uno stop vero, che
  parte a 2 ATR e poi insegue. Nessun TP.

### 🎯 E PERCHE' TOCCA IL BUCO DEL MANDATO
Il ramo **gap-giu' → riconquista fallita → SELL** genera **DAX SHORT e DOW
SHORT all'apertura**, che nel censimento dei lati (`R52_CENSIMENTO_LATI.md`)
**non esistono**: 770101 SOLO LONG, 770202 SOLO LONG, 770611 SOLO LONG.

### 🔴 E LE TRE COSE CONTRO, scritte prima e non dopo
1. **LA FREQUENZA RESTA IL PROBLEMA VERO.** Anche col pavimento nuovo, un
   gap e' **uno al giorno per simbolo** e la soglia 0,2% ne toglie parecchi.
   **Per questo il file prova e' un CONTEGGIO (Passo 0), non una griglia**: se
   la famiglia {D30EUR, U30USD, NASUSD} × {long, short} non arriva a **1,00
   op/giorno**, si chiude scrivendo il numero, senza trattare.
2. **LA PREVISIONE DI CASA SUL LATO SHORT E' NEGATIVA, e va rispettata.**
   `GAPCASH_NAS_PASSO0.txt`, criterio **P0-5**, scritto il 06/09:
   _"PREVISIONE SCRITTA PRIMA: NULLA — sull'esterno la media e' +0,0076% con
   win 51,0% contro un controllo di 50,8%"_. ⚠️ Attenzione: quella e' la
   previsione per il **FADE** del gap in su sul **Nasdaq**. Questo motore e'
   una **CONTINUAZIONE** dopo un riempimento fallito, ed e' misurato **anche
   sul DAX**, dove nessuno ha guardato. Sono grandezze diverse — **ma se il
   Passo 0 esce piatto, la famiglia gap-in-apertura si chiude per davvero.**
3. **`ABTG_GapFill` (772231-772235) e' parente e va dichiarato.** Quello entra
   **contro** il gap puntando al riempimento **completo**, sul gap del
   **weekend**, su **H1**. Qui il gap e' quello della **sessione cash
   infrasettimanale** e la condizione e' che il riempimento **FALLISCA**. La
   parentela va scritta, non nascosta.

📄 **File prova congelato:**
`backtest_pipeline/prove/GAPCASH_RICONQUISTA_PASSO0.txt` (sonda di conteggio,
due lati, D30EUR/U30USD/NASUSD, M30)

---

## 4. 🥇🥇 IL CANDIDATO PIU' ECONOMICO DI TUTTI **NON E' MIO** — e va detto qui

Il miglior rapporto valore/tempo di questa battuta non e' un EA che ho trovato
fuori: e' un EA che **e' gia' in casa, compilabile, con i criteri gia'
congelati, e mai girato una volta**.

> 🔴 **`mql5/Experts/ABTG_OpeningReversalB.mq5` esiste.**
> `prove/ABTG_OpeningReversalB.txt` esiste, con ipotesi, cancello S0,
> cancello di scorrelazione e **obbligo dei due lati** gia' scritti.
> `report/GIACIMENTO_DI_CASA_2026-09-03.md` lo mette al **n.2** della lista
> del giacimento: _"criteri gia' congelati, il ramo CONFERMATO mai misurato"_.
> **Costo per avere un numero: una riga di lancio e una corsa.**

E' il **fade del drive d'apertura fallito a tre stadi di conferma** — cioe'
il **contrario logico** del mio promosso `ImpulsoApertura` (che va **a favore**
del drive). **Girati insieme sullo stesso simbolo e sulla stessa campanella,
i due rispondono alla stessa domanda dai due lati opposti**, e nessuno dei due
puo' bluffare l'altro. A tre settimane dalla challenge, questa e' la corsa
piu' redditizia che questa caccia sappia indicare.

⚠️ E' materiale di casa, non esterno: **non lo conto fra i miei promossi**.
Lo scrivo perche' non scriverlo sarebbe stato disonesto.

---

## 5. 🚫 LA TABELLA DEGLI SCARTI — una riga di motivo a testa

### 5a — arrivati al SORGENTE LETTO e scartati (il taglio che conta)

| oggetto | fonte | motivo dello scarto, con la riga che lo prova |
|---|---|---|
| **`20 Pips Opposite Last N Hour Trend`** | Code Base **19500**, barabashkakvn, 539 righe **lette** | 🔴🔴 **MARTINGALA CERTIFICATA**: `InpFirstMultiplicator=2` `InpSecond=4` `InpThird=8` `InpFourth=16` `InpFifth=32` (righe 52-56) + `InpMaxPositions=9` + **nessuno stop loss** (solo `InpTakeProfit=20`). §4, doppia |
| **`10pipsOnceADayOppositeLastNHourTrend`** | Code Base **17474**, stesso autore | 🔴 stesso impianto dell'autore, stessa famiglia. Scartato senza appello |
| **`Gap DM`** | Code Base **23223**, 605 righe **lette** | 🔴 `input ushort InpStopLoss = 0;` **e** `InpTakeProfit = 0;` di default + `InpMaxPositions = 15`: **nessuno stop e accumulo**. §4 |
| **`Gaps`** | Code Base **21617**, 392 righe **lette** | 🟠 SL vero (50 pip) ma **lotto fisso** `InpLots=0.1`, gap misurato **barra-su-barra** sul TF del grafico → su un CFD che quota 23 ore **il gap non esiste**: misurerebbe il nulla. Stessa trappola dell'OOPS |
| **`Exp_TimeZonePivotsOpenSystem`** | Code Base **22429**, 143 righe **lette** | 🔴 **lotto fisso** (`MM=0.1`, `MMMode=LOT`) + **stop in punti fissi** (`StopLoss_=1000`) + il "canale" e' di **ampiezza fissa** (`Offset=100` punti) attorno al prezzo dell'ora `StartH` = **un ORB con range sintetico**: famiglia chiusa |
| **`DAX Shooter 5M Strategy`** | TradingView `ENOEn0SBJ…`, th3web, 78 righe **lette** | 🔴 **NESSUNO STOP LOSS**: le due `strategy.exit(..., loss=90)` sono **commentate** (righe 63 e 69). Piu': RSI(7)+ADX>32+BB = doppione di `ABTG_BandFade`. (Era gia' in biblioteca dal 28/08 — l'ho letto lo stesso e confermo) |
| **`Gold Friday Anomaly Strategy`** | TradingView `9ca6beb3ed…`, piirsalu, MPL 2.0, 59 righe **lette** | 🔴🔴 **E' ROTTO, e in due punti**: `isFriday` e' calcolato e **mai usato**; l'ingresso e' `if dayofweek == 4` che in Pine e' **MERCOLEDI'** (`dayofweek.friday == 6`); e `if (barCounter % 1 == 0)` e' **sempre vero**, quindi `strategy.close` scatta **sulla stessa barra dell'ingresso**. Caso da manuale del perche' si legge il sorgente e non il titolo |
| **`Gold/Silver 30m Only Strategy`** | TradingView `brcH9KCdP1…`, MtxTrader, 2.082 like, 32 righe **lette** | 🔴 **nessuno stop loss** (solo `strategy.exit(when=...)` su condizione RSI) + la condizione d'uscita short e' incoerente con l'ingresso. 2.082 like non sono un criterio |
| **`MAster Gold Strategy` (15m)** | TradingView `v0d1rwLHjX…`, MtxTrader, 690 like, **8 righe** lette | 🔴 **nessuna uscita di nessun tipo**: due `strategy.entry` e basta. Non e' una strategia |
| **`Midnight Candle Color Strategy` (silver)** | TradingView `7f34674873…`, Rendon1, 286 like, 34 righe **lette** | 🔴 **TP 57 tick / SL 200 tick** cablati (e **48** tick sullo short: due costanti diverse senza motivo) = **rischio/rendimento 3,5:1 CONTRO**, e costanti tarate a mano su un simbolo. Sovradattamento dichiarato dal codice stesso |
| **`Gap Filling Strategy`** | TradingView `u53wbRdbE1…`, alexgrover, MPL 2.0, 1.389 like, 33 righe **lette** | 🔴 nel ramo di **default** (`invert=false`) c'e' solo `strategy.exit(..., limit=lim)`: **nessuno stop**. Lo `stop=` esiste **solo** nel ramo invertito. Piu': doppione di `ABTG_GapFill` |
| **`[VJ] First Candle Strategy`** | TradingView `a2456332…`, vikris, MPL 2.0, 323 like, 108 righe **lette** | 🔴 **fade NUDO** del colore della prima candela = famiglia R42 **0/24**, R60 **12/12**, R109 DD 44-68%. Piu': `calc_on_every_tick=true` e `default_qty_value=100` **% di equity** (all-in) |
| **`HSI First 30m Candle Strategy`** | TradingView `218b23dc…`, james0445, 75 righe **lette** | 🔴 **ORB puro** sul range dei primi 30 minuti, TP 1R, stop all'altro estremo: e' letteralmente la famiglia chiusa il 26.07.26 (~210 celle) |
| **`NY First Candle Break and Retest`** | TradingView `ccc5c273…`, PrincessQuinn, 546 righe **scansionate** | 🔴 **~25 input liberi** (tetto di casa ~15) con **quattro filtri OPZIONALI** (EMA, VWAP, volume, trailing) = il pattern §5B che ha fatto **0 successi su 5** in casa. Motore = break+retest della prima candela: doppione della leva gia' misurata in `Walkforward_Aperture/REFERTO_FASE_B_C5.md` |
| **`Toby Crabel's narrow range`** | TradingView `aysIrn2pVF…`, Tr0sT, 49 righe **lette** | 🔴 **compressione → espansione**: lapide **L3** del 03/09, **9.723 segnali**, 0/8 sopra il pavimento, **delta vs caso −1,2 punti** |
| **`002 - Inside Bar`** | Code Base **73884**, 318 righe **lette** | 🟠 **codice buono** (rischio %, SL 0,62×range della barra madre, TP a multiplo di R, pendente che scade, legge solo barre CHIUSE, gira su `PERIOD_CURRENT`) **ma gia' scartato due volte** (16/08, 22/08) e la famiglia e' la compressione→espansione di L3. Piu': `balance` letto **una volta in `OnInit()`** = rischio % che e' **lotto fisso travestito**, e **manca `OnTester`** |
| **`003 - Weekly Day Reversal`** | Code Base **74137**, 318 righe **lette** | 🟠 stesso autore, stesso impianto pulito, **ma `SWEEP_MECCANISMI_LIBERI` §D1 lo dichiara "GIA' MORTO, E DUE VOLTE"**, e il difetto strutturale e' scritto: mette **direzione (diretta/inversa) fra gli INPUT** e lascia all'ottimizzatore decidere **SE la tesi e' ribaltamento o continuazione**. Piu': 1 trade/settimana/simbolo e **niente `OnTester`** |
| **`ICT Opening Gap [Momentum1]`** | TradingView `d0e1bfb762…`, 66 righe **lette** | 🔴 **unica protezione** = `strategy.exit(stop=na, trail_points=10)`: 10 tick di trailing su un indice **non passa nemmeno il pavimento DURO** di 13,3 × spread |

### 5b — scartati al primo taglio (titolo / pagina), con il motivo

| oggetto | fonte | motivo |
|---|---|---|
| `Pending tread EA (Best for Gold)` | Code Base 61319 | **griglia** dichiarata nella descrizione: _"multiple pending orders arranged in a grid pattern"_ |
| `Sniper Gold Hybrid **Recovery** EA` · `Daily Zone **Recovery** for GOLD` · `XANDER Gold **Recovery**` · `XANDER **Grid** XAUUSD` | CB 76605, 75922, 72278, 71776 | **recovery / griglia nel titolo** = §4 |
| `Breakout **Martin Gale** EA` · `Periodic Range Breakout (**Martingale**)` · `Reversing **Martingale** EA` · `Reversing **Grid** on Limit orders` | CB 46591, 30560, 26324, 26418 | martingala/griglia nel titolo |
| `Quantum XAUUSD Silver Trader` · `Quantum Gold Silver Trader` | CB 73622, 63193 | **81 input** = fattoria di manopole (gia' a verbale nel `SETACCIO_MANUALE`) |
| `Session Range Desk MT5` (76927) · `Session Opening Range Breakout EA` (76153) · `AAPL cfd - ORB` (76333) · `Easy Range Breakout` (71460, 68764) · `Range BreakOut EA` (26451) · `Periodic Range Breakout 2.0` (31198) · `Lazy Bot (Daily Breakout)` (41732) | Code Base | **famiglia ORB/range breakout**, chiusa il 26.07.26 con ~210 celle a tick |
| `Viral (1M+ views) 4 Hour Range Strategy` (68082) | Code Base | breakout di range + **l'autore stesso scrive** _"my own backtest shows that this strategy does not work"_ |
| `Breakout Strategy with Prop Firm Helper Functions` (49713) | Code Base | motore = `Simple Yet Effective Breakout` (famiglia chiusa). 🟢 **Tenuto come ATTREZZO**: le funzioni di guardia prop sono da leggere per il Guardian |
| `Price Action Intraday Trading` (68704) | Code Base | pin bar + engulfing + inside bar **filtrati da due medie** = filtro appiccicato (§5B) + doppione di `ABTG_PinRejectRev` |
| `KSQ Fair Value Gap EA` (71467) | Code Base | doppione di `ABTG_FvgRetest`, e il "regime filter" e' **opzionale** (EMA/ADX/entrambi) = §5B |
| `MA + Envelope Breakouts` (74815) | Code Base | doppione di `ABTG_BandFade` / `ABTG_BreakingBand` |
| `Prime Quantum AI — TRADE WITH AI` (72527) | Code Base | chiamate di rete a LLM esterni = §4 |
| ~35 titoli tipo `RiskPilot`, `Trade Guardian`, `TradeHistoryLogger`, `Position Peak Logger`, `Basket Manager`, `Close All …`, `Trailing …` | Code Base pagine 1-26 | **pannelli, calcolatori, logger, chiudi-tutto**: zero ingressi, niente da backtestare |
| famiglia `[SHORT ONLY] …` (Botnet101, 5 script) · `Narrow Range + Inside Day Short Only` (ChartArt) | TradingView, sorgente disponibile | 🟠 **short-only veri**, e mi dispiace: sono **mean reversion su barra GIORNALIERA su azionario**, quindi violano il vincolo intraday/flat di fine seduta. Annotati, non promossi |
| `Xetra DAX Opening Range PRO V3.0` · `Opening Drive Continuation (NQ)` · `MNQ Gap-Fade (ETH)` | TradingView | `access=2/3`: **sorgente protetto** → §4 non applicabile → fuori per costruzione |
| ~25 `XAUUSD … Scalping` (M1/M5/10-min) | TradingView | 🔴 **aritmetica, non opinione**: stop da scalping sull'oro contro un pavimento DI LAVORO di ~9,6 $ (spread misurato 0,24 $). Chi non spiega come paga il pedaggio non entra |
| ~40 `indicator()` d'apertura (initial balance, first hour, opening range box) | TradingView | **disegnano scatole, non tradano**: nessun ordine, niente da misurare |

---

## 6. 🕳️ LE FONTI CHE NON HANNO PRODOTTO NIENTE — e perche'

| fonte | esito | perche' non ha prodotto candidati |
|---|---|---|
| **Quantpedia** (screener, 82 strategie estratte) | 🟢 raggiunta | Delle 82, le uniche vicine al mandato sono `turn-of-the-month-in-equity-indexes`, `pre-holiday-effect`, `market-sentiment-and-an-overnight-anomaly`, `mean-reversion-effect-in-country-equity-indexes`. **Sono tutte MENSILI o cross-sezionali su centinaia di titoli**: 1 operazione al mese e' **1/20 del pavimento**, e noi abbiamo 4 indici, non 3.000 azioni (stessa obiezione con cui il 03/09 fu scartato M12). **Zero candidati, e non e' un buco della fonte: e' la fonte sbagliata per un mandato intraday** |
| **arXiv q-fin** | 🟢 raggiunta (API 200) | Le due strade d'apertura sono **gia' chiuse in casa e a verbale**: la deriva a mezz'ora di Knuteson (`arXiv 2010.01727`) e' la lapide **M27** (_"nessuna mezz'ora paga nemmeno UNO spread"_), e la reversione overnight→intraday e' sepolta due volte (DAX 1.513 coppie, monotonia FALLITA; S&P segno rovesciato). **Non ho aperto un paper nuovo per non riportare cultura al posto di candidati** |
| **QuantConnect** | 🟠 raggiunta, sterile | pagine 200 ma **indice generato in JS**: nessun elenco estraibile senza browser. Dichiarato, non aggirato |
| 🔴 **GitHub** | **403** | policy di egress, coerente col mandato. **Quinta caccia di fila non battuta** |
| 🔴 **SSRN** | **403** | muro dal 29/08 |
| 🔴 **Forex Factory** | **403** | muro dal 29/08 |

### 🔴 E la cosa che NON ho potuto vedere e che pesa di piu'
| non visto | conseguenza |
|---|---|
| **profondita' a tick di XAUUSD** — in `risultati_archivio/misura_tick/` ci sono **SOLO** D30EUR, NASUSD, U30USD | 🔴 **nessun verdetto di merito sull'oro e' possibile oggi, per nessun candidato**. Il `@DAQUANDO` dell'oro **non si inventa**: si misura con `scarica_storico.ps1` |
| **spread BCM su XAUUSD** | mai misurato in repo. Lo strumento (`RealCost Spread P95 Logger`, Code Base 74148) e' **promosso dal 23/08 e mai usato**. E' il collo di bottiglia dichiarato che blocca `KA-Gold Bot` (Code Base 48251, **promosso 9/10 dal 25/08, mai costruito**) |
| **se D30EUR abbia un `_EXT`** | esiste `NASUSD_EXT` (import a verbale). Per il DAX **non l'ho trovato**: lo screening di regime 2020/2022 sul DAX **potrebbe non essere disponibile**, e va verificato prima di prometterlo |

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Sul NOSTRO DAX e sul NOSTRO Nasdaq, una candela d'apertura ANOMALA
> (range ≥ K × ATR) porta informazione sulla DIREZIONE del resto della
> seduta — e la porta ANCHE DAL LATO SHORT, dove non abbiamo nessuna sedia —
> oppure il suo vantaggio vive dentro lo spread, come e' gia' successo al
> lead-lag BOND→ORO il 06/09?"**

Ed e' una domanda **in due tempi**, perche' il primo puo' cancellare il secondo:

| passo | cosa misura | senza il quale... |
|---|---|---|
| **PASSO 0** | quanti segnali/giorno per simbolo e per lato · lo **stop mediano** in punti · lo **spread del minuto d'apertura** | ...non so se supera il pavimento di **1,00 op/giorno per famiglia** ne' se lo stop arriva a **40 × spread**: gira una griglia che risponde a un'altra domanda |
| **PASSO 1** | la griglia stretta (5 × 4 = 20 celle **per lato**), **due corse separate**, col **controllo a ingressi casuali** accanto | ...un win rate senza il suo caso non dice niente (16 celle, 32.339 segnali, delta medio **−0,70 punti**) |

### 🚦 Riga di lancio: **non la scrivo, e il motivo e' la checklist**
`CHECKLIST_RIGA_DI_LANCIO.md` punto 1: _"APRO LO SCRIPT. Ogni volta."_
**Gli EA di questi due candidati non esistono ancora** (`ABTG_ImpulsoApertura.mq5`,
`ABTG_SondaGapRiconquista.mq5`). Una riga di lancio che punta a un `.mq5`
inesistente non e' una riga di lancio: e' un errore in attesa. Si scrive
**dopo** il codice, e passando tutti e 4 i punti della checklist.

---

## 8. 📌 L'ORDINE DELLA CODA, se dovessi deciderlo io (ma decide Claudio)

| # | cosa | costo | perche' li' |
|---|---|---|---|
| **1** | 🥇 girare **`ABTG_OpeningReversalB`** (gia' in casa, mai girato) | **una riga + una corsa** | miglior rapporto valore/tempo della battuta, e non e' nemmeno mio (§4) |
| **2** | scrivere e girare **`ABTG_ImpulsoApertura`** | 6-8 h + una corsa | **l'unico candidato esterno nuovo per i due lati mancanti**, sizing gia' giusto, M30 dentro la frontiera di costo |
| **3** | sonda **`GAPCASH_RICONQUISTA`** (conteggio, due lati, 3 indici) | mezza giornata | risponde con **un numero** se la famiglia gap-in-apertura ha portata sotto il pavimento nuovo — e se e' no, **chiude la famiglia per davvero** |
| **4** | far girare il logger di spread **74148** su XAUUSD | una corsa | 🔓 **sblocca l'oro**: senza quel numero nessun candidato oro puo' avere un verdetto, incluso il `KA-Gold Bot` promosso 9/10 dal 25/08 |

---

_Cacciatore di strategie · 08/09/2026 · branch `lavoro`._
_Attribuzioni: `Market Open Impulse [LuciTech]` — @TradesLuci, TradingView
`fd3aaa16c57f4a75b712fa311c62594a` (nessuna licenza dichiarata: **letto, non
copiato**; l'eventuale `.mq5` va scritto da specifica con attribuzione in testa).
`IU Gap Fill Strategy` — @Shivam_Mandrai, TradingView, **MPL 2.0**.
`SP500 Session Gap Fade` — @exlux, **MPL 2.0**. `Gap Filling Strategy` —
@alexgrover, **MPL 2.0**. `002/003` — Sergei Ermolov (dj_ermoloff), MQL5 Code
Base 73884/74137. Gli EA barabashkakvn 19500/17474/23223/21617 e
GODZILLA 22429 sono citati come **scarti**, e non e' stato copiato niente._
