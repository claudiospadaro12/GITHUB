# 🎯 CACCIA — MECCANISMI NUOVI per DAX (D30EUR) e DOW (U30USD) — 06/09/2026

_Mandato: Regola della Seconda Caccia (CLAUDE.md, 19/08). Si cercano
**MECCANISMI ALTERNATIVI** sulla stessa inefficienza, **MAI parametri diversi**
di un motore gia' bocciato o gia' vivo. Bersaglio: DAX e Dow, non Nasdaq.
Nessun EA toccato, nessun backtest lanciato, nessun parametro di forward
sfiorato._

---

## LA RIGA CHE CONTA

> **Su ~149 titoli guardati su 11 interrogazioni e 8 fonti (di cui 5 chiuse o
> bloccate), 6 pagine/abstract esterni letti davvero, ZERO candidati esterni
> promossi.**
>
> 🔴 **E il candidato che mi e' stato passato — l'ORB-STRADDLE del PS5 ORB Bot
> — NON e' un meccanismo nuovo per noi: ce l'abbiamo gia', in QUATTRO EA, e
> DUE di quei quattro girano sul conto reale.** Verificato riga per riga nel
> sorgente, non nella descrizione (§1).
>
> 🟢 **L'unica cosa genuinamente diversa che questa caccia consegna non e' un
> EA esterno: e' una MISURA che non abbiamo mai fatto sugli indici, e che e'
> l'unica famiglia su DAX/Dow che il pavimento dei 150 trade NON uccide** —
> la **SONDA DELL'OROLOGIO** (§5). File prova pronti, magic vergini, zero
> righe di codice da scrivere.

---

## 0. CONTROLLO POSITIVO — fonte per fonte, prima di cercare

| fonte | esito | prova |
|---|---|---|
| **MQL5 Code Base** `mql5.com/en/code/mt5/experts` | 🟢 **PASSA** | HTTP 200, 40 titoli con ID reali, e fra questi **id gia' nel nostro setaccio**: 76446 (Chaos Lyapunov, bocciato 31/08), 76153 (Session ORB, scartato 19/08), 76117 (Round Trip Cost Reconciler, annotato 05/09), 75586 (GoldLondonBreakout, scartato). Il canale restituisce cio' che so gia' esserci. ⚠️ **Autori e date NON leggibili nella lista** (JS): confermata la limitazione del 05/09 |
| **arXiv API q-fin** `export.arxiv.org/api/query` | 🟢 **PASSA** | `cat:q-fin.TR` ultimi 5 -> 2609.03115, 2609.02447, 2608.30999, 2608.30321, 2608.29468 (date 29/08-02/09/2026, coerenti). ⚠️ **Solo HTTPS** (lezione 05/09: in http torna 301 a 0 byte) |
| **TradingView** `tradingview.com/scripts/...` | 🟢 **PASSA** | `/scripts/opensource/?script_type=strategies` restituisce titoli e autori reali (`CryptoFlux Dynamo [JOAT]`, e **`Out of the Noise Intraday Strategy with VWAP [YuL]` di Yuri_Lopukhov — che e' l'originale del nostro `ABTG_OutOfNoise`**: bersaglio noto ritrovato = controllo passato) |
| **GitHub (UI di ricerca)** | 🔴 **NULLA — e NON e' un 404** | `github.com/search?q=mql5` -> **HTTP 429, `Retry-After: 3600`**. `api.github.com` -> 403 (sessione vincolata al repo). **`gh` CLI non installato** in questo ambiente (`No such file or directory`). ➡️ **FRONTE GITHUB NON BATTUTO OGGI.** Terza volta di fila (02/09, 05/09, 06/09) |
| **Forex Factory** `forexfactory.com/forum/71-trading-systems` | 🔴 **NULLA** | HTTP **403** |
| **SSRN** `papers.ssrn.com` (bersaglio noto 4729284) | 🔴 **NULLA** | HTTP **403** — ennesima di fila |
| **Deutsche Boerse / Xetra** (orari d'asta, fonte primaria) | 🔴 **NULLA** | `cashmarket.deutsche-boerse.com` **EGRESS_BLOCKED**, `xetra.com` **EGRESS_BLOCKED** |
| **Quantpedia** (blog gratuito) | 🟡 **raggiungibile, vuota sul tema** | ricerca su blog 2026: gli aggiornamenti di maggio/giugno 2026 non contengono nulla di intraday su indici. Le pagine `/strategies/` restano premium (confermato 03/09) |

🔴 **Cinque fonti su otto non hanno prodotto nulla per motivi di canale, non di
merito. Questa caccia e' zoppa e lo dichiara.**

---

## 1. 🚨 LA VERIFICA CHIESTA: l'ORB-STRADDLE ESISTE GIA' IN CASA, E GIRA SUL REALE

**Domanda posta:** _"Verifica se una logica ORB-STRADDLE (doppio ordine stop
opposto con cancellazione immediata) esiste gia' in qualche forma nel nostro
repo."_

**Risposta: SI. In quattro EA. Letto nel sorgente, con i numeri di riga.**

| EA | doppio ordine stop opposto | cancellazione immediata della gamba opposta |
|---|---|---|
| 🪑 **`ABTG_DAX_Apertura_EU.mq5`** (magic 770101, **LIVE sul reale**) | `gTrade.BuyStop(...)` **r.1073** e `gTrade.SellStop(...)` **r.1096**, entrambi su `gRangeHigh+buffer` / `gRangeLow-buffer` dentro la stessa `TryPlaceBreakout()` | `HandleOCO()` **r.1850-1854**: `if(!HasOpenPosition()) return; CancelMyPendings();` → `CancelMyPendings()` **r.1833-1845** filtra simbolo+magic e chiama `gTrade.OrderDelete(ticket)`. **Chiamata a ogni tick, r.590** |
| 🪑 **`ABTG_ORB_Ottimizzato.mq5`** (magic 770611, **LIVE sul reale**) | `BuyStop` **r.456**, `SellStop` **r.471** | `HandleOCO()` **r.1029**, `CancelPendings()` **r.1031-1041** |
| `ABTG_Londra_ORB.mq5` (bocciato) | `BuyStop` **r.220**, `SellStop` **r.235** | `HandleOCO()` **r.304**, `CancelPendings()` **r.306-314** |
| `ABTG_MaxMinNotte.mq5` (famiglia con sedia viva) | `BuyStop` **r.355**, `SellStop` **r.367** | `HandleOCO()` **r.473**, `CancelPendings()` **r.475-483** |

_(un quinto: `ABTG_PostNews.mq5` fa la stessa cosa sul range della notizia, con
`OcoCheck` — annotato nel dossier notizie del 03/09.)_

### E i quattro "tratti distintivi" del PS5 sono INPUT che abbiamo gia'

| tratto dichiarato dalla fonte | dove sta gia' da noi | [VERIFICATO] |
|---|---|---|
| geometria **interamente ATR-adattiva** | `input ENUM_ABTG_SL InpSLMode` con modo **`ABTG_SL_ATR`** + `input double InpAtrSlMult = 1.5` | `ABTG_DAX_Apertura_EU.mq5` **r.314-315**; applicato a r.1063 (`sl = entry - AtrValue()*InpAtrSlMult`) |
| **stop MOLTO stretto, pavimento a ZERO, mai allargato** | `input double InpMinStopPts = 0; // ... 0=off` — **il default e' gia' 0** — con `InpSkipIfTight` che decide se SALTARE o ALLARGARE | `ABTG_DAX_Apertura_EU.mq5` **r.345**; logica a r.1064-1068 |
| **partial TP a 1,5R + runner a 3R** | `InpTP1_R`, `TpTotalR()`, `InpBEatR` (breakeven indipendente) | **r.317, r.320**, gestione in `ManagePosition()` |
| **niente recovery/martingala mai** | e' gia' il §4 del cacciatore: nessuno dei nostri EA ne ha | — |

### 🔴 VERDETTO: SCARTO, e non e' una questione di gusto — e' la Regola della Seconda Caccia alla lettera

> _"si cercano MECCANISMI alternativi sulla stessa inefficienza, MAI 'parametri
> diversi dello stesso motore morto'."_ (CLAUDE.md, 19/08)

Qui il motore non e' nemmeno morto: **e' VIVO e sta sul conto reale.** Proporre
il PS5 come candidato significherebbe rilanciare `ABTG_DAX_Apertura_EU` con
`InpSLMode=ATR`, `InpMinStopPts=0`, `InpTP1_R=1.5` — cioe' **una griglia di
parametri su una sedia viva**, che e' esattamente la cosa che la regola vieta.

**I numeri della fonte** (DAX PF 2,40 / DD 2,07%; Dow PF 3,01 / DD 2,67%) sono
**[DICHIARATI DALL'AUTORE, BACKTEST IDEALE, NON VERIFICATI DA NOI]** e per il §7
del mandato **non pesano sul punteggio**. Vanno letti accanto a due misure di
casa che dicono il contrario su questa stessa geometria:

- **R57**: cambiando **solo** il modello (OHLC → tick reali) il segno si e' ribaltato.
- **Dow H4**: PF **2,77** su barre → PF mediano **0,79** a tick reali, promozione **revocata**.
- **Londra_ORB** (`REGISTRO_TEST.md` r.29) e' descritto testualmente come
  _"straddle OCO sul range 06-07 server"_ → **11% celle positive, DD 23%, morto**.
- **R45** (ORB di sessione): **0 celle positive su 48**.
- **Capitolo BREAKOUT M5 in apertura: CHIUSO il 26.07.26** (`REGISTRO_TEST.md` r.40),
  testualmente _"Non costruire altri v2 M5"_.

### 🟡 L'UNICA COSA ONESTA CHE RESTA IN PIEDI (e NON e' un candidato, e' una decisione di Claudio)

La sedia viva `ABTG_DAX_Apertura_EU` gira con **floor 200 punti**
(`REGISTRO_TEST.md` r.19, config A2) e SL al **bordo opposto del range**, non ad
ATR. Il PS5 gira con **floor 0** e SL **ATR**. **Sono due valori di due input che
gia' esistono**, non due motori.

- Come **candidato da imbuto**: 🔴 **SCARTO** (parametri di un motore vivo).
- Come **ablazione a due celle** su banco separato, magic nuovi, sedia viva mai
  toccata: e' tecnicamente possibile ed e' **una decisione di Claudio, non mia**.
  ⚠️ Con un avvertimento misurato: il pavimento `InpMinStopPts` **e' nato da R109**
  e lo spread D30EUR misurato in casa e' **1,65 punti indice**
  (`SPREAD_FLOTTA_MISURA_2026-09-03.md`) → **uno stop "molto stretto" su D30EUR
  paga una tassa che cresce come 1/SL.** Con SL 20 punti lo spread vale gia'
  **0,0825R**, cioe' **1,1 volte l'intero cancello H8 (0,075R)**
  (`CACCIA_TF_M5_2026-09-05.md`). "Stop strettissimo" e "prop" sono in tensione,
  e la tensione va misurata prima, non dopo.

---

## 2. COSA HO SFOGLIATO, FONTE PER FONTE

| fonte | interrogazioni | titoli visti | pagine aperte | sorgenti letti |
|---|---:|---:|---:|---:|
| MQL5 Code Base | 1 lista + 2 schede | 40 | 2 | **0** |
| TradingView (tag `dax`, `us30`, `xetra`, opensource, ricerca) | 5 | 41 | 1 | **0** |
| arXiv API q-fin (TR recent, TR+intraday, ST+DAX/lead-lag, closing auction, index futures) | 5 | 68 | 3 abstract (API `id_list`) | — |
| GitHub | 2 | 0 | 0 | 0 (**429**) |
| Forex Factory | 1 | 0 | 0 | 0 (**403**) |
| SSRN | 1 | 0 | 0 | 0 (**403**) |
| Quantpedia | 1 | — | 0 | 0 |
| Deutsche Boerse/Xetra | 2 | 0 | 0 | 0 (**EGRESS_BLOCKED**) |
| **TOTALE** | **18** | **~149** | **6** | **0 esterni** |

🔴 **DIFETTO DICHIARATO DI QUESTA CACCIA: ZERO sorgenti esterni letti.**
Non e' pigrizia, ed e' peggio di una pigrizia perche' e' strutturale:
(a) i due EA nuovi del Code Base si scartano **sulla loro stessa pagina** (§3);
(b) l'unico script TradingView con una meccanica nuova **e' un indicatore e la
fetch non rende il Pine**; (c) GitHub — la fonte che di solito da' il sorgente —
**e' murata da tre cacce**. Un dossier con 0 sorgenti letti vale meno di uno con
3: lo scrivo invece di nasconderlo dietro un elenco.

**In compenso i sorgenti letti verbatim OGGI sono 7, e sono i NOSTRI:**
`ABTG_DAX_Apertura_EU.mq5` (2367 righe), `ABTG_ORB_Ottimizzato.mq5` (1463),
`ABTG_Londra_ORB.mq5` (490), `ABTG_MaxMinNotte.mq5` (918),
`ABTG_SondaOrologio.mq5` (971), piu' i due file prova dell'orologio.
**La verifica del §1 vale piu' di dieci link.**

---

## 3. LA TABELLA DEGLI SCARTATI — una riga di motivo a testa

### 3.1 MQL5 Code Base — i due EA nuovi dal 05/09 a oggi

| id | titolo / autore / data | cosa fa (dalla sua pagina) | 🔴 motivo dello scarto |
|---|---|---|---|
| **76927** | `Session Range Desk MT5` — **Erdem Mumin Kaynak, 03/09/2026** | range trailing su N barre precedenti, banda di ampiezza su ATR, **ingresso ai bordi del range con stop al bordo opposto**, rischio %, R-multipli, BE, parziali, limite giornaliero, flat a fine sessione | 🔴 **DOPPIONE ESATTO del nostro `ABTG_ORB`/`ABTG_DAX_Apertura_EU`**, con in piu' un "desk multi-grafico" che noi risolviamo col Guardian. Famiglia ORB: **~210 celle gia' spazzolate**, R45 0/48, capitolo M5 chiuso r.40. L'autore stesso scrive che e' _"a programming example, not a certified account-protection system"_ |
| **77009** | `SuperTrend TV EA` — **Mykyta Samoiliuk (Nikita9995), 06/09/2026** | SuperTrend che si ribalta: compra allo flip su, vende allo flip giu'; SL **sulla linea SuperTrend**; una posizione alla volta | 🔴 **Famiglia SupRev, che in casa e' gia' VIVA** (SupRev DAX H1/H4, Dow H1/H4, Nasdaq H1). Non porta niente che non abbiamo. E **lo dice l'autore stesso sulla pagina**: pubblica per la correttezza del segnale, non per la redditivita', _"backtests showed modest results due to spread costs from frequent reversals"_ |

📌 **CONFERMA, quinta volta consecutiva (31/08, 02/09, 03/09, 05/09, oggi): il
Code Base ha smesso di produrre MOTORI.** Degli altri 38 titoli della prima
pagina, sono **tutti** pannelli, calcolatori, logger, demo Renko, utility
Quantora, guardiani di DD, esportatori di calendario. **Zero motori intraday per
indici.** ➡️ La regola gia' scritta il 31/08 regge: **il Code Base si apre per
gli ATTREZZI, non per i motori.**

### 3.2 TradingView — tag `dax` (22 script) e `us30` (13 script)

**Il fatto quantitativo prima dei singoli:** sul tag DAX, **20 su 22 sono
INDICATORI**. Le due `strategy` sono `TPS - FX Trade` (trademasterf) e
`Dhananjay Volatility stop strategy v1.0` — **nessuna delle due e' DAX-specifica**:
il DAX c'entra solo come simbolo del grafico. Sul tag US30, **11 su 13 sono
indicatori**. **Questa e' la terza conferma indipendente** (28/08, 30/08, oggi):
_il DAX gratuito col sorgente e' fatto di indicatori e dashboard, e quando trada
e' ORB._

| script / autore | cosa fa | 🔴 motivo dello scarto |
|---|---|---|
| **`Xetra Auctions Breakout [Box Strategy]`** — ovvo_113, agg. 11/02/2026, **1.742 like**, open-source | box high/low dell'**asta di apertura 08:50-09:00 CET** e dell'**asta intraday 13:00-13:02 CET**, estesi come S/R per la giornata; tre usi suggeriti: breakout sopra/sotto il box d'apertura, **reversal sul box dell'asta intraday**, "ghost levels" del giorno prima | 🟠 **Lo scarto migliore della giornata, e resta scarto.** (a) E' un **`indicator`, non una `strategy`**: zero ordini, zero gestione, zero numeri. (b) ⚠️ **SORGENTE NON LETTO**: la pagina dichiara open-source ma la fetch non rende il Pine → non posso applicare il §4. (c) **La geometria e' quella dei caduti**: box su finestra oraria + rottura = ORB (~210 celle); box + fade = R42 (**0/24 IS e 0/24 OOS**). La lezione e' gia' agli atti in due posti: _"Cambiare il LIVELLO non cambia la geometria"_ (03/09) e _"Non si riapre cambiando simbolo"_ (03/09). (d) Il box d'apertura 08:50-09:00 CET = **07:50-08:00 ora server** = **la finestra pre-apertura della sedia viva 770101**. ✅ **Cosa TENGO — e non e' il codice, e' un FATTO: §4** |
| `DAX 9-10 Breakout Strategy Indicator` — HubertLorenz | rottura del range 09:00-10:00 | 🔴 ORB, capitolo chiuso. Indicatore |
| `OPR Asia London US Universal Open Price Range` — RAFENTech | opening price range multi-sessione | 🔴 ORB su tre sessioni. Indicatore |
| `Xetra / GER40 1M Setup`, `Zen FDAX Session`, `DAX 6x Daily Session lines`, `Multi-Time Open Levels`, `SESSIONS`, `NYSessions`, `1+KillZoneLite` | disegnano sessioni e livelli | 🔴 **Non sono motori**: sono righe sul grafico |
| `DAX Universe Relative Strength [JS]`, `DAX Breadth [AM]`, `McClellan Oscillator for DAX (GER30)` | **ampiezza di mercato** sui 40 titoli del DAX | 🔴 **Morti per DATI, non per idea**: richiedono i costituenti dell'indice, che su MT5/BCM **non esistono**. Non e' testabile con la nostra pipeline. (Il McClellan, per giunta, l'autore lo dichiara **bacato**) |
| `Seasonality: Stock Indices`, `Seasonality DOW - Day Of the Week`, `Seasonality Overnight Gaps`, `ILM Overnight vs Intraday Performance` — invincible3 / ILuvMarkets | tabelle di stagionalita' e scomposizione overnight/intraday | 🔴 **Tabelle di analisi, non motori.** E la scomposizione overnight e' gia' chiusa in casa: **lapide L4** (_"un gap di apertura e' UNO al giorno: nessuna implementazione puo' superare il pavimento di 2 segnali/giorno per lato"_) e **L5** (momentum di Gao morto in R98 _"per attrito overnight che sui CFD non esiste"_) |
| `Nasdaq DowJones RATIO` — triccomane | rapporto fra due indici | 🔴 **E' la famiglia `ABTG_Relativo`**, gia' misurata: **R117 D30EUR BOCCIATA PER RISCHIO** (DD 25,01%, peggior giornata -5,20%, E OOS -0,267R). Indicatore, e la famiglia e' chiusa sul DAX |
| `Balance of Power for US30 4H [PineIndicators]` | oscillatore BoP su **US30 H4**, soglie incrociate | 🔴 **Due muri insieme**: (a) e' un **oscillatore a soglia** = filtro-che-e'-un-motore ma della famiglia cross gia' morta due volte (Chaos 105 celle, RSI+EMA V8); (b) **H4 sul Dow e' esplicitamente vietato dal mandato** — PF 2,77 su barre → **0,79 mediano a tick reali**, promozione revocata |
| `Swing Stock Market Multi MA Correlation` — exlux | incroci di piu' medie + correlazione, **swing** | 🔴 Incrocio di medie (SuperWave/Chaos) **e swing**, mentre il buco e' intraday |
| `Dow Theory Trend Strategy` — Salaryman_G | pivot high/low, trend secondo la teoria di Dow | 🔴 Pivot di struttura = famiglia `ABTG_EasyTrend`/`SuperWave`, gia' in casa. Nessuna sessione, nessun flat |
| `US30 HMA Signal v2.8`, `Liquidity Sniper Pro`, `Asia Range 120% & 161.8%`, `US30 Quarter Levels`, `Pinbar-Rejection-Indicator` | HMA, sweep di liquidita', livelli, pin bar | 🔴 **M24 (liquidity pools) e' un cimitero tre volte** (`CACCIA_TF_M5`); il range asiatico e' `MaxMinNotte`/`BreakinBox` (chiuso a tick 31/08: PF 1,007 DD 24,1%); i pin bar sono il ramo reversal di 68704, gia' in coda dal 30/08 |
| `TPS - FX Trade`, `Dhananjay Volatility stop strategy v1.0` | le uniche due `strategy` del tag DAX | 🔴 **Fuori bersaglio**: nessuna delle due e' un motore per indici — il DAX e' solo il grafico su cui sono pubblicate |

### 3.3 arXiv q-fin — 68 voci scorse, 3 abstract verificati con l'API

_(metadati verificati con `export.arxiv.org/api/query?id_list=...`, non con la
pagina: lezione del 05/09 — "una risposta di WebFetch non e' una citazione")_

| paper | metadati [VERIFICATI via API] | 🔴 motivo dello scarto |
|---|---|---|
| **`Push-response anomalies in high-frequency S&P 500 price series`** — Vlasiuk, Smirnov | 2511.06177v1, **pubblicato 2025-11-09**, q-fin.TR | 🔴 **Ci dice il contrario di quello che speravamo, e lo dice l'abstract**: _"for short lags (1-5,000 ticks), expected responses cluster near zero across most push magnitudes, suggesting high short-term efficiency"_. L'asimmetria che trova sta **oltre** quel raggio e su **dati NBBO tick-per-tick di SPY**: non riproducibile su un CFD BCM, non testabile con la nostra macchina |
| **`Hidden Order in Trades Predicts the Size of Price Moves`** — Singha | 2512.15720v1, **pubblicato 2025-12-02**, q-fin.TR | 🔴 **L'autore stesso esclude la direzione**: _"predicts intraday price magnitude without directional signal ... directional accuracy remains at chance levels (45%)"_. Al massimo sarebbe un **GATE di volatilita' appiccicato a un motore esistente** = il caso che in casa e' **0 successi su 5** (R20, R12, R26, R45, R54). E servono **38,5 milioni di trade** per calcolare l'entropia |
| **`A Volume-Price-Adjusted MACD Trading Strategy ... for U.S. Equity Indices`** — Lin, Lin, Zhang, Zheng, Wang | 2604.26063v1, **pubblicato 2026-04-28**, q-fin.TR | 🔴 **MACD = incrocio di medie.** In casa quella famiglia e' morta due volte in modo misurato (Chaos Lyapunov 105 celle, RSI+EMA V8 -9/-13% di segnali tolti) e vive solo come SuperWave/SupRev, che gia' **abbiamo sul Dow**. Piu': **calibrato 2018-2022 e testato 2023-2026 su dati giornalieri**, nessuno stop loss descritto, **nessun codice pubblicato** |
| `Learning Market Making with Closing Auctions` (2601.17247), `Equity auction dynamics` (2401.06724), `Heavy tailed distributions in closing auctions` (2012.10145), `Dynamical regularities of US equities opening and closing auctions` (1802.01921) | letti solo come titolo+riassunto | 🔴 **Tutta la letteratura sulle aste e' MICROSTRUTTURA da libro ordini su AZIONI SINGOLE.** Non esiste un'asta su un CFD di indice, e il libro ordini non ce l'abbiamo. **Nessuna traduzione possibile sui nostri simboli** |
| 25 voci `lead-lag` (2608.24703, 2601.01871, 2201.08283, 2312.10084, ...) | scorse | 🔴 **Tutte cross-section su AZIONI o cluster di titoli**, nessuna su lead-lag fra INDICI intraday. E la nostra misura c'e' gia': **M25 lead-lag S&P→DAX su M5 = 8 celle su 8 negative al netto**, informazione direzionale **-0,003R/+0,013R = zero** (`CACCIA_TF_M5_2026-09-05.md`) |
| 5 voci con "DAX" (2509.19663, 2409.10543, 2104.10673, 2012.06856, 2009.13215) | scorse | 🔴 Sono **econometria del rischio e statistica delle serie** (DFA, entropia, backtesting di VaR, Tsallis): il DAX c'e' come dato, non come strategia |

📌 **E LE TRE LAPIDI arXiv gia' agli atti restano in piedi e coprono il resto
del campo su questi simboli:** 2605.04004 (14 famiglie di segnali intraday
OHLCV su MNQ, **nessuna supera i costi**), 2605.17724 (LSTM/GB su MNQ, **nessuna
configurazione sopra il tasso base 51,8%**), 2605.11423 (classificatore di
regime, **8 configurazioni direzionali su 8 falsificate dall'autore**).

---

## 4. ✅ COSA TENGO DALLA CACCIA — un FATTO, non un candidato

**L'asta intraday di Xetra.** Lo script `Xetra Auctions Breakout` afferma che il
DAX ha, oltre all'asta di apertura, una **asta intraday alle 13:00-13:02 CET**,
cioe' **12:00-12:02 ORA SERVER BCM** — un evento di liquidita' **programmato,
a minuto fisso, in mezzo alla seduta**.

- ⚠️ **[INCERTO], e va detto forte: l'orario NON e' verificato alla fonte
  primaria.** `cashmarket.deutsche-boerse.com` e `xetra.com` sono entrambi
  **EGRESS_BLOCKED**. L'ho letto **solo** sulla pagina di uno script TradingView
  e su un riassunto di ricerca. **Prima di spenderci un minuto, qualcuno deve
  aprire il calendario Xetra da un browser vero.**
- 🕳️ **Perche' e' comunque un fatto utile:** la nostra flotta sul DAX lavora
  **08:00-12:00** (aperture) e **di notte** (MaxMinNotte). Le **12:00 server**
  sono il confine esatto in cui la sedia viva smette. `ABTG_DaxReEntry` guarda
  **12:05-15:15** — cioe' comincia **cinque minuti dopo** l'asta dichiarata.
  **Nessuno ha mai guardato quel minuto.**
- 🔬 **E si misura a costo quasi zero, senza toccare MT5**: i dati M1 esterni
  sono gia' in casa (**FutureSharks/financial-data, GPL-3.0, `GRXEUR` M1
  2012-2018, stessa scala di D30EUR**, `biblioteca/sonde_esterne/LEGGIMI.md`),
  con l'orologio gia' calibrato (**ora file + 5 = ora server**, misurato il
  05/09). Una sonda Python di venti righe risponde a: **"alle 12:00 server il
  DAX mostra un salto di |variazione| media rispetto alle 11:xx e 12:xx?"**
  Se la risposta e' no, l'idea muore in venti minuti e non torna mai piu'.
- 🔴 **E se la risposta fosse si', NON diventerebbe comunque un box-breakout**:
  quella geometria e' sepolta. Diventerebbe la domanda giusta —
  _"esiste un'ora del giorno con una deriva, sul DAX?"_ — che e' esattamente il
  §5.

---

## 5. 🥇 LA PROPOSTA — e non e' un EA esterno: e' la SONDA DELL'OROLOGIO sugli INDICI

**Non ho un candidato esterno da promuovere. Ce l'ho in casa, non e' mai stato
acceso, ed e' l'unica famiglia su DAX/Dow che non ha un parente nel cimitero.**

```
NOME            SONDA DELL'OROLOGIO -- celle INDICI (D30EUR, U30USD)
FONTE / URL     IN CASA: mql5/Experts/ABTG_SondaOrologio.mq5 (971 righe,
                gia' scritto il 28/08/2026, MAI COMPILATO, MAI GIRATO --
                verificato: zero referti in risultati_archivio/)
                Specifica congelata: prove/SONDA_OROLOGIO_FX.txt
AUTORE / DATA   di casa, 28/08/2026.  POPOLARITA' n/a
LICENZA         nostra
RIGHE / INPUT   971 righe. UN SOLO asse spazzolato (l'ORA) + la durata

TESI IN UNA RIGA
  "Guadagna perche' i flussi che muovono un indice hanno un ORARIO
   D'UFFICIO -- l'apertura del cash, il fixing, l'arrivo di New York,
   l'asta di chiusura -- e quell'orario non e' un pattern di prezzo:
   e' un calendario. Se la deriva media di un BLOCCO DI ORE e' diversa
   da zero in modo sistematico e piu' grande dello spread di
   QUELL'ORA, esiste un motore che non ha bisogno di nessun livello."

MECCANICA        ingresso: all'apertura della barra H1 la cui ora server ==
                 InpOraIngresso. NESSUNA condizione di prezzo, mai.
                 uscita:   dopo InpOreDurata ore. Sempre. Senza condizioni.
                           + flat forzato di fine giornata non disattivabile.
                 stop:     SOLO protezione, 10 x ATR (praticamente mai toccato)
GESTIONE RISCHIO rischio in % (1,0% taglia di confronto), SL vero al broker,
                 1 posizione, 1 ingresso/giorno, nessun filtro di spread
                 (lo spread si MISURA, non si filtra)
BANDIERE ROSSE   NESSUNA. Zero indicatori nell'ingresso, zero martingala,
                 zero griglia, zero repaint (decide all'apertura della barra)
COSTO DI PORTING ZERO. L'EA esiste, i file prova esistono, il driver esiste.

PUNTEGGIO (0-2 per voce)
  [2] semplicita'                 DUE input spazzolati. Non ce n'e' di piu' semplici
  [2] il filtro E' il motore      l'orologio NON e' un filtro sopra un motore:
                                  l'orologio E' l'unico ingresso che esiste
  [2] tesi di mercato scrivibile  si', ed e' sopra in cinque righe
  [2] riempie un BUCO             tre buchi insieme: (a) nessun motore di casa
                                  su indici entra senza guardare un livello o
                                  una media; (b) SHORT simmetrico misurato per
                                  costruzione (regola dei due lati, 25/08);
                                  (c) copre TUTTE le 24 ore, comprese le fasce
                                  12:00-15:00 e 15:30-17:30 server che sulla
                                  flotta DAX/Dow sono VUOTE
  [2] testabile senza riscritture zero righe di codice da scrivere
------------------------------------------------------------------
VERDETTO   🟢 PROVA SUBITO — 10/10
PERCHE'    E' l'UNICO meccanismo su DAX/Dow che il pavimento dei 150 trade
           NON uccide, e questo e' aritmetica, non speranza (vedi sotto).
```

### 📏 IL NUMERO CHE LO PROMUOVE — l'unico che supera il muro del campione

Il pavimento tick BCM sugli indici e' **2024.09.26**, stato `COMPLETO`
[VERIFICATO: `REFERTO_SONDA_STORICO_17-08.md` r.46, che elenca `D30EUR` e
`U30USD` fra i simboli con quella data].

| | |
|---|---:|
| feriali da 2024.09.26 a 2026.06.30 | **459** |
| operazioni della sonda (1/giorno per costruzione) | **~459 per cella** |
| meta' IS / meta' OOS | **~229 / ~229** |
| pavimento richiesto (Emendamento A) | **150 / 150** |
| **margine** | 🟢 **+79 per meta', anche togliendo ~20 festivi di borsa** |

🔴 **Confronto con TUTTO cio' che e' morto di campione su questi simboli negli
ultimi due mesi**, e la differenza non e' di qualita' — e' di **portata**:

| candidato | n misurato | esito |
|---|---:|---|
| R117 RELATIVO NASUSD | IS **87** / OOS **154** | merito SOSPESO, e **A6 non e' raggiungibile prima del 27/11/2026** |
| NY Session Retest (gate slope 75) | **114-115** | merito SOSPESO |
| DaxReEntry | **<= 92** | merito SOSPESO |
| M31 salto statistico su DAX M15 (cella con l'edge) | **~88** su tutto il banco | _"un round a tick non sarebbe nemmeno LEGGIBILE"_ |
| 🟢 **SONDA OROLOGIO indici** | **~229 / ~229** | **leggibile** |

**Non e' un dettaglio contabile: e' il motivo per cui gli ultimi quattro round
su questi simboli non hanno potuto dare un verdetto di merito.** L'orologio
entra **ogni giorno, per costruzione** — e' l'unica cosa che compra campione.

### 🧊 IL CANCELLO ZERO, congelato PRIMA di qualunque numero

Ricalcato su C1 dei criteri FX, con la costante di casa:

> **|lordo medio per giornata| >= 3 x spread mediano DELLA STESSA ORA**, su
> almeno UNA fascia, su **ENTRAMBI** i simboli (lettura SEVERA, come firmato il
> 31/08 — la lettura larga esce etichettata e non decide).

Con lo spread D30EUR misurato **1,65 punti indice**
(`SPREAD_FLOTTA_MISURA_2026-09-03.md`), il cancello chiede **>= 4,95 punti
indice di lordo medio per giornata** sulla fascia. **E' un numero, non
un'opinione: o esce dalla tabella o non esce.**

### 🏛️ IN OTTICA PROP — la riga che va scritta anche quando e' sfavorevole

- 🟢 **Il DD giornaliero e' strutturalmente contenuto**: una posizione al
  giorno, un solo simbolo per cella, uscita a orario, flat forzato di fine
  giornata. **Zero overnight per costruzione** = zero rischio di gap.
- 🟢 **La scorrelazione e' quasi garantita dal disegno**: se la fascia buona
  cade fuori da **08:00-12:00** (DAX Apertura) e da **14:30-19:30** (Dow
  Apertura / ORB), il motore **non condivide nemmeno un'ora** con le sedie vive.
  Il DD della prop e' uno solo: questa e' la proprieta' che conta.
- 🔴 **E il rovescio, dichiarato:** se la fascia buona cadesse **dentro**
  08:00-12:00 sul DAX, il candidato **perde quasi tutto il suo valore prop**
  anche con numeri belli — sarebbe un secondo EA sullo stesso segnale orario
  della sedia viva 770101, cioe' la cosa che `ROTTA_PROP.md` vieta per prima.
  **Va guardata la colonna dell'ORA prima della colonna del profitto.**
- ⚠️ **La peggior giornata esce in colonna comunque** (criterio C4), anche se
  il merito non passa: un DD e' un fatto accaduto e non si sospende mai.
- ⚠️ **Un solo regime.** 2024.09.26 → 2026.06.30 e' **toro pieno**. Su un
  motore direzionale a orario fisso questo e' il rischio piu' serio: una fascia
  LONG puo' uscire verde solo perche' l'indice e' salito. 🔬 **Ed e' proprio per
  questo che i DUE LATI vanno misurati insieme**: se long e short sono
  simmetrici e opposti sulla stessa ora, e' deriva; se una fascia e' verde e la
  sua immagine speculare non e' rossa della stessa quantita', c'e' un fatto.
  **La lettura della deriva e' scritta qui, prima dei numeri.**

### 🪦 I DUE PARENTI PIU' VICINI NEL CIMITERO — cercati apposta, e sono DIVERSI

Prima di proporlo ho passato la lista dei caduti (`REGISTRO_TEST.md`), come
prescrive la Regola della Seconda Caccia:

| caduto | perche' NON e' questo |
|---|---|
| **R98 — Market Intraday Momentum (Gao, `ABTG_IntradayMomentum`)** | Gao entra **condizionato al rendimento della prima mezz'ora**: e' una regola di prezzo. L'orologio **non guarda nessun prezzo**. E R98 e' morto _"per attrito overnight che sui CFD non esiste"_ — un attrito che la sonda non usa |
| **D7 — "l'ora del fix" (Michelberger & Witte 2015)** | D7 ha chiuso il **minuto del fix**: _"volatilita' si', DIREZIONE no"_. La sonda misura la **deriva media di un BLOCCO di ore**, non la volatilita' di un minuto. 🔴 **Ma va detto adesso, non dopo: se la tabella esce PIATTA, D7 esce CONFERMATO ED ESTESO agli indici e la pista dell'orologio si chiude per sempre. Anche quello e' un risultato, e lo firmo prima.** |
| M25 lead-lag S&P→DAX | e' un **segnale** da un altro simbolo. L'orologio non legge nessun altro simbolo |

### 📌 Il precedente di casa che rende ragionevole spenderci una corsa

Non e' un'idea nuda: sul forex la stessa tesi ha gia' prodotto **il miglior C1
misurato del progetto** — `OROLOGIO_VS_BREEDON_2026-09-03.md`, EURUSD **SHORT
08:00-16:00 server**, C1 **4,59** su IS 2011-2017 (n=1.607) e **5,31** su OOS
2017-2026 (n=2.411), con la **cella indicata PRIMA dei numeri**.
⚠️ **E il limite di quel precedente, dichiarato: era FOREX.** Che la stessa
forma valga su un indice **e' esattamente cio' che questa corsa deve scoprire**,
non cio' che assume.

### 📄 GLI ARTEFATTI CONSEGNATI (scritti oggi, nessuno lanciato)

| file | cosa e' |
|---|---|
| `backtest_pipeline/prove/SONDA_OROLOGIO_INDICI.txt` | **la specifica**: ipotesi, criteri **I1-I8 congelati**, finestra misurata. **NON si lancia** |
| `backtest_pipeline/prove/SONDA_OROLOGIO_11_D30EUR_LONG.txt` | cella eseguibile, magic **777211** |
| `backtest_pipeline/prove/SONDA_OROLOGIO_12_D30EUR_SHORT.txt` | cella eseguibile, magic **777212** |
| `backtest_pipeline/prove/SONDA_OROLOGIO_13_U30USD_LONG.txt` | cella eseguibile, magic **777213** |
| `backtest_pipeline/prove/SONDA_OROLOGIO_14_U30USD_SHORT.txt` | cella eseguibile, magic **777214** |

**Magic 777211-777214: VERGINI**, cercati uno per uno in tutto il repo il
06/09/2026 → **zero occorrenze** (`777207` e' l'ultimo libero della serie bassa;
i 777200-777206 sono gia' impegnati dalle sette celle FX).

⚠️ **Cose che NON ho fatto e che non vanno saltate prima di lanciare:**
l'EA **non e' mai stato compilato da nessuno** (lo dice il file prova FX del
28/08 e l'ho riverificato: **zero referti in `risultati_archivio/`**). Se
MetaEditor si lamenta, **quello e' il risultato del Passo 0** e va riportato
com'e'. E la riga di lancio va passata da
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` — **classe 129 compresa: un
solo agente MT5 vivo**, altrimenti le celle gemelle divergono.

---

## 6. COSA NON HO POTUTO VEDERE — i buchi, dichiarati

1. 🔴 **GitHub: NON BATTUTO.** UI **429 `Retry-After: 3600`**, `api.github.com`
   **403**, **`gh` CLI non installato** in questo ambiente. **Un 429 non e' un
   404**: il pool GitHub di oggi non e' stato guardato, e questa e' la **terza
   caccia di fila** (02/09, 05/09, 06/09) in cui succede. ➡️ **E' la fonte che
   di solito da' il SORGENTE: e' il buco piu' costoso di questo dossier.**
2. 🔴 **Forex Factory 403** — i thread storici (l'unico posto dove si legge
   *come una strategia e' invecchiata*) restano inaccessibili.
3. 🔴 **SSRN 403** — ennesima di fila.
4. 🔴 **Deutsche Boerse e Xetra EGRESS_BLOCKED** → **gli orari delle aste del
   DAX non sono verificati alla fonte primaria** (§4). ➡️ **Servono due minuti
   del browser di Claudio**, ed e' un buco che gli agenti non possono chiudere.
5. 🔴 **ZERO sorgenti esterni letti** (§2), ed e' la debolezza principale.
6. ⚠️ **MQL5 Code Base: autori e date non leggibili dalla lista** (JS): li ho
   presi dalle **schede** dei due EA aperti, non dall'elenco.
7. ⚠️ **Il Pine di `Xetra Auctions Breakout` non e' stato letto**: dichiarato
   open-source sulla pagina, ma la fetch non lo rende. Il §4 **non e' stato
   applicato** a quello script, e per questo e' scartato **anche** per
   inapplicabilita' del setaccio, non solo per geometria.

---

## 7. LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Esiste, su D30EUR e su U30USD, almeno UNA fascia oraria in cui la deriva
> media per giornata vale almeno TRE VOLTE lo spread misurato IN QUELL'ORA —
> e quella fascia sta FUORI dalle ore gia' occupate dalle sedie vive?"**

Le due meta' della domanda contano allo stesso modo:
- se la risposta alla prima meta' e' **no**, la pista dell'orologio si chiude
  sugli indici **con un numero nostro** — e la lapide D7 si estende;
- se la risposta alla prima e' **si'** ma la fascia cade **dentro** 08:00-12:00
  (DAX) o 14:30-19:30 (Dow), **il candidato vale molto meno per la prop** anche
  con dei bei numeri, perche' sarebbe un secondo EA sullo stesso orario di una
  sedia viva.

---

## 8. RIEPILOGO IN UNA TABELLA

| | |
|---|---:|
| interrogazioni | **18** |
| titoli visti | **~149** |
| pagine/abstract esterni aperti | **6** |
| sorgenti ESTERNI letti | **0** 🔴 |
| sorgenti DI CASA letti verbatim | **7** |
| candidati esterni **promossi** | **0** |
| candidati esterni **scartati** | **~30 nominati, uno per uno, col motivo** |
| fonti dichiarate NULLE o bloccate | **5 su 8** |
| proposte consegnate | **1** (di casa, mai accesa) |
| file prova nuovi | **5** |
| EA toccati | **0** |
| parametri di forward toccati | **0** |
| backtest lanciati | **0** |
