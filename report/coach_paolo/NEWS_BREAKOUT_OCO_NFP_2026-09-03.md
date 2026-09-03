# 📰 "News Breakout M15 OCO | NFP SEL" — CHE COS'E' L'EA DI PAOLO

> **Dossier INFORMATIVO.** Non e' una caccia per l'imbuto prop, non contiene
> righe di lancio, non tocca EA nostri ne' il forward. Serve a capire cosa
> gira sul conto del coach Paolo, e a decidere **se vale la pena guardarlo**.
>
> Data: **03/09/2026** · Fonte dell'osservazione: Claudio, storico del conto
> di Paolo visto in call Zoom.

---

## 0. 🔴 LA RIGA CHE CONTA, SUBITO

**NON ho identificato il prodotto esatto.** Ho aperto 12 pagine, letto **2
sorgenti `.mq5` interi** e 1 articolo con codice, e **nessuna fonte raggiungibile
contiene la stringa letterale `"News Breakout M15 OCO"`.**

Ma il meccanismo e' **identificato con certezza**, e ho una lettura forense
del commento che spiega perche' quella stringa non si trova da nessuna parte:

🎯 **Quel commento e' quasi certamente META' scritto da Paolo.** Vedi §2.
Cercare "il prodotto che scrive quella frase" e' cercare una cosa che
probabilmente non esiste: la frase la digita l'utente in un `input string`.

E il verdetto, anticipato: **non merita di entrare nella coda dell'imbuto.**
Il motivo non e' estetico, e' scritto nero su bianco nel regolamento FTMO che
abbiamo gia' agli atti (§5.3): **su conto funded, aprire su NFP su USDJPY e'
una violazione contrattuale.** Paolo lo fa su un conto suo, non su una prop.

---

## 1. 📋 IL DATO DI PARTENZA (osservazione di Claudio, non verificabile da me)

| campo | valore |
|---|---|
| commenti visti | `News Breakout M15 OCO \| NFP SEL` · `News Breakout M15 OCO \| NFP BUY` |
| simboli | **USDJPY**, **D30EUR** (DAX) |
| giorno | **07/08/2026** — [VERIFICATO col calendario] e' un **venerdi'** |
| ora | **13:30 server** |
| altri giorni con lo stesso schema | 10/08 (lunedi'), 11/08 (martedi') |
| magic visti | **20314878**, **20280015** e altri simili |

### ✅ Coerenza oraria: perfetta
[VERIFICATO per calcolo] NFP esce alle **08:30 ET**. Ad agosto (EDT = UTC−4)
sono **12:30 UTC** = **14:30 ora italiana** = **13:30 ora server BCM**
(regola di casa: server = IT − 1, `CLAUDE.md`).
➡️ **L'ora combacia al minuto con l'uscita del dato.** I trade sono
**scattati sull'istante del rilascio**, non prima e non dopo.

### ⚠️ Nota su USDJPY + D30EUR insieme
Un NFP e' un evento **USD**. USDJPY e' un simbolo USD → coerente.
**D30EUR (DAX) non contiene USD**: se l'EA filtrasse gli eventi per valuta del
simbolo (come fanno le implementazioni corrette, vedi §4.1) il DAX **non
dovrebbe entrare**. [INFERITO] O l'EA e' configurato a mano simbolo per
simbolo (l'utente decide dove metterlo), oppure il filtro valuta e' disattivato.
Questo e' un altro indizio a favore della lettura "prodotto generico
configurato dall'utente", non di un motore che ragiona da solo.

### ❓ I magic number
[INCERTO] `20314878` e `20280015`: 8 cifre, entrambi con prefisso `20`,
differenza 34.863. **Non ho trovato nessuno schema pubblicato che li spieghi.**
Non sono ID prodotto MQL5 Market (quelli stanno sui 6 numeri: `112770`,
`176522`, `183742`). Ipotesi non verificate e da non spacciare per fatti:
magic generati per istanza/simbolo, oppure digitati a mano dall'utente.
**Non li uso come prova di niente.**

---

## 2. 🔬 LA LETTURA FORENSE DEL COMMENTO — il pezzo piu' utile del dossier

Conto i caratteri:

```
"News Breakout M15 OCO | NFP BUY"   ->  31 caratteri  ✅ intero
"News Breakout M15 OCO | NFP SEL"   ->  31 caratteri  ⚠️ TRONCO
"News Breakout M15 OCO | NFP SELL"  ->  32 caratteri  ❌ non ci sta
```

[VERIFICATO col conteggio, riprodotto in `python3`]
[VERIFICATO sulla documentazione/forum MQL5] **Il limite del campo `comment`
in MetaTrader e' 31 caratteri**, e oltre quella soglia la stringa viene
troncata (o rifiutata, a seconda del server).

➡️ **[INFERITO, ma robusto]** L'EA scrive `... | NFP SELL` e **il terminale
taglia la L**. Non e' un EA che scrive "SEL": e' un EA che scrive "SELL" e
sbatte contro il muro dei 31 caratteri. `BUY` (3 lettere) passa intero, `SELL`
(4) no. **Questa asimmetria e' la firma del troncamento, non di una scelta.**

### 🎯 E da qui la conclusione che cambia la ricerca

La struttura del commento e' **`<prefisso> | <EVENTO> <DIREZIONE>`**.
La parte che cambia trade per trade e' solo l'ultima. Il prefisso
`News Breakout M15 OCO` e' **costante**, descrittivo, e contiene tre cose che
un autore di EA non metterebbe mai insieme in una costante compilata:
- il **nome della strategia** ("News Breakout")
- il **timeframe** ("M15") — che un EA legge da `Period()`, non hardcoda
- il **tipo di gestione ordini** ("OCO") — che e' un `input bool`, non un nome

[VERIFICATO sul prodotto MQL5 Market #47956, `Straddle EA` di Hitesh Arora]
quel prodotto ha, tra gli input, letteralmente **`Comment: text field for
trades`** accanto a `Magic Number`. Cioe': **il prefisso lo scrive l'utente.**

➡️ **[INFERITO] Lettura piu' probabile:** Paolo (o chi gli ha configurato la
macchina) ha scritto a mano nel campo commento qualcosa come
`News Breakout M15 OCO | NFP`, e l'EA appende ` BUY`/` SELL`. **Il prodotto
non e' riconoscibile dal commento.** Cercare quella frase su Google e' come
cercare il nome che uno da' al proprio cane.

⚠️ **Lettura alternativa, non esclusa:** e' un EA scritto su misura (o da un
programmatore per la sua community) che non e' mai stato pubblicato.
In quel caso **nessuna ricerca web lo trovera' mai**. [INCERTO]

---

## 3. 🎰 IL MECCANISMO — questo si', identificato al 100%

Si chiama **news straddle** (o *bracket breakout su calendario economico*),
ed e' uno dei meccanismi piu' vecchi e piu' documentati del retail forex.

**Come funziona, in cinque righe:**
1. L'EA legge il calendario economico (MQL5 nativo, o un CSV caricato a mano).
2. **X minuti/secondi prima** dell'evento piazza **due ordini pendenti stop**:
   un **BUY STOP** a `Ask + distanza`, un **SELL STOP** a `Bid − distanza`.
3. All'uscita del dato il prezzo esplode: **uno dei due scatta**.
4. **OCO (One-Cancels-the-Other):** appena uno scatta, l'EA **cancella
   l'altro**. E' l'unica cosa che il termine "OCO" significa.
5. Se **nessuno** scatta entro N minuti, l'EA cancella entrambi.

**La tesi di mercato, in una riga:** _"sull'uscita di un dato macro il prezzo
si riprezza con un salto piu' grande del costo di transazione, e la direzione
del salto non e' prevedibile — quindi compro il MOVIMENTO, non la direzione."_

🔎 **Ed e' una tesi rispettabile**, con appoggio nel materiale che abbiamo
gia' in casa (vedi §5.1): il salto sulle prime barre **esiste davvero**.
Il problema non e' se il movimento c'e'. **E' se riesci a prenderlo.** (§5)

---

## 4. 🔢 I PARAMETRI TIPICI — solo da pagine e sorgenti che ho aperto

> 🔴 **Nessuno di questi numeri e' un consiglio.** Sono i default e i range
> dichiarati dagli autori, mai verificati da noi, quasi sempre in OHLC e senza
> costi. Servono a Claudio per **riconoscere** la famiglia, non per tararla.

### 4.1 `Forex news events reaction EA` — Code Base #55064 — **SORGENTE LETTO**
[VERIFICATO] Autore **Peter Mueller** (`Mullerp04`), pubblicato **21/01/2025**,
gratuito col `.mq5`. Scaricato ed estratto: **169 righe, 5 input**.
File: `FetchNews.mq5`, header `Copyright 2023, MetaQuotes Ltd.`,
`#property copyright "Müller Peter"`.
URL: https://www.mql5.com/en/code/55064

| input | default | cosa fa |
|---|---|---|
| `Type` | `Alerting` | modalita' (allerta o trading) |
| `Magic` | `1125021` | — |
| `TPPoints` | **150** | ⚠️ e' **anche** la distanza dei pendenti |
| `SLPoints` | **150** | stop in punti |
| `Volume` | **0.1** | 🔴 **lotto FISSO** |

Geometria letta nel codice (righe 102-108):
- **BUY STOP** a `ask + 150 punti`, **SL** a `ask + 150 − 150 = ask` (cioe' lo
  stop e' esattamente il prezzo di partenza), **TP** a `ask + 300 punti`.
- Simmetrico sul sell. ➡️ **Rischio/rendimento 1:1, distanza 150 punti.**
- **Scadenza:** `Expiry = TimeTradeServer() + 500` → **500 secondi**
  (8 min 20 s), poi `DeletePending()` cancella tutto (riga 99 e 114-118).
- **Eventi coperti:** solo i nomi che contengono `"cpi"`, `"ppi"`,
  `"interest rate decision"` (righe 86-88). 🔴 **NFP NON e' incluso**
  (il nome "Non-Farm Payrolls" non contiene nessuna delle tre stringhe).

🔴 **E qui il pezzo che nessuna descrizione dice:** **questo EA NON fa OCO.**
Nel sorgente non c'e' **nessuna** riga che cancelli il pendente opposto
all'attivazione del primo. I due pendenti restano vivi fino ai 500 secondi.
**In un whipsaw scattano ENTRAMBI.**
Altri due difetti letti nel codice, non nella descrizione:
- il filtro `CALENDAR_IMPORTANCE_MODERATE` c'e' **solo nel ramo Alerting**
  (riga 79): **il ramo che TRADA non filtra l'importanza**;
- `StringContains` ha un off-by-one (`if(ct == containing.Length()-1) return
  true;`, riga 161): fa match su n−1 caratteri.

### 4.2 `News Sniper Straddle` — MQL5 Market #176522 — a pagamento
[VERIFICATO sulla pagina] Autore **Napat Puangjunkum**, pubblicato
**11/05/2026**, versione **2.18** (agg. 07/08/2026).
Prezzo **1.299 USD**, noleggio da **89 USD/mese**.
URL: https://www.mql5.com/en/market/product/176522

| parametro | valore dichiarato |
|---|---|
| **Minuti prima della news** | **2** |
| **Minuti dopo la news** | **10** (poi cancella i pendenti non riempiti) |
| Distanza straddle | range di ottimizzazione **50-200 pips**, passo 25 |
| Stop loss | **200-500 pips**, passo 50 |
| Take profit | **300-1000 pips**, passo 100 |
| Trailing | **50-300 pips**, passo 50 |
| Eventi ON di default | **NFP · CPI · FOMC · GDP** |
| Eventi OFF di default | Retail Sales, Employment Change |
| Valute | USD, EUR, GBP, JPY, CAD, AUD, NZD, CHF |
| Scansione calendario | ogni 4 ore, orizzonte 24 ore |

⚠️ I "pips" di quei range sono quasi certamente **punti** (500 pips di stop su
EURUSD sarebbe assurdo). [INCERTO] — riportato come sta scritto.
📌 Nota: la pagina dichiara backtest su **EURUSD M15**. E' l'unico posto dove
ho visto insieme le parole *straddle* + **M15**. Non e' una prova.

### 4.3 `Straddle EA` — MQL5 Market #47956 — a pagamento
[VERIFICATO] Venditore **HITESH ARORA** (`thetradingtools`), pubblicato
**02/04/2020**, v2.1, **49 USD/anno di noleggio**.
URL: https://www.mql5.com/en/market/product/47956

Input rilevanti letti sulla pagina: `Buy Gap` / `Sell Gap` (in **punti**),
`Take Profit`, `Stop Loss`, **`Comment` (campo testo per i trade)**,
`Magic Number`, `News Time`, `Expiration Time`, **`Seconds before News Time`**,
`Trade Only Once`, **`Cancel Opposite Order`** (= l'OCO), `Close Pending Order
on Expire`, `Close Live Order on Expire`, trailing (`Trailing Start`/`Step`).
🎯 **E' il prodotto la cui anatomia somiglia di piu' al commento di Paolo:
prefisso libero + OCO opzionale.** Non e' una identificazione: e' una
somiglianza strutturale. [INFERITO]

### 4.4 `News Advisor MT5` — MQL5 Market #112770 — **GRATIS** (senza sorgente)
[VERIFICATO] Venditore **Zakaria Rachid**, pubblicato **17/02/2024**, v1.0.
Versione gratuita limitata a **5 notizie su USDJPY, 0.01 lotti**.
URL: https://www.mql5.com/en/market/product/112770
Ha: pending distance, aggiustamento minuti per l'ora broker, scadenza, SL/TP,
trailing, **max spread**, **max slippage**, **OCO**, calendario **da CSV**
(`ReleaseDt;Currency;EventName`), e — cosa rara — **backtestabile**.
🔴 Compilato, niente sorgente → §4 del nostro setaccio non e' applicabile.

### 4.5 `STRADDLE NEWS` — Code Base #11003 — **MT4**
[VERIFICATO] Autore **Dany Benjumea** (`dbenjume`), **16/09/2013** (agg. 2016).
URL: https://www.mql5.com/en/code/11003
Input: `StopLoss`, `TakeProfit`, `TrailingStop`, **`PipsAway`** (distanza dei
pendenti), `BalanceUsed`, `SpreadOperation` (spread massimo), slippage.
Fa **OCO vero** ("if the Buy Stop order is activated, the Sell Stop will be
deactivated automatically"). 🔴 Ma: **e' MT4**, e la pagina dichiara che
l'utente deve **ricompilare prima di ogni notizia** e attivarlo **~5 secondi
prima** a mano. Non e' automazione, e' un bottone.

### 4.6 Articolo MQL5 #16752 — la reference implementation gratuita
[VERIFICATO] _"Developing a Calendar-Based News Event Breakout Expert Advisor
in MQL5"_, **Zhuo Kai Chen**, **21/01/2025**, codice pubblicato nell'articolo.
URL: https://www.mql5.com/en/articles/16752

```
input int Magic = 0;
input int closeTime = 18;
input int slp = 1000;          // stop loss in punti
input int Deviation = 1000;    // distanza dei pendenti dal bid
input string Currencies = "USD";
input ENUM_CALENDAR_EVENT_IMPORTANCE Importance = CALENDAR_IMPORTANCE_HIGH;
```
Piazzamento: `trade.BuyStop(lots, price, _Symbol, sl, 0, ORDER_TIME_DAY, 1)`
con `lots = 0.1` **fisso** e **TP = 0** (nessun take profit; chiude tutto alle
`closeTime = 18`). 🟢 Ha il **filtro valuta** e il **filtro importanza HIGH**.
🔴 **Anche qui l'OCO non c'e'**: la pagina lo dice esplicitamente — _"The code
lacks explicit opposite-order cancellation"_, si limita a impedire che esistano
due coppie contemporaneamente.

### 📊 Sintesi dei parametri tipici della famiglia (da 6 fonti aperte)

| grandezza | valori visti | mediana ragionevole |
|---|---|---|
| **quando piazza** | 2 minuti prima (#176522) · "secondi prima" (#47956, #11003) · sul tick dell'evento (#55064) | **da 2 minuti a pochi secondi prima** |
| **distanza pendenti** | 150 punti (#55064) · 1000 punti (art. 16752) · 50-200 "pips" (#176522) | **150-200 punti** e' il centro |
| **quanto li tiene** | 500 s ≈ 8 min (#55064) · 10 min dopo (#176522) · fino a fine giornata (art. 16752) | **5-10 minuti** |
| **SL** | = distanza (#55064) · 1000 pt (art. 16752) · 200-500 (#176522) | **≈ la distanza, R 1:1** |
| **TP** | 2× distanza (#55064) · nessuno (art. 16752) · 300-1000 (#176522) | **1:1 o 1:2** |
| **eventi** | CPI/PPI/tassi (#55064) · NFP+CPI+FOMC+GDP (#176522) · NFP/GDP/tassi/inflazione/PMI (#11003) | **NFP · CPI · FOMC/tassi · GDP** |
| **lotto** | 🔴 **fisso** in 3 sorgenti su 3 lette | 🔴 **fisso** |

---

## 5. ⚠️ I RISCHI NOTI — e sono quattro, tutti misurabili

### 5.1 🟢 Prima la parte onesta: **il movimento esiste davvero**
[VERIFICATO nel repo, `caccia_strategie/CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md`
righe 340-349, citazione dal PDF di **arXiv 2605.04004 §4.7** (Mesfin, 2026),
**993 eventi 2022-2025**]:

> _"The drift is real in the first five bars after the release. **That is just
> the news spike itself.** From bar +6 onward, T-statistics across all tested
> horizons are between 0.14 and 0.69."_

➡️ **Da leggere bene, perche' e' l'opposto di come la usiamo di solito.**
La nostra lapide **L1** (`REGISTRO_TEST.md`, riga 785) chiude il **post-news
drift 15-30 minuti** — cioe' **da barra +6 in poi**. Lo straddle di Paolo
lavora sulle **prime barre**, ed e' proprio il pezzo che il paper dice
**reale**. 🔴 **Quindi: L1 NON boccia lo straddle.** Sarebbe scorretto dire
"l'abbiamo gia' bocciato". Non l'abbiamo mai misurato.

### 5.2 🔴 Ma il movimento non e' l'edge: il costo di prenderlo lo e'
Le quattro insidie, tutte confermate su piu' fonti:

| # | insidia | perche' morde |
|---|---|---|
| 1 | **Slippage all'attivazione** | sul rilascio il book si svuota: uno stop order viene eseguito **al prezzo che c'e'**, non a quello scritto. E' l'unico momento della giornata in cui lo slippage puo' valere piu' dello stop. |
| 2 | **Spread che si allarga di colpo** | fonti concordi: uno spread normale **si moltiplica per 3-5** (e oltre) sul rilascio. Il BUY STOP e' un ordine sull'**Ask**: se l'Ask salta, l'ordine parte in perdita immediata. |
| 3 | 🔴 **DOPPIO RIEMPIMENTO nel whipsaw** | il prezzo va su, scatta il buy, torna giu' e **scatta anche il sell prima che l'OCO cancelli**. Risultato: **due stop presi nello stesso minuto**. E' il rischio strutturale numero uno di questo meccanismo. |
| 4 | **Requote / rifiuto / distanza minima** | molti broker impongono `SYMBOL_TRADE_STOPS_LEVEL` piu' largo vicino agli eventi, o rifiutano l'ordine. |

📌 **Sull'insidia 3, un dato duro dal sorgente:** delle **due** implementazioni
gratuite di cui ho letto il codice (#55064 e art. 16752), **ZERO hanno l'OCO**.
Cioe' il doppio riempimento non e' un rischio teorico: e' il **comportamento di
default** della meta' delle implementazioni in circolazione.
E anche dove l'OCO c'e', **e' software**: fra l'attivazione del primo ordine e
la cancellazione del secondo passa un tick, e sul rilascio di un NFP un tick
puo' valere 30 punti.

### 5.3 🧱 E il muro vero per NOI: **le prop lo vietano**
[VERIFICATO nel repo, `docs/REGOLAMENTO_FTMO_2026-08.md` §4]:

> _"On the targeted instruments, it is not permitted to open or close any
> trades, **including pending orders**, within a time window starting **2
> minutes before and ending 2 minutes after** the release of selected news
> announcements."_ — e — _"during the US NFP release, you may trade EURGBP or
> AUDNZD; however, **you must not open or close trades on USDJPY or GBPUSD**"_.

➡️ **Il trade di Paolo del 07/08 su USDJPY alle 13:30 server, se fatto su un
FTMO funded Standard, sarebbe una violazione del contratto.** Alla lettera,
compreso lo SL/TP che scatta dentro la finestra.
🟡 Sfumature agli atti: **non** vale in Challenge/Verification, e **non** vale
sul conto **Swing**. Ma sul conto che porta i soldi, vale.
📌 E il paper lo dice da solo (§4.7): _"NFP and CPI ... are excluded entirely
by prop firm rules"_.

### 5.4 🎭 E la contraddizione col corso, che vale la pena far notare a Claudio
[VERIFICATO nel repo, `REGISTRO_TEST.md` riga 175, §D "Filtri e DIVIETI",
consolidato dalle 18 live di Emiliano]:

> _"**RICORRENTE** Blackout **news**: 11:00 e 14:30 IT (CPI/PPI) + ECB 09:00 →
> **cancella i pendenti**. **No giorni FOMC/NFP.**"_

E ancora, `prove/FIBOH4_CORSO_SPEC.md` riga 436: eventi di **cancellazione
totale** = **NFP, tassi, CPI, discorsi dei governatori**.

➡️ 🎯 **Il corso insegna a CANCELLARE i pendenti sull'NFP. L'EA di Paolo li
PIAZZA sull'NFP.** Sono due dottrine opposte. Non e' un giudizio su Paolo —
puo' benissimo tenere separate la roba discrezionale insegnata e una macchina
sperimentale su un conto suo — ma **e' un'incoerenza documentata**, ed e'
esattamente il tipo di domanda che vale la pena fargli alla prossima call.

---

## 6. 🏠 COSA ABBIAMO GIA' MISURATO IN CASA

Letto `backtest_pipeline/REGISTRO_TEST.md` **per intero** (917 righe) e
grep su `notiz|NFP|calendario|news|straddle|payroll|FOMC|OCO`.

| cosa | dove | esito | vale contro lo straddle? |
|---|---|---|---|
| **L1 — post-news drift 15-30 min su Nasdaq** | `REGISTRO_TEST.md` riga 785 + arXiv 2605.04004 §4.7, 993 eventi | 🔴 **CHIUSO**, `D127 permanently rejected`, T 0,14-0,69 **da barra +6** | ❌ **NO.** Misura le barre **dopo** lo spike. Lo straddle vive **nelle prime cinque**. |
| **Filtro news su ABTG_FiboH4 (R93 gamba A)** | `R93_CRITERI.md`, `PIANO_PROP.md` D5 | 🟡 misura il **COSTO della conformita'**, non promuove; il filtro esisteva ma era **cieco** (colonne CSV scambiate) | ❌ e' un **filtro** che ESCLUDE le news, il contrario |
| **Blackout news negli EA aperture** | `REGISTRO_TEST.md` §D e §MODIFICHE punto 4 | input `InpUseNewsFilter` esiste, **spento** | ❌ contrario |
| **`ABTG_NFP_Study.mq5`** (script, 118 righe) | `mql5/Scripts/` | 🟡 **SCRITTO, MAI GIRATO** — censito in `GIACIMENTO_DI_CASA_2026-09-03.md` come *"riga; mai toccato da 39 giorni"* | ✅ **e' esattamente lo strumento giusto** |
| **`Londra_ORB` (O4)** — straddle OCO sul range 06-07 | `REGISTRO_TEST.md` §3 | 🔴 **morto**: 11% celle positive, DD 23% | 🟡 stessa **geometria**, evento diverso (orario, non notizia) |
| **Gold Phantom / ORB Master (EA di mercato)** | `CACCIA_MARKET_2026-08-23.md`, `CONFIG_PROP_RACCOLTA_SET_2026-08-18.md` | usano l'NFP per **CHIUDERE tutto** (100 min prima / 60 dopo) | ❌ contrario |

### 🎯 VERDETTO SU (d): **NO. In casa lo straddle sul rilascio NON e' mai stato misurato.**
Abbiamo misurato **il dopo** (bocciato) e abbiamo costruito **il filtro che lo
evita**. Il meccanismo di Paolo — **pendenti opposti sull'istante del dato** —
e' un buco vero nel nostro registro.

🔎 **E c'e' gia' l'attrezzo per aprirlo senza scrivere una riga di codice:**
`mql5/Scripts/ABTG_NFP_Study.mq5` misura, per ogni NFP dal 2024, **MFE / MAE /
chiusura a 15-30-60 minuti** dalla candela di rilascio. E' uno **script**, non
un EA: si trascina su un grafico, sputa un CSV, e non tocca niente.
**Costo: una trascinata di mouse.** ⚠️ Ma i suoi numeri sarebbero **OHLC senza
costi**, e su questo meccanismo lo spread e lo slippage **sono l'intera
partita**: darebbe una **misura di occasione**, mai un verdetto (regola F6).

---

## 7. ⚖️ MERITA ATTENZIONE? — parere onesto

### 🔴 NO come candidato per l'imbuto prop. Cinque motivi, in ordine di peso.

1. 🧱 **Lo vietano proprio dove ci servirebbe.** FTMO funded Standard: aperture
   e chiusure, **pendenti inclusi**, vietate ±2 minuti sugli strumenti
   colpiti (§5.3). Costruire un motore il cui unico momento operativo e'
   dentro la finestra vietata e' costruire qualcosa che **non potremo mai
   accendere** sul conto che paga.
2. 📉 **Frequenza da fondo classifica.** NFP = **12 volte l'anno**. Anche
   allargando a NFP+CPI+FOMC+GDP su 4 valute si sta sulle **poche decine di
   trade l'anno**. Con la regola di casa (**IS ≥150 operazioni**, emendamento
   della finestra §A) servirebbero **anni** di storico solo per l'IS — e sui
   tick reali BCM non ci arriviamo.
3. 💥 **Il rischio giornaliero e' concentrato per costruzione.** Il muro prop
   giornaliero e' **−5.000 su 100k**. Uno straddle su NFP puo' prendere
   **due stop nello stesso minuto** (doppio riempimento, §5.2 #3), su piu'
   simboli contemporaneamente, con **slippage non modellabile**. E' l'esatto
   contrario del profilo che `METRO_PROP.md` ci chiede.
4. 🚫 **Non e' backtestabile con onesta'.** Il tester MT5 non riproduce lo
   slippage e l'allargamento di spread del rilascio, e il calendario nativo
   **non funziona nel tester** (limite dichiarato negli articoli MQL5 letti).
   Qualunque numero uscisse sarebbe **ottimista di un fattore che non
   sappiamo stimare**. Un backtest che non puo' sbagliarsi non serve.
5. 🔴 **Tutte e tre le implementazioni gratuite lette hanno lotto FISSO**
   (0.1 in due casi) — scarto ricorrente del `SETACCIO_MANUALE.md` — e due su
   tre **non hanno nemmeno l'OCO**.

### 🟡 SI come materiale informativo, e su tre punti precisi

1. 🧠 **Ci dice cosa fa Paolo, e che non e' quello che insegna.** Vale una
   domanda diretta: *"l'EA che piazza i pendenti sull'NFP e' tuo? Che
   distanza e che stop usa? E come lo concili col blackout news del corso?"*
   **Una risposta sua vale piu' di dieci pagine mie.** Se gli chiede il nome
   del prodotto, il dossier si chiude in trenta secondi.
2. 📏 **Apre un buco misurabile a costo quasi zero:** `ABTG_NFP_Study.mq5` e'
   gia' scritto e mai girato. Farlo girare **non e' un round**, e' una sonda.
   E risponderebbe a una domanda che non abbiamo mai posto: *sulla candela di
   rilascio dell'NFP, il Nasdaq/DAX parte e continua, o frusta?*
3. 🛡️ **Ci serve al contrario: come stress test.** In
   `ANALISI_LIVE_EMILIANO_2026-08-31.md` c'e' gia' in coda la voce **S-F —
   "stress-slippage sui pendenti in finestra NFP/CPI"**, agganciata a
   METRO_PROP G3.2, marcata *"la piu' utile alla challenge"*. **Studiare
   quanto slitta un pendente sull'NFP serve a proteggere le NOSTRE sedie**
   (MaxMinNotte e le aperture piazzano pendenti tutte le mattine), non a
   costruirne una nuova. 🎯 **Questo e' il vero valore del dossier.**

### 🆓 E la parte "meccanismo libero mai provato", come da mandato §3
| candidato | licenza | perche' NON lo propongo lo stesso |
|---|---|---|
| Code Base **#55064** (sorgente letto) | 🔴 **nessuna licenza libera dichiarata** — header `Copyright 2023, MetaQuotes Ltd.` + `#property copyright "Müller Peter"`, si applicano i termini del Code Base. **Non e' MIT/BSD/Apache.** | lotto fisso 0.1, **niente OCO**, niente filtro importanza nel ramo trading, NFP non coperto, `StringContains` con off-by-one |
| Articolo **#16752** (codice pubblicato) | 🔴 idem, termini MQL5 | lotto fisso, **TP=0**, **niente OCO** |
| Code Base **#11003** | 🔴 idem | **MT4**, e va ricompilato a mano prima di ogni notizia |
| GitHub | — | 🔴 **zero repository trovati** (vedi §8) |

➡️ **Niente da segnalare come "libero e mai provato".** Non esiste, nelle
fonti che ho potuto raggiungere, un'implementazione news-straddle **con
licenza libera** che passi il §4 del setaccio.

---

## 8. 🚧 COSA NON HO POTUTO VEDERE — il buco dichiarato

### Controllo positivo, fonte per fonte

| fonte | controllo positivo | esito |
|---|---|---|
| **MQL5 Code Base** (`/en/code/mt5/experts`) | lista EA | 🟡 **PARZIALE**: titoli veri e attuali (`PropFirmGuard`, `Trading Tool Assistant v2`, ...) ma **autori e date non renderizzati**. Le **pagine dei singoli EA** danno tutto (autore, data, sorgente scaricabile) → **usata, e funziona** |
| **MQL5 Market** (pagine prodotto) | #176522, #47956, #112770 | ✅ **PASSA** — nome, venditore, prezzo, data, versione, input |
| **MQL5 Articoli** (#16752) | codice nell'articolo | ✅ **PASSA** |
| **MQL5 ricerca interna** (`/en/search#!keyword=`) | ricerca "News Breakout" OCO | 🔴 **NULLA** — pagina JS, torna solo il template, **zero risultati renderizzati**. La ricerca full-text di MQL5 **non e' stata utilizzabile**. |
| **download sorgente** (`/en/code/download/55064`) | HTTP 200, 2.718 byte, ZIP → `FetchNews.mq5` 14.260 byte | ✅ **PASSA** |
| **GitHub API di ricerca** | `search/repositories` | 🔴 **NULLA** — HTTP **403**: *"This GitHub API path is not available: sessions are bound to their configured repositories"* |
| **GitHub ricerca web** | `search?q=mql5+news+straddle+ea` | ✅ raggiungibile, **0 risultati** ("Your search did not match any repositories") |
| **Forex Factory** | thread 597450 (AmazingEA straddle) | 🔴 **NULLA** — HTTP **403 Forbidden**. **La fonte forum non e' stata raggiunta.** |
| **EarnForex** (`Amazing` EA, MT4/MT5 con sorgente) | pagina prodotto | 🔴 **BLOCCATO dal proxy di rete** (`EGRESS_BLOCKED`) |
| **RobotFX** (`News OCO EA`, il lead piu' promettente) | 3 domini provati: `robotfx.org`, `www.robotfx.org`, `maintenance.robotfx.org` | 🔴 **TUTTI BLOCCATI dal proxy** (`EGRESS_BLOCKED`) |
| forextoolstore.com · bestmt4ea.com · financialsource.co · forexop.com | pagine con tabelle parametri e rischi | 🔴 **BLOCCATI dal proxy** |
| **TradingView** | — | ⚪ **non interrogata**: Pine non piazza ordini pendenti su calendario economico, fonte strutturalmente inadatta al quesito |

🔴 **Il buco piu' grosso: `RobotFX News OCO EA`.** E' l'unico prodotto trovato
che ha **"News" + "OCO" nel nome stesso**, con input che dai risultati di
ricerca risultano essere: *"Delete pending orders (minutes after news)"*,
*"The distance between them (pips)"*, *"Distance from current price (of first
pending order)"*, *"Enable OCO (one cancels others)"*. **Non ho potuto aprire
la pagina** (dominio bloccato in uscita): quei quattro nomi vengono dagli
snippet dei motori di ricerca, **non da una pagina che ho letto**, e li marco
**[INCERTO]**. Se un domani il dominio si sblocca, **e' la prima porta da
riaprire** — ma resta un prodotto **MT4** e **senza sorgente**.

---

## 9. 📌 SE CLAUDIO VUOLE CHIUDERE LA DOMANDA IN 30 SECONDI

Le tre domande da fare a Paolo, in ordine di resa:

1. **"Come si chiama l'EA che ti piazza i pendenti sull'NFP?"** — chiude tutto.
2. **"Quanti punti di distanza mette, e quanto prima li piazza?"** — dice se e'
   la famiglia dei 150-200 punti / 2 minuti prima (§4).
3. **"Ti e' mai capitato che scattassero tutti e due?"** — la sua risposta
   misura, sul campo e gratis, l'insidia numero 1 di questo meccanismo (§5.2).

E la domanda a cui dovrebbe rispondere il primo (eventuale) esperimento di
casa — che **non e' un round e non promuove niente**:

> 🎯 _"Sulla candela di rilascio dell'NFP, il movimento oltre ±150 punti
> arriva prima o dopo il ritracciamento che ammazzerebbe l'ordine opposto?"_
> Attrezzo: `mql5/Scripts/ABTG_NFP_Study.mq5`, gia' in casa, mai girato.
> ⚠️ Misura **OHLC senza costi** = misura di **occasione**, mai un verdetto.

---

## 10. 🔗 FONTI EFFETTIVAMENTE APERTE

- https://www.mql5.com/en/code/55064 — sorgente `FetchNews.mq5` scaricato e letto (169 righe)
- https://www.mql5.com/en/code/11003 — STRADDLE NEWS (MT4), pagina letta
- https://www.mql5.com/en/articles/16752 — Zhuo Kai Chen, codice letto
- https://www.mql5.com/en/market/product/176522 — News Sniper Straddle
- https://www.mql5.com/en/market/product/47956 — Straddle EA (Hitesh Arora)
- https://www.mql5.com/en/market/product/112770 — News Advisor MT5 (gratis)
- https://www.mql5.com/en/blogs/post/772709 — Mohan Shivaji Shivtare, 16/07/2026
- https://www.mql5.com/en/forum/174934 — thread straddle (sterile: nessun numero)
- https://www.mql5.com/en/code/mt5/experts — controllo positivo
- https://github.com/search?q=mql5+news+straddle+ea — 0 risultati
- In casa: `backtest_pipeline/REGISTRO_TEST.md` · `docs/REGOLAMENTO_FTMO_2026-08.md` ·
  `backtest_pipeline/caccia_strategie/CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` ·
  `backtest_pipeline/prove/FIBOH4_CORSO_SPEC.md` · `mql5/Scripts/ABTG_NFP_Study.mq5` ·
  `report/GIACIMENTO_DI_CASA_2026-09-03.md` ·
  `backtest_pipeline/risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-31.md`
