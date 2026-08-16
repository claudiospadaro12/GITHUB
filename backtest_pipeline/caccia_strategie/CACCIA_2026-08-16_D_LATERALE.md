# 🏹 CACCIA 2026-08-16 — D · **IL LATERALE**, quarta battuta

> ## 📌 LA RIGA CHE CONTA (§8.3)
> **Su 320 titoli sfogliati su 4 fonti, 6 schede aperte, 4 sorgenti scaricati e
> letti riga per riga, 1 lo proverei — ed e' `001 - Turnaround Tuesday`, perche'
> e' l'unico motore del laterale che NON ancora il ribaltamento a un livello di
> prezzo (banda, canale, estremo di N barre) ma al CALENDARIO: e' una meccanica
> che nel nostro repo non esiste, e le altre tre le abbiamo gia' in coda o gia'
> morte.**

_Bersaglio assegnato: **BUCO n.1, IL LATERALE**. Misurato in R50:
`LARRY_GBPUSD` **−6.445** e `BB_EURUSD` **−2.381** nella finestra LATERALE 2019,
dove `PTE_GBPUSD` fa **+5.284**. Due celle su tre muoiono li'._

---

## 0. 🧭 IL VINCOLO CHE HA GUIDATO TUTTA LA CACCIA

Prima di cercare ho contato **cosa e' gia' puntato su questo buco**, perche' il
rischio numero uno di una quarta battuta e' consegnare il terzo doppione:

| # | cosa | stato | meccanica |
|---|---|---|---|
| 1 | `ABTG_MeanRevert` (da `MeanReversion.mq5`) | 🔻 **MORTO** — R60, 12 celle su 12 in perdita, PF max 0,986, DD 37% | estremo di **N barre** → centro del range |
| 2 | `ABTG_BandFade` (da `BBRSI.mq5`) | 🟡 congelato, file prova scritto | chiusura fuori dalla **banda di Bollinger** + RSI → rientro |
| 3 | `Trade in Channel` (battuta B) | 🟡 secondo in coda | bordi di un **canale Donchian** che non si espande |

> 🔴 **Tutte e tre ancorano il ribaltamento a un LIVELLO DI PREZZO.** Sono tre
> modi di dire la stessa frase: _"il prezzo e' andato troppo lontano da un
> riferimento, torna indietro"_. E il primo dei tre e' gia' morto misurato.
>
> 🎯 **Quindi la caccia aveva un bersaglio piu' stretto del titolo:** un motore
> di ritorno alla media che **non guardi un livello**. Se ne trovavo un quarto
> ancorato a una banda, il posto giusto era il cestino, non il dossier.

⚠️ **L'handicap dichiarato in partenza** (me lo chiede il mandato): la famiglia
mean-reversion e' stata **bocciata oggi stesso** in R60. Un candidato che
ripete quella meccanica parte con un handicap. **Il mio non la ripete** — e il
motivo per cui lo dico e' che la falsificazione di R60 e' precisa e va letta
per quello che dice: _"comprare il minimo di N barre puntando al centro del
range perde a ogni N fra 50 e 300"_. **Non dice che il laterale non si operi.**

---

## 1. 🚦 CONTROLLO POSITIVO, FONTE PER FONTE (§2)

Fatto **prima** di cercare, su ogni canale usato.

| fonte | controllo | esito |
|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | la lista deve mostrare titoli veri e la paginazione | ✅ **HTTP 200, 40 schede, paginazione fino a `/page40`** → fonte VALIDA |
| **MQL5 schede singole** `/en/code/NNNNN` | devono dare autore, data, download | ✅ **valide** (es. 73674 → Sergey Ermolov, 05/06/2026, 3.096 viste) |
| **MQL5 download** `/en/code/download/NNNNN/<file>.mq5` | deve tornare sorgente vero | ✅ **4 file su 4, HTTP 200**, dimensioni coerenti |
| **arXiv API** `export.arxiv.org` | deve tornare paper veri con data e id | ✅ **valida** (5 paper q-fin restituiti) |
| **Quantpedia** sezione gratuita | pagina leggibile senza registrazione | ✅ **valida e senza paywall** |
| **SSRN** `papers.ssrn.com` | — | 🔴 **NON RAGGIUNTA** — challenge Cloudflare, dichiarata nulla |
| **Forex Factory** | — | 🔴 **NON RAGGIUNTA** — challenge Cloudflare, dichiarata nulla |
| **Ricerca interna MQL5** | — | 🔴 **inutilizzabile** (`robots.txt: Disallow: /*/search*`, pagina in JS) |

**Aggiramento della ricerca interna, e ha funzionato:** sfoglio diretto di
`/en/code/mt5/experts/pageN` — **8 pagine, 320 titoli** — piu' WebSearch
`site:mql5.com/en/code`. Il download diretto `/en/code/download/NNNNN/<nome>.mq5`
funziona **e il `.zip` dell'intero pacchetto anche** (`/en/code/download/NNNNN.zip`):
me ne sono servito per una verifica decisiva, vedi lo scarto di `Bands R-squared`.

### Fonti NON visitate, e il motivo — non taciute

- **TradingView**: non aperta. Pine → MQL5 e' **una riscrittura, non un porting**
  (§3.D), e avevo gia' in mano un sorgente `.mq5` pronto che risponde alla stessa
  domanda. Aprirla sarebbe stato spendere il tempo di Claudio sul candidato piu'
  costoso, non sul migliore.
- **GitHub**: non ri-battuta. E' stata **arata dalle battute A e B di oggi**
  (`geraked/metatrader5`, `pipbolt/experts`, `santiago-cruzlopez/MQL5`,
  `n30dyn4m1c/crt-turtlesoup-ea` e il mirror `GeneralTradingSarl/expert-mt5`
  con **1.185 sorgenti setacciati**). Rifarla oggi sarebbe stato rumore.

---

## 2. 📚 COSA HO SFOGLIATO DAVVERO

### A. MQL5 Code Base — **8 pagine, 320 titoli**

Primo taglio dai titoli (§6.4). La fotografia e' coerente con quella del
setaccio automatico della battuta B (219 file su 1.185 = martingala/griglia):

| famiglia scartata dal titolo | quanti (contati sulle 8 pagine) | esempi testuali |
|---|---:|---|
| **griglia / martingala / lock dichiarati nel titolo** | **~22** | `Sideways Martingale` (68537) · `RSI Grid EA Pro` (71700) · `BGC Grid EA` (70764) · `XANDER Grid XAUUSD` (71776) · `Grid Master` (67355) · `Simple_Grid` (63244) · `Martingale Pulse EA` (63569) · `Basic Martingale EA v3` (32521) · `VIDYA N Bars Borders Martingale` (39638) · `MACD Four Colors 2 Martingale` (39234) · `MA Grid Trade` (38303) · `Long and Short Stepped Grid Trade` (38300) · `Periodic Range Breakout (Martingale)` (30560) · `Breakout Martin Gale` (46591) · `Advisor Based on RSI and Martingale` (46339) · `KSU_martin` (32243) · `MT5-CoupleHedgeEA` (29115) · `HedgeCover EA` (63299) · `VR Locker Lite` (68602, "positive lock") |
| **pannelli, calcolatrici, copier, logger, trailing** — non aprono posizioni | **~95** | tutta la fascia `Quantora *`, `ASQ *`, `BEC *`, `Trade Manager *`, `Risk Calculator`, `Spread lister`, `CSV Exporter` |
| **ONNX / IA / "AI"** — parametri che sono output di un fit | **~7** | `Market Structure Onnx` (68535) · `Larry Williams XGBoost Onnx` (68424) · `ONNX Trader` (48482) · `Neurotest` (52148) · `MarketPredictor` (54127) · `Prime Quantum AI` (72527) |
| **gia' setacciati** (lista del mandato) | **9** | `ProAutoSL_DynamicTP` (76165) · `Session ORB` (76153) · `Daily Zone Recovery` (75922) · `Smart Trade Manager` (75916) · `GoldLondonBreakout` (75586) · `Relative Moving Average EA / RMA` (75473) · `Nikkei 225 Gap Continuation` (75301) · `Universal Breakout Study` (73711) · `Quantum Gold Silver Trader` (63193) · `Pending tread` (61319) · `XANDER Gold Recovery` (72278) · `MeanReversionTrendEA` (57020) |
| **breakout / ORB / trend following** — porte chiuse con ~210 celle | **~30** | `Easy Range Breakout` (68764, 71460) · `Moving average breakout` (35502) · `Periodic Range Breakout 2.0` (31198) · `Lazy Bot (Daily Breakout)` (41732) · `Outbreak Trader` (54611) |

📌 **Controprova utile che e' emersa da sola:** a pagina 8 c'e' **`Range Follower`
(30304)** — cioe' il **candidato n.1 della battuta B**, che era stato trovato sul
mirror GitHub senza pagina di origine. Adesso l'origine c'e': e' del Code Base.
**Il mirror non mentiva.**

### B. arXiv q-fin — 🟢 fonte viva, ❌ zero candidati, e lo dichiaro

L'API ha risposto con paper veri (5 restituiti, i piu' recenti):

| paper | id | data | perche' NON e' un candidato |
|---|---|---|---|
| _Optimal Trading of Microstructure Mean Reversion_ — L. R. Amaral | 2608.00885 | 01/08/2026 | ritorno alla media **sulla scala dei secondi** attorno al prezzo efficiente latente: e' HFT sul book. Non abbiamo il book, non abbiamo la latenza. |
| _The Bounce Has No Direction_ — V. Portnaya | 2606.29591 | 28/06/2026 | conclude che l'autocorrelazione a lag 1 e' dominata dal **rimbalzo denaro-lettera**, non da un ribaltamento direzionale. **Utile al contrario**: e' un avvertimento su cosa si compra quando si "fa mean reversion" su scala fine. |
| _Fast Times, Slow Times_ — J. Rosenzweig | 2601.11201 | 16/01/2026 | separazione di scale temporali, niente regole operative |
| _Deep RL for optimal trading with partial information_ | 2511.00190 | 31/10/2025 | Ornstein-Uhlenbeck a regimi + RL: **il motore E' la manopola** (Gold Dust docet) |
| _Optimal Turnover, Liquidity, and Autocorrelation_ | 2110.03810 | 07/10/2021 | teoria di portafoglio, nessuna traduzione su un simbolo che abbiamo |

> **Verdetto sulla fonte: cultura, non candidati** (§3.A in persona). La dico
> perche' il mandato pretende che un buco si dichiari: **arXiv oggi non ha
> prodotto niente di traducibile**, e non ho riempito la riga con un titolo
> plausibile.

### C. Quantpedia — 🟢 e qui invece la resa c'e' stata, ed e' LA TESI

`https://quantpedia.com/strategies/short-term-reversal-in-stocks` — **gratuita,
senza paywall, letta**. E' la fonte accademica del motore che promuovo:

> **Fonte primaria citata:** de Groot, Huij, Zhou — _"Another Look at Trading
> Costs and Short-Term Reversal Profits"_, SSRN 1605049.
> **[VERIFICATO]** sulla pagina Quantpedia. **[NON VERIFICATO]** il paper in
> se': SSRN da qui e' 403.

**Il meccanismo, nelle parole della pagina** — ed e' la parte che vale, perche'
e' esattamente il _"guadagna perche'…"_ che il §7 pretende:

1. **Sovrareazione**: _"the investor's overreaction to the past information and
   a correction of that reaction after a short time horizon"_.
2. **Fornitura di liquidita'** (Nagel): i rendimenti del ribaltamento sono
   _"a proxy for the returns from liquidity provision"_ — non un errore di
   prezzo, ma **il compenso di chi assorbe uno squilibrio di ordini**.

> 🎯 **Questa seconda spiegazione e' la piu' importante del dossier**, e cambia
> come si legge il candidato: se il ritorno e' il **compenso per fornire
> liquidita'**, allora **vive dove la liquidita' e' scarsa e gli squilibri si
> riassorbono — cioe' nel LATERALE — e muore quando lo squilibrio e' informato,
> cioe' nel trend e nel crollo.** E' precisamente la forma del buco che devo
> riempire, e ci dice anche **dove NON aspettarsi niente**.

---

## 3. ✅ IL PROMOSSO — uno solo

### 🥇 `001 - Turnaround Tuesday`

```
NOME            001 - Turnaround Tuesday
FONTE / URL     MQL5 Code Base
                scheda:   https://www.mql5.com/en/code/73674
                sorgente: https://www.mql5.com/en/code/download/73674/001-Turnaround-Tuesday.mq5
AUTORE / DATA   Sergey Ermolov (dj_ermoloff) — https://www.mql5.com/en/users/dj_ermoloff
                #property copyright "Copyright 2026, Sergei Ermolov | IT Trader"
                pubblicato 05/06/2026 · #property version "1.1"
POPOLARITA'     3.096 viste · voto 3/5 (348 valutazioni)   [VERIFICATO sulla pagina]
LICENZA         la pagina dichiara sorgente aperto e modificabile; nessun testo
                di licenza nel file (solo il copyright). Valgono i termini
                generali del Code Base, che NON ho verificato. [INCERTO]
RIGHE / INPUT   306 righe · **10 input veri** + 4 `input group`
                (contati nel sorgente: nessun gruppo conteggiato per errore)

TESI IN UNA RIGA
  "Guadagna perche' una giornata storta e' in buona parte SOVRAREAZIONE e
   squilibrio di ordini: chi la assorbe viene pagato quando lo squilibrio si
   riassorbe il giorno dopo — e viene pagato solo se il mercato non ha una
   direzione vera da seguire."

MECCANICA  (letta riga per riga, non dalla descrizione)
  quando   al primo tick dopo la MEZZANOTTE SERVER, se il giorno appena
           chiuso e' LUNEDI'  (OnTick righe 76-91: cancello a nuovo giorno
           `tc - tc%86400`, poi `day_of_week` della barra H1 chiusa)
  cosa     ricostruisce la candela del giorno dalle barre H1 (GetCheckDayData,
           righe 265-306) e ne guarda SOLO il segno: `isBullish = close>open`
  ingresso ⭐ `bool tradeUp = !isBullish;`  (riga 120)
           lunedi' ROSSO -> COMPRA martedi' · lunedi' VERDE -> VENDE martedi'
           UNA riga. E' tutta la strategia.
  stop     SL = kDailyATR x ATR(D1,14) della barra CHIUSA, con pavimento al
           `SYMBOL_TRADE_STOPS_LEVEL` (righe 124-130). **VERO, nell'ordine.**
  target   TP = rrTP x la distanza di stop -> multiplo di R, come le nostre sedie
  uscita   chiusura forzata a `CloseHour` (default 22) — **ORA SERVER**
           (`TimeCurrent(mtc)`, riga 77). Una posizione, un trade a settimana.

GESTIONE RISCHIO ✅ rischio in **percentuale** (`LOT_RISK` di default, riga 23)
                 ✅ SL VERO mandato al broker, mai virtuale
                 ✅ `MathFloor` sul lotto (arrotonda in GIU', verso il rischio
                    dichiarato) + clamp min/max + `CheckMargin` prima di sparare
                 ✅ magic impostato (`trade.SetExpertMagicNumber`, riga 161)
                 ✅ `CloseAllPositions` filtra per **simbolo E magic** (righe 237-243)
                 🟡 `balance` letto UNA VOLTA in `OnInit` -> il rischio e' il % del
                    saldo INIZIALE, non dell'equity corrente (l'enum lo dichiara:
                    "% Risk from Start Balance"). Da cambiare, vedi §3-bis.
                 🟡 `CalcLot` usa `SYMBOL_TRADE_TICK_VALUE` nudo (riga 213):
                    e' **il bug che ci ha ucciso il round 2 sul Nikkei**. Su
                    GBPUSD non morde, su 225JPY si'. Da cambiare, vedi §3-bis.
BANDIERE ROSSE   ✅ **NESSUNA.** Grep esplicito sul sorgente di: `martingal`,
                    `MathPow`, `LotExponent`, `multiplier`, `grid`, `averag`,
                    `hedge`, `recovery`, `#import`, `WebRequest`, `iCustom`,
                    `OrderSend`, `IsInTester`, `MQL_TESTER`, `ExpertRemove`,
                    `Sleep(` -> **zero occorrenze, tutte e sedici.**
                 ✅ niente repaint: decide su barre CHIUSE (ATR da `CopyBuffer`
                    shift 1, candela del giorno gia' finito). Nessuno shift 0.
                 ✅ non e' un indicatore: zero `OnCalculate`, ha `OnTick` e `trade.Buy`
                 🔴 **manca `OnTester`** -> il driver rifiuta di partire (unico blocco vero)
                 🔴 `PositionsTotal() > 0` (riga 94) e' **di CONTO**, non di
                    simbolo+magic: con la flotta accesa non aprirebbe mai
COSTO DI PORTING **3-4 ore.** MQL5 -> MQL5, la logica NON si tocca. Sono
                 quattro innesti di gestione, tutti mestiere nostro (§3-bis).

PUNTEGGIO (0-2 per voce)
  [2] semplicita'             306 righe, **10 input**, e le manopole di
                              strategia sono DUE (kDailyATR, rrTP). Il giorno
                              e la direzione sono `const`, non input: vedi sotto.
  [2] il filtro E' il motore  non c'e' nessun filtro. La direzione la decide
                              **il segno del lunedi'**: e' costitutiva, e il
                              filtro ATR opzionale lo teniamo SPENTO apposta.
  [2] tesi scrivibile         si', e con una fonte accademica dietro (§2.C)
  [2] riempie un BUCO         LATERALE + **simmetrico vero** (lo specchio e' la
                              stessa riga con il `!` davanti) + **fascia oraria
                              e frequenza che non copriamo**: 1 trade a settimana
  [1] testabile senza riscritture  no: manca `OnTester`, conteggio posizioni di
                              conto, rischio sul saldo iniziale

VERDETTO   🟢 **PROVA SUBITO — 9/10**
PERCHE'    E' l'unico motore del laterale trovato in quattro battute che non
           ancori il ribaltamento a un livello di prezzo: dove BandFade, Trade
           in Channel e il defunto MeanRevert dicono tutti "il prezzo e' andato
           troppo lontano", questo dice "e' passato un giorno storto". Se il
           laterale si opera, questa e' la seconda domanda da fare — ed e'
           indipendente dalla prima.
```

### 🎯 Il dettaglio che l'ha promosso sopra al suo stesso fratello

L'autore ha pubblicato **una serie**. Il numero 003 (`Weekly Day Reversal`,
`/en/code/74137`, 19/06/2026) e' **lo stesso scheletro** — l'ho scaricato e
messo a `diff` — con due input in piu':

```cpp
input ENUM_DAY_OF_WEEK CHECK_DAY = MONDAY;     //Day Of Week      <- era const
input ENUM_DIRECTION   Direction = reverse;    //Direct / Reverse <- NUOVO
...
bool tradeUp = (Direction == reverse) ? !isBullish : isBullish;   // 003
bool tradeUp = !isBullish;                                        // 001
```

> 🚨 **Il 003 lascia scegliere all'ottimizzatore SE la tesi e' "ribaltamento"
> o "continuazione", e su QUALE giorno.** Cioe' mette la tesi stessa fra le
> manopole. E' la forma pura del curve-fitting — la stessa che ha bocciato
> `Universal Breakout Study` (l'interruttore per giorno della settimana col
> lunedi' spento) — e con dodici Spearman IS→OOS negativi su tredici e' il modo
> piu' rapido di costruire il ribaltamento numero trentuno.
>
> ✅ **Nel 001 il giorno e la direzione sono CABLATI.** Due manopole in meno che
> il backtest puo' girare verso il passato, e una tesi che si puo' falsificare.
> **Il fratello piu' povero e' il candidato migliore, e non e' un paradosso: e'
> il §5.A e il §5.B nello stesso file.**

### ⚠️ E i numeri dell'autore — dichiarati, NON verificati, e NON pesano

La pagina dichiara: backtest 2016-2026 su EURUSD, XAUUSD e SP500, **baseline in
perdita**, e con il filtro ATR acceso **XAUUSD +38%, SP500 +40% (DD max 11%)**.

> 🔴 **Etichetta obbligatoria: "dichiarato dall'autore, NON verificato".** Non
> pesano sul punteggio (§7) — e in questo caso c'e' una ragione in piu' per
> ignorarli, che e' **il cuore del nostro archivio**:
> **il baseline perde e a raddrizzarlo e' un FILTRO.** E' il caso R26/R45 in
> persona (_"un filtro non salva un motore morto"_, **0 successi su 5**).
> 👉 Per questo nel file prova **il filtro ATR e' PINNATO SPENTO**: misuriamo il
> motore nudo. Se il motore nudo e' rosso, la famiglia si chiude — **non la si
> ripesca con la manopola dell'autore.** L'ho scritto prima dei numeri apposta.
> E l'11% di DD dichiarato, comunque, e' **gia' oltre il muro prop del 10%**.

---

## 3-bis. 🔧 COSA TENGO (il motore) · COSA RIFACCIO (la gestione) — §5.F

### 🟢 COSA TENGO — e' tutto il candidato

1. **La riga `tradeUp = !isBullish`** e il fatto che giorno e direzione siano
   `const`. Questo e' il motore, e non si tocca.
2. **SL strutturale in ATR giornaliero** con pavimento allo `STOPS_LEVEL`. E'
   gia' la forma giusta (mai pip fissi — il difetto di `ProAutoSL` e `EXSR`).
3. **TP come multiplo di R.** E' la nostra grammatica.
4. **Chiusura forzata a un'ora dichiarata in ORA SERVER.** L'autore ci e' gia'
   arrivato: `TimeCurrent` e non `TimeLocal`. Un errore in meno da correggere.
5. **`MathFloor` sul lotto** — arrotonda verso il basso, cioe' verso il rischio
   dichiarato. `MeanReversion.mq5` sbagliava proprio questo passo.

### 🟡 COSA RIFACCIO — quattro innesti, tutti mestiere di casa

| # | cosa | perche' | costo |
|---|---|---|---|
| 1 | **aggiungere `double OnTester()`** | senza, `walkforward_generico.ps1` **rifiuta di partire** (22 EA su 61 gia' bocciati cosi'). E' l'unico blocco vero. | 10 min |
| 2 | **posizioni contate per SIMBOLO + MAGIC** (oggi `PositionsTotal()` di conto, riga 94) | con la flotta accesa **non aprirebbe mai**: identico difetto di `MeanReversion.mq5` | 15 min |
| 3 | **rischio sull'EQUITY CORRENTE**, non sul saldo letto in `OnInit` | oggi e' rischio fisso in valuta travestito da percentuale: il DD% e le Monte Carlo non sarebbero confrontabili con le altre 14 celle | 20 min |
| 4 | **lotto via `OrderCalcProfit`**, non `SYMBOL_TRADE_TICK_VALUE` nudo | e' **il bug del round 2 sul Nikkei** (tick value in yen, ~160x, lotto appoggiato al minimo). Su GBPUSD non morde; se un giorno il motore va su 225JPY, morde. Si mette adesso che costa niente. | 20 min |

### 🔴 E il quinto innesto, che e' il piu' importante e non e' cosmetico

**L'EA entra al primo tick dopo la MEZZANOTTE SERVER.** Su GBPUSD quello e'
**l'istante del rollover**, cioe' il momento della giornata in cui **lo spread
e' al massimo**. Con uno stop di 0,5 x ATR(D1) (~40 pip su GBPUSD) uno spread di
rollover che passa da 1 a 15 pip **si mangia un terzo del rischio prima che il
trade cominci** — e R55 ha misurato che 1,5 punti indice di slippage bastano a
sfondare il cancello del 10% sull'ORB.

👉 **Serve un `InpEntryHourServer`** e la griglia lo spazzola su **due soli
valori**: `0` (com'e' scritto dall'autore) e `8` (apertura della liquidita'
europea, e la stessa ora del DAX in ora server). **Non e' gusto: e' la
differenza fra misurare la strategia e misurare il rollover.**

> 🛠️ **Trappola per chi scrive il codice, e va letta due volte.** Il controllo
> del giorno oggi guarda **l'ultima barra H1 chiusa** (`iTime(...,PERIOD_H1,1)`,
> riga 82): a mezzanotte quella barra e' lunedi' 23:00 ✅, ma **alle 08:00 di
> martedi' e' martedi' 07:00** → `closedDay != MONDAY` → **l'EA non aprirebbe
> MAI, in silenzio, e le 12 celle a ora 8 tornerebbero vuote senza un errore.**
> Il controllo va riscritto sul **giorno di calendario precedente**, non
> sull'ultima barra. Se le celle a `EntryHour=8` tornano con zero trade, **il
> primo sospetto e' questo, non la tesi.**

---

## 4. ❌ GLI SCARTATI LETTI NEL SORGENTE — una riga di motivo a testa

| file | id | righe | esito |
|---|---|---:|---|
| `003 - Weekly Day Reversal` | 74137 | 318 | 🔴 **il giorno E la direzione sono input**: l'ottimizzatore sceglie la tesi. Il fratello 001 fa la stessa cosa con due manopole in meno. |
| `EXSR — Extreme Strength Reversal` | 60413 | 208 | 🔴 **DOPPIONE di `ABTG_BandFade`** (banda di Bollinger sfondata + RSI 20/80 + candela di ritorno) **e con lo stop peggiore**: `StopLoss_pips * _Point` = distanza FISSA in punti (150/300), la scala sbagliata su indici e oro. Niente `OnTester`. |
| `Bands R-squared` | 58268 | 351 | 🔴 **`iCustom` su un indicatore ESTERNO NON ALLEGATO** — riga 49: `iCustom(...,"\\Indicators\\Free Indicators\\Donchian Channel",...)`. **Ho scaricato il `.zip` per esserne sicuro: contiene un solo file, `Bands.mq5` (29.644 byte).** Non compila, non gira. In piu' **lotto fisso** (`Lots = 0.1`). ✅ ha `OnTester`, ed e' l'unica cosa buona. |
| `Viral (1M+ views) 4 Hour Range Strategy` | 68082 | — | 🔴 scartato al primo taglio dalla scheda (§6.4): rottura + rientro nel range delle prime 4 ore = **fade del range di apertura**, porta chiusa in **R42, 0 celle su 48**. E l'autore stesso scrive: _"Backtests on EURUSD under my conditions were unprofitable"_. **Sorgente non letto, e lo dichiaro.** |

### 🔍 E un ritrovamento che non e' un candidato ma vale un paragrafo

**`Indiana Jones Mean Reversion EA`** — `/en/code/58135`, Yashar Seyyedin,
11/04/2025, **7.270 viste, voto 4,9/5 su 331 valutazioni**. Non l'ho
ricontrollato: **e' il `MeanReversion.mq5` del setaccio manuale**, cioe'
`ABTG_MeanRevert`, **bocciato oggi in R60 con 12 celle su 12 in perdita**.

Ma adesso abbiamo la sua pagina d'origine, e dice due cose che R60 non poteva
sapere — e che **confermano il nostro verdetto dall'esterno**:

> **[VERIFICATO sulla pagina]** L'autore stesso definisce il proprio backtest
> _"a misleading simulation conducted on one-minute OHLC"_, e nei commenti c'e'
> un avvertimento esplicito a non metterlo su un conto reale.

> 🎯 **Il file piu' votato che abbiamo incontrato (4,9/5 su 331 voti) e' quello
> che il nostro imbuto ha ucciso in un pomeriggio — e l'autore era d'accordo.**
> E' la miglior difesa del metodo che potessi riportare: **il voto della
> community non e' un criterio, il sorgente e la misura si'.** Vale anche al
> contrario: il mio promosso ha **voto 3/5**, il piu' basso di tutti quelli che
> ho aperto.

---

## 5. 🏛️ IL CANCELLO PROP (§7-bis) — _"in ottica prop, questo motore…"_

### 🟢 1. La peggior giornata: e' **strutturalmente** un solo trade

Un trade a settimana, **una posizione alla volta**, chiuso lo stesso giorno alle
22 server. La peggior giornata possibile e' **uno stop pieno = 1R = 0,65%** al
nostro rischio di rotta.

| | |
|---|---|
| muro giornaliero prop (100k) | **−5.000 = −5%** |
| peggior giornata **possibile** di questo motore | **−0,65%** (1R) |
| peggior giornata **misurata** del portafoglio (R51) | −2,06% |

> **Non puo' fisicamente fare due stop nello stesso giorno.** E' il profilo
> giornaliero piu' pulito che abbia incontrato in quattro battute.

### 🟢 2. Concentrazione e frequenza: zero trade correlati nella stessa mattina

Non spara mai piu' colpi sullo stesso segnale (§7-bis.2): il segnale **esiste
una volta a settimana**.

### 🟢 3. Scalabilita' a 100k

Rischio in percentuale gia' nel sorgente. Va spostato dal saldo iniziale
all'equity corrente (innesto 3), e allora e' confrontabile con le altre celle.

### 🟡 4. Scorrelazione — favorevole sul segnale, **da sorvegliare sul simbolo**

- 🟢 **Sul segnale non si sovrappone a niente**: nessuna cella viva guarda il
  giorno della settimana, e nessuna entra a mezzanotte o alle 08:00 di martedi'
  tenendo fino a sera.
- 🔴 **Sul simbolo si': GBPUSD e' affollato** (`LARRY_GBPUSD` short-only,
  `PTE_GBPUSD`, `EZ_GBPUSD`, `GAP_GBPUSD`, `BB_GBPUSD`). La regola di rotta e'
  _"mai due EA sullo stesso segnale/simbolo/lato allo stesso rischio pieno"_.
  👉 Se passa, **prima di accenderlo va misurato il DD combinato con le celle
  GBPUSD**, non stimato. E la cosa da guardare per prima e' se il suo lato short
  del martedi' cade addosso a LARRY, che e' short-only.

### 🔴 5. Il difetto prop, e va detto per primo perche' e' quello che costa

**52 trade all'anno.** Il verdetto di casa e' a 15 trade per famiglia: in
**forward** significa **quattro mesi** prima di poter dire qualcosa, contro le
poche settimane di una sedia intraday.

> **In ottica prop, questo motore e' un ottimo passeggero e un pessimo pilota:**
> profilo giornaliero quasi inattaccabile e scorrelazione vera, ma da solo non
> costruisce un conto e ci mette una stagione a dimostrare che esiste. **Il
> posto giusto e' accanto ad altri, a taglia piena — non da solo.**

### ⚠️ 6. DD trailing

Un trade a settimana con TP a 1,5-2,5R produce **una curva a scalini con lunghi
piani** — cioe' esattamente la forma che un **DD che insegue l'equity** punisce
(Upcomers). Le nostre Monte Carlo sono tutte su DD **statico dal deposito**:
**su questo motore quel numero varra' ancora meno del solito.** Segnalato, non
misurato: il ricalcolo col trailing e' una misura aperta del progetto.

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

1. **SSRN**: 403 Cloudflare. Il paper primario della tesi
   (de Groot–Huij–Zhou, SSRN 1605049) **non l'ho letto**: ho letto la sintesi di
   Quantpedia che lo cita. **[INCERTO]** tutto cio' che sta nel paper e non
   nella sintesi.
2. **Forex Factory**: 403 Cloudflare. E' la fonte che avrebbe risposto alla
   domanda piu' importante su questo candidato — _"come e' invecchiato l'effetto
   Turnaround Tuesday?"_ (§3.E). **Non raggiunta.**
3. **La licenza esatta** del sorgente promosso: la pagina dichiara codice aperto
   e modificabile, il file porta solo un copyright. **[INCERTO]** — attribuzione
   obbligatoria in testa all'`.mq5` derivato, e verifica prima di qualunque
   distribuzione.
4. **La data d'inizio storico di GBPUSD su questo terminale**: non misurata,
   quindi `@DAQUANDO` nel file prova e' **vuota apposta** (si misura con
   `scarica_storico.ps1`).
5. **I commenti sotto la scheda 73674**: la pagina ne mostra il voto (3/5 su
   348) ma non ho letto la discussione. Su 58135 invece i commenti erano
   visibili e li ho citati.
6. **TradingView**: non visitata (motivo al §1).
7. **L'effetto su indici azionari**, dove la letteratura lo colloca. Vedi §7:
   e' il limite piu' onesto di tutto il dossier.

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Un ribaltamento ancorato al CALENDARIO invece che a un livello di prezzo guadagna nella finestra LATERALE 2019 di GBPUSD — quella dove `LARRY_GBPUSD` perde 6.445 — SENZA il filtro dell'autore?**

E le tre risposte possibili, scritte adesso:

| esito | cosa vuol dire |
|---|---|
| 🟢 **verde nel laterale** | il buco n.1 ha finalmente un motore, ed e' **scorrelato per costruzione** da BandFade e Trade in Channel: si puo' tenere *insieme* a loro, non al posto loro |
| 🔴 **rosso ovunque, come R60** | il laterale non si opera **con un ancoraggio temporale** su FX, e restano solo gli ancoraggi di prezzo (BandFade, Trade in Channel). **Costo: 48 pass OHLC, zero euro.** |
| 🟡 **verde solo su un lato** | non ha riempito il buco degli **short**, e va dichiarato cosi' anche se il totale e' verde (criterio 2 del file prova) |

### ⚠️ E il limite che dichiaro PRIMA, perche' dopo non conterebbe piu'

**La letteratura di questo effetto sta sull'AZIONARIO** (lo dice Quantpedia:
_"stocks"_; e i backtest dell'autore girano su SP500 e XAUUSD). **Io lo mando su
GBPUSD.** Perche':

- il buco e' misurato **li'** — `LARRY_GBPUSD` −6.445 nel laterale 2019 e' la
  nostra ferita, con un numero;
- su GBPUSD H1 abbiamo **gia' le celle di regime** (`CELLE_REGIME.txt`) per il
  confronto diretto, e `ABTG_BandFade` va sullo stesso banco: i due candidati
  del laterale diventano **confrontabili fra loro**, non solo col passato.

> 🔴 **Quindi un esito rosso su GBPUSD falsifica la tesi SU GBPUSD, non
> l'effetto.** Lo scrivo ora, e scrivo anche il vincolo che impedisce che
> diventi una scusa: **il round dopo non esiste "a sentimento".** Se e' rosso,
> la famiglia si chiude come si e' chiusa `ABTG_MeanRevert` — l'unica riapertura
> ammessa e' **su indice**, con la stessa griglia e i criteri riscritti prima,
> e solo se qualcuno la chiede esplicitamente. **Cercare il simbolo giusto dopo
> un rosso e' pesca**, ed e' il vizio che l'imbuto esiste per impedire.

---

## 📎 ATTRIBUZIONE DA RIPORTARE IN TESTA ALL'`.mq5` DERIVATO

```
// Meccanica di ingresso derivata da "001 - Turnaround Tuesday"
// Copyright 2026, Sergei Ermolov (dj_ermoloff) | IT Trader
// https://www.mql5.com/en/code/73674
// https://www.mql5.com/en/users/dj_ermoloff
// Licenza: non dichiarata nel file; la scheda del Code Base dichiara
// sorgente aperto e modificabile. Uso interno di ricerca.
// NON adottiamo i suoi parametri ne' il suo filtro ATR: prendiamo la
// MECCANICA e la TESI. Il verdetto lo da' il nostro imbuto.
// Tesi di mercato: short-term reversal / liquidity provision
//   Quantpedia, "Short Term Reversal Effect in Stocks"
//   fonte primaria citata: de Groot, Huij, Zhou, SSRN 1605049 (non letto)
```

## 📦 CONSEGNE DI QUESTA BATTUTA

1. questo dossier
2. `backtest_pipeline/prove/ABTG_TurnaroundTuesday.txt` — ipotesi e criteri
   congelati **prima** che l'EA esista
3. sorgenti scaricati e letti, per chi vuole ricontrollare:
   `73674` · `74137` · `60413` · `58268` (+ il `.zip` di 58268)

> ### 🔭 DA DOVE RIPARTE LA QUINTA BATTUTA
> Il laterale adesso ha **due ancoraggi diversi** in coda (prezzo: BandFade /
> Trade in Channel · tempo: Turnaround Tuesday). Il terzo ancoraggio possibile
> e' **la RELAZIONE fra due simboli** (pairs trading, cointegrazione): e' il
> motore di ritorno alla media con la letteratura piu' solida, e nel Code Base
> c'e' materiale (`2-Pair Correlation EA` 52043, `Arbitrage Triangle` 51014,
> `Triangular Arbitrage` 57272). **Non l'ho aperto apposta**: il nostro driver
> gira un simbolo per passata, e il costo di validazione supererebbe il valore
> atteso finche' non c'e' un modo di misurarlo (§5.E). **Va aperto quando
> qualcuno decide di pagarne il costo, non prima.**
