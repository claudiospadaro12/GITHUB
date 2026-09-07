# 🔧 TRASFORMAZIONI CANDIDATE — i caduti che vale la pena CAMBIARE

_Mandato diretto di Claudio, 07/09/2026, testuale:_
> **"MAGARI TRA QUELLI SCARTATI ABBIAMO QUALCUNO CHE POTREBBE DAVVERO ESSERE
> UTILE E TRASFORMARLO IN VINCENTE."**

---

## 0. 🚦 CHE COS'È QUESTO DOCUMENTO — e cosa NON è

| | |
|---|---|
| ✅ **è** | la lista dei caduti per cui esiste un **MECCANISMO o una GESTIONE diversa** che li rimetterebbe in gioco, con il Passo 0 che li misurerebbe e i cancelli congelati PRIMA |
| ❌ **non è** | una ri-ottimizzazione. Nessuna griglia nuova su un motore morto. La `REGOLA DELLA SECONDA CACCIA` (CLAUDE.md, 19/08) lo vieta, e il motivo è misurato: *"su un motore 0/48 un'altra griglia trova solo picchi di rumore — la cella «verde per caso» è quella che brucia la challenge"* |
| ❌ **non è** | `report/CORSIA_DEMO_CANDIDATI.md` (chi può andare in demo **così com'è**), né `report/PIANO_PROP.md`, né il censimento delle sedie **in campo**. Quelli rispondono a un'altra domanda |
| 🚫 **non promuove niente** | qui si **propone**. Decide Claudio. Nessun EA toccato, nessun preset toccato, nessun backtest lanciato, nessun parametro di forward sfiorato |

**Il filtro che ho applicato a ogni caduto — tre domande, in quest'ordine:**

1. **L'inefficienza che cercava esiste ancora?** Se una lapide misurata la nega
   (fade post-news, salto statistico, numeri tondi, sweep di micro-pivot,
   fix valutari, asta LBMA…) → **non c'è niente da trasformare**.
2. **È morto di MOTORE o di CONTORNO?** Se l'ablazione ha smontato l'ingrediente
   (Chaos LLE), se non generava segnali (M0PB 12/12), se è un doppione
   smascherato (BreakinBox = R95 con un livello nuovo) → **niente da fare**.
3. **Se è morto di contorno: il pezzo da cambiare è un MECCANISMO, o è un
   parametro?** Se è un parametro, la riga non entra.

**Risultato: 4 trasformazioni proposte. Zero richiedono un EA nuovo** — sono
tutte interruttori o riparazioni su EA che esistono già e sono già collaudati.
Undici altri caduti sono stati esaminati e **scartati con motivo** (§6).

---

## 1. 🎯 LE DUE LEVE MISURATE SU CUI POGGIA TUTTO IL DOCUMENTO

Non sono idee mie: sono due misure di casa, entrambe recenti, che **nessuno dei
caduti qui sotto aveva davanti quando è stato giudicato**.

### 1.1 🥇 LEVA A — **LIMIT contro STOP.** Non è "pendente contro mercato"

- un **BUY LIMIT** si riempie al prezzo chiesto **o migliore** → slippage in
  ingresso **zero per costruzione**;
- un **BUY STOP** è un **ordine a mercato differito**: si riempie al prezzo
  chiesto **o peggiore**, e lo slippage se lo prende tutto.

**Le prove in casa, verificate nel sorgente (non nella descrizione):**

| fatto | dove | riga |
|---|---|---|
| la sedia viva **770101** entra con `BuyLimit` in modo RETEST | `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` | **1504** |
| e il commento lo dice: *"limit sul livello (niente buffer/slippage)"* | idem | **1487** |
| l'intestazione dell'input: *"06/08: era BREAKOUT. Unico motore in utile fuori campione con campione vero (+392,96 · PF 1,065 · 244 trade)"* | idem | **261** |
| la sedia viva **770611** entra con `BuyStop` → esposta in pieno | `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` | **456** |
| in **R118** la corsa `c` (RETEST) è l'unica **senza asse di slippage**, e la raccomandazione 3 dice che portarcelo richiederebbe di toccare **la riga 1487** | `backtest_pipeline/risultati_archivio/REFERTO_R118_PAVIMENTO_STOP.md` | §5, racc. 3 |

**🔬 E l'A/B esiste già, sullo stesso banco, stessa finestra, stessa gestione,
cambiando SOLO il modo d'ingresso** — `backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_B_C5.md`
(06/08/2026, 48 passate a tick reali, IS 26/09/2024→30/06/2025, OOS 01/07/2025→30/06/2026):

| mercato | motore | IS | OOS | PF OOS | n OOS | DD OOS |
|---|---|---:|---:|---:|---:|---:|
| **DAX** | BREAKOUT (STOP) | +1352,27 | **−225,44** | 0,966 | 243 | 14,54% |
| **DAX** | **RETEST (LIMIT)** | +807,30 | **+392,96** | **1,065** | 244 | **13,32%** |
| **NASDAQ** | BREAKOUT + volumi | +147,61 | +122,28 | 1,063 | 108 | 4,13% |
| **NASDAQ** | **RETEST + volumi** | +332,40 | **+274,35** | **1,109** | 94 | **3,68%** |

👉 **Su due mercati indipendenti, cambiando solo STOP→LIMIT, il profitto OOS
migliora e il drawdown OOS scende.** Sul DAX il segno si ribalta.

### 1.2 💸 LEVA B — **la frontiera del costo**, e gli spread MISURATI

Da `backtest_pipeline/caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6,
costruita sul cancello **H8** (`report/FIRME_2026-08-31.md`, FIRMA 2: E ≥ 0,075R):

- pedaggio di una operazione, in R = `spread ÷ stop_in_punti`
- 🧱 **pavimento DURO**: `stop ≥ 13,3 × spread` (sotto, non si prova nemmeno)
- 🎯 **pavimento DI LAVORO**: `stop ≥ 40 × spread`

Spread **MISURATI** (`backtest_pipeline/risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`,
252 milioni di tick BCM, % solo-bid 0,000%):

| simbolo / fascia | spread mediano | 🧱 DURO | 🎯 DI LAVORO |
|---|---:|---:|---:|
| D30EUR in sessione 8-16 srv | **1,6-1,7** pt idx | 21-23 pt | 64-68 pt |
| **D30EUR di NOTTE** (fuori sessione) | **3,5-3,9** pt idx | **47-52 pt** | **140-156 pt** |
| **D30EUR, la pendente delle 07:59** | **~2,8** pt idx | **37 pt** | **112 pt** |
| U30USD 14-20 srv | 1,9-2,0 pt idx | 25-27 pt | 76-80 pt |
| NASUSD 14-20 srv | 1,6-1,8 pt idx | 21-24 pt | 64-72 pt |
| **EURUSD / GBPUSD / USDJPY** | 🔴 **NON MISURATO** (H12 / M36 aperte) | — | — |

> 🎯 **Perché queste due leve insieme cambiano il quadro:** la leva A dice
> *quanto meglio entro*; la leva B dice *quanto vale, in R, ogni punto
> guadagnato in ingresso*. **Un buffer d'ingresso di 10 punti indice su uno
> stop al pavimento di lavoro (112 pt) vale 0,089R — cioè più dell'intero
> cancello H8 (0,075R).** Non è un dettaglio di esecuzione: **è tutto il
> margine che stiamo cercando.**

---

## 2. 🥇 T1 — `ABTG_Nightly` (FADE del box notturno) su **D30EUR · U30USD · XAUUSD**

### 2.1 Chi era e di cosa è morto

| | |
|---|---|
| **verdetto agli atti** | *"**ABTG_Nightly** · screening **0/8 promossi** · Nemmeno una cella OHLC positiva in entrambe le finestre su 8 mercati. Capitolo chiuso, 9 bocciature totali contando EURUSD."* — `backtest_pipeline/risultati_archivio/REFERTO_CODA_FASCIA_B.md` r.29 |
| 🔴 **ma il verdetto su 3 di quegli 8 mercati NON ESISTE** | `backtest_pipeline/caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md` §6.3, testuale: *"la bocciatura «Nightly 0/8» **non ha davvero misurato 8 mercati**. Ne ha misurati **3** (EURUSD, GBPUSD, USDCHF, ~160 trade a testa) e ne ha lasciati **5 senza un solo ordine**. Su forex il verdetto regge; su indici e oro **non esiste, non è negativo**."* |
| **la causa, VERIFICATA NEL SORGENTE** | `mql5/Experts/ABTG_Nightly.mq5`: r.**72** `input double InpMaxNightVolPips = 45;` · r.**199-201** `NightH1Vol()` ritorna `ATR(H1)/PipSize()` · r.**107-111** `PipSize()` ritorna `_Point` quando i decimali **non sono 3 o 5** — cioè su indici e oro · r.**213** `if(qb>=InpMaxNightVolPips){ … return(true); }` |
| **conseguenza meccanica** | su D30EUR/U30USD/XAUUSD `qb` esce **in punti** invece che in pip → è **sempre ≥ 45** → l'EA esce con *"QB alto: escluso"* **ogni singola notte**. **Zero ordini piazzati in tutta la storia.** Confermato indipendentemente da `backtest_pipeline/risultati_archivio/CENSIMENTO_REGOLA_FINESTRA.md` §4: *"17 coppie fanno ZERO trade… **`Nightly` su 6**"*, e i 6 sono U30USD, D30EUR, XAUUSD, AUDUSD, USDJPY (+1) — gli ultimi due **bloccati di proposito** da `NightActiveSymbol()` (r.115-116, regola voluta) |

### 2.2 L'inefficienza che cercava — esiste ancora?

**Sì, e non è colpita dalla misura che sembra colpirla.** La distinzione è già
agli atti in `ANALISI_NIGHTLY_PDF_2026-08-23.md` §6.4, scritta contro il nostro
stesso archivio:

| meccanismo | colpito dalla misura di casa (`NOTTE_ORO.md`, 371 notti XAUUSD: rompe il max 49,9% · rompe il min 41,2% · **resta dentro 8,9%**)? |
|---|---|
| **BREAKIN** (entra da un lato, TP al lato opposto) | 🔴 **colpito in pieno** — riesce nell'8,9% delle notti. *(E infatti `BreakinBox` è stato chiuso a tick il 31/08.)* |
| **FADE a LIMIT sul bordo, TP verso il CENTRO** (= questo EA, `InpTPfrac=0.5`) | 🟡 **NON colpito.** La misura conta le notti che restano dentro; un fade con TP a metà range può vincere **prima** che il box venga rotto. *"Dire il contrario sarebbe barare"* |
| **BREAKOUT** | 🟢 confermato (91,1% delle notti rompe un lato) — ed è la sedia viva `MaxMinNotte` |

E riempie un **buco di portafoglio dichiarato**: il fade è il meccanismo che
lavora **nel laterale**, dove il resto della flotta muore (LARRY **−6.445** nel
2019, `report/ROBUSTEZZA.md`), ed è **il meccanismo opposto** alla sedia viva
`MaxMinNotte` sullo **stesso livello** — complementare, non doppione
(già annotato come proposta n.4 in `CENSIMENTO_LATI_SHORT_2026-08-25.md` §5 il
**25/08**, e mai eseguita da 13 giorni).

### 2.3 🔧 LA TRASFORMAZIONE — **la soglia di volatilità diventa RELATIVA**

Non è "alzare 45 a un altro numero". È **cambiare l'unità di misura del
cancello**, che oggi è una costante senza dimensione fisica:

```
oggi     qb = ATR(H1) / PipSize()        confronto con una costante in "pip"
domani   qb = ATR(H1) / ampiezza_box     (adimensionale)
   oppure qb = ATR(H1) / mediana_ATR(H1) delle ultime N notti   (adimensionale)
```

È **esattamente la regola candidata che quel referto ha già scritto**
(`ANALISI_NIGHTLY_PDF_2026-08-23.md` §9.3): *"le soglie di volatilità si
scrivono in ATR relativo, mai in punti o pip assoluti — costo di ignorarla, già
pagato: **3 mercati spenti in silenzio**"*. Ed è la stessa lezione di **R55**
(«lo spread si scrive come percentuale dello stop, non in punti»).

### 2.4 ⚖️ PERCHÉ NON È CURVE FITTING

- **Non tocco nessun parametro del motore.** Ingresso, SL, TP, orari, offset dal
  bordo: tutti invariati. Cambia **la formula di un cancello**, da una grandezza
  dimensionata (pip) a una adimensionale.
- **Non c'è un numero da tarare sui dati passati**, perché **non ci sono dati
  passati**: su questi tre mercati l'EA non ha mai piazzato un ordine. Non sto
  cercando una cella verde in una griglia già vista — **sto rendendo eseguibile
  una misura mai fatta.** È lo stesso caso, già a verbale due volte, di
  `FiboH4` (banco rotto: `InpSymbols` vuoto, §2-bis del registro) e di
  `ABTG_PostNews` (`Trades 0` su 4 CSV, §2-ter): **un verdetto inesistente non
  si difende, si esegue.**
- **La direzione della correzione è dichiarata prima e non dipende dall'esito**:
  la soglia relativa la scelgo perché è **fisicamente giusta**, non perché fa
  passare qualcosa.

### 2.5 🧪 IL PASSO 0 — cancelli congelati PRIMA

**Banco:** OHLC M1 (screening, mai verdetto) su **D30EUR, U30USD, XAUUSD**;
`@DAQUANDO` da MISURARE con `scarica_storico.ps1` (sugli indici il pavimento
noto è **2024.09.26**, su XAUUSD la profondità **non è mai stata sondata** —
buco aperto da R86/R87 §2.0 e da G1-PAOLO). Rischio **0,65%**. Magic nuovi.

| # | cancello, scritto prima dei numeri | come passa | come boccia |
|---|---|---|---|
| **N0** | 🚨 **CANARINO — l'EA deve PIAZZARE** | ≥ 1 ordine piazzato per notte utile, contatore in chiaro nel log | **0 ordini = corsa da buttare, non risultato.** È il difetto che ha prodotto il "0/8" |
| **N1** | 💸 **la frontiera del costo, PRIMA di qualunque PF** | il **1R mediano in punti indice** dev'essere **≥ 47** su D30EUR (pavimento DURO alla fascia notturna, spread misurato 3,5-3,9) | sotto 47 → **scarto per aritmetica**, senza guardare nient'altro. ⚠️ Oggi `slDist = 1,0 × ATR(H1)` (r.221) e **quanto valga in punti nella fascia 23:00-04:59 NON è misurato**: è il primo numero che questa corsa deve produrre |
| **N2** | 🎯 **S0** (lo stesso che ha falsificato `ABTG_VwapRevert` il 03/09) | take lordo mediano / spread dell'ora **≥ 2,5** | sotto → capitolo chiuso, e **non si cerca un'altra taratura** |
| **N3** | campione | n ≥ 150 per finestra (Emendamento A) | sotto → **merito SOSPESO**, mai bocciato |
| **N4** | rischio (si legge a qualunque n, Emendamento B) | DD ≤ 10% **e** peggior giornata ≥ −5,0% | oltre → **bocciato per rischio**, e non si riapre |
| **N5** | 🧪 **controllo a INGRESSI CASUALI APPAIATI** (lezione 05/09) | il fade dev'essere **sopra** il lato opposto sulla stessa barra | delta ≤ 0 → è la geometria, non il mercato: **scarto** |

**Previsione dichiarata PRIMA:** l'esito più probabile è **N1 che boccia sul
DAX** (uno stop da 1×ATR(H1) notturno contro un pavimento duro di 47 punti è una
gara dura) e **N3 sospensione** ovunque. 🟢 Se N1 passa, è la prima volta che
questo meccanismo viene misurato in tre anni di archivio.

### 2.6 💰 Costo · 🏛️ ottica prop

| | |
|---|---|
| **codice** | **1 input nuovo + ~6 righe** su un EA che esiste, compila e ha già i suoi collaudi. **NESSUN EA nuovo.** |
| **macchina** | 1 corsa di screening OHLC (~minuti) → **solo se N0+N1+N2 passano**, 1 corsa a tick reali |
| 🏛️ **prop** | **La fascia oraria è vuota nella flotta**: `ABTG_Nightly` piazza alle **05:00 server** e cancella alle **07:00** (r.53-56) — `MaxMinNotte` piazza alle **07:59**, le aperture alle **08:00**. Zero sovrapposizione di minuti. ⚠️ **Ma è lo STESSO LIVELLO** del box notturno della sedia viva 770411: due EA sullo stesso livello in direzioni opposte non sono scorrelati per costruzione, sono **anti-correlati** — e con il tetto per cluster firmato il 07/09 **ma NON ancora attivo nel Guardian**, questo va misurato prima di accendere, non dopo. ⚠️ Ingresso già **a LIMIT** (r.234/241): slippage d'ingresso zero per costruzione, il che lo rende **fra i pochi candidati compatibili con un DD trailing**. |

---

## 3. 🥈 T2 — `ABTG_PostNews`: da **due STOP** a **rottura + LIMIT sul bordo**

### 3.1 Chi era e di cosa è morto

`backtest_pipeline/REGISTRO_TEST.md`, sezione *"POSTNEWS — candidati A e B:
PASSO 0 CHIUSO, SENZA EDGE, 05/09/2026"*:

| cella | finestra | n | PF | profit | DD% |
|---|---|---:|---:|---:|---:|
| **A** ISM 15:15 srv, EURUSD (774701/774706) | IS 2010-2015 | 234 | **0,76** | −4.651,72 | 6,92 |
| | OOS 2015-2023 | 312 | **0,79** | −5.633,01 | 6,94 |
| **B** blocco 13:45 srv, USDJPY (774801/774806) | IS 2010-2015 | 151 | **0,66** | −4.084,87 | 4,75 |
| | OOS 2015-2023 | 253 | **0,90** | −1.979,08 | 4,56 |

Campione **pieno su tutte e 4 le letture** (nessuna sospensione: il verdetto è
leggibile ed è negativo). E il registro stesso apre la porta:
*"non si ritocca SL/TP sugli stessi dati per farli tornare verdi… si cerca un
**MECCANISMO diverso** sulla stessa inefficienza (fade, liquidity sweep,
**gestione a tempo**)."*

**La seconda caccia del 05/09 ha già bruciato tre di quelle strade**
(`caccia_strategie/CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md`, misure su 686
giornate-evento EURUSD e 683 oro, col controllo casuale):
- 🪦 **fade post-notizia: CHIUSO** (ISM PF 0,85 EURUSD / 0,73 oro; il segno si
  ribalta fra blocchi e simboli). *"Invertire una strategia perdente non è un
  meccanismo nuovo."*
- 🪦 **liquidity sweep sul range della notizia: CHIUSO** (terzo giro sulla stessa
  geometria dopo BreakinBox e R95).
- ⏱️ **uscita a tempo 30': UCCISA DALLA PROVA DELL'EPOCA** (84% del profitto dal
  20% del campione, e sono i due anni più vecchi; +0,36 pip su stop 25 =
  **0,014R** contro il cancello 0,075R).

👉 **Restava una sola strada non battuta, ed è la LEVA A: l'INGRESSO.**

### 3.2 L'inefficienza esiste ancora?

**Sì, ed è l'unica della famiglia news che una misura esterna sostiene.**
`arXiv 2605.04004` §4.7 (993 eventi, MNQ, barre da 5 minuti): la deriva è
**reale nelle prime cinque barre** e le T-statistiche stanno fra 0,14 e 0,69
**da barra +6**. Correzione già a verbale il 03/09: barre da 5 minuti ⇒
**reale nei minuti 0-25, morta dal minuto 30**. `ABTG_PostNews` agisce a
**news+10 / news+15** — cioè **dentro** la finestra viva.
⚠️ Non è una promozione: l'autore attribuisce quella deriva **al salto stesso**.
È il motivo per cui questo resta un Passo 0, non un round.

### 3.3 🔧 LA TRASFORMAZIONE — verificata riga per riga nel sorgente

Oggi, `mql5/Experts/ABTG_PostNews.mq5`:

| pezzo | riga | valore |
|---|---|---|
| range = max/min di **2 candele M5** | 318-320 | — |
| `InpBuyOffsetPips` / `InpSellOffsetPips` | **95-96** | **3,0 pip** oltre il bordo |
| `gTrade.BuyStop(...)` / `gTrade.SellStop(...)` | **342 / 352** | 🔴 **due ordini a mercato differiti, nel minuto peggiore del mese** |
| `InpSLpips` / `InpTPpips` | **97-98** | 25 / 50 pip (RR 2,0) |
| size calcolata su `InpRiskRefSLpips` | **114 / 325** | **50** = worst case del **doppio stop** |

**Domani (interruttore `InpEntryMode`, default = comportamento di oggi):**

```
1) il prezzo rompe  max + 3 pip   -> la rottura è CONFERMATA (il livello non cambia)
2) si piazza un BUY LIMIT ESATTAMENTE SUL BORDO (max), non 3 pip sopra
3) SL e TP restano alle STESSE DISTANZE (25 / 50 pip): R invariata
4) si arma UN SOLO LATO — quello che ha rotto per primo
```

### 3.4 ⚖️ PERCHÉ NON È CURVE FITTING — **e qui c'è un'aritmetica, non un'opinione**

1. **Il guadagno è calcolabile prima di girare qualsiasi cosa.** Entrare
   **3 pip meglio** con la **stessa distanza di stop** (25 pip) vale
   **3 ÷ 25 = 0,12R per operazione**. Il cancello H8 è **0,075R**.
   👉 **La sola correzione dell'ingresso vale 1,6 volte l'intero cancello di
   merito, e non dipende da nessun dato passato.**
2. **In più c'è lo slippage, che oggi non è nemmeno modellato.** Un ordine STOP
   che scatta 10-15 minuti dopo un dato macro si riempie *al prezzo o peggio*,
   nel momento di libro più sottile del mese. Un LIMIT si riempie *al prezzo o
   meglio*. **[NON MISURATO su BCM: `ABTG_SlippageLogger` sul reale ha 0 deal,
   R118 §3.]** Non lo faccio pesare: lo dichiaro come margine in più, non come
   numero.
3. **Cambia la POPOLAZIONE dei riempimenti, non la taratura.** Oggi si riempie
   ogni giornata in cui il prezzo tocca il bordo+3. Domani si riempiono solo le
   giornate in cui il prezzo **rompe e poi ritorna**: è un insieme di eventi
   **diverso**, non lo stesso insieme pesato diversamente.
4. **Sparisce la ragione strutturale del doppio riempimento**, che è **misurata**:
   *"92/371 = **24,8%** (ISM) e 74/315 = **23,5%** (13:30) delle giornate
   riempiono ENTRAMBE le gambe. Senza OCO la giornata di whipsaw vale **−2,0R**
   mentre il trend pulito paga **+1,2R**: asimmetria STRUTTURALE contro la
   strategia"* (caccia 05/09). Un solo lato armato **non può** avere quella
   asimmetria. **[INFERITO dalla meccanica dell'ordine, non misurato.]**

> 🔴 **E COME PUÒ MORIRE — scritto prima, perché è l'obiezione forte.**
> `backtest_pipeline/righe/RIGA_PREOPEN_DOW_DA_MANDARE.md` la mette per iscritto
> già dal 06/09: *"il retest su livello giovane prende il **fallimento** della
> rottura, non la continuazione"*. Se il ritorno sul bordo succede soprattutto
> nelle giornate in cui la rottura **fallisce**, il LIMIT compra la parte
> peggiore della distribuzione e il PF **peggiora** invece di migliorare.
> **È esattamente ciò che il Passo 0 misura, e costa zero ore di MT5.**

### 3.5 🧪 IL PASSO 0 — gratis, e girabile da un agente OGGI

**Non serve MT5.** La macchina esiste già: `caccia_strategie/biblioteca/sonde_esterne/sonda_postnews.py`
(EUR_USD M1 Oanda, timestamp **UTC come il nostro calendario FF**, calendario
`biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv`, **686 giornate-evento**).
✅ **Controllo positivo del canale fatto oggi 07/09:** `raw.githubusercontent.com`
sul file `oanda-EUR_USD-2015-3.csv` → **HTTP 200, 1.650.996 byte**.

| # | cancello, congelato PRIMA | passa | boccia |
|---|---|---|---|
| **P1** | **quante volte il prezzo TORNA sul bordo** dopo averlo rotto, entro la finestra di scadenza | ≥ **50%** delle giornate che oggi si riempiono | < 50% → il retest dimezza il campione e la famiglia non arriva mai a n=150: **scarto** |
| **P2** | 🎯 **il confronto testa a testa, stesse giornate, stessa geometria** | R medio del **LIMIT sul bordo** > R medio dello **STOP a bordo+3** | ≤ → l'obiezione «il retest compra i fallimenti» è **confermata**: capitolo chiuso, e **non si prova un altro offset** |
| **P3** | 🧪 controllo a **ingressi casuali appaiati** (stessa barra, lato opposto) | il LIMIT dev'essere sopra il caso | ≤ → geometria, non mercato: scarto |
| **P4** | prova dell'epoca (la stessa che ha ucciso l'uscita a tempo) | il segno regge **spezzando 2010-2011 vs 2012-2020** | se l'80% del vantaggio viene dai due anni più vecchi → **scarto**, come il 05/09 |
| **P5** | 💸 frontiera del costo | **🔴 NON CALCOLABILE**: lo spread forex BCM **non è misurato** (H12/M36 aperte). A convenzione 1,0 pip lo stop da 25 sta **sopra il DURO (13,3) e sotto il DI LAVORO (40)** | va **dichiarato accanto a ogni numero**, non nascosto |

⚠️ **Limiti da scrivere accanto a ogni cifra:** non è BCM, è OHLC M1 non tick,
**zero costi**, finestra 2010→2020-05 che **non copre il regime delle sedie**, e
**USD_JPY non esiste sulla fonte esterna (404 vero)** → il blocco B si misura su
EURUSD, non sul simbolo della cella bocciata. **Misure di occasioni, mai
verdetti (F6).**

### 3.6 💰 Costo · 🏛️ ottica prop

| | |
|---|---|
| **Passo 0** | **~1 ora di agente, 0 ore di MT5.** Sonda Python già scritta, canale verde oggi |
| **poi, se P1-P4 passano** | 1 input `InpEntryMode` + **~30 righe** su un EA esistente, autotestato, con OCO vero e rischio in % (`ABTG_PostNews.mq5` v1.10). **NESSUN EA nuovo** |
| ⚠️ **una cosa alla volta** | nel confronto la size resta ancorata a `InpRiskRefSLpips = 50` (**invariata**). Con un lato solo quel riferimento non serve più e la posizione raddoppierebbe a parità di rischio dichiarato: **è una decisione di rischio separata, non si muove insieme all'ingresso** |
| 🏛️ **prop** | ⚠️ **FTMO Account Standard vieta di aprire O CHIUDERE ±2 min dal rilascio.** news+10/+15 è compatibile; ma *"un EA che entra a news+10 può avere lo SL colpito dentro la finestra ±2 min dell'evento SUCCESSIVO, e con **43 giorni l'anno a ≥4 eventi high** non è teorico"* (caccia 03/09). 👉 **Un EA news FTMO-compatibile ha bisogno del calendario per USCIRE, non solo per entrare** — e oggi non ce l'ha. 🟢 In compenso: un lato solo invece di due dimezza il rischio aperto per evento, che sul cap C1 (3,25%) conta |

---

## 4. 🥉 T3 — `ABTG_PostNews`: il **CONTENITORE**, per far esistere un verdetto

_Indipendente da T2. Si possono firmare separatamente, ma girano nello stesso round._

### 4.1 Il problema, in una riga di aritmetica

`ABTG_PostNews` in configurazione viva vede **16 eventi/anno** (8 FOMC + 8 ECB).
Con la regola dei **150 per finestra** (Emendamento A) servirebbero **~19 anni**
per IS+OOS. 👉 **Non è un motore che ha fallito: è un motore che non può essere
giudicato.** E ogni round che gli abbiamo dedicato è stato speso su campioni
comprati allargando la lista eventi a mano, uno per volta.

### 4.2 🔧 LA TRASFORMAZIONE — leggere **l'ora dell'evento dal CSV**

Oggi l'ora d'azione è una **costante dell'istanza**:
`mql5/Experts/ABTG_PostNews.mq5` r.**74-75** `InpActionHour = 14` / `InpActionMin = 0`,
usata a r.**243** `if(now.hour!=InpActionHour || now.min!=InpActionMin) return;`.
Un'istanza = **un orario** = **una famiglia di eventi**.

**Domani:** l'ora si legge **dalla riga del calendario** (il CSV ce l'ha già:
`NewsToday` fa già match sulla data). Una sola istanza copre tutti i blocchi
orari, e il campione si **pool**a.

**Il numero che lo giustifica** — contato il 05/09 sui CSV di casa
`caccia_strategie/biblioteca/dati/` (**1.667 eventi USA ad alto impatto con
forecast E actual, 2021.01.05 → 2024.10.29**):

| blocco | giornate distinte |
|---|---:|
| 13:30 srv | 220 |
| 15:00 srv | 138 |
| Jobless Claims | 199 |
| 15:00 + Claims (si sovrappongono solo 18 volte) | 319 |
| **tutti e tre** | **452** in 3,8 anni |

> 🎯 **452 giornate poolate = 226 IS + 226 OOS = la PRIMA volta che la famiglia
> news vede il pavimento dei 150.** *(citazione dalla caccia del 05/09, verificata
> sui conteggi di quel dossier)*

### 4.3 ⚖️ PERCHÉ NON È CURVE FITTING

- **Non tocco un solo parametro del motore.** Non tocco SL, TP, offset, orario di
  scadenza, filtri. **Cambio il contenitore, non il contenuto.**
- **Un campione non è un parametro.** Aumentare n non sposta il risultato verso
  il verde: lo rende **leggibile**. Se il motore è a PF 0,76, con 452 giornate
  sarà a PF 0,76 con un intervallo di confidenza stretto — cioè **una
  bocciatura definitiva invece di una sospensione eterna.** 🎯 **Questa
  trasformazione può benissimo UCCIDERE la famiglia, ed è un buon esito.**
- ⚠️ **La tensione va dichiarata, non aggirata:** poolare eventi eterogenei
  (NFP, CPI, ISM, Claims) assume che reagiscano allo stesso modo, e **non lo
  sappiamo**. Il criterio da congelare prima: **il risultato si legge anche
  spezzato per famiglia di evento**, e se il segno cambia fra famiglie, **il
  pool non è legittimo e il round è nullo**.

### 4.4 🧪 IL PASSO 0

| # | cancello, congelato PRIMA | passa | boccia |
|---|---|---|---|
| **C1** | 🚨 **canarino del calendario** (classe già pagata, §2-ter) | riga in chiaro `[NEWS] letto da … UTILI per questo preset **N** | dal … al …` con **N > 0** | **N = 0 → corsa da buttare.** È il difetto che produsse `Trades 0` su 4 CSV |
| **C2** | 🐛 **CLASSE 129** | le celle gemelle devono uscire **identiche al centesimo** → **un solo agente MT5 locale** (`Get-Process metatester64` in loop, max nel referto) | > 1 processo tester vivo → **round fermo**, qualunque numero sia uscito |
| **C3** | campione | n ≥ 150 per finestra, **poolato** | sotto → il contenitore non ha fatto il suo lavoro |
| **C4** | 🎯 **coerenza del pool** | stesso **segno** di E su tutte le famiglie di evento | segno che cambia → **pool illegittimo, round nullo** (non "risultato misto") |
| **C5** | rischio | DD ≤ 10% e peggior giornata ≥ −5,0% | oltre → bocciato, a qualunque n |
| ⚠️ **C0** | 🔴 **prima di tutto**: `InpRiskPercent` di default è **3,0** (r.113) | va rimesso a **0,65** prima di qualunque confronto | altrimenti i numeri non sono confrontabili con niente in casa |

**Prerequisito dati:** il CSV con forecast/actual copre **2021-2024**; il
calendario `abtg_news_postnews_2010_2025_UTC.csv` (599 eventi) copre 2010-2025
ma **senza** actual. Per il pool serve **solo l'ora**, che c'è in entrambi.
🔧 Attrezzo già censito e mai letto nel sorgente: **`Economic Calendar CSV`,
Code Base 52977** (Stanislav Korotky) — fa la correzione di **ora legale** sui
timestamp storici, cioè il difetto DST misurato il 04/09 (**10 NFP su 174 a
12:30 invece che 13:30**). ⚠️ **Sorgente non letto: va letto prima di girarlo**
(lezione 55630).

### 4.5 💰 Costo · 🏛️ ottica prop

| | |
|---|---|
| **codice** | **~40 righe** su `ABTG_PostNews.mq5` (leggere ora/minuto dalla riga di calendario invece che dall'input) + il canarino. **NESSUN EA nuovo** |
| **macchina** | 1 corsa di screening OHLC + 1 a tick, **a un agente solo** |
| 🏛️ **prop** | 🔴 **è anche il round che misura il rischio vero della famiglia**: con 452 giornate si vede **quante volte due eventi cadono nella stessa settimana** e quanto vale la peggior giornata. Oggi, con 16 eventi l'anno, quel numero **non esiste**. E con **43 giorni/anno a ≥4 eventi high**, un motore news poolato è **il candidato più a rischio di sfondare il muro giornaliero** della flotta: meglio saperlo su 452 giornate che su una challenge |

---

## 5. 🏅 T4 — `ABTG_MaxMinNotte`: **LIMIT sul livello** invece di **STOP oltre il buffer**

_(sulle gambe **CADUTE**. La sedia viva 770411 **non si tocca**: banco separato, magic nuovi.)_

### 5.1 Chi era e di cosa è morto

`backtest_pipeline/REGISTRO_TEST.md`, *"MaxMinNotte — rottura range notturno
all'apertura europea (26/07/2026, real-tick)"*:

| gamba | miglior config | PF | esito |
|---|---|---:|---|
| **D30EUR SHORT** | buffer 1000, corr S&P ON | **2,05** | 🟢 **VIVA** — sedia 770411, `report/ROTTA_PROP.md` la dà a DD OOS **1,88%** / PF **2,192**. **NON SI TOCCA** |
| **D30EUR LONG** | — | — | 🔴 **morto** (`CENSIMENTO_LATI_SHORT_2026-08-25.md` §2 punto 10: *"sweep 26/07: morto; la famiglia vive SOLO short"*) |
| **100GBP (FTSE)** | — | max **0,67** | 🔴 morto |
| **F40EUR (CAC)** | — | max **~1,0** | 🔴 morto |
| **E50EUR (Stoxx50)** | — | max **0,59** | 🔴 morto |

CSV agli atti: `risultati_archivio/MaxMinNotte/efe054b5-valid_MaxMin_100GBP.csv`,
`4528c79b-valid_MaxMin_F40EUR.csv`, `8eefb007-valid_MaxMin_E50EUR.csv`.

### 5.2 L'inefficienza esiste ancora?

**Sì, ed è la più solida che abbiamo misurato sulla notte:** *"il **BREAKOUT**
del box è confermato dal PDF e dalla misura di casa (**91,1% delle notti rompe
un lato**, `NOTTE_ORO.md`)"* (registro, 23/08). Non è in discussione **che** il
box si rompa. È in discussione **come ci entriamo**.

### 5.3 🔧 LA TRASFORMAZIONE — e il numero che la giustifica è brutale

Verificato nel sorgente, `mql5/Experts/ABTG_MaxMinNotte.mq5`:

| pezzo | riga | valore |
|---|---|---|
| `InpBufferPoints` | **140** | **1000 punti MT5 = 10 punti indice** oltre il max/min della notte |
| `gTrade.BuyStop(...)` / `gTrade.SellStop(...)` | **355 / 367** | 🔴 **due ordini a mercato differiti** |
| piazzamento / cutoff | **126-129** | **07:59 srv** → cutoff **08:30 srv** = **il minuto di apertura del DAX cash** |
| SL | **145-148** | `MM_SL_ATR`, `1,5 × ATR(M15)` (la cella viva gira a **2,5**) |

**Domani:** il buffer resta **come conferma della rottura** (identico ruolo che
ha nel modo RETEST della sedia 770101: r.**264** del `.mq5` DAX, *"Col retest NON
è dove si entra: si entra sul livello"*), e l'ingresso diventa un **LIMIT sul
livello del box**.

> ### 💰 **QUANTO VALE, IN R — e il calcolo non dipende da nessuna cella**
>
> Lo spread misurato per **la pendente delle 07:59 su D30EUR è ~2,8 punti
> indice** (`SPREAD_FLOTTA_MISURA_2026-09-03.md`). La frontiera del costo dà
> quindi, su questa sedia: 🧱 pavimento DURO **37 punti** · 🎯 pavimento DI
> LAVORO **112 punti**.
>
> | stop usato | i 10 punti di buffer valgono | contro il cancello H8 (0,075R) |
> |---|---:|---|
> | al pavimento DI LAVORO (112 pt) | **0,089R** | 🟢 **1,19 ×** |
> | al pavimento DURO (37 pt) | **0,270R** | 🟢 **3,60 ×** |
>
> 🎯 **Qualunque sia lo stop, purché legale, i 10 punti che oggi regaliamo
> all'ingresso valgono PIÙ dell'intero cancello di merito.** E questo **prima**
> di contare lo slippage di un ordine STOP nel minuto d'apertura, che è
> [NON MISURATO] ma va nella stessa direzione.

### 5.4 ⚖️ PERCHÉ NON È CURVE FITTING

- **Non è il fade e non è il breakin.** Il LIMIT sul livello va **nella stessa
  direzione della rottura**; `BreakinBox` (chiuso a tick il 31/08: PF 1,007 DD
  24,1% · controllo PF 1,106 DD 19,7%) va **nella direzione opposta**. Sono due
  meccanismi diversi, e confonderli sarebbe l'errore da evitare qui.
- **Non muovo `InpBufferPoints`.** Resta **1000**. Cambia **a cosa serve**: da
  *prezzo d'ingresso* a *soglia di conferma*. È un cambio di ruolo di una
  variabile, non una nuova taratura.
- **Ha già un precedente misurato su due mercati indipendenti** (§1.1): la
  stessa sostituzione, sullo stesso tipo di livello orario, ha ribaltato il
  segno OOS sul DAX e migliorato PF **e** DD sul Nasdaq.
- **La direzione dell'effetto è dichiarata prima**: entrare 10 punti meglio con
  lo stesso stop **non può** peggiorare il singolo trade riempito. L'unico modo
  in cui può perdere è **riempirsi meno spesso** — e quello si conta, non si
  ottimizza.

### 5.5 🧪 IL PASSO 0

**Banco:** tick reali, `@DAQUANDO` **2024.09.26** (pavimento misurato sugli
indici, `REFERTO_WALKFORWARD.md`), rischio **0,65%**, magic vergini.
**Gambe: 100GBP · F40EUR · E50EUR · D30EUR LONG.** ⚠️ Su 100GBP/F40EUR/E50EUR lo
**spread BCM non è misurato** → prima colonna del referto obbligatoria.

| # | cancello, congelato PRIMA | passa | boccia |
|---|---|---|---|
| **M1** | 📊 **il conteggio, prima del merito** | quante notti rompono **e ritornano** sul livello entro il cutoff 08:30 | se il ritorno avviene in **< 40%** delle notti che oggi si riempiono, il campione crolla sotto ogni soglia: **scarto** |
| **M2** | 🎯 **testa a testa sulle stesse notti** | R medio LIMIT-sul-livello > R medio STOP-a-buffer | ≤ → il ritorno seleziona le rotture false: **capitolo chiuso, nessun altro buffer** |
| **M3** | 💸 frontiera | 1R mediano ≥ **37 punti indice** su D30EUR (DURO alle 07:59) | sotto → scarto per aritmetica |
| **M4** | campione | n ≥ 150 per finestra | sotto → **merito SOSPESO** (non bocciato) |
| **M5** | rischio | DD ≤ 10% **e** peggior giornata ≥ −5,0% | oltre → bocciato, a qualunque n |
| **M6** | 🚫 **anti-doppione** | correlazione dei giorni di trade con la sedia **770411** | se opera **le stesse notti nello stesso verso** della sedia viva → è un doppione, non un candidato |

### 5.6 💰 Costo · 🏛️ ottica prop

| | |
|---|---|
| **codice** | interruttore `InpEntryMode` (BREAKOUT / RETEST), **~40 righe**, ricalcate su quelle già scritte e collaudate in `ABTG_DAX_Apertura_EU.mq5` r.1479-1516. 🔴 **Va fatto su una COPIA o dietro default invariato**: `ABTG_MaxMinNotte.mq5` è il padre della sedia viva 770411 sul demo 100k. **NESSUN EA nuovo da zero** |
| **macchina** | 1 corsa di conteggio (M1, OHLC, minuti) → poi 1 corsa a tick su 4 gambe |
| 🏛️ **prop** | 🟢 **Riempie il buco dichiarato il 07/09** (*"la portata la fa la LARGHEZZA… ci servono i motori che abbiamo GIÀ su più simboli"*): tre simboli nuovi su un motore già in casa. 🔴 **Ma il conflitto di cluster va detto subito**: 100GBP/F40EUR/E50EUR/D30EUR sono **tutti indici europei alla stessa ora**. Il tetto per cluster al 3,0% è **FIRMATO il 07/09 e NON ATTIVO nel Guardian** — finché non è implementato e collaudato è **un'intenzione, non una protezione**. 👉 **Se questa passa, entra UNA gamba, non quattro.** |
| ⚠️ **e una scelta da fare** | **T4 e T1 lavorano sullo stesso livello (il box notturno) e sugli stessi simboli.** Non sono da accendere insieme senza aver misurato la sovrapposizione. Sono due proposte, **non un pacchetto** |

---

## 6. 🪦 I CADUTI ESAMINATI E **SCARTATI** — uno per riga, col motivo

_Severità voluta: meglio 4 trasformazioni solide che 15 speranze._

| caduto | perché NON si trasforma | fonte |
|---|---|---|
| **`M0PB`** | **non genera segnali**: 12/12 alla sonda di conteggio, 0,52 seg./gg il lato migliore contro un pavimento di 1,00. Non c'è meccanismo da cambiare in un motore che non spara | `REFERTO_SONDAM0PB_2026-08-31.md` |
| **`Chaos Lyapunov`** | l'**ablazione** ha smontato l'ingrediente: il gate LLE morde **al contrario della tesi**, e la fascia buona è **1 cella su 105** | `REFERTO_CHAOS_2026-08-31.md` |
| **`BreakinBox`** | l'ablazione lo smaschera come **R95 con un livello nuovo**: la tesi (TP al lato opposto, PF 1,007 DD 24,1%) **perde contro il proprio controllo** (PF 1,106 DD 19,7%), e il controllo buca il cancello DD | `REFERTO_BREAKIN_2026-08-31.md` |
| **`R95` sweep+reclaim JPY** | **0/30**, PF 0,65-0,80, nessuna passata sopra 1,00, con **21.354 livelli creati e 0 buttati**: la densità non era il problema | `R95_REFERTO.md` |
| **`R89` LiquiditySweep** | era morto di **fame di livelli** (14 trade IS), e il livello che chiedeva (box notturno) **è stato dato e misurato**: è BreakinBox, chiuso. Porta chiusa due volte | `R89_CRITERI.md` + `REFERTO_BREAKIN` |
| **`ABTG_VwapRevert`** | **S0 NON PASSA su 4 celle su 4**, con rapporto punti/spread **negativo** (−0,11 / −0,21 / −0,14 / −0,21). La clausola congelata nella bozza chiude il capitolo *anche come motore*. **Il motore perde più dello spread: non è un problema di costo, è assenza di edge** | `risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt` |
| **`R116 LondonFx`** (3 motori × 2 simboli) | **bocciata PER RISCHIO** su tutti e sei: DD OOS 31-61%, IS già in perdita. E l'aritmetica che la uccide non si aggira con un ingresso: **1R = 8 pip, il costo vale 1,7-3,3 volte l'edge richiesto**. Un LIMIT non recupera 55 punti di DD | registro, sezione R116 |
| **`R117 RELATIVO D30EUR`** | **bocciata per rischio** (DD OOS 25,01%, peggior giornata **−5,20%**: due muri prop sfondati insieme). Il registro scrive esplicitamente *"NON si ritocca e NON si riprova con una finestra più lunga"*. Un rischio accaduto non si trasforma | registro, sezione R117 |
| **`CRT Turtle Soup`** | **non è trasformabile: è bloccato dai DATI.** È un motore da **chop** (2023 +5.259, 2022 +2.633; perde nel crollo e nel toro) e i tick BCM sono **21-24 mesi di solo toro**. Serve l'import Dukascopy, che è a **cancello chiuso** (§7) | `REFERTO_CRT_2026-08-30.md` |
| **`Londra_ORB` / `R45`** con l'orologio giusto | 🟡 **caso interessante e comunque NO.** Il fuso è stato misurato il 03/09 (*"Londra apre alle **08:00 ora server**"*) e quindi `Londra_ORB` ("06-07") e R45 ("07:00") **misuravano la pre-apertura**. Ma rifarli è **ORB su un'altra ora** = ~210 celle di famiglia sepolta, e la caccia del 03/09 chiude l'apertura di Londra *"in tutte e due le forme a livello"*. 👉 **L'alternativa vera sulla stessa inefficienza è già indicata e non è un range: è la DERIVA ORARIA** (EURUSD short 08:00-16:00 srv, C1 4,59 IS / 5,31 OOS) — ed è la **Sonda dell'Orologio ramo FX**, che è **pronta dal 28/08 e mai girata** (§7) | `CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md` §3 |
| **`Aperture` su NASUSD** | **sette ipotesi, sette bocciature**, e la settima con il retest già acceso: *"il Nasdaq d'apertura è chiuso come ricerca"*, scritto **prima** del test | `Walkforward_Aperture/REFERTO_FASE_M.md` |
| **`Aperture` su 100GBP / U30USD** (fase nuovi indici) | 🟡 **ho verificato l'archivio riga per riga e il retest lì non è mai stato provato** (`valid_Apertura_100GBP_FTSE.csv` e `valid_Apertura_U30USD_Dow.csv`: 96 righe ciascuno, `InpEntryMode` = **solo 0**). **Ma:** sul Dow il retest è **già la sedia viva 770202**, quindi sarebbe un doppione; su 100GBP il breakout dà PF 0,90 e il delta misurato del retest sul DAX vale ~+0,10 di PF → arriverebbe a **~1,00**. **Guadagno atteso troppo piccolo per un round, e stesso cluster di T4.** Registrato come gap dell'archivio, **non proposto** | mia scansione di **254 CSV** in `risultati_archivio/` |
| **`M31` salto statistico** | chiuso **per aritmetica su due timeframe**, e con la contro-prova che chiude la porta: *"l'edge per segnale è una **quantità fissa di ATR (~0,16)**, non un multiplo fisso di R — allargando lo stop l'edge in R si diluisce esattamente quanto il costo"*. Nessuna geometria salva l'aritmetica | `CACCIA_TF_M15_2026-09-05.md` |
| **`Live5m` / famiglia breakout M5** | chiusa **210 celle fa** e oggi si sa **perché**: su D30EUR M5 uno stop da 20 punti vale **0,0825R = 110% del cancello H8**, sotto anche il pavimento DURO. *"Non è «M5 è morto»: è «uno stop da 20 punti è morto»"* | `CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` §6.3 |
| **`ABTG_AltaVelocita`** | rosso **8/8** a tick e rosso di nuovo dopo l'unica iterazione dichiarata. Nessun meccanismo isolato da salvare | `REFERTO_ALTA_VELOCITA_V1.md` |

---

## 7. 🚧 COSA **NON È ROBA MIA** — ma va detto, perché vale più di metà di questo documento

Nessuno di questi è una **trasformazione**: sono **corse che mancano** o
**sblocchi**. Li elenco perché in almeno tre casi costano meno delle mie
proposte e valgono di più.

| # | cosa | perché non è una trasformazione | stato |
|---|---|---|---|
| 1 | **`ABTG_OutOfNoise`** — il momentum intraday di Zarattini-Aziz-Barbon | **non è bocciato, era ROTTO** (`CopyRates` contava barre di **calendario** invece che di **seduta**, n=0 su 3 celle) — e il baco è **già corretto** nel sorgente (v1.01 fix warmup, v1.02 diagnostica, r.102-111). **Non c'è niente da cambiare: c'è da farlo girare** | 🟢 **1 corsa** |
| 2 | **`SONDA DELL'OROLOGIO`, ramo FX** | 7 file prova pronti dal **28/08**, **zero referti** in archivio: mai girata. È *"il solo meccanismo FX a tenuta di ore con frequenza ≥1/giorno che il progetto possieda"*, e la seconda caccia di Londra la indica come **l'alternativa vera** al range | 🟢 **pronta, mai lanciata** |
| 3 | **`LONDONFX` R116-BIS** | riga e driver pronti dal 05/09 (banco pulito, un agente solo, classe 129) | ⚠️ non cambia il verdetto: da R116 **non esce una sedia** |
| 4 | **`RealCost Spread P95 Logger`** (Code Base 74148) | promosso il **23/08** e **mai usato**: è la **settima caccia** che lo scrive. Senza, **lo spread forex e oro BCM resta non misurato** e i cancelli P5 di T2 e mezzo documento restano su una convenzione | 🔴 **H12/M36 aperte** |
| 5 | **`Dukascopy` / `U30USD_DK`** | cancello **chiuso** per un solo giorno fuori soglia (**2024.11.20 a 0,0696%**). Il registro dà il passo esatto per capirlo (aprire un grafico U30USD M1 per scaricare i tick nativi di quel giorno e rilanciare `-SoloSonda`). 👉 **Sbloccarlo riapre DUE verdetti parcheggiati insieme: CRT-chop e NY-Retest slope75 (n=114)** | 🔴 in frigo |
| 6 | **le celle a MERITO SOSPESO** (`NY Retest` slope 75 · `DaxReEntry` LONG 6/6 · `R117 RELATIVO NASUSD`) | passano il **RISCHIO** e non hanno **n**. Non vanno cambiate: vanno messe dove si accumulano operazioni. **È la corsia demo sul piccolo 50503392**, ed è di un altro agente | ➡️ `CORSIA_DEMO_CANDIDATI.md` |
| 7 | **`InpUseOCO=false` sulle sedie PostNews vive** | il doppio riempimento al **24,8%** è misurato e l'asimmetria (−2,0R contro +1,2R) è strutturale. Ma `InpUseOCO` **è un input di una sedia in campo**: la tensione con la Regola della seconda caccia è **dichiarata, non aggirata**. **Decisione di Claudio, non mia** | ⚖️ aperto dal 05/09 |

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO PASSO DEVE RISPONDERE

Tutte e quattro le trasformazioni sono figlie della stessa ipotesi, e una sola
misura la falsifica o la conferma per tutte:

> ### 🎯 **«Quando un livello orario viene rotto, il prezzo ci TORNA abbastanza spesso da poterci entrare a LIMIT — e le rotture che tornano sono quelle BUONE o quelle FALSE?»**

- 🟢 **Se tornano spesso e sono buone**: T2 e T4 valgono, e la leva vale per
  ogni motore a livello che abbiamo. Il margine è già quantificato: **0,12R su
  PostNews · ≥0,089R su MaxMinNotte**, contro un cancello di **0,075R**.
- 🔴 **Se tornano spesso ma sono le rotture FALSE** (l'obiezione di
  `arXiv 2605.04004` già messa a verbale il 06/09): T2 e T4 **muoiono insieme**,
  e si scrive una volta per tutte che **il retest funziona sull'apertura del DAX
  per una ragione specifica di quel livello**, non come regola generale. Anche
  questo è un risultato che vale un round.
- ⚪ **Se non tornano quasi mai**: il campione crolla e la questione si chiude
  per frequenza, senza spendere un'ora di tick.

**E la cosa migliore è che questa domanda si può cominciare a rispondere
SENZA MT5:** la sonda `sonda_postnews.py` esiste, il canale dati è verde (**200,
1.650.996 byte, verificato oggi**), e il conteggio «rompe → torna → cosa fa
dopo» è la stessa riga di codice su qualunque livello orario.

---

## 9. 🚧 BUCHI DICHIARATI — cosa NON ho potuto verificare

- 🔴 **Spread BCM su forex, oro e sui tre indici europei minori: NON MISURATO**
  (H12/M36). Tutte le righe «frontiera del costo» di T2 e metà di T4 poggiano su
  una **convenzione**, e l'ho scritto ogni volta che compare.
- 🔴 **Slippage reale su BCM: NON MISURATO.** `ABTG_SlippageLogger` sul conto
  reale ha **0 deal** (R118 §3). Il vantaggio LIMIT-contro-STOP che deriva dallo
  slippage è **[INFERITO dalla meccanica dell'ordine]**, non misurato: **non l'ho
  fatto pesare in nessun cancello.**
- 🔴 **Profondità tick di XAUUSD: mai sondata** (aperta da R86/R87 §2.0). Il
  `@DAQUANDO` di T1 sull'oro **non si inventa**: si misura con
  `scarica_storico.ps1`, e finché non è misurato quella gamba non parte.
- 🔴 **Quanto vale in punti `1,0 × ATR(H1)` sul DAX fra le 23:00 e le 04:59:
  non misurato.** È il primo numero che il Passo 0 di T1 deve produrre, ed è il
  cancello che può ucciderlo subito.
- ⚠️ **Non ho eseguito alcun backtest** (MT5 sta solo sul PC di Claudio) e non ho
  toccato EA, preset, file prova, righe di lancio o forward. **Le uniche cose
  che ho eseguito** sono letture di file del repo, una scansione di **254 CSV**
  di `risultati_archivio/` per la colonna `InpEntryMode`, e **un controllo
  positivo HTTP** su `raw.githubusercontent.com`.
- ⚠️ Ogni riga di questo documento porta il suo file. Dove ho dedotto, ho scritto
  **[INFERITO]**; dove non so, ho scritto **NON MISURATO** invece di riempire.

---

_Compilato il 07/09/2026. Fonti: `backtest_pipeline/REGISTRO_TEST.md` (1.827
righe, letto per intero), i referti in `backtest_pipeline/risultati_archivio/`,
i dossier in `backtest_pipeline/caccia_strategie/`,
`report/PERCHE_NON_ARRIVIAMO_2026-09-07.md`, `report/ROTTA_PROP.md`,
`backtest_pipeline/prove/R52_CENSIMENTO_LATI.md`, e i sorgenti `.mq5` citati
riga per riga. **Nessuna promozione, nessuna corsa, nessuna modifica.**_
