# 🏹 CACCIA — APERTURA DI LONDRA, MECCANISMI DIVERSI DAI CADUTI (19/08/2026)

**Mandato di Claudio:** cercare fuori dal repo strategie/EA/paper sull'apertura
di Londra il cui **MECCANISMO** sia diverso da quello gia' misurato e morto in
casa. Regola d'ingaggio dichiarata: _"parametri diversi dello stesso motore =
scarto automatico"_.

**Risultato in una riga:**
> Su **12 candidati valutati** (di cui **5 letti nel sorgente `.mq5`** e 1 paper
> verificato in metadati), **1 solo e' PROMOSSO all'imbuto**, 1 va **IN CODA**,
> **7 sono SCARTATI** (di cui 4 perche' sono letteralmente il motore morto con
> altri parametri o con filtri appiccicati sopra), 3 **non sono valutabili**
> perche' la fonte non si e' fatta leggere.
>
> 🔴 **La risposta onesta e' scomoda: il web, sulla parola "Londra", offre
> quasi solo varianti del breakout gia' bocciato 48/48.** L'unico meccanismo
> strutturalmente nuovo che ho trovato col sorgente in mano non e' nemmeno
> nato "di Londra": e' un motore di **sweep + reclaim su livello strutturale**,
> ed e' Londra solo se glielo rendiamo costitutivo noi.

---

## 0. 📕 LA LISTA DEI CADUTI — il metro di questa caccia

Riletti prima di uscire, sono il criterio di scarto:

| caduto | dove | meccanismo | verdetto misurato |
|---|---|---|---|
| **Londra_ORB** (O4) | `REGISTRO_TEST.md` §3 | straddle OCO sul range 06-07 server, SL al centro canale | OHLC **11% celle positive**, DD **23%** → 🔴 morto |
| **capitolo BREAKOUT M5 in apertura** | `REGISTRO_TEST.md` §2 | Live5m, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB | **CHIUSO il 26.07.26** su tick reali. _"Non costruire altri v2 M5."_ |
| **R45 — ORB di sessione Londra** | `REFERTO_ROUND45_LONDRA.md` | range 07:00→07:15/07:30 server, chiusura 12:00, conferma su chiusura M5, corpo 50%, EMA 9/21 | **0 celle positive su 48** (GBPUSD/EURUSD/XAUUSD, 149-408 trade/cella). Famiglia ORB chiusa **su ogni sessione misurata**. |
| **R42 — FADE degli estremi del range** | `REFERTO_ROUND42_FADE.md` | fade sugli estremi del range di apertura (15'/35', offset 0/200/400, ATR 1,0/1,5) | **0/24 IS e 0/24 OOS**, PF sempre fra **0,50 e 0,93**, campioni 195-333/cella. Diagnosi dell'autore del referto: **e' morto il MOTORE, non la gestione**. |

### 📌 Le due frasi dei referti che ho usato come bussola (citate, non parafrasate)

1. **R42:** _"agli estremi del range di apertura non c'e' edge IN NESSUNA DELLE
   DUE DIREZIONI (breakout puro: bocciato R7/02.08/R25; fade: bocciato oggi).
   L'unica cosa che ha sempre pagato e' il **RETEST** — entrare sul RITORNO al
   livello DOPO la rottura confermata"_.
2. **R45:** _"il box notturno paga sul **RANGE DELLA NOTTE** (ore di accumulo),
   non sul quarto d'ora dell'apertura europea"_.

> 🎯 **Queste due frasi, messe insieme, sono la specifica del candidato che
> stavo cercando: un livello costruito in ORE, non in 15 minuti, e un ingresso
> sul RITORNO al livello, non sul tocco.** Il candidato promosso e' l'unico
> oggetto trovato sul web che le soddisfa entrambe. Il resto e' la solita
> scatola dei 15 minuti.

⚠️ **Nota di fuso da sanare prima di qualunque riga di lancio [INCERTO].**
I nostri stessi due referti usano ore di Londra diverse: `REGISTRO_TEST.md`
scrive per Londra_ORB _"range 06-07 server"_, `REFERTO_ROUND45_LONDRA.md`
scrive _"range 07:00→07:15/07:30 server"_. Con la regola di casa
(server BCM = ora italiana − 1) l'apertura di Londra cadrebbe alle **08:00
server**. **Tre valori diversi in tre posti: non ne invento uno.** Va misurato
sull'orologio del server prima di scrivere un `.txt` di prova.

---

## 1. 🔌 CONTROLLO POSITIVO SU OGNI FONTE — misurato oggi, non ipotizzato

Il `PROMEMORIA_SBLOCCO_FONTI.md` del 16/08 dava quasi tutto a 403. **La
situazione e' cambiata e l'ho rimisurata**: alcuni domini si sono aperti.

| fonte | HTTP | contenuto | esito controllo positivo |
|---|---|---|---|
| **MQL5 Code Base** | 200 | su `/en/code/75586` leggo titolo `GoldLondonBreakout`, autore `adeolu01` (Adeolu Kayode Gbadebo), data `2026-08-01T21:53:47`, **`UserDownloads:512`**, rating 4,67 | 🟢 **PASSA in pieno** (titolo+autore+data+download). **E in piu' `/en/code/download/<id>` restituisce lo ZIP col `.mq5`: il sorgente si legge davvero.** |
| **arXiv (API + abs)** | 200 | `arxiv.org/abs/1103.5664` → `citation_title`, `citation_author` (cotter, john / dowd, kevin), `citation_date 2011/03/29` | 🟢 **PASSA** |
| **SSRN** (`papers.ssrn.com` e `www.ssrn.com`) | **403** / Cloudflare _"Just a moment..."_ | — | 🔴 **NULLA.** Dichiarata. |
| **TradingView** | pagina **tag** 200, pagina **script** **404** | `/scripts/openingrange/` risponde 200 ma **zero link `/script/` nell'HTML** (rendering lato client); le pagine dei singoli script rispondono `Publication not found` | 🔴 **NULLA per la lettura del sorgente Pine.** Vedi §4. |
| **GitHub** (web + API) | **403** su `github.com/search`, **403** su `api.github.com`, `gh` CLI assente | — | 🔴 **NULLA.** Dichiarata. |
| **Forex Factory** | **403** | — | 🔴 **NULLA.** I thread storici sulla London session — la cosa che volevo davvero da li' — **non li ho potuti leggere.** |
| **Quantpedia** | 200 | `/?s=intraday+session` rende la paginazione (1-265) ma **nessun titolo di strategia** nel corpo | 🔴 **NULLA in pratica.** |
| **ideas.repec.org** | — | `EGRESS_BLOCKED` dal proxy | 🔴 **NULLA.** |

**Traduzione:** delle 6 fonti del protocollo, in questa caccia ne hanno
funzionato **due** (MQL5 Code Base e arXiv). Le altre quattro sono buchi
dichiarati, non silenzi.

### Cosa ho sfogliato dove ha funzionato
- **MQL5 Code Base:** **200 titoli EA MT5 unici** raccolti su 6 pagine di
  listato (`/en/code/mt5/experts` + `page2..page6`), poi filtrati con
  `london|asian|asia|session|sweep|liquidity|judas|killzone|fvg|fair value|
  reversion|reversal|gap` → **7 titoli in tema**. Piu' 4 ricerche mirate.
  **5 sorgenti `.mq5` scaricati e letti riga per riga** (68951, 71467, 76153,
  73210, 71195).
- **arXiv:** 2 query all'API (`q-fin.TR` recenti; `abs:"intraday seasonality"
  AND abs:"foreign exchange"`). Il listato `q-fin.TR` recente e' **tutto
  microstruttura ed esecuzione** (market making, child order placement,
  mercati elettrici): **zero strategie di sessione**. Un solo paper in tema.

---

## 2. 🟢 IL PROMOSSO — l'unico

### `Liquidity Sweep H4 - M15 (Swing Highs and Lows) / MQL5`

```
NOME            Liquidity Sweep H4 - M15 (Swing Highs and Lows) / MQL5
FONTE / URL     https://www.mql5.com/en/code/68951   [rango: SORGENTE LETTO]
AUTORE / DATA   OsmarSandovalEspinosa — 2026.03.23   [VERIFICATO sulla pagina]
LICENZA         #property copyright "Copyright 2025, MetaQuotes Ltd." (header
                di default del template MQL5) — Code Base = download gratuito
RIGHE / INPUT   287 righe · **3 input** (Range=21, sl_points=100, RR=1)
```

**MECCANISMO IN TRE RIGHE** _(letto nel sorgente, non nella descrizione)_
1. **Il livello:** su ogni nuova barra H4 marca uno swing se la barra di indice
   `Range` (default **21**) ha high superiore a tutte le 21 barre a sinistra e a
   destra (righe 198-208). Il livello e' quindi **confermato ~21 barre H4 dopo
   essersi formato = circa 3 giorni e mezzo di accumulo**, e finisce in un array.
2. **Il grilletto:** su chiusura di barra **M15**, se
   `close(1) < SwingHigh && high(1) > SwingHigh` → **SELL** (riga 93); simmetrico
   `low(1) < SwingLow && close(1) > SwingLow` → **BUY** (riga 134). Cioe':
   **il prezzo ha bucato il livello e c'e' rientrato dentro alla chiusura**.
3. **Uscita:** SL fisso `sl_points` punti dal prezzo, TP = distanza SL × `RR`,
   entrambi **mandati al broker** dentro `trade.Sell/Buy` (righe 97-103, 138-144).
   Il livello viene **consumato** dopo l'uso (`ArrayModify`, righe 106/147) e
   **cancellato** se il prezzo lo chiude oltre in modo pulito (righe 120-124,
   161-165): un livello vale **una volta sola**.

**TESI IN UNA RIGA**
> _"Guadagna perche' uno swing strutturale vecchio di giorni e' dove stanno gli
> stop di chi lo ha visto; il prezzo li va a prendere e, se il flusso vero non
> c'era, la stessa candela lo riporta dentro — e chi e' entrato sulla rottura
> diventa il carburante del ritorno."_

### 🎯 IN COSA DIFFERISCE DAI CADUTI — punto per punto, esplicito

| | i caduti (Londra_ORB / R45 / R42) | questo |
|---|---|---|
| **da dove nasce il livello** | high/low di una finestra di **15-30 minuti** attorno all'apertura | swing H4 con **21 barre di conferma per lato ≈ 3,5 giorni** |
| **quando entra** | al **tocco** o alla **conferma di rottura** (R45), oppure al tocco dell'estremo in controtendenza (R42) | solo se la barra M15 **chiude di nuovo DENTRO** dopo aver bucato: la conferma **e' il rientro**, non la rottura |
| **verso dove entra** | breakout: **con** la rottura. Fade: **contro**, ma **sull'estremo** | **contro la rottura, ma solo dopo il rientro** = famiglia **RETEST/RECLAIM** |
| **cosa fa del livello** | ne fa due grilletti OCO simultanei | ne fa **un evento singolo**, poi lo butta |
| **il calendario** | la strategia **e'** un orario | **nessun filtro orario nel codice** (0 input di tempo) |

> ✅ **Non e' "lo stesso motore con altri pip".** R42 ha misurato il fade
> *sull'estremo del box del giorno* e lo ha ucciso; questo aspetta il **rientro**
> su un livello di **altra scala temporale**. Ed e' esattamente la famiglia che
> il referto R42 indica come **l'unica che ha sempre pagato** ("il RETEST").
> R45 aggiunge il secondo pezzo: il box che paga e' quello costruito in **ore di
> accumulo**. Qui il livello e' costruito in **giorni**.

**BANDIERE ROSSE (§4): NESSUNA.** Verificato con grep e a mano:
niente martingala (lotto costante), niente griglia, niente hedge, niente
`#import`/`WebRequest`/`iCustom`, **SL vero mandato al broker**. L'unica
occorrenza di "grid" e' `CHART_COLOR_GRID` alla riga 31 (cosmetica).

**Nessun look-ahead nell'ingresso:** decide su `close(1)`/`high(1)`/`low(1)`,
cioe' la barra M15 **chiusa** (righe 93, 134), dentro un blocco `if(isnewbarM15)`.

### 🔧 COSA TERREI / COSA RIFAREI — la separazione che chiede il §5F

**DA TENERE (il motore):** rilevamento swing simmetrico su H4 · condizione di
sweep-and-reclaim su chiusura M15 · consumo del livello (un livello = un
trade) · invalidazione del livello su chiusura oltre. **Sono ~40 righe di
logica e sono sane.**

**DA RIFARE (la gestione — cioe' la parte che sappiamo fare):**

| difetto, con la riga | perche' morde | cosa ci mettiamo |
|---|---|---|
| `trade.Sell(SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN), ...)` righe **103, 144** | **lotto minimo fisso**: non scalabile a 100k, non confrontabile coi nostri | **rischio 0,65% dell'equity** |
| `sl_points = 100` punti fissi (righe 97, 138) | su XAU/indici la scala e' sbagliata; e' scollegato dalla volatilita' | SL **strutturale** (oltre l'estremo dello sweep) o ATR |
| `RR = 1` secco, TP unico | nessuna gestione | **parziale 1R + breakeven + runner 2R** (le nostre DAX/Dow) |
| 🐛 `SwingHighs[100]` con `SwingHighCount++` **senza controllo di limite** (righe 216-217, 226-227) | **BUG VERO: overflow dell'array oltre 100 swing**, quindi crash o dati sporchi in un backtest lungo. Da correggere PRIMA di qualunque misura. | `if(count < ArraySize(...))` |
| `if(high4(Range) < high4(Range-i) ...)` riga **200**: con `i=Range` legge `high4(0)`, la barra H4 **in formazione** | **[INFERITO dalla riga 200]** non e' look-ahead (barra 0 e' presente, non futura) e viene valutata all'apertura della barra, quando bar 0 e' quasi vuota — ma rende la definizione dello swing **instabile** | escludere bar 0 dalla finestra |
| nessun filtro di spread | R55: lo spread va misurato **in % dello stop** | il nostro filtro standard |
| `ArrayModify` non azzera la coda (righe 270-283) | lascia un duplicato dell'ultimo elemento | riscrittura banale |

**COSTO DI PORTING:** **0 ore di traduzione** (e' gia' MQL5). ~**3-5 ore** di
rifinitura: fix del bug d'array, rischio %, SL strutturale, gestione a
parziali, filtro spread, filtro di sessione costitutivo.

```
PUNTEGGIO
  [2] semplicita' — 3 input, 287 righe, ~40 di logica
  [2] il filtro E' il motore — non c'e' NESSUN filtro: c'e' solo il motore
  [2] tesi di mercato scrivibile — sopra, e regge
  [2] riempie un BUCO — motore SIMMETRICO vero (long e short dallo stesso
      codice), e quasi tutte le nostre celle sono long-only
  [2] testabile senza riscritture — MQL5, zero dipendenze, gira su Period()

VERDETTO   🟢 PROVA SUBITO (10/10)
PERCHE'    e' l'unico oggetto trovato che soddisfa ENTRAMBE le lezioni scritte
           nei nostri referti (livello costruito in ore/giorni + ingresso sul
           RITORNO), e arriva grezzo esattamente dove sappiamo rifinire.
```

### 🏛️ In ottica prop
Motore **event-driven e raro**: entra solo quando un livello strutturale viene
bucato e riconquistato, e ogni livello vale **una volta sola** — quindi non
spara 5 trade correlati la stessa mattina, che e' il rischio giornaliero che
`METRO_PROP.md` teme. ⚠️ **Il rovescio:** con `Range=21` su H4 i livelli sono
pochi, quindi **il campione potrebbe non arrivare ai 150 trade IS** richiesti
dall'Emendamento della Finestra: **va misurata la frequenza prima di
giudicare il merito**. ⚠️ Secondo avviso: essendo controtendenza su livello,
e' il tipo di motore che **incassa una serie di stop in un trend forte** →
la peggior giornata va misurata, non stimata.

---

## 3. 🟡 IN CODA — uno

### `KSQ Fair Value Gap EA FVG with Regime Detection and Dual SL TP Mode`

```
FONTE / URL   https://www.mql5.com/en/code/71467   [rango: SORGENTE LETTO]
AUTORE / DATA Adiec7 — 2026.04.04   [VERIFICATO]
RIGHE / INPUT 949 righe · **53 input** (contati: `grep -c "^input"`)
```

**MECCANISMO:** rileva FVG a 3 barre (imbalance), entra sul **pullback
confermato dentro la zona**, ogni FVG spara una volta sola. Filtro di regime
(bias EMA e/o ADX su TF superiore), SL/TP ATR o punti, breakeven + parziale +
trailing, kill-switch di DD giornaliero e totale, filtro di sessione
**gia' in ora server** (`InpSessionStartHour = 7`, `InpSessionEndHour = 20`,
riga 133-136 — disattivato di default, `InpUseSessionFilter = false`).

**Differenza dai caduti:** ✅ reale — la zona d'ingresso e' un **buco di
prezzo lasciato dall'impulso**, non un range orario; e l'ingresso e' un
**ritorno nella zona**, ancora famiglia retest.

**Perche' NON e' promosso oggi, in una riga:**
> **53 input contro il nostro tetto di ~15, e 949 righe.** Il §5A dice che
> sopra i 15 input liberi il backtest ha troppe manopole da girare verso il
> passato; qui ce ne sono **tre volte e mezzo** tante. E il §5E dice che quando
> il costo di validazione supera il valore atteso si dichiara e si mette in
> coda. **Non e' rotto: e' caro.** Se ci va, ci va dopo aver sfrondato gli
> input a mano — che e' mezza giornata prima ancora del primo backtest.

**Bandiere rosse §4:** nessuna trovata (le uniche occorrenze di `Multiplier`
sono `InpSLATRMult`, `InpTPATRMult`, `InpTrailATRMult` — moltiplicatori ATR,
non di lotto). Ha `InpUseFixedLot` ma con **rischio % selezionabile**.
Nota dell'autore sulla pagina: _"It's not yet optimised for any pair"_.

---

## 4. 🔴 GLI SCARTATI — una riga di motivo a testa

| candidato | fonte / rango | meccanismo dichiarato | motivo dello scarto |
|---|---|---|---|
| **`SessionORB_EA`** (Session Opening Range Breakout EA), `Stridz_z`, 2026.08.15 | [mql5.com/en/code/76153](https://www.mql5.com/en/code/76153) — **sorgente letto**, 466 righe, 20 input | high/low dei primi N minuti dopo l'apertura scelta, poi due grilletti di rottura con buffer, SL oltre il bordo opposto, 1 trade/sessione | 🔴 **E' LETTERALMENTE R45.** `InpSessionStartHour=8`, `InpOpeningRangeMinutes=30`, `InpBreakoutBufferPoints=20`, `InpStopLossBufferPoints=30`, `InpRewardToRiskRatio=2.0`: **stesso motore, altri numeri.** Regola d'ingaggio → scarto automatico. |
| **`V1N1 LONNY MT5`**, `vinicius-fx`, 2026.06.18 | [mql5.com/en/code/73210](https://www.mql5.com/en/code/73210) — **sorgente letto**, 2359 righe, 17 input | stop order pendenti fuori dal **range asiatico pre-Londra**, segnali PSAR + MACD + Stocastico, filtro dimensione range vs ADR, gestione DST Londra/NY, SL strutturale su swing PSAR opposto | 🔴 **Motore morto + filtri appiccicati sopra.** L'ingresso resta lo straddle sul range = Londra_ORB. E il §5B e' misurato in casa: **filtro aggiunto dopo a un motore gia' tarato = 0 successi su 5** (R20 ADX, R12, R26, R45, R54). _(Nessuna bandiera §4: le occorrenze di "recovery" alle righe 387-404 sono il **recovery factor** dentro un `OnTester` personalizzato, non un martingala. Scartato per meccanismo, non per marciume.)_ |
| **`GoldLondonBreakout`**, `adeolu01`, 2026.08.01, 512 download | [mql5.com/en/code/75586](https://www.mql5.com/en/code/75586) — pagina letta | _"Locks in the Asian session range on XAUUSD, then places an OCO breakout pair (BuyStop/SellStop) for the London open, with ATR-based stops and risk-percent position sizing"_ | 🔴 **Gia' nel `SETACCIO_MANUALE.md` e = R45.** OCO sul range per l'apertura di Londra: e' la definizione del caduto. Non lo riapro. |
| 🆕 **`London SE BreakOut EA`**, Alessandro Titov, v4.16, 03/05/2023 — **MQL5 Market, AFFITTO 99 USD/mese** (199/3 mesi), 5 attivazioni, 32 demo | Market prodotto **97941** — ⚠️ **pagina NON riaperta da me** (Market fuori perimetro §3B); giudico sui **fatti misurati in sessione principale e passatimi dal coordinatore**, e lo dichiaro | range max/min (ATR) in finestra oraria, **breakout** nell'orario di trading, filtro trend a **3 medie mobili**, chiusura a orario fisso. Consigliato GBPJPY M15. Default: range **08:45-10:45**, trade **10:45-22:00**, close **22:50**; TP **690 pip**, SL **320 pip**; **Risk 2,0%**; slippage **2000 pip**; SL shift #1 a 480 pip → prezzo+20 | 🔴 **SCARTO SU DUE LIVELLI INDIPENDENTI — e nemmeno la demo nel tester e' giustificata.** <br>**(a) Meccanismo = famiglia dei caduti.** "Range in finestra oraria + breakout + filtro medie mobili" e' **Londra_ORB con tre medie sopra**: il range e' ATR invece che high/low e la finestra e' 08:45-10:45 invece di 07:00-07:15, ma **il grilletto resta la rottura del range di sessione**. E' precisamente il caso che il §5B ha gia' misurato **0 su 5**. Regola d'ingaggio di Claudio: parametri diversi dello stesso motore → scarto automatico. <br>**(b) Bandiera rossa §4 nel motore, non nella gestione.** L'opzione _"coprire la posizione dopo una perdita, cercare di recuperare in caso di inversione"_ e' **recovery/hedge di copertura**: §4 la elenca fra le cose che **non si rifiniscono**. Il §5F e' esplicito: _"resta SCARTO tutto cio' che e' marcio nel motore"_. <br>**(c) Incompatibilita' prop, che pesa sull'ordine ma non serviva.** Risk default **2,0%** contro il nostro **0,65%** (a 1% la p99 del DD e' **12,47%**, gia' oltre il muro del 10%); _"non usare insieme ad altri EA sullo stesso account"_ **contraddice frontalmente** l'obiettivo di `ROTTA_PROP.md` (_"piu' EA possibili con DD bassi da accendere simultaneamente col guardiano"_); _"un rischio maggiore richiede una leva maggiore"_ e **tolleranza slippage 2000 pip** sono la firma di un EA che non e' stato pensato per un cap di DD. <br>**(d) Il cancello.** `CANCELLO_ACQUISTI_EA.md` ammette la spesa **solo dopo** che il meccanismo ha meritato la misura. Qui il meccanismo **non merita**: aprire la demo nel tester costerebbe una serata per rimisurare R45 con altri parametri. **99 USD/mese, in affitto, senza sorgente** (= niente rifiniture, il limite va dichiarato sempre) per un motore gia' bocciato 48/48 e' esattamente il tipo di spesa che il cancello esiste per fermare. |
| **`Dominance EA`**, 2026 | [mql5.com/en/code/71195](https://www.mql5.com/en/code/71195) — **sorgente letto**, 359 righe, **11 input** | bias del giorno precedente (controllo rialzista vs ribassista) + conferma MA, SL ATR, un solo trade a volume minimo | 🟠 **FUORI TEMA, non bocciato.** Meccanismo **davvero diverso** (bias giornaliero, nessun range, nessuna sessione) e **pulito**: 11 input, nessuna bandiera §4, SL ATR vero. Ma **non e' un motore di Londra** e questa caccia aveva un bersaglio. **Segnalato come spunto per una caccia "bias giornaliero"**, non proposto qui. Difetto noto: volume minimo fisso, non rischio %. |
| **`ORB - Asia Opening Range Breakout`**, XAUmmunity | TradingView `4Pd2NfN6` — ⚠️ **solo titolo dal motore di ricerca, pagina 404** | opening range della sessione asiatica | 🔴 Il titolo **e'** la famiglia morta. Non spendo altro. |
| **`Asian Range Breakout PRO`** | MQL5 **Market** (a pagamento, senza sorgente) | breakout del range asiatico | 🔴 Fuori perimetro §3B **e** famiglia dei caduti. Doppio motivo. |

---

## 5. ⬜ NON VALUTABILI — dichiarati, non taciuti

| oggetto | perche' non l'ho potuto leggere |
|---|---|
| **`Session Liquidity Reversion Strategy (Asia Range False Breakout)`** di `JaxonJackFX` — TradingView `uHN2BQiV` | 😤 **Il piu' doloroso.** Sulla carta e' il candidato piu' in tema di tutta la caccia (falso breakout del range asiatico, rischio in % dell'equity ~2%, M5-M30). **Ma la pagina risponde `404 — Publication not found`** a ogni tentativo (dominio `.com`, `.es`), e la pagina tag `/scripts/openingrange/` risponde 200 con **zero link agli script nell'HTML**. Non ho letto **una riga di Pine**. Tutto cio' che ne so viene da uno snippet di motore di ricerca → **[INCERTO], non entra in nessuna tabella di merito.** Se Claudio riesce ad aprirlo dal suo browser e a incollare il Pine, va dritto nel `SETACCIO_MANUALE.md`: **il meccanismo, se e' davvero "false breakout del range asiatico con rientro", e' cugino stretto del promosso** e merita la lettura. ⚠️ E se lo leggiamo: Pine → MQL5 **non e' un porting, e' una riscrittura**, e lo Strategy Tester di TradingView e' **ottimista di natura**. |
| **`Asia Session Liquidity + Weekly VWAP Strategy v2`** di `przemo28g` — TradingView `RCHiuWi0` | stesso muro 404. Segnalo solo che **l'aggancio VWAP** sarebbe un meccanismo diverso dai caduti. Nient'altro: non l'ho letto. |
| **Forex Factory — thread storici sulla London session** | dominio a **403**. Era la fonte da cui volevo la cosa che vale piu' del sistema: **come una strategia di Londra e' invecchiata**. **Buco vero di questa caccia.** |
| **GitHub** | 403 su web e API, `gh` assente. Zero repo esaminati. |

---

## 6. 📄 IL PAPER — cultura, non candidato (e va detto)

### `Intra-Day Seasonality in Foreign Exchange Market Transactions`
**John Cotter, Kevin Dowd — arXiv, 29/03/2011** — [arxiv.org/abs/1103.5664](https://arxiv.org/abs/1103.5664)
[VERIFICATO: `citation_title`, `citation_author`, `citation_date` letti nei meta della pagina]

Documenta stagionalita' intraday in **rendimenti, volatilita' e code** del
forex. **Non e' una strategia**: non da' regole d'ingresso ne' di stop.

> ⚠️ **E letto col nostro metro, spinge nella direzione OPPOSTA a quella che
> speravo:** se l'apertura di Londra e' un **massimo di volatilita' e di code**,
> allora e' anche il momento di **spread e slippage peggiori** — che e'
> esattamente la spiegazione economica del perche' il breakout d'apertura
> muore sui tick reali mentre brillava in OHLC (`REGISTRO_TEST.md`: _"in OHLC i
> Live5m davano numeri finti enormi... in real tick: morti"_). **Il paper non
> mi da' un candidato: mi da' un motivo per non riprovare i caduti.** Vale
> come cultura, e la scrivo qui perche' un giorno qualcuno riproporra' l'ORB
> di Londra e questa riga gli fara' risparmiare una serata.

### 🕳️ Lo SPUNTO che non posso promuovere — e perche' non lo promuovo
`Intraday Patterns in Foreign Exchange Returns and Realized Volatility`,
**Hao Zhang**, Finance Research Letters 27 (2018) 99-104, SSRN 3138756.
Tesi riportata: _le valute "home" tendono a **deprezzarsi durante la sessione
domestica** e ad **apprezzarsi durante la sessione USA dopo la chiusura di
Londra**_ (16 valute vs USD, alta frequenza, 2010-2015).

> 🎯 Sarebbe un **meccanismo strutturalmente nuovo per noi**: una **deriva
> direzionale legata all'ora e all'identita' della valuta** — nessun range,
> nessun breakout, nessun livello. Riempirebbe due buchi in un colpo
> (motore **short/simmetrico** e roba che **lavora nel laterale**, dove LARRY
> muore a −6.445 nel 2019).
>
> 🔴 **MA: SSRN mi ha risposto 403, ScienceDirect e' a pagamento, RePEc e'
> bloccato dal proxy. NON HO APERTO NESSUNA PAGINA DI QUESTO PAPER.** Ho solo
> snippet di motore di ricerca. Per la regola §1 del mio mandato **questo non
> e' una fonte**, e quindi non e' un candidato promosso: e' una **pista**,
> etichettata **[INCERTO]**, da confermare leggendo il paper prima di
> costruirci sopra una sola riga di codice.

---

## 7. 🥇 I MIGLIORI, IN ORDINE — e la bozza delle celle

### 1° — `Sweep H4-M15` ripulito (nome di lavoro: `SWEEP_RECLAIM`)

**Il round va costruito in due gradini, e il secondo e' quello di Londra.**

**Gradino A — il motore nudo, senza orario.** Serve a rispondere a *"il
sweep-and-reclaim ha un edge, si' o no?"* **prima** di appiccicargli una
sessione. Se lo misurassi gia' filtrato per Londra e andasse male, non saprei
se e' morto il motore o l'orario — ed e' l'errore che il §5B ci ha fatto
pagare 5 volte.

```
IPOTESI  Il rientro (close M15 dentro) dopo lo sweep di uno swing H4
         confermato a 21 barre per lato ha un edge, indipendente dall'ora.
SIMBOLI  GBPUSD (il curriculum) + XAUUSD (il piu' "livellato")
PERIODO  M15
CELLE    Range      = 12 | 21 | 34      (barre H4 di conferma per lato)
         SL         = strutturale 1,0 | 1,5 x l'ampiezza dello sweep
         RR         = 1,5 | 2,0
         -> 3 x 2 x 2 = 12 celle. Screening stretto, non un verdetto.
```

**Gradino B — Londra diventa COSTITUTIVA, non un filtro.** Qui il livello
**non e' piu' lo swing H4**: e' **l'estremo del range notturno asiatico**
(ore di accumulo, la lezione testuale di R45), e il grilletto e' il **rientro
su chiusura M15 nella finestra di Londra**. Il tempo **e'** il motore, non un
cerotto: e' la forma che in casa ha dato il miglior risultato di sempre
(`ABTG_EMA200` Dow, R29, 30 celle su 30 a PASS pieno).

```
CELLE    FinestraAsia   = 00:00-07:00 | 22:00-07:00  (ora SERVER, da fissare)
         FinestraLondra = 3h | 5h dall'apertura di Londra (ora SERVER)
         SL             = 1,0 | 1,5 x ampiezza dello sweep
         RR             = 1,5 | 2,0
         -> 16 celle
```

🛑 **Tre paletti prima di scrivere qualunque `.txt` di prova:**
1. **`@DAQUANDO` va MISURATO** con `scarica_storico.ps1`, non ipotizzato — sugli
   indici il driver diceva 2024.01.01 e i dati partivano dal **26/09/2024**.
2. **L'ora di Londra in ora server va fissata**: i nostri stessi referti ne
   danno **tre valori diversi** (§0). Si guarda l'orologio del server.
3. **Il bug dell'array a riga 216/226 va corretto prima**, o il backtest lungo
   misura spazzatura.
4. Selezione: **centro dell'altopiano, MAI il picco** (12 Spearman IS→OOS
   negative su 13). E la soglia dell'Emendamento: **>=150 operazioni IS**, che
   su questo motore **non e' scontata** — se non ci arriva, il round misura il
   **rischio** ma sospende il giudizio sul **merito** (valvola R59).

### 2° — `KSQ FVG EA` (71467), **solo dopo** aver sfrondato 53 input a ~15
Stessa famiglia concettuale (ritorno in una zona), ma il conto dei parametri
lo rende il candidato che costa di piu' prima ancora di partire.

### 3° — La pista Zhang 2018, **solo dopo aver letto il paper**
Se e solo se qualcuno apre la fonte. Altrimenti resta una frase in un dossier,
e le frasi non si backtestano.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Il RIENTRO dopo lo sweep — cioe' la famiglia RETEST che R42 indica come
> l'unica che ha sempre pagato — ha un edge su un livello costruito in GIORNI,
> dopo che lo stesso rientro sull'estremo del box di 15 minuti e' stato
> bocciato 48 celle su 48?"**
>
> Se **si'**, abbiamo un motore simmetrico nuovo e il gradino B lo porta su
> Londra nel modo giusto (sessione costitutiva).
> Se **no**, abbiamo chiuso anche la scala H4 con un round solo, e il verbale
> dira' che il retest paga sui **nostri** livelli (apertura DAX/Dow) e non in
> generale — che e' un'informazione che oggi non abbiamo.

---

## 9. 🧾 ONESTA' FINALE — la riga che Claudio deve leggere due volte

**Il web, sulla parola "Londra", non ha quasi niente da darci.** Delle 8 fonti
sondate, 5 non si sono fatte leggere. Delle 2 che hanno funzionato, il Code
Base ha restituito **200 titoli** di cui **7 in tema**, e di quei 7 la
maggioranza e' **la stessa scatola dei 15 minuti** che abbiamo gia' seppellito
48 volte su 48 — compreso l'EA in affitto a 99 USD/mese arrivato a caccia in
corso, che aggiunge tre medie mobili e una funzione di recovery a un motore
morto.

**Un solo oggetto ha portato un meccanismo davvero diverso, e non era
catalogato come "London": e' un file di 287 righe con 3 input, scritto sopra
un template MetaQuotes, con un bug di overflow dentro.** E' esattamente il
profilo che il §5F descrive: **motore sano, gestione da rifare.**

Se il verdetto del gradino A fosse negativo, **la conclusione corretta non
sara' "cerchiamo un altro EA di Londra": sara' che l'apertura di Londra, per
come il mercato la tratta oggi, non e' un evento su cui abbiamo un edge — e
che il tempo va speso sui buchi veri del portafoglio** (short, laterale,
crollo) invece che su una sessione che ci ha gia' detto di no in cinque modi
diversi.

---

_Dossier compilato il 19/08/2026. Fonti aperte davvero: MQL5 Code Base
(5 sorgenti `.mq5` scaricati e letti), arXiv (1 paper, metadati verificati).
Fonti dichiarate NULLE: SSRN, TradingView (pagine script), GitHub,
Forex Factory, Quantpedia, RePEc. Nessun numero di performance di autore e'
stato usato nei punteggi._

_Attribuzione, come da regola di casa: `Liquidity Sweep H4 - M15` e'
di **OsmarSandovalEspinosa** (MQL5 Code Base, 2026.03.23) — la citazione va
ripetuta in testa a qualunque `.mq5` derivato._
