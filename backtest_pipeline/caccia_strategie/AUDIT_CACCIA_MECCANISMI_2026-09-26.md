# AUDIT DELLA CACCIA — `CACCIA_MECCANISMI_SEI_FAMIGLIE_2026-09-26.md` (commit `80251fd6`)

_Controllo caccia · 27/09/2026 · SOLA LETTURA: nessun EA, preset, file prova, round o terminale
toccato; nessun candidato nuovo. Ogni fonte e' stata **riaperta da qui** (curl col proxy della
sessione + WebFetch + WebSearch), in una cartella di lavoro separata da quella del cacciatore; le
copie del cacciatore sono state usate **solo** per confrontare cio' che la pagina diceva il 26/09
con cio' che dice oggi._

Metro: il mandato `.claude/agents/cacciatore-strategie.md` (§1 allucinazioni, §2 controllo
positivo, §3 fonti, §4 setaccio, §8 consegna).

---

## 0. LA RIGA CHE CONTA

> **Verdetto: il dossier e' AUTENTICO — zero allucinazioni su ~45 affermazioni verificabili
> riaperte, e zero bandiere rosse del §4 perse sul promosso che porta codice esterno (P2, Gold
> Breakout 77691). Ma non regge su tre punti che toccano i promossi (la finestra d'ingresso di P1,
> il "ritest" della fonte di P4, la soglia di costo della sonda), su una fonte del mandato mai
> nominata (QuantConnect), e la sonda Oanda non e' nel repo.**
>
> **Fiducia complessiva: 7/10 — ci si puo' fidare delle FONTI, non dei PIN.** Non serve
> rimandare il cacciatore a caccia; servono le correzioni del §5 prima di qualunque file prova.

Campione: **tutti e 4 i promossi** (sorgente/pagina riaperti, setaccio rifatto da zero) e
**20 dei 23 scartati** (sopra il terzo richiesto: gli scartati erano quasi tutti a costo di un
curl). Le 6 affermazioni di casa richieste, rilette alla fonte. La sonda Oanda **rifatta con codice
mio**, sugli stessi dati riscaricati.

---

## 1. TABELLA PER FONTE

| fonte (mandato §3) | cosa dice il dossier | cosa trovo io, riaprendo | fiducia |
|---|---|---|---|
| **MQL5 Code Base** | girata: 3 pagine, 119 titoli, 2 sorgenti letti, 3 schede | **CONFERMATA.** Elenco 200 (oggi 40+40+40 ID, drift normale); 77691, 77639, 77595, 77470, 77653, 77535, 77220, 77060 tutti 200 con titolo/autore/data giusti. Sorgente 77691 riscaricato: **identico byte per byte** alla copia del cacciatore | **9/10** |
| **MQL5 Articoli** | 1 articolo (17239) | **CONFERMATA con due imprecisioni** (§3, P1) | **7/10** |
| **TradingView** | girata: 47 interrogazioni, 16 sorgenti | **CONFERMATA** sull'autenticita': 3 sorgenti dei promossi + 10 scartati riscaricati da `pine-facade`, tutti `open_no_auth`, nomi/date/like giusti. **Una lettura sbagliata sul sorgente di P4** e 3 dettagli numerici sbagliati (§3) | **7/10** |
| **arXiv** | girata; API 406 | **CONFERMATA.** 4 abstract riaperti (2605.11423, 2607.01550, 2507.04481, 2510.01542) + controllo positivo 2605.04004 (in casa: `report/CACCIA_TF_BASSO_2026-09-12.md` e altri 2). API: `http` -> 301, `https` -> **406** anche con `Accept: application/atom+xml` | **9/10** |
| **raw.githubusercontent** | 200, 6.941 byte | **CONFERMATA**: 200, **6.941 byte** esatti | **10/10** |
| **GitHub** API/ricerca | 403 / 403 | **CONFERMATA** (403 e 403). Nota: il 403 dell'API e' del **proxy della sessione** (_"sessions are bound to their configured repositories"_), non di GitHub. Un canale MCP GitHub, se disponibile al cacciatore, **non risulta tentato** `[INCERTO]` | 8/10 |
| **SSRN** | 403 "Content Blocked" | **CONFERMATA**: curl 403 con "Content Blocked" (2 occorrenze), WebFetch 403 | 10/10 |
| **Forex Factory** | 403 | **CONFERMATA**: curl 403, WebFetch 403 | 10/10 |
| **Quantpedia** | screener 200; articolo GDX 504 -> 466; "non adesso" | **IMPRECISA.** Screener 200 (613.102 byte, identico). Ma la copia del "466" salvata dal cacciatore e' una pagina **WAF "Access Denied... blocked by our web application firewall"**: e' un **blocco**, non un "non adesso". E **oggi** due articoli del blog Quantpedia rispondono **200** da qui (`building-and-testing-trend-following-strategies-on-one-minute-spy-data`, `can-weakening-morning-order-flow-predict-spy-reversals`) -> la fonte **e' raggiungibile e va rigirata** | 6/10 |
| **QuantConnect** | **NON NOMINATA** | 🔴 **BUCO NON DICHIARATO.** Il mandato §3F la elenca accanto a Quantpedia; il dossier non la cita in nessuna sezione (ne' girata, ne' vuota, ne' irraggiungibile). Da qui `quantconnect.com/research/` risponde **200** (272 KB) | — |
| **Siti murati** (NY Fed, Liberty Street, fedinprint, CBS, gold.org, substack, mdpi, quantifiedstrategies) | EGRESS_BLOCKED / 000 | **CONFERMATA**: curl 000 su tutti (CONNECT 403 dal proxy), WebFetch `EGRESS_BLOCKED` su Liberty Street. Anche ideas.repec/econpapers murati: nessuna via laterale | 10/10 |
| **[LETTO-VIA-SEARCH]** | Liberty Street 07/2026, WGC, substack, NY Fed SR 917 | **CONFERMATE tutte e quattro** dalle mie ricerche: _"The Disappearing Overnight Drift"_ (01/07/2026, Boyarchenko-Larsen-Whelan: finestra 02-03 ET, ~3,7%/anno, "close to zero since 2021"); WGC Mid-Year Outlook 2026 (pullback in ore USA, rimbalzi in ore asiatiche); _"Intraday Short Setup in ES Futures"_ di Dave Johnson (backtest.substack.com, 12/02/2026); SR 917 = _The Overnight Drift_ | 8/10 |
| **Affermazioni di casa** | R42, R95, R242a, R197A, CSV EURUSD, censimento | **CONFERMATE** (§4) con due citazioni selettive | 9/10 |
| **Sonda Oanda** | §4.1 | **RIPRODUCIBILE ed ESATTA sui numeri, SBAGLIATA sulla soglia, e fuori dal repo** (§4.1) | **6/10** |

---

## 2. I PROMOSSI — SETACCIO RIFATTO DA ZERO

### P2 · Gold Breakout EA (Code Base 77691) — **CONFERMATO** (setaccio pulito), 2 dettagli imprecisi

- **Pagina** (`/en/code/77691`, 200): titolo _"Gold Breakout EA for XAUUSD H4 +90 Percent in a 2020
  to 2026 Backtest"_, pubblicato **24 September 2026, 23:28**, autore pagina **Ali Akbar**
  (utente `RanaAli878`), sorgente `#property copyright "Ali Rajput"`. Tutto come nel dossier.
- **Popolarita'**: il dossier dice 84 download / 402 visite / 1 voto. Oggi la pagina dice **131 /
  548 / (2)**; la copia salvata dal cacciatore il 26/09 alle 08:14 UTC dice **84 / 402 / (1)**.
  -> **numeri veri al momento della lettura**, cresciuti da allora. Non e' un'allucinazione.
- **Numeri dichiarati**, tutti letti in pagina: 198 operazioni tutte buy · PF **1.77** · win
  **46.97%** · DD equity **11.38%** · 9 perdite di fila **-889.86 (~8.2%)** metà 2021 · tenuta
  "about 71 hours" · anni +5,1 / -2,9 / +4,6 / +4,8 / +24,0 / +27,1 / +7,9% · con gli short 310
  op. PF **1.28**, short **-2,080.39** · _"Most of the money came from 2024 and 2025"_ · EURUSD H1
  **PF 1.03** su 164 op. · le tre uscite provate anno per anno **senza** filtro di trend, poi la
  EMA200 aggiunta sulla C. **Tutti confermati parola per parola.**
- **Sorgente** (riscaricato, **428 righe**, ASCII): logica esattamente come scritta —
  `CheckBreakout` canale su `h[2..21]`, `c[1] > up && c[2] <= upPrev`, EMA a shift 1; stop
  `2 x ATR(20)` dal riempimento con `minGap`; TP `2R` in `EXIT_FIXED`; ordine a mercato **senza
  SL** poi `PositionModify`, chiusura se l'aggancio fallisce; rischio % del **balance** via
  `OrderCalcProfit`; una posizione; nessun ingresso negli ultimi 15' di sessione; venerdi' opzionale.
- **Setaccio §4 rifatto**: martingala NO · griglia NO · stop vero SI (finestra nuda di un
  round-trip, dichiarata) · recovery/hedge NO · lotto fisso NO · repaint/look-ahead NO (tutto a
  shift 1) · `iCustom` NO · `#import`/`WebRequest` NO (grep a zero). **Il cacciatore non ha perso
  nulla.**
- 🟠 **Impreciso 1**: "16 input" — sono **17** (20 righe `input` meno 3 `input group`).
- 🟠 **Impreciso 2**: _"cancello spread = 10% dello stop: e' la nostra regola R55"_. Il
  **meccanismo** e' quello di R55 (spread in % dello stop), la **soglia no**: 10% = **10x**, la
  casa usa 2,5% = **40x** (`report/EA_LVN_ARBITRO_2026-09-08.md` r.82/133). Innocuo sull'H4
  dell'oro, dove 2 ATR H4 valgono ~100-300x uno spread di 0,24 $ `[STIMA]`, ma nel porting va
  scritto 0,025, non "gia' fatto dall'autore".
- ⚪ Nota di porting non scritta: le barre **H4** di MetaQuotes-Demo (UTC+2/+3) e del BCM (UTC+1)
  sono **tagliate a orari diversi** -> i segnali del canale non coincidono; i numeri dell'autore
  non sono nemmeno un prior sul nostro feed. Non e' un difetto del dossier, e' un'avvertenza.

### P1 · Box asiatico intero forex su `ABTG_MaxMinNotte` — fonti **CONFERMATE**, mappa **INCOMPLETA**

- **AutoBot** (`PUB;ffcf1f59...`, 200): `bhanubisen1`, **369** like, creato **19/04/2026**,
  **108** righe, box `0000-0800` UTC, ingresso `ta.crossover(close, a_high)`, stop `a_low`, TP
  `a_high + 2 x box`, `close_all` a fine USA, `strategy.fixed, 1`. **Tutto confermato.** (Il nome
  pubblicato e' "Asian Breakout AutoBot (NASDAQ, S&P 500, Gold)"; il dossier cita quello del
  sorgente: legittimo.)
- **Articolo 17239** (200): Allan Munene Mutiiria, **25/02/2025**, box `23:00-03:00` GMT, TP
  `RiskToReward = 1.3`, uscita alle 13:00 GMT, `LotSize = 0.1`, backtest "for 1 year, 2023"
  solo in immagine. Confermato. **Ma due affermazioni non reggono:**
  - 🟠 _"pendenti a ±10 pip"_: il codice fa `offsetPrice = BreakoutOffsetPips * _Point` -> su un
    5 cifre sono **10 punti = 1 pip**. Il dossier ha preso per buona l'etichetta della variabile.
  - 🟠 _"le due fonti concordano riga per riga"_: **no**. L'articolo piazza **UN SOLO** pendente,
    buy stop **o** sell stop scelto dalla SMA50 (`if(bullish)... else if(bearish)`); AutoBot
    prende i due lati a chiusura, box di 8 ore, finestra fino alle 20:00 UTC. Concordano sul box e
    sullo stop all'estremo opposto, non "riga per riga". Il dossier non porta la SMA50 (giusto), ma
    la frase sopravvaluta la convergenza delle fonti.
- **Casa**: i due CSV `ABTG_MaxMinNotte_EURUSD_{IS,OOS}_ohlc.csv` dicono davvero
  `InpBufferPoints=1000`, `InpSLMode=1`, **Trades 1** (IS, per magic) e **0** (OOS). GBPUSD:
  nessun CSV, nessun file prova, nessun `.ini` (`100GBP` e' il FTSE). **Confermato.**
- 🔴 **Mappa incompleta — il pin che manca cambia la misura**: il dossier propone piazzamento
  07:00 e **cutoff 10:00** con "gestione di default". Ma `ABTG_MaxMinNotte.mq5` r.339 fa
  `exp = TimeCurrent() + InpPendingExpiryMin*60` con default **90** (r.137): i pendenti muoiono
  alle **08:30** e il cutoff delle 10:00 (r.258) e' **inerte**. La cella misurerebbe 90' dicendo di
  misurarne 180'. [VERIFICATO sul sorgente]. _(Osservazione in sola lettura: il file prova
  `prove/R266a_asia_box_GBPUSD_TESTA.txt`, **non tracciato**, di un altro agente, ha gia' corretto
  con `InpPendingExpiryMin=180`.)_
- 🟠 "`MaxMinNotte`: ~45 input" — sono **53** (62 righe `input` meno 9 gruppi). Dettaglio.

### P3 · Direzione dell'oro come cancello sul long di `770402` — fonte **CONFERMATA**, 1 errore d'orario, 1 rischio di mappa

- **Fonte** (`PUB;8ee9baaf...`, 200): `bradenstrock`, **39** like, creato **01/03/2026**, box
  `1900-0000` NY, finestra `0000-0500` NY, `close > asiaHigh + buffer` **e** `close > ema(200)`,
  stop 1,2 ATR / TP 1,8 ATR, max 2/giorno, chiusura a fine finestra, **`calc_on_every_tick=true`**.
  Confermato (righe: 128, il dossier dice 127 — irrilevante). La citazione dell'autore di P2 (_"The
  200 EMA filter softens that bet..."_) e' **letterale**.
- 🟠 **Orario sbagliato**: _"box 1900-0000 New York (≈ il nostro 23:00-04:59 BCM d'estate)"_.
  19:00 EDT = 23:00 **UTC** = **00:00 BCM** (UTC+1). Il box NY e' **00:00-04:59 BCM**: il dossier
  ha scritto l'ora UTC chiamandola BCM. Impatto nullo (si porta solo la regola di direzione), ma
  e' la classe d'errore che la casa paga di piu'.
- **Mappa sul nostro codice**: `CorrBias()` e' davvero a r.698-709, `CopyBuffer(...,1,1,...)` a
  shift 1 (r.705-706), e una EMA a periodo 1 **e'** la chiusura (alfa = 2/(1+1) = 1). Confermato.
- 🟠 **Rischio non scritto** `[INFERITO dal sorgente]`: `CorrBias()` crea l'handle `iMA`, legge e
  lo **rilascia a ogni chiamata**; se il `CopyBuffer` su un handle appena creato fallisce, `dir`
  resta 0 e la funzione **restituisce 0 = "entrambi i lati"**: il cancello si **apre in silenzio**.
  In casa e' gia' successo per un'altra via sulla stessa funzione: `770411` girava con il cancello
  S&P spento perche' il nome del simbolo non esisteva (`report/SEDIA_770411_IL_RIENTRO_2026-09-20.md`
  r.387). Il dossier chiede di verificare "che iMA(1) dia la chiusura"; va verificato **anche**
  quante giornate il bias vale 0 — altrimenti "P3 = R260a" potrebbe voler dire "cancello mai acceso".
- 🟠 Precedente citato _"sul 770411 il cancello S&P ha raddoppiato il PF (1,19 -> 2,0)"_: alla fonte
  e' **1,181 -> 2,053**, con **n da 98 a 41** (stesso report r.67). Il dossier omette che il
  precedente vive su 41 operazioni.

### P4 · Asse pendente / chiusura / ritest — fonte **LETTA MALE**

- **Fonte** (`PUB;31855484...`, 200): creato **13/08/2025**, Pine **v6**, **87** righe, **5**
  input, `percent_of_equity, 1`, RR 3, stop = minimo della barra - buffer. Confermato. 🟠 Autore:
  il dossier scrive `samuelmathieu050`, l'utente vero e' **`samuelmathieu0508`**; il titolo
  pubblicato e' "Breakout asia USD/CHF".
- 🔴 **Il "ritest" della fonte, nella maggior parte dei casi, NON E' UN RITEST.** Nella stessa
  esecuzione della barra, il passo 1 fa `breakoutUp := true` su `ta.crossover(close, rangeHigh)` e
  il passo 2 valuta subito `longRetest = breakoutUp and low <= rangeHigh and close > rangeHigh`. Sulla
  barra che incrocia verso l'alto, `close > rangeHigh` e' vero per definizione e `low <= rangeHigh`
  e' vero ogni volta che la barra non apre in gap sopra il livello (la chiusura precedente era
  `<= rangeHigh`). **Quindi l'ingresso scatta sulla barra di rottura stessa**: e' un breakout a
  chiusura con lo stop al minimo della barra. [VERIFICATO sul sorgente, r. "Etape 1/Etape 2"]. In
  piu', in Pine v6 gli `and` sono pigri e `ta.crossover` dentro la condizione non viene chiamato
  su ogni barra (storia della funzione non aggiornata) `[INFERITO dalla semantica v6]`.
  -> Il dossier descrive "passo 1 / passo 2 = ritest" come **[VERIFICATO]**: la fonte **non porta
  evidenza di ritest**. P4 si regge **solo** su `R197A` di casa (che e' vero, §4) e sul modulo
  gia' scritto in `ABTG_Dow_Apertura_US`. Non e' una bandiera del §4, ma e' esattamente il tipo di
  difetto di logica che il cacciatore ha trovato sugli scartati (`lonHigh` di RamonBosch) e ha
  mancato su un promosso.

---

## 3. GLI SCARTATI — 20 SU 23 RIAPERTI

| scartato | esito | nota |
|---|---|---|
| 77639 SMC Gold | **confermato** | 23/09/2026 20:36, 518 righe, `InpMinSLToSpread = 3.0`, PF 1.12 / 1.10 in pagina |
| 77595 EA Trend Follower | **confermato** | Syamsurizal Dimjati, 22/09, PSAR, "base trading architecture for research", "not presented as a fully optimized" |
| 77470 RiskGuard Lite | **impreciso** | la citazione tra virgolette _"clean template... No profit claim"_ non e' letterale: la pagina dice _"educational template... there is no claim of profitability"_. Sostanza giusta |
| 77653 EMA Cross Demo | **confermato** | 24/09, curva "from a synthetic price series" |
| TV `TJR asia session sweep` | **confermato** | `antonioreale94`, 75 like, **590** righe (pubblicato come "Cs Fenix Us30"; il nome e' quello del sorgente) |
| TV `US30 AsianRange ... LIMIT OCO` | **confermato** | limiti al `fibLevel 1.15`, SL 30 "pips" |
| TV `US30 Stealth` | **confermato** | LigerzWays, 90 like, `maxCandleSize = 30` |
| TV `Ellis US30 Combo` | **confermato** | 27 input |
| TV `US30 ORB 5m / 1m` | **confermato** | MPL 2.0, `takeProfitPts = 10` |
| TV `Prop-Firm London Breakout` | **confermato** | il bug `lonHigh` include la barra corrente: dentro la finestra `high > lonHigh + atr` non puo' scattare. Lettura esatta |
| TV `London Breakout` (Cookedaburra) | **impreciso** | 2018 e `pyramiding = 6` e `stop=200` giusti; ma e' **Pine v3** (non v2) e `default_qty_value = 30000` (non 300) |
| TV Kevin Davey BB (EdgeTools) | **confermato** | 125 like, MPL 2.0, nessuno stop, `calc_on_every_tick=true`, solo long |
| TV Konigs BB | **confermato** | esce sulla media, nessuno stop |
| arXiv 2605.11423 (Mesfin) | **confermato** | _"Eight directional configurations were tested. None passed."_ letterale, T 1,46. Il dossier dichiara che e' MNQ e solo sui giorni del classificatore (40 giorni): citazione corretta, trasferibilita' al Dow debole e detta |
| arXiv 2607.01550 (Kurth-Eisler-Rej-Bouchaud) | **confermato** | 02/07/2026, ~100 futures 1995-2025, crollo post-2008 sui tick piccoli |
| arXiv 2507.04481 | **impreciso** | gli autori sono **quattro**: manca Mamaysky |
| arXiv 2510.01542 (Han) | **confermato** | "Renaissance Technologies' Medallion Fund" in abstract |
| NY Fed SR 917 | **confermato** (via ricerca) | Boyarchenko-Larsen-Whelan, _The Overnight Drift_ |
| WGC Mid-Year Outlook 2026 | **confermato** (via ricerca) | frase su ore USA/asiatiche presente nei riassunti |
| GitHub `nsclk` | **impreciso** | il repo si chiama **`Asian-Range-Breakout-Expert-Advisor-for-MT5`** (come nella caccia del 12/09), non `...-EA-for-MT5`: col nome del dossier il README da' **404**, col nome giusto **200** |

Non riaperti: `Follow the Trend / Trend Pullback System` (rimando a una caccia del 01/09), e le
due righe "usati come SPECIFICHE", gia' coperte al §2.

---

## 4. LE AFFERMAZIONI DI CASA

| affermazione | alla fonte | esito |
|---|---|---|
| R42 fade 0/24 + 0/24 | `REGISTRO_TEST.md` r.1993 | confermato |
| R95 0/30 | registro r.1197/1250 (PF 0,65-0,80) | confermato |
| R242a long 7 celle PF 0,732-0,941 | `report/REFERTO_R242_2026-09-24.md` r.40-48 | confermato |
| R197A retest IS 1,21214 / OOS 1,25384 vs breakout IS 0,96503 | `report/IL_REGISTRO_RIMESSO_A_POSTO_2026-09-23.md` r.105-106 | **confermato ma selettivo**: il breakout in OOS fa **1,18772** (n 162), e il dossier non lo scrive. Il vantaggio fuori campione del retest e' **+0,07**, non lo scarto dell'IS. E la cella `EntryMode=1` a 2 operazioni e' davvero degenere (r.262) |
| EURUSD MaxMinNotte 1 IS / 0 OOS, buffer 1000 | i due CSV | confermato (§2 P1) |
| censimento r.3843-3850 (D30EUR 24, XAUUSD 14, EURUSD 2, GBPUSD 0) | registro r.3843-3850 | confermato; GBPUSD non e' nella tabella (lo 0 e' per assenza) e non esiste in nessun CSV/prova |
| 770402 PF 1,308 · n 693 · DD 5,32% | registro r.4230 | confermato |
| BreakinBox DAX PF 1,007 DD 24,1% vs RR 1,106 | registro r.1349/2913 | confermato |
| L3 9.723 · L2 22.616 · MeanRevert R60 12/12 · ISM 0,85/0,73 · R54a OOS 0,840 su 73 · DAX long 0/33 max 0,947 | registro r.1210-1213; `report/CACCIA_SUPREV_ALTERNATIVE_2026-09-12.md` r.89; `report/CORSIA_DEMO_CANDIDATI.md` r.257; `report/SEDIA_SHORT_DOW_FTMO_2026-09-26.md` r.429; `report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md` r.13 | confermati |

### 4.1 LA SONDA OANDA — riproducibile, esatta sui numeri, sbagliata sulla soglia

- **Da dove vengono i dati**: `FutureSharks/financial-data` (GitHub), licenza **GPL-3.0**
  (LICENSE riscaricato, 200). Riscaricato `GBP_USD 2018-07`: **identico** alla copia del cacciatore.
- 🔴 **Dove stanno**: dati (`oanda/`, ~340 MB) e script (`box_asia.py`) sono **solo nello
  scratchpad della sessione**, non nel repo. Il dossier non lo dice. Chi apre il repo **non puo'
  rifare il conto**; io l'ho rifatto perche' condivido lo scratchpad.
- **I numeri**: con codice mio, stesso box 23:00-05:59 UTC e stesso filtro, le **8 righe della
  tabella tornano identiche** (mediane, P25, P75, quote). Confermato.
- **L'orologio**: il dossier prova "UTC" col profilo orario (il salto alle 06-07). Riprodotto
  esatto (8,4-11,4 pip 00-05, 19,6 alle 06, 25,8 alle 07, 28,2 alle 14). Ma il contro-esempio e'
  **debole**: prova UTC contro "non-UTC, il box contiene Londra", non contro l'alternativa vicina
  (orologio spostato di un'ora), che sul profilo annuo mescolato d'estate/inverno non si separa
  bene. Il test che la separa l'ho fatto io: **prima barra della domenica 22:00 d'inverno / 21:00
  d'estate** (= 17:00 New York) e **picco NFP alle 12 UTC d'estate / 13 d'inverno**, su GBPUSD 2018
  ed EURUSD 2019. **I dati sono UTC: la conclusione regge, il metodo no.**
- 🟠 **Filtro >= 300 barre non dichiarato come distorsione**: i giorni scartati sono quelli con
  meno barre M1, cioe' i piu' quieti (mediana dei giorni scartati **15-22 pip**). Tenendo tutti i
  giorni, GBPUSD 2012 passa da 33% a **27%**, 2019 da 26% a **20%**. Distorsione **a favore** del
  candidato, non scritta.
- 🔴 **La soglia e' sbagliata, e l'errore va nell'altro verso**: il dossier applica **33,2 pip** a
  entrambe le coppie e **all'ampiezza del box W**. Due errori: (1) il costo di EURUSD non e' quello
  di GBPUSD (commissione 0,004% del nozionale in EUR ~ 0,46 pip, non 0,53; spread 0,2 non 0,3);
  (2) con `InpSLMode=0` lo stop e' **W + 2 x buffer** (r.336-337, r.377), non W. Coi pedaggi
  riportati nel file prova R266 in scrittura (non tracciato, di un altro agente: letto, non
  verificato da me) il cancello su W diventa **27,7 pip GBPUSD** e **20,6 pip EURUSD**, e le quote
  cambiano molto:

  | W >= soglia corretta (tutti i giorni) | 2012 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020* |
  |---|---:|---:|---:|---:|---:|---:|---:|
  | GBPUSD, W >= 27,7 | 39% | 49% | 78% | 46% | 44% | 31% | 58% |
  | EURUSD, W >= 20,6 | 87% | 85% | 68% | 59% | 65% | 16% | 52% |

  _(*2020: ~95 giorni nel dataset.)_ -> La frase del dossier _"il canale largo non basta da solo:
  passa un giorno su tre su GBPUSD, fra uno su due e uno su venti su EURUSD"_ e il pin
  `InpMinBoxPts = 332` **non reggono**: il cancello e' piu' largo di cosi', e P1 e' **piu'**
  misurabile di quanto il dossier dicesse. Il dossier aveva inoltre in cartella gli anni 2016,
  2017 e 2020 e ne riporta quattro senza dire perche'.

---

## 5. FORMATO E PROPORZIONE

- Sezioni del mandato §8.1: cosa ha sfogliato ✅ · controllo positivo per fonte ✅ (la ricerca web
  generica non ne ha uno, marginale) · promossi con scheda e cancello prop ✅ · scartati con motivo
  ✅ · cosa non ha visto ✅ · domanda del primo test ✅ · attribuzioni e licenze ✅ · numeri
  dell'autore etichettati `[DICHIARATO]` e tenuti fuori dal punteggio ✅ · mappa sugli input ✅
  (con i buchi del §2) · costo ✅ · lapidi coi numeri dei caduti ✅.
- 🟠 **Il file prova del candidato n.1 (§8.2) non c'e'**: il dossier si dichiara "sola lettura".
  Non e' nascosto; se la sessione aveva chiesto sola lettura e' conforme. `controlla_prova.py`
  non e' applicabile.
- 🟠 **Conti interni**: "~420 candidati" contro la somma dei suoi stessi addendi (119 + ~150 + ~200
  + 1 + 6 = ~476); "47 interrogazioni" TV contro 45 distinte elencate. Dettagli.
- 🟠 _"Gli unici motori nuovi dal 23/09 sono 77691 e 77639"_: anche 77653 (24/09, incrocio EMA) e'
  un motore, ed e' fra gli scartati.
- **Proporzione 420 / 22 / 4**: non puzza di raccolta ne' di setaccio saltato. Ma va letta giusta
  (e il dossier la dice): **dal web arriva UN motore** (P2); P1, P3, P4 sono **motori di casa** con
  fonti usate come specifiche. Il contributo del web a questa caccia e' sottile, e il dossier non
  lo gonfia.
- Nota: 77691 era gia' passato per titolo nella caccia DAX short del 25/09
  (`CACCIA_DAX_SHORT_2026-09-25.md` r.168, "oro fuori bersaglio"). Non era uno scarto sul merito,
  quindi non e' un riproposto; il dossier poteva citarlo.

---

## 6. ELENCO DEI VERIFICATI CON ESITO

| # | voce | esito |
|---|---|---|
| P2 | Gold Breakout 77691: pagina, numeri, sorgente, setaccio | **confermato** (2 imprecisi: 16->17 input; "R55" con soglia 10x) |
| P1 | AutoBot | **confermato** |
| P1 | Art. 17239 | **impreciso** (±10 pip = 1 pip; "riga per riga" falso: un solo lato scelto dalla SMA50) |
| P1 | mappa su `MaxMinNotte` | **impreciso — pin mancante** (`InpPendingExpiryMin=90` rende inerte il cutoff 10:00) |
| P1 | sonda Oanda | **numeri confermati · soglia sbagliata · fuori repo** |
| P3 | Braden GC | **confermato** (orario NY->BCM sbagliato di un'ora) |
| P3 | mappa `CorrBias` | **confermata**, con rischio di fail-open non scritto `[INFERITO]` |
| P4 | Samuel "Retest" | **impreciso — logica letta male**: il ritest scatta sulla barra di rottura |
| 20 scartati | §3 | 15 confermati, 5 imprecisi, **0 allucinati** |
| casa | §4 | confermati; R197A e 770411 citati in modo selettivo |

**Allucinazioni trovate: ZERO.** Ogni URL esiste, ogni titolo/autore/data/numero di pagina torna;
dove un numero differisce da oggi, la copia che il cacciatore aveva davanti il 26/09 lo conferma.
**Setaccio §4 mancato su un promosso: ZERO.**

---

## 7. PUNTEGGIO DI FIDUCIA

| strato | voto | perche' |
|---|---:|---|
| autenticita' delle fonti | **9/10** | zero allucinazioni, controlli positivi veri, murati davvero murati |
| setaccio §4 | **9/10** | P2 pulito rifatto da zero; bandiere giuste sugli scartati |
| lettura del codice dei promossi | **6/10** | il ritest di P4 letto male; ±10 pip dell'art. 17239 |
| mappa sui nostri input | **6/10** | scadenza del pendente mancante (P1); fail-open di `CorrBias` non detto (P3); orario NY sbagliato |
| sonda | **6/10** | numeri esatti, soglia sbagliata, filtro distorsivo, non nel repo |
| copertura fonti | **7/10** | QuantConnect mai nominata; Quantpedia oggi raggiungibile |
| **complessivo** | **7/10** | fidarsi delle fonti e delle lapidi; **rifare i pin e la soglia** prima di scrivere qualunque file prova |

---

## 8. COSA RIFAREI IO, SE DOVESSI RIPETERE QUESTA CACCIA

1. **Girerei QuantConnect** (`/research/` risponde 200) e **ririgirerei Quantpedia** (blog 200
   oggi) sulle famiglie **B, C, E** — sono proprio quelle chiuse a "zero promossi", e sono le due
   fonti del mandato che danno la tesi con il paper dietro.
2. **Riscriverei la sonda nel repo** (script + tabella, con la fonte GPL-3.0 dichiarata) con la
   soglia **per simbolo** e **sullo stop** (W + 2 x buffer), **senza** il filtro dei 300 minuti (o
   con i due numeri affiancati), su **tutti** gli anni disponibili, e col test dell'orologio della
   domenica/NFP invece del profilo orario.
3. **Rileggerei il sorgente di P4** e lo declasserei a "nessuna evidenza esterna di ritest": la
   domanda di P4 resta buona, ma la sua unica prova e' `R197A` (con il breakout OOS 1,18772 scritto
   accanto).
4. **Nel file prova di P1** fisserei `InpPendingExpiryMin` = distanza piazzamento-cutoff e
   `InpMinBoxPts` dal pedaggio di ciascun simbolo (il file R266 in scrittura sembra averlo gia'
   fatto: va comunque passato da `controlla_prova.py` e da `controllo-preventivo`).
5. **Per P3** chiederei all'autotest di contare le giornate con `CorrBias() == 0`: se sono tante,
   la cella e' R260a travestita.
6. **Buchi che puo' chiudere solo Claudio col suo browser** (tutti murati da qui, anche per vie
   laterali come ideas.repec): l'articolo Liberty Street del 01/07/2026 (numeri post-2021) e
   l'articolo substack di Dave Johnson per la famiglia C.

---

### Fonti riaperte (campione)
- https://www.mql5.com/en/code/77691 · https://www.mql5.com/en/code/download/77691/GoldBreakoutEA.mq5
- https://www.mql5.com/en/code/77639 · /77595 · /77470 · /77653 · https://www.mql5.com/en/code/mt5/experts (+ /page2, /page3)
- https://www.mql5.com/en/articles/17239
- https://pine-facade.tradingview.com/pine-facade/get/PUB;ffcf1f5967e94ce1a91aabcf9d1284aa/last (e gli altri 12 ID del §2-§3)
- https://arxiv.org/abs/2605.11423 · /2607.01550 · /2507.04481 · /2510.01542 · /2605.04004
- https://raw.githubusercontent.com/FutureSharks/financial-data/master/LICENSE
- [The Disappearing Overnight Drift - Liberty Street Economics](https://libertystreeteconomics.newyorkfed.org/2026/07/the-disappearing-overnight-drift/) (solo via ricerca)
- [Gold Mid-Year Outlook 2026 - World Gold Council](https://www.gold.org/goldhub/research/gold-mid-year-outlook-2026) (solo via ricerca)
- [Intraday Short Setup in ES Futures - Dave Johnson](https://backtest.substack.com/p/intraday-short-setup-in-es-futures) (solo via ricerca)
- [NY Fed Staff Report 917, The Overnight Drift](https://www.newyorkfed.org/medialibrary/media/research/staff_reports/sr917.pdf) (solo via ricerca)
