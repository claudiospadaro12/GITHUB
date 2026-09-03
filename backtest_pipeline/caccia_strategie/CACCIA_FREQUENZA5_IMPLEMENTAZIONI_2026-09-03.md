# 🏹 CACCIA FREQUENZA — **QUINTA BATTUTA · FRONTE B** · IMPLEMENTAZIONI PER MECCANISMO — 03/09/2026

**Mandato (Claudio, 03/09, testuale):** _"MANDIAMO GLI AGENTI PER UNA CACCIA PIU'
APPROFONDITA DEL SOLITO. TIME FRAME BASSI 5 MIN E 15 MIN. ASPETTO IL VERDETTO
APPENA POSSIBILE"_.

**Perimetro assegnato (FRONTE B):** otto MECCANISMI nominati, uno per uno, con
query sul meccanismo e non sul formato. Il fronte A batte la tassonomia.

---

## ⚡ IL RISULTATO IN SEI RIGHE

> **Otto meccanismi battuti. 41 query (29 TradingView + 6 WebSearch + 6 sonde
> di rete), 47 strategie viste, 12 sorgenti Pine letti riga per riga e
> archiviati, 1 paper riletto per intero. ZERO EA PROMOSSI — e per la prima
> volta in cinque battute lo scarto NON e' un'opinione: e' una MISURA.**
>
> 🔓 **La cosa che vale piu' di un candidato: ho trovato dei DATI.**
> `github.com/FutureSharks/financial-data` (GPL-3.0) serve **barre M1 di DAX,
> S&P500, Nikkei, EuroStoxx 2010-2018 e Nasdaq/oro/major 2005-2020** da
> `raw.githubusercontent.com`, che e' verde da cinque dossier. **Il buco
> dichiarato quattro volte di fila — _"da qui nessun agente puo' MISURARE una
> frequenza"_ — e' CHIUSO.** Misurato oggi: 5 anni di DAX M1 scaricati
> (1.055.635 barre), 3 di S&P (815.320), un mese di Nasdaq con volume.
>
> 📏 **E l'ho usato subito.** Ho scritto tre sonde di conteggio e le ho fatte
> girare sui due meccanismi che avevano superato la lettura del sorgente.
> **Risultato: entrambi falsificati, con controllo a ingressi casuali.**
> Su **16 celle e 32.339 segnali**, il delta di tasso di vittoria contro un
> ingresso **a caso con la stessa geometria** sta fra **−3,9 e +3,5 punti**,
> media **−0,70**. Nessuno dei due distingue il proprio ingresso dal caso.
>
> 🩹 **CORREZIONE AL MANDATO, e va detta subito perche' cambia una decisione:**
> il mandato dice _"R95 JPY sweep e' in coda, non morto"_. **E' falso.**
> `R95_REFERTO.md`, 23/08/2026: _"30 passate su 30 in perdita … PF da 0,65 a
> 0,80 … nessuna passata sopra 1,00, da nessuna parte"_, con **21.354 livelli
> creati e 0 buttati** e l'asse della DENSITA' gia' spazzolato da M30 a H4.
> **Lo sweep+reclaim non e' in coda: e' bocciato**, ed e' il motivo per cui
> oggi ho scartato il miglior candidato della battuta.
>
> 🪦 **Tre lapidi nuove, tutte con un numero** (§6): post-news chiuso da un
> paper gia' agli atti che nessuno aveva letto nel punto giusto; sweep di
> micro-pivot chiuso da 22.616 segnali contro il caso; compressione→espansione
> chiusa da 9.723.

---

## 0. ⚖️ I CRITERI — congelati PRIMA di aprire una pagina

Presi dal mandato del 03/09 e dalle quattro battute precedenti, non toccati
dopo aver visto un numero.

| # | criterio | soglia |
|---|---|---|
| **C1** | **TF di lavoro M5 o M15** | dichiarato dall'autore **o** leggibile nel sorgente |
| **C2** | **FREQUENZA ≥ 2,0 segnali/giorno PER LATO** | e si dichiara se e' `[MISURATA]`, `[DERIVATA]` o `[DICHIARATA DALL'AUTORE]` |
| **C3** | **§4 non si ammorbidisce** | griglia / martingala / recovery / hedge / `IgnoreSL` / SL virtuale / repaint / look-ahead → scarto **con la riga che lo prova** |
| **C4** | **MECCANISMO NUOVO** | ogni candidato passa la **lista dei caduti** prima di entrare. Mai "parametri diversi di un motore morto" |
| **C5** | **gratuito, sorgente leggibile** | mai promuovere da una descrizione |
| **C6** | **aritmetica H8** | `p ≥ 1,075/(RR+1)`. **RR < 0,70 = morto senza corsa** |
| **C7** | **due lati** (regola 25/08) | long-only senza ragione dichiarata = punto in meno, scritto |
| **C8** | **costo contro lo SPREAD MISURATO** | `SPREAD_FLOTTA_MISURA_2026-09-03.md`: mediane in sessione **NASUSD 1,6-1,8 · U30USD 1,9-2,0 · D30EUR 1,6-1,7** punti indice. Take lordo mediano ≥ **3×** lo spread dell'ora in cui il motore lavora |

**Piu' i paletti di casa, che il mandato non sospende:** P5 (max 25% dei trade
sotto 60 s) · muro prop DD **10% totale / 5% giornaliero** su 100k · numeri
d'autore letti, etichettati, **mai a punteggio** · F11 (nessun EA vivo,
nessun magic, nessun parametro in forward toccato).

**File esclusi dal mandato e non toccati:** `mql5/Experts/ABTG_SondaRelativo.mq5`,
`prove/RELATIVO_*`, `RIGA_COMPILA_ORB104*`, `CACCIA_FREQUENZA5_TASSONOMIA` (fronte A).

---

## 1. 📕 IL CIMITERO, RILETTO PRIMA DI USCIRE

Letti per intero prima di aprire un browser: le quattro battute
(`CACCIA_FREQUENZA_2026-08-31.md`, `CACCIA_FREQUENZA2_2026-08-31.md`,
`CACCIA_FREQUENZA3_ART_PAPER_2026-09-01.md`, `CACCIA_FREQUENZA3_TV_GH_2026-09-01.md`,
`CACCIA_FREQUENZA4_CB_PAPER_2026-09-02.md`, `CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md`),
`PROMEMORIA_SBLOCCO_FONTI.md` (619 righe), `backtest_pipeline/REGISTRO_TEST.md`
(727 righe), `FLOTTA_ATTIVA.md`, `SPREAD_FLOTTA_MISURA_2026-09-03.md`, e
l'indice dei **61 sorgenti gia' in `biblioteca/sorgenti/`**.

### 1.1 Il cimitero, meccanismo per meccanismo — **e' il motivo per cui oggi non promuovo niente**

| meccanismo del mandato | cosa c'e' GIA' in casa | verdetto agli atti |
|---|---|---|
| **1. momentum intraday prima/ultima mezz'ora (Gao)** | `ABTG_IntradayMomentum` | 🔴 **R98: 0/6 su NASUSD, lordo medio −0,31 punti/trade su 410.** Capitolo Nasdaq chiuso da R97+R98 |
| **2. Initial Balance / TPO / range prima ora** | `ABTG_ORB`, `ABTG_ORB_Fibo`, `ABTG_Londra_ORB`, `ABTG_DaxValueArea` | 🔴 **R45 0/48 · R12 48/48 negative OOS · capitolo breakout M5 CHIUSO il 26.07.26** |
| **3. reversione a VWAP con bande** | `ABTG_VwapRevert` (porting sumbloke077, 25/08), `ABTG_NySessionRetest` | 🟠 VwapRevert **mai girato**; NyRetest: gate slope VALIDATO a tick ma **n=114 < 150** → merito sospeso. Fade Bollinger `ABTG_BandFade` 🔴 **R108/R111 6 finestre su 6 rosse, gradiente H1 > M30 > M15 monotono su 3 simboli** |
| **4. contrazione → espansione (NR7/inside/squeeze)** | ⚪ **NIENTE.** `ABTG_Bulge` e' l'opposto (fade sull'ESPANSIONE delle bande, forex H1) | ⚪ **BUCO VERO** — l'unico degli otto |
| **5. sweep di liquidita' + rientro** | `ABTG_LiquiditySweep`, `ABTG_CRT_TurtleSoup`, `ABTG_BreakinBox` | 🔴 **R95: 0/30 su EURJPY**, densita' gia' spazzolata · **CRT 0/30 a tick sugli indici** · **BreakinBox: tesi falsificata dall'ablazione (31/08)** · R89 non misurabile (14 trade IS) |
| **6. gap intraday e gap-fill** | `ABTG_GapFill`, `ABTG_GapContinuation` | 🟠 R36 / R61 / R62 / R65 / R66 gia' girati. **Tetto strutturale: 1 occasione al giorno** |
| **7. lead-lag cross-asset** | `ABTG_SondaRelativo` (convergenza, IN CANNA — non toccata) | ⚪ direzionale mai misurato |
| **8. regime post-news 15-30 min** | `ABTG_PostNews` (2 sedie VPS: EURUSD M5, EURJPY M5) | ⚪ mai misurato in casa |

📌 **La frase-bussola, alla sesta conferma:**
> _"La frequenza NON la compreremo scendendo di timeframe. Va presa con PIU'
> SIMBOLI a M15-H1."_ (caccia M1, 29/08)
> 👉 **Oggi, per la prima volta, ho potuto CONTARE invece di sperare — e su
> otto meccanismi uno solo passa il pavimento di frequenza.**

---

## 2. 📡 CONTROLLO POSITIVO — misurato OGGI, 03/09, fonte per fonte

**Regola di casa: prima di cercare, si verifica il canale su un bersaglio di
cui si conosce gia' la risposta.**

| canale | bersaglio noto | esito misurato oggi |
|---|---|---|
| **`raw.githubusercontent.com`** | `geraked/metatrader5/master/README.md` | 🟢 **200, 6.941 byte**, prima riga `![cover](cover.jpg)` e titolo corretto |
| **TradingView `pubscripts-suggest-json`** | `?search=vwap` | 🟢 **200, 40.283 byte**, primo risultato *"Volume Profile Free Ultra SLI by RRB"* con `scriptIdPart`, `access`, `agreeCount` |
| **`pine-facade` `/get/`** | l'hash del risultato sopra | 🟢 **200, 146.815 byte**, campo `source` in chiaro (140.603 caratteri), `scriptName` coerente |
| **`WebSearch`** | `geraked metatrader5 github` | 🟢 restituisce il repo vero + 9 file reali dell'albero |
| **`arxiv.org/pdf`** | `2605.04004` | 🟢 **200, 1.130.529 byte**, convertito e letto |
| 🆕 **`raw` su `FutureSharks/financial-data`** | `…/GRXEUR/DAT_ASCII_GRXEUR_M1_2016.csv` | 🟢 **200, 14.639.395 byte, 213.764 barre M1** — §3 |
| **`papers.ssrn.com`** | PDF diretto `Delivery.cfm/5095349.pdf` | 🔴 **403** (5.625 byte di pagina di blocco) — **DODICESIMA di fila**, provata con URL diretto al PDF: non e' un problema di percorso |
| 🆕 **`medium.com`** | articolo FMZQuant sul TTM squeeze | 🔴 **`EGRESS_BLOCKED`** — dominio nuovo, mai provato prima, **da segnare** |
| 🆕 **`concretumgroup.com`** (sito di Zarattini) | pagina "Beat the Market" | 🔴 **000 al CONNECT** |
| 🆕 **`tapescript.io`** | blog intraday momentum | 🔴 **000 al CONNECT** |

**Non riprovati, per mandato esplicito:** MQL5 Code Base, articoli MQL5,
QuantConnect, `geraked` (chiusi); Forex Factory, EarnForex, Quantpedia
premium (murati e gia' misurati su due trasporti).

---

## 3. 🔓 LA SCOPERTA DELLA BATTUTA — **una fonte di DATI che passa dal canale gia' verde**

### 3.1 Il buco che chiude

Quattro dossier di fila portano questa riga:
> _"Da questo ambiente **nessun agente puo' MISURARE una frequenza, una
> distribuzione di take o uno spread**"_ — Yahoo, Stooq e Dukascopy **403 al
> CONNECT**, misurati tre volte.

La diagnosi era giusta sui **feed**. Ma i dati non stanno solo nei feed:
stanno anche **dentro repo GitHub**, e `raw.githubusercontent.com` e' verde
**dal 28/08** (`PROMEMORIA_SBLOCCO_FONTI.md` §B). **Nessuno aveva provato.**

### 3.2 Cosa c'e', misurato oggi

`github.com/FutureSharks/financial-data` — **licenza GPL-3.0 dichiarata nel
repo**, autore FutureSharks.

| famiglia | percorso `raw` (prefisso `…/FutureSharks/financial-data/master/`) | simboli | anni |
|---|---|---|---|
| indici histdata, **volume = 0** | `pyfinancialdata/data/stocks/histdata/<SYM>/DAT_ASCII_<SYM>_M1_<ANNO>.csv` | `SPXUSD` · **`GRXEUR` = DAX 30 in EUR, la STESSA SCALA di D30EUR** · `JPXJPY` · `ETXEUR` | **2010-2018** |
| Oanda, **con volume**, file **mensili** | `pyfinancialdata/data/currencies/oanda/<SYM>/<ANNO>/oanda-<SYM>-<ANNO>-<MESE>.csv` | `NAS100_USD` · `SPX500_USD` · `US2000_USD` · `UK100_GBP` · `FR40_EUR` · `JP225_USD` · `AU200_AUD` · **`XAU_USD`** · `EUR_USD` · `GBP_USD` · `AUD_JPY` · `USD_CAD` · `EUR_JPY` · `WTICO_USD` · … (25 cartelle) | **2005-2020** |

**Verifiche fatte oggi, non ipotizzate:**
- `GRXEUR` 2014·2015·2016·2017·2018 → **200 su 5 su 5**, 209.954 / 211.996 /
  213.764 / 206.648 / 213.273 righe. Prima riga letta:
  `20160104 020000;10494.000000;10494.000000;10482.500000;10486.500000;0`.
- `SPXUSD` 2016·2017·2018 → **200 su 3 su 3** (282.913 / 222.026 / 310.381 righe).
- `NAS100_USD/2018/oanda-NAS100_USD-2018-3.csv` → **200**, intestazione
  `time,close,high,low,open,volume`, 28.578 barre, **volume presente**.
- ⚠️ **Il percorso scritto nel README del repo e' SBAGLIATO**
  (`data/stocks/…` → **404**). Quello giusto ha il prefisso del pacchetto:
  `pyfinancialdata/data/stocks/…`. **404 ≠ assenza**: qui era un percorso.

### 3.3 ⚠️ I LIMITI, scritti prima dei numeri

1. **Non e' BCM.** Altri orari, altri spread, altri gap. Da qui esce una
   **misura di OCCASIONI**, **mai un verdetto**. I verdetti restano a tick
   reali sul nostro broker (F6 non si ammorbidisce).
2. **Fuso EST**, non ora server. Per un CONTEGGIO totale non cambia; per un
   filtro orario va convertito, e va dichiarato.
3. **Volume 0 sugli indici histdata** → la VWAP vera non si calcola: si
   approssima con la media cumulativa di `hlc3`. Gli Oanda il volume ce l'hanno.
4. **OHLC M1, non tick.** Ambiguita' intrabarra risolta **sempre a sfavore**.
5. **Zero costi** dentro le sonde: il costo si confronta a parte con
   `SPREAD_FLOTTA_MISURA_2026-09-03.md`.
6. **Finestra 2005-2020: NON copre il 2024-2026** delle sedie. **Copre pero'
   i regimi che sugli indici a BCM non abbiamo** (21 mesi, un regime solo):
   crollo 2011, laterale 2015-2016, orso 2018. Questo tocca direttamente
   l'emendamento §C ("la PROVA DI REGIME batte la storia contigua").

📦 Strumenti e istruzioni: `biblioteca/sonde_esterne/LEGGIMI.md` + 5 script.

---

## 4. 🔬 COSA HO SFOGLIATO — meccanismo per meccanismo

| # | meccanismo | query fatte | strategie viste | **sorgenti letti riga per riga** |
|---|---|---:|---:|---:|
| 1 | momentum prima/ultima mezz'ora | 2 TV + 1 WebSearch | 0 strategie su TV | 0 (§5.1) |
| 2 | Initial Balance / TPO / estensioni | 5 TV | 5 | 0 — **tutte gia' setacciate** (§5.2) |
| 3 | reversione a banda su VWAP | 4 TV | 21 | **3** |
| 4 | contrazione → espansione | 8 TV + 1 WebSearch | 11 | **5** |
| 5 | sweep di liquidita' + rientro | 3 TV | 6 | **2** |
| 6 | gap intraday / gap-fill | 2 TV | 7 | **2** (+1 scaricato non letto, dichiarato) |
| 7 | lead-lag cross-asset | 3 TV + 1 WebSearch | **0 strategie** | 0 |
| 8 | regime post-news | 2 TV + 1 WebSearch | **0 strategie** | 1 paper riletto per intero |
| | **TOTALE** | **29 TV + 6 WebSearch + 6 sonde di rete** | **47** | **12 Pine + 1 paper** |

### 🔴 La misura che smentisce la chiusura di TradingView del 02/09

Il fronte A del 02/09 ha scritto: _"`pubscripts-suggest-json` e' un motore di
TITOLI, e i titoli sul nostro bersaglio sono finiti — **28 query su 68 rendono
ZERO strategie**"_. **Oggi, con query sul MECCANISMO invece che sul formato:
29 query, 47 strategie viste, 12 sorgenti nuovi.** Le query produttive sono
state `vwap reversion` (**15 strategie aperte**), `liquidity sweep reversal`
(4), `volatility expansion` (3), `nr7` (2), `gap fill strategy` (2).

➡️ **La lezione del 02/09 e' confermata e va scritta piu' forte: TradingView
NON e' saturo. E' saturo sui FORMATI. Sui MECCANISMI risponde.**

---

## 5. 🗑️ GLI SCARTATI — con la riga che lo prova

### 5.1 MECCANISMO 1 — momentum "prima mezz'ora → ultima mezz'ora"

| # | oggetto | la riga che lo prova |
|---|---|---|
| **S1** | **La versione M5/M15 di Gao esiste, si chiama Zarattini-Aziz-Barbon, ed E' GIA' IN CASA** | La domanda del mandato era: _"esiste una versione M5/M15 con piu' occasioni al giorno?"_. **Sì, ed e' `ABTG_OutOfNoise`.** Il paper *"Beat the Market: An Effective Intraday Momentum Strategy for S&P500 ETF (SPY)"* (Zarattini, Aziz, Barbon, SFI Research Paper 24-97) e' esattamente questo: _"Unlike typical academic literature that limits trading to the last 30 minutes of the trading session, their model initiates trend-following positions **as soon as** there is an indication of abnormal demand/supply imbalance"_ `[VERIFICATO via WebSearch sull'abstract; il PDF NON e' stato letto: SSRN 403, alexandria.unisg.ch e concretumgroup 000 al CONNECT]`. 🔴 **E in casa non e' bocciato: e' ROTTO.** `REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md`: **n=0 trade su 3 celle**, e la diagnosi e' nel codice — `int need=(InpConeDays+3)*BarrePerSeduta()+shiftEval+5;` con `CopyRates(...,0,need,r)` che copia barre **consecutive sul calendario**: su un CFD che contratta ~92 barre M15 al giorno, 482 barre = **5 giorni**, non 17 sedute → `nDays` resta 4-5 → `if(nDays < InpConeMinDays) return;` con `InpConeMinDays=14` → **non entra mai**. 👉 **Non e' un candidato da cacciare: e' una RIPARAZIONE da fare.** Costo stimato: una riga di `CopyRates` |
| **S2** | *"Improvements to Intraday Momentum Strategies…"*, Ákos Maróy, SSRN 5095349 | 🔴 **NON LETTO — SSRN 403 sul PDF diretto.** Dichiarato come buco, non compensato con la memoria |

### 5.2 MECCANISMO 2 — Initial Balance / TPO / estensioni

**Cinque query TradingView** (`initial balance`, `market profile`, `value area`,
`opening range extension`, `first hour range`). **Rese: 2 + 0 + 2 + 0 + 0.**

| # | oggetto | la riga che lo prova |
|---|---|---|
| **S3** | `Initial Balance BO Strategy` · MIKMani · MPL 2.0 · [`4732849691c1…`](https://www.tradingview.com/script/zpIyp7KB/) | 🔵 **GIA' SETACCIATO il 28/08** (`CACCIA_INTRADAY_INDICI_2026-08-28.md` §435): _"IB di 55 minuti, rottura in chiusura di IBH/IBL, SL 0,75 × range IB, TP 2 × range IB → famiglia ORB"_. Sorgente gia' in biblioteca. **Cio' che e' setacciato non si ricontrolla** |
| **S4** | `Initial Balance Panel Strategy for Bitcoin` · Smollet | 🔴 fuori strumento (cripto) |
| **S5** | `Mou Value Areas` · moumoose | 🔴 **doppione di `ABTG_DaxValueArea`**, gia' in casa |
| **S6** | `market profile` → **50 risultati, 0 strategie** | 🔴 su TradingView il market profile e' **solo indicatori**. Terza conferma (28/08, 02/09, oggi) |
| — | **estensioni del range** | 🔴 **`opening range extension` e `first hour range` rendono 8 e 4 risultati, ZERO strategie.** La variante "estensione" che il mandato cercava **non esiste come strategia pubblicata** |

> 🔴 **E sopra tutto c'e' il muro di casa: R45 0/48, R12 48/48 negative OOS,
> capitolo breakout M5 chiuso il 26.07.26.** Una variante di gestione su un
> motore chiuso 0/48 e' esattamente cio' che la Regola della Seconda Caccia
> vieta.

### 5.3 MECCANISMO 3 — reversione a banda su VWAP

| # | oggetto | la riga che lo prova |
|---|---|---|
| **S7** | **`NQ Scalping VWAP Mean Reversion (RSI + ATR Exits) [v5]`** · bradenstrock · 27/02/2026 · 105 righe · [`m69VWMzJ`](https://www.tradingview.com/script/m69VWMzJ/) | 🟠 **Motore pulito, ucciso dal grilletto di coda.** Ha tutto quel che serve: due lati simmetrici, `stopATR=1.0` / `targetATR=1.1` → **RR 1,1** (passa H8 con WR 51,2%), uscita a tempo a 20 barre, sessione 0930-1600, `process_orders_on_close=true`. 🔴 **Ma l'ingresso e' `(dist <= -minVwapDist) and (rsi <= rsiOS) and bullReversal` con `rsiOS=30` su `ta.rsi(close,14)`** (righe 54-58): **tre condizioni in AND di cui una e' un evento di coda.** E' **la stessa malattia di M0PB**, morto 12/12 il 31/08 con 0,52 segnali/giorno. Piu' `useOneTradeAtATime=true` → **il tetto e' 1 posizione alla volta per costruzione**. C2 fallito per disegno. 🟡 Da tenere: `minVwapDist` in **punti indice** e non in ATR e' sbagliato per noi, ma l'idea di una **soglia minima di distanza dall'ancora** e' giusta e ci manca |
| **S8** | **`VWAP Mean Reversion (2 Candle Rejection)`** · Spencer1976 · 25/03/2026 · 62 righe · [`3Q98707C`](https://www.tradingview.com/script/3Q98707C/) | 🟢🔴 **IL PIU' INTERESSANTE DEI TRE, E L'HO MISURATO.** Tre pezzi che in casa non abbiamo: **(a) il target E' l'ancora** (`targetLong = vwapValue`, riga 35) invece di un multiplo di R; **(b) un cancello di ARITMETICA DENTRO IL MOTORE** — `validLongRR = rewardLong >= riskLong * 1.5` (riga 38) rifiuta il trade se la geometria non paga, che e' il nostro H8 scritto nel Pine; **(c) un FILTRO DI REGIME LATERALE COSTITUTIVO** — `flatEMA = math.abs(ema20 - ema20[10]) < atr*0.4` (riga 15), e il laterale e' un **buco dichiarato** del portafoglio (LARRY: −6.445 nel 2019). 🔴 **MISURATO OGGI e bocciato sulla FREQUENZA, non a occhio** (§7.2): con il filtro flat come scritto, **0,03-0,27 segnali/giorno per lato** su DAX e S&P, M5 e M15 — **da 7 a 60 volte sotto il pavimento C2**. Senza il filtro flat sale a **1,16-1,28/gg (M5)**, ancora sotto 2,0 — **ma allora si perde l'unica cosa che lo rendeva nuovo.** 🎯 **La riga da ricordare: il filtro che riempiva il buco taglia il 79-88% dei segnali.** Non e' un difetto di taratura: e' il prezzo del laterale |
| **S9** | **`HYE Mean Reversion VWAP [Strategy]`** · HYE0619 · 27/07/2021 · 75 righe · [`WeAMGj9j`](https://www.tradingview.com/script/WeAMGj9j/) | 🔴 **NESSUNO STOP LOSS, e in piu' un BUG DI DIREZIONE.** Le uniche uscite sono `strategy.close("BUY")` e `strategy.close("SELL")` (righe 66 e 71) **entrambe sulla stessa condizione** `crossover(smallvwapValue, bigvwapValue)`: 👉 **lo short esce quando la media veloce SALE sopra la lenta, cioe' esattamente quando sta perdendo — e non ha nessun'altra uscita.** Inoltre `default_qty_value=100` **percent_of_equity** e `tradeDirection` default `"Long Only"` (C7). E la "VWAP" non e' una VWAP di sessione: e' una media ponderata a **2 e 5 barre** → **doppione della famiglia BandFade** (R108/R111, 6 finestre su 6 rosse) |
| — | `VWAP SD2 Reversion (Long)` · jswapnil | 🔵 **GIA' SCARTATO il 25/08**: sorgente in biblioteca come `VwapSD2Reversion_jswapnil_tvoSV81CXs_2026-08-25.pine`, motivo agli atti *"long-only, lotto fisso, TP/SL a 5 pip da forex"*. Citato **nell'header di `ABTG_VwapRevert.mq5`** perche' non venga riaperto. **Non ricontrollato** |
| — | `VWAP Suite`, `EMA Cross + Triple VWAP Reclaim`, `VWAP Mean Reversion Range Bound Forex RSI Volume`, `Dynamic Swing Anchored VWAP`, e altre 11 | 🔴 **primo taglio**: multi-indicatore in AND, oppure doppioni dichiarati di `ABTG_VwapRevert` (porting sumbloke077, gia' in casa e **mai girato**) |

> ### 🧭 E il muro esterno su questo meccanismo, letto oggi nel paper
> `arXiv 2605.04004`, Appendice A, decisione **D100: _"MNQ OU mean reversion
> permanently rejected (Hurst 0.59, trending)"_** e **D101: _"MNQ is
> momentum-dominant at 5-minute resolution"_**. 👉 **Una falsificazione
> esterna della mean-reversion sul Nasdaq a 5 minuti**, su un simbolo della
> nostra famiglia. Non chiude il DAX, ma cambia l'ordine della coda.

### 5.4 MECCANISMO 4 — contrazione di volatilita' → espansione · **l'unico BUCO VERO, e l'ho misurato**

| # | oggetto | la riga che lo prova |
|---|---|---|
| **S10** | **`Volatility Expansion Strategy [MNQ] V7`** · ZenOutMan · **MPL 2.0** · 13/04/2026 · 84 righe · [`57J0Kih3`](https://www.tradingview.com/script/57J0Kih3/) | 🟢 **IL CANDIDATO MIGLIORE DELLA BATTUTA SULLA CARTA — e falsificato dalla misura.** Sulla carta era tutto giusto: **il filtro E' il motore** (`if isCompressed: breakoutHigh := high` — **senza compressione non esiste nessun livello, quindi nessun trade**: la forma che in casa vale 30 celle su 30), **6 input**, **due lati simmetrici**, **nessuna ancora di orologio** (quindi non e' un ORB), `atrMult=1.5` / `rrRatio=2.0` → **RR 2,0**, livello azzerato dopo l'ingresso (`breakoutHigh := na`) contro il re-ingresso, nessun `request.security`, nessun `calc_on_every_tick`. 🔴 **MISURATO OGGI su 1.055.635 barre M1 di DAX (5 anni) e 815.320 di S&P (3 anni)** (§7.1): **frequenza 0,55-1,87 segnali/giorno per lato → C2 FALLITO su 8 celle su 8**; e soprattutto **tasso TP-prima-di-SL 31,6-36,0% contro il 35,8% richiesto da H8 → 7 celle su 8 SOTTO IL CANCELLO**, con **delta contro un ingresso CASUALE della stessa geometria fra −3,9 e +3,5 punti (media −1,2)**. 👉 **Su 9.723 segnali il motore non si distingue dal caso.** 🟡 Il difetto di disegno che avrei corretto (e che non salva): il livello e' l'estremo dell'**ultima** barra compressa, non il **range** dell'intera fase di compressione |
| **S11** | **`BB Keltner Squeeze Strategy`** · jimmaay · 17/06/2020 · 108 righe · [`yU4Zq0jT`](https://www.tradingview.com/script/yU4Zq0jT/) | 🔴 **NESSUNO STOP LOSS DI DEFAULT, provato in una riga:** `stop_loss = input(defval = 0, …)` (riga 63) e poi `if stop_loss>0 strategy.exit(…)` (riga 75) → **con i default il ramo non viene mai eseguito**, e l'unica uscita e' `strategy.close_all()` al cambio di direzione (riga 94). Piu' `default_qty_value = 100` **percent_of_equity**. 🟡 Il motore (BB(20,2) dentro Keltner(20,1.5) = squeeze; rilascio → lato del prezzo rispetto alla mediana BB) e' costitutivo e sarebbe interessante, **ma la regola di direzione e' un incrocio della media a 20** → famiglia `SuperWave`/`CrossEma`/`ChaosLyapunov`, e il **03/09 `RSI+EMA V8` ha appena riconfermato con una misura** che "nei numeri e' un incrocio di EMA" |
| **S12** | **`Volatility Expansion Breakout`** · ChenzyForex · 22/02/2026 · 47 righe · [`zhEefWDB`](https://www.tradingview.com/script/zhEefWDB/) | 🔴 **Non e' contrazione: e' un Donchian con due filtri appiccicati.** `rangeHigh = ta.highest(high, 20)` + `close > rangeHigh[1]` (righe 27, 31) = **breakout di canale a 20 barre** (famiglia R45 0/48), piu' `bullBias = htfClose > htfEMA` con **EMA 200 su H1** (filtro di tendenza appiccicato: **0 successi su 5** in casa) e `atrRising = atr > atr[1]` — che **richiede l'espansione GIA' IN CORSO**, cioe' nega la tesi della contrazione |
| **S13** | **`Decoded Volatility Expansion - Visual Pro`** · AHTISHAM_EE · 09/05/2026 · 73 righe · [`qgLu0K0v`](https://www.tradingview.com/script/qgLu0K0v/) | 🔴 **NON C'E' NESSUNA CONDIZIONE DI CONTRAZIONE.** `zoneHigh = ta.highest(high[1], 20)` e' definito **sempre**, e gli ordini stop sono piazzati **ad ogni barra piatta** (`if strategy.position_size == 0: strategy.entry("Long", …, stop=buyStopLevel)`, riga 41): e' uno **straddle di breakout su canale a 20 barre**, il motore che R45 ha chiuso 0/48. Piu' `default_qty_value=100` percent_of_equity |
| **S14** | **`Hybrid Trend-Following Inside Bar Breakout`** · JeET369 · 15/12/2025 · 129 righe · [`Fbp0VWt7`](https://www.tradingview.com/script/Fbp0VWt7/) | 🔴 **La condizione di volatilita' CONTRADDICE la tesi:** `volOK = atrFast > atrSlow or (atrFast/close) >= 0.012` (riga 98) → **pretende che la volatilita' sia GIA' SOPRA la sua media** per entrare su una **inside bar**, che e' per definizione una contrazione. Le due condizioni si combattono. Piu' `trendLong = emaFast > emaSlow` (EMA 50/200: filtro appiccicato + doppione di `ABTG_GoldenCross`/`EMA200`) e `default_qty_value=100`. 🟢 Da tenere: la gestione **e' la nostra** (parziale 50% a 1,5R + trailing ATR), ma la gestione ce l'abbiamo gia' |
| — | `Narrow Range + Inside Day, Long/Short Only` · ChartArt (1.631 + 1.048 like) | 🔴 **fuori TF**: sono NR+inside **DAY**, cioe' D1. Il mandato e' M5/M15. Dichiarato, sorgente non aperto |
| — | `Bollinger Squeeze Breakout + Volume` · AIScripts · `BT-SAR Ema, Squeeze, Volatility` · Credsonb | 🔴 primo taglio: multi-indicatore in AND con SAR/EMA/volume, nessuna tesi separabile |

### 5.5 MECCANISMO 5 — sweep di liquidita' + rientro · **e la CORREZIONE al mandato**

| # | oggetto | la riga che lo prova |
|---|---|---|
| **S15** | **`Asia Liquidity Sweep Reversal Scalper (GC/Gold)`** · bradenstrock · 01/03/2026 · 101 righe · [`4IevbowH`](https://www.tradingview.com/script/4IevbowH/) | 🟢🔴 **Il candidato che sembrava riaprire R89 — e l'ho misurato per chiudere la questione.** L'idea giusta: il livello non e' uno swing H4 a 21 barre per lato (quello che ha dato **14 trade IS** a R89), ma un **pivot(3,3) sul TF di lavoro** — `ph = ta.pivothigh(high, 3, 3)` (riga 37), aggiornato solo quando il pivot e' **confermato** (nessun repaint: il valore arriva 3 barre dopo). Grilletto: `low < lastPL and close > lastPL` (riga 56) = **spazzolata con l'ombra e rientro in chiusura**, piu' `rsi <= 45` per non inseguire. `slATR=1.2` / `tpATR=1.4` → **RR 1,167**, uscita a tempo a 25 barre, due lati simmetrici. 🟢 **La densita' FUNZIONA, ed e' la prima volta che il numero esiste: 4,22 e 4,57 segnali/giorno per lato su DAX M5** (§7.3) — cioe' **R89 non e' mai stato un verdetto sul meccanismo, era un verdetto sul GENERATORE DI LIVELLI**. 🔴 **E poi la misura lo uccide:** tasso TP-prima-di-SL **43,5-48,2% contro il 49,6% richiesto da H8 → 8 celle su 8 sotto il cancello, prima dei costi**, e **delta contro l'ingresso casuale fra −1,6 e +2,0 punti (media −0,2) su 22.616 segnali.** 👉 **Lo sweep di micro-pivot sugli indici a M5/M15 e' indistinguibile da un ingresso a caso.** Piu' C4: **`R95_REFERTO.md` ha gia' bocciato la famiglia 0/30** |
| **S16** | **`Liquidity Sweep + VWAP Reversal (v6 clean)`** · ReneHerkert · 25/01/2026 · 86 righe · [`raeV41qI`](https://www.tradingview.com/script/raeV41qI/) | 🔴 **Tetto di frequenza scritto negli input + filtro appiccicato.** `oneTradePerDay = input.bool(true, "Max. 1 Trade pro Tag")` (riga 19) e `tradedToday := true` dopo ogni ingresso: **1 trade al giorno per costruzione**, contro un pavimento di 2 per lato. E il livello e' **il massimo/minimo del giorno precedente** (`request.security(…, "D", high[1], …, barmerge.lookahead_off)`) → **un solo livello per lato al giorno**: e' esattamente la carenza di livelli di R89. In piu' `bull = close > ema200` (riga 58) = filtro di tendenza **appiccicato** a un motore controtendenza (0 successi su 5). 🟢 Corretto sul non-repaint: `lookahead_off` esplicito e `high[1]` |
| — | `_mr_beach Liquidity Sweep + VWAP V2 Trend Filter, Presets` · ReneHerkert (261 like) | 🔴 **Non aperto, e lo dichiaro**: stesso autore e stessa famiglia di S16, e il titolo annuncia **"Trend Filter" + "Presets"** = filtro appiccicato + parametri d'autore. Motivo scritto, non nascosto |
| — | `Liquidity Sweep Tracker \| Smart Money Stop Hunts` · blitz_locked | 🔴 e' un **tracker**: nessuna geometria di uscita propria |

> ### 🩹 **LA CORREZIONE AL MANDATO — R95 NON E' "IN CODA"**
> Il mandato dice: _"verifica se il cimitero ha gia' qualcosa — R95 JPY sweep
> e' in coda, non morto"_. **Verificato, ed e' il contrario.**
> `risultati_archivio/R95_REFERTO.md`, verdetto del **23/08/2026**:
> > _"**30 passate su 30 in perdita.** Tutti e 5 i timeframe (M30, H1, H2, H3,
> > H4), tutte e 3 le celle per timeframe, in IS E in OOS: PF da 0,65 a 0,80.
> > **Nessuna passata sopra 1,00, da nessuna parte.**"_
>
> E l'alibi non c'e': _"**Tetto livelli: NON ha morso** — `Livelli Buttati = 0`
> su 21.354 creati. **tutte le celle si leggono sul merito, nessuna scusa
> disponibile**"_, con **n da 149 a 3.641 trade per passata**.
> 👉 **L'asse della densita' — quello che il candidato di oggi prometteva di
> risolvere — era gia' l'oggetto stesso di R95** (cinque file prova `R95a..e`
> = "una scala di densita' da 2 a 48 ore di accumulo per lato").
>
> **Quindi oggi il quadro dello sweep+reclaim e' questo, tutto misurato:**
> R89 non misurabile (14 trade) · **R95 0/30 su forex con la densita' spazzolata**
> · **CRT TurtleSoup 0/30 a tick sugli indici** · **BreakinBox: tesi falsificata
> dall'ablazione** · **e oggi 8/8 sotto H8 e indistinguibile dal caso su 22.616
> segnali di indice.** 🔴 **Il meccanismo si chiude.**

### 5.6 MECCANISMO 6 — gap intraday e gap-fill

| # | oggetto | la riga che lo prova |
|---|---|---|
| **S17** | **`Gap Filling Strategy`** · alexgrover · **MPL 2.0** · 09/04/2020 · 33 righe · **1.383 like** · [`ghocsiv7`](https://www.tradingview.com/script/ghocsiv7/) | 🔴 **NESSUNO STOP, in un file di 33 righe dove si vede tutto.** Le uniche uscite sono `strategy.exit("ExitBuy","Buy",limit=lim)` (riga 30 — **solo `limit`, mai `stop`**) e `strategy.close_all` al cambio sessione (riga 18). 👉 **Se il gap non si chiude, la posizione resta aperta tutto il giorno senza protezione.** E il tetto e' **1 occasione al giorno** (`ses = change(time("D"))`) e solo nei giorni con gap: C2 fallito di un fattore ≥4 |
| **S18** | **`IU Gap Fill Strategy`** · Shivam_Mandrai · **MPL 2.0** · 10/03/2025 · 78 righe · [`T2ByrMw0`](https://www.tradingview.com/script/T2ByrMw0/) | 🔴 **Stesso tetto strutturale: 1 gap al giorno**, e in piu' filtrato a `pec_gap = 0.2%` (riga 8) → sui nostri indici restano poche sedute l'anno. 🟢 **Un pezzo da rubare, e lo scrivo perche' e' gratis:** l'ingresso NON e' all'apertura ma alla **riconquista confermata** — `low < last_session_last_bar_close and close > last_session_last_bar_close` (riga 27) + `barstate.isconfirmed` (riga 34). **Da confrontare con l'ingresso di `ABTG_GapFill` in un'ablazione, se e diverso** |
| — | `ICT Opening Gap Strategy [Momentum1]` · Toddwaters72 | 🟠 **scaricato ma NON letto riga per riga, e lo dichiaro.** Scartato al primo taglio: stessa famiglia (**1 occasione/giorno**) e **variante `Confirmed Close` gia' letta e in biblioteca dal 28/08** |

> 🔴 **Il tetto e' aritmetico, non di qualita': un gap di apertura e' UNO al
> giorno.** Nessuna implementazione di gap-fill puo' superare C2. **Il
> meccanismo 6 e' incompatibile col mandato di frequenza**, e va scritto una
> volta per non riaprirlo.

### 5.7 MECCANISMO 7 — lead-lag cross-asset

**Rese misurate:** `lead lag index` → 1 risultato, **0 strategie**;
`correlation divergence two symbols` → **0 risultati**;
`nasdaq dow correlation` → **0 risultati**. Piu' `lead lag` (02/09) → 0 strategie.
La ricerca web sul meccanismo rende **solo letteratura** (Kawaller et al.:
_"futures lead the index by 20 to 45 minutes"_ — misura degli anni '90) e
**nessuna implementazione**.

🔴 **SCARTO PER DUPLICATO DICHIARATO, come previsto dal mandato.** Il fronte A
del 02/09 ha gia' promosso **la divergenza relativa fra due indici**
(`z-score di D30EUR/U30USD`), e `ABTG_SondaRelativo.mq5` e' **in canna** (non
toccato, per mandato). **Il lead-lag direzionale non e' un meccanismo diverso:
e' lo stesso segnale letto come freccia invece che come elastico.** Prima di
aprire una seconda struttura sullo stesso dato, **si legge il referto della
sonda che sta per girare.**

### 5.8 MECCANISMO 8 — regime post-news (15-30 minuti DOPO il dato)

**Rese misurate:** `post news` → 1 risultato, **0 strategie**;
`economic news volatility` → **0 risultati**; `fomc` → 18 risultati, **0 strategie**.
Su TradingView **il regime post-news non esiste come strategia pubblicata**.

> ### 🪦 **E la lapide arriva da un paper GIA' AGLI ATTI, mai letto nel punto giusto**
> `arXiv 2605.04004` (Mesfin) e' citato **in 18 file del repo** — sempre per
> il §6.2 (soffitto d'attrito). **Nessuno aveva letto il §4.7.** Testuale,
> dal PDF scaricato e convertito oggi (1.130.529 byte):
>
> > _"**4.7 Event Day Trend (News-Driven Signals).** The hypothesis is that
> > after major economic releases — FOMC, CPI, NFP, PCE — forced institutional
> > repositioning creates directional order flow that persists for 10–60
> > minutes. I used a ForexFactory calendar with **993 qualifying events from
> > 2022–2025**. **The drift is real in the first five bars after the release.
> > That is just the news spike itself. From bar +6 onward, T-statistics
> > across all tested horizons are between 0.14 and 0.69.** The two largest
> > releases by market impact (NFP and CPI, both at 08:30 ET) are excluded
> > entirely by prop firm rules restricting trading to RTH hours anyway. On
> > the RTH-compatible sample, **T = 0.38**."_
> >
> > _"Secondary finding: comparing the two validated signals on news days
> > versus non-news days shows **no material difference**. … **News proximity
> > adds no value to either validated signal.**"_
>
> E nell'Appendice A: **`D127 — MNQ post-news drift permanently rejected — LOCKED`**.
>
> 🎯 **Cosa dice, in una riga:** su MNQ a barre di 5 minuti, **il "regime
> post-news" e' il picco stesso, e finisce entro 5 barre**. Dalla barra +6 —
> cioe' esattamente la finestra 15-30 minuti del mandato — **non c'e'
> niente**. E la prossimita' a una news **non funziona nemmeno come FILTRO**
> su segnali gia' validati.
>
> ⚠️ **Cosa NON dice:** e' misurato su **MNQ (Nasdaq)**. Le due sedie
> `ABTG_PostNews` in osservazione sul VPS sono su **EURUSD M5 e EURJPY M5**:
> sul forex questa e' un'**indicazione forte**, non un verdetto. Ma prima di
> spendere un round sul post-news sugli INDICI, si legge questo paragrafo.

---

## 6. 🪦 LE TRE LAPIDI DELLA BATTUTA — cosa risparmiano

| # | direzione chiusa | con quale numero | round risparmiati |
|---|---|---|---|
| **L1** | **regime post-news 15-30 min sugli indici** | 993 eventi 2022-2025 su MNQ, **T fra 0,14 e 0,69 dalla barra +6**, T=0,38 sul campione RTH, `D127 LOCKED` | ≥1 |
| **L2** | **sweep di liquidita' + rientro sugli indici a M5/M15** | **22.616 segnali**, TP-prima-di-SL **43,5-48,2%** contro **49,6%** richiesto, **delta contro il caso −0,2 punti**; piu' R95 **0/30** con densita' gia' spazzolata | ≥2 (era il candidato "naturale" della settimana) |
| **L3** | **compressione ATR → espansione (la variante piu' pulita in circolazione)** | **9.723 segnali**, TP-prima-di-SL **31,6-36,0%** contro **35,8%**, **7 celle su 8 sotto il cancello**, delta contro il caso **−1,2 punti** | ≥1 |

> 🎯 **E la lezione che le tiene insieme, ed e' la cosa piu' utile che porto:**
> **il controllo a ingressi casuali costa dieci righe e cambia il significato
> di ogni numero.** Un tasso di vittoria del 46% non dice niente da solo:
> **dice tutto quando accanto c'e' il 47% di un ingresso a caso con la stessa
> geometria, sugli stessi dati.** Su 16 celle e 32.339 segnali, il delta medio
> e' **−0,70 punti**. ➡️ **Da oggi ogni sonda di conteggio porta il suo
> controllo casuale.**

---

## 7. 📏 LE MISURE, per esteso — banco, criteri e numeri

**Banco (identico per tutte):** dati `FutureSharks/financial-data` GPL-3.0 via
`raw.githubusercontent.com`. **`GRXEUR` (DAX 30 in EUR, stessa scala di
D30EUR) 2014-2018 = 1.055.635 barre M1, 1.261 giorni.** **`SPXUSD` 2016-2018
= 815.320 barre M1, 925 giorni.** Aggregazione M1→M5/M15 fatta in casa.
Ambiguita' intrabarra **sempre a sfavore**. **Zero costi dentro le sonde.**
Parametri: **quelli dell'autore, non toccati** (non si tara un candidato prima
di sapere se esiste).

### 7.1 Compressione → espansione (S10, `Volatility Expansion Strategy [MNQ] V7`)

`ATR(20) / SMA(ATR(20),40)`; compresso < 0,95; espansione > 1,02;
SL 1,5×ATR, TP 3,0×ATR → **RR 2,0 → WR richiesto 35,8%**.

| simbolo | TF | lato | n | **segnali/giorno** | take mediano | stop mediano | **TP prima di SL** | **controllo casuale** | delta |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| DAX | M5 | L | 1.785 | **1,42** | 29,6 | 14,8 | **33,2%** | 36,4% | −3,2 |
| DAX | M5 | S | 1.797 | **1,43** | 30,5 | 15,2 | **36,0%** | 32,6% | +3,5 |
| DAX | M15 | L | 696 | **0,55** | 57,4 | 28,7 | **35,2%** | 33,2% | +2,0 |
| DAX | M15 | S | 712 | **0,56** | 57,0 | 28,5 | **31,6%** | 34,7% | −3,1 |
| S&P | M5 | L | 1.727 | **1,87** | 2,8 | 1,4 | **32,5%** | 35,3% | −2,9 |
| S&P | M5 | S | 1.707 | **1,85** | 2,8 | 1,4 | **31,7%** | 33,0% | −1,3 |
| S&P | M15 | L | 665 | **0,72** | 4,9 | 2,4 | **32,8%** | 36,7% | −3,9 |
| S&P | M15 | S | 634 | **0,69** | 5,0 | 2,5 | **31,9%** | 32,3% | −0,5 |

- **C2 (≥2,0/gg/lato): 0 su 8.** Il massimo e' 1,87 (S&P M5).
- **H8: 7 su 8 sotto il 35,8%** richiesto. L'unica sopra (36,0%) e' a
  +0,2 punti dalla soglia, **con costi zero**.
- **C8 (costo): il solo confronto legittimo e' il DAX** (GRXEUR = stessa scala
  di D30EUR): take M5 **29,6-30,5** contro spread mediano in sessione
  **1,6-1,7** → **18×**, largamente sopra il 3× richiesto. **Il costo NON e'
  il problema di questo motore: lo e' la direzione.**
  ⚠️ **I numeri S&P non si confrontano coi nostri spread**: SPXUSD sta su
  scala ~2.800, NASUSD su ~20.000 — sono punti indice diversi.
- **MFE ≈ MAE a ogni orizzonte** (DAX M5 a 60 barre: MFE 33,0 / MAE 36,0):
  **nessuna asimmetria direzionale dopo l'ingresso.**

### 7.2 Banda su ancora di sessione + rientro (S8, `VWAP Mean Reversion 2 Candle Rejection`)

Banda ±2,5×ATR(14) sull'ancora; stop ±4,0×ATR; cancello RR ≥ 1,5; filtro flat
`|EMA20 − EMA20[10]| < 0,4×ATR`.
⚠️ **Limite dichiarato:** i CSV histdata sugli indici hanno **volume = 0** →
la VWAP e' **approssimata con la media cumulativa di `hlc3`** dall'inizio
giornata. **La frequenza e' indicativa, non certificata.**

| simbolo | TF | filtro flat | L /gg | S /gg | RR mediano | take | stop |
|---|---|---|---:|---:|---:|---:|---:|
| DAX | M5 | **ACCESO (come scritto)** | **0,25** | **0,26** | 1,58 | 23,9 | 15,2 |
| DAX | M5 | spento | 1,16 | 1,18 | 1,58 | 26,5 | 16,8 |
| DAX | M15 | **ACCESO** | **0,04** | **0,03** | 1,59 | 48,4 | 30,6 |
| DAX | M15 | spento | 0,35 | 0,37 | 1,58 | 51,7 | 32,7 |
| S&P | M5 | **ACCESO** | **0,27** | **0,26** | 1,59 | 3,0 | 1,9 |
| S&P | M5 | spento | 1,28 | 1,25 | 1,58 | 2,8 | 1,8 |
| S&P | M15 | **ACCESO** | **0,06** | **0,05** | 1,57 | 4,5 | 2,8 |
| S&P | M15 | spento | 0,50 | 0,53 | 1,58 | 5,3 | 3,4 |

- **C2: 0 su 8.** Col filtro come scritto si sta **da 7 a 60 volte sotto** il
  pavimento.
- **Il cancello RR interno funziona** (RR mediano 1,57-1,59 su tutte le celle):
  e' l'unica cosa del file che consiglio di copiare.
- **Il filtro flat taglia il 79-88% dei segnali.** 🎯 **Questo e' il numero da
  ricordare quando si parla del buco "laterale": il laterale non e' un
  ingrediente gratis — costa quasi tutta la portata.**

### 7.3 Sweep di micro-pivot + rientro (S15, `Asia Liquidity Sweep Reversal Scalper`)

Pivot(3,3) confermato sul TF di lavoro; ombra oltre il livello + chiusura
rientrata; gate RSI(14) ≤45 / ≥55; SL 1,2×ATR, TP 1,4×ATR → **RR 1,167 → WR
richiesto 49,6%**.

| simbolo | TF | lato | n | **segnali/giorno** | take | stop | **TP prima di SL** | **controllo casuale** | delta |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| DAX | M5 | L | 5.321 | **4,22** | 15,6 | 13,4 | **46,3%** | 47,2% | −0,9 |
| DAX | M5 | S | 5.765 | **4,57** | 13,0 | 11,2 | **45,1%** | 44,4% | +0,8 |
| DAX | M15 | L | 1.804 | **1,43** | 28,0 | 24,0 | **47,1%** | 48,6% | −1,6 |
| DAX | M15 | S | 2.094 | **1,66** | 22,9 | 19,6 | **43,5%** | 44,4% | −1,0 |
| S&P | M5 | L | 2.458 | **2,66** | 2,1 | 1,8 | **48,2%** | 47,4% | +0,8 |
| S&P | M5 | S | 2.705 | **2,92** | 1,8 | 1,5 | **45,8%** | 47,3% | −1,4 |
| S&P | M15 | L | 1.148 | **1,24** | 3,3 | 2,8 | **47,5%** | 48,0% | −0,5 |
| S&P | M15 | S | 1.321 | **1,43** | 2,7 | 2,3 | **46,0%** | 43,9% | +2,0 |

Senza il gate RSI la frequenza raddoppia (**DAX M5: 8,59 e 8,56/gg**), e resta
la stessa geometria.

- ✅ **C2 SUPERATO su M5, per la prima volta in cinque battute** (4,2-4,6 sul
  DAX, 2,7-2,9 sull'S&P). **La carenza di livelli di R89 e' un problema
  risolto: bastava cambiare il generatore di livelli.**
- 🔴 **H8: 8 su 8 sotto il 49,6%**, e siamo a **costi zero**.
- 🔴 **Delta contro il caso: −0,2 punti in media.** Il segnale non c'e'.
- **C8:** take DAX M5 **13,0-15,6** contro spread **1,6-1,7** = costo **11-13%
  del take lordo**. Passa il 3×, ma su un motore a **4,4 trade/giorno per lato**
  quell'11-13% e' un attrito che si paga **~2.200 volte l'anno**.

---

## 8. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perche', e cosa ci costa |
|---|---|
| 🔴 **Il PDF di Zarattini-Aziz-Barbon ("Beat the Market")** | **SSRN 403** sul PDF diretto, **alexandria.unisg.ch / concretumgroup / tapescript 000 al CONNECT**. Ho letto solo l'abstract via `WebSearch`. 👉 **Non so quali siano i parametri veri del cono di rumore**: il porting `ABTG_OutOfNoise` viene dal Pine di Yuri Lopukhov, non dal paper. **Se un domani si ripara OutOfNoise, questo resta un anello non verificato** |
| 🔴 **"Improvements to Intraday Momentum Strategies", Maróy, SSRN 5095349** | 403. E' esattamente il paper che risponde alla domanda 1 del mandato (uscite diverse sullo stesso motore Gao) |
| 🔴 **`medium.com`** (dominio nuovo) | `EGRESS_BLOCKED`. Ci perdiamo tre implementazioni Python di squeeze/compressione ATR trovate via `WebSearch` |
| 🟠 **`_mr_beach Liquidity Sweep + VWAP V2`** e **`ICT Opening Gap [Momentum1]`** | **Scaricato il secondo, non letto nessuno dei due.** Motivi scritti in §5.5 e §5.6 (famiglia gia' letta / tetto di frequenza aritmetico). Non e' un buco di fonte: e' una scelta, e la dichiaro |
| 🟠 **~35 delle 47 strategie viste** | Filtrate su titolo + scheda. Con `pubscripts-suggest-json` che rende **~50 risultati per query**, il filtro per titolo puo' aver perso qualcosa |
| 🔴 **Il MERITO di qualunque candidato, sul NOSTRO banco** | Qui non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier viene da una corsa a tick.** Le misure del §7 sono su **dati esterni, OHLC M1, senza costi**: sono **indicazioni**, e sono etichettate cosi' ovunque |
| 🔴 **Nessun EA toccato, nessuna sedia, nessun magic, nessun parametro in forward** | **F11 rispettato.** Non ho creato nessun file in `prove/`: **non c'e' niente da provare** |
| ⚠️ **Nessun file del fronte A toccato** | `ABTG_SondaRelativo.mq5`, `RELATIVO_*`, `RIGA_COMPILA_ORB104*`, `CACCIA_FREQUENZA5_TASSONOMIA`: **mai aperti in scrittura** |

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

**Non c'e' un primo test di questa caccia, perche' non c'e' un candidato — e
questa e' una risposta, non un fallimento.** Quel che c'e' e' un **ordine di
coda** che oggi ha una ragione misurata dietro.

### La domanda, e la propongo cosi'

> **"La `SONDA DELL'OROLOGIO` — preparata il 28/08, sette file prova, riga
> pronta, MAI GIRATA in `risultati_archivio` — regge il pavimento di frequenza
> che oggi ha ucciso otto meccanismi su otto?"**

**Perche' questa e non un'altra**, in tre righe:
1. In cinque battute e ~200 oggetti guardati, **il web gratuito non ha
   prodotto un solo motore che superi insieme frequenza, aritmetica e
   scorrelazione.** L'unico che ha superato la frequenza (sweep di micro-pivot,
   4,4/gg) e' risultato **indistinguibile dal caso su 22.616 segnali**.
2. **Le cose pronte in casa e mai accese sono tre**: la Sonda dell'Orologio
   (28/08), `ABTG_VwapRevert` (25/08), `ABTG_AtrExhaustVol` (25/08). **Zero
   costo di porting, zero rischio di traduzione.**
3. **E c'e' una riparazione da un'ora che vale piu' di una caccia:**
   `ABTG_OutOfNoise` **non e' bocciato, e' rotto** — `CopyRates` conta barre
   di calendario invece che sedute (§5.1). E' **il momentum intraday del
   mandato**, gia' scritto, gia' autotestato 8/8 sul nucleo, fermo per una
   riga.

### E la seconda domanda, che ora si puo' fare per la prima volta

> **"Le sedie vive reggono nei regimi che a BCM non abbiamo?"**

Con `GRXEUR` M1 **2010-2018** e `NAS100_USD`/`XAU_USD` M1 **2005-2020**
scaricabili da qui, la **PROVA DI REGIME** dell'emendamento §C
(toro / orso / laterale / crollo) **non e' piu' bloccata dai 21 mesi a regime
unico degli indici BCM**. ⚠️ Con tutti i limiti del §3.3 — **e i verdetti
restano a tick sul nostro broker.** Ma **selezionare** e **falsificare** si
puo' fare qui, gratis, prima di accendere il PC di Claudio.

---

## 📊 IL CONTO DELLA BATTUTA

| | |
|---|---|
| meccanismi battuti | **8 su 8** |
| query | **29 TradingView + 6 WebSearch + 6 sonde di rete = 41** |
| strategie viste | **47** |
| **sorgenti letti riga per riga** | **12 Pine + 1 paper (PDF integrale)** |
| sorgenti archiviati in `biblioteca/sorgenti/` | **12** |
| **misure fatte su dati veri** | **24 celle** (frequenza + geometria) + **16 celle** (TP-prima-di-SL con controllo casuale) |
| **segnali misurati** | **32.339** |
| barre di prezzo lette | **1.870.955 M1** (DAX 5 anni + S&P 3 anni) |
| **EA promossi** | **ZERO** |
| lapidi nuove | **3** |
| canali nuovi aperti | **1** (dati M1 via `raw.githubusercontent`) |
| canali nuovi murati | **3** (`medium.com`, `concretumgroup.com`, `tapescript.io`) |
| correzioni a documenti di casa | **1** (R95 "in coda" → **bocciato 0/30**) |
| file di forward toccati | **0** |
