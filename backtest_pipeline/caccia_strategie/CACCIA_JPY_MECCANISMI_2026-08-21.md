# 🏹 CACCIA JPY — MECCANISMI DIVERSI DAL BREAKOUT MORTO (21/08/2026)

**Mandato:** REGOLA DELLA SECONDA CACCIA (CLAUDE.md, firmata il 19/08). Il
motore morto e' il **BREAKOUT DEL CORSO sui cross JPY** — R82, chiuso il
18/08 con **zero vincitori su sette**. Si cercano **MECCANISMI ALTERNATIVI
sulla stessa inefficienza** (compressione -> espansione sui cross JPY), mai
"parametri diversi dello stesso motore morto".

**Risultato in una riga:**

> Su **28 oggetti guardati** (815 titoli EA del Code Base setacciati per
> parola chiave, 6 sorgenti `.mq5` **scaricati e letti riga per riga**, 1 repo
> GitHub letto nel README, 2 pagine Quantpedia, 4 interrogazioni all'API arXiv),
> **1 solo candidato esterno arriva al sorgente con un meccanismo davvero
> diverso**, **1 candidato interno gia' scritto e' la prova piu' economica che
> abbiamo**, **1 tesi accademica resta IN CODA perche' il paper non e'
> raggiungibile**, e **tutto il resto e' il motore morto con un'altra scatola**.
>
> 🔴 **Il reperto piu' importante di questa caccia e' negativo e va detto
> subito: sull'inefficienza "compressione JPY -> espansione", il web gratuito
> offre quasi SOLO breakout da inseguire.** Su 815 titoli EA del Code Base, i
> filtri `asian|tokyo|jpy|yen|sweep|fade|false|reclaim|session|night|carry`
> tirano fuori **7 titoli**, e **sei sono breakout di inseguimento**. La
> famiglia che il mandato chiede — **fade / sweep / rientro** — esiste in
> **un solo esemplare gratuito col sorgente**.

---

## 0. 📕 LA LISTA DEI CADUTI — riletta prima di uscire, e' il metro di scarto

| caduto | dove | meccanismo | verdetto misurato DA NOI |
|---|---|---|---|
| **R82 — BreakoutCorso, 7 cross JPY** | `REFERTO_ROUND82_TORNEO_JPY.md` | rettangolo mobile 20 candele M15 + Williams 140 + SuperTrend, rottura secca | **0 vincitori su 7.** PF OOS 0,769-0,980. 264-2.138 op/finestra. Unico lampo EURJPY IS 1,112 -> OOS 0,902 |
| **R42 — FADE degli estremi del range** | `REFERTO_ROUND42_FADE.md` | fade **sull'estremo** del range di apertura (15'/35') | **0/24 IS e 0/24 OOS**, PF 0,50-0,93. Diagnosi: *"e' morto il MOTORE, non la gestione"* |
| **R45 — ORB di sessione Londra** | `REFERTO_ROUND45_LONDRA.md` | range 07:00->07:15/07:30 server, conferma su chiusura M5 | **0 celle positive su 48** |
| **capitolo BREAKOUT M5** | `REGISTRO_TEST.md` §2 | Live5m, Live5m_v2, DAX_M3, ORB_Fibo, Londra_ORB | **CHIUSO il 26.07.26** a tick reali |
| **R89 — Liquidity Sweep GBPUSD** | `REFERTO_R86_R87_R89_NOTTE.md` | sweep+reclaim su swing H4 a 21 barre | **NON bocciato: non misurabile.** n IS = 14 (canarino 30). Testuale: *"NON e' una bocciatura del meccanismo: e' la prova che con 21 barre H4 per lato i livelli sono troppo pochi... servono swing piu' corti"* |
| **famiglia JPY, altri motori** | prove `R22`, `R39d`, `R40b/d`, `R48/49`, `R23c`, `R79` | SupRev GBPJPY, Larry GBPJPY, CostToCost CHF/EURJPY, EasyTrend CHF/AUDJPY, PTE USDJPY | vincolo firmato: **dalla famiglia JPY entra al massimo UNA sedia, mai il paniere** |

### 🎯 Le due frasi dei referti che ho usato come bussola (citate, non parafrasate)

1. **R42:** _"L'unica cosa che ha sempre pagato e' il **RETEST** — entrare sul
   RITORNO al livello DOPO la rottura confermata"_.
2. **R45:** _"il box notturno paga sul **RANGE DELLA NOTTE** (ore di accumulo),
   non sul quarto d'ora dell'apertura europea"_.

> Messe insieme sono la specifica del candidato che cercavo: **un livello
> costruito in ORE, e un ingresso sul RITORNO dentro il livello, non sulla
> rottura.** Su tutto il materiale gratuito guardato oggi, **due oggetti
> soddisfano entrambe** — uno esterno e uno che abbiamo gia' in casa.

---

## 1. 🔌 CONTROLLO POSITIVO SU OGNI FONTE — misurato oggi, 21/08

| fonte | HTTP | contenuto verificato | esito |
|---|---|---|---|
| **MQL5 Code Base** | 200 | `/en/code/mt5/experts` pagine 1-20 rendono titolo+id nell'HTML; sulla scheda `68082` leggo titolo, autore **Peter Mueller (Mullerp04)**, data **2026.01.10**, **`UserDownloads:795`**. `/en/code/download/<id>` restituisce lo **ZIP col `.mq5`** | 🟢 **PASSA in pieno** (titolo+autore+data+download+**sorgente**) |
| **arXiv (API)** | 200 | `cat:q-fin.TR` recenti rende titoli/autori/date veri (es. 2026-08-19 *Concentrated Liquidity Provision*) | 🟢 **PASSA** come canale, 🔴 **STERILE** come contenuto: vedi §5 |
| **GitHub — `raw.githubusercontent.com`** | 200 | README di `MHZardary/london-strategy-backtest` letto per intero (11.881 byte, branch `master`) | 🟢 **PASSA per la LETTURA**, 🔴 **NULLO per la RICERCA** |
| **GitHub — `github.com` e `api.github.com`** | **403** | ricerca web e API respinte dal proxy; `gh` CLI assente | 🔴 **NULLA.** I repo li ho trovati solo di rimbalzo dal motore di ricerca |
| **TradingView** | 200 | ⚠️ **novita' rispetto al 19/08**: `/scripts/breakout/` ora rende **i link `/script/`** nell'HTML, e la scheda del singolo script rende **titolo e autore** (verificato su *Range Commander ORB [JOAT]* di `officialjackofalltrades`). **Ma il sorgente Pine NON e' nell'HTML** (zero occorrenze di `//@version`, `strategy(`, `indicator(`) | 🟡 **METADATI SI', SORGENTE NO** -> **non setacciabile** (§4: senza sorgente il setaccio non e' applicabile) |
| **Quantpedia** | 200 | `/strategies/` rende **82 slug** veri; scheda `fx-carry-trade` leggibile con regole, fonte e numeri | 🟢 **PASSA** (sezione gratuita) |
| **SSRN** (`papers.ssrn.com`, anche via URL `Delivery.cfm`) | **403** Cloudflare *"Just a moment..."* | — | 🔴 **NULLA** |
| **snb.ch** (working paper Ranaldo) | **403** al CONNECT | — | 🔴 **BLOCCATA DAL PROXY** |
| **efmaefm.org** (PDF alternativo dello stesso paper) | **403** al CONNECT | — | 🔴 **BLOCCATA DAL PROXY** |
| **api.semanticscholar.org** | **403** al CONNECT | — | 🔴 **BLOCCATA DAL PROXY** |
| **Forex Factory** | **403** | — | 🔴 **NULLA.** I thread storici sui cross JPY — cioe' l'unico posto dove si legge **come una strategia e' invecchiata** — **non li ho potuti leggere** |

**Traduzione onesta:** hanno funzionato **MQL5 Code Base**, **arXiv**,
**Quantpedia** e **la lettura raw di GitHub**. **Non ho potuto leggere nessun
paper SSRN e nessun thread di Forex Factory**, e **non ho potuto leggere una
sola riga di Pine** su TradingView.

### Cosa ho sfogliato dove ha funzionato
- **MQL5 Code Base:** **20 pagine** di `/en/code/mt5/experts` -> **815 id EA
  unici** raccolti. Filtro per
  `jpy|yen|asian|asia|tokyo|sweep|liquidity|fade|false|fake|reject|reclaim|trap|squeeze|compress|volatilit|session|night|carry`
  -> **7 titoli in tema**. Piu' 2 ricerche mirate sul dominio.
  **6 sorgenti `.mq5` scaricati e letti**: 68082, 20815, 43252, 30304, 58135, (68951 gia' in casa).
- **arXiv:** 4 interrogazioni API (`cat:q-fin.TR` recenti; `all:JPY`;
  `all:"carry trade"`; `abs:"foreign exchange" AND abs:intraday AND abs:seasonality`).
- **GitHub:** 1 repo letto integralmente nel README + sezione Results.
- **Quantpedia:** 82 slug gratuiti elencati, 1 scheda letta per intero.

---

## 2. 📊 TABELLA DEI CANDIDATI — tutti, coi motivi

| # | nome | fonte | meccanismo | perche' NON e' il motore morto con altri parametri | confronto coi caduti | esito |
|---|---|---|---|---|---|---|
| 1 | **`ABTG_LiquiditySweep`** su cross JPY, struttura piu' corta | in casa — motore da [MQL5 68951](https://www.mql5.com/en/code/68951) | **sweep + reclaim** su livello di swing: entra **solo se la barra chiude di nuovo DENTRO** dopo aver bucato | il motore morto **insegue** la rottura; questo **la fade dopo il rientro**. Direzione opposta, grilletto opposto, SL dalla parte opposta | R42 fadeva **sull'estremo senza sweep** e su box di 15' -> qui serve **l'escursione fuori + il rientro** su livello di ore. R89 **non l'ha bocciato**: l'ha dichiarato non misurabile per rarita' | 🟢 **PROVA SUBITO** |
| 2 | **`DataTraderH4Breakout.mq5`** (*Viral 4 Hour Range Strategy*) | [MQL5 68082](https://www.mql5.com/en/code/68082) | box di **4 ore di accumulo** ancorato alla sessione + **fade sul rientro** + SL **oltre l'estremo dello sweep** + TP 2R | il box e' **costitutivo** (lo costruisce la sessione, non un contatore di candele) e l'ingresso e' **contro** la rottura: sono due cambi di natura, non due valori | soddisfa **entrambe** le frasi di R42 e R45. Non e' l'ORB di R45 (4 ore contro 15 minuti) e non e' il fade di R42 (richiede rottura + rientro) | 🟢 **PROMOSSO — serve l'EA** |
| 3 | **Time-of-day / domestic currency bias** (Ranaldo 2007-2009) | [SNB WP 2007-03](https://www.snb.ch/en/publications/research/working-papers/2007/working_paper_2007_03) · [SSRN 960209](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=960209) | *la valuta domestica si DEPREZZA nelle ore lavorative domestiche e si APPREZZA in quelle estere* -> sui cross JPY: **long il cross nelle ore di Tokyo, short nelle ore europee** | non usa nessun rettangolo, nessuna rottura, nessun indicatore: **solo l'orologio**. E' l'unico oggetto che spiega perche' esiste la compressione, invece di misurarla | ortogonale a tutti i caduti: nessun round nostro ha mai testato una direzionalita' **oraria pura** | 🟡 **IN CODA** — ⚠️ **paper NON LETTO** (§5) |
| 4 | `Night Flat Trade` | [MQL5 20815](https://www.mql5.com/en/code/20815) | fade dentro il flat notturno, ingresso al quarto inferiore/superiore del range di 3 barre | e' **R42 con un altro nome**: fade **sull'estremo**, senza sweep e senza rientro | famiglia gia' bocciata 0/24+0/24 | 🔴 **SCARTO** (+ **codice rotto**, §4.1) |
| 5 | `V1N1 LONNY MT5` | [MQL5 73210](https://www.mql5.com/en/code/73210) | range asiatico + **pending stop** in apertura Londra + PSAR/MACD/Stocastico | e' il motore morto con **una scatola oraria e tre filtri appiccicati** | filtro aggiunto a motore gia' tarato = **0 successi su 5** (R20/R12/R26/R45/R54). Gia' letto nella caccia del 19/08 | 🔴 **SCARTO** |
| 6 | `GoldLondonBreakout` | [MQL5 75586](https://www.mql5.com/en/code/75586) | range asiatico su XAUUSD + OCO all'apertura di Londra | breakout da inseguire, e per giunta non JPY | gia' setacciato: *"l'abbiamo gia' fatto, e si chiama R45"* (`SETACCIO_MANUALE.md`) | 🔴 **SCARTO (gia' setacciato)** |
| 7 | `Session Opening Range Breakout EA` | [MQL5 76153](https://www.mql5.com/en/code/76153) | high/low della finestra di apertura + rottura confermata | stesso motore, altra finestra | gia' setacciato il 16/08: *"il migliore dei cinque, e comunque non entra"* | 🔴 **SCARTO (gia' setacciato)** |
| 8 | `Universal Breakout Study` | [MQL5 73711](https://www.mql5.com/en/code/73711) | studio di breakout su N candele H1, sessione configurabile via GMT | e' letteralmente la macchina per spazzolare parametri del motore morto | gia' setacciato: *"38 input, e tre sono giorni della settimana"* | 🔴 **SCARTO (gia' setacciato)** |
| 9 | `Easy Range Breakout EA - MT5` | [MQL5 68764](https://www.mql5.com/en/code/68764) / [71460](https://www.mql5.com/en/code/71460) | range fra due orari + rottura | stesso motore, altra scatola | famiglia R45 / capitolo breakout chiuso | 🔴 **SCARTO** |
| 10 | `Range BreakOut EA` | [MQL5 26451](https://www.mql5.com/en/code/26451) | rottura del range | idem | gia' setacciato: *"pulito, minuscolo, e non serve"* | 🔴 **SCARTO (gia' setacciato)** |
| 11 | `london-strategy-backtest` | [GitHub MHZardary](https://github.com/MHZardary/london-strategy-backtest) | breakout del range asiatico 00:00-07:00 GMT su **GBPJPY**/EURUSD/GBPUSD, con MACD+RSI+news+SMA | breakout inseguito + **quattro filtri appiccicati sopra** | **vale come PROVA INDIPENDENTE, non come candidato**: §6 | 🔴 **SCARTO come candidato, 🟢 TENUTO come evidenza** |
| 12 | `FX Carry Trade` | [Quantpedia](https://quantpedia.com/strategies/fx-carry-trade/) | long le 3 valute a tasso alto, short le 3 a tasso basso, ribilancio mensile | e' la tesi macro dello yen come valuta di funding — **ma non e' un motore intraday** | ortogonale ai caduti, e **non traducibile**: §4.3 | 🔴 **SCARTO (non traducibile)** |
| 13 | `Reversal Strategy` | [MQL5 43252](https://www.mql5.com/en/code/43252) | Bollinger + RSI, mean reversion generica su M5 | non e' sull'inefficienza JPY: e' un mean-reversion da manuale | doppione della famiglia BB gia' in casa | 🔴 **SCARTO** (lotto fisso `my_lot=1`, hedging obbligatorio) |
| 14 | `Range Follower` | [MQL5 30304](https://www.mql5.com/en/code/30304) | quando il range del giorno raggiunge il 60% dell'ATR(20) D1, entra sul residuo | inefficienza **diversa** (completamento dell'ADR), non compressione->espansione | nessun caduto corrispondente, ma fuori mandato | 🔴 **SCARTO** (lotto fisso 0,1; **SL 60% ATR contro TP 40% ATR = R:R 0,67**) |
| 15 | `MeanReversion.mq5` (Yashar Seyyedin) | [MQL5 58135](https://www.mql5.com/en/code/58135) | minimo/massimo delle ultime 200 barre -> ritorno al punto medio | — | **GIA' SETACCIATO E PROMOSSO 9/10 il 16/08** | ⚪ **NON RICONTROLLATO** (regola di casa) |
| 16 | `False Breakout Detector` | [MQL5 Market 145504](https://www.mql5.com/en/market/product/145504) | rilevatore di falsi breakout | — | **Market = compilato, senza sorgente** | ⛔ **FUORI PERIMETRO** (§4: niente sorgente = niente setaccio) |
| 17-28 | 12 titoli TradingView (`Range Commander ORB [JOAT]`, `Compression Breakout Follow-Through`, `Tyson Uppercut Compression Spring Breakout`, ...) | [TradingView `/scripts/breakout/`](https://www.tradingview.com/scripts/breakout/) | dichiarano compressione/breakout | — | **sorgente Pine non leggibile dall'HTML** | ⛔ **NON VALUTABILI** — dichiarati, non scartati |

---

## 3. 🟢 IL CANDIDATO NUMERO UNO — e non viene dal web: **ce l'abbiamo gia'**

### `ABTG_LiquiditySweep` portato sui cross JPY, con struttura piu' corta

```
NOME            ABTG_LiquiditySweep.mq5 (nostro, 1.137 righe)
MOTORE ORIGINE  "Liquidity Sweep H4 - M15 (Swing Highs and Lows) / MQL5"
FONTE / URL     https://www.mql5.com/en/code/68951   [VERIFICATO, sorgente letto il 19/08]
AUTORE / DATA   OsmarSandovalEspinosa — 2026.03.23   [VERIFICATO sulla pagina]
LICENZA         header MQL5 di default; Code Base = download gratuito. [INCERTO] licenza esatta
STATO IN CASA   CANDIDATO, mai promosso. Girato UNA volta (R89, GBPUSD).
                Attribuzione gia' nell'header del nostro .mq5.
COSTO DI PORTING  ZERO ORE. L'EA esiste, compila, ha gia' la nostra gestione.
```

**MECCANISMO IN TRE RIGHE** _(letto nel sorgente il 19/08, inputs riletti oggi)_
1. **Il livello:** swing simmetrico sul TF di struttura (`InpTF_Struttura`),
   confermato da `InpSwingBars` barre per lato.
2. **Il grilletto:** su chiusura della barra del grafico, il prezzo ha **bucato**
   il livello e ci e' **rientrato dentro** -> entra **contro la rottura**.
3. **Uscita:** SL **strutturale oltre l'estremo dello sweep** + 0,5 ATR di
   respiro (`InpSLMode=0`), TP a 2R, breakeven a 1R. Il livello si **consuma**:
   vale una volta sola.

**TESI IN UNA RIGA**
> _"Sui cross JPY la compressione esiste davvero (il corso lo dice, R82 lo
> conferma contando 264-2.138 rotture per finestra), ma **la rottura non paga**:
> chi entra sulla rottura e' il carburante di chi la fade. Guadagna chi aspetta
> che il prezzo torni dentro."_

### 🎯 PERCHE' PROPRIO QUESTO, E PERCHE' ADESSO — i tre motivi, in ordine

**1. R89 ha scritto DA SOLO la direzione, e questa e' esattamente quella.**
Testuale dal referto: _"NON e' una bocciatura del meccanismo: e' la prova che
con 21 barre H4 per lato i livelli sono troppo pochi. Se il motore merita un
round vero, servono **swing piu' corti** (o un TF di struttura piu' basso) — e
sarebbe un round nuovo, con criteri nuovi."_ **Questo e' quel round.**

**2. Il difetto di R89 era la RARITA', e i cross JPY sono la cura misurata.**
R89 su GBPUSD ha fatto **n IS = 14**, sotto il canarino di 30 e lontanissimo
dai 150 dell'Emendamento della Finestra. **R82 ha gia' misurato il traffico dei
cross JPY sulla stessa scala temporale**: da 264 (GBPJPY) a 2.138 (USDJPY)
operazioni **per finestra**, su M15. Non e' una speranza: e' un conteggio che
abbiamo gia' in mano. Abbassando `InpTF_Struttura` da H4 a H1 e `InpSwingBars`
da 21 a 8-10, **il campione smette di essere il problema**.

**3. Costa ZERO ore di sviluppo.** `InpTF_Struttura` e `InpSwingBars` **sono
gia' input** (righe 131 e 136 del nostro sorgente). Non serve scrivere niente,
non serve `mql5-ea-developer`: serve un file prova e una riga di lancio.

### ⚠️ I LIMITI, dichiarati prima dei numeri
- **Il merito di questo motore non e' MAI stato misurato.** R89 non lo ha
  bocciato, ma nemmeno promosso: n=14 significa che **non sappiamo niente**.
  Chiunque legga "R89 ha dato PF 0,23 in IS" sta leggendo rumore, non un edge.
- **Abbassare gli swing e' una manopola.** Va spazzolata **stretta** (2-3
  valori), e la cella si sceglie al **centro dell'altopiano, mai al picco**
  (12 Spearman IS->OOS negative su 13).
- **E' un motore controtendenza su livello:** incassa **serie di stop** in un
  trend forte. Sui cross JPY, che sono la definizione stessa di trend forte
  quando parte il carry, questa e' la debolezza vera. **La peggior giornata si
  misura, non si stima.**
- **Il vincolo di portafoglio resta in vigore:** dalla famiglia JPY entra al
  massimo **UNA** sedia. Se questo round producesse due cross buoni, ne passa
  uno solo.

```
PUNTEGGIO
  [2] semplicita' — il motore e' ~40 righe di logica, 5 input di motore
  [2] il filtro E' il motore — non c'e' nessun filtro: c'e' solo il motore
  [2] tesi di mercato scrivibile — sopra, e regge
  [2] riempie un BUCO — motore SIMMETRICO vero (long e short dallo stesso
      codice) su una famiglia dove abbiamo solo motori direzionali morti
  [2] testabile senza riscritture — e' gia' nostro, gia' nella nostra grammatica

VERDETTO   🟢 PROVA SUBITO (10/10)
PERCHE'    e' l'unico modo di rispondere alla domanda di R82 (fade invece di
           inseguimento) senza scrivere una riga di codice, e la direzione
           gliela ha data per iscritto il referto R89.
```

### 🏛️ In ottica prop
Motore **event-driven**: ogni livello vale **una volta sola** e viene consumato,
quindi non spara 5 trade correlati la stessa mattina — che e' il rischio
**giornaliero** che `METRO_PROP.md` teme (muro a −5.000 su 100k). ⚠️ **Il
rovescio, e va scritto anche se e' sfavorevole:** abbassando `InpSwingBars` la
frequenza sale, e con lei sale la **concentrazione giornaliera**. Il tetto
`InpMaxTradesPerDay` esiste nell'EA ma **e' un filtro travestito**: non si
accende dentro il round che misura il motore. Si misura prima **quanti trade al
giorno fa**, poi si decide.

---

## 4. 🟢 IL CANDIDATO ESTERNO — l'unico che ha superato il sorgente

### `DataTraderH4Breakout.mq5` — *"Viral (1M+ views) 4 Hour Range Strategy coded and tested"*

```
NOME            Viral (1M+ views) 4 Hour Range Strategy coded and tested
FONTE / URL     https://www.mql5.com/en/code/68082   [SORGENTE SCARICATO E LETTO]
AUTORE / DATA   Peter Mueller (Mullerp04) — 2026.01.10   [VERIFICATO sulla pagina]
POPOLARITA'     UserDownloads: 795 · valutazione 4,7 su 88 recensioni [VERIFICATO]
LICENZA         #property copyright "Mueller Peter" + link al profilo autore.
                Code Base = download gratuito. [INCERTO] licenza esplicita assente.
RIGHE / INPUT   303 righe · **3 input operativi** (+4 di fuso orario)
COSTO DI PORTING  gia' MQL5 -> 0 ore di traduzione. ~4-6 ore di riscrittura
                  della gestione (e ~150 righe di macchina fusi da BUTTARE).
```

**MECCANICA — letta nel codice, non nella descrizione**

1. **Il box (righe 285-303, `RangeForming`):** accumula high/low delle candele
   M5 mentre l'ora locale di **New York** e' fra **00:00 e 04:00**
   (`TimeNewyorkFirst_4_H`, righe 270-282). Quando la finestra finisce, il box
   si congela. **Quattro ore di accumulo**, ricalcolate ogni giorno.
2. **Il grilletto (righe 65 e 88):**
   ```cpp
   if(iClose(M5,1) > RangeBottom && iClose(M5,2) < RangeBottom)   // BUY
   if(iClose(M5,1) < RangeTop    && iClose(M5,2) > RangeTop)      // SELL
   ```
   Cioe': **una candela M5 ha chiuso FUORI dal box, la successiva ha chiuso di
   nuovo DENTRO** -> si entra **contro la rottura**. E' un **fade del falso
   breakout su rientro confermato**.
3. **Lo stop (righe 68-80 e 91-103):** risale all'indietro finche' le chiusure
   stanno fuori dal box e prende **l'estremo dell'escursione** -> **SL
   strutturale oltre lo sweep**. **TP = 2 x la distanza dello stop.** Entrambi
   mandati al broker.
4. **Il filtro nascosto (righe 76 e 99, `if(i > 15) return;`):** se
   l'escursione fuori dal box e' durata **piu' di 15 candele M5 = 75 minuti**,
   il segnale viene **silenziosamente scartato**. L'autore lo conferma nella
   descrizione: _"A time filter invalidates trades if price remains extended
   beyond the range for more than 75 minutes"_. **E' una regola vera, non un
   dettaglio: e' cio' che distingue uno SWEEP da una vera espansione.**

**TESI IN UNA RIGA**
> _"Dopo quattro ore di accumulo, la prima rottura del box e' quasi sempre una
> raccolta di stop: se il prezzo rientra entro 75 minuti, l'espansione non
> c'era e chi e' entrato sulla rottura deve uscire — e la sua uscita e' il
> movimento."_

### 🎯 PERCHE' NON E' IL MOTORE MORTO CON ALTRI PARAMETRI — punto per punto

| | R82 (BreakoutCorso, morto) | questo |
|---|---|---|
| **da dove nasce il livello** | rettangolo **mobile di 20 candele M15**, ricalcolato a ogni chiusura, **senza ancora oraria** (§2.3 della spec: *"nessun filtro orario, 24/5"*, ed e' **esplicito**, non dimenticato) | box **ancorato a una finestra di 4 ore**, uno al giorno |
| **verso dove entra** | **con** la rottura (inseguimento) | **contro** la rottura, dopo il rientro |
| **cosa conferma** | il Williams in zona + il SuperTrend + 20 candele trascorse | **il rientro stesso**, piu' un tetto di 75 minuti |
| **dove sta lo stop** | buffer in pip oltre il bordo del rettangolo | **all'estremo dell'escursione fuori** (piu' lontano, e strutturale) |
| **quanti indicatori** | 2 (Williams 140, SuperTrend) | **zero** |
| **input liberi** | 16 nel file prova R82 | **3** |

> ✅ **Sono tre cambi di natura, non tre valori:** ancora oraria costitutiva,
> direzione invertita, stop di struttura. E il tetto dei 75 minuti e' una
> regola che **il motore morto non ha in nessuna forma**.

### 🔬 IL PUNTO CHE VALE PIU' DEL CODICE: il box non e' quello che dice il nome

`00:00-04:00 di New York` non e' "la sessione asiatica" come si legge in giro.
Convertito: NY 00:00 = **05:00 UTC d'inverno / 04:00 UTC d'estate**, quindi il
box copre **04:00-08:00 UTC** (estate) — cioe' **la coda di Tokyo piu' il
pre-apertura di Londra**. `[INFERITO]` dalle righe 200-240 del sorgente
(`NY_DST_Start_UTC`, `NewYorkGMTOffsetHoursFromUTC`).

**Per i cross JPY questa e' la finestra giusta, non quella sbagliata:** e'
esattamente dove il cross comprime prima che l'Europa lo apra. **E' anche il
motivo per cui il fallimento dichiarato dall'autore su EURUSD non e' un
verdetto per noi**: su EURUSD quella finestra e' rumore notturno, sui cross JPY
e' la fase di accumulo del simbolo.

⚠️ **Numeri dell'autore, riportati e NON pesati** [dichiarato dall'autore, NON
verificato da noi]: _"Backtests on EURUSD under my conditions were
unprofitable."_ Vale zero come promozione **e zero come bocciatura**: e' un
simbolo che non e' il nostro bersaglio, su una parametrizzazione che non e' la
nostra, senza costi dichiarati.

### 🔴 BANDIERE ROSSE (§4): NESSUNA — verificata a grep e a mano
Niente martingala (nessuna dipendenza del lotto dall'esito precedente), niente
griglia, niente hedge di copertura, **niente `#import`/`WebRequest`/`iCustom`**,
**SL e TP mandati al broker** (righe 82 e 105). L'unica occorrenza di `GRID` e'
`CHART_SHOW_GRID` alla riga 35 (cosmetica). **Nessun look-ahead**: decide su
`iClose(M5,1)` e `iClose(M5,2)`, cioe' **due candele chiuse**, dentro
`if(IsNewCandle())`.

### 🔧 COSA TERREI / COSA RIFAREI — la separazione del §5F

**DA TENERE (il motore, ~60 righe):** costruzione del box su finestra ancorata ·
condizione di **rientro** su chiusura M5 · **SL all'estremo dell'escursione** ·
**tetto dei 75 minuti** sulla durata dello sweep · TP 2R · una posizione per volta.

**DA RIFARE (la gestione — la parte che sappiamo fare):**

| difetto, con la riga | perche' morde | cosa ci mettiamo |
|---|---|---|
| `input double Lots = 0.1;` (riga 21), usato secco in `Trade.Buy/Sell` | **lotto fisso**: non scalabile a 100k, non confrontabile coi nostri round | **rischio % dell'equity** (0,65% di campo, 1,0% nei round) |
| `PositionsTotal() == 0` (riga 62) | 🔴 **DIFETTO GRAVE SUL NOSTRO CONTO**: conta **tutte** le posizioni dell'account, non quelle di questo EA. Sul VPS con 8 sedie accese **questo EA non aprirebbe MAI** | conteggio **filtrato per magic**, come tutti i nostri |
| ~150 righe di macchina fusi (`ServerGMTOffset*`, `NY_DST_*`, `UTCToNewYork`) | e' un generatore di errori: **quattro input** che descrivono il broker, non la strategia. E il DST del broker non e' il DST di NY | **si butta**: un input di **ora SERVER** di inizio e uno di fine, come in tutti i nostri EA. Regola di casa: server BCM = ora italiana − 1 |
| nessun filtro di spread | R55: lo spread va misurato **in % dello stop**, non in punti | il nostro filtro standard |
| `CTrade Trade;` istanziato **dentro** il blocco del segnale (righe 81, 104) | il magic number **non viene mai impostato** -> gli ordini escono con magic 0, **non riconoscibili** | oggetto unico con magic dichiarato |
| nessun breakeven, nessun parziale | TP secco a 2R | **parziale 1R + breakeven + runner 2R** (le nostre DAX/Dow) |
| box non validato | se la finestra e' vuota (festivo) il box resta quello vecchio | invalidazione esplicita + canarino di conteggio |

```
PUNTEGGIO
  [2] semplicita' — 3 input operativi, zero indicatori
  [2] il filtro E' il motore — l'ancora oraria COSTRUISCE il livello,
      non filtra un motore gia' tarato (§5B: filtro-motore = miglior
      risultato del progetto; filtro appiccicato = 0 su 5)
  [2] tesi di mercato scrivibile — sopra, e regge fra un mese
  [2] riempie un BUCO — fade simmetrico su una famiglia dove abbiamo solo
      inseguimenti morti, e nella fascia oraria Tokyo->pre-Londra che
      NESSUNA sedia viva copre
  [1] testabile senza riscritture — e' MQL5 e non ha dipendenze, ma la
      gestione va rifatta e la macchina fusi va buttata: serve un EA nuovo

VERDETTO   🟢 PROMOSSO (9/10) — ma richiede mql5-ea-developer
PERCHE'    e' l'UNICO oggetto gratuito col sorgente, su tutte le fonti
           raggiunte, che soddisfa insieme le due frasi di R42 e R45.
```

### 🏛️ In ottica prop
**Al massimo 2 segnali al giorno** (uno per bordo, e la posizione singola ne
ammette una alla volta): frequenza bassa e prevedibile, che e' cio' che serve
contro il muro **giornaliero** del 5%. ⚠️ **Il rovescio:** e' controtendenza, e
nei giorni di espansione vera (quelli che il motore morto cercava) **prende lo
stop su entrambi i bordi**. Due stop in una giornata a 0,65% sono ~1,3-2%: sotto
il cap, ma va **misurata la peggior giornata**, che sulla nostra scala (R51)
vale **−2,06%**.

---

## 4.1 🐛 IL REPERTO DEL SORGENTE — `Night Flat Trade` non trada, e si vede dal codice

Vale la pena scriverlo perche' e' la dimostrazione che **la descrizione mente e
il codice no**. [MQL5 20815](https://www.mql5.com/en/code/20815),
`barabashkakvn`, 2018.06.18, righe 119-121:

```cpp
double highest = iHighest(m_symbol.Name(),Period(),MODE_HIGH,3,0);
double lowest  = iLowest( m_symbol.Name(),Period(),MODE_LOW, 3,0);
double diff    = highest-lowest;
```

`iHighest`/`iLowest` restituiscono **l'INDICE della barra**, non il prezzo. Quindi
`diff` vale **0, 1 o 2** — mentre `ExtDiffMin`/`ExtDiffMax` valgono 18 e 28 **pip
convertiti in prezzo** (0,0018 e 0,0028). La condizione
`diff > 0,0018 && diff < 0,0028` **non e' mai vera**: con `diff=0` fallisce la
prima, con `diff>=1` fallisce la seconda. **[INFERITO dalle righe 119-133: questo
EA non apre mai una posizione.]** In piu' `m_symbol.Bid() > lowest` confronta un
prezzo (~1,09) con un indice (0-2): **sempre vero**, quindi senza significato.

Sarebbe stato scartato comunque (fade sull'estremo = famiglia R42; EURUSD e H1
**cablati** in `OnInit`; sizing `CMoneyFixedMargin` con `Risk=5`, che e' **margine
in %, non rischio in %**). Ma il motivo vero e' che **non funziona**.

---

## 4.3 ⚖️ Il carry/risk-off: perche' NON diventa un candidato (per ora)

Il mandato chiedeva se esiste letteratura sullo yen come proxy del risk
sentiment e se se ne puo' fare un motore. **La risposta misurata su cio' che ho
potuto leggere e': si' esiste, no non e' traducibile da noi.**

- **`FX Carry Trade`** ([Quantpedia](https://quantpedia.com/strategies/fx-carry-trade/), sezione gratuita, **letta per intero**):
  regola dichiarata — _"Go long three currencies with the highest central bank
  prime rates and go short three currencies with the lowest"_, universo di
  **10-20 valute**, ribilancio **mensile**. Numeri dichiarati dalla fonte
  (indice Deutsche Bank Currency Carry USD, 1989-2009, **NON verificati da
  noi**): rendimento **7,27%**, Sharpe **0,29**, **max drawdown −32,05%**.
- **Perche' esce dall'imbuto, in tre righe:**
  1. serve un **portafoglio cross-sectional di 10-20 valute con i tassi di
     policy**: nel tester MT5, su un simbolo alla volta, **non si costruisce**;
  2. **e' mensile**, e la nostra unita' di misura sono le operazioni: 150
     operazioni IS vorrebbero **12 anni** di ribilanci;
  3. **DD −32,05% dichiarato** contro un muro prop del **10%** e un DD storico
     di portafoglio nostro del **5,50%**. Non e' un margine da limare: e' 3x.
- **Cosa RESTA di utile, ed e' molto:** e' la spiegazione economica del perche'
  i cross JPY hanno **trend violenti e crolli asimmetrici**, cioe' **perche' un
  motore controtendenza su questa famiglia va misurato sulla peggior giornata,
  non sul PF**. Questo entra nei criteri dei round §3 e §4, non nel catalogo.

---

## 5. 🟡 IN CODA — la tesi che non ho potuto leggere

### Time-of-day / domestic currency bias (Ranaldo)

```
NOME       Segmentation and Time-of-Day Patterns in Foreign Exchange Markets
AUTORE     Angelo Ranaldo
DOVE       SNB Working Paper 2007-03 · SSRN abstract 960209 ·
           poi Journal of Banking & Finance, vol. 33 n. 12, dicembre 2009
STATO      🔴 PAPER **NON LETTO**: snb.ch, efmaefm.org, papers.ssrn.com e
           api.semanticscholar.org sono TUTTI respinti (403 al CONNECT o
           Cloudflare). Ho letto SOLO l'abstract riportato dal motore di
           ricerca. [INCERTO su tutto cio' che non e' l'abstract]
```

**La tesi dichiarata (abstract):** _"Domestic currencies appreciate
(depreciate) systematically during foreign (domestic) working hours"_, con la
spiegazione microstrutturale del **domestic currency bias** — durante le ore
lavorative locali prevalgono gli operatori domestici che **domandano la valuta
estera**, e questo genera **pressione al ribasso sulla valuta domestica**.

**Cosa sarebbe da noi:** sui cross JPY, **long il cross nelle ore di Tokyo**
(lo yen si indebolisce -> EURJPY sale) e **short nelle ore europee/americane**.
Due input di orario in ora server, zero indicatori, zero rettangoli.

**Perche' resta IN CODA e non va in cima:**
1. **Non ho letto il paper.** Non so su quali coppie, con quale campione, con
   quali costi, e **soprattutto non so se il JPY e' fra i casi dove l'effetto
   e' forte o fra quelli dove e' rumore**. Il protocollo di casa e' esplicito:
   se non l'ho aperto, non esiste.
2. **Il campione del paper e' 1993-2005 circa** `[INCERTO, dedotto dalla data
   di pubblicazione]`. **R82 ha appena mostrato la forma dell'edge mangiato**:
   EURJPY PF 1,112 nel 2007-2014 e 0,902 dopo. Un effetto documentato su dati
   di vent'anni fa merita **sospetto di decadimento**, non entusiasmo.
3. **Serve un EA nuovo** che ancora non esiste.

**Cosa servirebbe per portarlo nell'imbuto:** (a) una copia leggibile del paper
— la strada piu' probabile e' chiedere a Claudio di scaricarlo lui, o
sbloccare `snb.ch`/`ssrn.com` nel proxy (`PROMEMORIA_SBLOCCO_FONTI.md`);
(b) un EA a 2 input di orario; (c) un round di sola **direzionalita' oraria**
sui 7 cross, che e' un round grande. **Ordine di grandezza: 3-4 volte il costo
del candidato §3.** Non prima che il §3 abbia risposto.

---

## 6. 📌 L'EVIDENZA ESTERNA CHE VALE, ANCHE SE NON E' UN CANDIDATO

**`MHZardary/london-strategy-backtest`** — README **letto per intero** via
`raw.githubusercontent.com` (branch `master`, 11.881 byte).

E' un backtest Python **trasparente** del breakout del range asiatico
(00:00-07:00 GMT, M15, TP = 2x range, SL = 1x range, filtro news, SMA 50) su
**EURUSD, GBPUSD e GBPJPY**, 21/07/2024 -> 20/07/2025.

**Cosa dichiara l'autore** [dichiarato dalla fonte, NON verificato da noi]:
- in testa al README: _"My investigation shows **weak results** when applying
  this strategy. (At least with the most common variations on the mentioned
  markets)"_;
- **242 segnali totali** sui tre simboli, **accuratezza direzionale ~54,1%**,
  **PnL medio per trade +0,00018** con **deviazione standard 0,00429** — cioe'
  un rapporto segnale/rumore di circa **1 a 24**;
- 65 falsi long contro 74 veri, e la sua conclusione: _"a high number of false
  buy signals suggests further refinement is needed"_.

> 🎯 **Perche' lo tengo:** e' una **conferma indipendente, su GBPJPY, con
> metodo diverso dal nostro**, che il **breakout del range asiatico sui cross
> JPY non paga** — la stessa famiglia che R82 ha bocciato 7 volte su 7 con la
> scatola del corso. **Due misure indipendenti, due metodi, stesso segno.**
> E' l'argomento piu' forte che ho per dire che il §3 e il §4 (fade) sono la
> strada, e non "un'altra taratura del breakout".
>
> ⚠️ **Limiti dichiarati:** UN anno solo, 242 trade su TRE simboli (quindi
> ~80 per simbolo), nessun costo dichiarato, e quattro filtri sovrapposti —
> cioe' esattamente lo schema "filtro appiccicato a un motore gia' tarato"
> che da noi fa **0 su 5**. **Non e' una misura nostra e non entra in nessun
> referto come numero.** Entra come indizio.

---

## 7. 🚫 COSA NON HO POTUTO VEDERE — i buchi, dichiarati

1. **Nessun paper SSRN.** Cloudflare respinge anche l'URL diretto del PDF.
   Fra questi c'e' *"The Illusion of Breakouts: Empirical Evidence of
   Institutional Liquidity Capture in Major Currency Pairs"* (Rodrigo Costa,
   SSRN 6592020, aprile 2026), che dai risultati di ricerca dichiara di aver
   mappato **oltre 3.800 tentativi di breakout su EURUSD, GBPJPY, USDCAD,
   USDJPY, AUDUSD e oro (2016-2026)** e di trovare che il forex **invalida la
   rottura in oltre il 75% dei casi**. 🔴 **Non l'ho letto. Non e' una fonte,
   e' un titolo.** Se fosse vero sarebbe la prova accademica del candidato §4 —
   **ed e' esattamente per questo che non lo faccio pesare**: un paper del 2026
   di autore sconosciuto, non letto, con un risultato che mi fa comodo, e' il
   modo migliore per prendere una cantonata. **Va letto prima di citarlo.**
2. **Nessun thread di Forex Factory** (403). E' la fonte che serviva di piu':
   e' li' che si legge **come e' invecchiato** un sistema sui cross JPY, cioe'
   la domanda vera lasciata aperta da R82 (perche' EURJPY ha smesso nel 2014).
3. **Nessuna riga di Pine.** TradingView oggi rende titoli e autori ma **non
   il sorgente**: 12 script "compressione/breakout" restano **non valutabili**.
4. **Nessuna ricerca su GitHub** (403 su web e API): i repo li ho raggiunti
   solo di rimbalzo. Quello che c'e' su GitHub e non e' indicizzato dal motore
   di ricerca, **non l'ho visto**.
5. **arXiv e' STERILE su questa domanda, e l'ho misurato:** `all:JPY` restituisce
   4 paper di econofisica del 2001-2003 e 6 fuori tema; `all:"carry trade"`
   restituisce 3 paper di dipendenza di coda e 3 fuori tema; il listato recente
   di `q-fin.TR` e' **tutto microstruttura, market making e reinforcement
   learning**. **Zero meccanismi di sessione, zero JPY intraday.**

---

## 8. ✅ LA RACCOMANDAZIONE SECCA

| ordine | cosa | costo | chi lo fa |
|---|---|---|---|
| 🥇 **1** | **`ABTG_LiquiditySweep` sui cross JPY, struttura piu' corta** (§3) | **0 ore di codice** — file prova + riga di lancio | round nuovo, criteri nuovi |
| 🥈 **2** | **Motore fade su box di 4 ore ancorato alla sessione** (§4), riscritto con la nostra gestione | ~4-6 ore | `mql5-ea-developer`, **solo dopo** il verdetto del n.1 |
| 🥉 **3** | **Time-of-day di Ranaldo** (§5) | paper irraggiungibile + EA nuovo | **fermo** finche' il paper non si legge |
| ⛔ | **Tutto il resto** | — | scartato, §2 |

### 🔴 E QUELLO CHE VA SCARTATO SUBITO, anche se fa gola

**Il "lampo EURJPY" di R82 (PF IS 1,112 nel 2007-2014) NON e' un candidato, e
rimetterci le mani sarebbe la violazione esatta della Regola della Seconda
Caccia.** Il mandato chiedeva: *"cosa lo ha ucciso? costi? volatilita'? orario?"*
La risposta onesta e': **con gli strumenti di una caccia non si puo' sapere, e
provare a scoprirlo cambiando la gestione significa spazzolare parametri su un
motore che nella finestra recente fa PF 0,902 su 2.068 operazioni.** Su un
campione cosi' grande, PF 0,902 non e' sfortuna: e' il motore. E la regola dice
testualmente: **"MAI parametri diversi dello stesso motore morto"** — perche'
*"su un motore 0/48 un'altra griglia trova solo picchi di rumore, e la cella
verde per caso e' quella che brucia la challenge"*. Il referto R82 lo aveva gia'
messo per iscritto: **porta di rientro C3, solo con una tesi NUOVA, non con una
taratura.**

### ⚖️ E la domanda che il mandato poneva sulla SESSIONE — la mia risposta argomentata

> *"Il corso non distingue Tokyo/Londra/NY. Un breakout JPY filtrato per
> sessione e' un meccanismo diverso, non un parametro diverso?"*

**Dipende da COME entra la sessione, e la differenza e' misurata in casa:**

- ❌ **Se la sessione FILTRA il motore del corso** (stesso rettangolo mobile,
  stessa rottura inseguita, ma "solo fra le 8 e le 12") -> **e' un parametro
  diverso, ed e' vietato.** E' lo schema "filtro appiccicato a motore gia'
  tarato": **0 successi su 5** (R20 ADX, R12, R26, R45, R54). In piu' §2.3 della
  spec dice che il corso **ha escluso l'orario esplicitamente**, non lo ha
  dimenticato: aggiungerlo non e' completare la strategia, e' cambiarla di
  nascosto.
- ✅ **Se la sessione COSTRUISCE il livello** (il box **e'** le 4 ore di Tokyo,
  e senza quelle ore non esiste alcun livello) -> **e' un motore diverso**, ed
  e' il caso del candidato §4. E' il pattern `ABTG_EMA200` Dow di R29 — **il
  filtro che E' la strategia: 30 celle su 30 a PASS pieno**, il miglior
  risultato del progetto.

**Ma attenzione, e questa e' la parte scomoda:** il **breakout** di un box
ancorato alla sessione **e' gia' stato misurato due volte e non paga**
(R45 0/48 sulla nostra scala; MHZardary "weak results" su GBPJPY, §6). Quindi
la sessione costitutiva vale **solo accoppiata al FADE**, non all'inseguimento.
**E' esattamente il candidato §4, e nessun altro.**

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Sui cross JPY — dove R82 ha contato da 264 a 2.138 rotture per finestra e
> ha dimostrato che INSEGUIRLE non paga su nessuno dei sette — il RIENTRO dopo
> lo sweep ha un edge, una volta che il livello e' costruito abbastanza fitto
> da produrre un campione leggibile (>=150 operazioni IS)?"**

E la sotto-domanda che va letta **prima** del conto economico, come in R89:
**quanti livelli e quanti trade produce** `InpSwingBars` abbassato? Il canarino
`[LIQSWEEP][CONTEGGIO]` esiste apposta. **Se l'IS resta sotto 150, il round
misura il RISCHIO e sospende il MERITO** (valvola R59) — e la conclusione
sara' sulla frequenza, non sull'edge.

**Bozza di file prova (NON lanciabile cosi' com'e'):**
`backtest_pipeline/prove/JPY_LIQSWEEP_BOZZA.txt` — con i TODO obbligatori
elencati dentro (criteri da congelare, PASSO 0 sulla profondita' storica,
regime dichiarato). Non l'ho promosso a file di round: **i criteri si firmano
prima dei numeri, e non e' il cacciatore a firmarli.**

---

## 10. 📎 ATTRIBUZIONI

- `Liquidity Sweep H4 - M15 (Swing Highs and Lows) / MQL5` — **OsmarSandovalEspinosa**,
  MQL5 Code Base 68951, 2026.03.23. Gia' citato nell'header di `ABTG_LiquiditySweep.mq5`.
- `Viral (1M+ views) 4 Hour Range Strategy coded and tested` — **Peter Mueller
  (Mullerp04)**, MQL5 Code Base 68082, 2026.01.10. **Da citare nell'header** di
  qualunque `.mq5` derivato.
- `london-strategy-backtest` — **MHZardary**, GitHub. Citato come evidenza.
- `Segmentation and Time-of-Day Patterns in Foreign Exchange Markets` —
  **Angelo Ranaldo**, SNB WP 2007-03 / JBF 2009. **Abstract soltanto.**
