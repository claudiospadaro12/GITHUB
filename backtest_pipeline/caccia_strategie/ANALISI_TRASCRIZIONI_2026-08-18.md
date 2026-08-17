# 🎧 ANALISI TRASCRIZIONI — 18/08/2026

_Analista-trascrizioni. Fonte UNICA: le **12** trascrizioni TurboScribe caricate
da Claudio in `trascrizioni_2026-08-18/` (11 col primo zip + 1 col secondo zip
del 18/08 sera; il secondo file di quello zip era un doppione byte-per-byte di
`Prop EA Review` ed è stato scartato). Nessuna navigazione, nessuna integrazione
"da memoria", nessun buco riempito. Ogni estrazione porta il nome del file e la
citazione. I numeri dei relatori sono **[dichiarato, NON verificato]**._

> 🔴 **Un video (`#1 Prop Firm HACK`) insegna a NASCONDERE gli EA alle prop.**
> Documentato qui come **INTELLIGENCE**, marcato **VIETATO PER NOI**, mai
> proposto come pratica. Violare i termini di una prop = conto perso = l'esatto
> opposto dell'obiettivo. Il valore di quel video è capire **cosa** le prop
> rilevano, non come fregarle.

---

# 🥇 SINTESI INCROCIATA — la pagina che conta

## ⚠️ Nota di indipendenza (si legge PRIMA di contare le convergenze)

Le 12 trascrizioni **non sono 12 fonti indipendenti.** Due gruppi vanno contati
come UNA fonte ciascuno:

- **FONTE PETKO** (Petko Aleksandrov / EA Forex Academy — riconoscibile da: app
  **"PropFirm Robots"**, **"EA Studio"**, il broker "8Cap", il corso FTMO
  proprio, i coupon affiliati, il congedo "ti amo ragazzi / amo voi"):
  copre **4 video** → `#1 Prop Firm HACK`, `I found the Best Prop Firm`,
  `Prop EA Review`, `Prop firm EA... XT Prop Firms MT5 Review`. **Contano come 1.**
- **FONTE "CASH & PROP" (me + Alex)** (stile identico: varianza, portafoglio
  multi-asset, MT4 strategy tester, "single asset shown"): copre **2 video** →
  `EA Passing Prop Firm With 10% Max Drawdown`, `Profitable EA - Stop Loss
  Strategy`. **Contano come 1.**

Quindi le fonti realmente indipendenti sono **7**, non 12:
1. Petko / EA Forex Academy (4 video)
2. Cash & Prop / me+Alex (2 video)
3. BM Trading — range breakout (`FTMO Challenge Passed`)
4. Recensore-sviluppatore Gold Longbow (`Prop Firm Gold EA Review`)
5. Venditore bot "86% winrate" (`This EA Can Pass EVERY...`)
6. Blue Edge Financial — Titan X (`This Prop Firm Robot Passed 1,000`)
7. Canale affiliato Top-3 (`Top 3 Prop Firms`) + `Why This... Survives` (bot
   proprio, quasi vuoto)

**Su questo metro va letta ogni riga di convergenza qui sotto.**

## 🎯 I QUATTRO PUNTI CALDI CHE CLAUDIO HA CHIESTO DI VERIFICARE

| domanda di Claudio | risposta dalle trascrizioni |
|---|---|
| Il pattern **buffer 4%/9%** converge anche nel parlato? | ❌ **NO. Zero.** Nessun video detta 4/9, né alcun buffer numerico sotto il muro. Il parlato dà i muri prop "nominali" (5/10, 3/6) ma **non** l'idea di stare un punto prima. Il pattern 4/9 resta un fatto **solo dei `.set`** del §1A-ZERO del dossier, **non del parlato.** |
| Qualcuno detta l'**ora di reset** del muro giornaliero e il **fuso**? | ❌ **NO** per il reset del muro. Nessuno dice a che ora resetta il daily. **UN** fuso dettato ma è di STRATEGIA, non di reset: `Prop Firm Gold EA` cita **"New York + 7"** e una chiusura fissa **"11:20 NY"** (orari del motore gold, non del muro prop). [TRASCRITTO] |
| Qualcuno detta **valori di filtro news** (finestre in minuti)? | ❌ **NO.** `This Prop Firm Robot` (Titan X) dichiara un "news filter" che "ti fa uscire dalle news di alto impatto" **senza un solo numero in minuti**. Nessun video dà finestre in minuti. Contrasto netto coi `.set` (Gold Phantom NFP 100/60). |
| Qualcuno detta **recovery/griglia** per gli EA già schedati (FX JetBot, Dark, Infinity, UnitedEuro)? | ❌ **NO incrocio diretto.** Nessuno dei 4 EA è nominato in nessuna trascrizione. Conferma solo GENERICA: `Why This... Survives` dice _"le EA più popolari che vedo sono Martingale o grid style"_ [TRASCRITTO] — coerente col rischio già segnalato nel dossier §1D, ma non tocca i nostri nomi. |

> _(Aggiornamento secondo zip: la 12ª trascrizione — `XT Prop Firms MT5 Review`,
> Scheda 12 — **non cambia nessuna delle quattro risposte**: niente buffer,
> niente ora di reset, niente minuti news, nessuno dei 4 EA schedati.)_

> **In una riga:** le trascrizioni **NON confermano** nessuno dei quattro punti
> caldi con un numero. Dove i `.set` davano parametri, il parlato dà **concetti
> e trucchi**. La resa numerica di queste 11 trascrizioni è **molto più bassa**
> di quella dei tre `.set` veri.

## 📊 TABELLA DEI VALORI CONVERGENTI (fra fonti INDIPENDENTI)

| tema | valore / concetto | fonti indipendenti | conta come |
|---|---|---|---|
| **Alto reward-risk + alta win rate + BASSA VARIANZA per sopravvivere al muro** | "keep the variance low, the win rate's got to be high", RR positivo obbligatorio | Cash&Prop, Gold-reviewer, Blue Edge | **3 su 7** 🟢 il più solido |
| **Rischio basso per trade, lasciar correre le probabilità** (non "passare veloce") | "metti il rischio basso e lascia esplodere le probabilità" | Petko (`Prop EA Review`), BM Trading, Cash&Prop | **3 su 7** 🟢 |
| **Randomizzare input/SL/TP/magic per non risultare "stessa strategia"** | 🔴 anti-detection | Petko, Venditore-86%, Blue Edge | **3 su 7** — ⚠️ **VIETATO PER NOI** |
| **Hedge su un conto reale/live per recuperare il costo della challenge** | 🔴 hedge cross-account | Petko (`PropEA`), Venditore-86%, Blue Edge (Titan X) | **3 su 7** — ⚠️ bandiera |
| **Drawdown STATICO, mai trailing** (per l'hedge / per il calcolo) | "usalo solo su firme con drawdown statico, non trailing — importante" | Petko (`PropEA`) | 1 su 7 — ma **coincide col dossier P7** |
| **FundedNext daily/total** | 5%/10% (2-step) · **3%/6% (1-step)** | Petko (`I found the Best`), Top-3 | 2 su 7 — **coincide col dossier §2B** |
| **I muri 1-step sono più stretti: daily 3-4%, total 6%** | FundedNext 1-step 3%/6% · theforexpropfirm.com 1-step **4%/6%** (e 2-step 12% senza daily) | entrambe le voci sono di Petko | **1 su 7** — NON è convergenza fra fonti, ma coincide col pattern del dossier (E8 daily 4%, FTMO 1-step 3%) |
| **Misurare il max DD del backtest CONTRO il muro della sfida prima di comprarla** | XT review: DD 6,62% > muro 6% → "perderei l'account" → riduce il rischio e rimisura | Petko (`XT Review`) | 1 su 7 — ma è **esattamente il metodo del nostro `METRO_PROP.md`**, detto ad alta voce |
| **Rischio per trade "regola semplice"** | **1% per trade** | Petko (`I found the Best`) | 1 su 7 |
| **FTMO minimo giorni di trading** | **4 giorni** | Petko (`PropEA`) | 1 su 7 — coincide col dossier §2A |

## ⚔️ CONTRADDIZIONI

1. **"Nessun grid/martingala" a parole, ma il settore è pieno di grid.**
   `This EA Can Pass EVERY` e `Prop Firm Gold EA Review` giurano "no grid, no
   martingale, no HFT"; `Why This... Survives` ammette che _"le EA più popolari
   sono Martingale o grid"_. Il "no-grid" è **linguaggio di vendita**, non un
   fatto verificabile dal parlato.
2. **DCA vs "no averaging".** `EA Passing Prop Firm With 10% Max Drawdown`
   dichiara apertamente _"siamo in grado di **DCA** un paio di giorni più tardi
   per evitare questo sguardo quotidiano"_ [TRASCRITTO] — cioè **mediazione**,
   che le stesse prop (FundedNext, `I found the Best`) elencano fra le pratiche
   a rischio. Stesso video vende "10% max drawdown, EA totalmente passiva".
3. **Reward-risk alto vs win-rate alto.** Alcuni (Gold-reviewer, 53% win, RR
   ~1:1) vendono RR alto; altri (Venditore-86%) vendono win-rate 86% con RR
   implicitamente basso. **Due ricette opposte, stesso obiettivo.** Nessuno
   porta il numero che le concilia.

## 🏠 CONFRONTO COL REPO (cosa già sappiamo / già facciamo)

- **Il buffer 4/9** (dossier §1A-ZERO, proposta **P2**): **il parlato NON lo
  rinforza.** Resta appeso ai soli `.set`. P2 non guadagna una terza gamba qui.
- **Static-not-trailing drawdown** (proposta **P7**, `METRO_PROP §1`): il video
  `PropEA` lo dice **esplicitamente** — l'hedge/challenge va fatto **solo** su
  drawdown statico. È una conferma qualitativa alla nostra cautela sul trailing.
- **Randomizzazione** (proposta **P8**): il parlato conferma che serve a **non
  risultare "strategia identica"** su più conti — esattamente la lettura di P8.
  E conferma la domanda aperta in `DOMANDE_SUPPORTO_PROP.md`: **stessa flotta su
  due conti = "copy trading"/"stessa strategia"?** `I found the Best` (FundedNext)
  dice che due EA sullo stesso simbolo, uno long e uno short, su **conti diversi**
  = **hedging multi-account = VIETATO**. Sullo **stesso** conto = permesso.
- **News filter** (proposta **P5**): confermato come "buco che fa perdere le
  challenge" (Titan X: _"è dove molte persone perdono la loro roba"_), ma
  **nessun valore in minuti** da copiare — quindi non aiuta a tarare P5.
- **FundedNext 1-step 3%/6%** (dossier §2B dava solo il 2-step 5%/10%): il video
  `I found the Best` **aggiunge il numero 1-step: 3% daily / 6% total** — utile,
  ma è comunque [dichiarato dal relatore], non verificato.

## ❓ LE DOMANDE PER CLAUDIO (schermate ai minuti giusti)

Molti relatori mostrano pannelli di input **senza leggerli ad alta voce**. I
buchi da colmare con uno screenshot:

1. **`Prop EA Review` (PropEA)** — mostra il pannello input dell'EA hedge
   (modo PROP/live, "min sell days", target, daily loss 500$, verification
   phase). I **default numerici** non sono dettati: serve lo screenshot del
   pannello. → è software di **hedge cross-account**: intelligence, **non da
   comprare** (bandiera).
2. **`This Prop Firm Robot` (Titan X / Blue Edge)** — mostra il "leaderboard"
   con pass-rate per strategia e la funzione **MDL (Max Daily Loss)** e il
   **news filter**: nessun valore dettato. Screenshot del pannello MDL e della
   finestra news (se c'è un campo minuti).
3. **`Prop Firm Gold EA Review`** — recensione a schermo di una pagina MQL5:
   il "New York +7" e "11:20" sono dettati, ma i **default del `.set`** no.
   Se interessa il motore gold, screenshot della lista input.
4. **`FTMO Challenge Passed`** — mostra le metriche FTMO (max risk 3,5%, lotti
   0.2, target 500€): il **`.set` del range-breakout EA non è mostrato.**

---

# 📇 LE 12 SCHEDE

---

## SCHEDA 1 — `#1 Prop Firm HACK How to hide your EAs in Challenges.txt`

```
FILE            #1 Prop Firm HACK How to hide your EAs in Challenges.txt
RELATORE/CANALE Petko Aleksandrov / EA Forex Academy [INFERITO: app "PropFirm
                Robots", "dollarone EA", broker Trading.com, coupon affiliati]
OGGETTO         🔴 TECNICA ANTI-DETECTION — come nascondere un EA alla prop
```

**🔴 VIETATO PER NOI — documentato come intelligence.**

PARAMETRI CON VALORE
- Nessun parametro di protezione/config. Solo numeri di performance dichiarati
  (sotto).

MECCANISMI (di occultamento — VIETATI)
1. **Magic number = 0** per simulare trading manuale: _"se cambiate soltanto
   il numero magico a zero, simulerete il tradimento manuale. La firma PropFirm
   non capirà che trattate con un robot"_ [TRASCRITTO chiaro]. **Intelligence
   utile per noi: la prop legge il magic number** e cerca EA di mercato con
   magic condiviso fra utenti.
2. **Randomizzare gli input** (SL, TP, parametri indicatore): _"randomizzare
   gli input dell'advisore esperto... cambiare leggermente il valore del
   stop-loss o il valore del profit"_ [TRASCRITTO]. **Intelligence: la prop
   cerca "tratti simili" fra conti diversi.**
3. **Magic number unico per ogni download** (funzione dell'app PropFirm Robots):
   _"ottenendo un numero magico unico... ogni volta che downloado un expert
   advisor lo downloaderà con un numero magico unico e tutti gli input... saranno
   diversi"_ [TRASCRITTO].

REGOLE PROP CITATE
- **Trading.com** (piattaforma "incubatore Hedge Fund"): _"No City Rules, usate
  qualsiasi EA che volete"_, **absolute stop loss 10%**, target fase 1 **20%**,
  scala fino a fase 5 (200k). Struttura: deposita 1k → 9k di credito → conto 10k.
  [TRASCRITTO, dichiarato dal relatore].

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- Target 20% raggiunto, profitto $2.008 su conto 10k; recupero da −5% a +20%.

BANDIERE ROSSE
- 🔴 **Tutto il video è una bandiera rossa.** Magic 0 + randomizzazione =
  **elusione del rilevamento anti-EA**. FTMO ($400k/strategia) ed E8 ("1
  strategia/utente") **misurano** esattamente questo. **VIETATO PER NOI.**

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il pannello "randomize all" dell'app PropFirm Robots (checkbox per magic
  unico/input diversi): mostrato, non dettato.

COSA NE COPIAMO
- **NIENTE come pratica.** Come intelligence: **la prop rileva (a) magic number
  condiviso, (b) input identici, (c) tratti simili fra conti.** Conferma la
  lettura di P8 e la domanda in `DOMANDE_SUPPORTO_PROP.md`.

---

## SCHEDA 2 — `EA Passing Prop Firm With 10% Max Drawdown.txt`

```
FILE            EA Passing Prop Firm With 10% Max Drawdown.txt
RELATORE/CANALE Cash & Prop / "me + Alex" [INFERITO — stesso stile della Scheda 5]
OGGETTO         EA swing per prop, filosofia "varianza bassa"
```

PARAMETRI CON VALORE
- **Rischio per trade allo stadio "aggressivo": ~4%** — _"il rischio per
  vantaggio massimo su questo è... allo stadio aggressivo di circa 4%"_
  [TRASCRITTO dubbio: lo speech-to-text qui è pessimo, "vantaggiatura"=leverage/edge].
- Registrato **fino al 2025**; test su singolo asset (New Zealand citato).
- Varianza di mercato osservata **~400 punti** in un periodo laterale.

MECCANISMI
- **Alta "edge"/RR + varianza bassa** come principio-chiave per non bucare il
  muro 5%/10%: _"keep the variance low, the win rate's got to be high"_
  [TRASCRITTO chiaro, parte finale in inglese].
- **Entrate solo dopo grande movimento** (swing): _"avrai bisogno di lasciare il
  mercato muoversi considerabilmente prima di prendersi avanti del prezzo"_.
- 🔴 **DCA** per evitare il drawdown giornaliero: _"siamo in grado di DCA un
  paio di giorni più tardi per evitare questo sguardo quotidiano"_ [TRASCRITTO].

REGOLE PROP CITATE
- Muri **5% giornaliero / 10% totale** citati genericamente (il "trap" del 5/10).

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- ~$19.558 profitto, max drawdown $1.366 su un test.

BANDIERE ROSSE
- 🔴 **DCA = averaging.** Dichiara "no arranged, totally random" ma poi ammette
  di mediare per nascondere il drawdown giornaliero. Contraddittorio col claim
  "10% max drawdown passiva".

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il "giornale"/report a schermo con gli asset e i risultati aggregati: mostrato,
  non dettato. Nessun `.set`.

COSA NE COPIAMO
- Il **principio varianza-bassa/RR-alto** (converge, vedi sintesi). Il DCA **NO**.

---

## SCHEDA 3 — `FTMO Challenge Passed The EA Strategy That Got Me Funded.txt`

```
FILE            FTMO Challenge Passed The EA Strategy That Got Me Funded.txt
RELATORE/CANALE BM Trading [TRASCRITTO: "questo video è presentato da BM Trading"]
OGGETTO         Range Breakout EA su FTMO, racconto di una challenge passata
```

PARAMETRI CON VALORE
- **Lotto fisso 0.2** su ogni trade: _"ogni unico negozio è stato fatto con 0.2
  lotti"_ [TRASCRITTO chiaro].
- **Rischio massimo osservato 3,5%**: _"il più grande rischio era del 3,5 per
  cento, ciò che è assolutamente ok"_ [TRASCRITTO].
- Challenge **10K**, **target 500 euro** (fase verifica), passata in **~5 mesi**.
- Simboli: **GBPUSD + JPY** (yen ha fatto il profitto, GBPUSD ha perso ~500).
- **Un solo giardino/grafico al giorno** per il programma di trading.
- FTMO ha **rimosso la regola dei 30 giorni** [TRASCRITTO, dichiarato].

MECCANISMI
- **Range breakout** su H? [non dettato il timeframe].
- **Diversificazione per settings**: la STESSA strategia base con **input diversi
  su conti diversi** — _"in tutti i miei account uso settori diversi per la
  stessa base strategia"_. Ammette che **non sa quali siano i "migliori settings"**.
- **Stop breakeven** consigliato in mercati laterali, tolto in mercati trend.
- 🔴 (soft) **"modificherò un po' così non potrete copiarlo"** sul conto funded
  = variazione input per non farsi copiare (non anti-prop, anti-follower).

REGOLE PROP CITATE
- FTMO: challenge 10K e 100K, fase verifica con target, no regola 30 giorni.

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- 8 challenge FTMO: 2 passate, 2 fallite, 3 in verifica, 1 in challenge.

BANDIERE ROSSE
- Nessuna tecnica vietata. Solo il "cambio settings per non farsi copiare".

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il `.set` del Range Breakout EA (mai mostrato/dettato) — **screenshot utile**
  se interessa un motore breakout su FX.

COSA NE COPIAMO
- Nota metodologica: **lotto fisso + rischio basso + diversificazione per
  input** su più conti. Nessun valore direttamente adottabile.

---

## SCHEDA 4 — `I found the Best Prop Firm That Allows EAs.txt`

```
FILE            I found the Best Prop Firm That Allows EAs.txt
RELATORE/CANALE Petko / EA Forex Academy [INFERITO: app "PropFirm Robots"]
OGGETTO         FundedNext come "prop che permette gli EA", censimento pratiche
                vietate + regole hedging
```

**🟢 La scheda con più intelligence-regole utile del lotto.**

PARAMETRI CON VALORE
- **FundedNext 2-step: 5% daily loss / 10% max loss.** _"la perdita massima di
  giorno e la perdita massima di tutto è 5% e 10% ma questo è per la sfida di due
  passaggi"_ [TRASCRITTO chiaro].
- **FundedNext 1-step: 3% daily / 6% total.** _"ho scelto la sfida di uno
  passaggio... è 3% per la perdita massima di giorno e è 6% per la perdita
  massima di tutto"_ [TRASCRITTO chiaro]. **Coincide col dossier §2B / §2G.**
- **Rischio per trade: 1%** — _"di solito vado per 1% per vendita, regola
  semplice che funziona bene a lungo termine"_ [TRASCRITTO].
- Challenge acquistata: **15K Stellar One Step**.
- Strategia: **top 5 EA dell'ultimo mese** tenuti nel conto.

MECCANISMI / PROTEZIONI
- **Equità minima ed equità massima** impostate negli EA: _"ho l'equità minima e
  l'equità massima"_ [TRASCRITTO] — cioè min/max equity guard **dentro l'EA**
  (come il KT Equity Protector del dossier §1B, ma qui è nell'EA stesso).
- **Randomizzazione** di entrate/uscite/indicatori/stop/profit per "tratti unici"
  (via app PropFirm Robots) — stesso meccanismo Scheda 1.

REGOLE PROP CITATE (FundedNext, [dichiarato dal relatore])
- **EA permessi**, ma i parametri devono essere "unici".
- **VIETATO:** HFT, QuickStrike, latency trading (da terzi), **arbitrage**,
  **tick scalping**, **GRID trading**, side betting/gambling, hyperattività,
  uso di piattaforma/dati "freddi" per errori del demo.
- 🔴 **HEDGING multi-account VIETATO:** _"hedging è permesso solo nello stesso
  account... sarà contro le loro regole se ho un euro-dollar EA in un account e
  un altro euro-dollar EA in un altro account"_ (uno long, uno short = hedge
  cross-account). **Sullo stesso conto: permesso** (due EA long+short OK).
- Ha **scritto un'email al supporto** e ottenuto conferma scritta → **è la
  regola D3 in azione** (coerente con `DOMANDE_SUPPORTO_PROP.md`).

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- +$147 su 5 giorni nella nuova challenge 15K.

BANDIERE ROSSE
- La randomizzazione (già marcata). Il resto della scheda è **conforme** e anzi
  utile per la conformità.

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il pannello dell'app con "rischio per strategia / lotti / periodo OOS verde":
  mostrato, valori non dettati.

COSA NE COPIAMO
- **Conferma regole:** FundedNext 1-step **3/6**, 2-step **5/10**; **grid
  vietato**; **hedge cross-account vietato**; **stessa strategia su conti diversi
  = rischio**. Rinforza P8 e la domanda supporto. **1% per trade** come dato
  esterno (il nostro è 0,65%).

---

## SCHEDA 5 — `Profitable EA Trading - Stop Loss Strategy For Prop & Cash Trading.txt`

```
FILE            Profitable EA Trading - Stop Loss Strategy For Prop & Cash Trading.txt
RELATORE/CANALE Cash & Prop / "me + Alex" [INFERITO — stessa fonte Scheda 2]
OGGETTO         EA che codifica una metodologia di stop-loss manuale
```

PARAMETRI CON VALORE
- Conto iniziale **100.000** (tipico challenge).
- **Win rate 75%** [dichiarato].
- **Max loss ~4-5%** _"la perdita max è arrivata a circa 5%"_ [TRASCRITTO dubbio].
- Perdite consecutive max **7**.
- Profitto **9,4%** su **2 anni 8 mesi** (03/03/2022 → 05/11/2024).
- Portafoglio dichiarato: **20-40 asset**, di cui ~10-13 non correlati.

MECCANISMI
- **Chiusura anticipata prima del target** ("spesso chiudiamo molto prima del
  target... la valutazione diminuisce con il tempo").
- Stesso principio **varianza bassa / RR** della Scheda 2 (conferma la stessa
  fonte, NON una fonte in più).

REGOLE PROP CITATE
- Muro **4-5% di chiusura** "sotto i vostri parametri che vi chiuderanno su Prop".

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- 9,4% / 2a8m, 75% win, 20 "portafogli".

BANDIERE ROSSE
- Nessuna tecnica vietata dichiarata (a differenza della Scheda 2, qui niente DCA).

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il report statistiche MT4 (win rate, consecutive) mostrato, ma è **un solo
  asset** — nessun `.set`.

COSA NE COPIAMO
- **NIENTE di numerico** (stessa fonte della Scheda 2, il concetto è già contato).

---

## SCHEDA 6 — `Prop EA Review How to Pass Prop Firm Challenges.txt`

```
FILE            Prop EA Review How to Pass Prop Firm Challenges.txt
RELATORE/CANALE Petko / EA Forex Academy [INFERITO: EA Studio, 8Cap, Discord VIP]
OGGETTO         "PropEA" — software di HEDGE cross-account per recuperare il
                costo della challenge
```

**⚠️ Intelligence su un prodotto di hedge. NON una proposta d'acquisto.**

PARAMETRI CON VALORE
- Challenge FTMO **10K**: target **10%** (fase 1), **5%** (fase 2), drawdown **10%**.
- Prezzo PropEA **185€** (pagato 105€ in promo).
- **Conto live/hedge necessario: ~231€** (calcolato dal calcolatore dell'EA) —
  usato hedge da **~250$**.
- **FTMO min sell days = 4**: _"FTMO ha un giorno di vendita min di 4"_
  [TRASCRITTO chiaro] — l'EA piazza **4 piccoli trade** per soddisfare la regola.
- Modalità di trading dell'EA: **manuale / random / buy / sell** (4 opzioni);
  default **random** = apre buy o sell **random ogni 24h** se non c'è trade aperto.

MECCANISMI
- 🔴 **HEDGE cross-account:** stesso EA su conto prop e conto live, che "si
  parlano"; se perdi sul prop, il live va in profitto (~105) e recuperi il costo.
  _Scenario 1: perdi il 10% sul prop → il live fa +105 → recuperato il costo._
- 🔴 **Random pass:** _"si tratta di acquistare o vendere randomicamente ogni 24
  ore... cercando di passare la sfida in questo unico trattamento"_ = **gambling
  su un trade**, non strategia. Il relatore stesso ammette: _"se usi la default
  mode non ha davvero un bordo nel mercato"_.
- ✅ **Static-not-trailing (dato utile):** _"assicuratevi di usarlo solo su firme
  con drawdown STATICO invece del drawdown trailing, è molto importante... col
  trailing... potreste perdere sia la sfida che l'hedge"_ [TRASCRITTO chiaro].
  **Coincide col dossier P7 / METRO_PROP §1.**

REGOLE PROP CITATE
- FTMO 2-step 10%/5% target, 10% drawdown, min 4 giorni.

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- Molte challenge passate "in 5-6 mesi con rischio basso" vs "4-6 settimane con
  PropEA a rischio alto"; payout da 100K FTMO.

BANDIERE ROSSE
- 🔴 **Hedge cross-account + random pass.** L'hedge fra due conti **propri** con
  posizioni opposte è ciò che FundedNext (Scheda 4) chiama **hedging multi-account
  = VIETATO**. **Da NON fare.** Intelligence: capire che l'hedge cross-account è
  un pattern che le prop cercano.

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il pannello PropEA (modo, verification phase, daily loss 500$, target 1000$):
  valori mostrati parzialmente, `.set` completo non dettato — **screenshot** se
  serve capire il meccanismo (non per usarlo).

COSA NE COPIAMO
- Solo il **rinforzo di P7** (static, non trailing). Il prodotto **NO**.

---

## SCHEDA 7 — `Prop Firm Gold EA Review - Real Time Based Strategy.txt`

```
FILE            Prop Firm Gold EA Review - Real Time Based Strategy.txt
RELATORE/CANALE Recensore-sviluppatore (dichiara: "ho sviluppato il Gold Longbow";
                cita Wim/Gold Reaper) [INCERTO sul nome del canale]
OGGETTO         Recensione di "Prop Firm Gold EA" — strategia gold time-based
```

**🟢 La scheda con più struttura di STRATEGIA dettata (orari veri).**

PARAMETRI CON VALORE
- **Fuso: "New York + 7"** — _"se stai usando un broker che non ha un tempo
  standard New York Plus 7, devi accontentarti"_ [TRASCRITTO chiaro]. È il fuso
  del **broker atteso dall'EA**, non il reset di una prop.
- **2 trade al giorno.** Primo trade **all'apertura del mercato oro** (tipo
  breakout asiatico). Secondo trade dopo la chiusura del primo.
- **Chiusura fissa ~11:20 ora NY** (18:20-20:00 ora broker "+7"): _"va fino a
  18-20 ogni giorno, e questo sarebbe il tempo di New York a 11:20"_ [TRASCRITTO].
- **Win rate ~53%**, **507 trade in un anno** (~1,4/giorno), RR ~1:1 positivo
  [dichiarato, da report a schermo].
- Test su Vantage, **every tick / real ticks**.

MECCANISMI
- **Entrata time-based** sul primo trade del giorno (long/short in base a un
  filtro di trend o al colore della prima candela M5 — **il recensore SPECULA**,
  non è dettato dal vendor).
- **Stop-and-reverse:** se il trade 1 va in stop loss → il trade 2 entra in
  direzione opposta. Se il trade 1 chiude in profitto → il trade 2 entra "un po'
  dopo".
- **Drawdown protector + randomizer** dichiarati come "feature prop firm"
  (nomi, senza valori).

REGOLE PROP CITATE
- Generico "compatibile prop, RR più alto". Nessun numero di muro.

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- 53% win, 507 trade/anno, curva equità "reale".

BANDIERE ROSSE
- Nessuna tecnica vietata (dichiara no-grid/no-martingala; **claim di vendita**,
  non verificabile dal parlato).

COSA C'ERA A SCHERMO E NON NEL PARLATO
- La **pagina MQL5 con la lista input** e il **`.set`**: mostrati, valori non
  dettati. **Screenshot molto utile** se interessa un motore gold time-based
  (è il tipo "apertura + orario fisso" affine alle nostre sedie ORB/aperture).

COSA NE COPIAMO
- Concettuale: **motore gold a 2 trade/giorno, entrata all'apertura + chiusura
  oraria fissa + stop-and-reverse**. Nessun valore diretto, ma è la strategia
  meglio descritta del lotto. Da abbinare a uno screenshot.

---

## SCHEDA 8 — `This EA Can Pass EVERY Prop Firm Challenge [86% Winrate No Grid No Martingale No HFT].txt`

```
FILE            This EA Can Pass EVERY Prop Firm Challenge [86% Winrate...].txt
RELATORE/CANALE Venditore di bot proprio [INCERTO sul nome; Discord + Instagram]
OGGETTO         Vendita di un EA "86% winrate" per challenge + funded
```

PARAMETRI CON VALORE
- **Win rate dichiarato 86%** (nel titolo), **pass rate 80-82%** nel parlato
  (_"le probabilità sono 82% o 80% di probabilità di passarlo"_) — **il titolo e
  il parlato non coincidono** (86% vs 80-82%). [TRASCRITTO — incoerenza interna].
- **Licenza 12 mesi, 1 solo account per volta.**
- Vendite limitate: **5 copie, poi "lo cambiano un po'" e altre 5.**

MECCANISMI
- 🔴 **"Soluzione tecnica per mascherarlo"** — _"abbiamo un'altra soluzione
  tecnica per mascheggiarlo, quindi non sarà un problema"_ [TRASCRITTO]. =
  **anti-detection.**
- **Hedge/"account life"** citato come modo per fare comunque soldi anche
  fallendo.
- Cambio del bot ogni 5 vendite per non far girare la stessa strategia su troppi
  conti (= altra forma anti-detection).

REGOLE PROP CITATE
- FTMO generico; "molte firme che permettono EA".

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- 86% winrate, 80-82% pass, esempi di payout $4.000.

BANDIERE ROSSE
- 🔴 **"Mascherare" + vendere a lotti di 5 e cambiare** = elusione del
  rilevamento. **VIETATO PER NOI.**

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il sito web con FAQ e il pannello dell'EA: mai mostrati in dettaglio nel testo.

COSA NE COPIAMO
- **NIENTE.** Intelligence: conferma che "mascheramento" + "lotti piccoli di
  vendita" è una tecnica di mercato che le prop combattono.

---

## SCHEDA 9 — `This Prop Firm Robot Passed 1,000 Challenges.txt`

```
FILE            This Prop Firm Robot Passed 1,000 Challenges.txt
RELATORE/CANALE Blue Edge Financial — "Titan X" + "HiveMind AI"
                [TRASCRITTO: blueedgefinancial.com, leaderboard.blueedgefinancial.com]
OGGETTO         Vendita bot Titan X + community "HiveMind"
```

PARAMETRI CON VALORE
- **Pass rate dichiarato 25-33%** (confrontato col "top trader manuale 29%").
- **Target sul funded: 2-4% al mese** (_"andiamo per targetti conservativi 2-4%"_).
- Costo VPS "10-20$/mese". Conto hedge "1000-1500$".
- Esempi challenge: Blue Guardian **$348**, E8 **$397/$398**.
- Leaderboard mostra per strategia: **% challenge passate su 1 anno / 12
  settimane**, **giorni medi per passare** (es. 27 gg / 21 gg, o 12 / 10).

MECCANISMI
- **News filter** ("ti fa uscire dalle news di alto impatto") — **nessun valore
  in minuti dettato.**
- **MDL (Max Daily Loss)** — funzione che risponde alle regole di daily/total
  loss della prop — **nessun valore dettato.**
- **Funzione di randomizzazione** per non farsi detectare ("PropFirms non è in
  grado di detectare molte persone usando lo stesso robot").
- 🔴 **"Hedge on real account"** — attivato su un conto separato con 1000-1500$:
  se perdi sul prop, guadagni sull'hedge (esempi: sconfitto ma +$701, +$733,
  +$977). = **hedge cross-account** (stessa bandiera di Scheda 6/8).
- **"HiveMind AI"** che raccoglie dati dalla community per scegliere quali
  strategie passano meglio (marketing; nessun parametro).

REGOLE PROP CITATE
- Blue Guardian, E8 (nomi, con costi challenge). Nessun numero di muro dettato.

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- $1.4M funded personale, 1000+ challenge passate, pass 25-33%.

BANDIERE ROSSE
- 🔴 **Hedge on real account + randomization anti-detection.** **VIETATO PER NOI.**

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il pannello **MDL** e la **finestra news filter** di Titan X: mostrati, **zero
  valori dettati** → screenshot se si vuole vedere se il news filter ha un campo
  minuti.

COSA NE COPIAMO
- **NIENTE come prodotto/pratica.** Intelligence: (a) target funded realistico
  **2-4%/mese** citato da più venditori; (b) conferma che il **news filter è il
  punto dove "molti perdono"** (rinforza P5, senza numeri).

---

## SCHEDA 10 — `Top 3 Prop Firms For EA Trading.txt`

```
FILE            Top 3 Prop Firms For EA Trading.txt
RELATORE/CANALE Canale affiliato "Top 3" [INCERTO; voce/testo tradotti da script]
OGGETTO         Classifica affiliata: FunderFX, FundedTrading+, FundedNext
```

PARAMETRI CON VALORE
- **FunderFX:** fondo fino a **$1.75M**, **profit split 70%**, no-challenge
  (fondi immediati), broker 8Cap, **leva 1:100**. Permette EA, overnight,
  weekend, news.
- **FundedTrading+:** split **70/30**, scala fino a **$2.5M**, **drawdown 5%**,
  **target profit 5%**; una volta raggiunto il target il "raggio di trading" (il
  drawdown attivo) **viene tolto**. Vieta arbitraggio.
- **FundedNext:** richiede challenge, **drawdown 5%**, leva 1:100, **UN solo
  posizionamento alla volta** (_"one position at a time"_) [TRASCRITTO — nota:
  potrebbe essere una semplificazione del canale, contrasta con la Scheda 4 dove
  FundedNext permette più EA/posizioni; **[INCERTO]**].

MECCANISMI
- Nessuno tecnico. È un elenco di regole/benefici commerciali.

REGOLE PROP CITATE
- Vedi sopra. **[dichiarato dal canale affiliato, NON verificato]** — il video è
  esplicitamente promozionale (coupon/affiliazione).

NUMERI DI PERFORMANCE
- Nessuno.

BANDIERE ROSSE
- Nessuna tecnica vietata. Bandiera "soft": **è un video affiliato**, i giudizi
  non pesano (regola di casa).

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Nessun pannello EA. Solo grafica promozionale.

COSA NE COPIAMO
- Solo il dato **FundedTrading+ 5%/5% con drawdown rimosso dopo il target** come
  voce da verificare (non è fra le 6 prop del dossier). **[INCERTO]** —
  eventualmente una domanda supporto se interessa quella prop.

---

## SCHEDA 11 — `Why This Prop Firm EA Robot Survives Long-Term (Most Don't).txt`

```
FILE            Why This Prop Firm EA Robot Survives Long-Term (Most Don't).txt
RELATORE/CANALE Canale con EA proprio [INCERTO]
OGGETTO         Chiacchierata generica su cosa sia un EA + teaser del proprio bot
```

**⚠️ TRASCRIZIONE TRONCA.** Il file finisce a metà frase (riga finale: un muro di
"risorse risorse risorse..." — bug dello speech-to-text) **prima di arrivare a
qualunque parametro del "loro EA".** Solo 12 righe utili su un video presumibilmente
lungo. **La parte con i dati del prodotto NON è nel file.**

PARAMETRI CON VALORE
- Nessuno. Cita prezzi generici di EA sul MQL5 Market ($300-$30.000, Gold Reaper,
  Maximus) come panoramica, non come config.

MECCANISMI
- Solo definizioni generiche ("EA = strategia su autopilot", regole specifiche).

BANDIERE ROSSE
- ✅ **Osservazione utile (intelligence generica):** _"le EA più popolari che
  vedo sono EA di tipo Martingale o grid style trading... continueranno a mettere
  negozi contro il movimento"_ [TRASCRITTO]. Conferma il rischio del dossier §1D
  ("prop-ready ≠ senza recovery"), **senza nominare i nostri 4 EA schedati.**

COSA C'ERA A SCHERMO E NON NEL PARLATO
- Il MQL5 Market e (presumibilmente) il pannello del loro EA: la parte del video
  col prodotto **non è stata trascritta** → se Claudio vuole il contenuto, serve
  **la trascrizione completa** (questa è troncata).

COSA NE COPIAMO
- **NIENTE.** Scarto quasi totale per troncamento.

---

## SCHEDA 12 — `Prop firm EA that might be a Game Changer! XT Prop Firms MT5 Review Scam or Not.txt`

_(secondo zip TurboScribe, 18/08 sera — commit 4de2d39)_

```
FILE            Prop firm EA that might be a Game Changer! XT Prop Firms MT5
                Review Scam or Not.txt
RELATORE/CANALE Petko / EA Forex Academy [INFERITO: corso FTMO proprio con EA
                inclusi, coupon in descrizione, congedo "amo voi... fate un
                sicuro trattamento" — stessa firma verbale del cluster A]
                → NON è un'ottava fonte: si somma alla FONTE PETKO (4° video)
OGGETTO         Recensione dell'EA "XT Prop Firms MT5" (MQL5 Market, $600) +
                regole della prop "theforexpropfirm.com"
```

⚠️ "Game Changer!" + "Scam or Not" nel titolo = marketing da recensione: qui si
estraggono i **meccanismi e i valori dettati**, i giudizi del relatore no.

PARAMETRI CON VALORE
- **EA XT Prop Firms MT5:** prezzo **$600**; simboli dichiarati **EURUSD,
  GBPUSD, USDJPY**; versioni MT4 e MT5, "qualsiasi broker"; **rischio
  suggerito dallo sviluppatore: 5%** (input "risk percent"); test suggerito:
  **every tick**, deposito minimo **$1.000** [TRASCRITTO chiaro].
- **theforexpropfirm.com** [dichiarato dal relatore, NON verificato]:
  - **1-step:** rischio totale **6%**, rischio giornaliero **4%**, target
    **10%**, **niente giorni minimi né massimi** di trading;
  - **2-step:** rischio totale **12%** in fase 1 e fase 2, **NESSUN rischio
    giornaliero**, max **35 giorni** (fase 1) / **60 giorni** (fase 2);
  - **instant funding:** capitale 10k-200k, drawdown **5%**; il 200k instant
    costa **$10.000**; la challenge 200k ~**$900** (825+ secondo il piano).

MECCANISMI (di METODO, i più utili della scheda)
1. ✅ **Backtest misurato CONTRO il muro specifico della sfida**: col rischio 5%
   il max DD equity del backtest è **6,62%** > muro 6% → _"se l'equità va sotto
   6% perderei l'account"_ → **riduce il rischio e rimisura** (arriva a 5,32%)
   [TRASCRITTO]. È il nostro metodo (`METRO_PROP.md`) pronunciato ad alta voce.
2. ✅ **Test sulla finestra recente** (ultimo mese, poi da inizio maggio) per
   stimare se il target 10% è raggiungibile nel tempo reale della sfida:
   $970/mese e $2.820/2 mesi su 10k → _"dipende abbastanza da quando inizierai"_.
3. ✅ **Due diligence sul venditore**: una sola recensione negativa → Google del
   nome → **Forex Peace Army "guilty case" (79 guilty / 0 not guilty)** +
   "scammers hall of shame" + feedback negativi su Forex Factory [dichiarato,
   visto a schermo dal relatore]. Conclusione del relatore: backtest
   "troppo ottimizzato", l'EA non farà come il test.

REGOLE PROP CITATE
- Vedi sopra (theforexpropfirm.com). Nota del relatore: senza max giorni,
  _"non mi forza a correre... c'è più tempo per l'EA di raggiungere il 10%"_.

NUMERI DI PERFORMANCE [dichiarato, NON verificato]
- Backtest full history ~**$300k** di profitto — che il relatore STESSO
  giudica _"sembra un'ottimizzazione"_ e poi smonta con la due diligence.

BANDIERE ROSSE
- 🔴 **Il venditore dell'EA XT ha un dossier FPA "guilty" 79-0** e recensioni
  che dicono _"i risultati non hanno nulla a che fare con il backtest"_. È il
  caso da manuale del §1D del dossier: **"prop-ready" nel marketing non
  garantisce niente** — e stavolta nemmeno il backtest del recensore lo salva.
- ⚠️ [INFERITO] **Rischio 5% per trade suggerito dal vendor contro un muro
  giornaliero del 4%**: aritmetica — UN solo stop pieno buca il daily. Il
  DD 6,62% misurato dal recensore lo conferma.

COSA C'ERA A SCHERMO E NON NEL PARLATO
- La **lista input dell'EA** ("voglio imparare di più sulle input... ce ne sono
  molte"): mostrata, **non dettata**. La pagina prezzi completa della prop.

COSA NE COPIAMO
- **Il metodo, non l'EA:** (a) DD del backtest contro il muro esatto della
  sfida, con riduzione del rischio finché ci sta (già nostro metro); (b) la
  **checklist di due diligence sul vendor** (recensioni → Google del nome →
  FPA → Forex Factory) come passo formale prima di considerare qualunque EA di
  mercato; (c) la voce **theforexpropfirm 1-step 4%/6%** come ennesimo caso di
  muro daily al 4% — da verificare col supporto se mai interessasse (regola D3).

---

# 🗑️ GLI SCARTI (dichiarati, col motivo)

- **`Why This... Survives` (Scheda 11):** file **troncato**, nessun parametro.
  Serve la ri-trascrizione completa.
- **`Top 3 Prop Firms` (Scheda 10):** video affiliato, nessun meccanismo tecnico,
  giudizi che non pesano. Trattenuto solo il dato FundedTrading+ (incerto).
- **`Profitable EA - Stop Loss` (Scheda 5):** stessa fonte della Scheda 2 → il
  concetto non conta come fonte in più; nessun `.set`.
- **Secondo zip (18/08 sera):** conteneva 2 file; uno era un **doppione
  byte-per-byte** di `Prop EA Review How to Pass Prop Firm Challenges` (già
  Scheda 6) → scartato senza rianalisi. L'altro è la Scheda 12.

---

# 🕳️ COSA NON HO POTUTO VEDERE — i buchi

1. **Nessun `.set` / nessun default numerico** è mai stato **dettato ad alta
   voce** in nessuno degli 11 video. Tutti i pannelli sono mostrati a schermo:
   servono gli **screenshot** (elencati nella sintesi). Le trascrizioni, da sole,
   danno **concetti e trucchi, pochissimi numeri di config.**
2. **La trascrizione `Why This... Survives` è troncata** — la parte col prodotto
   manca.
3. **Speech-to-text pessimo su alcuni video** (Scheda 2: "vantaggiatura" =
   edge/leverage confusi; il "~4%" è [TRASCRITTO dubbio]). I numeri critici li ho
   marcati dubbi dove il contesto non li conferma.
4. **Nessuno dei 4 EA schedati** (FX JetBot, famiglia Dark, Infinity Trader,
   UnitedEuro) è nominato: **zero incrocio diretto** col §1D del dossier.
5. **Nessun orario di reset del muro, nessun fuso di reset, nessuna finestra news
   in minuti** è dettato: i tre punti caldi "operativi" di Claudio restano
   **non confermati dal parlato.**
