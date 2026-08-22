# 🔬 GOLDEDGE SPARK — il quarto EA esterno, guardato fino in fondo

_Scritto il **22/08/2026**. Tutte le pagine citate sono state **aperte
davvero** in questa sessione, e la data di lettura e' **22/08/2026** salvo
diversa indicazione. Ogni numero che viene da fuori e' etichettato
**[DICHIARATO DAL VENDITORE, NON MISURATO DA NOI]**; i numeri presi dalle
statistiche automatiche di MQL5 sono etichettati **[MQL5, dato di piattaforma]**._

**Mandato di Claudio (22/08)**: quarto EA esterno da indagare, *"GoldEdge
Spark 5"*, autore **Chi Sang Lai**, categoria Experts su MQL5 Market. Segnalato
come EA **sull'oro** e come EA che **"cita FTMO"**. Stesso rigore del dossier
`DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md`.

---

> ## 🎯 LA RIGA CHE CONTA
> **Ho aperto 24 pagine su 4 fonti. Tre delle premesse del mandato vanno
> corrette: non e' un EA sull'oro (i simboli ammessi sono USDCHF, USDJPY,
> CADJPY, NZDJPY — XAUUSD non c'e'), "5" non e' una versione (e' il voto in
> stelle; la versione e' la 3.4), e "cita FTMO" e' molto piu' di una citazione:
> tutto il prodotto e' venduto come EA da prop.
> **Ma il fatto che chiude il discorso e' un altro, ed e' scritto da MQL5, non
> da me: il signal LIVE che il venditore linka DALLA SUA STESSA PAGINA
> PRODOTTO ha un drawdown massimo dell'80% sull'equity, previsione annua
> −100%, e porta l'avvertimento automatico della piattaforma
> _"High current drawdown in 31% indicates the absence of risk limitation"_.
> Non e' un'opinione mia sulla griglia: e' MQL5 che certifica l'assenza di
> limitazione del rischio su un conto del venditore.**
>
> 🔴 **VERDETTO: SI SCARTA QUI. Non si scarica, non si prova nel tester, non
> si spende un'ora.** Motivazione formale nel §11.

---

## 0. ✅ CONTROLLO POSITIVO DELLE FONTI (fatto PRIMA di cercare)

| fonte | bersaglio noto | esito |
|---|---|---|
| MQL5 Market (curl) | pagina 111837 (Master Nasdaq, gia' letta il 22/08) deve tornare l'HTML pieno | ✅ **200, 293 kB** — canale sano |
| MQL5 profilo utente / seller | devono elencare prodotti, signals, reputazione | ✅ 200, contenuti veri |
| MQL5 tab `/comments/pageN` e `/updates` | devono restituire thread e changelog | ✅ **9 pagine di commenti + changelog, tutti 200** |
| MQL5 dati strutturati JSON-LD | devono contenere autore+voto di ogni recensione | ✅ **20 recensioni con voto**, emesse dal server MQL5 |
| MQL5 Signals | statistiche complete dei 4 signal dell'autore | ✅ 200, statistiche integrali |
| **goldedgeea.com** (sito ufficiale) | docs, setfile, "Prop Firm Strategy Guide" | ❌ **BLOCCATO** dal proxy (`EGRESS_BLOCKED`) |
| **trader.ftmo.com** (le 3 metrix linkate dalla scheda) | i tre "Live Signal FTMO" della scheda | ❌ **403 dal proxy** (CONNECT tunnel failed) |
| Google / Forex Peace Army / Forex Factory / Reddit | tracce indipendenti di "GoldEdge" | ✅ risponde, ma **zero risultati pertinenti** (§9) |
| tab **Reviews** del prodotto | testo integrale delle 22 recensioni | 🟠 **solo parziale** — la tab e' caricata in JavaScript (§8) |

🔴 **Cosa NON ho potuto vedere, e va dichiarato**: il manuale e i setfile sul
sito del venditore, e le tre pagine metrix FTMO che la scheda usa come prova.
**Non le ho viste, quindi non pesano ne' a favore ne' contro.** Fortunatamente
i signal MQL5 dello stesso autore sono pubblici e coprono lo stesso terreno
con dati di piattaforma, che valgono di piu' (§6).

---

## 1. 🪪 IDENTIFICAZIONE — tre correzioni al mandato, tutte verificate

### 1.1 Il prodotto giusto
**[VERIFICATO 22/08]**

| campo | valore |
|---|---|
| **nome esatto** | **GoldEdge Spark** (non "Spark 5") |
| **URL** | https://www.mql5.com/en/market/product/178221 |
| **piattaforma** | 🟢 **MT5** (siamo su MT5 — nessun problema di piattaforma) |
| **categoria** | Experts |
| **autore** | **Chi Sang Lai** (handle `vincentlai`), Hong Kong |
| **prezzo** | ✅ **FREE** — Claudio aveva ragione, e' gratuito |
| **pubblicato** | **27 maggio 2026** (→ **87 giorni di eta'**) |
| **versione attuale** | **3.4**, aggiornata **16 agosto 2026** |
| **recensioni / commenti** | tab "Reviews (22)" · tab "Comments (168)" |

### 1.2 🔴 CORREZIONE 1: **"Spark 5" non e' una versione — e' il voto**
Nella pagina, subito sotto il titolo, compare `GoldEdge Spark` e poi un `5`.
Quel `5` e' **il rating in stelle**, non la versione ne' "MT5". Prova nei dati
strutturati emessi da MQL5:
```json
"aggregateRating":{"@type":"AggregateRating","ratingValue":5,"ratingCount":5}
```
E la pagina venditore lo scrive esplicitamente: `GoldEdge Spark — 5 (5)`.
**La versione e' la 3.4.** Non esiste nessun "Spark 5".

### 1.3 🔴 CORREZIONE 2 (la piu' importante): **NON e' un EA sull'oro**
Il nome inganna. La scheda, testualmente:

> *"Recommended symbols: **USDCHF, USDJPY, CADJPY, NZDJPY**"*
> *"Timeframe: **H4 is recommended for stability**"*

E il venditore lo ribadisce due volte nei commenti, correggendo utenti che
provavano altro:
- **#63 (14/06)**: *"For GoldEdge Spark, I do **not** recommend using other
  symbols such as EUR/USD. Spark is optimized and tested specifically for the
  4 main symbols: USDCHF, CADJPY, NZDJPY, and USDJPY."*
- **#85 (16/06)**: *"GoldEdge Spark (the free version) does **NOT** support
  EURCHF, Spark version is USDCHF."*

> 🎯 **XAUUSD non compare da nessuna parte fra i simboli supportati di Spark.**
> Il "Gold" del nome e' **marchio commerciale**, non mercato. Quindi il
> confronto che il mandato immaginava — contro `LARRY ORO`, `MaxMinNotte oro`,
> `EMA200_Ottimizzato`, `SupertrendReversal_Ottimizzato` — **non esiste**:
> questo EA non compete con nessuna delle nostre sedie sull'oro.
> ⚠️ L'oro compare **una volta sola** in tutta l'indagine, e in un posto
> pessimo: `XAUUSD+` e' fra i 14 simboli del signal live del venditore che sta
> a −80% di drawdown (§6.2).

### 1.4 Il resto delle raccomandazioni della scheda
**[VERIFICATO, testo della scheda]**

| voce | valore dichiarato | 🚩 |
|---|---|---|
| deposito minimo | **1.000 USD con leva 1:1000** | 🔴 su FTMO la leva e' **1:30** (§6.1) |
| broker | *"ICMarkets, Vantage, Ultima or any ECN/RAW/low-spread broker, **including prop firms such as FTMO**"* | |
| tipo conto | **Hedging raccomandato** | apre buy e sell insieme sullo stesso simbolo |
| VPS | *"strongly recommended for 24/7 stable operation"* | |
| **guida al backtest** | 🔴 *"Use around **1,5 years** of backtest data"* | vedi §4.3 |

---

## 2. 🏛️ LA CITAZIONE FTMO — testo esatto, e in che senso

Il mandato chiede: **e' un endorsement, un preset dedicato, o solo un nome fra
tanti?** Risposta: **e' molto piu' di una citazione. FTMO e' l'argomento di
vendita centrale del prodotto.** Ci sono **quattro** punti distinti.

### 2.1 Il paragrafo dedicato nella scheda (verbatim)
> **"Built for Prop Firm Challenges**
> GoldEdge Spark is designed for disciplined, rules-based trading environments
> such as **FTMO-style challenges** — focusing on stability, risk control, and
> consistent execution.
> **Live Signal #1 FTMO Challenge:** CLICK HERE
> **Live Signal #2 FTMO Challenge:** CLICK HERE
> **Live Signal #3 FTMO Challenge:** CLICK HERE
> **Live Signal #4 Vantage:** https://www.mql5.com/en/signals/2378218"

I tre "CLICK HERE" puntano a **pagine condivise di FTMO**
(`trader.ftmo.com/live-metrix/511355585/...`, `.../541373187/...`,
`trader.ftmo.com/metrix/531292418/...`) — 🔴 **bloccate dal proxy (403), non
le ho potute leggere**.

### 2.2 FTMO come broker raccomandato (verbatim)
> *"Brokers: ICMarkets, Vantage, Ultima or any ECN / RAW / low-spread broker,
> **including prop firms such as FTMO**"*

### 2.3 FTMO nel profilo venditore (verbatim)
> *"🔥 **Built for Prop Firm Challenge Style Trading** — GoldEdge is designed
> for structured trading environments such as **FTMO-style challenges**, where
> stability and capital preservation are just as important as profit
> generation."*

E il **fratello a pagamento** e' venduto cosi': *"GoldEdge Matrix — Premium
**Prop-Firm Edition**"*, **899 USD**.

### 2.4 🔴 E POI C'E' IL COMMENTO #69 — il pezzo che nessuna scheda dice
**[VERIFICATO 22/08, verbatim, commento #69 del 15/06/2026]**

Domanda del cliente **Mihai Emil (#68)**:
> *"By using the common/shared EA, do we run any risk of FTMO closing or
> restricting our accounts?"*

Risposta di **Chi Sang Lai**, per intero nelle parti che contano:
> *"Yes, FTMO has strict rules against **"Group Trading"** and copy trading.
> If many traders use the exact same EA with the exact same default settings,
> FTMO's system might flag the accounts because the trade entries and exits
> will be 100% identical.*
> *Please note that for **GoldEdge Spark (the free version), the parameters
> are fixed and cannot be modified**. Therefore, **using Spark on a live FTMO
> funded account carries a risk of having identical trades with other Spark
> users**.*
> *To avoid this risk completely and trade safely on FTMO, you must make your
> trading setup unique. **This is why we have GoldEdge Matrix.** [...] By
> slightly adjusting these settings, your entry distances, profit targets, and
> volatility filters will be different from everyone else. **The core
> profitable logic remains exactly the same**, but your specific trade timings
> and price levels will become completely unique to your account.*
> *This is the best and safest way to pass and manage prop firm accounts
> without violating any of their rules!"*

> 🚨 **Leggiamolo per quello che e'.** Il venditore:
> 1. **ammette che il proprio prodotto gratuito puo' far scattare la regola
>    anti-group-trading di FTMO** — cioe' puo' far chiudere un conto pagato;
> 2. **vende la versione da 899 USD come rimedio**;
> 3. e il rimedio non e' "rispettare la regola", e' **"cambiare abbastanza i
>    parametri da non sembrare uguale agli altri"**, dichiarando nella stessa
>    frase che *"the core profitable logic remains exactly the same"*.
>
> 🔴 Questo tocca direttamente la **regola D3 di casa** (`METRO_PROP.md`:
> *"niente acquisti prima delle risposte per iscritto dal supporto"*). Un
> prodotto il cui autore consiglia di **mascherare** la somiglianza invece di
> chiedere alla prop se e' consentito **non entra nemmeno in discussione** su
> un conto pagato.

### 2.5 Confronto col "FTMO" di **Master Nasdaq FTMO** — sono OPPOSTI
| | **Master Nasdaq FTMO** (Warsito) | **GoldEdge Spark** (Lai) |
|---|---|---|
| cosa dice di FTMO | *"Propfirm & FTMO **no longer supported**, I am sorry about that"* | *"**Built for Prop Firm Challenges** ... FTMO-style challenges"* |
| direzione | 🟠 **ritira** il supporto prop | 🔴 **ci costruisce sopra tutta la vendita** |
| documentato? | ❌ **no** — mai nel changelog, mai nei 17 commenti, non databile | ✅ **si'** — 4 punti nella scheda + 3 signal FTMO pubblici |
| segnale per noi | l'autore **si tira indietro** dalla promessa prop | l'autore **fa la promessa piu' grande possibile** — quindi si controlla, e si trova §6 |

> 📌 **Sono due situazioni diverse, e per il nostro metro il caso GoldEdge e'
> il PEGGIORE dei due.** Warsito toglie una promessa che non riusciva a
> mantenere: e' un fatto brutto per il prodotto ma **onesto**. Lai fa la
> promessa piu' forte del mercato — *"Built for Prop Firm Challenges"* — e
> nella stessa pagina linka un signal che la piattaforma ha marchiato come
> **privo di limitazione del rischio**.

---

## 3. ⚙️ IL MECCANISMO — griglia dichiarata, con le parole dell'autore

Il criterio di casa (`CANCELLO_ACQUISTI_EA.md`, **gradino 2**) e':
> *"recovery/griglia/martingala **dichiarati o inferiti** = SCARTO anche se
> costasse 10 euro"*

Qui non c'e' niente da inferire. **Il venditore usa lui stesso, per iscritto,
tutte e tre le parole della lista.**

### 3.1 Dalla scheda del prodotto (verbatim)
> *"GoldEdge Spark is a next-generation MT5 Expert Advisor built around the ATR
> Border system. It uses **structured grid-style entries and adaptive position
> scaling**, guided by ATR Ratio, Border levels, spread control, and
> directional logic."*

> *"**Hedging Close** — When both buy and sell positions exist, GoldEdge Spark
> can close them together around breakeven or target net profit"*
> *"**Smart Lot Scaling** — Position sizing adjusts based on account balance,
> risk parameters, and market structure."*

E il resto della meccanica dichiarata:
- **4-Layer ATR Border** — quattro bande dinamiche che si allargano con la volatilita';
- **Bi-Level Protection** — *"Above the Border Midline → SELL Only / Below the Border Midline → BUY Only"*;
- **One Order Per Bar** — un ordine per candela H4;
- **Ranging Zone Specialist** — *"designed to capture opportunities inside consolidation zones"*;
- **Symbol Cut Loss** — l'unico vero freno, per simbolo.

### 3.2 🔴 Dai commenti: la parola "averaging", scritta da lui
- **#161 (05/08)**: *"Smoothly executed a 3-order **hedging/averaging**
  strategy during the pullback, closing all Sell positions in profit!"*
- **#33 (09/06)**: 🔴 *"**Instead of relying on fixed Stop Losses that might get
  hunted**, GoldEdge uses a smart equity target to **close the entire basket
  in profit**."*
- **#56 (12/06)**, la meccanica esatta dell'uscita: *"The EA pairs **multiple
  most profitable orders** with **ONE losing order**. Once their combined net
  profit reaches the set target, it closes them simultaneously."*
- **#36 (09/06)**, dove si colloca da solo: *"One of the biggest flaws of
  **traditional grid systems** is opening trades during a steep freefall.
  This GBPNZD chart perfectly demonstrates how GoldEdge Matrix solves this issue."*
- **#38 (10/06)**: *"Most **grid or martingale EAs** blow up Prop Firm accounts
  because they cannot handle the correlation risk during strong trending markets."*
- **#14 (03/06)**, il comportamento visto: *"Over the past few days, NZDJPY
  moved higher [...] GoldEdge opened one **Sell** order on **each
  candlestick**."*

> ### 🎯 Tradotto nella lingua di casa
> Il prezzo sale, l'EA vende **una volta per candela H4**, accumulando
> perdenti. Quando arriva il ritracciamento, chiude **N vincenti + 1 perdente**
> a target netto positivo. **Le perdite non vengono chiuse: vengono
> parcheggiate aperte e smaltite una alla volta.** Ecco perche' la curva del
> BILANCIO e' liscia e la curva dell'EQUITY no — e ne abbiamo la prova
> numerica nel §6.
>
> Questo e' **esattamente** cio' che il gradino 2 del cancello esclude, e qui
> non l'abbiamo dedotto noi: **e' scritto nella prima riga della scheda di
> vendita** ("grid-style entries and adaptive position scaling").

### 3.3 Cosa NON c'e' — la lista dei freni mancanti
**[VERIFICATO — assenti dalla scheda e dai 168 commenti]**

| freno | c'e'? | prova |
|---|---|---|
| **stop loss fisso per trade** | 🔴 **di fatto no** | #33 *"instead of relying on fixed Stop Losses"*; #53 un cliente: *"the TP & SL are so far, is it correct?"* → #54 *"Yes, the TP and SL distances are correct"* |
| **filtro news** | 🔴 **NO, confermato** | §3.4 |
| cap perdita giornaliera | ❌ | mai nominato |
| stop dopo N perdite di fila | ❌ | mai nominato |
| max trade al giorno | 🟠 solo *"one order per bar"* (H4 → **max 6/giorno per simbolo**) | scheda |
| flat serale / venerdi' / no-overnight | ❌ | **zero occorrenze** di GMT/session/Friday/weekend in 2.715 righe di commenti |
| controllo del lotto | 🔴 **impossibile: input assente** | §3.5 |
| max esposizione simultanea | ❌ | il numero di posizioni aperte lo decide la griglia |
| **unico freno reale** | 🟡 **Symbol Cut Loss** (per simbolo) | e va **ottimizzato dall'utente**, vedi #177 |

### 3.4 🔴 Il filtro news: chiesto, ignorato 27 giorni, poi negato
**[VERIFICATO 22/08, verbatim]**
- **26/06/2026, #119 — Ignas Ronkaitis**: *"Great EA so far! I have one
  question: is there an option to disable trading during high-impact news
  events? If not, are you planning to add this feature in a future update?"*
- **23/07/2026, #120 — Chi Sang Lai** (**27 giorni dopo**): *"GoldEdge Spark /
  Matrix **does not use a calendar-based news filter**. However, the EA is
  designed on the H4 timeframe and includes ATR Ratio volatility filtering
  [...] Also, it only opens one trade per H4 candle, so it is not a
  high-frequency or aggressive news-period strategy."*

📌 In quei 27 giorni il venditore ha pubblicato **decine** di post
promozionali nello stesso thread. **L'unica domanda scomoda del thread e'
l'unica che ha aspettato quattro settimane.**
_(Confronto: l'autore di Artemis rispose in 8 minuti — sbagliando — e promise
il filtro "entro pochi giorni", 27 giorni dopo non c'era. Due venditori
diversi, stesso buco: **nessuno dei quattro EA esterni censiti ha un filtro
news da calendario.**)_

### 3.5 🔴 Su Spark il lotto NON si puo' cambiare
**[VERIFICATO, verbatim]**
- **#159 (05/08) — Md Atiqul Islam**: *"i don't see any input that allow me
  change lot size. how to do it?"*
- **#160 — Chi Sang Lai**: *"the initial lot size in the Spark version is
  **fixed at 0.01 and cannot be changed**. If you are already familiar with
  the strategy and want full control to modify all parameters, including using
  a larger lot size, please check out our full version: **GoldEdge Matrix**."*

> 🎯 **Ecco l'imbuto commerciale, in chiaro.** Su Spark il lotto e' 0,01 fisso:
> su un conto da 100k e' rumore, e la "sicurezza" della versione gratuita e'
> tutta li'. Per avere una taglia sensata **devi comprare Matrix a 899 USD** —
> ed e' esattamente con Matrix a taglia vera che si produce il signal del §6.2.
> **La versione gratis e' innocua perche' e' inerte, non perche' sia sicura.**

---

## 4. 🧨 IL CASO DEL LOTTO 0,01 → 0,16 — bug documentato, e "correzione" ritirata

E' la vicenda piu' istruttiva del thread. Ricostruita **interamente** dai
commenti e dal changelog, **[VERIFICATO 22/08]**.

### 4.1 I fatti, in ordine
| data | chi | cosa |
|---|---|---|
| 03/08 06:08 | **Mihai Emil** (cliente) | *"Spark opens **large positions of 0.16 lots** on CAD/JPY during this volatile move—is that okay?"* |
| 03/08 07:47 | Lai | *"GoldEdge Spark will only open an **initial lot of 0.01**."* |
| 03/08 09:19 | Mihai | 🔴 la sequenza esatta: *"**0.01 - 0.01 - 0.02 - 0.02 × 7 (long and short) then dumping price - 0.04 - 0.12 - 0.16**"* |
| 03/08 09:05 | Lai | 🔴 *"It is **highly unreasonable and abnormal** for an initial lot size of 0.01 to eventually scale up to 0.16. This should not happen under **the EA's normal lot multiplier logic**."* |
| 03/08 09:19 | Mihai | 🔴 *"There's not much I can do with the **drawdown being at −800 USD**, so I just have to **let it run**. **The same thing happened on my live account** on CADJPY, where it started opening positions from 0.03 lots."* |
| 03/08 22:10 | Lai | *"This issue is related to the older version's Initial Lot fallback logic [...] **Spark 3.1 has fixed this issue by using `InferInitialLotFromExistingPositions()`** to infer the original Initial Lot from existing positions"* |
| **16/08** | changelog **v3.4** | 🔴 *"**Removed** Basket / AutoLot GV. **Removed InitialLot inference.** Fixed InitialLot = BaseLot."* |

### 4.2 Le quattro cose che questa storia dimostra
1. 🔴 **Esiste un moltiplicatore di lotto.** Parole dell'autore: *"the EA's
   normal **lot multiplier** logic"*. Se i lotti fossero fissi, una base
   sbagliata avrebbe dato 0,04 — non 0,16. La **scala** 0,04 → 0,12 → 0,16 e'
   la scala del prodotto, funzionante; l'unica cosa rotta era la base.
2. 🔴 **La "correzione" del 3.1 e' stata RIMOSSA nel 3.4, 13 giorni dopo.**
   Il 03/08 Lai dichiara il problema *"already resolved in Spark 3.1"* grazie
   a `InferInitialLotFromExistingPositions()`; il 16/08 il changelog scrive
   *"Removed InitialLot inference. **Fixed InitialLot = BaseLot**"*. Tradotto:
   il rimedio non reggeva, e alla fine hanno **inchiodato** il lotto iniziale.
   ⚠️ **E' una smentita dell'autore a se stesso in 13 giorni** — lo stesso
   schema visto su Artemis (dove ci mise 7 minuti).
3. 🔴 **Il cliente era impotente**: nessun input per intervenire (§3.5), −800 USD
   di flottante, *"I just have to let it run"*. **Su una challenge non esiste
   il "let it run": esiste il muro.**
4. 🟠 Il changelog del 3.4 nomina anche `Basket` e `AutoLot` — **due parole che
   la scheda di vendita non usa mai.** La scheda dice "Smart Lot Scaling"; il
   changelog dice `AutoLot`.

### 4.3 🔴 E il consiglio di backtest e' il contrario del nostro Emendamento
La scheda: *"Use around **1,5 years** of backtest data."*
E le due modalita' sono ottimizzate cosi': **Current Market Mode** dal
**2025/01/01**, **Long-Term Stable Mode** dal **2024/01/01**.

> 🎯 **Ti dicono di collaudare esattamente sulla stessa finestra su cui hanno
> ottimizzato.** In casa nostra questo ha un nome (`CLAUDE.md`, Emendamento
> della Finestra, regola **C**: *"La PROVA DI REGIME batte la storia
> contigua"*) e una misura: un motore validato su 1,5 anni di un solo regime
> **non e' misurabile**, ne' per il merito ne' per il rischio. Per una griglia
> — la cui rovina e' il trend lungo e unidirezionale — collaudare su una
> finestra scelta dal venditore e' **il singolo test meno informativo
> possibile**.

---

## 5. 📉 I NUMERI DICHIARATI DAL VENDITORE — e perche' non tornano

**[TUTTI DICHIARATI DAL VENDITORE, NON MISURATI DA NOI]**

### 5.1 Il drawdown in dollari, dalla bocca dell'autore
Commento **#89 (17/06)** — il principio di dimensionamento del prodotto:
> *"**The core design principle of GoldEdge is that your account balance must
> always be higher than the combined Max Drawdown of all the pairs you are
> running.** [...] USDCHF Max DD is around $760. CADJPY / NZDJPY Max DD is
> around 450–550. Combined Max DD = around 1,200 to 1,300."*

E il cliente Mihai (#81, 16/06) misura da solo, 12 mesi su conto da **500 USD**:
| simbolo | Equity DD | P&L |
|---|---:|---:|
| NZDJPY | **468 USD** | 1.072 |
| CADJPY | **550 USD** | 1.224 |
| USDJPY | **467 USD** | 1.239 |
| USDCHF (#84/#89) | **~760–900 USD** | 1.134 |

> 🔴 **Il drawdown misurato e' il 93–100% del capitale su un conto da 500 USD,
> e il 45–90% su un conto da 1.000 USD** — che e' **il deposito minimo
> raccomandato dalla scheda**. Il venditore stesso lo ammette in #82: *"In your
> $500 tests, the drawdowns [...] are **almost 100% of the balance**."*
>
> **Il rischio non e' controllato dall'EA: e' controllato dalla scelta di
> mettere lotti minuscoli su un conto grande.** Che e' un'altra cosa. Su 100k
> con lotto 0,01 quei 1.300 USD diventano 1,3% e sembrano meravigliosi; ma la
> quantita' che l'EA rischia **non e' una percentuale del conto — e' un numero
> in dollari fissato dalla profondita' della griglia**, e la profondita' della
> griglia non ha un tetto misurato.

### 5.2 I risultati live dichiarati (e la contraddizione interna)
Commento **#93 (17/06)**, *"Live Account 1"*: Gen +0,17% · Feb **+14,12%** ·
Mar **+16,54%** · Apr +13,68% · Mag **+32,48%** · Giu **+22,24%**.
*"Live Account 2"*: Feb +7,43% · Mar +15,77% · Apr **−1,34%** · Mag **+34,02%** ·
Giu +21,50%.

> ⚠️ **Un sistema non puo' essere insieme "+32% al mese" e "1,08% di
> drawdown".** Sono lo stesso motore a due taglie diverse; e quando si va a
> vedere il conto dove la taglia e' vera (§6.2), il drawdown e' **80%**.
> 📌 In piu': **+32%/mese violerebbe la regola di consistenza di molte prop**
> anche se il conto sopravvivesse.

### 5.3 Il "Gain on DD" che cambia valore
- #24 (05/06): *"Gain on DD Ratio: **1.5**"* — presentato come eccellente
- #60 (13/06): *"an **excellent** 'Gain on DD' ratio of **0.2 to 0.4**"*
- #131 (02/08): *"Gain on DD monthly: **0.28**"*

Sono numeri che differiscono di **5 volte**, tutti etichettati "excellent",
senza mai definire la formula. **Per il metro di casa valgono zero.**

---

## 6. 🔎 I SIGNAL MQL5 — la parte che non e' opinabile

Qui non c'e' marketing: sono statistiche calcolate da MetaQuotes sui conti
reali del venditore. **[MQL5, dato di piattaforma, letto 22/08]**

### 6.1 I tre signal "vetrina" — belli, e non sono Spark
| | **Prop Firm 100K Signal1** | **Prop Firm 100K Signal2** | **US30 Index 50K Challenge** |
|---|---|---|---|
| id | [2375791](https://www.mql5.com/en/signals/2375791) | [2385352](https://www.mql5.com/en/signals/2385352) | [2383404](https://www.mql5.com/en/signals/2383404) |
| server / leva | FTMO-Server3 · **1:30** | FTMO-Server · **1:30** | FTMO-Server4 · **1:30** |
| avviato | 30/05/2026 | 06/08/2026 | 23/07/2026 |
| eta' | **16 settimane** | 3 settimane | 5 settimane |
| **crescita** | **+4,29%** | +0,84% | **+0,28%** |
| DD max (bilancio) | 906,32 USD (**0,88%**) | ~1% | ~1% |
| DD relativo (equity) | **2,31%** | n/d | n/d |
| profit factor | 2,29 | 5,09 | 1,19 |
| Sharpe | **0,26** | n/d | n/d |
| trade | 878 (**83/settimana**) | 132 | 87 |
| tempo medio in posizione | **5 giorni** | 2 giorni | 4 giorni |
| **subscribers** | **0** | **0** | **0** |
| avviso automatico MQL5 | — | *"newly opened account, results may be of random nature"* | 🟠 *"**80% of growth achieved within 1 days.** This comprises 3.13% of days out of 32 days"* |

**Tre osservazioni che contano:**
1. 🔴 **Signal1 NON gira con Spark.** La distribuzione simboli e': EURGBP,
   EURUSD, CADJPY, NZDCHF, FRA40.cash, US30.cash, AUDCAD, NZDCAD, NZDJPY,
   GBPUSD, AUDNZD — **11 simboli**, di cui 8 che **Spark non supporta**.
   Quello e' **Matrix** (899 USD). **Nessuno dei 4 signal e' un signal di
   Spark.** La prova FTMO in vetrina non e' la prova del prodotto segnalato.
2. 🟠 **16 settimane per +4,29%.** Una challenge FTMO chiede **+10%** (fase 1)
   o 8%/5% (2 step). Dopo quasi 4 mesi il conto piu' vecchio non ci e'
   arrivato: **la challenge in vetrina non risulta passata**.
3. 🔴 **La leva sui conti FTMO e' 1:30.** Ma la scheda raccomanda **1:1000** e
   il venditore in #66 scrive *"I strongly recommend using **1:1000 or more**
   [...] Higher leverage gives you a much better **margin buffer**, which is
   very important for handling potential drawdowns"*. 🚨 **Il cuscinetto di
   margine su cui poggia la sopravvivenza della griglia NON ESISTE su una
   prop.** E' una contraddizione strutturale fra il prodotto e il caso d'uso
   che lo pubblicizza.

### 6.2 🚨 IL QUARTO SIGNAL — quello linkato DALLA SCHEDA DI SPARK
**"GoldEdge MT5 Vantage Live 2"** — [signal 2378218](https://www.mql5.com/en/signals/2378218),
**lo stesso URL scritto nella scheda del prodotto** come *"Live Signal #4 Vantage"*.

| voce | valore | |
|---|---:|---|
| broker / leva | VantageMarkets-Live 3 · **1:2000** | |
| eta' | **45 settimane** (il piu' lungo dei quattro) | |
| **Balance** | **3.016,26 USD** | |
| **Equity** | **1.873,10 USD** | 🔴 **flottante −1.143,16 = −37,9% del bilancio, ADESSO** |
| **DD massimo (bilancio)** | **4.953,15 USD = 47,88%** | 🔴 |
| **DD relativo per EQUITY** | 🔴🔴 **79,98% (3.893,08 USD)** | |
| **Monthly growth** | 🔴 **−59,57%** | |
| **Annual Forecast** | 🔴 **−100,00%** | |
| Profit Factor | **1,17** | |
| Sharpe Ratio | **0,06** | |
| Recovery Factor | **0,45** | |
| perdite consecutive max | **38** | |
| perdita consecutiva massima | **−2.868,22 USD (26 trade)** | su un conto da ~3.000 |
| trade | 1.861 (**96/settimana**) · in posizione **8 giorni** medi | |
| peggior simbolo | **GBPCHF+ = −4.100 USD** | da solo, oltre il bilancio del conto |
| subscribers | **0** | |

**E il verdetto automatico della piattaforma, verbatim:**
> 🔴 **"Subscription not permitted — Current drawdown is dangerous for
> subscribers. Subscription will be allowed once drawdown improves."**
> 🔴 **"Subscription to signals with a leverage exceeding 1:500 is not permitted"**

**Il registro degli avvisi MQL5 su quel signal, verbatim:**
| data | avviso |
|---|---|
| **2026.08.21 02:37** | 🔴 *"**High current drawdown in 31% indicates the absence of risk limitation**"* |
| 2026.08.20 07:15 | *"Removed warning: High current drawdown indicates the absence of risk limitation"* |
| 2026.07.24 18:41 | *"**80% of growth achieved within 12 days.** This comprises 4.26% of days out of 282 days of the signal's entire lifetime"* |
| **2026.07.06 08:30** | 🔴 *"High current drawdown in 30% indicates the absence of risk limitation"* |

> ### 🎯 QUESTA E' LA RIGA CHE CHIUDE IL DOSSIER
> **Non sono io a dire che questo motore non limita il rischio. E' MQL5, con
> una frase automatica, due volte (6 luglio e 21 agosto), su un conto del
> venditore. E quel signal e' linkato dalla scheda di vendita di GoldEdge
> Spark come prova a favore.**
>
> La differenza fra il signal FTMO (DD 0,88%) e questo (DD 47,88% / equity
> 80%) **non e' il motore: e' la taglia**. Stesso EA, stessa logica; su FTMO
> con lotti minuscoli sembra un capolavoro, sul conto dove la taglia e' vera
> e' **−100% di previsione annua**. 🔴 **E' la firma della griglia: il rischio
> non e' eliminato, e' rimandato — e vive nel flottante finche' non arriva il
> trend che non ritraccia.**
>
> 📌 E si noti la data del signal: **avviato il 17/06/2026, 45 settimane di
> storia**, con `growth since 2025`. Ha attraversato piu' mesi di quelli che
> il venditore mostra nei suoi post mensili "+32%".
>
> 📌 Nota per il nostro archivio: **XAUUSD+ e' fra i 14 simboli di questo
> conto** (90 deal, +798 USD). E' **l'unico contatto fra "GoldEdge" e l'oro**
> che ho trovato in tutta l'indagine — sul conto a −80%.

### 6.3 Il quinto signal: cancellato
Il feed del profilo mostra *"Published MetaTrader 5 signal — 2026.06.17 —
**"GoldEdge MT5 Vantage Live 1" is unavailable**"*, e la scheda del prodotto
linka *"Live Signal #3"* a [2378217](https://www.mql5.com/en/signals/2378217),
che oggi **non esiste piu'** (pagina di elenco generico, 43 kB).
📌 **La scheda di vendita pubblicizza un signal che non c'e' piu'.**

---

## 7. 👤 IL VENDITORE — Chi Sang Lai (`vincentlai`)

**[VERIFICATO 22/08, profilo MQL5]**

| voce | valore |
|---|---|
| nome / paese | **Chi Sang Lai**, **Hong Kong** |
| reputazione | 4.124 |
| voto venditore | **5 (6 recensioni)** |
| **esperienza dichiarata su MQL5** | 🟠 **1 anno** |
| esperienza dichiarata nel post di lancio | *"built on more than **15 years** of trading experience"* |
| **prodotti** | **4** (Spark FREE · US30 349 USD · Matrix **899 USD** · ATR Price Border FREE) |
| versioni demo | 15 |
| **signals** | ✅ **4 pubblicati** (piu' 1 cancellato) |
| **subscribers** | 🔴 **1** in totale sul profilo; **0** su ognuno dei 4 signal |
| amici | 31 |
| canali | sito, MQL5 Channel, YouTube, Telegram, Facebook, Instagram |

### 7.1 Il confronto con gli altri tre venditori censiti
| | Gilks (Artemis) | Warsito (Master Nasdaq) | **Lai (GoldEdge)** |
|---|---|---|---|
| prodotti | 26-32 in ~3 mesi | 29 in 2 anni | **4 in 3 mesi** |
| signals | **0** | **0** | ✅ **4** |
| subscribers | 0 | 0 | **0 sui signal** |
| recensioni venditore | 1 in tutto il catalogo | 4,5 su 112 | 5 su 6 |
| esperienza dichiarata | *"no"* | 2 anni | **1 anno** (ma *"15 years"* nel marketing) |

> 🟢 **Va detto in suo favore, ed e' l'unica cosa**: **e' l'unico dei tre
> venditori che pubblica signal verificati.** Ha scelto la trasparenza dove gli
> altri due non l'hanno fatta.
> 🔴 **Ed e' proprio per questo che il suo prodotto e' quello che si scarta con
> piu' certezza**: gli altri due non li abbiamo potuti misurare, lui si' —
> **e la misura e' −80%.** La trasparenza gli fa onore e affonda il prodotto.

### 7.2 🟠 Il catalogo: due prezzi diversi per lo stesso EA
- pagina venditore MQL5 (22/08): **GoldEdge Matrix = 899,00 USD**
- blog dell'autore su MQL5 (18/06/2026, post 771707): *"**$799 Lifetime License**"*

E in piu', dal profilo: *"🎁 **LIMITED TIME OFFER: BUY ONE GET ONE FREE!**"* e
dal changelog v3.1: *"Special Launch Offer: Buy One Get One Free until
**10 August 2026**"* — offerta scaduta da 12 giorni ma **ancora scritta nel
profilo il 22/08**. 🚩 Pressione di vendita permanente: bandiera minore, ma
si annota.

---

## 8. ⭐ LE RECENSIONI — 5,0 stelle, e come si sono formate

### 8.1 Cosa dicono le fonti (e non concordano)
| fonte | numero |
|---|---|
| tab del prodotto | **"Reviews (22)"** |
| dati strutturati JSON-LD del server MQL5 | **20 recensori elencati**, `ratingCount: 5`, `ratingValue: 5` |
| pagina venditore | **"GoldEdge Spark — 5 (5)"** |

⚠️ **[INCERTO]** perche' i tre numeri differiscano. Riporto tutti e tre invece
di sceglierne uno.

### 8.2 🔴 Il venditore CHIEDE le recensioni, per iscritto, nel thread
**[VERIFICATO, verbatim]**
- **#47 (11/06)** a Mihai Emil: *"Could I ask a small favor? Since this is the
  comments section, would you mind **copying and pasting this wonderful
  feedback into the official "Reviews" tab**? That is the actual rating area,
  and **your 5-star review would mean a lot to me** and help other traders
  tremendously."*
- **#52 (12/06)** a Tonybrownssd: *"if GoldEdge is helping you out, **please
  consider leaving a rating and comment in the Reviews tab**."*
- **#42 (11/06)**, pubblico: *"(**If you love the results, a 5-star review
  would mean the world to me!** ⭐⭐⭐⭐⭐)"*

> 🎯 **Il campione delle recensioni e' SOLLECITATO, non spontaneo.** Incrociando
> la lista dei recensori col thread, almeno **8 dei 20** (Cosminrus, Ignas
> Ronkaitis, Goodlove bone, Mihai Emil, Tonybrownssd, Brendon-LMK, Jeferson Do
> Nascimento Pereira, wongmf2019) sono **le stesse persone a cui il venditore
> ha chiesto di recensire**. Per il nostro metro: **non e' un campione
> indipendente**.

### 8.3 🔴 Due anomalie nella lista dei recensori
Dalla lista emessa dal server MQL5:

1. **`vincentlaihkfpa` — 5 stelle.** L'handle e' quello del venditore
   (`vincentlai`) + `hkfpa` (Hong Kong + FPA). 🔴 **Il profilo oggi restituisce
   404: l'account non esiste piu'.**
   → **[VERIFICATO]** che una recensione a 5 stelle e' firmata da un account
   con quel nome, e che quell'account e' sparito.
   → **[INFERITO]** che appartenesse al venditore. Non l'ho potuto provare:
   l'account e' cancellato. **Lo scrivo come inferenza, non come fatto.**
2. **`javaai` — 1 stella.** 🔴 **E' l'unica recensione negativa, ed e'
   invisibile**: l'anteprima della scheda mostra solo le 3 piu' recenti, tutte
   a 5 stelle. `javaai` e' un utente reale (Cina, reputazione 559).
   ⚠️ **[INCERTO] sul voto esatto**: i dati strutturati del server MQL5 dicono
   `"ratingValue":"1"`, mentre una lettura della pagina renderizzata mi ha
   restituito "5 stelle". **Mi fido del dato emesso dal server** e dichiaro il
   conflitto. Il testo della recensione **non e' pubblico** (senza commento);
   la risposta del venditore (22/06) parla di *"long-term risk awareness"* e
   ammette: *"I fully agree that **no trading strategy is a 'holy grail' that
   can be profitable forever on a single pair**"*.
3. Il resto della lista e' **fortemente concentrato su Hong Kong** (Kwok Por Ko,
   Stephencheung888, lisachan1023, Wing Hong Yeung, Nim Chi Cheng, Law L,
   sophiacheung761, wongmf2019, jessicaiori) — cioe' la citta' del venditore —
   piu' un account chiamato **`test2010`**. 🟠 **[INFERITO]** rete personale
   piuttosto che base clienti indipendente. Non e' una prova, e' un contorno.

### 8.4 Le 3 recensioni leggibili, per intero
**[DICHIARATO DAI CLIENTI, NON VERIFICATO DA NOI]**
- **Cosminrus, 06/08/2026** — *"Hello, I've been using GoldEdge Spark for my
  FTMO account and it works flawlessly. Very happy about it. Thank you Chi Sang Lai!"*
- **Ignas Ronkaitis, 02/08/2026** — *"GoldEdge spark EA is a reliable and stable
  choice for long-term trading. It offers a good balance between risk and
  profit potential [...] Based on my experience, the risk is well managed, and
  the profit margin is attractive."*
  📌 **E' lo stesso utente che il 26/06 aveva chiesto del filtro news** e a cui
  il venditore ha risposto **27 giorni dopo** che non c'e' (§3.4).
- **Goodlove bone, 24/07/2026** — *"THIS EA IS SO AWESOME/ EXCELLENT INDEED...
  I AM USING IT FOR A MONTH NOW .... I RECOM THIS EA 4 SURE"*

> **Zero numeri. Zero drawdown. Zero periodi. Zero challenge passate.**
> Esattamente come le 6 recensioni di Master Nasdaq. **Per il metro di casa
> valgono zero.**

### 8.5 🔴 A cosa serve davvero questo EA, secondo i suoi utenti
Il dato piu' inquietante del thread non e' una recensione, e' un uso:
- **#43 (11/06) — Mihai Emil**: *"I am currently running GoldEdge Spark on my
  50K FTMO 1-Step account [...] **The account was in a deep $2,000 drawdown
  before applying this bot**, but it's already doing an amazing job recovering
  it safely."*
- **#45 (11/06) — Tonybrownssd**: *"**I actually have a challenge account that
  is on the verge of failing as well.** I think I'll give it a try on that one too!"*
- **#107 — un cliente**: *"I have **lost a lot of money this year with trap
  strategies**."*

> 🚨 **Questi utenti usano l'EA come strumento di RECUPERO su conti gia' in
> perdita.** E' il caso d'uso classico della martingala, ed e' il caso d'uso in
> cui salta il conto. **Il venditore non li ferma** — in #47 ringrazia Mihai e
> gli chiede la recensione a 5 stelle.
>
> 📌 E il seguito e' documentato: **due mesi dopo** (03/08) lo stesso Mihai e'
> a **−800 USD di flottante** con lotti saliti a 0,16, e scrive *"I just have
> to let it run"* (§4).

---

## 9. 🌍 REPUTAZIONE ESTERNA E FUSO ORARIO

### 9.1 Tracce indipendenti: nessuna
Ricerche del 22/08 su Google, **Forex Peace Army**, **Forex Factory**, Reddit
per `"GoldEdge" EA review scam / grid / hedging`: **zero risultati pertinenti**.

> ⚫ **Esito NULLO, non negativo**: non ho trovato nulla, non ho trovato prove
> che non ci sia nulla. Con 87 giorni di eta' e' normale. **Significa solo
> che l'unica reputazione esistente e' quella che il venditore ha costruito
> lui, sulla sua pagina.**

### 9.2 ⏰ Il fuso: non ci sono input orari, e proprio per questo e' un problema
**[VERIFICATO]**: in **2.715 righe** di commenti estratti (9 pagine) le parole
`GMT`, `server time`, `broker time`, `timezone`, `session`, `Friday`,
`weekend`, `overnight` compaiono **zero volte** come impostazione dell'EA.
Combinato col §3.5 (*"parameters are fixed and cannot be modified"*):
**GoldEdge Spark non ha input di orario, ne' di sessione, ne' di chiusura
serale o del venerdi'.**

Ma il fuso morde lo stesso, e per una via meno ovvia:

> 🚨 **L'EA decide "un ordine per candela H4" e calcola le ATR Border sulle
> candele H4. I confini delle candele H4 dipendono dall'ora del SERVER.**
> - Broker collaudati dall'autore: **IC Markets, Vantage, FTMO** → tipicamente
>   **GMT+2/+3**.
> - **BCM e' GMT+1** (regola di casa: ora server = ora italiana − 1).
> - **Scarto: 1-2 ore.** Su H4 questo sposta **ogni singolo confine di
>   candela**, quindi **ogni** valore di ATR Border e **ogni** decisione di
>   ingresso.
>
> Su un EA a parametri fissi, ottimizzato su 1,5 anni su broker GMT+2/+3,
> **su BCM gireresti una configurazione diversa da quella collaudata, senza
> avere alcun input per rimetterla in fase.** E' lo stesso genere di trappola
> gia' vista su Artemis (§2.6 del dossier Nasdaq), ma **qui non c'e' nemmeno
> l'input per correggerla**.

### 9.3 🟠 E c'e' l'overnight e il weekend
Tempo medio in posizione sui signal: **5 giorni (FTMO)** e **8 giorni
(Vantage)**. Nessun flat serale, nessun flat del venerdi'.
→ **Il paniere aperto attraversa i weekend.** Per una griglia che accumula
perdenti, il gap del lunedi' e' il modo canonico di scoprire il muro di lunedi'
mattina. **Non c'e' nessun meccanismo dichiarato che lo gestisca.**

---

## 10. 📏 IL CONFRONTO COL METRO DI CASA

`report/METRO_PROP.md`: muri **10% totale / 5% giornaliero**, rischio di casa
**0,65%**, p99 Monte Carlo **~8,1%** su 27 serie, peggior giornata misurata
**−2,06%** (R51).

| voce | **casa nostra** | **GoldEdge Spark / Matrix** |
|---|---|---|
| stop loss per trade | ✅ sempre, dimensionato allo **0,65%** | 🔴 *"instead of relying on fixed Stop Losses"* |
| DD peggiore **misurato** | p99 MC **~8,1%** · giornata peggiore **−2,06%** | 🔴 **47,88% (bilancio) / 79,98% (equity)** sul signal live |
| cap rischio aperto | ✅ **C1 = 3,25%** (5 SL vivi) | 🔴 nessuno: lo decide la profondita' della griglia |
| numero di posizioni | 1 per segnale/simbolo/lato | 🔴 illimitato per costruzione (1 per candela H4, mai chiuse in perdita) |
| filtro news | 🟠 `InpUseNewsFilter` sui nostri EA | 🔴 **assente e confermato assente** |
| flat serale / venerdi' | ❌ buco nostro noto | 🔴 assente (8 giorni medi in posizione) |
| Guardian esterno | ✅ `ABTG_Guardian` 779001 (pausa 4,0 · emergenza 4,9 e 9,9) | 🔴 **non potrebbe salvarlo**: chiudere il paniere a meta' congela le perdite che il motore stava per compensare |
| finestra di validazione | **>=150 operazioni IS + 150 OOS**, prova di regime su 4 finestre | 🔴 **1,5 anni consigliati dal venditore, sulla stessa finestra dell'ottimizzazione** |

### 🔴 E il punto che nessun parametro sistema
> **Il nostro `ABTG_Guardian` e' progettato per fermare EA che chiudono in
> perdita quando devono.** Su un motore a paniere-hedging l'intervento del
> Guardian e' **il peggiore dei mondi**: chiude d'imperio un paniere costruito
> per essere smaltito a pezzi, cristallizzando esattamente la perdita che il
> motore stava rimandando. **Non c'e' configurazione che concili i due.**
> E' architettura, non impostazione — la stessa conclusione gia' scritta per
> Master Nasdaq (20 posizioni simultanee), qui in forma piu' netta.

---

## 11. ⚖️ RACCOMANDAZIONE ONESTA

### 🔴 **SI SCARTA QUI. Non si scarica, non si prova nel tester.**

**Motivo primario, formale e non opinabile.**
`CANCELLO_ACQUISTI_EA.md`, **gradino 2**: *"recovery/griglia/martingala
**dichiarati o inferiti** = SCARTO anche se costasse 10 euro"*. Qui **non c'e'
niente da inferire**: la **prima riga** della scheda di vendita dice
*"structured **grid-style entries** and adaptive position scaling"*, il
venditore scrive *"hedging/**averaging**"* (#161) e *"instead of relying on
fixed Stop Losses"* (#33), e il changelog v3.4 nomina `Basket` e `AutoLot`.
🔴 **Il gradino 2 si applica identico al gratuito**: il costo di un EA non e'
il prezzo, e' il conto.

**I quattro fatti che si sommano, tutti verificati oggi:**

| # | fatto | dove |
|---|---|---|
| 1 | 🔴 Il signal live linkato dalla scheda ha **DD 47,88% bilancio / 79,98% equity**, previsione annua **−100%**, e **MQL5 lo marchia** *"absence of risk limitation"* — due volte | §6.2 |
| 2 | 🔴 Il venditore ammette che **Spark su FTMO puo' far scattare la regola anti-group-trading**, e vende come rimedio da 899 USD il "sembrare diversi" mantenendo *"the core profitable logic exactly the same"* | §2.4 |
| 3 | 🔴 **Nessun freno**: niente SL vero, niente filtro news (confermato), niente cap giornaliero, niente flat, **e su Spark nemmeno l'input del lotto**. Un cliente e' rimasto a −800 USD potendo solo *"let it run"* | §3.3, §3.5, §4 |
| 4 | 🔴 Il bug **0,01 → 0,16** e' documentato, la sua correzione (v3.1) e' stata **ritirata 13 giorni dopo** (v3.4), e la parola dell'autore conferma l'esistenza di un **"lot multiplier"** | §4 |

**Perche' non vale nemmeno l'ora di demo nel tester** (gradino 3 del cancello,
che sarebbe a costo zero — l'EA e' gratis):
1. Il gradino 3 esiste per **misurare cio' che il gradino 2 non ha gia'
   bocciato**. Qui il gradino 2 ha bocciato in modo esplicito e dichiarato.
2. 🔴 **Il backtest di una griglia e' il test piu' ingannevole che esista**:
   produce una curva di bilancio liscia esattamente fino alla serie che la
   uccide, e su 1,5 anni scelti dal venditore quella serie non c'e'. **Il
   forward pubblico del venditore l'ha gia' trovata: −80%.** Non abbiamo
   bisogno di ri-scoprirla noi.
3. Su Spark il **lotto e' 0,01 fisso**: qualunque numero di drawdown
   percentuale uscisse dal nostro tester sarebbe una funzione del capitale
   iniziale che scegliamo, **non una proprieta' del motore**. Il test non
   risponderebbe a nessuna domanda.
4. Non e' un EA sull'oro (§1.3): non colma nessun buco della flotta.

**Cosa NON dico**, per onesta':
- Non dico che il venditore sia disonesto. **Pubblica 4 signal verificati,
  compreso quello che lo danneggia**, ed e' l'unico dei quattro venditori
  censiti a farlo. Risponde ai clienti, ammette un bug, corregge i suoi stessi
  consigli sbagliati (#35 → #37). **La sua trasparenza e' il motivo per cui
  posso scartarlo con questa sicurezza.**
- Non dico che l'EA perda sempre. **PF 1,17 su 1.861 trade non e' rumore
  casuale.** Dico che il modo in cui guadagna — rimandando le perdite nel
  flottante — e' **strutturalmente incompatibile con un muro giornaliero al 5%
  e un muro totale al 10%**, che e' l'unica cosa che ci interessa.

---

## 12. 📦 COSA CI PORTIAMO A CASA (perche' qualcosa c'e')

Tre cose, e nessuna e' il suo codice.

### 12.1 🔵 Un metodo di controllo nuovo, riusabile: **il test del signal a taglia vera**
Questa indagine ha trovato la verita' in **10 minuti**, guardando i signal
dell'autore e cercando **la differenza fra il conto vetrina e il conto a
taglia piena**. Su Artemis e Master Nasdaq questo test **non era possibile**
(0 signals). Qui era possibile e ha risolto tutto.

> 📌 **Proposta di procedura**, da aggiungere al gradino **1-bis** del
> `CANCELLO_ACQUISTI_EA.md` (io non lo tocco — lo propongo):
> *"Se il venditore pubblica signal: aprirli TUTTI e confrontare il DD
> relativo per EQUITY fra il conto con la taglia piu' piccola e quello con la
> taglia piu' grande. Se il rapporto e' >5x, il rischio del motore non e'
> controllato dal motore ma dalla taglia — scarto. E leggere il REGISTRO
> AVVISI del signal: le frasi automatiche di MQL5 (`absence of risk
> limitation`, `80% of growth achieved within N days`) sono giudizi di
> piattaforma, non marketing."*
>
> **Costo: 10 minuti per prodotto. Resa: qui ha chiuso il caso da solo.**

### 12.2 🔵 Una conferma indipendente della nostra regola sulla finestra
La scheda dice *"use around 1,5 years of backtest data"* e le due modalita'
sono ottimizzate dal 2024/01 e dal 2025/01. Poi il forward reale a 45 settimane
fa −80%. **E' un caso di studio pulito dell'Emendamento della Finestra
(`CLAUDE.md`, regole A e C)**: finestra corta, un solo regime, ottimizzazione e
validazione sulla stessa storia → il forward smentisce tutto.
📌 Vale la pena citarlo quando qualcuno rivorra' accorciare le finestre.

### 12.3 🔵 Due voci per la nostra tabella dei buchi — **gia' note, ora confermate 4 volte su 4**
| meccanismo | noi | Artemis | Master Nasdaq | **GoldEdge** |
|---|---|---|---|---|
| filtro news da calendario | 🟠 sugli EA, non nel Guardian | ❌ promesso, mai fatto | ❌ | 🔴 **negato esplicitamente** |
| flat serale / venerdi' / no-overnight | ❌ **buco nostro** | 🟠 blocca ma non chiude | ❌ | 🔴 **assente** (8 giorni in posizione) |

> 🎯 **Nessuno dei quattro prodotti esterni censiti ha un filtro news da
> calendario e nessuno ha un flat serale completo.** Le uniche schede che li
> avevano sono quelle dei **guardiani** (Prop Guard Pro, §6.4 del dossier
> Nasdaq). **Conferma: questi due buchi si riempiono nel GUARDIAN, non
> cercando un EA che li abbia gia'.** Le proposte P3 e le voci sul filtro news
> restano in coda dove sono, senza doppioni.

### 12.4 ⚫ E cosa NON ci portiamo a casa
**Niente della sua meccanica.** L'ATR Border, l'hedging close, il cut loss per
simbolo, il "one order per bar": sono i pezzi di un motore a paniere. Presi
singolarmente non servono; presi insieme sono la cosa che il gradino 2 vieta.
📌 L'unica idea astrattamente interessante — *"un ordine per candela"* come
tetto anti-overtrading — **noi ce l'abbiamo gia' meglio**, sotto forma di
`InpMaxOpenPositions` e del cap C1 al 3,25%.

---

## 13. 🗂️ ELENCO DELLE PAGINE APERTE (per chi verra' dopo)

| URL | cosa ci ho preso |
|---|---|
| `mql5.com/en/market/product/178221` | **scheda Spark integrale**: descrizione, citazioni FTMO, raccomandazioni, guida backtest, 3 recensioni, JSON-LD con 20 recensori e voti |
| `mql5.com/en/market/product/178221/updates` | **changelog completo, 8 versioni** (2.4 → 3.4) |
| `mql5.com/en/market/product/178221/comments` + `/page2..page9` | 🔴 **168 commenti, tutte e 9 le pagine, verbatim** (2.715 righe) |
| `mql5.com/en/users/vincentlai` | profilo: 4 prodotti, 4 signals, 1 subscriber, esperienza "1 year", timeline pubblicazioni, testo integrale del bio |
| `mql5.com/en/users/vincentlai/seller` | catalogo coi **prezzi** (Matrix 899, US30 349) e **tabella riassuntiva dei 4 signal con Max DD** |
| `mql5.com/en/signals/2375791` | **FTMO 100K Signal1**: statistiche integrali, distribuzione 11 simboli |
| `mql5.com/en/signals/2378218` | 🔴 **Vantage Live 2**: DD 47,88%/79,98%, −100% annuo, **registro avvisi MQL5** |
| `mql5.com/en/signals/2383404` | US30 50K: avviso *"80% of growth achieved within 1 days"* |
| `mql5.com/en/signals/2385352` | FTMO 100K Signal2 |
| `mql5.com/en/signals/2378217` | ⚫ **signal cancellato** (linkato dalla scheda come "Live Signal #3") |
| `mql5.com/en/market/product/178219` · `/187088` · `/187275` | Matrix, US30, ATR Price Border (identificazione dei 4 prodotti) |
| `mql5.com/en/blogs/post/771707` | blog dell'autore: *"4-layer ATR dynamic border grid system"*, prezzo **799** |
| `mql5.com/en/users/javaai` · `/vincentlaihkfpa` | recensore a 1 stella (Cina, rep. 559) · 🔴 **404** |
| **goldedgeea.com** | ❌ **bloccato dal proxy** — manuale, setfile e "Prop Firm Strategy Guide" non letti |
| **trader.ftmo.com** (3 metrix) | ❌ **403 dal proxy** — le tre prove FTMO della scheda non lette |
| Google / FPA / Forex Factory / Reddit | ⚫ **nessuna traccia indipendente** |

---

_Nessun EA nostro toccato. Nessun parametro in forward toccato. Nessun file di
R97 o del Guardian toccato. Questo documento contiene **proposte e verdetti su
prodotti esterni**, non azioni._
