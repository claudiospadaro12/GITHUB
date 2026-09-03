# 🏹 CACCIA — APERTURA DI LONDRA, MECCANISMO ALTERNATIVO DOPO R116 (03/09/2026)

**Mandato:** dopo la bocciatura di `ABTG_LondonFx` (R116, entrambe le gambe,
bocciate PER RISCHIO), cercare fuori dal repo un **meccanismo DIVERSO sulla
STESSA inefficienza** — l'apertura della sessione di Londra sul forex — mai un
ritocco dei parametri del motore morto. Angoli assegnati: (1) **fade**
dell'eccesso iniziale, (2) **liquidity sweep / stop hunt** con conferma,
(3) **regime**.

---

## 0. 🧾 IL RISULTATO IN UNA RIGA, E NON E' QUELLO CHE SPERAVO

> Su **47 strategie viste** in 30 query su TradingView, **10 sorgenti letti riga
> per riga** (9 Pine + 1 MQL5) e 1 repo GitHub aperto, **PROMOSSI: ZERO.**
>
> 🔴 **Il motivo non e' che il materiale esterno sia scarso: e' che i quattro
> migliori candidati che ho trovato sono, riga per riga, LO STESSO MOTORE che in
> casa e' gia' stato scritto, misurato a tick e CHIUSO il 31/08 —
> `ABTG_BreakinBox`.** Non l'ho scoperto leggendo il titolo: l'ho scoperto
> aprendo il sorgente del nostro EA e trovandoci dentro, uno per uno, tutti gli
> ingredienti che credevo nuovi (ingresso differito, scadenza dell'armamento a
> N barre, SL oltre l'estremo dello sweep, filtro di ampiezza del box in ATR,
> TP al lato opposto contro RR fisso come ablazione).
>
> 🎯 **La cosa piu' utile che questa caccia consegna e' quindi una CHIUSURA e un
> reindirizzo:** l'angolo 1 e l'angolo 2 del mandato sono **la stessa famiglia**,
> e quella famiglia in casa e' bocciata **quattro volte con quattro banchi
> diversi** (R42, R45+, R95, BreakinBox), piu' una quinta misura esterna il
> 03/09 (sweep di micro-pivot, 22.616 segnali). **Il meccanismo alternativo vivo
> sull'apertura di Londra ce l'abbiamo gia' e non e' un range: e' la DERIVA
> ORARIA di Breedon-Ranaldo, misurata OGGI e passata su entrambe le finestre.**

---

## 1. 🔌 CONTROLLO POSITIVO SU OGNI FONTE — misurato oggi, 03/09/2026

| fonte | bersaglio noto | esito | uso |
|---|---|---|---|
| **TradingView** `pubscripts-suggest-json` | query `vwap` | 🟢 **200, 40.283 byte** (identico al 03/09 mattina, byte per byte) | ✅ usata, 30 query |
| **TradingView** `pine-facade /get/` | `PUB;yMINlAO3…` (SoftKill21, gia' in biblioteca) | 🟢 **200**, `source` in chiaro **con l'intestazione MPL 2.0 presente** → il canale **non** perde le licenze (controllo fatto apposta, §5) | ✅ usata, 11 sorgenti |
| **MQL5 Code Base** | `/en/code/68951` | 🟢 **200** — titolo, autore `OsmarSandovalEspinosa`, `datePublished 2026-03-23`, `UserDownloads:2465` | 🟡 usata solo per 1 attrezzo (mandato: il CB e' chiuso per i motori) |
| **arXiv API** | `cat:q-fin.TR` | 🟢 **200** | ✅ usata, 4 query → **zero risultati in tema** |
| **raw.githubusercontent** | `geraked/metatrader5/README.md` | 🟢 **200, 6.941 byte** | ✅ disponibile |
| **GitHub** via `WebSearch`+`WebFetch` | repo reale | 🟢 200 | ✅ usata, 1 repo aperto |
| **SSRN** | `abstract_id=3138756` | 🔴 **403 (5.505 byte di pagina di blocco)** — **TREDICESIMA di fila** | ❌ buco dichiarato |
| 🆕 **newyorkfed.org** (PDF Osler sr125) | `/medialibrary/…/sr125.pdf` | 🔴 **000 al CONNECT** su `curl`, **`EGRESS_BLOCKED`** su `WebFetch` | ❌ buco dichiarato, §6 |
| 🆕 **technicalanalysis.org.uk** (mirror Osler) | `/bar-charts/Osle02.pdf` | 🔴 **403** | ❌ buco dichiarato |
| **ideas.repec.org** | Osler 2005 JIMF | 🔴 **`EGRESS_BLOCKED`** su `WebFetch` (secondo trasporto) | ❌ buco dichiarato |
| Forex Factory · Quantpedia premium · EarnForex | — | ⬜ **non riprovate**: murate e gia' misurate su due trasporti (02/09) | — |

### Cosa ho sfogliato dove ha funzionato
- **TradingView: 30 query sul MECCANISMO** (mai sul formato, regola del 03/09).
  Produttive: `sweep reversal` (6 strategie), `liquidity grab` (5),
  `session sweep` (5), `turtle soup` (4), `fakeout` (3), `stop hunt` (2),
  `london session` (2), `asian session` (2), `range fade` (2), `time of day` (3).
  **A ZERO strategie, da aggiungere alla lista dei vuoti:** `london killzone` ·
  `london fade` · `session high low` (50 risultati, 0 strategie) ·
  `opening range reversal` · `overextension` · `reversion to open` ·
  `morning reversal` · `first hour reversal` · `atr extension` ·
  `currency strength strategy` · `session drift` · `intraday seasonality forex`.
- **arXiv, 4 query** (`all:"stop-loss orders" AND all:"exchange rate"`,
  `abs:"false breakout"`, `all:"liquidity" AND all:"London open"`,
  `abs:"opening range" AND cat:q-fin*`): **un solo hit, fuori tema**
  (*FinLLM-B*, 2024). Conferma della nota del 02/09: **la microstruttura non
  vive su arXiv.**

---

## 2. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire, ed e' il verdetto

`REGISTRO_TEST.md` letto per intero (861 righe) piu' i referti. Sull'apertura di
Londra e sulla geometria range-sweep il progetto ha **cinque misure**, non una:

| # | caduto | banco | meccanismo misurato | numero |
|---|---|---|---|---|
| 1 | **R42** `REFERTO_ROUND42_FADE.md` | tick M5, NASUSD + D30EUR, 2 finestre | **FADE degli estremi del range di apertura** (15'/35', offset 0/200/400, ATR 1,0/1,5) | **0/24 IS e 0/24 OOS**, PF **0,50-0,93** sempre, 195-333 trade/cella |
| 2 | **R45** `REFERTO_ROUND45_LONDRA.md` | tick M5, XAUUSD+EURUSD+GBPUSD | **ORB della sessione di Londra** (range 07:00→07:15/07:30 server) | **0/48**, 149-408 trade/cella |
| 3 | **R95** `R95_REFERTO.md` | OHLC M1, EURJPY, M30→H4 | **sweep + reclaim** su swing pivot | **0/30**, PF **0,65-0,80**, 21.354 livelli creati e **0 buttati** (nessuna scusa strutturale) |
| 4 | 🔴 **BreakinBox** `REFERTO_BREAKIN_2026-08-31.md` | **tick M15, D30EUR, 2024-2026** | **falsa rottura del box notturno → reversal**, ingresso DIFFERITO su conferma in finestra di sessione | A (TP al lato opposto) **PF 1,007 / DD 24,1%** · B (RR fisso 2,0) **PF 1,106 / DD 19,7%** — cancello DD **≤15%**. **Candidato CHIUSO da lettera congelata** |
| 5 | **L2** `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` §7.3 | sonda esterna, DAX M5/M15 | **sweep di micro-pivot + rientro** | densita' ok (4,22-4,57 seg/gg/lato) ma TP-prima-di-SL **43,5-48,2% contro 49,6% richiesto, 8/8 sotto**, **delta contro ingresso CASUALE −0,2 punti su 22.616 segnali** |
| 6 | **R116** (oggi) | tick M15, EURUSD+GBPUSD | canale di Londra + RSI, breakout in chiusura | E OOS **−0,108R / −0,173R**, DD OOS **31-61%** contro tetto 8% |

### 🔴 E il colpo che chiude la caccia: `ABTG_BreakinBox` HA GIA' TUTTO

Ho letto gli `input` del nostro EA (`mql5/Experts/ABTG_BreakinBox.mq5`,
righe 191-237). **Ogni "ingrediente nuovo" che i candidati esterni portano e'
gia' li' dentro, gia' misurato a tick, e il candidato e' chiuso:**

| ingrediente che credevo nuovo | dove sta gia' in casa |
|---|---|
| ingresso **differito** (chiusura fuori → chiusura dentro su barra successiva) | `InpMinBarreRientro = 1` |
| 🎯 **il fakeout SCADE se il prezzo resta fuori troppo** (= `max_bars_outside` del candidato C1) | **`InpConfirmMaxBars = 8`** — "barre entro cui il rientro deve arrivare, poi l'armamento SCADE" |
| **SL oltre l'estremo dello sweep**, non a pip fissi | `InpSlBufferPts` + pavimento `InpMinStopPts` |
| filtro di **ampiezza del range in ATR relativo**, mai in punti | `InpMinBoxATR` + `InpAtrTF=D1` |
| **TP al lato opposto del range** contro RR fisso | `InpTP_RR` — **e' esattamente l'asse dell'ablazione gia' girata** |
| rischio %, tetto giornaliero, due lati separati, flat di seduta | `InpRiskPercent=0.65`, `InpMaxTradesPerDay=2`, `InpAllowLong/Short`, `InpCloseAtEnd` |

E la **tesi di mercato scritta nell'intestazione del nostro EA** (righe 51-57) e'
parola per parola quella dei candidati esterni:
> _"un range di sessione e' dove il mercato ha lasciato gli stop di chi dormiva.
> Quando il prezzo lo rompe, CHIUDE FUORI e poi RIENTRA, la rottura non aveva
> ordini dietro: chi e' entrato sul breakout e' dalla parte sbagliata di un
> livello che tiene, e il prezzo ha TUTTO IL BOX da percorrere."_

➡️ **Proporre uno dei quattro candidati esterni significherebbe riproporre
BreakinBox su un altro simbolo.** La lettera congelata di quel round dice:
_"VINCE LA GAMBA B (RR fisso) → il motore e' R95 CON UN LIVELLO NUOVO e IL
CAPITOLO SI CHIUDE LI'. Niente caccia a 'un RR migliore': vietata dalla Regola
della Seconda Caccia (19/08)."_ **Non lo aggiro cambiando valuta.**

⚠️ **Cio' che NON e' misurato, e lo dichiaro perche' e' l'unica porta rimasta:**
BreakinBox e' girato su **D30EUR** (indice), box **23:00-04:59 server**. Sul
**forex a tick** questa geometria non e' mai stata girata. **Ma R95 l'ha girata
su EURJPY (0/30) e R42 sul fade di range (0/48 fra IS e OOS)**: la porta esiste,
e' stretta, e **non giustifica un round nuovo senza un fatto nuovo**.

---

## 3. 🕐 IL FUSO DI LONDRA — questione APERTA dal 19/08, oggi CHIUSA

Il dossier `CACCIA_LONDRA_MECCANISMI_2026-08-19.md` §0 lasciava
**tre valori diversi in tre posti** per l'apertura di Londra in ora server, e lo
dichiarava `[INCERTO]`. **Il referto del Passo 0 di `ABTG_AllineaLondra`
(03/09, ore 16:51) lo misura e lo scrive:**

> _"MISURATO con la regola di casa (server = ora italiana − 1, ancora: DAX 09:00
> IT = 08:00 server): **l'orologio del server BCM segna la STESSA ora di Londra
> tutto l'anno.** Quindi 03:00-08:45 SERVER sono 03:00-08:45 DI LONDRA, e
> **Londra apre alle 08:00**."_

✅ **Da oggi: apertura di Londra = 08:00 ORA SERVER BCM, tutto l'anno.** Vale
per qualunque `.txt` di prova futuro. `Londra_ORB` a "06-07 server" e R45 a
"07:00 server" stavano misurando **la pre-apertura**, non l'apertura.

---

## 4. 📋 LA TABELLA DEI CANDIDATI — 10 sorgenti letti, 0 promossi

Licenza, meccanismo, finestra/regime della fonte, perche' non e' (o e') un
caduto, voto. **Nessun numero di performance degli autori e' stato usato.**

| # | candidato · fonte · autore/data · dimensione | licenza | meccanismo LETTO NEL SORGENTE | finestra/regime della fonte | e' un caduto? | voto |
|---|---|---|---|---|---|---|
| **C1** | `4H Range Scalp V3 - Smart Fakeout` · [TV `MfYqi6rS`](https://www.tradingview.com/script/MfYqi6rS/) · heriniaina2022 · 17/02/2026 · **106 righe, 4 input** | 🔴 **nessuna dichiarata** (verificato: il canale restituisce l'MPL quando c'e') | range 00:00-04:00 NY (righe 20-41); conta le barre con chiusura FUORI (`bars_out_high += 1`); alla prima chiusura DENTRO entra CONTRO la rottura; **SL = estremo raggiunto fuori** (`ext_high`, riga 78); TP = `risk × 2,0`; **`max_bars_outside=6`: oltre, non e' piu' un fakeout → niente trade**; `max_sl_atr=2,5`; 1 trade per lato al giorno | ⬜ **nessuna dichiarata dall'autore** — nessun mercato, nessun periodo, nessun regime nominato nel sorgente | 🔴 **SI**: e' `ABTG_BreakinBox` (`InpConfirmMaxBars` = `max_bars_outside`; `InpSlBufferPts` = SL all'estremo; `InpTP_RR` = RR fisso 2,0 = **gamba B, PF 1,106 DD 19,7%, gia' bocciata**) | **SCARTO** (era 9/10 prima del confronto coi caduti) |
| **C2** | `Strategy_500 - Turtle Soup NY V5 M5 Sweep` · [TV `XC77YPtV`](https://www.tradingview.com/script/XC77YPtV/) · Fran_Pineda · 22/05/2026 · 502 righe, **7 input funzionali** | 🔴 nessuna dichiarata | range di **3 ore** `0600-0859` NY (riga 19); operativita' 09:00-12:00; **due stadi**: (a) `low < rangeLow` = liquidita' presa, (b) su una barra **successiva** (`bar_index > longSetupBar`) una turtle soup di candela (`low<low[1] and close>low[1] and close>open`); SL = minimo della manipolazione − buffer; **TP = lato opposto del range**; **cancello `rr >= minimumRR`**; `process_orders_on_close=true`; 1 trade/giorno totale | ⬜ nessuna dichiarata | 🔴 **SI**: e' la **gamba A di BreakinBox** (TP al lato opposto, ingresso differito) → **PF 1,007, DD 24,1%, tesi FALSIFICATA**. Il secondo stadio (turtle soup di candela) e' il motore di **CRT**, chiuso il 31/08 | **SCARTO** |
| **C3** | `Gold H1 Breakout Failure (V11.0)` · [TV `8Iv42BDE`](https://www.tradingview.com/script/8Iv42BDE/) · MatthewRodrigues4 · 30/10/2025 · 110 righe, **5 input** | 🔴 nessuna dichiarata; ⚠️ il file dichiara _"Coded by Gemini AI"_ (riga 9) | range asiatico `0000-0800`, killzone `0900-1700`; **schema a 3 barre in CHIUSURA**: barra[2] dentro, barra[1] **fuori**, barra[0] **rientra** → ingresso contro (righe 73-86); SL = 1,5×ATR(14), TP = 2×SL; 🟢 **sizing a rischio % vero** (`risk_per_trade = equity*0.01; pos_size = risk/sl_distance`) | ⬜ nessuna dichiarata (titolo dice "Gold H1", ma nessun periodo) | 🔴 **SI**, stessa famiglia. In piu' l'SL ad ATR **non e' all'estremo dello sweep**: e' la geometria che R116 ha appena punito (stop scollegato dall'escursione reale) | **SCARTO** |
| **C4** | `Parent Session Sweeps + Alert` · [TV `idsNSGg2`](https://www.tradingview.com/script/idsNSGg2/) · mindyourbuisness · 13/10/2024 · 374 righe, ~15 input (quasi tutti cosmetici) | 🔴 nessuna dichiarata | sessioni Asia `2000-0300` / Londra `0300-0830` / NY `0830-1600` (ora NY); individua la **sessione "genitore"** che contiene la successiva; sweep del suo estremo → attesa del **reclaim** in chiusura → **filtro di candela** (corpo nel verso + ombra dal lato giusto piu' corta, righe 236-240) → **cancello `rr >= min_rr`**; SL = `post_sweep_extreme`; TP = lato opposto della sessione genitore | ⬜ nessuna dichiarata | 🔴 **SI**, stessa famiglia (gamba A). 🟢 **Un'idea che NON abbiamo:** il livello non e' un orologio fisso, e' **la sessione che contiene la successiva** — cioe' un range scelto dalla struttura, non dal calendario. Resta dentro una famiglia bocciata | **SCARTO**, spunto registrato §7 |
| **C5** | `SMC Liquidity Grab Pro` · [TV `WZ4s1MRC`](https://www.tradingview.com/script/WZ4s1MRC/) · Ericem · 11/01/2026 · 82 righe, 3 input | 🟢 **MPL 2.0** (riga 5) | sweep del massimo/minimo H4 precedente + chiusura rientrata; SL allo swing pivot; RR fisso 2,0 | ⬜ nessuna | 🔴 **SI** (R95: stessa geometria, 0/30) **e in piu' bandiera rossa §4** | 🔴 **SCARTO IMMEDIATO — LOOK-AHEAD**: `request.security(…, [high[1], low[1]], lookahead = barmerge.lookahead_on)` (righe 17-22). Con `lookahead_on` il valore H4 arriva **prima che la barra H4 sia chiusa**. Qualunque numero di questo script e' privo di significato |
| **C6** | `Falcon Liquidity Grab Strategy` · [TV `egRAKemI`](https://www.tradingview.com/script/egRAKemI/) · sadboyX · 20/01/2025 · 85 righe, 5 input | 🟢 **MPL 2.0** (riga 5) | "liquidity grab" + filtro MA + filtro di sessione; SL **20 punti fissi**, TP 2× | ⬜ nessuna | — | 🔴 **SCARTO — IL CODICE NON PUO' ENTRARE.** Riga 41-42: `swing_low = ta.lowest(low, 5)` **include la barra corrente**, quindi la condizione `low < swing_low` e' **matematicamente impossibile**. Idem sul lato short. Piu': `is_sydney_session = (time >= sydney_start or time <= sydney_end)` (riga 31) e' **sempre vera**. E SL a **20 punti fissi** = il difetto che ha ucciso R116 |
| **C7** | `AI MES Asian Session Strategy` · [TV `HR3TVGbS`](https://www.tradingview.com/script/HR3TVGbS/) · lylerh · 06/04/2026 · 354 righe, **27 input** | 🔴 nessuna dichiarata | ingresso = **`breakoutLong OR fadeLong`** (righe 173-177): rottura del range asiatico **oppure** fade del suo estremo, piu' RSI, volume e filtro HTF | ⬜ nessuna | 🔴 **SI, due volte** (breakout = R45; fade dell'estremo = R42) | 🔴 **SCARTO.** Stesso autore e stesso difetto gia' a verbale il 28/08 (`CACCIA_APERTURA_DAX_EUROPA`): _"il grilletto e' un OR di due cose diverse = fabbrica di combinazioni"_. **27 input contro il tetto di ~15** |
| **C8** | `Turtle soup plus one` · [TV `pQSrIqR2`](https://www.tradingview.com/script/pQSrIqR2/) · Tr0sT · 18/09/2018 · 76 righe, Pine v3 · 416 like | 🔴 nessuna dichiarata | turtle soup classica di Raschke sull'estremo a **20 barre** (`bigPeriod=20`), scala giornaliera, trailing % | ⬜ nessuna | 🟠 **fuori tema** (nessuna sessione, nessuna Londra) + livello a 20 barre = la **carenza di livelli di R89** | 🔴 **SCARTO.** `default_qty_value=100` (100% dell'equity), `pyramiding=1`, nessun cancello di rischio |
| **C9** | `Liquidity Grab Strategy (Volume Trap)` · [TV `Jvnd1LTj`](https://www.tradingview.com/script/Jvnd1LTj/) · davidmdan · 19/05/2025 · **42 righe** | 🔴 nessuna dichiarata | "volume piatto" (`|vol−SMA20|/SMA20 < 5%`) + rottura + FVG a 3 barre; **solo LONG** | ⬜ nessuna | 🟠 fuori tema | 🔴 **SCARTO.** (a) **un lato solo** → non riempie il buco short; (b) il motore e' il **VOLUME**, e la regola di casa (Paolo, `REGISTRO_TEST.md`) e' esplicita: _"volumi affidabili SOLO sugli indici, NON sulle valute"_ → su EURUSD/GBPUSD e' tick volume, non e' un edge |
| **C10** | 🔧 `Dynamic Session Range Sweep Detector` · [MQL5 CB **76305**](https://www.mql5.com/en/code/76305) · Gbadebo Adedayo David · 19/08/2026 · 299 righe · 270 download | 🔴 `#property copyright "Gbadebo Adedayo David"`, nessuna licenza OSI (Code Base = download libero) | **INDICATORE**, non EA: costruisce i range Asia/Londra/NY **in ORA SERVER** (input `InpAsianStartHour=0 … InpLondonEndHour=13`), li **blocca** a fine sessione, e segnala lo sweep solo se la penetrazione supera **`InpMinSweepPips=2,0`** e la barra **chiude rientrata** | ⬜ nessuna | — | 🟠 **NON e' un candidato** (zero `OrderSend`). 🟢 **Archiviato come ATTREZZO**: e' l'unica implementazione MQL5 nativa e pulita del *level builder* di sessione, con `PipSize` fatto giusto (`digits==3\|\|5 → point*10`) e con la **penetrazione minima**, che `ABTG_BreakinBox` **non ha** |
| **C11** | `MHZardary/london-strategy-backtest` · [GitHub](https://github.com/MHZardary/london-strategy-backtest) · 6 stelle | 🟢 **MIT** | backtest Python del **London Open Breakout**: range asiatico 00:00-07:00 GMT, ingresso alla chiusura fuori, SL oltre il lato opposto, TP 1,5-3×, filtri news/SMA50/RSI/MACD | dichiarata EURUSD, GBPUSD, GBPJPY | 🔴 **SI: e' R45 / Londra_ORB** | 🔴 **SCARTO.** 🟢 Nota utile: **l'autore stesso** misura 242 trade, accuratezza **54,1%**, PnL medio **+0,00018 USD/trade** → praticamente zero. **Non conta come nostro numero** (regola: i numeri d'autore non pesano), ma e' una **conferma esterna indipendente** che il breakout d'apertura di Londra e' piatto |

---

## 5. 🔬 IL CONTROLLO SULLE LICENZE — fatto apposta, e il risultato e' scomodo

Il vincolo duro del mandato e' **licenza libera**. Prima di dichiarare "nessuna
licenza" su otto sorgenti, ho verificato che **non fosse il canale a perderla**:
ho riscaricato con lo stesso endpoint uno script che sappiamo essere MPL
(`EurUsd5minLondonSession_SoftKill21-MPL2`, gia' in biblioteca) e la riga
> `// This source code is subject to the terms of the Mozilla Public License 2.0…`

**c'e', alla riga 1.** Il canale non la perde: quando manca, manca davvero.

🔴 **E qui c'e' un'inversione che vale la pena scrivere:** dei quattro candidati
di questa famiglia, **i due con licenza MPL 2.0 sono quelli ROTTI** (C5 con
`lookahead_on`, C6 con una condizione d'ingresso impossibile), e **i quattro
scritti bene non hanno licenza**. L'unico artefatto con licenza libera vera
(**MIT**, C11) e' un caduto. **Anche se il verdetto sul meccanismo fosse stato
positivo, il vincolo di licenza avrebbe fermato l'import del codice** — e la sola
strada legittima sarebbe stata riscrivere la meccanica in MQL5 di casa citando
gli autori, che e' una decisione di Claudio, non mia.

---

## 6. 📄 LA LETTERATURA — buco DICHIARATO, e non lo riempio con la memoria

L'angolo 2 (stop hunt) ha una fonte accademica precisa e vecchia di vent'anni:
**Carol Osler**, *Currency Orders and Exchange Rate Dynamics* (Journal of
Finance, 2003) e *Stop-loss orders and price cascades in currency markets*
(JIMF, 2005). Sarebbero **la tesi prima del codice** che `prove/LEGGIMI.md`
pretende.

🔴 **NON HO APERTO NESSUNA DELLE DUE.** Tre porte, tre muri, misurati oggi:
`papers.ssrn.com` **403** (tredicesima di fila) · `newyorkfed.org` (PDF dello
staff report) **000 al CONNECT + `EGRESS_BLOCKED`** · `technicalanalysis.org.uk`
(mirror) **403** · `ideas.repec.org` **`EGRESS_BLOCKED`** anche via `WebFetch`.

Quello che ho e' **uno snippet di motore di ricerca**, che per la regola §1 del
mio mandato **non e' una fonte**. Lo riporto etichettato e **non lo faccio
pesare su nessun voto**:

> **[INCERTO — snippet, pagina MAI aperta]** gli ordini take-profit si
> addenserebbero **sui** numeri tondi e gli stop-loss **appena oltre**; da qui
> due previsioni: (a) il prezzo **inverte** ai livelli, (b) il prezzo **accelera**
> dopo averli attraversati.

⚠️ **E se anche fosse verificato, taglierebbe in due direzioni opposte:** (b) e'
un argomento **a favore del BREAKOUT** (gia' bocciato 48/48 su Londra), non del
fade. Usare Osler come sponsor dello sweep-and-reclaim sarebbe citarne meta'.
**Da leggere prima di costruirci sopra una riga di codice.**

---

## 7. 🎯 ANGOLO 3 — IL REGIME: non e' un'idea sbagliata, e' un muro di DATI

Il mandato chiedeva se un filtro di regime potesse salvare l'idea. **La risposta
di casa esiste gia', ed e' misurata sulla famiglia esatta** (fade/reversal),
in `REFERTO_CRT_2026-08-30.md` STAGE-2 — cella robusta, 320 trade, per regime:

| regime | n | netto | lettura |
|---|---:|---:|---|
| **crollo 2020** | 30 | **−2.760** | 🔴 il fade prende il coltello che cade |
| toro 2021 (trend liscio) | 68 | −609 | 🔴 piatto/rosso |
| **orso 2022** (grind) | 73 | **+2.633** | 🟢 |
| **2023** (range/chop) | 83 | **+5.259** | 🟢 il grosso |

➡️ **Il fade di sessione e' un motore da CHOP, misurato.** E questo spiega
perfettamente perche' BreakinBox e R116 sono rossi: **il tick BCM copre 21-24
mesi di UN SOLO REGIME (toro)**, cioe' il regime in cui questa famiglia non paga.

🔴 **Ma da qui NON esce un candidato, per due motivi duri:**
1. Un filtro di regime **appiccicato a un motore gia' tarato** e' 0 successi su
   5 in casa (R20 ADX, R12, R26, R45, R54) — ed e' esattamente cio' che il §5B
   vieta. Il filtro dovrebbe **essere** il motore, e qui non lo e'.
2. **F6 non si ammorbidisce**: il verdetto lo danno i tick del nostro broker, e
   i tick BCM **non raggiungono** i regimi in cui la famiglia vive. Senza
   l'import Dukascopy (strumenti pronti dal 31/08, **mai lanciati**) questo
   angolo **non e' misurabile**, punto.

**Traduzione operativa:** l'angolo 3 e' bloccato dai DATI, non dall'idea. Chi lo
vuole riaprire deve prima far girare l'import Dukascopy — e' la stessa porta che
tiene parcheggiati CRT e NY-Retest.

---

## 8. ⬜ QUELLO CHE NON HO POTUTO VEDERE — dichiarato

| oggetto | perche' |
|---|---|
| **Osler 2003 (JF) e Osler 2005 (JIMF)** | SSRN 403 · NY Fed egress-blocked · mirror UK 403 · RePEc egress-blocked. **Il buco piu' costoso della caccia**: e' la tesi che sta sotto all'angolo 2 |
| **Forex Factory — thread storici sulla London session** | murata al DOMINIO su due trasporti (misurato 02/09). Era l'unico posto dove si legge **come una strategia e' invecchiata** |
| **`Liquidity Sweep Tracker` (blitz_locked, 666 righe)** e **`_mr_beach Liquidity Sweep + VWAP V2`** | **scaricati ma NON letti riga per riga**, e lo scrivo invece di fingere: dopo aver stabilito che l'intera famiglia e' BreakinBox, leggere altre 666 righe della stessa famiglia non cambia nessun verdetto. Se qualcuno vuole riaprirli, sono in `/tmp` della sessione, non in biblioteca |
| **`TJR asia session sweep`, `ICT Sessions & Liquidity Sweeps Strategy`** (576 e 173 like) | `access=2` → **sorgente protetto**, il `pine-facade` risponde 401. Non valutabili |
| **MQL5 Code Base, censimento nuovo** | **non fatto per mandato**: chiuso il 02/09 su **400 id / 10 pagine** con zero motori intraday, e la ricerca per parola chiave **non esiste** (il parametro `keyword` viene ignorato). Aperto solo per l'attrezzo 76305 |

---

## 9. 🥇 COSA MERITA DAVVERO L'ATTENZIONE DI CLAUDIO — l'alternativa vera esiste, ed e' in casa

Il mandato chiedeva **un meccanismo diverso sulla stessa inefficienza**. Non l'ho
trovato fuori. **Ma dentro c'e', e' stato misurato OGGI, ed e' l'unica cosa viva
sull'apertura di Londra:**

### 🕐 La DERIVA ORARIA di Breedon-Ranaldo — `OROLOGIO_VS_BREEDON_2026-09-03.md`

| finestra | cella | lordo | spread med | **C1 (soglia 3)** | n |
|---|---|---:|---:|---:|---:|
| IS 2011-2017 | **EURUSD SHORT 08:00-16:00 server** | **+32,13** pti | 7,00 | **4,59** ✅ | 1.607 |
| OOS 2017-2026 | stessa cella | **+5,31** pti | 1,00 | **5,31** ✅ | 2.411 |

**Perche' e' esattamente cio' che il mandato cercava:**
- 🎯 **Non e' un range, non e' un breakout, non e' uno sweep.** E' una **deriva
  direzionale legata all'ora e all'identita' della valuta**: zero livelli, zero
  rotture. **Nessuna parentela con nessuno dei sei caduti** della tabella §2.
- 🎯 **Copre la stessa inefficienza**: la finestra 08:00-16:00 server **inizia
  esattamente all'apertura di Londra** (§3).
- 🎯 **Ha la tesi PRIMA del codice**, che e' il primo requisito di ogni round:
  Breedon-Ranaldo (JMCB 2013), con implementazione pubblica **Apache 2.0** gia'
  in biblioteca (`FxBizday_QuantRocket-Apache2_gh-fx-bizday_2026-09-01.py`).
- 🎯 **La cella e' stata indicata PRIMA dei numeri** (foglio di pre-registrazione
  01/09, criterio C2) — la forma piu' forte di conferma che il metodo conosca.
- 🎯 **Riempie il buco SHORT** dichiarato in `ROTTA_PROP.md`.

🔴 **E il suo problema e' NOMINATO, non nascosto** — ed e' un problema di
**esecuzione**, non di edge: l'autore del paper scrive
_"even 1 basis point will destroy the profitability"_, e la versione
incondizionata muore con ~1 bp di slippage. **La domanda giusta del prossimo
round non e' "quale motore", e' "come si entra senza pagare lo spread"**
(esecuzione passiva / alla barra, non market).

### Il secondo posto, e costa una corsa
**`ABTG_OutOfNoise` non e' bocciato: e' ROTTO** e mai rigirato dopo la
riparazione (`REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md`: `CopyRates` conta barre
di **calendario** invece che di **seduta**, quindi `nDays` resta 4-5 contro
`InpConeMinDays=14` e l'EA non entra mai). Baco corretto in v1.01/v1.02, **mai
rigirato**. E' momentum intraday, famiglia completamente diversa dai caduti.

---

## 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non e' piu' *"quale motore di Londra proviamo"*. Dopo sei bocciature sulla stessa
famiglia, la domanda utile e' **una sola**:

> **"La deriva oraria di Breedon-Ranaldo su EURUSD (short 08:00→16:00 server) —
> l'unica meccanica sull'apertura di Londra che in casa abbia superato un
> cancello su ENTRAMBE le finestre — sopravvive a un'ESECUZIONE REALE sul nostro
> broker, cioe' entrando in modo passivo invece che a mercato?"**

Se **si'**: abbiamo un motore short, non-correlato al parco (nessun livello,
nessun range), su un'inefficienza documentata da rivista.
Se **no**: allora l'apertura di Londra **e' chiusa per noi in tutte e due le
forme note** — la forma "livello" (sei bocciature) e la forma "deriva" (uccisa
dai costi) — e il tempo va sui buchi veri del portafoglio.

🛑 **NESSUN FILE PROVA E' STATO SCRITTO**, perche' non ci sono promossi. Scrivere
un `.txt` per un candidato che il §2 dichiara caduto sarebbe la cosa peggiore
che questa caccia potesse consegnare.

---

## 11. 🧾 ONESTA' FINALE

**Sei mesi di caccia sulla parola "Londra" hanno prodotto, ogni volta, la stessa
scatola.** Il 19/08 il dossier chiudeva cosi': _"il web, sulla parola Londra,
offre quasi solo varianti del breakout gia' bocciato"_. Oggi la frase va
aggiornata, ed e' peggio: **il web offre il breakout E il suo fade, e li abbiamo
misurati entrambi.**

Il valore di questa caccia non e' un candidato. E' aver stabilito, **con i
sorgenti aperti da una parte e i nostri `input` dall'altra**, che i quattro
migliori oggetti del web su questo bersaglio sono **un EA che abbiamo gia'
scritto, gia' compilato, gia' girato a tick e gia' chiuso** — e che quindi
**non esiste, oggi, un round di Londra da lanciare**. Una serata di tester
risparmiata, e un file `.txt` non scritto.

---

_Dossier compilato il 03/09/2026. Fonti aperte davvero: TradingView (30 query,
47 strategie viste, **9 sorgenti Pine scaricati e letti**), MQL5 Code Base
(1 sorgente `.mq5` letto), GitHub (1 repo), arXiv (4 query). Fonti dichiarate
NULLE oggi: SSRN (403, 13ª), newyorkfed.org (egress), technicalanalysis.org.uk
(403), ideas.repec.org (egress). **Nessun numero di performance d'autore e'
stato usato in nessun voto.** **Nessun EA di casa e' stato modificato; nessuna
sedia in forward e' stata toccata; nessuna riga di lancio e' stata costruita.**_

_Attribuzione, come da regola di casa — gli autori dei sorgenti letti:
heriniaina2022, Fran_Pineda, MatthewRodrigues4, mindyourbuisness, Ericem,
sadboyX, lylerh, Tr0sT, davidmdan (TradingView); Gbadebo Adedayo David
(MQL5 Code Base 76305); MHZardary (GitHub, MIT). **Nessuna riga del loro codice
e' stata portata in nessun file del repo**: i sorgenti sono archiviati in
`caccia_strategie/biblioteca/sorgenti/` per la lettura, non per l'uso._
