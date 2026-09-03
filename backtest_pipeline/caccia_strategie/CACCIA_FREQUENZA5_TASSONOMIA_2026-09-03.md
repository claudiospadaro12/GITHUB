# 🗺️ CACCIA FREQUENZA — **QUINTA BATTUTA · FRONTE A** · LA TASSONOMIA DELLE INEFFICIENZE INTRADAY — 03/09/2026

**Mandato (Claudio, 03/09 pomeriggio, testuale):** _"MANDIAMO GLI AGENTI PER UNA
CACCIA PIU' APPROFONDITA DEL SOLITO. TIME FRAME BASSI 5 MIN E 15 MIN. ASPETTO
IL VERDETTO APPENA POSSIBILE"_.

**Perimetro assegnato (FRONTE A):** **non cercare EA.** Costruire la **mappa dei
MECCANISMI** intraday documentati, e per ognuno dire (a) che evidenza ha,
(b) che frequenza puo' fare a M5/M15, (c) quanto e' sensibile al costo,
(d) **se in casa e' gia' stato battuto, e dove sta il suo cadavere.**

---

## ⚡ IL RISULTATO IN SEI RIGHE

> **24 meccanismi mappati in 10 famiglie di inefficienza. Di questi: 6 sono
> GIA' IN FLOTTA, 8 sono NEL CIMITERO con un numero che li ha uccisi, 5 sono
> IN CANNA (scritti, o misurati a meta'), 5 sono MAI TOCCATI.**
>
> 🥇 **Ma il risultato che vale piu' di tutta la shortlist non e' un
> meccanismo nuovo: e' che il piu' documentato dei 24 E' GIA' SCRITTO IN CASA,
> IL SUO BACO E' GIA' STATO CORRETTO, E NESSUNO L'HA RIGIRATO.**
> `ABTG_OutOfNoise` (il **cono di rumore orario**) e' il porting esatto del
> meccanismo che Zarattini-Aziz-Barbon pubblicano come **Swiss Finance
> Institute RP 24-97** (SPY 2007-2024). Il PASSO 0 del 29/08 ha dato **n=0 per
> un baco di warmup**, il baco e' stato **corretto lo stesso giorno**
> (v1.01, commit `65df62c`), la diagnostica aggiunta (v1.02, `13dc8cf`) —
> **e in `risultati_archivio` non esiste nessun referto successivo.**
> 🎯 **Costo per avere la risposta: una corsa. Zero righe di codice nuove.**
>
> 🆕 **E il meccanismo nuovo con l'evidenza migliore che ho trovato e' UNO:
> i FIX VALUTARI.** _Foreign Exchange Fixings and Returns around the Clock_,
> Krohn-Mueller-Whelan, **Journal of Finance 79(1), 2024** — il dollaro si
> apprezza nel run-up ai tre fix (Tokyo 09:55 JST, ECB 14:15 CET, WMR 16:00
> Londra) e si deprezza dopo, su **9 valute e 21 anni**, con meccanismo
> economico dichiarato (**rischio d'inventario dei dealer**). Confermato in
> modo indipendente da Evans, **Journal of Banking & Finance 2018**:
> _"extraordinary volatility and negative serial correlation around the Fix"_.
> **In repo la parola "WMR" compare UNA volta**, in un dossier che il 28/08
> aveva concluso _"arXiv: `all:"WMR fix"` → 0"_. **La letteratura c'era, era
> solo fuori da arXiv.**
>
> 🔴 **E l'aritmetica scomoda la scrivo qui, non in fondo: 2 punti base di
> oscillazione giornaliera su un portafoglio G9 sono ~2,2 pip TOTALI su
> EURUSD, spalmati su tre fix e due gambe = ~0,37 pip per gamba, contro uno
> spread di ~1,0 pip.** 👉 **La versione "deriva" del meccanismo e' morta
> prima di partire, esattamente come `fx-bizday`. L'unica versione viva
> possibile e' il FADE DELLO SPIKE al fix** — che e' quello che misura Evans,
> e che il PASSO 0 deve contare.

---

## 0. ⚖️ I CRITERI, CONGELATI PRIMA DI APRIRE UNA PAGINA

Ereditati da C1-C8/P5 delle quattro battute precedenti, **non toccati**.
I criteri si cambiano prima dei numeri, non dopo.

| # | criterio | soglia |
|---|---|---|
| **C1** | **TF DI LAVORO M5 o M15** | il meccanismo dev'essere valutabile e operabile su barre da 5 o 15 minuti. H1+ e M1 fuori perimetro |
| **C2** | **FREQUENZA ≥ 2 segnali/giorno per lato raggiungibili** | e va etichettato se e' `[MISURATA]`, `[DICHIARATA DALL'AUTORE]` o `[DERIVATA DALLA MECCANICA]` |
| **C3** | **il §4 non si ammorbidisce** | griglia / martingala / recovery / hedge / no-SL / SL virtuale / repaint / look-ahead = fuori, senza discussione |
| **C4** | **MECCANISMO NUOVO sulla stessa inefficienza** | mai "parametri diversi di un motore morto" (regola della seconda caccia, 19/08). **Ogni voce della tassonomia dichiara il suo cadavere.** |
| **C6** | **RR < 0,70 = SCARTO PER ARITMETICA** | da `p ≥ 1,075/(RR+1)`, cancello H8 (`FIRME_2026-08-31.md` FIRMA 2) |
| **C7** | **due lati** (regola 25/08) | un meccanismo a un lato solo senza ragione strutturale = punto in meno, scritto |
| **C8** | **numeri d'autore** | si leggono, si etichettano, **non entrano in nessun punteggio** |
| **P5** | **vincolo prop HFT** | max **25%** dei trade sotto 60 secondi (`report/CONFIG_PROP_2026-08-31.md`) |

### 💸 C2-bis — IL COSTO, E ADESSO SUGLI INDICI E' MISURATO

**Il debito aperto dal 23/08 e' stato pagato oggi.** Fonte:
`backtest_pipeline/risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`
(252 milioni di tick BCM, 2024.09.26 → 2026.06.30, % solo-bid **0,000%**).

| simbolo | ore di lavoro | **mediana** | P95 | **cancello 3× (punti indice)** |
|---|---|---:|---:|---:|
| **NASUSD** | 14-20 server | **1,6-1,8** | 1,8-2,7 | **4,8 - 5,4** |
| **U30USD** | 14-20 server | **1,9-2,0** | 2,0-3,0 | **5,7 - 6,0** |
| **D30EUR** | 8-16 server | **1,6-1,7** | 1,9 | **4,8 - 5,1** |
| **D30EUR NOTTE** | fuori sessione | **3,5-3,9** | — | **10,5 - 11,7** |

⚠️ **Il cancello si applica ORA PER ORA**, non in media: il take lordo mediano
del motore dev'essere ≥ 3× lo spread mediano **dell'ora in cui lavora**.

🔴 **E per il FOREX la misura NON esiste, e lo dichiaro invece di riempirlo.**
L'unica misura in repo e' quella degli indici sopra. Per il forex uso la
**convenzione dichiarata** delle battute precedenti — **`[NON MISURATO su BCM]`**:

| | convenzione usata | cancello 3× |
|---|---:|---:|
| **EURUSD** | **1,0 pip** | **3,0 pip** |
| **GBPUSD** | **1,5 pip** | **4,5 pip** |
| **XAUUSD** | **[INCERTO — mai misurato, nemmeno per convenzione stabile]** | — |

👉 **Ogni riga di questo dossier che tocca il forex porta questo cartello.
Un cancello tarato su una convenzione non e' un cancello: e' un promemoria.**

---

## 1. 📕 QUELLO CHE HO LETTO IN CASA PRIMA DI USCIRE

Letti per intero prima di aprire un browser, come da mandato:

`CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md` (729 righe) ·
`CACCIA_FREQUENZA4_CB_PAPER_2026-09-02.md` (569) ·
`CACCIA_FREQUENZA3_TV_GH_2026-09-01.md` · `CACCIA_FREQUENZA3_ART_PAPER_2026-09-01.md`
(sezione 3 per intero) · `CACCIA_FREQUENZA_2026-08-31.md` ·
`CACCIA_FREQUENZA2_2026-08-31.md` · `PROMEMORIA_SBLOCCO_FONTI.md` (619) ·
`backtest_pipeline/REGISTRO_TEST.md` (728, **il cimitero, per intero**) ·
`FLOTTA_ATTIVA.md` (259) · `report/ROTTA_PROP.md` ·
`backtest_pipeline/prove/CELLE_REGIME.txt` ·
`backtest_pipeline/prove/R52_CENSIMENTO_LATI.md` ·
`report/SWEEP_MECCANISMI_2026-08-23.md` (§5 N1) ·
`SETACCIO_MANUALE.md` (indice) ·
`risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md` ·
`risultati_archivio/OROLOGIO_VS_BREEDON_2026-09-03.md` ·
`risultati_archivio/REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md` ·
`mql5/Experts/ABTG_OutOfNoise.mq5` (changelog + `CalcCono`).

### 1.1 ⛔ Cio' che il mandato mi vieta di riaprire, e che NON ho riaperto

| oggetto | chiuso quando, con quale misura |
|---|---|
| **MQL5 Code Base** | 02/09, **400 id su 10 pagine**: zero motori intraday M5/M15 |
| **articoli mql5.com** | 01/09, **1.120 titoli**, zero candidati (chiusura strutturale) |
| **QuantConnect** | 01/09, 83 slug: libreria di portafoglio a ribilancio |
| **`geraked/metatrader5`** | 01/09, `Grid=true` su **11 EA su 11** |
| **TradingView** | 02/09, **28 query su 68 a resa ZERO** = saturazione misurata |
| **GitHub** | 02/09, **4 ricerche su 5 rendono lo stesso pool gia' scartato** |
| **SSRN · Forex Factory · EarnForex · Quantpedia premium** | murati, **non riprovati** (regola del mandato) |

🎯 **E questa battuta esiste proprio per la frase che la quarta ha misurato:**
_"le uniche due query produttive sono state quelle su un **MECCANISMO**, non su
un **FORMATO**."_ Qui non c'e' nessuna query su "EA", "MQL5", "scalping".

---

## 2. 📡 CONTROLLO POSITIVO — misurato OGGI, 03/09, prima di cercare

| fonte | bersaglio noto | esito misurato oggi | verdetto |
|---|---|---|---|
| **arXiv API** `export.arxiv.org` | `id_list=1103.5664` | **HTTP 200, 1.934 byte**, `<title>` = _"Intra-Day Seasonality in Foreign Exchange Market Transactions"_ | 🟢 **PASSA** |
| **arXiv** ricerca per categoria/stringa | 8 query lanciate | 200 su tutte, entry con id/data/autori/abstract | 🟢 **PASSA** |
| **`WebSearch`** (canale bibliografico) | 10 ricerche su paper di cui conosco titolo e rivista | tutte hanno restituito **la rivista, il volume, le pagine e l'anno corretti** | 🟢 **PASSA** |
| **GitHub** `WebFetch` su pagina repo | `giovannibrusco/zarattini-2023-orb-qqq` | **200**, README letto per intero | 🟢 **PASSA** |
| 🔴 `www.econ.umu.se` (PDF Lundström) | — | **EGRESS_BLOCKED** | 🔴 **NULLA** |
| 🔴 `www.diva-portal.org` (PDF Lundström) | — | **EGRESS_BLOCKED** | 🔴 **NULLA** |
| 🔴 `www.aeaweb.org` (draft Krohn) | — | **EGRESS_BLOCKED** | 🔴 **NULLA** |
| 🔴 `sites.insead.edu` (draft Krohn) | — | **EGRESS_BLOCKED** | 🔴 **NULLA** |

> ⚠️ **Quattro mura NUOVE, tutte su PDF accademici, tutte al CONNECT.**
> Non le scrivo nel `PROMEMORIA_SBLOCCO_FONTI.md` perche' **il mandato lo
> assegna al fronte B**: sono qui, misurate, pronte da copiare.
> **`bankofcanada.ca` e `wiley` non li ho provati**, e lo dichiaro.

### 🔬 IL RILIEVO DI METODO DELLA BATTUTA — e vale per ogni caccia futura

Il 28/08 un dossier ha scritto, con onesta': _"arXiv, 8 query: `all:"London fix"
AND all:exchange` (0) · `all:"WMR fix" OR all:"benchmark fixing"` (**0**)"_ e ne
ha concluso che sul fix valutario non c'era letteratura.

🔴 **La letteratura c'era: e' su Journal of Finance 2024 e su Journal of
Banking & Finance 2018. Non e' su arXiv, e non ci sara' mai.**

> 🎯 **Regola da tenere: arXiv indicizza la FISICA DELLA FINANZA (q-fin), non
> la FINANZA EMPIRICA.** I meccanismi di microstruttura veri — inventario dei
> dealer, ordini stop, fix, flussi — vivono in JF / JFE / RFS / JFM / JBF, che
> **non depositano su arXiv**. 👉 **Uno zero su arXiv NON e' una misura di
> assenza di letteratura**: e' una misura di assenza *su arXiv*. Da li' in poi
> si passa al canale bibliografico (`WebSearch` su titolo+rivista) e si
> etichetta **`[LETTO-VIA-SEARCH]`**. E' esattamente la stessa lezione del
> `PROMEMORIA` §D ("zero risultati su un tag non e' una misura di assenza"),
> applicata alle fonti accademiche.

**Etichette usate in tutto il dossier, senza eccezioni:**
- **`[VERIFICATO]`** — abstract o sorgente letto **su pagina aperta da me oggi**;
- **`[LETTO-VIA-SEARCH]`** — titolo, autori, rivista, anno, pagine e frasi
  chiave dal canale di ricerca, **PDF non aperto**;
- **`[INFERITO]`** / **`[INCERTO]`** — dedotto o non saputo, e detto.

---

## 3. 🗺️ LA TASSONOMIA — 24 MECCANISMI IN 10 FAMIGLIE DI INEFFICIENZA

**Legenda dello STATO IN CASA:**
🟩 **IN FLOTTA** (gira) · 🟨 **IN CANNA** (scritto o misurato a meta') ·
⬛ **CIMITERO** (ucciso da un numero nostro) · ⬜ **MAI TOCCATO** ·
🚫 **NON MISURABILE** (ci mancano i dati, non l'idea).

---

### 🅰️ FAMIGLIA I — APERTURA E RANGE INIZIALE

#### **M1 · ORB nudo — rottura del range dei primi n minuti**
- **(a) Evidenza:** Holmberg, Lönnbark & Lundström, _"Assessing the profitability
  of intraday opening range breakout strategies"_, **Finance Research Letters
  10, 27-33 (2013)** — futures sul greggio, **30/03/1983 → 26/01/2011**, costi
  stimati **0,04% per trade**; profittabilita' concentrata **nei periodi
  volatili**, e le soglie d'ingresso piu' alte alzano sia il success rate sia
  il rendimento medio. **`[LETTO-VIA-SEARCH]`** — due PDF (umu.se, diva-portal)
  **EGRESS_BLOCKED**.
- **(b) Frequenza M5/M15:** **≤1/giorno per lato** per costruzione (un range,
  una rottura). **`[DERIVATA DALLA MECCANICA]` → C2 fallita per definizione.**
- **(c) Costo:** medio-alta sensibilita': entra su un estremo, cioe' dove lo
  spread e' peggiore.
- **(d) STATO: ⬛ CIMITERO.** ~**210 celle a tick**. **R45 0/48**, **R12 48/48
  negative OOS**, R97 Nasdaq nessun edge, `Londra_ORB` OHLC 11% pos DD 23%.
  Capitolo **BREAKOUT M5 CHIUSO il 26/07/26** a verbale nel `REGISTRO_TEST`.

#### **M2 · ORB condizionato allo STATO di volatilita' (principio Contrazione-Espansione, Crabel 1990)**
- **(a) Evidenza:** stesso paper di M1 — la **C-E** e' fra le sue parole chiave:
  _"prices are characterized by intraday momentum on expansion days, whereas
  prices move randomly on contraction days"_ **`[LETTO-VIA-SEARCH]`**. Il
  corredo pratico (NR4/NR7 di Crabel) e' **divulgativo, non accademico**:
  grado di evidenza **basso**.
- **(b) Frequenza:** ≤1/giorno, e **si dimezza** perche' meta' dei giorni e'
  "contrazione". `[DERIVATA]`
- **(c) Costo:** come M1.
- **(d) STATO: 🟨 IN CANNA / PARZIALE.** La forma "l'arbitro di regime sceglie
  il motore" e' **DayFlow** (promosso 01/09, 9/10, `DAYFLOW_FREQUENZA_BOZZA.txt`,
  **mai girato**). L'ORB nudo sotto e' ⬛. 👉 **Non si riapre M2: si accende
  DayFlow.**

#### **M3 · ORB su "titoli in gioco" (volume relativo di apertura)**
- **(a) Evidenza:** Zarattini, Barbon & Aziz (2024), _"A Profitable Day Trading
  Strategy For The U.S. Equity Market"_ — l'ORB nudo e' debole, **quasi tutto il
  risultato viene dalla selezione dei titoli piu' anormalmente attivi in
  apertura**. **`[LETTO-VIA-SEARCH]`**
- **(d) STATO: 🚫 NON MISURABILE.** Serve una **sezione trasversale di azioni**
  e il **volume vero**. Sui CFD abbiamo 3 indici e **tick volume** (regola
  Paolo). **Fuori perimetro in modo permanente, e va scritto una volta.**

#### **M4 · Apertura direzionale su livello del TF superiore (non un box M5)**
- **(d) STATO: 🟩 IN FLOTTA.** `ABTG_DAX_Apertura_EU` (D30EUR M5, magic 770111,
  **PF 1,49 / DD 3,8% / 314 trade a tick**, SOLO LONG) e `Dow Apertura US`.
  ⚠️ **E' l'eccezione che conferma M1**: e' M5 ma su **livello H1**, non
  breakout di M5. **Anomalia del DAX, non motore generalizzabile** (FTSE, Dow,
  Nasdaq in apertura: tutti morti a tick).

#### **M5 · Fade dell'apertura / opening reversal**
- **(d) STATO: ⬛ CIMITERO.** R42 **0/24 IS e 0/24 OOS** sul fade degli estremi;
  A4 Nasdaq apertura **0% combo positive**; `ABTG_OpeningReversalB` in prove
  senza referto. **Nessuna evidenza esterna nuova trovata oggi.**

---

### 🅱️ FAMIGLIA II — SESSIONE E SOVRAPPOSIZIONI

#### **M6 · Canale di sessione di Londra (SMA5 high/low rotto in chiusura)**
- **(b) Frequenza: 🟢 MISURATA IN CASA, 03/09.** EURUSD M15+RSI: **12/12 righe
  vive, 2,0-2,3 segnali/giorno per lato**, MFE mediana **10-13,4 pip**;
  GBPUSD **24/24 vive**, MFE 12,6-16,3 pip. Il filtro RSI taglia il **73-77%**
  dei segnali nudi (filtro **vero**, opposto del V8).
- **(c) Costo:** 🔴 **il punto dolente, gia' scritto nei criteri R116**:
  1R = 8 pip, il cancello vale 0,60 pip, lo spread assunto 1,0-2,0 →
  **il costo e' 1,7-3,3 volte l'edge richiesto**. Previsione dichiarata prima:
  **MAE mediana 11,8 pip > SL 8,0 pip → l'esito piu' probabile e' un NO.**
- **(d) STATO: 🟨 IN CANNA — il piu' avanti di tutti.** PASSO 0 **SUPERATO**
  (`REFERTO_SONDALONDONFX_2026-09-03.md`), criteri del round a tick **R116 da
  firmare** (`LONDONFX_TICK_CRITERI.md`).

#### **M7 · Convergenza EU-USA fra due indici (z-score del rapporto)**
- **(a) Evidenza:** tre autori indipendenti su TradingView + un indicatore MQL5
  su GitHub (`m4rk-lewis`), **nessun paper**. Grado di evidenza: **pratico, non
  accademico**.
- **(b) Frequenza:** `[DERIVATA]` ~2-3 ingressi/giorno a **M5**, ~1 a M15.
  🎯 **La frequenza e' una MANOPOLA (la finestra `n`), non una speranza.**
- **(d) STATO: 🟨 IN CANNA.** Promosso 02/09 (**8/10**),
  `prove/RELATIVO_FREQUENZA_BOZZA.txt`, sonda **da scrivere**. Un altro agente
  ci sta gia' lavorando (`ABTG_SondaRelativo.mq5`, `prove/RELATIVO_*`):
  **non l'ho toccato.**

#### **M8 · Fade del range asiatico**
- **(a) Evidenza:** ⬜ **nessuna trovata.** TradingView `asian range fade`:
  **1 risultato, 0 strategie** (02/09). arXiv: niente.
- **(d) STATO: ⬜ MAI TOCCATO, e resta tale.** 🔴 **Non entra in shortlist:
  un meccanismo senza evidenza e senza codice e' una spazzolata, non un
  esperimento** (§5C del mandato di ruolo).

#### **M9 · Retest della VWAP di sessione NY**
- **(b) Frequenza: 🟢 MISURATA.** n=625 in 21 mesi ≈ **1/giorno**, U30USD M15.
- **(d) STATO: 🟨 PARCHEGGIATO CON NUMERI.** Nudo: **PF 1,002** (pareggio
  perfetto), DD 12,9%, take mediano win **+87,6 punti indice**. Col gate
  slope 75: PF 1,37-1,43, DD 3,7-4,7% ma **n=114-115 < 150** → muro R59, merito
  sospeso. 🟢 **Primo gate costitutivo della flotta VALIDATO a tick.** Porta di
  rientro **meccanica** (tagliando quando n≥150, stima 2027, o tick Dukascopy).

---

### 🅲 FAMIGLIA III — ORA DEL GIORNO E DERIVA

#### **M10 · Deriva oraria del forex (ore d'ufficio domestiche)**
- **(a) Evidenza: 🥇 la migliore della famiglia, e su due fonti indipendenti.**
  Breedon & Ranaldo, **Journal of Money, Credit and Banking, luglio 2013**
  (_"EUR/USD tends to depreciate in the European morning and then appreciate in
  US trading hours"_) e Ranaldo, **Journal of Banking & Finance 2009**
  (_"pervasively persist across many years, **even after accounting for calendar
  effects**"_). **`[LETTO-VIA-SEARCH]`, 5 copie provate e 5 mura.**
  Meccanismo economico dichiarato: **squilibrio d'inventario dei dealer**.
- **(b) Frequenza:** **1 gamba/giorno** per cella (08:00→16:00 server).
  🔴 **C2 non raggiunta su un simbolo solo**; si raggiunge **con piu' simboli**,
  che e' la bussola del 29/08.
- **(c) Costo:** 🔴 **il killer noto**: la versione incondizionata muore con
  **~1 bp di slippage**, dichiarato dall'autore stesso del codice di replica
  (`fx-bizday`, QuantRocket, Apache 2.0): _"Even 1 basis point will destroy the
  profitability"_. Edge lordo stimato **fra 0,17 e 1,7 pip per gamba** contro
  ~1,0 pip di spread.
- **(d) STATO: 🟨 IN CANNA, E MISURATO OGGI.**
  `OROLOGIO_VS_BREEDON_2026-09-03.md`: **cella A — EURUSD SHORT 08:00-16:00
  server (LA previsione del paper) passa il cancello C1 su ENTRAMBE le
  finestre** (IS +32,13 pti / C1 4,59, n=1607; OOS +5,31 / C1 5,31, n=2411).
  Cella B (long 16:00-20:00): segno giusto, **sotto C1**.
  ⚠️ **Onesta' agli atti:** nell'OOS il segno short domina **quasi tutte le
  ore** → la specificita' "ufficio europeo" e' nitida nell'IS, annacquata
  nell'OOS.

#### **M11 · 🆕 I FIX VALUTARI — Tokyo 09:55 · ECB 14:15 · WMR 16:00**
- **(a) Evidenza: 🥇 LA MIGLIORE DI TUTTA LA TASSONOMIA, e su due fonti
  indipendenti di prima fascia.**
  1. **Krohn, Mueller & Whelan**, _"Foreign Exchange Fixings and Returns around
     the Clock"_, **Journal of Finance 79(1), 541-578, febbraio 2024**
     (DOI 10.1111/jofi.13306). **`[LETTO-VIA-SEARCH]`** — 4 copie provate
     (aeaweb, INSEAD, Wiley, SSRN), **tutte murate**.
     Frasi riportate dagli estratti: _"the U.S. dollar appreciates in the run-up
     to foreign exchange (FX) fixes and depreciates thereafter, tracing a
     **W-shaped return pattern around the clock**"_; _"return reversals for the
     **top nine traded currencies over a 21-year period** are pervasive and
     highly statistically significant"_; _"consistent with an **inventory risk
     explanation** whereby FX dealers intermediate unconditional demand for U.S.
     dollars at the fixes"_.
     **Orari, dichiarati:** Tokyo **09:55 JST** · ECB **14:15 CET** ·
     WM/Reuters **16:00 Londra**. **Magnitudine dichiarata:** portafoglio long
     G9 → _"daily average swings of around **2 basis points** (or over 5%
     annualized)"_.
  2. **Evans, M.D.D.**, _"Forex trading and the WMR Fix"_, **Journal of Banking
     & Finance (2018)** — _"forex price changes display **extraordinary
     volatility and negative serial correlation** around the Fix"_, su **21
     valute in un decennio**. **`[LETTO-VIA-SEARCH]`**
     🎯 **"Negative serial correlation" = INVERSIONE, a un orario noto al
     minuto. E' la versione tradabile del meccanismo.**
- **(b) Frequenza M5/M15:** **3 eventi/giorno per simbolo**, a orario fisso.
  Su 3 simboli forex → **9 finestre/giorno**; con due letture (run-up e fade)
  → **fino a 6 segnali/giorno per simbolo**. `[DERIVATA DALLA MECCANICA]`
  🟢 **C2 raggiunta con margine, e senza scendere di TF.**
- **(c) Costo: 🔴 LA RIGA CHE DECIDE, e la scrivo prima della sonda.**
  2 bp di oscillazione giornaliera su EURUSD a 1,10 = **~2,2 pip TOTALI**,
  spalmati su tre fix e due gambe → **~0,37 pip per gamba** contro **~1,0 pip
  di spread** `[NON MISURATO]`. **La versione "deriva" e' morta di un fattore
  ~2,7, prima di scrivere una riga.** 👉 **Vive solo la versione FADE DELLO
  SPIKE**, la cui ampiezza non e' la deriva media ma il movimento del fix — che
  Evans descrive come "straordinario" **e che nessuno di noi ha mai misurato**.
- **(d) STATO: ⬜ MAI TOCCATO.** Grep su tutto il repo: **"WMR" = 1 occorrenza**
  (in un dossier che dichiarava zero letteratura), **"fix delle 16" = 1**,
  **"Osler" = 0**. 👉 **Voce n.1 della shortlist, §4.**

#### **M12 · Periodicita' intraday a mezz'ora (la stessa mezz'ora si ripete)**
- **(a) Evidenza:** Heston, Korajczyk & Sadka, _"Intraday Patterns in the
  Cross-section of Stock Returns"_, **Journal of Finance 2010** — e
  **`[VERIFICATO]`**, perche' e' anche su arXiv: **`arXiv:1005.3535`**,
  abstract letto oggi per intero: _"a striking pattern of return continuation
  at **half-hour intervals that are exact multiples of a trading day**, and this
  effect lasts for **at least 40 trading days**. Volume, order imbalance,
  volatility, and bid-ask spreads exhibit similar patterns, but do not explain
  the return patterns."_ Spiegazione teorica: **Bogousslavsky, _"Infrequent
  Rebalancing, Return Autocorrelation, and Seasonality"_, Journal of Finance 71,
  2967-3006 (2016)** `[LETTO-VIA-SEARCH]` — il ribilanciamento infrequente
  genera autocorrelazioni che **cambiano segno all'orizzonte di ribilancio**.
- **(b) Frequenza:** 13 mezz'ore in una sessione → **potenzialmente alta**.
- **(d) STATO: ⬜ MAI TOCCATO — e lo lascio fuori dalla shortlist, con motivo.**
  🔴 **E' un effetto di SEZIONE TRASVERSALE** (quali azioni sono andate bene in
  quella mezz'ora ieri), e noi abbiamo **tre indici, non 3.000 azioni**. La
  versione univariata (l'autocorrelazione della stessa mezz'ora su un solo
  strumento) **non e' quella misurata dal paper**: sarebbe una nostra
  estrapolazione. **`[INFERITO, e dichiarato debole]`.**

#### **M13 · Momentum intraday "prima mezz'ora → ultima mezz'ora"**
- **(a) Evidenza:** Gao, Han, Li & Zhou, _"Market intraday momentum"_,
  **Journal of Financial Economics 129(2), 394-414 (2018)** — SPY ETF ad alta
  frequenza **1993-2013**, effetto piu' forte nei giorni **volatili, ad alto
  volume, in recessione e con news macro**; presente su altri 10 ETF.
  Estensione FX: Elaut, Frömmel & Lampaert, _"Intraday momentum in FX markets:
  Disentangling informed trading from liquidity provision"_, **Journal of
  Financial Markets 37, 35-51 (2018)** — MICEX tick-by-tick 2005-2014.
  Entrambi **`[LETTO-VIA-SEARCH]`**.
  🔬 **La riga che vale piu' del risultato**, da Elaut et al.: il momentum
  intraday **non e' informed trading**, e' _"consistent with **risk-aversion for
  overnight holdings among liquidity providers**"_. 👉 **Quindi esiste solo
  dove esiste una CHIUSURA vera.** Sui CFD indice di BCM, che girano quasi 24h,
  **la premessa del meccanismo e' piu' debole per costruzione.**
- **(d) STATO: ⬛ CIMITERO.** **R98** (`IntradayMomentum`, porting del paper,
  NASUSD): **0/6 celle**, lordo medio **−0,31 punti indice per trade su 410**,
  **short PF 0,37 IS / 0,92 OOS**. Cancello S0 impossibile.
  👉 **La spiegazione di Elaut dice PERCHE' e' morto da noi. Non si riapre.**

---

### 🅳 FAMIGLIA IV — REVERSIONE A VWAP E ALLA MEDIA

#### **M14 · Fade della banda (Bollinger e simili)**
- **(d) STATO: ⬛ CIMITERO, DUE VOLTE.** **R108/R111: 6 finestre su 6 rosse**,
  con gradiente **H1 > M30 > M15 monotono su 3 simboli** — cioe' **peggiora
  proprio nel TF del mandato**. **R60: 12 celle su 12 in perdita.**
  Nessuna evidenza esterna nuova. **Ha gia' ucciso 7 candidati fra 01 e 02/09.**

#### **M15 · Reversione alla VWAP di sessione**
- **(a) Evidenza:** 🔴 **e questo e' un buco di letteratura misurato oggi.**
  arXiv, query `all:"VWAP" AND cat:q-fin*`, 12 risultati su 12: **sono TUTTI di
  ESECUZIONE ottimale** (VWAP execution, impatto, RL), **nessuno e' un segnale**.
  👉 **La VWAP in accademia e' un BENCHMARK DI ESECUZIONE, non un predittore.
  Chi la usa come segnale lo fa senza appoggio accademico**, e va scritto.
- **(d) STATO: 🟨 IN CANNA.** `ABTG_VwapRevert` **scritto e MAI GIRATO**;
  M9 (retest VWAP) misurato e parcheggiato.

#### **M16 · 🆕 Reversione a breve come REMUNERAZIONE DELLA LIQUIDITA', condizionata alla volatilita'**
- **(a) Evidenza:** Nagel, _"Evaporating Liquidity"_, **Review of Financial
  Studies 25(7), 2005-2039 (2012)** `[LETTO-VIA-SEARCH]`:
  _"the returns of short-term reversal strategies **can be interpreted as a
  proxy for the returns from liquidity provision**... the expected return from
  liquidity provision is **strongly time-varying and highly predictable with the
  VIX index**"_, con Sharpe condizionati che _"increase enormously along with
  the VIX during times of financial market turmoil"_.
- **(b) Frequenza:** alta quando la volatilita' e' alta, **zero quando e'
  bassa** — cioe' **non uniforme nel tempo**. `[DERIVATA]`
- **(c) Costo:** 🔴 altissima sensibilita': e' una strategia di **fornitura di
  liquidita'**, cioe' vive esattamente sullo spread che noi **paghiamo**.
- **(d) STATO: ⬜ MAI TOCCATO **come motore condizionato** — ma la sua versione
  INCONDIZIONATA e' M14, che e' ⬛ tre volte.
  🎯 **E qui c'e' il regalo diagnostico della battuta: Nagel spiega PERCHE'
  R42, R60 e R108/R111 sono morti.** Il fade non e' un edge: e' un **pagamento
  per fornire liquidita'**, e quel pagamento **esiste solo quando la liquidita'
  si ritira**. Su 21 mesi di toro tranquillo, il pagamento e' zero e resta solo
  il costo. ⚠️ **VIX: non ce l'abbiamo** (`SWEEP` 23/08 lo dichiara fra i dati
  mancanti). Il sostituto misurabile e' **la volatilita' realizzata del
  simbolo** — ed e' un'approssimazione, non la variabile del paper.
  👉 **In coda, non in shortlist: §4.5.**

#### **M17 · Contrarian dopo una sovrareazione (fade dell'anomalo)**
- **(a) Evidenza:** Caporale & Plastun, _"Price Overreactions in the Forex and
  Trading Strategies"_ e _"Daily abnormal price changes and trading strategies
  in the FOREX"_ (Journal of Economic Studies) — EURUSD, USDJPY, USDCAD,
  AUDUSD, EURJPY, **01/01/2008 → 31/12/2018**, dati giornalieri **e intraday**.
  **`[LETTO-VIA-SEARCH]`**
- **(d) STATO: ⬛ CIMITERO ESTERNO + ⬛ CIMITERO INTERNO.**
  🪦 **Gli autori stessi lo seppelliscono per il nostro mercato:** _"a strategy
  based on counter-movements after overreactions **does not generate profits in
  the FOREX and commodity markets**, but it is profitable in the case of the US
  stock market"_. E in casa: **R42, 0/24 IS e 0/24 OOS.**
  👉 **Due misure indipendenti, stessa direzione. Chiuso, e risparmia un round.**

---

### 🅴 FAMIGLIA V — CONTRAZIONE E ESPANSIONE DI VOLATILITA'

#### **M18 · 🥇 CONO DI RUMORE ORARIO / "noise area" — la banda che cresce con l'ora del giorno**
- **(a) Evidenza: 🥇 la piu' forte fra i meccanismi che possiamo DAVVERO
  operare.** Zarattini, Aziz & Barbon, _"Beat the Market: An Effective Intraday
  Momentum Strategy for S&P500 ETF (SPY)"_, **Swiss Finance Institute Research
  Paper 24-97, maggio 2024** (SSRN 4824172). **`[LETTO-VIA-SEARCH]`** — SSRN
  403, `alexandria.unisg.ch` EGRESS_BLOCKED.
  **La regola, riportata per intero dagli estratti:** _"each minute of each day,
  the strategy computes **noise boundaries as daily opening SPY price times one
  plus and one minus the average daily return up to that minute over the last 14
  trading days**, adjusting the upper bound up by any gap-down the prior
  overnight and the lower bound down by any gap-up. When SPY price is between
  these boundaries, demand and supply are in balance. **If at any clock hour or
  half-hour (HH:00 or HH:30), SPY price has moved above (below) the upper
  (lower) boundary, open a long (short) position.**"_ Uscita: **trailing stop
  dinamici**. Numeri dichiarati **`[DICHIARATI DALL'AUTORE, NON VERIFICATI,
  ESCLUSI DA OGNI PUNTEGGIO — C8]`**: 2007 → inizio 2024, **+1.985% netto costi,
  19,6% annuo, Sharpe 1,33**.
  🔬 **Perche' NON e' l'ORB e NON e' Bollinger, e la distinzione e' load-bearing:**
  (i) la banda e' **ancorata all'APERTURA DEL GIORNO**, non a una media mobile;
  (ii) la sua **larghezza e' il movimento tipico A QUELL'ORA** — normalizzazione
  **per ora del giorno**, che **nessuna banda in flotta ha**;
  (iii) si valuta **solo a orologio** (HH:00/HH:30) → il rumore fra un
  controllo e l'altro **non produce segnali**;
  (iv) e' **momentum** (si esce dal rumore), non fade → **non e' M14**.
- **(b) Frequenza M5/M15:** **13 controlli a orologio** in una sessione da 6,5h;
  con un ingresso per lato per giorno → **1-2/giorno per simbolo**, che su
  **3 indici** fa **3-6/giorno di flotta**. `[DERIVATA DALLA MECCANICA]`
  🔴 **E su un simbolo solo C2 non e' garantita: e' la ragione per cui la sonda
  deve contare, non stimare.**
- **(c) Costo:** 🟢 **il profilo migliore della tassonomia.** Ingresso a orologio
  (non su un estremo), tenuta di **ore**, uscita a trailing, **flat a fine
  seduta** → P5 (HFT prop) non morde. Cancello 3× spread: **4,8-6,0 punti
  indice** in sessione (misura di oggi).
- **(d) STATO: 🟨 **IN CANNA, ED E' IL PEZZO GRATIS DELLA BATTUTA.**
  `mql5/Experts/ABTG_OutOfNoise.mq5` **esiste, e' il porting MIT del Pine di
  Yuri Lopukhov (`tv gJeM3LZ5`) che implementa ESATTAMENTE questa formula**
  (`InpConeDays = 14`, media di `|close/open−1|` alla **stessa posizione
  oraria**), con **stop vero al broker** (ATR×1,5 + pavimento R109 obbligatorio),
  **flat di fine seduta, mai overnight**, **cap giornaliero**, rischio in %.
  - PASSO 0 del **29/08**: **n=0 su 3 celle** → 🔴 **BACO DI WARMUP, non motore
    morto**: `CalcCono` dimensionava la copia storica sulle barre **dentro** la
    seduta mentre `CopyRates` copia barre **di calendario** (NASUSD ~92 barre
    M15/giorno) → trovava 5 sedute su 14 e `nDays < InpConeMinDays` bloccava
    **ogni** ingresso, per sempre. Referto:
    `REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md`.
  - **Il baco e' CORRETTO**: v1.01 commit **`65df62c`**, con **blocco 9
    dell'autotest come guardia anti-regressione**; v1.02 **`13dc8cf`** aggiunge
    **14 contatori per-cancello** in `OnNewBar` esposti in colonna nel CSV di
    `OnTester` (cioe': se rifa' n=0, si vede **quale** cancello mangia le barre).
  - 🔴 **In `risultati_archivio` non esiste NESSUN referto successivo al
    29/08. La corsa non e' mai stata rifatta.**
  👉 **§4.0: e' la prima cosa da lanciare, e non costa una riga di codice.**

#### **M19 · L'arbitro di regime che sceglie il motore (fade **o** breakout)**
- **(a) Evidenza:** convergente ma **pratica**: DayFlow (TradingView) + il
  principio C-E di M2 + la conferma indipendente registrata il 01/09.
- **(b) Frequenza:** il punteggio di espansione arma sul **25% delle barre per
  costruzione** (percentile, non coda) — **frequenza garantita in STATO**, poi
  dimezzata da un cooldown a 10 barre.
- **(d) STATO: 🟨 IN CANNA.** Promosso 01/09 (**9/10**),
  `prove/DAYFLOW_FREQUENZA_BOZZA.txt`, **mai girato.**

#### **M20 · Squeeze / NR4 / NR7 (Crabel divulgativo)**
- **(a) Evidenza:** 🔴 **divulgativa** (Bookmap, StockCharts, LuxAlgo,
  QuantifiedStrategies). Nessuna fonte accademica trovata **oltre** M2.
- **(d) STATO: ⬜ MAI TOCCATO, e ci resta.** **Doppione di M2/M19 con evidenza
  peggiore.** Scarto per costo di validazione > valore atteso.

---

### 🅵 FAMIGLIA VI — GAP

#### **M21 · Chiusura del gap (gap fill)** — **🟩 IN FLOTTA**
`ABTG_GapFill` su 5 simboli (magic 772231-772235), **lato VINCOLATO dal segno
del gap** (`.mq5:424`), H1. **Frequenza ≤1/giorno per definizione → C2 fallita
su un simbolo.** Nessuna evidenza esterna nuova oggi.

#### **M22 · Continuazione del gap** — **🟩 IN FLOTTA**
`ABTG_GapContinuation` Nikkei M1 (magic 774101), da Code Base 75301, validato
R65/R66: **+8.339 · PF 1,398 · n=70 · DD 11,59%** a tick. ⚠️ **~3,7 operazioni
al MESE**: e' un passeggero per fascia oraria, non portata.
🔴 **Il lato SHORT perde (−2.182 OOS): non riempie il buco degli short.**

> ### 📌 La riga che chiude tutta la famiglia VI per questo mandato
> **Un gap da' UNA occasione al giorno.** Sotto C2 (≥2/giorno per lato) la
> famiglia gap **non e' candidabile su un simbolo**, e su N simboli diventa la
> stessa cosa che gia' facciamo. **Nel primo taglio del 02/09 sei candidati sono
> caduti esattamente qui.** Non si riapre senza un motivo nuovo.

---

### 🅶 FAMIGLIA VII — SWEEP DI LIQUIDITA' E CACCIA AGLI STOP

#### **M23 · 🆕 CASCATE DI STOP ATTORNO AI NUMERI TONDI**
- **(a) Evidenza: 🥈 la seconda migliore della tassonomia, e con DUE paper dello
  stesso filone.**
  1. **Osler, C.L.**, _"Currency Orders and Exchange Rate Dynamics: An
     Explanation for the Predictive Success of Technical Analysis"_,
     **Journal of Finance 58(5), 1791-1819 (2003)**. `[LETTO-VIA-SEARCH]` —
     documenta il **clustering degli ordini** sul libro **di una grande banca
     dealer FX**: _"**take-profit orders cluster particularly strongly at round
     numbers**"_ e _"**stop-loss orders cluster strongly just beyond round
     numbers**"_. Da li' spiega **due** predizioni: (i) i trend **si invertono ai
     livelli** di supporto/resistenza, (ii) i trend sono **insolitamente rapidi
     dopo** che il livello e' rotto.
  2. **Osler, C.L.**, _"Stop-loss orders and price cascades in currency
     markets"_, **Journal of International Money and Finance 24(2), 219-241
     (2005)**. `[LETTO-VIA-SEARCH]`
  🎯 **E' l'unico meccanismo della tassonomia in cui la fonte del denaro e'
  NOMINATA E CONTATA: gli ordini veri di un dealer.** Non e' geometria, non e'
  un indicatore: e' **dove stanno gli ordini**.
- **(b) Frequenza M5/M15:** EURUSD ha un range giornaliero di ~70-90 pip →
  attraversa **1-2 "big figure" (x.xx00) e 2-4 livelli "50" al giorno**.
  **`[DERIVATA DALLA MECCANICA]` → 2-6 tocchi/giorno per simbolo, entrambe le
  letture (rimbalzo AL livello · accelerazione OLTRE il livello) sullo stesso
  evento.** 🟢 **C2 raggiungibile su un simbolo solo.**
- **(c) Costo:** 🟠 medio. Il **rimbalzo** entra su un livello preciso (limite →
  spread favorevole); la **cascata** entra in rottura (spread peggiore, ed e' il
  lato che ci ha ucciso 210 celle di breakout).
- **(d) STATO: ⬜ MAI TOCCATO — e la verifica e' meccanica.**
  `grep -ri "Osler"` sul repo → **0**. `"round number"` → **0**.
  ⚠️ **Onesta':** _"numero tondo"_ compare in **45 file** — ma **sempre come
  ostacolo che DECLASSA un setup** nelle regole di Emiliano
  (`REGISTRO_TEST` §D: _"Declassano il setup (5 ostacoli): media 200 H1, VWAP,
  S/R, pre-section, **numero tondo**"_) e come **target** — **mai come motore,
  mai misurato, mai in un file prova.** 👉 **Shortlist, §4.2.**

#### **M24 · Falsa rottura di un livello di liquidita' (CRT / Turtle Soup / BreakinBox)**
- **(d) STATO: ⬛ CIMITERO, TRE VOLTE.** CRT Turtle Soup: **0/30 celle a tick nel
  toro**, e **il gate ADX non salva a tick** (PF 0,459 gated contro 0,462
  ungated, 17/19 mesi rossi). `BreakinBox`: **l'ablazione lo smaschera come R95
  con un livello nuovo** (il controllo a RR fisso batte la tesi su PF **e** DD,
  e buca comunque il cancello DD≤15%). `ABTG_LiquiditySweep`: chiuso da **R89
  per carenza di livelli** (14 trade IS).
  👉 **Il §4.4 di questa famiglia e' la lezione: "sweep" e' un NOME, non un
  meccanismo. Quando lo si misura, e' una rottura di livello con un altro
  vestito.** M23 e' diverso **perche' il livello non lo scegliamo noi: lo
  sceglie il sistema decimale**, ed e' dove Osler ha CONTATO gli ordini.

---

### 🅷 FAMIGLIA VIII — LEAD-LAG FRA STRUMENTI

#### **M25 · 🆕 Lead-lag DIREZIONALE futures USA → indici europei**
- **(a) Evidenza:** _"Intra-Day Anomalies in the Relationship between U.S.
  Futures and European Stock Indexes"_ — relazione **minuto per minuto** fra
  S&P 500 futures e **CAC 40, DAX, FTSE 100**: _"futures price movements
  consistently **lead index movements by twenty to forty-five minutes**, while
  movements in the index rarely affect futures beyond one minute"_.
  **`[LETTO-VIA-SEARCH]`**
  🔴 **E il contro-argomento va scritto accanto, non dopo:** la letteratura piu'
  recente sul lead-lag DAX/Eurex misura che _"market integration ... has
  significantly grown"_ e che la latenza di borsa e' il fattore che lo spiega.
  👉 **Venti-quarantacinque minuti di ritardo nel 2026 sono, con ogni
  probabilita', un numero d'epoca.** `[INCERTO — e' l'ipotesi piu' fragile
  della tassonomia]`
- **(b) Frequenza:** dipende dalla soglia sul movimento del leader → **manopola**.
- **(d) STATO: ⬜ MAI TOCCATO **come MOTORE**, 🟩 in flotta **come GATE**.
  In flotta la correlazione S&P e' **un filtro che SPEGNE** (e su MaxMinNotte
  DAX short **raddoppia il PF, 1,2→2,0+, e dimezza il DD**); qui sarebbe
  **cio' che DECIDE**. E' la distinzione che in casa vale **30 celle su 30**
  (`ROBUSTEZZA.md` §5B).
  🎯 **E la cosa importante: si misura con la STESSA sonda di M7 (RELATIVO).**
  Il numero 6 della sonda RELATIVO — _"quota di divergenze che NON convergono
  entro fine sessione"_ — **e' esattamente la misura che separa i due
  meccanismi**: se le divergenze convergono → M7; **se NON convergono, il
  laggard insegue → M25.** **Una corsa, due verdetti. Non serve una sonda
  nuova.**

#### **M26 · Lead-lag fra cambi**
- **(a) Evidenza `[VERIFICATO]`:** Basnarkov, Stojkoski, Utkovski & Kocarev,
  _"Lead-lag Relationships in Foreign Exchange Markets"_, **arXiv:1906.10388**
  (25/06/2019), abstract letto oggi: _"even though **for most pairs of exchange
  rates lagged effects are absent**, there are many pairs which pass statistical
  significance tests"_, su **log-rendimenti a un minuto**.
- **(d) STATO: ⬜ MAI TOCCATO, e non entra in shortlist.** L'evidenza dice
  **"assenti per la maggior parte delle coppie"**, l'orizzonte e' **M1**
  (capitolo chiuso: _"trappola di costo strutturale"_), e la parte viva
  riguarda **indici quotati nella propria valuta**, non i nostri cambi.

---

### 🅸 FAMIGLIA IX — CHIUSURA E OVERNIGHT

#### **M27 · Deriva overnight contro deriva intraday sugli indici**
- **(a) Evidenza `[VERIFICATO]`:** Knuteson, _"Strikingly Suspicious Overnight
  and Intraday Returns"_, **arXiv:2010.01727** (05/10/2020), abstract letto oggi:
  _"Overnight returns to major stock market indices over the past few decades
  have been **wildly positive**, while intraday returns have been **disturbingly
  negative**."_ Filone accademico parallelo: Lou, Polk & Skouras, _"A tug of war:
  Overnight versus intraday expected returns"_, **Journal of Financial Economics
  134(1), 192-213 (2019)** `[LETTO-VIA-SEARCH]` — _"profits are earned **either
  entirely overnight or entirely intraday**, typically with **profits of opposite
  signs** across these components"_.
- **(b) Frequenza:** **1/giorno.** 🔴 **C2 fallita per definizione.**
- **(c) Costo:** 🔴 **swap ogni notte, 450 volte** — e il paper misura **lordi**.
- **(d) STATO: 🟨 IN CODA DAL 23/08, MAI MISURATO.** E' il candidato **N1** dello
  `SWEEP_MECCANISMI_2026-08-23.md` (9/10 sull'idea), con il PASSO 0 gia' scritto:
  _"rendimento medio e mediano di D30EUR fra le 16:30 e le 08:00 server, al netto
  dello spread misurato e dello swap reale"_. **Oggi lo spread e' misurato**
  (D30EUR notte **3,5-3,9**, piu' del doppio della sessione) → **il PASSO 0 e'
  finalmente eseguibile con un numero vero al posto della convenzione.**
  🎯 **Ma il valore vero di M27 per noi NON e' un motore overnight: e' un BIAS
  DIREZIONALE.** Se la deriva **intraday** degli indici e' negativa, questo e'
  un argomento a favore del **lato SHORT intraday** — che e' il buco n.1 del
  portafoglio (`R52_CENSIMENTO_LATI`: quasi tutte le celle long-only, l'unica
  short pura e' MaxMinNotte DAX).

#### **M28 · Rottura del box notturno** — **🟩 IN FLOTTA**
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (magic 770411, M15, **SOLO SHORT**,
corr S&P ON): **PF 2,05 · DD 3,1% · 41 trade a tick**. ⚠️ **La misura di oggi
la tocca:** lavora **di notte**, dove lo spread DAX e' **3,5-3,9** — e la
pendente delle 07:59 lavora a ~2,8. **Costo strutturale da tenere davanti.**

---

### 🅹 FAMIGLIA X — EVENTI PROGRAMMATI E SALTI

#### **M29 · Deriva post-notizia (evento da calendario)** — **🟩 IN FLOTTA**
`ABTG_PostNews` su EURUSD e EURJPY **M5**. Frequenza legata al calendario macro.
Corredo: `DOSSIER_NEWS_FILTER_2026-08-21.md`.

#### **M30 · Deriva PRE-annuncio (pre-FOMC)**
- **(b) Frequenza: ~8 eventi l'anno.** 🔴 **C2 fallita di due ordini di
  grandezza.** Non e' un candidato per questo mandato, ed e' inutile discuterlo
  oltre. Citato per completezza della mappa.
- **(d) STATO: ⬜ MAI TOCCATO** (2 menzioni in repo, entrambe di passaggio).

#### **M31 · 🆕 SALTO STATISTICO — rilevare il salto senza il calendario**
- **(a) Evidenza:** Lee, S.S. & Mykland, P.A., _"Jumps in Financial Markets:
  A New Nonparametric Test and Jump Dynamics"_, **Review of Financial Studies
  21(6), 2535-2563 (2008)**. `[LETTO-VIA-SEARCH]` — _"a new nonparametric test
  to detect **jump arrival times and realized jump sizes in asset prices up to
  the intra-day level**"_, e _"the likelihood of misclassification of jumps
  becomes **negligible when using high-frequency returns**"_. Risultato che ci
  riguarda: i salti dell'**indice S&P 500** sono associati ad **annunci
  macro generali**, quelli dei singoli titoli a notizie societarie.
  Il test e' **calcolabile in un EA**: rendimento standardizzato sulla
  volatilita' locale (variazione bipotere), con soglia analitica.
- **(b) Frequenza M5/M15:** 🎯 **la frequenza E' LA SOGLIA**, cioe' un nostro
  parametro: abbassando la soglia i salti aumentano in modo continuo.
  **Come lo z-score di RELATIVO e il percentile di DayFlow: manopola, non
  speranza.** `[DERIVATA DALLA MECCANICA]`
- **(c) Costo:** 🔴 **il rischio strutturale della famiglia:** un salto e' il
  momento in cui **lo spread si allarga di piu'**. La misura di oggi lo mostra
  gia' altrove (U30USD ora 23: **P95 7,0, massimo 101** contro mediana 1,9-2,0).
  👉 **Il cancello 3× spread va applicato allo spread DEL MOMENTO DEL SALTO,
  non alla mediana dell'ora.** Se la sonda non sa dirlo, il candidato resta
  sospeso.
- **(d) STATO: ⬜ MAI TOCCATO.** In flotta il salto lo prendiamo **dal
  calendario** (M29); qui verrebbe preso **dal prezzo**, il che (i) non dipende
  da un file news da mantenere, (ii) prende anche i salti **senza notizia** —
  che sono quelli in cui non c'e' informazione nuova e quindi **il rientro e'
  piu' probabile**. 👉 **Shortlist, §4.3.**

---

### 🚫 APPENDICE ALLA TASSONOMIA — le tre famiglie che NON possiamo misurare, e va scritto una volta

| famiglia | perche' e' fuori, misurato |
|---|---|
| **Order flow / delta / footprint / assorbimento** | su forex e CFD il "volume" e' **TICK VOLUME** = conteggio dei cambi di prezzo, non scambi (regola Paolo, e Paolo aggiunge che **i volumi sono affidabili solo sugli indici regolamentati**). Ha gia' ucciso **~11 candidati** al primo taglio il 02/09 |
| **Aste di apertura e chiusura** (squilibrio MOC, prezzo indicativo) | letteratura viva su arXiv (1802.01921, 2401.06724, 2012.10145) ma **il dato dell'asta non esiste su un CFD**. 🚫 **Fuori in modo permanente** |
| **Sezione trasversale di titoli** (M3, M12, i reversal di Nagel nella forma originale) | abbiamo **3 indici + 8 cambi + 2 metalli**, non un universo di azioni. Ogni meccanismo la cui variabile e' *"quale titolo, fra mille"* **non e' traducibile**, e va detto invece di adattarlo |

---

## 4. 🎯 LA SHORTLIST — quello che proverei, in ordine, con la DOMANDA-SONDA

**Criterio di ordinamento, dichiarato:** _(valore atteso) ÷ (costo per avere la
risposta)_. **Non "quale mi piace di piu'".**

---

### 🥇 §4.0 — IL PEZZO GRATIS: **`OutOfNoise` (M18) — la sonda esiste gia', il baco e' gia' corretto**

> ⚠️ **Non e' MAI TOCCATO: e' MAI MISURATO. Lo metto in cima lo stesso, e con
> una ragione sola: e' l'unica voce della tassonomia il cui costo per avere la
> risposta e' UNA CORSA E ZERO RIGHE DI CODICE.** Nascondere questo per far
> sembrare la caccia piu' "nuova" sarebbe il modo migliore di bruciare il tempo
> di Claudio.

**Cosa lo giustifica adesso, e non il 29/08:**
1. il **baco e' corretto** (v1.01 `65df62c`) **con guardia anti-regressione**
   (blocco 9 dell'autotest riproduce il baco su barre fuori-seduta intercalate);
2. la **diagnostica c'e'** (v1.02 `13dc8cf`, 14 contatori per-cancello in colonna
   nel CSV di `OnTester`): **se rifa' n=0, stavolta si SA perche'**;
3. 🆕 **l'evidenza esterna e' arrivata dopo**: il 29/08 il cono era "un Pine di
   TradingView con voto 7/10"; **oggi e' il meccanismo di uno Swiss Finance
   Institute Research Paper su SPY 2007-2024**;
4. 🆕 **lo spread ora e' MISURATO**: il cancello S0 del file prova diceva
   _"spread tipico NASUSD 1-2 punti indice `[INCERTO]`, soglia ~6"_. **Oggi:
   mediana 1,6-1,8 in sessione → soglia 3× = 4,8-5,4.** Il cancello smette di
   essere una convenzione.

> ### ❓ LA DOMANDA-SONDA
> **Con il warmup corretto, il cono di rumore orario produce almeno 2 uscite dal
> cono al giorno per lato su NASUSD / U30USD / D30EUR a M15 e M5 — e la mediana
> dell'escursione favorevole vale almeno 3 volte lo spread MISURATO dell'ora in
> cui entra?**

| # | numero da leggere | cancello, congelato PRIMA |
|---|---|---|
| N1 | **uscite dal cono eseguibili/giorno per lato** | 🔴 **< 2,00 → il round non si apre** |
| N2 | **`gMaxNDays` e i 14 contatori per-cancello** | **se `gCntWarmup` > 0 a regime, il fix non ha funzionato** e si ferma tutto li' |
| N3 | **mediana del take lordo in PUNTI INDICE** (colonna `take_idx_pts`, gia' esportata) | **NASUSD < 4,8 · U30USD < 5,7 · D30EUR < 4,8 → SCARTO** |
| N4 | **MAE mediana** | dice dove sta lo stop senza essere dentro il rumore (R109) |
| N5 | **RR = N3/N4** | 🖊️ **< 0,70 → morto per aritmetica, senza corsa a tick** |
| N6 | **massimo di uscite in UNA giornata** | taglia `InpMaxTradesPerDay` **sui dati**. Se `max × 0,65% > 3,25%` (cap C1) il cap entra dal primo round |
| N7 | **gradiente M5 contro M15** | la conseguenza scomoda si dichiara PRIMA: **a M15 il cono e' piu' largo, quindi meno segnali. Se M15 non arriva a 2/giorno, il bersaglio e' M5.** |
| N8 | **quota di trade sotto 60 s** | **≥25% → SCARTO PROP (P5)**. Atteso basso: si valuta solo a HH:00/HH:30 |

⚠️ **Il file prova esiste gia'** (`prove/ABTG_OutOfNoise.txt`) e i suoi criteri
A/B/C sono **firmati dal 29/08**. **Non li tocco**: i criteri si cambiano prima
dei numeri, e questi sono gia' congelati. **L'unica cosa che aggiungo e' il
numero dello spread**, che prima era `[INCERTO]` e oggi e' misurato.

---

### 🥈 §4.1 — **M11 · I FIX VALUTARI** — la migliore evidenza mai portata in una caccia di questo progetto

```
EVIDENZA     Krohn, Mueller & Whelan, JOURNAL OF FINANCE 79(1) 541-578 (2024)
             + Evans, JOURNAL OF BANKING & FINANCE (2018)
             9 valute, 21 anni, 2 fonti indipendenti, MECCANISMO ECONOMICO
             DICHIARATO (rischio d'inventario dei dealer ai fix)
             [LETTO-VIA-SEARCH -- 4 copie PDF provate, 4 EGRESS_BLOCKED]
ORARI        Tokyo 09:55 JST · ECB 14:15 CET · WM/Reuters 16:00 Londra
IN ORA SERVER BCM (server = ora italiana - 1):
             ECB      14:15 CET = 13:15 SERVER  (CET = IT, entrambe le stagioni)
             WMR      16:00 Londra = 16:00 SERVER
                      [INFERITO dal calcolo dei fusi -- Londra e Italia
                       cambiano ora legale INSIEME, quindi le due letture
                       coincidono. E' la stessa coincidenza fortunata di
                       Breedon-Ranaldo. NON verificato sull'orologio del
                       terminale: e' il primo collaudo della sonda.]
             Tokyo    09:55 JST = 01:55 SERVER (estate) / 00:55 (inverno)
                      [INFERITO -- il Giappone NON ha ora legale, quindi
                       QUESTA sfasa di un'ora fra le stagioni. Va gestita,
                       non ignorata.]
STATO        MAI TOCCATO. grep "Osler" 0 - "WMR" 1 (in un dossier che
             dichiarava zero letteratura) - nessun file prova, nessun EA.
```

🔴 **L'ARITMETICA CHE VA FATTA PRIMA DI SCRIVERE UNA RIGA, e che quasi lo uccide:**
2 punti base di oscillazione giornaliera su un portafoglio G9 = **~2,2 pip
totali** su EURUSD a 1,10, spalmati su **3 fix × 2 gambe** → **~0,37 pip per
gamba** contro **~1,0 pip di spread `[NON MISURATO]`**.
👉 **La versione "cavalca la deriva" e' morta di un fattore ~2,7 — la stessa
parete che ha ucciso `fx-bizday`, il tube oscillator e meta' della letteratura
FX intraday. Non la propongo.**

🟢 **Quello che resta in piedi e' l'altra meta' del meccanismo, quella di Evans:
al fix c'e' "volatilita' straordinaria e correlazione seriale NEGATIVA".** Un
movimento straordinario **a un minuto noto in anticipo**, seguito da un rientro,
ha un'ampiezza che **non e' la deriva media**: e' l'ampiezza dello spike.
**Quella non l'ha mai misurata nessuno di noi, e la sonda la conta in un
pomeriggio.**

> ### ❓ LA DOMANDA-SONDA
> **Nei 30 minuti attorno ai tre fix (13:15 e 16:00 server; 01:55/00:55 per
> Tokyo), su EURUSD / GBPUSD / USDJPY a M5: (1) di quanti pip si muove il prezzo
> nella finestra di run-up, (2) quanto di quel movimento RIENTRA nei 30 minuti
> successivi, e (3) l'escursione favorevole mediana di un fade entrato al fix
> vale almeno 3 volte lo spread?**

| # | numero | cancello, congelato PRIMA |
|---|---|---|
| F1 | **eventi/giorno con movimento pre-fix ≥ una soglia in ATR** | 🔴 **< 2,00 sommando i tre fix e i lati → SCARTO** |
| F2 | **movimento MEDIANO nella finestra di run-up**, in pip, per fix | descrittivo: dice **quale dei tre fix vale la pena**, e i due morti si spengono subito |
| F3 | 🎯 **QUOTA DI RIENTRO** = (pip rientrati nei 30' dopo) ÷ (pip del run-up) | 🔴 **IL NUMERO CHE UCCIDE O SALVA LA TESI.** Se e' bassa, non c'e' inversione: c'e' momentum, e il meccanismo di Evans **da noi non esiste** |
| F4 | **MFE mediana di un fade entrato a fix+1 minuto** | 🔴 **< 3,0 pip (EURUSD) / < 4,5 (GBPUSD) → SCARTO.** ⚠️ **Cancello su spread di CONVENZIONE, non misurato: se F4 cade fra 2× e 3×, il verdetto e' SOSPESO e prima si misura lo spread forex** |
| F5 | **MAE mediana** e **RR = F4/F5** | 🖊️ **RR < 0,70 → morto per aritmetica** |
| F6 | **verifica del FUSO**: l'ora server dei tre fix, letta dai dati | 🔴 **collaudo obbligatorio prima di leggere qualunque altro numero.** Un fix contato all'ora sbagliata da' un risultato pulito e falso |
| F7 | **asimmetria dei lati** | il paper dice **dollaro su prima, giu' dopo**: su EURUSD e GBPUSD e' **long dopo il fix**, su USDJPY **short dopo**. 🟢 **Se i segni escono cosi', e' una pre-registrazione superata; se no, e' rumore** |

🏛️ **In ottica prop:** e' il candidato con **il profilo di perdita piu' diverso
da tutta la flotta** — perde quando il fix **non** rientra, cioe' in un giorno di
flusso vero, evento che **non e' correlato** a quello che fa perdere le sedie
direzionali. Tenuta **decine di minuti** → P5 non morde. **E lavora in una
fascia oraria (13:15 e 16:00 server) dove oggi non spara nessuno.**

---

### 🥉 §4.2 — **M23 · NUMERI TONDI** — l'unico meccanismo in cui gli ordini sono stati CONTATI

```
EVIDENZA     Osler, JOURNAL OF FINANCE 58(5) 1791-1819 (2003)
             + Osler, J. INTERNATIONAL MONEY AND FINANCE 24(2) 219-241 (2005)
             Fonte del dato: il LIBRO ORDINI di una grande banca dealer FX.
             [LETTO-VIA-SEARCH]
LE DUE FRASI "take-profit orders cluster particularly strongly at ROUND NUMBERS"
             "stop-loss orders cluster strongly JUST BEYOND round numbers"
LE DUE       (1) al livello -> RIMBALZO   (2) oltre il livello -> CASCATA
LETTURE      Sono lo stesso evento letto due volte, e si contano insieme.
STATO        MAI TOCCATO come motore. "numero tondo" e' in 45 file, SEMPRE
             come ostacolo che DECLASSA un setup (regole Emiliano) o come
             target. Zero misure, zero file prova.
```

**Perche' e' un candidato serio e non folklore:**
- 🟢 **il filtro E' il motore**: senza il livello non c'e' segnale — forma
  `ABTG_EMA200` (**30/30**), non forma "filtro appiccicato" (**0/5**);
- 🟢 **zero parametri liberi nel cuore**: il livello lo decide il **sistema
  decimale**, non una nostra ottimizzazione. **Non c'e' niente da sovradattare**
  — che e' l'opposto esatto delle 210 celle di breakout;
- 🟢 **due lati per costruzione** (il livello si tocca da sopra e da sotto);
- 🟢 **e' l'anti-M24**: il difetto di CRT/BreakinBox/LiquiditySweep e' che **il
  livello se lo sceglie il motore**. Qui no.

> ### ❓ LA DOMANDA-SONDA
> **Su EURUSD / GBPUSD / XAUUSD a M5 e M15, quante volte al giorno il prezzo
> tocca un livello tondo (x.xx00 e x.xx50), e — separando i tocchi che RIMBALZANO
> da quelli che ROMPONO — l'escursione favorevole mediana nelle 12 barre
> successive vale almeno 3 volte lo spread?**

| # | numero | cancello, congelato PRIMA |
|---|---|---|
| R1 | **tocchi/giorno per lato**, ai livelli **00** e **50** contati separatamente | 🔴 **< 2,00 sommando i lati → SCARTO.** ⚠️ E se **00** e **50** danno numeri molto diversi, **vale il livello, non la media** |
| R2 | **quota di RIMBALZO** (torna indietro di ≥X pip senza superare il livello di Y) contro **quota di ROTTURA** | 🎯 **il numero che sceglie QUALE delle due letture di Osler e' viva sui nostri dati.** Non si sceglie a priori: **si conta** |
| R3 | **MFE mediana del rimbalzo** a 12 barre | 🔴 **< 3,0 pip EURUSD / < 4,5 GBPUSD → SCARTO** `[spread di convenzione]` |
| R4 | **MFE mediana della cascata** dopo la rottura | stesso cancello. 🔴 **Previsione dichiarata PRIMA: la cascata e' l'ipotesi PIU' DEBOLE**, perche' e' un breakout, e i breakout in casa sono **0/48 e 48/48 negative**. Se cade solo la cascata, il meccanismo non e' morto: e' meta' |
| R5 | **MAE mediana** e **RR** | 🖊️ **RR < 0,70 → morto per aritmetica** |
| R6 | **XAUUSD: quali sono i "tondi"?** | ⚠️ **`[INCERTO]` da risolvere PRIMA**: su un prezzo a quattro cifre i tondi sono le decine, non i decimali. **La sonda misura 1 / 5 / 10 dollari separatamente e lo dichiara**, non sceglie |

⚠️ **Il rischio del candidato, nominato per primo:** e' l'ipotesi che il
clustering degli ordini misurato **nel 2003 su una banca** valga **nel 2026 su
un broker retail**. `[INCERTO]`. **Ma e' proprio quello che la sonda misura**, e
il costo di scoprirlo e' un pomeriggio.

---

### 4️⃣ §4.3 — **M31 · SALTO STATISTICO (Lee-Mykland)** — la frequenza e' una soglia, non una speranza

```
EVIDENZA  Lee & Mykland, REVIEW OF FINANCIAL STUDIES 21(6) 2535-2563 (2008)
          [LETTO-VIA-SEARCH]. Test non parametrico dei tempi di arrivo e
          delle ampiezze dei salti "up to the intra-day level".
STATO     MAI TOCCATO. In flotta il salto lo prendiamo dal CALENDARIO
          (ABTG_PostNews); qui si prende DAL PREZZO.
```

**Le due cose che lo rendono diverso da tutto quello che abbiamo:**
1. 🎯 **il grilletto e' una soglia NORMALIZZATA** (rendimento diviso per la
   volatilita' locale): la frequenza **non dipende dal mercato, dipende dalla
   soglia — che e' nostra.** E' la stessa proprieta' che ha promosso RELATIVO e
   DayFlow, e l'opposto esatto del **grilletto di coda** che ha ucciso M0PB
   (**0,52 segnali/giorno**);
2. 🎯 **separa il salto CON notizia dal salto SENZA notizia.** Il secondo e'
   quello dove non c'e' informazione nuova, quindi **quello dove il rientro e'
   piu' probabile** — ed e' esattamente cio' che un filtro da calendario **non
   puo' fare**, perche' guarda solo i primi.

> ### ❓ LA DOMANDA-SONDA
> **Su U30USD / NASUSD / EURUSD a M5, con la soglia del test di Lee-Mykland
> tarata per dare 2-4 salti al giorno: dopo il salto il prezzo CONTINUA o
> RIENTRA — e il movimento residuo vale piu' dello spread che si paga PROPRIO
> in quel momento?**

| # | numero | cancello, congelato PRIMA |
|---|---|---|
| J1 | **salti/giorno per lato** a 3 soglie (3σ / 4σ / 4,5σ) | 🔴 **non e' un cancello, e' la TARATURA**: si sceglie la soglia che da' 2-4/giorno, e **si dichiara quale** |
| J2 | **rendimento mediano nelle 12 barre dopo il salto**, nel verso del salto | 🎯 **il segno decide il motore**: positivo → continuazione, negativo → fade. **Non si sceglie prima, si legge** |
| J3 | 🔴 **LO SPREAD NEL MINUTO DEL SALTO**, non la mediana dell'ora | **il cancello 3× si applica a QUESTO numero.** Se la sonda non riesce a leggerlo, **il candidato resta SOSPESO** — non si usa la mediana per comodita' |
| J4 | **MFE / MAE / RR** | 🖊️ **RR < 0,70 → morto per aritmetica** |
| J5 | **quota di salti che cadono entro ±5 minuti da una news del calendario** | dice **quanto del meccanismo e' gia' coperto da `ABTG_PostNews`**. 🔴 **Se e' > 70%, non e' un motore nuovo: e' il nostro con un grilletto diverso, e C4 lo boccia** |

---

### 5️⃣ §4.4 — **M25 · LEAD-LAG DIREZIONALE** — un verdetto che si prende in omaggio

**Non chiedo una sonda per questo.** Chiedo **una colonna in piu' nella sonda di
RELATIVO** (M7), che un altro agente sta gia' scrivendo.

> ### ❓ LA DOMANDA-SONDA
> **Quando D30EUR si stacca da U30USD piu' del solito, lo scarto RIENTRA (→ M7,
> valore relativo) o il ritardatario INSEGUE (→ M25, lead-lag)? E in quanti
> minuti?**

Il numero 6 del PASSO 0 di RELATIVO — _"quota di divergenze che NON convergono
entro fine sessione"_ — **e' gia' esattamente questa misura**. Serve solo che il
CSV riporti anche **il segno e il tempo del movimento successivo del
ritardatario**. 🎯 **Una corsa, due meccanismi, due verdetti. E se il primo
muore, il secondo puo' essere vivo: sono le due facce della stessa moneta.**

---

### 6️⃣ §4.5 — **M16 · REVERSIONE CONDIZIONATA ALLA VOLATILITA' (Nagel)** — in coda, e con una condizione

**Non lo propongo come candidato: lo propongo come DOMANDA DA FARE AI NOSTRI
MORTI**, perche' costa zero e puo' riaprire tre round.

> ### ❓ LA DOMANDA
> **Nei referti gia' in archivio di R42 (fade estremi, 0/24+0/24), R60 (mean
> reversion, 12/12 in perdita) e R108/R111 (banda, 6/6 rosse): le perdite sono
> distribuite uniformemente, o i pochi periodi positivi coincidono con la
> volatilita' realizzata piu' alta?**

- 🟢 **Se coincidono**, Nagel ha ragione e il fade non e' morto: **e' morto
  incondizionato**, e la versione condizionata e' un motore nuovo con
  un'evidenza di **Review of Financial Studies** dietro.
- 🔴 **Se non coincidono**, la famiglia fade si chiude **per la quarta volta e
  con una spiegazione**, che vale piu' di una quarta bocciatura.
- ⚠️ **Il vincolo che va scritto:** la variabile del paper e' il **VIX**, che
  **non abbiamo**. Il sostituto e' la volatilita' realizzata del simbolo:
  **e' un'approssimazione, non la variabile del paper**, e il verdetto va
  etichettato cosi'.
- 🔴 **E il paletto di casa non si ammorbidisce:** se questo diventa un round,
  il regime dev'essere **costitutivo dal primo minuto** (forma `ABTG_EMA200`,
  30/30), **mai un filtro acceso sopra un motore gia' tarato** (0 successi su 5).

---

## 5. 🪦 LE DUE LAPIDI DELLA BATTUTA — valgono quanto un candidato

### 5.1 **La famiglia CONTRARIAN su forex e materie prime e' chiusa DA CHI L'HA STUDIATA**
Caporale & Plastun, su 5 cambi e 11 anni: _"a strategy based on counter-movements
after overreactions **does not generate profits in the FOREX and commodity
markets**"_. **In casa: R42, 0/24 IS e 0/24 OOS.**
👉 **Due misure indipendenti, un mercato, stessa direzione. Non si riapre.**

### 5.2 **Il MOMENTUM INTRADAY (Gao) e' morto da noi PER UNA RAGIONE, e ora la ragione ha un nome**
Elaut, Frömmel & Lampaert (JFM 2018) misurano che il momentum intraday **non e'
informed trading**: e' l'**avversione al rischio overnight dei fornitori di
liquidita'**, che si scaricano prima della chiusura.
👉 **Su un CFD indice che gira quasi 24 ore, quella chiusura non esiste nella
stessa forma.** R98 (**0/6, −0,31 punti per trade su 410**) non e' stata sfortuna:
**e' la premessa del meccanismo che manca sul nostro strumento.**
🎯 **E la conseguenza generale, che vale oltre questo caso:** prima di portare un
meccanismo accademico sui nostri CFD, si chiede **su quale attrito istituzionale
poggia** — chiusura, asta, fixing, inventario, calendario — e **se quell'attrito
esiste su BCM**. I fix (M11) e i numeri tondi (M23) **passano questo esame**;
Gao e le aste **no**.

---

## 6. ⬜ ONESTA' DICHIARATA — cosa NON ho potuto leggere, e dove la mappa e' INFERITA

| oggetto | stato, e cosa ci costa |
|---|---|
| 🔴 **Il PDF di Krohn-Mueller-Whelan (JF 2024)** | **4 copie provate, 4 mura** (aeaweb, INSEAD EGRESS_BLOCKED; SSRN e Wiley non provati/murati). 👉 **Non conosco: gli orari esatti delle finestre di run-up e reversal in minuti, le magnitudini per SINGOLA valuta, e cosa dice il paper sui costi di transazione.** Ho solo **il portafoglio G9 aggregato (2 bp)** — ed e' proprio il numero su cui poggia la mia aritmetica di §4.1. **Se il paper dice che su EURUSD la magnitudine e' 3× quella del portafoglio, la mia stima e' pessimista di 3 volte.** `[INCERTO, e pesa]` |
| 🔴 **Il PDF di Osler (JF 2003 / JIMF 2005)** | **`[LETTO-VIA-SEARCH]`**. Ho le due frasi sul clustering e le due predizioni; **non ho** la definizione operativa di "just beyond" (quanti pip oltre il tondo?) ne' le magnitudini. 👉 **La sonda di §4.2 deve misurare la distanza, non assumerla** |
| 🔴 **Il PDF di Lee-Mykland (RFS 2008)** | **`[LETTO-VIA-SEARCH]`**. Ho il concetto e la garanzia asintotica; **non ho la formula esatta della soglia** (la finestra della variazione bipotere e la costante). 👉 **Chi scrive la sonda la deve ricavare, e se non ci riesce il candidato scende in coda: non si inventa una soglia e la si chiama Lee-Mykland** |
| 🔴 **I due PDF di Lundström** (umu.se, diva-portal) | **EGRESS_BLOCKED entrambi.** Costo: non conosco i numeri per stato di volatilita' della C-E — che sono **la parte che ci interesserebbe** di M2 |
| 🟡 **Zarattini-Aziz-Barbon (SFI 24-97)** | **`[LETTO-VIA-SEARCH]`**, SSRN 403 e alexandria EGRESS_BLOCKED. 🟢 **Ma la regola l'ho per intero dagli estratti, ed e' quella che `ABTG_OutOfNoise` gia' implementa** — quindi qui il buco pesa poco. ⚠️ **Cosa NON so: come sono fatti i "dynamic trailing stops" del paper.** Il nostro EA usa ATR×1,5 + pavimento: **e' una NOSTRA scelta, non la loro**, e va scritto |
| 🟡 **La replica indipendente `giovannibrusco/zarattini-2023-orb-qqq`** | 🟢 **letta per intero (MIT)** — ma replica il paper **2023 sull'ORB QQQ**, **non** il "Beat the Market" 2024 del cono. 🔴 **E la sua lezione va presa sul serio anche qui:** l'ORB replicato passa da **$138.639 a $4.860 con 2 centesimi/azione di slippage**, break-even a **2,2 centesimi**, e **il 76% del PnL filtrato viene dal 2022 soltanto**. 👉 **Un edge intraday pubblicato regge quasi sempre a costi zero e quasi mai ai costi veri: e' la ragione per cui il cancello 3× spread viene PRIMA del PF, sempre** |
| 🔴 **Nessuna frequenza MISURATA in questo dossier** | **quinta battuta di fila.** Yahoo, Stooq e Dukascopy restano murate al CONNECT (non riprovate, come da mandato). **Tutte le frequenze qui sono `[DERIVATA DALLA MECCANICA]` o `[MISURATA IN CASA da un referto citato]`. Nessuna e' stata misurata da me oggi** |
| 🔴 **Lo spread FOREX di BCM** | **non esiste.** Oggi e' stato misurato **solo sugli indici**. Tutti i cancelli forex di §4.1 e §4.2 poggiano su una **convenzione**, e ogni riga lo dichiara. 👉 **La stessa macchina che ha prodotto `SPREAD_FLOTTA_MISURA` gira su EURUSD/GBPUSD/XAUUSD senza modifiche: e' la mossa piu' economica del prossimo giro** |
| 🟡 **Dove la tassonomia e' INFERITA** | (1) **le frequenze di M11, M23, M31, M18** sono derivate dalla meccanica, non contate; (2) **gli orari server dei fix** sono un calcolo di fusi, **non letti sul terminale** (F6 e' il collaudo); (3) **M12** e' dichiarato non traducibile per un ragionamento mio, non per una misura; (4) **M25** poggia su un numero (20-45 minuti) **probabilmente d'epoca**, e l'ho scritto; (5) le classificazioni ⬜/🟨 vengono da `grep` su tutto il repo — **un meccanismo chiamato con un altro nome puo' essermi sfuggito**, ed e' il modo piu' probabile in cui questa mappa sbaglia |
| ⚠️ **Nessun backtest, nessuna compilazione, nessun file toccato** | qui non esistono MT5 ne' Strategy Tester. **Nessun numero nuovo e' stato misurato oggi tranne gli HTTP.** Nessun EA modificato, nessuna sedia, nessun magic, niente in forward. **Nessun file di altri agenti toccato** (`ABTG_SondaRelativo.mq5`, `prove/RELATIVO_*`, `RIGA_COMPILA_ORB104*`, `PROMEMORIA_SBLOCCO_FONTI.md`) |

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Il cono di rumore orario, con il warmup corretto, produce almeno due uscite al giorno per lato sui nostri tre indici — e l'escursione favorevole mediana supera i 4,8-6,0 punti indice che oggi SAPPIAMO essere il triplo dello spread?**

**E' la domanda giusta per quattro ragioni, e le scrivo tutte e quattro:**

1. **Costa una corsa.** L'EA e' scritto, il baco e' corretto, l'autotest ha la
   guardia anti-regressione, la diagnostica esce in colonna, il file prova ha i
   criteri firmati dal 29/08. **Tutto il resto della shortlist costa una sonda
   nuova; questo costa un lancio.**
2. **Chiude in ogni caso.** Se N1 non passa, si chiude **la famiglia
   contrazione-espansione per intero** — perche' l'altro membro (M2, l'ORB
   condizionato) e' gia' ⬛ e il terzo (M19, DayFlow) e' lo stesso arbitro con
   un altro vestito. **Tre meccanismi con una corsa.**
3. **Se passa, e' l'unico motore intraday della flotta con un paper istituzionale
   dietro** — e nasce gia' con stop vero, flat di fine seduta, cap giornaliero e
   rischio in percentuale, cioe' **gia' dentro il metro prop**.
4. 🔴 **E ha una probabilita' alta e dichiarata di fallire.** Il cono e' una
   **banda**, e le bande in casa hanno un curriculum pessimo (M14: **6/6 rosse**,
   **12/12 in perdita**). La differenza che gli do' — banda **ancorata
   all'apertura**, larghezza **normalizzata per ora del giorno**, controllo
   **solo a orologio**, direzione **momentum e non fade** — **e' una mia
   distinzione ragionata, non una misura.** Se il numero dice che e' la stessa
   cosa, e' la stessa cosa, e si scrive.

**E se la risposta e' no su tutta la linea, la seconda cosa da lanciare NON e'
un'altra griglia: e' la sonda dei FIX (§4.1)** — perche' e' l'unico posto di
questa mappa dove c'e' un attrito istituzionale **datato al minuto**, misurato su
**21 anni**, pubblicato su **Journal of Finance**, e **mai guardato da noi**.

---

_Dossier chiuso il 03/09/2026. **24 meccanismi mappati in 10 famiglie**
(6 in flotta · 8 nel cimitero · 5 in canna · 5 mai toccati) + **3 famiglie
dichiarate non misurabili**; **8 query arXiv** + **10 ricerche bibliografiche**;
**3 abstract arXiv letti per intero e VERIFICATI** (1005.3535, 1906.10388,
2010.01727) · **11 paper di rivista `[LETTO-VIA-SEARCH]`** (JF ×4, JFE ×2,
RFS ×2, JBF ×2, JFM, JMCB, FRL) · **1 README GitHub letto per intero** ·
**4 mura NUOVE misurate** su PDF accademici; **1 rilievo di metodo**
(arXiv non indicizza la finanza empirica: uno zero su arXiv non e' una misura
di assenza) · **2 lapidi** che chiudono due famiglie con la voce degli autori ·
**1 shortlist di 4 meccanismi mai toccati** con domanda-sonda e cancelli
congelati · **1 pezzo gratis** (`ABTG_OutOfNoise`: baco corretto il 29/08,
mai rigirato).
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato, nessun
criterio congelato spostato, nessun file di altri agenti toccato.**_
