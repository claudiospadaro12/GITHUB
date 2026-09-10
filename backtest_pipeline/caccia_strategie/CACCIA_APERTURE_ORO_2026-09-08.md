# 🎯 CACCIA — APERTURE SUI DUE LATI (DAX short / Nasdaq long) + ORO — 08/09/2026

**Mandato di Claudio (07/09 notte), testuale:** _"mi preme trovare i motori per
le APERTURE dei mercati DAX, DOW, NASDAQ, LONG E SHORT. EA sull'ORO. Al di la'
delle mie preferenze, trovare EA e parametri che ci porteranno all'obiettivo
prop."_

🔒 **Nessun EA nostro toccato. Nessun parametro di forward sfiorato. Nessuna
riga di lancio costruita. Nessun backtest lanciato.**

---

## ⚡ LA RIGA CHE CONTA

> **Su 9 canali passati al controllo positivo (5 vivi, 4 murati), 320 titoli
> del Code Base MQL5 (8 pagine), 19 interrogazioni a TradingView per ~140
> script, 4 all'API arXiv, 40 articoli MQL5 e 2 ricerche testuali —
> **4 oggetti sono arrivati al SORGENTE LETTO**, e ne promuovo **UNO solo**.**
>
> 🥇 **P1 — `SessionReopenEA` (Code Base 77060, pubblicato IERI 07/09 alle
> 07:11).** Oro, un trade per sessione all'ora della riapertura CME dopo la
> pausa di manutenzione. **Zero bandiere rosse del §4**, SL vero server-side,
> 13 input, e un autore che **si e' corretto il modello di costo da solo** e
> ha ripubblicato i numeri dimezzati. **E' il motore-orologio che in casa
> abbiamo solo come sonda mai girata.**
>
> 🟡 **P2 — il pattern OOPS di Larry Williams** (articolo MQL5 21741). **E'
> l'unico meccanismo trovato che produce NATIVAMENTE il DAX SHORT e il NASDAQ
> LONG all'apertura**, con un interruttore di lato nel codice. **Ma va in coda
> e non entra come file**: (a) la pagina vieta esplicitamente la copia, (b)
> cosi' com'e' fa **8 operazioni in 4 anni** — intestabile.
>
> 🔴 **E la risposta scomoda sui due lati mancanti: FONTI ARATE.** Nessun EA
> esterno nuovo per il DAX SHORT o il NASDAQ LONG all'apertura. E' la **quarta
> caccia di fila** (29/08, 06/09 x2, oggi) che torna a mani vuote su
> quell'obiettivo. Il §6 dice perche', e dice dove sta invece la leva —
> **che e' di casa, misurata, e non e' un EA.**
>
> 🔧 **Bonus non richiesto ma che tappa un buco NOSTRO dichiarato:**
> `TrueCostReport` (Code Base 77015, stesso autore) misura il costo vero di un
> giro completo sul NOSTRO broker. E' l'attrezzo del buco §9.9 della caccia
> TF-basso (_"lo spread forex e ORO di casa non e' misurato"_). §7.

---

## 0. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire

Niente qui dentro e' stato riproposto. Fonti: `REGISTRO_TEST.md` (1.827 righe),
`SETACCIO_MANUALE.md`, `R52_CENSIMENTO_LATI.md`, `R95_REFERTO.md`,
`Walkforward_Aperture/REFERTO_FASE_B_C5.md` e i 7 dossier di caccia
dal 28/08 a oggi.

| caduto | dove | verdetto misurato |
|---|---|---|
| **famiglia BREAKOUT / ORB in apertura** | `REGISTRO_TEST.md` §2, verdetto **26.07.26** | *"Il breakout in apertura su M5 NON ha edge sul tick vero. Non costruire altri v2 M5."* ~210 celle |
| **R45 ORB Londra** | `REFERTO_ROUND45_LONDRA.md` | **0 celle positive su 48** |
| **A4 — Nasdaq apertura SOLO LONG** | `REGISTRO_TEST.md` riga A4 | **0% combo positive, best PF 0,91** — 🔴 **il buco "Nasdaq long" NON e' vergine: e' gia' stato provato e ucciso col motore breakout** |
| **ORB-straddle PS5** | `CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` | e' `ABTG_ORB` 770601, gia' morto in **R97, 0/4 celle** |
| **R95 sweep + reclaim** (EURJPY) | `R95_REFERTO.md` | **30 passate su 30** in perdita. ⚠️ ma il referto stesso dice: *"NON DICE che lo sweep sia morto ovunque"* |
| **R42/R43 fade degli estremi** | `REFERTO_ROUND42_FADE.md` | **0/24 IS e 0/24 OOS** |
| **R60 MeanRevert** | `REFERTO_ROUND60_MEANREVERT.md` | **12/12** in perdita |
| **Alta Velocita** | `REFERTO_ALTA_VELOCITA_V1.md` | rosso **8 su 8** a tick reali |
| **`GoldLondonBreakout`** (75586) | `SETACCIO_MANUALE.md` | *"e' LETTERALMENTE il nostro R45"* |
| **post-news sui metalli** | `CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` | sull'oro **il controllo casuale guadagna di piu'** |
| **lead-lag BOND→ORO** | `CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md` | esiste (t=+4,12) ma **vive dentro lo spread**: 54 celle, 0 promosse |
| **flusso recente del Code Base** | `CACCIA_SHORT_FREQUENZA_2026-09-06.md` | misurato su 400 titoli: *"pannelli, calcolatori, copiatori, logger"*. **Raccomandazione di smettere di spenderci cacce** — 🟡 oggi la riconfermo su 320 titoli, **con UNA eccezione** (§3) |

📌 **E un SOSPESO che va nominato ogni volta:** `KA-Gold Bot MT5` (Code Base
48251) e' **promosso 9/10 dal 25/08 e mai costruito**.

---

## 1. 📡 CONTROLLO POSITIVO — fonte per fonte, fatto PRIMA di cercare

| fonte | bersaglio noto | esito misurato oggi | verdetto |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | devono comparire id che **so gia'** esserci: 76446 (Chaos Lyapunov), 76153 (Session ORB), 76117 (Round Trip Cost), 75586 (GoldLondonBreakout) | HTTP **200**, 83.910 byte, **tutti e quattro presenti** | 🟢 **PASSA** |
| **MQL5 Code Base — download del sorgente** | `/en/code/download/77060/SessionReopenEA.mq5` | HTTP **200**, **20.591 byte, 409 righe di sorgente vero** | 🟢 **PASSA** |
| **MQL5 Articles** `/en/articles/mt5/trading_systems` | elenco articoli + allegato scaricabile | 200, 40 titoli; `articles/download/21741.zip` → **9.049 byte, zip valido, `.mq5` da 1.392 righe estratto** | 🟢 **PASSA** |
| **arXiv API** `export.arxiv.org` | `id_list=2010.01727` deve dare _"Strikingly Suspicious Overnight and Intraday Returns"_ | 200, **titolo esatto** | 🟢 **PASSA** |
| **TradingView** `pubscripts-suggest-json` + `pine-facade` | una query nota deve dare id, autore, like; e il `pine-facade` deve rendere il sorgente su `access=1` | 200; 3 sorgenti Pine scaricati davvero (righe contate) | 🟢 **PASSA** |
| **WebSearch** (canale bibliografico) | Donaldson & Kim 1993, di cui conosco rivista e pagine | restituisce **JFQA 28(3), 313-330** — corretto | 🟢 **PASSA** |
| 🔴 **GitHub** (UI, API di ricerca, `raw`) | elenco repo / file grezzo | **403 su tutto**, e lo status del proxy lo classifica come **policy di egress**, non quota. `gh` **non installato** | 🔴 **NULLA** — ⚠️ **e stavolta e' un 403, non il 429 del 06/09: cambia la diagnosi.** Quarta volta di fila non battuto |
| 🔴 **SSRN** `papers.ssrn.com` (bersaglio 4729284) | abstract | **403** | 🔴 **NULLA** (muro dal 29/08) |
| 🔴 **Forex Factory** `/forum/71-trading-systems` | elenco thread | **403** | 🔴 **NULLA** |
| 🔴 **MDPI** (paper *Price Gaps and Volatility*, JRFM 18(3), 132) | testo pieno, per il numero sul DAX | **403 al CONNECT** da curl **e** `EGRESS_BLOCKED` da WebFetch | 🔴 **NULLA** — vedi §6.2 |
| 🟡 **Quantpedia** `/strategies/` | elenco | **308** (redirect), non seguito | 🟠 non battuta |

🔴 **Quattro fonti su nove murate. Questa caccia e' zoppa su GitHub e sulla
letteratura a pagamento, e lo dichiara.** Niente di cio' che segue viene dalla
memoria: quello che non ho aperto non e' scritto qui.

---

## 2. 🥇 P1 — `SessionReopenEA` · **PROVA SUBITO** · scheda completa

```
NOME            SessionReopenEA
FONTE / URL     https://www.mql5.com/en/code/77060            [VERIFICATO]
                sorgente: /en/code/download/77060/SessionReopenEA.mq5
AUTORE / DATA   GianlucaGangemi — pubblicato 07 settembre 2026, 07:11
POPOLARITA'     Views 147 · Rating (2) · 1 commento     [VERIFICATO sulla pagina]
LICENZA         🟡 NESSUNA licenza OSI dichiarata. #property copyright
                "SessionReopenEA". Download libero dal Code Base, nessun
                divieto di copia sulla pagina (a differenza degli ARTICOLI,
                cfr. §4). Attribuzione obbligatoria in testa a un derivato.
RIGHE / INPUT   409 righe · 13 input        [CONTATI nel sorgente]
```

### TESI IN UNA RIGA
> **"Guadagna perche' la riapertura giornaliera dell'oro al CME concentra in
> una sola ora la domanda accumulata durante la pausa di manutenzione, e chi e'
> presente alla riapertura viene pagato per fornire quella liquidita'."**

### MECCANICA — tre righe, lette nel sorgente
- **Ingresso:** una volta per sessione, se l'ora server e' `InpEntryHour` e i
  minuti sono `< InpEntryWindowMin` (10). Compra a mercato. Salta il lunedi'
  (`InpSkipMonday`), che sul suo server e' la riapertura **settimanale**.
- **Uscita:** a tempo, `InpHoldHours = 2` ore dall'apertura (`ManageOpen`,
  r.224-227). **Nessun take profit.**
- **Stop:** `sl = ask − InpStopAtrMult(2,0) × MeanRange()`, dove `MeanRange` e'
  la **media di (high−low) su 480 barre H1** (~20 sessioni), r.190-201.
  **Mandato al broker dentro l'ordine** (`g_trade.Buy(... sl ...)`), quindi
  regge anche a EA spento. Rispetta `SYMBOL_TRADE_STOPS_LEVEL` (r.279-282).

### GESTIONE RISCHIO
🔴 **Lotto FISSO** `InpLots = 0.01` — *"Fixed lot - no scaling, ever"* (r.77).
🟢 SL **vero**, server-side. 🟢 **Una sola posizione** (`OnTick` r.135-141:
se c'e' una posizione aperta, gestisce e **esce**). 🟢 Un solo tentativo per
sessione anche in caso di rifiuto del broker (r.284-291, con il commento che
spiega perche': _"un EA che martella il broker dopo un rifiuto e' rotto"_).

### BANDIERE ROSSE (§4)
🟢 **NESSUNA.** Verificato per `grep` e a mano: nessun `MathPow` sul lotto,
nessun `Multiplier`, nessun `GridStep`, nessun `#import`, nessun `WebRequest`,
nessun `iCustom`, nessun controllo di account, nessuno stop virtuale, nessuna
decisione presa sulla barra in corso.

### COSTO DI PORTING
**~0 ore per lo SCREENING** (e' gia' `.mq5`, compila com'e').
**~4-6 ore** per la versione di casa (rischio %, parziale+pari, gate di
spread in % dello stop, sfrondatura input).

### PUNTEGGIO
| voce | voto | perche' |
|---|:--:|---|
| semplicita' | **2** | 13 input, 409 righe, una regola sola |
| il filtro **E'** il motore | **2** | l'orologio non e' un cerotto: **e' l'intera strategia**. Nessun filtro appiccicato |
| tesi di mercato scrivibile | **2** | una riga, e l'autore la falsifica da solo (§2.1) |
| riempie un BUCO | **1** | 🟡 riempie la **fascia oraria 23:00-01:00 sull'oro con un trigger a orologio**, che non abbiamo. **Ma NON riempie i due lati mancanti del mandato**, ed e' long-only: il buco short resta |
| testabile senza riscritture | **2** | `.mq5` pronto, zero dipendenze |
| | **9 / 10** | **PROVA SUBITO** |

**VERDETTO: 🥇 PROVA SUBITO (9/10).**
**PERCHE':** e' l'unico oggetto della battuta che ha insieme un motore sano,
una tesi falsificabile e zero costo di traduzione — e la sua unica debolezza
(la gestione) e' **esattamente** la parte che questo progetto sa rifare.

### 2.1 🧪 PERCHE' MI FIDO DEL METODO DELL'AUTORE (e non dei suoi numeri)

⚠️ **I numeri qui sotto sono DICHIARATI DALL'AUTORE, NON VERIFICATI da noi, e
non pesano di un grammo sul punteggio.** Li riporto perche' **il modo in cui
sono stati prodotti** e' una prova di serieta' rara:

- Ha pubblicato prima **+3,34 bps/trade, t=7,40, PF 1,63, 11 anni su 11**.
- Poi **ha trovato da solo l'errore**: il campo `spread` della barra M1 e' un
  **riassunto per barra** e sottostima il costo alla riapertura **di ~3 volte**
  (19 punti caricati contro **60 punti misurati a tick reali**).
- Ha **ripubblicato i numeri dimezzati**: **+1,60 bps, t=3,42, PF 1,30, 10 anni
  su 11**, e ha scritto in testa al file *"That second number is the real one"*.
- Ha lasciato agli atti le **falsificazioni**: non e' un gap (media −0,011
  attraverso la pausa, *"the move happens with the market open"*); non e'
  outlier (media trimmata 1% = +0,70 contro +0,75 piena); non e' la
  normalizzazione dello spread (lo spread e' **piatto** su tutta l'ora);
  entrare 15 e 30 minuti dopo **paga ancora, a 45 muore**; e la riapertura
  **settimanale non fa parte dell'effetto** (domenica +1,11 bps con **t=0,88**
  contro +3,90 e **t=8,32** delle giornaliere) — **da cui `InpSkipMonday`.**
- E scrive *"test it with every tick based on real ticks. On bar-modelled data
  this project once turned a −15.627 into +79.000 without changing a line"*.

🎯 **E' la nostra regola F6 scritta da un estraneo.** Non prova che l'edge
esista sul NOSTRO broker: prova che **vale la pena spendere un round per
scoprirlo**.

### 2.2 🔴 I QUATTRO BUCHI, e nessuno e' nascosto

**1. L'ORA VA MISURATA, NON COPIATA. E' il rischio n.1 di questo candidato.**
L'autore usa `InpEntryHour = 1` **sul SUO server**, che dal suo commento e'
allineato all'ora legale **americana** (18:00 New York → 01:00 = GMT+3).
Il **nostro** server BCM e' **ora italiana − 1** e segue l'ora legale
**europea**.
- [INFERITO, dal commento r.62-66 + la regola di fuso di `CLAUDE.md`]: sul BCM
  la riapertura dovrebbe cadere intorno alle **23:00 server**, e restare li'
  tutto l'anno perche' anche noi cambiamo ora — **tranne le ~3 settimane di
  marzo e di ottobre/novembre in cui i due cambi non coincidono**, dove
  slitterebbe di un'ora.
- 🔴 **[INCERTO] E soprattutto: non so se BCM abbia una pausa su XAUUSD, ne' a
  che ora.** Va **misurato** prima di scrivere qualunque `InpEntryHour`.
  Un'ora sbagliata qui non da' errore: **misura un'altra strategia.**

**2. IL CANCELLO DI COSTO — e stavolta l'aritmetica e' contro, non a favore.**
Frontiera di casa (`CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6.1):
pavimento **DURO** `stop ≥ 13,3 × spread`, pavimento **DI LAVORO**
`stop ≥ 40 × spread`.

| costo usato | pavimento DURO | pavimento DI LAVORO | lo stop dell'EA (2,0 × range orario medio) |
|---|---:|---:|---|
| spread oro **diurno MISURATO in casa** 0,24 $ | **3,2 $** | **9,6 $** | ~10-18 $ [INFERITO dall'ordine di grandezza del range orario] |
| costo **alla riapertura**, 60 punti = **0,60 $** (misurato dall'AUTORE, non da noi) | **8,0 $** | 🔴 **24,0 $** | **sotto** |

👉 **Passa il pavimento DURO, NON passa quello DI LAVORO al costo della
riapertura.** Significa che il pedaggio si mangia il **3-6%** dello stop invece
del 2,5% di progetto. **Non e' uno scarto** (l'autore il costo lo ha gia'
dedotto e l'edge sopravvive), **e' un cancello da mettere nel file prova
PRIMA**, e il primo numero da misurare e' **il nostro spread dell'oro a quelle
ore**, che oggi **non abbiamo**.

**3. IL VERDETTO DI MERITO OGGI NON E' POSSIBILE, ed e' scritto nel mandato.**
🔴 **La profondita' a tick di XAUUSD non e' mai stata misurata**: in
`risultati_archivio/misura_tick/` ci sono **solo** D30EUR, NASUSD, U30USD
[VERIFICATO, cartella elencata]. Regola F6: **verdetti solo a tick reali**.
👉 **Finche' la sonda non gira, di questo candidato si puo' avere solo uno
screening.** `@DAQUANDO` del file prova resta **VUOTO**, per progetto (§8).

**4. FASCIA ORARIA GIA' OCCUPATA SULLO STESSO SIMBOLO.**
`ABTG_MaxMinNotte` XAUUSD (magic **770402**, H2, long+short) lavora sulla
**notte dell'oro**. Non e' lo stesso segnale (li' e' la rottura del max/min
notturno, qui e' un orologio senza livello), ma e' **lo stesso simbolo nella
stessa fascia**. 🔴 Regola di rotta prop: *"mai due EA sullo stesso
segnale/simbolo/lato allo stesso rischio pieno"*. **Prima di schierarlo si
misura la sovrapposizione delle operazioni**, non si assume.

### 2.3 🏛️ LA RIGA PROP (obbligatoria, §7-bis)

> **In ottica prop, questo motore e' il tipo giusto con l'avvertenza sbagliata.**
>
> - 🟢 **Rischio giornaliero strutturalmente basso:** **UNA operazione per
>   sessione**, una posizione alla volta, uscita a tempo dopo 2 ore. Il muro
>   giornaliero (−5.000 su 100k) non lo puo' toccare con un trade solo.
> - 🟢 **Frequenza ~200 operazioni/anno** [dichiarata dall'autore] ≈ **0,8
>   op/giorno**: sotto il pavimento di **1,00** ma — regola firmata il 07/09 —
>   il pavimento si misura **per FAMIGLIA**, e con due simboli ci arriva.
> - 🟢 **Scorrelazione oraria vera:** nessuna sedia viva ha un trigger a
>   orologio senza livello. Il fattore di rischio e' diverso da tutte.
> - 🔴 **DD dichiarato 4,6% su capitale dimensionato per un DD del 20%**: e'
>   sopra il muro giornaliero se scalato cosi'. Al **nostro** 0,65% quella
>   forma si riduce, **ma il numero va rifatto, non convertito a occhio.**
> - 🔴 **Lotto fisso = non scalabile a 100k e non confrontabile.** Prima
>   riscrittura obbligatoria.
> - ⚠️ **DD trailing:** l'autore dichiara *"circa un anno su nove e'
>   negativo"* e `return/drawdown 6,5`. Una curva che passa anni interi sotto
>   il picco e' **esattamente la forma che il DD trailing punisce**
>   (`DOSSIER_PROP_UPCOMERS`). **Segnalato, come impone la regola.**

---

## 3. 🔧 IL BONUS CHE NON HO CERCATO — `TrueCostReport` (Code Base 77015)

**Stesso autore, pubblicato 06/09/2026.** 🔴 **Non e' un candidato da imbuto:
e' un attrezzo, dichiaratamente _"strictly read-only, it never opens, closes
or modifies a position"_** → zero ingressi = niente da backtestare.

**Perche' lo scrivo lo stesso:** misura **il costo vero di un giro completo**
sul nostro broker e sul nostro simbolo — spread live campionato dai tick, swap
dei due lati incluso il giorno del triplo, commissione letta dai nostri deal
chiusi. E porta la misura che ci riguarda: **su XAUUSD lo spread live e' 20
punti su 60 letture consecutive, mentre il campo della barra M1 ha mediana 6.
Un fattore 3,3.** [dichiarato dall'autore sulla pagina, NON verificato]

👉 **E' l'attrezzo del buco §9.9 della caccia TF-basso** (_"lo spread forex e
oro di casa non e' misurato; e' il collo di bottiglia"_). ⚠️ **Non l'ho letto
nel sorgente** — ho letto la pagina. Va letto prima di girarlo.

---

## 4. 🟡 P2 — IL PATTERN **OOPS** · IN CODA · l'unico che tocca i due lati

```
NOME            lwOopsPatternExpert (Larry Williams Market Secrets, Part 16)
FONTE / URL     https://www.mql5.com/en/articles/21741         [VERIFICATO]
AUTORE / DATA   Chacha Ian Maroa — 25 agosto 2026, 15:55 · 2.374 letture
LICENZA         🔴 "All rights to these materials are reserved by MetaQuotes
                Ltd. Copying or reprinting of these materials in whole or in
                part is prohibited."                    [VERIFICATO, testuale]
RIGHE / INPUT   1.392 righe · 8 input (7 funzionali)   [CONTATI nel sorgente
                estratto da articles/download/21741.zip]
```

### TESI IN UNA RIGA
> **"Guadagna perche' un'apertura oltre l'estremo del giorno prima e' un ordine
> di massa che non trova conferma: quando il prezzo rientra nel range
> precedente, chi e' entrato sull'apertura e' intrappolato e deve uscire."**

### MECCANICA
- **Gap giu':** apertura sotto il **minimo** del giorno prima di almeno
  `minimumGapSizePoints`. Poi, su una **barra CHIUSA successiva**, chiusura
  **≥ quel minimo** → **COMPRA**.
- **Gap su:** speculare sopra il **massimo** → **VENDE**.
- Il setup scade dopo `maxGapValidityBars = 3` barre.
- **SL = l'estremo della barra del gap** (strutturale). **TP = RR 2,5.**

### 🎯 PERCHE' E' RILEVANTE PER IL MANDATO — ed e' l'unico
| il buco | come lo copre |
|---|---|
| 🔴 **DAX SHORT in apertura** | il ramo **gap-su → vendi** e' **meta' del motore**, non un'opzione aggiunta dopo |
| 🔴 **NASDAQ LONG in apertura** | il ramo **gap-giu' → compra**, idem |
| **il lato e' un input nativo** | `ENUM_OOPS_TRADE_DIRECTION { LONG_ONLY, SHORT_ONLY, BOTH }` — **e' esattamente la REGOLA DEI DUE LATI del 25/08 gia' cablata nel codice** |

### E PERCHE' NON E' UN CADUTO — tre differenze, tutte nel sorgente
1. **Non e' l'ORB** (famiglia chiusa 26.07.26): **non c'e' nessun range
   d'apertura e nessuna rottura**. Il livello e' l'estremo del **periodo
   precedente**, e si entra **contro** l'apertura, non a favore.
2. **Non e' R95 sweep+reclaim** (0/30): li' si buca e si rientra **dentro la
   stessa barra** su un livello intraday; qui il grilletto e' **l'APERTURA**
   fuori range e la conferma arriva su una **barra chiusa successiva**. E'
   l'asse "grilletto differito" che gia' distingue `ABTG_BreakinBox` da R95.
3. **Non e' `ABTG_GapFill`** (772231-772235): quello entra **contro il gap
   verso la chiusura precedente**, con `InpFillPct`, **senza pretendere la
   riconquista di un estremo**. Qui la riconquista **e' la condizione**.

### 🔴 MA VA IN CODA, PER DUE MOTIVI DURI

**1. LA LICENZA VIETA LA COPIA — e il mandato e' esplicito.**
_"Copying or reprinting of these materials in whole or in part is prohibited."_
E' **piu' restrittiva** di CC-BY-NC, che il mandato dichiara squalificante.
👉 **Il file NON e' stato archiviato in `biblioteca/sorgenti/`, di proposito.**
Leggerlo e' lecito; copiarlo in repo no. **Il PATTERN pero' non e' loro**: e'
di Larry Williams, pubblicato nei suoi libri da 40 anni ed e' patrimonio
pubblico. **Se si costruisce, si scrive da zero dalla definizione del pattern**,
citando l'articolo come fonte della lettura e mai come sorgente del codice.

**2. COSI' COM'E' NON E' TESTABILE — e la prova la porta l'autore.**
Il suo test dichiarato: **XAUUSD, D1, 01/01/2022 → 28/02/2026, tick reali** —
e produce **8 operazioni in poco piu' di 4 anni** (5 long di cui 1 vincente,
3 short di cui 3 vincenti). L'autore stesso scrive che PF e drawdown *"should
be read directly from the report rather than estimated"*.
🔬 **E il motivo di quelle 8 operazioni e' la lezione R62 di casa, ripetuta da
un estraneo senza accorgersene:** il gap e' calcolato come *apertura della
barra corrente vs estremo della barra precedente* **sul timeframe del
grafico**. Su un CFD che quota ~23 ore, la barra D1 **non ha gap**: si
attraversa la mezzanotte del server, dove non succede niente. Con soglia 500
punti su XAUUSD ($5) il setup **quasi non esiste**.
👉 **Il meccanismo diventa vivo solo se il riferimento e' la SESSIONE CASH**
(estremo della sessione cash precedente contro l'apertura della cash) — che e'
**la stessa correzione** che ha reso vivo il gap del Nasdaq il 06/09. **Non e'
un parametro: e' una riscrittura del riferimento.**

### PUNTEGGIO
| voce | voto | perche' |
|---|:--:|---|
| semplicita' | **2** | 7 input funzionali |
| il filtro E' il motore | **2** | il gate direzionale **e'** la strategia |
| tesi scrivibile | **2** | si', e in una riga |
| riempie un BUCO | **2** | 🎯 **i DUE lati mancanti del mandato, entrambi** |
| testabile senza riscritture | **0** | 🔴 licenza che vieta la copia **+** riferimento del gap da riscrivere. n=8 in 4 anni |
| | **8 / 10** | ma il **voto 0** sull'ultima voce e' bloccante: **IN CODA, non PROVA SUBITO** |

**VERDETTO: 🟡 IN CODA.**
**PERCHE':** e' il meccanismo giusto sul buco giusto, ma oggi non e' un EA da
provare — e' una **specifica da scrivere**, e va accodata dietro a una misura
di casa (il gap della sessione cash sul DAX) che non e' ancora stata fatta.

### 🏛️ Riga prop
> Una operazione per giornata al massimo, un setup che scade in 3 barre, SL
> strutturale e rischio in %: e' **la forma giusta per una challenge**. Ma con
> una frequenza che, ancorata alla sessione cash, resta di **poche operazioni
> al mese per simbolo** → **vive solo come famiglia su 3-4 indici insieme**,
> mai come sedia singola. E allora il tetto per cluster (firmato il 07/09, **NON
> ancora attivo nel Guardian**) diventa il vincolo che decide.

---

## 5. 🚫 LA TABELLA DEGLI SCARTI — una riga di motivo a testa

### 5a — arrivati al sorgente e scartati
| oggetto | fonte | motivo dello scarto |
|---|---|---|
| **`NASDAQ 8AM Opening Candle`** (danielcdzz, 105 like, 07/05/2026) | TradingView `4f4e4c94...`, 61 righe **lette** | 🔴 **e' un `indicator()`, non una `strategy()`**: zero ordini, niente da backtestare. E il meccanismo (direzione della prima candela oraria → continuazione, SL a `low − 5 pips`) **e' il caduto A4** (`REGISTRO_TEST`: 0% combo positive, PF 0,91). Doppione di un morto |
| **`NY Open / Opening Drive / Close (15m)`** (TheMikeDoc, 33 like) | TradingView `ba159f78...`, 33 righe **lette** | 🔴 `indicator()` che disegna **quattro linee verticali** agli orari 9:30/9:45/16:00/19:00 NY. Nessuna regola d'ingresso. Non e' una strategia |
| **`DAX GAPS`** (AleksanderThor, 94 like) | TradingView `IrAhtWxZ...`, 10 righe **lette** | 🔴 `study("DOW GAP")` — **il titolo pubblico dice DAX, il codice dice DOW**, ed e' un indicatore da 10 righe del 2016. Caso da manuale del perche' si legge il sorgente e non la descrizione |

### 5b — scartati da titolo/pagina (primo taglio)
| oggetto | fonte | motivo |
|---|---|---|
| `SMC Liquidity Sweep Scalper` | Code Base **77094** (07/09) | famiglia **sweep+reclaim**, gia' 30/30 in perdita in R95; e "scalper" a fronte della frontiera del costo |
| `Sniper Gold Hybrid **Recovery** EA` | Code Base 76605 | **recovery** nel titolo = §4 |
| `Daily Zone **Recovery** EA for GOLD` | Code Base 75922 | idem, e gia' nel `SETACCIO_MANUALE` |
| `XANDER Gold Recovery`, `XANDER **Grid** XAUUSD` | 72278, 71776 | recovery / griglia = §4 |
| `Breakout **Martin Gale** EA` | 46591 | martingala dichiarata nel titolo |
| `Long and Short **Stepped Grid** Trade` | 38300 | griglia |
| `Session Opening Range Breakout EA` | 76153 | **gia' scartato il 19/08**, famiglia ORB chiusa |
| `AAPL cfd - ORB strategy` | 76333 | famiglia ORB chiusa + simbolo che non abbiamo |
| `Gold ORB - Asia & London Sessions` | TradingView `1d2a34d1...` | ORB su oro = **R45, 0/48** |
| `Xetra DAX Opening Range PRO V3.0` (Steffen_Schubert) | TradingView `ac53a17d...` | 🔴 **`access=3`: sorgente non leggibile.** Niente sorgente = §4. E comunque ORB |
| `Opening Drive Continuation (NQ)` (joetroyer, 33 like) | TradingView `88828a68...` | `access=2`: **protetto, niente sorgente** |
| `MNQ Gap-Fade (ETH)`, `RTH Gap Fade` | TradingView | `access=2`, protetti |
| famiglia `[SHORT ONLY] ...` (Botnet101, 4 script) | TradingView, `access=1` | 🟡 sorgente disponibile e **short-only vero** — ma sono **mean reversion su barra GIORNALIERA** su azionario: **violano il vincolo INTRADAY/flat a fine seduta** del mandato. Annotati, non aperti |
| ~15 "prima ora / initial balance / first hour" | TradingView | **tutti `indicator()`**: disegnano scatole, non tradano |
| ~25 `XAUUSD ... Strategy` (M1/M5/10-min) | TradingView | 🔴 **aritmetica, non opinione**: stop da scalping su oro contro un pavimento DURO di 3,2 $ e uno DI LAVORO di 9,6 $ (spread misurato 0,24 $). Chi non spiega come paga il pedaggio, non entra |
| `Prime Quantum AI — TRADE WITH AI` | Code Base 72527 | chiamate di rete a LLM esterni = §4 (`WebRequest`/DLL) |
| 34 titoli del Code Base tipo `RiskPilot`, `Trade Guardian`, `GridCapitalCalculator`, `TradeHistoryLogger`, `Position Peak Logger`, `Market Replay Tool`, i 4 `GDS Renko ... Demo` | Code Base pagine 1-8 | **pannelli, calcolatori, logger, demo**: zero ingressi. Riconferma su 320 titoli della diagnosi del 06/09 |

---

## 6. 🕳️ I DUE LATI MANCANTI: perche' torno a mani vuote, e dove sta la leva

### 6.1 Il fatto, detto senza girarci intorno
**Su DAX SHORT e NASDAQ LONG in apertura non ho trovato NIENTE di esterno e
nuovo.** Quarta caccia consecutiva. I tre motivi ricorrenti, misurati:

1. **Quello che c'e' fuori e' ORB, e l'ORB in apertura da noi e' chiuso.**
   Su ~140 script TradingView e 320 titoli Code Base guardati, **ogni** oggetto
   d'apertura con sorgente leggibile e' una rottura del range d'apertura o un
   suo retest. Sono le due geometrie che abbiamo gia' misurato a tick.
2. **Chi ha qualcosa di diverso lo protegge.** I tre oggetti d'apertura piu'
   interessanti visti oggi (`Xetra DAX Opening Range PRO`, `Opening Drive
   Continuation (NQ)`, `MNQ Gap-Fade`) sono **tutti `access=2` o `access=3`**:
   niente sorgente → §4 non applicabile → fuori per costruzione.
3. **Quasi tutto il resto e' un `indicator()`.** Disegna la scatola
   dell'apertura e si ferma li'. Non ha ingressi, non ha stop, non ha niente
   che l'imbuto possa misurare.

### 6.2 E la letteratura, per quel poco che ho potuto aprire, e' TIEPIDA sul gap del DAX
Dalla ricerca testuale [🟠 **LETTO-VIA-SEARCH, le pagine sono murate**: MDPI
403/EGRESS_BLOCKED, SSRN 403]: il paper *Price Gaps and Volatility: Do Weekend
Gaps Tend to Close?* (JRFM 18(3), 132) darebbe *"only tentative support"* al
gap del DAX, con *"subtler gap effects"* rispetto agli indici USA; e l'arXiv
**2605.04004** (Mesfin, **gia' nel nostro `REGISTRO_TEST`**) dichiara che sul
MNQ *"the gap fill fade fails at every tested entry time"*.
🔴 **Non l'ho verificato sulla pagina e quindi non lo uso come prova.** Ma se
regge, dice che **il gap-fade del DAX e' piu' debole di quello degli indici
USA** — cioe' che il buco DAX-short **non si tappa copiando il meccanismo che
ha funzionato sul Nasdaq**. Da tenere presente prima di spendere un round.

### 6.3 🎯 DOVE STA LA LEVA — ed e' di casa, misurata, e non e' un EA
Il mandato me l'ha data ed e' giusto ripeterla come **conclusione**, non come
scoperta:

| leva | numero misurato | fonte |
|---|---|---|
| **STOP → LIMIT sul ritorno al livello** | DAX OOS **−225,44 → +392,96**; Nasdaq **PF 1,063 → 1,109** con **DD 4,13% → 3,68%** | `Walkforward_Aperture/REFERTO_FASE_B_C5.md` |
| **il gap della SESSIONE CASH** (non quello di mezzanotte) | Nasdaq: media **+0,0988%**, win **60,1%**, n=348 contro un controllo a +0,0112% e 50,8% | `CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` |

👉 **Il DAX SHORT si misura prima in casa, non si compra fuori.** La domanda
esatta e': *"quando il DAX apre la sessione cash SOPRA la chiusura cash
precedente di almeno X%, i primi 15 minuti scendono?"* — **e' la stessa misura
del 06/09 sul Nasdaq, con il segno girato e il simbolo cambiato**, sullo
storico che abbiamo gia'. **Costa zero righe di EA nuovo** (lo strumento
`misura_gapcash_nasdaq_2026-09-06.py` esiste gia').
🔴 **Non lo propongo come candidato — non e' materiale esterno e il mio mandato
e' portare EA di fuori.** Lo scrivo come **la cosa piu' economica che questa
caccia sa indicare** per il buco che il mandato dichiara.

---

## 7. 🕳️ COSA NON HO POTUTO VEDERE — il buco dichiarato

| non visto | perche' | conseguenza |
|---|---|---|
| **GitHub, intero** | **403 su UI, API e `raw`**; lo status del proxy lo classifica come **policy di egress**, non quota; `gh` non installato | 🔴 **Un'intera fonte del §3 non battuta, per la 4a volta.** ⚠️ E' un **403, non il 429 del 06/09**: non e' "riprova fra un'ora", e' un muro. Va portato a Claudio come problema di canale |
| **SSRN, Forex Factory, MDPI** | 403 / EGRESS_BLOCKED | i numeri sul gap del DAX (§6.2) restano **non verificati sulla pagina** |
| **`TrueCostReport` nel sorgente** | non l'ho scaricato: e' un attrezzo, non un candidato | va letto prima di girarlo (§3) |
| **profondita' a tick di XAUUSD** | **mai misurata** (cartella `misura_tick/` ha solo i 3 indici) | 🔴 **nessun verdetto di merito sull'oro e' possibile oggi**, per nessun candidato |
| **spread dell'oro alle 23:00-01:00 server** | non misurato in casa | il cancello di costo di P1 (§2.2) resta **aperto** |
| **l'esistenza e l'ora di una pausa BCM su XAUUSD** | non misurabile da qui | 🔴 **`InpEntryHour` non e' scrivibile oggi** |

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Sul NOSTRO oro e sul NOSTRO broker, l'ora della riapertura CME esiste come
> ora distinta — e il rendimento delle 2 ore successive e' diverso da zero
> DOPO aver pagato lo spread di QUELLE ore, o l'effetto vive dentro il costo
> come e' gia' successo al lead-lag BOND→ORO il 06/09?"**

Ed e' **una domanda in due tempi**, perche' il primo tempo puo' cancellare il
secondo:

| passo | cosa misura | senza il quale... |
|---|---|---|
| **PASSO 0** (sonda) | la profondita' a tick di XAUUSD · l'ora vera della pausa BCM · **lo spread mediano ora per ora** | ...`@DAQUANDO` e `InpEntryHour` sono **inventati**, e il round misura un'altra strategia |
| **PASSO 1** (griglia stretta) | il segno del rendimento a 2 ore all'ora della riapertura, contro **le altre 23 ore come controllo** | ...non si distingue un edge da una deriva generale dell'oro |

Spec congelata: **`backtest_pipeline/prove/SESSIONREOPEN_ORO_BOZZA.txt`**.

---

## 9. 📊 IL CONTO ONESTO DELLA BATTUTA

| | numero |
|---|---:|
| canali passati al controllo positivo | **9** (5 vivi, 4 murati) |
| titoli Code Base MQL5 censiti (8 pagine) | **320** |
| articoli MQL5 censiti | **40** |
| interrogazioni TradingView / script visti | **19** / ~140 |
| interrogazioni all'API arXiv | **4** |
| ricerche testuali (con controllo positivo) | **2** |
| **oggetti arrivati al SORGENTE LETTO** | **4** (1 `.mq5` Code Base, 1 `.mq5` da articolo, 3 Pine — di cui 1 fuori conteggio perche' era un `study` da 10 righe) |
| **PROMOSSI "PROVA SUBITO"** | **1** |
| **IN CODA** | **1** |
| **candidati per il DAX SHORT o il NASDAQ LONG in apertura** | 🔴 **0 esterni** (1 meccanismo in coda, da riscrivere) |
| EA nostri toccati | **0** |

---

_Cacciatore di strategie · 08/09/2026 · branch `lavoro`._
_Attribuzioni: `SessionReopenEA` — GianlucaGangemi, MQL5 Code Base 77060._
_`lwOopsPatternExpert` — Chacha Ian Maroa / MetaQuotes Ltd, articolo 21741:
**letto, non copiato**, per divieto esplicito sulla pagina._

---

# 🔴 ERRATA — 10/09/2026: **lo "spread oro MISURATO in casa 0,24 $" di r.208/390 NON ESISTE**

Cercato in tutto il repo il 10/09: **quel numero non ha nessuna fonte.** Non e'
stato misurato da nessuna sonda, non sta in nessun CSV, non e' in nessun referto.
Da qui e' passato in altri dossier, portandosi dietro **due pavimenti di costo
sbagliati** (DI LAVORO 9,6 $ e DURO 3,2 $).

**I numeri veri, ognuno con la sua riga:**
- **spread 0,16 $** — `risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`,
  riga `XAUUSD`, colonna `SpreadPt` = **16 punti**. Verificata: nello stesso
  istante NASUSD **1,80** e U30USD **2,00**, contro le mediane a tick di
  1,6-1,8 e 1,9-2,0. Due su due.
- seconda lettura **0,22 $** — `R114_CORSA_20260827/REFERTO_R114.txt`.
- **commissione 0,0403 $** (3,4858 EUR/lotto, giro completo) —
  `data/statements/trades_auto.csv`, 520 righe XAUUSD. 🚨 **Sull'oro esiste e
  sugli indici e' ZERO**: nessun conto di casa la teneva.
- **COSTO PIENO: 0,2003 $ = 20,03 USD/lotto.**

**Pavimenti corretti: DI LAVORO 8,01 $ · DURO 2,67 $.**

🔴 E lo spread **nella finestra 14:30-14:41 server resta [NON MISURATO]**: le due
letture stanno una 3 ore dopo e una 6 ore prima.

> **Un numero senza riga di provenienza non e' un numero misurato: e' una voce.**
> Gemella del "DD 42,9% fantasma" di `HANDOFF.md`, ritirato il 09/09.
