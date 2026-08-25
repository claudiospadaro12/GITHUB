# 🏹 CACCIA M5/M15 — FOREX + ORO (25/08/2026)

**Mandato (sessione principale, richiesta esplicita di Claudio):**
_"Dobbiamo avere più strategie su TF 5 min e 15 min. Ci servono per la
challenge."_ Conto prop 100k. La flotta oggi è quasi tutta H1/H4/sessione:
serve **frequenza intraday** su **forex (GBPUSD/EURUSD in primis)** e **oro**.

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 1.597 titoli del Code Base ricrawlati (catalogo COMPLETO: pagina 41 = 0
> elementi) + 203 strategie TradingView raccolte per tag, 19 sorgenti letti
> riga per riga (13 `.mq5` + 6 Pine), 1 paper PDF letto nelle sezioni che
> contano, 6 query all'API arXiv, 82 slug Quantpedia enumerati e 8 fonti
> passate al controllo positivo — arrivano al sorgente 19 oggetti, ne propongo
> TRE (+1 in coda), e il primo non viene dal web: è un ramo MAI MISURATO di
> una sedia VIVA, e a dirci di misurarlo è la tesi del corso che abbiamo in
> repo da tredici giorni.**
>
> 🔴 **La risposta scomoda, e va letta due volte: sul TF M5/M15 il web
> gratuito non ha praticamente niente da darci, e non è pigrizia mia — è la
> quarta caccia di fila che ara lo stesso catalogo.** Dei 1.597 titoli, i
> filtri di questo mandato tirano fuori **61 titoli in tema**; di quelli,
> **la maggioranza è breakout da inseguire** (famiglia chiusa 26.07.26 e
> riconfermata 0/48 da R45), **martingala/griglia travestita**, oppure
> **scalping con take sotto il costo**. Il Code Base **non ha un solo EA di
> mean reversion intraday su forex col sorgente pulito e il rischio in
> percentuale.**
>
> 🟢 **E la cosa più preziosa che ho trovato non è un EA: è una
> SPECIFICA DI PROGETTO, misurata da un terzo che ha ammazzato quattordici
> famiglie di segnali** (arXiv 2605.04004). Dice, testualmente, che gli unici
> due segnali intraday che sopravvivono **tengono la posizione 12-15 barre e
> sono condizionati a un REGIME**. È il metro con cui ho giudicato tutto il
> resto — e spiega perché i nostri M5 sono morti tutti.

---

## 0. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire, è il metro di scarto

| caduto | dove | meccanismo | verdetto misurato DA NOI |
|---|---|---|---|
| **capitolo BREAKOUT M5 — CHIUSO** | `REGISTRO_TEST.md` §2 | Live5m, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, **Londra_ORB** | **CHIUSO il 26.07.26 a tick reali.** _"Il breakout in apertura su M5 NON ha edge sul tick vero. Non costruire altri v2 M5."_ |
| **R45 — ORB di sessione (Londra)** | `REFERTO_ROUND45_LONDRA.md` | range 07:00→07:15/07:30 server, conferma su chiusura M5 | **0 celle positive su 48** (GBPUSD/EURUSD/XAUUSD) |
| **R42/R43 — FADE degli estremi del range** | `REFERTO_ROUND42_FADE.md` | fade sull'estremo del box d'apertura | **0/24 IS e 0/24 OOS**, PF 0,50-0,93. _"è morto il MOTORE, non la gestione"_ |
| 🆕 **R95 — SWEEP + RECLAIM** | `R95_REFERTO.md` (23/08) | sweep di un livello di swing + rientro, EURJPY, M30→H4 | **30 passate su 30 in perdita.** PF 0,65-0,80, DD 27-99,9%, n 149-3.641. _"perde in modo uniforme, sistematico e su ogni scala temporale provata"_ |
| **R98 — intraday momentum (Gao)** | `R98_REFERTO.md` | prima mezz'ora predice l'ultima, NASUSD | **0/6.** Cancello zero **matematicamente impossibile**: −0,31 punti indice per operazione su 410, già al netto dello spread |
| **R60 — `ABTG_MeanRevert`** | `REFERTO_ROUND60_MEANREVERT.md` | fade simmetrico dell'estremo a N barre, GBPUSD H1 | **12 celle su 12 in perdita**, IS e OOS, PF 0,84-0,99 |
| **R63 — Turnaround Tuesday** | `REFERTO_ROUND63_64` | ribaltamento di calendario | **0/24 fuori campione su 11.928 operazioni. Famiglia chiusa** |
| **filtro appiccicato a motore già tarato** | R20 ADX, R12, R26, R45, R54 | — | **0 successi su 5** |

### 🎯 Le tre frasi che ho usato come bussola (citate, non parafrasate)

1. **`REGISTRO_TEST.md` §2:** _"in OHLC i Live5m davano numeri finti enormi
   (+129k DAX, +30k Nasdaq). In real tick: morti. **Lezione: M5/breakout →
   OHLC inganna.**"_ → è il motivo per cui **ogni candidato di questo dossier
   è marcato "validazione SOLO a tick reali"**, senza eccezioni.
2. **`REGISTRO_TEST.md` §Paolo:** _"**Volumi affidabili SOLO sugli indici**
   (regolamentati), **NON sulle valute**"_. → chiude la pista 5 del mandato
   (§6.5) su forex e oro, e non è un'opinione mia.
3. **arXiv 2605.04004 §6.2 (letto nel PDF):** _"both of them use regime
   classification and **hold positions for 60-75 minutes instead of 5-30
   minutes**... The two strategy types that avoid this ceiling share one
   feature: they hold positions for **12-15 bars rather than 1-6**."_

---

## 1. 🔌 CONTROLLO POSITIVO — misurato oggi, 25/08, fonte per fonte

| fonte | HTTP | bersaglio noto verificato oggi | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | scheda `/en/code/68951`: titolo `Liquidity Sweep H4 - M15 (Swing Highs and Lows) / MQL5`, autore `OsmarSandovalEspinosa`, data **2026.03.23**, **`UserDownloads:2383`** (erano 512 il 19/08 — la pagina è viva, non una cache). `/en/code/download/<id>` restituisce lo **ZIP col `.mq5`** | 🟢 **PASSA IN PIENO** |
| **arXiv API** (`export.arxiv.org`, https) | **200** | 6 query; `cat:q-fin.TR` rende titoli/date veri (es. *Short-horizon mean reversion in cryptocurrency markets*, 2026). PDF `2605.04004v2` scaricato (1.130.529 byte, 8 pagine) ed estratto (34.007 caratteri) | 🟢 **PASSA come canale** · 🔴 **STERILE sul mandato**: vedi §5 |
| **Quantpedia** | **200** (dopo `-L` sul 308) | `/strategies` rende **82 slug veri** | 🟢 **PASSA** · 🔴 **STERILE: ZERO strategie intraday FX o oro** — vedi §5.2 |
| **TradingView** | **200** | 🔓 **RIAPERTA A CACCIA IN CORSO — vedi §1-bis.** Prima misura: la pagina script non contiene il Pine (0 occorrenze di `//@version`). **Poi ho applicato il canale trovato dalla sessione gemella e ho scaricato 6 sorgenti Pine completi**, con `scriptName`, `created` e `scriptAccess: open_no_auth` | 🟢 **PASSA, SORGENTE COMPRESO** |
| **GitHub — `raw.githubusercontent.com`** | **200** | README di `abiodunaremu/openea` letto per intero (10.127 byte) | 🟢 **PASSA per la LETTURA** (se conosco già l'URL) |
| **GitHub — `github.com` e `api.github.com`** | **403** | testati **quattro** endpoint diversi: `/search`, `/topics/mql5`, `/topics/expert-advisor`, e persino la pagina di un repo pubblico (`/abiodunaremu/openea`) → **tutti 403, corpo di 378 byte**. `gh` CLI assente | 🔴 **NULLA per la RICERCA** — quinta caccia di fila |
| **Forex Factory** | **403** | `/forum/71-trading-systems` | 🔴 **NULLA** — quinta di fila |
| **SSRN** | **403** | Cloudflare su `papers.ssrn.com` | 🔴 **NULLA** — quinta di fila |

**Traduzione onesta:** su 8 fonti, **4 hanno funzionato** (Code Base, arXiv,
Quantpedia, lettura raw di GitHub), **2 sono leggibili solo a metà**
(TradingView senza sorgente), **2 sono mute** (Forex Factory, SSRN).

### Cosa ho sfogliato dove ha funzionato

- **Code Base:** `/en/code/mt5/experts` pagine **1→42**. Le pagine 1-40 rendono
  40 elementi ciascuna, **la 41 e la 42 rendono ZERO**: il catalogo finisce lì.
  **1.597 coppie id+titolo uniche** (erano 1.591 il 23/08 e 1.595 il 22/08:
  stesso catalogo, cresciuto di poco). Filtri **di questo mandato**:
  `revers|revert|fade|bollinger|band|rsi|stoch|deviation` ·
  `sweep|liquidit|order.block|fvg|imbalance|trap|false|fake` ·
  `gold|xau` · `volume|vwap|delta|obv|cvd` ·
  `session|intraday|scalp|momentum|london|new.york|tokyo|asian` ·
  `keltner|channel|envelope|donchian` · `eurusd|gbpusd|forex|currenc` ·
  `hour|clock|midnight|daily open` → **61 titoli in tema**.
  **13 sorgenti scaricati, decodificati (metà del Code Base è UTF-16) e letti**:
  `48251`, `68704`, `70796`, `20545`, `16350`, `39012`, `73638`, `74815`,
  `71189`, `70052`, `52105`, `68512`, `49770`.
- **arXiv:** 6 query (`abs:"intraday momentum"`, `abs:gold AND abs:intraday`,
  `abs:currency AND abs:intraday AND abs:trading`, `all:EURUSD OR all:GBPUSD
  OR all:XAUUSD`, `abs:"mean reversion" AND abs:"exchange rate"`,
  `abs:"foreign exchange" AND abs:intraday AND abs:predictab`). **1 PDF
  scaricato e letto** (§5.1).
- **TradingView:** **203 strategie uniche** raccolte dalle pagine tag
  `meanreversion`, `gold`, `forex`, `bollingerbands`, `reversal` (2 pagine per
  tag, filtro `?script_type=strategies`). **6 sorgenti Pine scaricati e letti
  riga per riga** (§3.4).
- **Quantpedia:** 82 slug enumerati e letti a titolo.

### 1-bis. 🔓 IL CANALE PINE — non è farina del mio sacco, e va detto

Il metodo **l'ha trovato la sessione gemella** che oggi batteva il lotto
INDICI (`CACCIA_M5M15_INDICI_2026-08-25.md` §1-bis): io l'ho **applicato** al
mio bersaglio e **verificato che funziona** anche qui. Tre passi, nessuna
autenticazione:

1. `https://www.tradingview.com/scripts/<tag>/?script_type=strategies`
   (paginata con `/page-N/`) → nell'HTML ci sono **link + titoli**, sotto
   `data-qa-id="ui-lib-card-link-title"`;
2. la pagina del singolo script **non contiene il Pine**, ma contiene
   l'identificatore **`PUB;<hash a 32 cifre esadecimali>`**;
3. `https://pine-facade.tradingview.com/pine-facade/get/PUB;<hash>/last` →
   **JSON col campo `source`: il Pine completo**, più `scriptName`,
   `created` e `scriptAccess`.

⚠️ **Nota mia, misurata oggi:** su **7 script provati, 6 hanno reso l'hash e
uno no** (`9morbD5t-15-Minute-Gold-Trend-Following-Strategy`: nessun `PUB;` a
32 cifre nell'HTML). **Il canale funziona, ma non è al 100%**: un titolo senza
hash non è un candidato scartato, è un candidato **non letto**, e va
dichiarato tale.

📌 **Reperti di struttura del Code Base, da mettere a verbale** (utili al
prossimo cacciatore quanto i candidati):
- `keltner` → **1 titolo** su 1.597. `donchian` → **1**. `vwap` → **ZERO**
  (confermato per la seconda caccia di fila).
- `london|new.?york|overlap|tokyo|sydney` → **UN titolo solo**
  (`GoldLondonBreakout`, già setacciato e scartato due volte).
- `gold|xau` → **10 titoli**, di cui **6 sono griglie/recovery già scartate
  il 16/08** (`XANDER Grid`, `XANDER Gold Recovery`, `Daily Zone Recovery`,
  `Quantum Gold Silver`, `Quantum XAUUSD Silver`, `Pending tread`).
  **Sull'oro il Code Base è, in maggioranza, un negozio di martingale.**

---

## 2. 🥇 I PROMOSSI — tre, in ordine di rapporto VALORE/LAVORO

---

### 🥇 P1 — `ABTG_BreakingBand` su **M15 e M5**: il ramo che la NOSTRA fonte ci dice di misurare e che non abbiamo mai misurato

```
NOME            ABTG_BreakingBand.mq5  (nostro, 1.640 righe, 82 input)
FONTE           IN CASA. Motore dal corso (live Emiliano/Paolo, 55 passaggi letti)
                Tesi distillata: backtest_pipeline/prove/BREAKING_BAND_TESI.md
LICENZA         roba nostra
COSTO DI PORTING  🟢 ZERO ORE, ZERO RIGHE. `InpTF` è GIÀ un input libero
                  (riga 213 del sorgente) e i quattro handle indicatore lo
                  usano già (righe 415-423). Serve un file prova, non codice.
STATO           MOTORE VIVO, non morto: R103 (finestra lunga 2020.01→2026.06,
                rischio 1%) → EURUSD PF 1,94 DD 2,5% n=59 · GBPUSD PF 1,20
                DD 7,8% n=126 · AUDUSD PF 1,54 DD 2,1% n=64.  [VERIFICATO in
                `risultati_archivio/R103_REFERTO_FINALE.md`, righe 23-25]
```

#### 🎯 IL FATTO CHE TRASFORMA QUESTO IN UN CANDIDATO — ed è in repo, non sul web

`backtest_pipeline/prove/BREAKING_BAND_TESI.md`, **riga 17**, sezione
_"I PARAMETRI (citazioni verificate)"_:

> **`- TF: dimostrata su tutti; operativita' M5/M15.`**

E nello **stesso file**, sezione *CRITERI DI PROMOZIONE (i soliti 4, congelati
ORA)*, riga 103:

> _"screening OHLC multi-simbolo **H1 (poi H4)** a default"_

📌 **Cioè: la fonte del motore dichiara che il TF operativo è M5/M15, e noi —
per una scelta di comodità congelata il 12/08 — abbiamo screenato H1 e poi
H4, e non siamo mai scesi.** Verificato: **tutti** i file prova di questa
famiglia (`R33_bb_walkforward.txt`, `R102_*`, `R103_*`) hanno
`InpTF=16385` (= `PERIOD_H1`). **Il ramo M5/M15 di un motore vivo non è stato
bocciato: non è stato misurato**, ed è esattamente il TF che Claudio chiede
oggi per la challenge.

#### ⚙️ MECCANICA, in tre righe (letta nell'header del sorgente, righe 16-60)
1. **FASE BULGE (obbligatoria):** espansione evidente delle bande 20/2
   (larghezza ≥ `InpBulgeWidthMult` × la media delle barre precedenti) **con la
   deviazione standard SOPRA la sua SMA50** (criterio ufficiale, non
   disattivabile), candele impulsive ≥ 1,5 ATR, movimento netto e
   unidirezionale, fase autonoma di ≥3 e ≤20 candele.
2. **PATTERN 2 — INVERSIONE (post-bulge, il default `InpPatternMode=2`):**
   dopo il bulge il prezzo **rientra verso la mediana senza mai toccare la
   banda opposta**, poi fa **RETEST della banda dell'impulso** con la banda
   piatta o a favore, bande in restringimento e StdDev in calo → **si entra
   CONTRO l'impulso**.
3. **USCITA:** SL = **3 × ATR** (regola fissa), **TP sulla MEDIANA aggiornato
   a ogni barra** (`InpTPRefreshBars=1`), breakeven a 1 ATR.

#### 🧭 TESI IN UNA RIGA
> _"Un'espansione di volatilità che si esaurisce lascia dentro il mercato chi è
> entrato per ultimo sull'impulso; quando la deviazione standard ritorna sotto
> la sua media e la banda smette di gonfiarsi, quella gente deve uscire — e il
> prezzo torna alla mediana, che è dove sta il nostro TP."_

#### ✅ PERCHÉ NON È UN CADUTO — punto per punto

| caduto | perché questo è un'altra cosa |
|---|---|
| **breakout M5 in apertura** (chiuso 26.07.26) | qui **non c'è nessuna apertura, nessuna sessione, nessun box orario**: il livello nasce da una fase di volatilità, non dall'orologio. E l'ingresso è **contro** l'impulso, non a favore |
| **R45 ORB di sessione** | idem: zero ancore orarie nell'EA |
| **R42/R43 fade dell'estremo** | R42 fadeva il **tocco dell'estremo di un box di 15 minuti**, senza nessuna condizione di volatilità. Qui servono **bulge validato + rientro senza toccare la banda opposta + retest con StdDev in calo**: tre condizioni di stato che R42 non aveva |
| **R95 sweep+reclaim** | lì serve **bucare un livello e rientrarci**. Qui **non c'è nessun livello da bucare**: il grilletto è il retest di una banda che si sta sgonfiando |
| **R60 `ABTG_MeanRevert`** | quello compra il minimo di N barre **senza nessuna condizione di regime** (il "coltello che cade" del `SETACCIO_MANUALE`). Qui il regime **È** il motore: senza bulge validato l'EA non guarda nemmeno il prezzo |
| ⚠️ **"parametri diversi di un motore morto"** | 🟢 **non si applica: il motore NON è morto.** R103 lo misura positivo su 3 simboli su 3 in finestra lunga. Questo è un **ramo non misurato di un motore vivo**, non la rianimazione di un cadavere |

#### 🔬 E COMBACIA CON LA SPECIFICA ESTERNA (§5.1)
Il paper di falsificazione dice che sopravvive solo chi **(a) è condizionato a
un regime** e **(b) tiene 12-15 barre**. Qui **(a)** il bulge **è** la
classificazione di regime, e non è appiccicata: è la porta d'ingresso.
**(b)** è la domanda aperta del round — `InpPostBulgeMaxBars=30` e
`InpBandRidingMaxBars=20` dicono che l'orizzonte c'è; **quante barre duri
davvero un trade a M15 va MISURATO**, ed è il secondo output del PASSO 0.

#### 🚨 I DUE RISCHI, dichiarati PRIMA dei numeri — e il primo può uccidere il round

**1. 💰 IL COSTO. Il TP è la MEDIANA: scendendo di TF, il take si accorcia di
   TF, ma lo spread NO.** Su H1 la semi-ampiezza di banda su GBPUSD è
   dell'ordine di decine di pip; su M15 è **circa la metà** [INFERITO: la
   larghezza di banda scala ~√(rapporto di TF); 4 barre M15 = 1 barra H1 →
   √4 = 2], su M5 **circa un terzo**. Il criterio congelato del mandato
   (**take medio ≥ 3× lo spread tipico**) diventa **il cancello che decide se
   il round esiste**, e va misurato PRIMA, non dopo. Nel sorgente esistono già
   le due valvole per farlo rispettare senza toccare il motore:
   `InpMinTPatATR` (oggi **0.0** = spenta) e `InpMinRR` (oggi **0.0**).
   ⚠️ **Ma non si accendono dentro il round che misura il motore**: prima si
   misura il take medio nudo, poi si decide.

**2. 📏 IL TETTO DELLE 100.000 BARRE.** Misurato in casa e già a verbale
   (`CODA_PROSSIMA_SESSIONE.md`, riga 21): _"il tetto di 100.000 barre, che
   **su M15 vale 4,0 anni**"_. Aritmetica di controllo: forex ≈ 480 barre M15
   a settimana → 100.000/480 = **208 settimane = 4,0 anni**. Su **M5** il
   tetto vale **~1,3 anni**, che è **troppo poco per un IS+OOS da 150
   operazioni ciascuno**. ➡️ **Conseguenza operativa: il round si fa su M15;
   M5 entra solo come cella diagnostica, dichiarata non giudicabile.**

#### 📊 FREQUENZA ATTESA — il numero che giustifica il mandato
GBPUSD H1: **126 operazioni in 6,5 anni = ~19/anno** [VERIFICATO, R103].
Se gli eventi scalano col numero di barre (M15 = 4× H1), a M15 fanno
**~78/anno** → **~310 operazioni in 4 anni**, cioè **~155 per finestra**
IS/OOS. 🟡 **È appena sopra la soglia dei 150 dell'Emendamento della
Finestra, quindi è esattamente il tipo di numero che NON si assume: si
misura al PASSO 0.** [INFERITO dall'aritmetica sopra, **NON MISURATO**]

```
PUNTEGGIO
  [1] semplicità — 82 input è tre volte il nostro tetto. È il difetto vero
      di questo candidato, e non lo nascondo: la mitigazione è che 40 di
      quegli input sono CONGELATI dalla cella viva di R103 e in questo
      round NON si toccano (unico asse: InpTF)
  [2] il filtro È il motore — il bulge è la porta d'ingresso, non un cerotto
  [2] tesi di mercato scrivibile — sopra, e regge
  [2] riempie un BUCO — è IL buco del mandato: forex intraday M15. Oggi la
      flotta forex fa 0,6-3,9 operazioni al MESE per sedia
  [2] testabile senza riscritture — zero righe, InpTF è già un input

VERDETTO   🟢 PROVA SUBITO (9/10)
PERCHÉ     è l'unico modo di rispondere alla domanda di Claudio ("più
           strategie su M5/M15") senza scrivere una riga di codice, su un
           motore che è già positivo 3 su 3 in finestra lunga, e a dirci di
           guardare lì è la fonte del motore stessa.
```

#### 🏛️ RIGA PROP
Motore **event-driven**: entra solo dopo un bulge validato, `InpMaxPositions=1`,
`InpMaxTradesPerDay=0` (nessun tetto). ⚠️ **Il rovescio, e va scritto anche se
è sfavorevole:** scendendo a M15 la frequenza sale **e con lei la
concentrazione giornaliera**, che è il rischio che `METRO_PROP.md` teme
(muro a **−5.000 in una sola giornata** su 100k). Il numero da guardare nel
referto **non è il DD totale: è la PEGGIOR GIORNATA** — la nostra misurata
(R51) è **−2,06%**, e due giornate così sono già metà del cap giornaliero.
🟢 **In compenso la scorrelazione è buona per costruzione:** oggi su GBPUSD
abbiamo PTE (H1) e PunteLarry, entrambe direzionali; questa è
**mean-reversion post-volatilità**, un'inefficienza diversa in un'ora diversa.

---

### 🥈 P2 — `KA-Gold Bot MT5` (Code Base 48251): espansione di canale **dentro** il regime EMA200, sull'oro, sul TF del grafico

```
NOME            KA-Gold Bot MT5
FONTE / URL     https://www.mql5.com/en/code/48251     [SORGENTE SCARICATO E LETTO]
AUTORE          Hung_tthanh@yahoo.com  ·  #property copyright "Copyright 2024"
                [VERIFICATO nell'header del .mq5; la data 2024 è dell'header,
                 la data di pubblicazione della scheda NON l'ho riletta → [INCERTO]]
LICENZA         header di copyright dell'autore. Code Base = download gratuito.
                [INCERTO] licenza esplicita assente
RIGHE / INPUT   619 righe (UTF-16) · **25 righe `input`, di cui 5 sono
                separatori `string`** → **20 input veri**
COSTO DI PORTING  già MQL5 → **0 ore di traduzione**. ~3-4 ore di rifinitura
                  (sizing, SL, gestione).
```

#### ⚙️ MECCANICA — letta nel codice, righe 218-268, non nella descrizione
1. **Il canale (righe 223-231):** banda di Keltner "fatta a mano" —
   `EMA(50)` ± `media(high−low)` sulle ultime 50 barre (funzione `findAvg`,
   righe 275-285). Nessun indicatore custom, nessun `iCustom`.
2. **Il grilletto BUY (righe 251-255), tre condizioni in AND:**
   ```cpp
   if(iClose(_Symbol,PERIOD_CURRENT,1) > upper1) EntryBuy1 = true;   // chiude FUORI
   if(iClose(_Symbol,PERIOD_CURRENT,1) > EMA200_1) EntryBuy2 = true; // regime
   if(EMA10_2 < upper2 && EMA10_1 > upper1) EntryBuy3 = true;        // la EMA10 esce
   ```
   Cioè: **la candela chiude oltre la banda, siamo dal lato giusto della
   EMA200, e la EMA10 (non il prezzo) ha appena attraversato la banda.**
   Il SELL è lo specchio esatto (righe 262-266).
3. **Uscita (righe 300-315):** SL e TP **fissi in "pip"** e **mandati al
   broker** (`m_trade.Buy(lot, sym, price, SL, TP, ...)`), più un trailing a
   trigger (righe 337-380). `isOrder` impedisce più di una posizione.

#### 🧭 TESI IN UNA RIGA
> _"L'oro passa la maggior parte del tempo dentro il suo canale di volatilità;
> quando esce dal lato in cui punta la media di lungo, non è rumore, è
> riposizionamento — e la EMA10 che segue il prezzo fuori dalla banda è la
> prova che il movimento ha corpo, non è uno spike."_

#### ✅ PERCHÉ NON È UN CADUTO, E PERCHÉ NON È UN DOPPIONE

| confronto | esito |
|---|---|
| **breakout M5/ORB di sessione** (chiuso) | 🟢 **diverso**: nessuna ancora oraria nel motore. Il filtro `InpTimeFilter 02:30-21:00` è una fascia larghissima, non un evento |
| **mean reversion intraday sull'oro** | 🟢 **è l'OPPOSTO.** Quella è già stata **falsificata dalla letteratura** e messa a verbale il 23/08 (`SWEEP_MECCANISMI_2026-08-23.md` §S15: OU su micro gold futures, tutte le configurazioni FAIL, T da −1,12 a **−4,49**). Questo compra l'**espansione**, non il ritorno |
| **`ABTG_EMA200` (XAUUSD, magic 971501)** | 🟢 **geometria opposta, non doppione.** Il nostro EMA200 è un **rimbalzo SULLA media con ordini LIMITE** (header righe 7-10: _"quando il prezzo ritraccia verso la media, si piazzano ordini pendenti LIMITE"_). Questo entra **a mercato quando il prezzo si ALLONTANA**. Uno compra il ritracciamento, l'altro l'espansione: sono **naturalmente scorrelati** |
| **`ABTG_SuperWave` sull'oro** (morto: _"l'oro rende col SupRev, non col cross"_) | 🟡 **adiacenza dichiarata**: SuperWave è un **incrocio di due medie** confermato dal Supertrend; qui il grilletto è **l'uscita da una banda di volatilità**. Meccanismo diverso, ma **stessa famiglia concettuale (trend/espansione)** — il carico della prova sta su chi propone, e sono io |
| **filtro appiccicato (0/5)** | 🟢 **la EMA200 è costitutiva**: senza di lei l'EA non ha direzione. È la forma di `ABTG_EMA200` Dow, R29, **30 celle su 30 a PASS pieno** |

#### 💰 COSTO — il conto, con i numeri, e il buco che resta
`OnInit()` righe 91-99: se `_Digits` è **pari** (XAUUSD → 2), allora
`Pips2Double = _Point = 0,01`. Quindi:
- **TP = `InpTP_Pips` 500 × 0,01 = 5,00 USD di oro.** SL uguale (R:R **1:1**).
- Guardia spread dell'autore: `InpMax_spread = 65` punti = **0,65 USD**.
- Criterio del mandato (take ≥ 3× spread): **5,00 ≥ 3 × spread** → passa
  finché **lo spread BCM sull'oro sta sotto 1,67 USD**.

🔴 **E qui c'è il buco che dichiaro invece di riempirlo: LO SPREAD BCM
SULL'ORO NON È MISURATO IN REPO.** Ho cercato: `report/VIVAIO_ORO_DEPLOY.md`
dice solo _"lo spread notturno dell'oro dal vivo può..."_, senza un numero.
**Nessun file del repo contiene una misura dello spread XAUUSD di BCM.**
➡️ **Questo è il cancello zero S0 del round**, e lo strumento per chiuderlo è
già stato promosso il 23/08 e mai usato: **`RealCost Spread P95 Logger MT5`**
([Code Base 74148](https://www.mql5.com/en/code/74148)), che dà media, p50,
p90, **p95**, p99 e massimo. **E il numero da usare è il p95, non la media**
(lezione R55: lo spread si legge in **percentuale dello stop**).

#### 🔧 COSA TERREI / COSA RIFAREI — la separazione che chiede il §5F

**🟢 DA TENERE (il motore, ~50 righe):** la banda di Keltner artigianale
(`findAvg` + EMA50), la **tripla condizione in AND** con la EMA200
costitutiva, la conferma sulla **EMA10 che esce dalla banda** (è ciò che
distingue un corpo da uno spike), una posizione alla volta, decisione su
**barra chiusa** (`iClose(...,1)`, mai la barra 0 → **niente look-ahead**).

**🔧 DA RIFARE (la gestione — cioè la parte che sappiamo fare):**

| difetto, con la riga | perché morde | cosa ci mettiamo |
|---|---|---|
| 🔴 `CalculateVolume()` righe **437-440**: `LotSize = InpRisk * FreeMargin / 100000` | **NON è rischio per operazione**: è **lotti per ogni 100k di margine libero**. Il rischio vero dipende interamente dall'SL fisso, e **cambia da solo se cambia l'SL**. Non è confrontabile coi nostri | **rischio 0,65% dell'equity calcolato SULLA DISTANZA DELLO STOP**, come tutte le nostre sedie |
| `InpSL_Pips = 500` fisso (righe 301, 315) | scollegato dalla volatilità: nel 2013 e nel 2020 lo stesso numero vuol dire due rischi diversi | **SL in ATR** (o strutturale oltre la banda opposta) |
| `InpTP_Pips = 500`, R:R **1:1** secco | nessuna gestione, nessun runner | **parziale 1R + breakeven + runner a 2R** (le nostre DAX/Dow) |
| 🐛 riga **266**: `if(EntrySell1 && EntrySell2 && EntrySell3) result = true;` | **scrive `true` in una `ENUM_ORDER_TYPE`.** Funziona **per caso** (`true`=1=`ORDER_TYPE_SELL`), ma è il tipo di riga che si rompe alla prima modifica. **Da correggere prima di misurare** | `result = ORDER_TYPE_SELL;` |
| `InpMax_spread` in **punti fissi** (riga 36) | R55: lo spread va letto in **% dello stop** | il nostro filtro standard |
| `OpenTrades(Signal)` chiamato a ogni barra anche con `Signal = -1` (righe 202, 207) | **non è un bug operativo** (dentro `OpenTrades` il `-1` non fa nulla), ma è codice che lavora a vuoto | guardia esplicita |

```
PUNTEGGIO
  [1] semplicità — 20 input veri, sopra il tetto di ~15 ma non di molto;
      619 righe di cui ~50 di logica
  [2] il filtro È il motore — la EMA200 è costitutiva, non opzionale
  [2] tesi di mercato scrivibile — sopra
  [2] riempie un BUCO — oro intraday M15 (oggi abbiamo SOLO oro H4/swing),
      e con geometria OPPOSTA a quella di ABTG_EMA200 già in flotta
  [2] testabile senza riscritture — MQL5, zero dipendenze, gira su Period()

VERDETTO   🟢 PROVA SUBITO (9/10), MA DIETRO IL CANCELLO ZERO SULLO SPREAD
PERCHÉ     è l'unico EA gratuito col sorgente, trovato in 1.597 titoli, che
           porta sull'oro un motore intraday sano e non è una griglia.
```

#### 🏛️ RIGA PROP
⚠️ **Il rischio vero di questo candidato non è il motore: è la
CONCENTRAZIONE.** `FLOTTA_ATTIVA.md` dice _"Concentrazione ORO altissima"_
(**12 grafici** sull'oro), e R100 ha già costretto a tagliare tre sedie oro
(`PunteLarry` a 0,3%, `EMA200` a 0,25% con **"prop: NO a nessuna taglia"`).
➡️ **Se questo candidato passa, non entra "in più": entra al posto di
qualcosa, oppure a taglia ridotta.** La domanda da porre nel referto non è
"quanto guadagna", ma **"il suo DD si somma o si compensa con quello delle
sedie oro già accese?"** — e la risposta si legge sulle serie per-trade,
non a occhio. 🟢 L'argomento a favore c'è ed è geometrico: comprando
l'espansione dove `ABTG_EMA200` compra il ritracciamento, **le due dovrebbero
perdere in giorni diversi**. È un'ipotesi, e come tale va misurata.

---

### 🥉 P3 — `DayFlow VWAP Relay — Majors` (TradingView, Pine letto): **un ROUTER DI REGIME, e stavolta le statistiche sono riproducibili**

```
NOME            DayFlow VWAP Relay — Majors   (shorttitle "DayFlow Relay")
FONTE / URL     https://www.tradingview.com/script/muhhiXQs-DayFlow-VWAP-Relay-Forex-Majors-Strategy/
                PINE SCARICATO E LETTO (6.593 byte di JSON, 135 righe di Pine)
AUTORE / DATA   © exlux · `created` 2025-11-03T13:30:58Z · `scriptAccess`
                **open_no_auth**  [VERIFICATO nel JSON del pine-facade]
LICENZA         🟢 **Mozilla Public License 2.0**, dichiarata nella riga 1 del
                sorgente. È l'unico candidato di tutta la caccia con una
                licenza esplicita.
RIGHE / INPUT   135 righe Pine · **12 input operativi** (+2 di sola grafica)
                → 🟢 **sotto il nostro tetto di ~15**
COSTO DI PORTING  🔴 **Pine → MQL5 NON è un porting, è una RISCRITTURA.**
                  Stimate **6-10 ore** (EA d'agente + collaudo). È il prezzo
                  vero di questo candidato, e non lo sconto.
```

#### ⚙️ MECCANICA — letta nel Pine, non nella descrizione

**Il cuore non è un segnale: è un INTERRUTTORE.**
```pine
expansion = ta.stdev(resid, sig_len) / math.max(1e-10, ta.stdev(close, sig_len))
balanced_day = expansion <  exp_gate      // 0.65
trend_day    = expansion >= exp_gate
```
dove `resid = close − vwap_giornaliero`. Cioè: **quanto della volatilità del
prezzo è "scostamento dal VWAP" e quanto è "movimento del VWAP stesso"**.

- **Giornata BILANCIATA** (`expansion < 0,65`) → **si FADE**: long quando il
  residuo scende sotto il **25° percentile** delle ultime 63 barre, short
  sopra il **75°**.
- **Giornata di TREND** (`expansion ≥ 0,65`) → **si segue la ROTTURA** della
  banda VWAP, **ma solo se la pendenza del VWAP (linreg a 63) è concorde**.
- **In entrambi i casi** serve la conferma di **micro-flusso**: si leggono le
  barre M1 dentro la barra appena chiusa e si conta quante salgono e quante
  scendono (`micro_flow`, righe 60-72); serve `|mf| > 0,20`.
- **Geometria:** SL **1,2 × ATR(14)**, TP **1,8 × ATR(14)** → R:R **1,5**.
  Sessione **07:00-17:00 UTC**. **Cooldown di 10 barre** dopo ogni chiusura.

#### 🧭 TESI IN UNA RIGA
> _"In una giornata in cui il prezzo oscilla ATTORNO al VWAP il flusso è
> bilanciato e gli estremi si pagano tornando indietro; in una giornata in cui
> è il VWAP stesso a muoversi, il flusso è a senso unico e gli estremi si
> pagano andando avanti. La stessa distanza dal VWAP vuol dire due cose
> opposte, e il rapporto fra le due deviazioni standard dice quale."_

#### 🎯 PERCHÉ È IL CANDIDATO CHE MANCAVA — tre motivi, in ordine

**1. È esattamente la specifica di P4, ma con statistiche RIPRODUCIBILI.**
Il paper di falsificazione dice che sopravvive solo chi **classifica un
regime**; il suo `London Signal B` lo fa con un **GMM che non possiamo
replicare**. Qui la classificazione è **un rapporto fra due deviazioni
standard e un percentile mobile**: si scrive in MQL5 in venti righe, senza
addestrare niente. 🎯 **È il ponte fra la specifica e il codice.**

**2. Il filtro NON è appiccicato: È il motore, ed è nella forma più forte che
conosciamo.** Non decide *se* entrare: decide **DA CHE PARTE** entrare.
Spegnere il regime non rende l'EA più permissivo — **lo rende senza
direzione**. È la stessa forma di `ABTG_EMA200` Dow (R29, **30 celle su 30 a
PASS pieno**), e l'opposto dei cinque filtri appiccicati che fanno **0/5**.

**3. 💰 IL COSTO SI CALCOLA, e passa con margine.** TP = **1,8 × ATR(14)** su
M15. Su GBPUSD l'ATR(M15) è dell'ordine di **8-12 pip** [INFERITO, da
misurare] → **TP ≈ 15-22 pip contro ~1 pip di spread = 15-22×**. Il criterio
del mandato chiede **≥3×**. 🟢 **È l'unico candidato della caccia in cui il
cancello del costo si legge PRIMA di girare, perché la geometria è in ATR e
non in una mediana che si accorcia col timeframe.**

#### ✅ PERCHÉ NON È UN CADUTO — e dove invece si avvicina, dichiarato

| caduto | confronto |
|---|---|
| **R42/R43 — fade degli estremi** | 🟢 R42 fadeva **l'estremo di un box di 15 minuti**, sempre, senza condizioni. Qui il fade **scatta solo nel regime bilanciato** e l'estremo è un **percentile del residuo dal VWAP** su 63 barre, non un massimo |
| **R60 — `ABTG_MeanRevert`** | 🟢 quello compra il minimo di N barre **senza nessuna condizione di stato**. Qui senza `balanced_day` il ramo fade non esiste |
| **capitolo BREAKOUT M5 / R45** | 🟡 **il ramo `trend_day` È un breakout**, e questo va detto. Ma (a) non è un breakout **di sessione** né di un box d'apertura: è la rottura di una banda VWAP con la pendenza concorde; (b) è **la metà** del motore. ➡️ **Conseguenza operativa: i due rami vanno misurati SEPARATI prima del combinato**, come abbiamo fatto per `InpPatternMode` del BreakingBand. Se il ramo breakout è il solito cadavere, si tiene il router col solo ramo fade e **si dichiara** |
| **R101 gradino 07 — VWAP di sessione** | 🟡 **adiacenza vera, e la nomino.** R101 ha misurato il VWAP **come filtro direzionale appiccicato al motore Aperture** su indici, e l'ha bocciato. **Qui il VWAP non è un filtro: è l'ANCORA rispetto a cui si misura il residuo**, e il verso lo decide il rapporto di deviazioni. Uso diverso, mercato diverso. **Ma se qualcuno legge "VWAP" e diffida, ha ragione a chiedere il conto: il carico della prova sta su chi propone** |

#### 🚨 I TRE LIMITI, dichiarati PRIMA dei numeri

1. 🔴 **IL VOLUME.** `ta.vwap` è **pesato sul volume**, e su forex MT5 dà
   **tick volume**, non contratti (`REGISTRO_TEST.md`, regole Paolo:
   _"Volumi affidabili SOLO sugli indici, NON sulle valute"_). ➡️ **Il VWAP
   che costruiremmo NON è il VWAP del paper: è un VWAP pesato sul numero di
   variazioni di prezzo.** Va scritto nel referto, e **c'è una variante di
   controllo gratuita**: la stessa macchina con ancora **TWAP** (media
   temporale, nessun volume). Se il router regge anche col TWAP, il volume
   non serviva; se muore, sappiamo che dipendeva da un dato inaffidabile.
   **Questa è la cella di controllo del round, e va congelata prima.**
2. 🟡 **Il micro-flusso legge le barre M1 dentro la barra M15.** L'autore ne è
   consapevole (`int last = math.max(1, n - 1)  // exclude freshest element`)
   e la strategia gira con **`process_orders_on_close=true`** e
   **`calc_on_every_tick=false`** — cioè **niente ripittura da ricalcolo a
   tick**, che è la trappola §4 di TradingView. In MQL5 diventa banale e
   **senza alcun look-ahead**: si contano le 15 barre M1 della candela M15
   appena chiusa. [INFERITO dalle righe 60-72 e dall'header `strategy(...)`]
3. 🟡 **Il sizing è `default_qty_value=3` = 3% dell'equity in NOZIONALE**, non
   rischio per operazione. È la solita **gestione da rifare**, ed è la parte
   che sappiamo fare: **0,65% dell'equity calcolato sulla distanza dello
   stop**, parziale 1R + breakeven + runner.

```
PUNTEGGIO
  [2] semplicità — 12 input veri, sotto il tetto; 135 righe leggibili
  [2] il filtro È il motore — il regime non filtra: ROUTA. Forma R29
  [2] tesi di mercato scrivibile — sopra, ed è la migliore della giornata
  [2] riempie un BUCO — forex majors M15 con un motore SIMMETRICO vero
      (long e short dallo stesso codice) e una fascia oraria 07-17 UTC
  [1] testabile senza riscritture — NO: Pine -> MQL5 è una riscrittura,
      6-10 ore. È l'unico punto dove perde

VERDETTO   🟢 PROVA (9/10), ma TERZO IN CODA per costo di sviluppo
PERCHÉ     è l'unico oggetto trovato in cinque cacce che implementa la
           specifica del paper di falsificazione (regime costitutivo +
           orizzonte lungo) con statistiche che sappiamo riscrivere.
```

#### 🏛️ RIGA PROP
🟢 **Il `cooldown = 10` barre è già un freno alla concentrazione
giornaliera** — è raro che un EA gratuito ce l'abbia, ed è esattamente ciò
che `METRO_PROP.md` chiede (muro giornaliero −5% su 100k). Su M15, 10 barre =
**2,5 ore di silenzio dopo ogni chiusura** → al massimo ~4 operazioni nella
finestra 07-17. 🟢 **Ed è un motore simmetrico**, cioè il buco più vecchio del
portafoglio (`R52_CENSIMENTO_LATI.md`: 4 titolari su 5 girano su un lato solo).
⚠️ **Il rovescio:** nel ramo `trend_day` prende posizioni **nella stessa
direzione del mercato**, quindi nelle giornate di trend forte **è correlato
alle nostre sedie long**. La scorrelazione va misurata sulle serie per-trade,
non sperata.

---

### 4️⃣ P4 — `London Session Signal B` (arXiv 2605.04004 §5.2): **la SPECIFICA che P3 realizza** — 🟡 IN CODA

```
NOME     "London Session Signal B (R0 to R2 Transition)"
FONTE    Mesfin (2026), "Structural Limits of OHLCV-Based Intraday Signals
         in MNQ Futures: A Systematic Falsification Study"
URL      https://arxiv.org/abs/2605.04004   (v2, 8 pagine)
         PDF SCARICATO (1.130.529 byte) ed ESTRATTO (34.007 caratteri).
         §5.2 letto per intero e citato sotto parola per parola.
```

#### ⚙️ MECCANICA, testuale dal PDF §5.2 [VERIFICATO]
> _"London Signal B fires when the GMM regime classifier on **15-minute London
> session bars (03:00–08:30 ET)** detects a clean transition from **Regime 0
> (Bearish Chop) to Regime 2 (Bullish Drift)** with **no Regime 1
> contamination in the prior two bars**. Entry is **long at the next
> 15-minute bar open**. Exit is **60 minutes later or at 08:30 ET**, whichever
> comes first."_

**I numeri dell'autore — [DICHIARATI, NON MISURATI DA NOI], tabella 10:**
289 operazioni · netto medio +5,77 punti · **T = 5,15** · win rate 64,7% ·
**PF 2,42** · Sharpe 5,09 · permutation p < 0,001 · sensibilità ai parametri
T da 3,87 a 4,83 su **tutte** le varianti.

#### 🎯 PERCHÉ È IN TABELLA — e perché NON è promosso oggi

🟢 **Perché conta:** è **l'unico meccanismo intraday M15 che ho trovato in
tutta la caccia con una validazione avversariale seria alle spalle** — viene
dallo stesso documento che ha **bocciato quattordici famiglie di segnali**,
compresa quella dell'autore stesso. E la forma è quella che il §5.1 indica
come l'unica sopravvissuta: **M15 · regime costitutivo · 4 barre di tenuta ·
una sessione**.

🎯 **E il motivo per cui resta in tabella anche se non parte: P3 È QUESTA
SPECIFICA, SCRITTA CON STATISTICHE CHE POSSIAMO RIPRODURRE.** Le due voci non
competono — la prima dice *quale forma sopravvive*, la seconda è l'unico
oggetto leggibile che quella forma ce l'ha. **Se P3 andasse bene, questa riga
sarà la ragione per cui ci abbiamo creduto prima di misurare; se andasse male,
sarà la prova che la forma da sola non basta.** In entrambi i casi vale
tenerla scritta.

🔴 **Perché NON parte adesso, e sono tre motivi indipendenti:**
1. **Il classificatore è un GMM (Gaussian Mixture Model) e il paper NON dà né
   le feature né i parametri stimati.** Non è "difficile da portare": **non è
   riproducibile.** Sostituirlo con un nostro Supertrend/EMA sarebbe
   **inventare un meccanismo e attribuirlo a una fonte**, che è precisamente
   ciò che il §1 del mio mandato vieta.
2. 🚨 **Il paper stesso dichiara la fragilità che ci riguarda di più:**
   _"1-bar delay reversal **T = −3.56 (edge destroyed)**"_. **Un ritardo di UNA
   barra M15 non degrada il segnale: lo ribalta.** Su un motore così, la
   differenza fra OHLC e tick reali non è un dettaglio — è tutto. E noi quella
   lezione l'abbiamo già pagata (`REGISTRO_TEST.md` §2).
3. **È misurato su MNQ (Nasdaq futures), non su forex né oro.** Portarlo su
   GBPUSD è un'ipotesi in più, non una traduzione.

🕐 **L'ora in ora server, e la dichiaro invece di tacerla:** 03:00–08:30 **ET**
= 09:00–14:30 ora italiana = **08:00–13:30 ora server BCM**
[INFERITO da `CLAUDE.md` "server BCM = ora italiana − 1" + ET = CET − 6].
⚠️ **Il salto di ora legale USA/EU non coincide in due finestre all'anno: se
un giorno questo candidato dovesse partire, l'ora va MISURATA sull'orologio
del server, non derivata.**

```
PUNTEGGIO   9/10 sull'IDEA · 🟡 IN CODA sull'ESEGUIBILITÀ
VERDETTO    non si scrive un file prova finché qualcuno non porta una
            classificazione di regime RIPRODUCIBILE. Come sta, è cultura
            di prima qualità e una specifica di progetto — non un round.
```

---

## 3. 🗑️ GLI SCARTATI — uno per riga, col motivo che li prova

### 3.1 Scartati per **bandiera rossa §4 nel sorgente**

| # | candidato | fonte | la riga che lo prova |
|---|---|---|---|
| S1 | **`Multi-currency night scalper — Night Scalper Multi`** | [Code Base 16350](https://www.mql5.com/en/code/16350) — sorgente letto (UTF-16), AM2 / forexsystems.biz | 🔴 **TRIPLO.** (a) `input double Lot = 1;` → **lotto fisso**, non scalabile a 100k. (b) La geometria: `StopLoss1=370` contro `TakeProfit1=20` → **R:R 0,054**, cioè si rischiano 37 pip per prenderne **2**. (c) **Take 2,0 pip contro uno spread tipico di ~1 pip = 2× lo spread**: sotto il criterio congelato del mandato (**≥3×**). **È l'esempio da manuale di ciò che il cancello del costo esiste per fermare.** |
| S2 | **`OHLCMTF Scalper EA - Multi-Timeframe Price Action`** v8.0, Amanda V | [Code Base 70796](https://www.mql5.com/en/code/70796) — sorgente letto per intero (143 righe) | 🔴 **`input double Fixed_Lot = 0.1;`** e **nessun tetto alle posizioni**: `OnTick` chiama **due** blocchi di logica per barra (`CheckTradingLogic(H1,H4,D1)` + `CheckTradingLogic(M5,H1,H1)`, righe 62-63) e ogni segnale apre. **Posizioni che si accumulano senza cap = averaging di fatto.** In più il segnale è `high[1] > high[2] && high[1] > highTF[1]` (riga 74) — banale — e **4 input su 21 non sono mai referenziati nel codice** (`Look_Back_Bar`, `Look_Forward_Bar`, `Buy_Cond_1`, `Sell_Cond_1`): manopole finte. |
| S3 | **`MA + Envelope Breakouts`** (`FC_Env Breakout.mq5`) | [Code Base 74815](https://www.mql5.com/en/code/74815) — sorgente letto | 🔴 `input int risk_percent = 99;` più `input bool cycle1/cycle2/cycle3` e `LotSize = 0.01`: **rischio al 99% e una struttura a "cicli"**. Non ho nemmeno letto oltre: il §4 non si ammorbidisce. |
| S4 | **`openea` / FxChartAI AI-Agent Trading EA** | [GitHub `abiodunaremu/openea`](https://github.com/abiodunaremu/openea) — README letto per intero via `raw` (10.127 byte) | 🔴 **Il segnale arriva da un servizio esterno via API**: _"Retrieves live signals from FxChartAI API via GET requests"_. È **`WebRequest` + scatola nera di terzi**: §4 lo vieta, e non è nemmeno backtestabile. |

### 3.2 Scartati perché **è il motore morto con un'altra scatola**

| # | candidato | fonte | perché è fuori |
|---|---|---|---|
| S5 | **`ExMachina SafeScalping`** (William Mukam) | [Code Base 70052](https://www.mql5.com/en/code/70052) — sorgente letto, 575 righe, **45 input** | 🔴 **Il motore è la rottura del massimo/minimo a N barre** (`InpBreakoutLookback=20` + buffer ATR) **con CINQUE filtri sopra** (EMA150/510, forza del trend in ATR, posizione vs medie, banda RSI 40-65, momentum). È **letteralmente** lo schema che in casa fa **0 successi su 5** (R20, R12, R26, R45, R54), su una famiglia già chiusa. 🟢 **Onestà: è il codice meglio scritto della giornata** — dichiara in header _"No martingale. No grid. No hedging. No recovery logic."_, ha breakeven, pausa su drawdown, filtro spread e sessione. **Ma la buona idraulica non salva un motore già sepolto**, e 45 input sono tre volte il nostro tetto. |
| S6 | **`ASQ Safe Scalping v1.20`** | [Code Base 71189](https://www.mql5.com/en/code/71189) — sorgente letto, 350 righe, **53 input** | 🔴 Stesso autore, stessa famiglia, **53 input**. Fuori per meccanismo **e** per conto dei parametri. |
| S7 | **`Long-Only Trend Breakout with Dynamic Risk Management`** | [Code Base 73638](https://www.mql5.com/en/code/73638) — sorgente letto | 🔴 Breakout (famiglia chiusa) **e** `input double InpRiskAmount = 20.0; // Fixed Currency Amount to Risk` → **importo fisso in valuta**, che a 100k è lo stesso identico problema del lotto fisso. |
| S8 | **`Session Opening Range Breakout EA`** · **`GoldLondonBreakout`** · **`Easy Range Breakout`** · **`Universal Breakout Study`** · **`Range BreakOut EA`** | Code Base 76153, 75586, 68764/71460, 73711, 26451 | 🔴 **GIÀ SETACCIATI E SCARTATI** (16/08 `SETACCIO_MANUALE.md`, 19/08, 21/08, 23/08). Ciò che è setacciato non si ricontrolla. |
| S9 | **`Daily Price Action EA`** (`PriceActionDayTrader`) | [Code Base 68704](https://www.mql5.com/en/code/68704) — sorgente letto, 1.237 righe, **29 input** | 🔴 **Non ha UNA tesi, ne ha TRE in OR** (righe 250-264): pin bar, engulfing, inside bar, ciascuna con le sue soglie, più medie e S/R. **È l'ottimizzatore a decidere quale sia la tesi** — lo stesso identico motivo per cui il 22/08 abbiamo scartato `003 - Weekly Day Reversal` (_"li mette fra gli input e lascia scegliere all'ottimizzatore SE la tesi è ribaltamento o continuazione"_). In più `StopLossPips = 40` **fisso**, non in ATR. 🟢 Va detto che il rischio **è** in percentuale e c'è un cap di perdita giornaliera: l'idraulica è decente, la tesi no. |
| S10 | **`Trend Momentum EA`** · **`QuickTrend Scalper`** · **`Probability Theory EA`** | Code Base 68512, 52105, 49770 — sorgenti letti | 🔴 Tre incroci di indicatori da manuale (EMA50/200+RSI+Stoch · RSI(6)+MA(2) · lotto 0,1 + `Risk = 2`). **Nessuna tesi di mercato scrivibile in una riga** → §5C. |
| S11 | **`PriceChannel_Signal_v2 EA`** | [Code Base 39012](https://www.mql5.com/en/code/39012) | 🔴 **Donchian breakout con indicatore custom allegato** — famiglia chiusa, e in più dipende da un `.mq5` di indicatore da compilare a parte. |

### 3.4 🆕 Scartati su **TRADINGVIEW** — cinque Pine letti riga per riga

_Fonte riaperta a caccia in corso (§1-bis). **203 strategie raccolte, 7
aperte, 6 Pine letti, 1 promosso (P3), 5 scartati.** Ecco i cinque._

| # | script | autore / data | meccanismo | la riga che lo prova |
|---|---|---|---|---|
| S16 | **`Konigs \| Bollinger Band Mean Reversion (Session Filter)`** | [`4wUJnYSD`](https://www.tradingview.com/script/4wUJnYSD-Konigs-Bollinger-Band-Mean-Reversion-Session-Filter/) · created **2026-01-20** · 41 righe | long sotto la banda inferiore, short sopra la superiore, uscita sulla mediana, dentro una sessione | 🔴 **NESSUNO STOP LOSS. Nemmeno virtuale.** Le uniche uscite sono `strategy.close` sulla mediana: **una posizione contro un trend resta aperta all'infinito.** §4, prima riga della tabella. E il motore è **R60 senza nemmeno il regime**: il "coltello che cade" del `SETACCIO_MANUALE.md` |
| S17 | **`VWAP Mean Reversion Strategy v6`** | [`9SEB7IHb`](https://www.tradingview.com/script/9SEB7IHb-VWAP-Mean-Reversion-Strategy-Range-Bound-Forex-RSI-Volume/) · created **2026-03-29** · 116 righe | fade a 2 deviazioni assolute pesate sul volume da una media mobile volume-ponderata a 60 barre, con RSI < 25 / > 65 | 🔴 **LO STOP NON STA FERMO.** `strategy.exit(..., stop = close * (1.0 - stopLossPct))` è dentro un `if strategy.position_size > 0` che gira **a ogni barra**: lo stop viene **ricalcolato sul `close` corrente**, quindi **insegue il prezzo anche mentre scende**. Non è un trailing: è uno stop che scappa. Più `default_qty_value = 10` (10% dell'equity in nozionale, nessun rischio per operazione). 🟢 **Un pezzo da rubare, però, e lo scrivo:** il filtro volume è **invertito** rispetto all'ovvio — `volCondition = not extremeVol` → **NON si fa il fade quando il volume è oltre 3× la media.** È una regola anti-spike da notizia, ed è sensata |
| S18 | **`MACD Volume Strategy for XAUUSD (15m)`** | [`k2ynWI6q`](https://www.tradingview.com/script/k2ynWI6q-MACD-Volume-Strategy-for-XAUUSD-15m-PineIndicators/) · PineIndicators · created **2025-02-21** · 85 righe | incrocio MACD sullo zero + oscillatore di volume + confronto `volume` vs `volume[1]/2`, su oro M15 | 🔴 **TRE motivi.** (a) `qty = strategy.equity * leverage / close` → **il 100% dell'equity a ogni operazione**. (b) `t = 10100` — **un numero magico** usato come `profit=t*1.1, loss=t` in tick: la geometria dell'intero EA è una costante senza nome e senza tesi. (c) Il segnale short pretende `osc > 0` **esattamente come il long** (righe 36-38): o è un refuso o è una regola che non si sa spiegare. Più il volume su un CFD non regolamentato (§S13) |
| S19 | **`Reverse Keltner Channel Strategy with ADX`** | [`Mbu0HmHZ`](https://www.tradingview.com/script/Mbu0HmHZ-Reverse-Keltner-Channel-Strategy/) · @fenyesk · created **2025-05-03** · 86 righe | il prezzo esce dal canale di Keltner e **rientra** → si entra, TP sulla banda opposta, SL a metà canale | 🔴 **LA TESI È UN INPUT.** `weakTrendOnly = input.bool(true, "Enter Only in Weak Trends")`: se `true` entra con ADX < 25, se `false` con ADX ≥ 25. **È l'ottimizzatore a decidere se la strategia è "mean reversion nel laterale" o "continuazione nel trend"** — identico al motivo per cui il 22/08 abbiamo scartato `003 - Weekly Day Reversal`. In più è **ADX appiccicato** (0/5 in casa) e `default_qty_value=100`. 🟢 **Osservazione tenuta agli atti:** la geometria "rientro nel canale, TP alla banda opposta" è la **cugina simmetrica di P2** (che compra l'uscita). Se P2 passasse, questa è la prima variante da provare — **come cella, non come EA** |
| S20 | **`Swing trading strategy FOREX` (BB+RSI, 15min)** | [`9eBjGz5d`](https://www.tradingview.com/script/9eBjGz5d-Swing-forex-strategy-15min/) · created **2021-08-02** · 82 righe | incrocio RSI(6) + rottura della banda di Bollinger(200) | 🔴 **NESSUNA USCITA: le due righe `strategy.exit` sono COMMENTATE** (righe 78-79 del sorgente). La posizione si chiude solo quando arriva il segnale opposto. **Nessuno stop, nessun target, orizzonte indefinito.** §4 |
| S21 | `15 Minute Gold Trend-Following Strategy` | [`9morbD5t`](https://www.tradingview.com/script/9morbD5t-15-Minute-Gold-Trend-Following-Strategy/) | — | ⬜ **NON VALUTATO, non scartato.** La pagina **non contiene l'identificatore `PUB;<hash>`** e il pine-facade non è raggiungibile senza. **Non ho letto una riga di Pine**, e per la regola §1 del mandato quindi **non esiste**. Era in pieno bersaglio (oro, 15 minuti): è il buco più fastidioso di questa caccia |

### 3.3 Le piste del mandato che ho dovuto **CHIUDERE**, e con quali prove

| # | pista del mandato | verdetto | le prove |
|---|---|---|---|
| **S12** | **Pista 2 — liquidity sweep / raid dei massimi-minimi di sessione (fade)** | 🔴 **CHIUSA, con due prove indipendenti** | **(a) In casa:** `R95_REFERTO.md`, 23/08: **30 passate su 30 in perdita** su EURJPY, PF 0,65-0,80, su **tutti e cinque** i timeframe provati (M30→H4), con n da 149 a 3.641 — _"non c'è altopiano da cercare"_. **(b) Fuori:** arXiv 2605.04004 §4.3, *Asia Session Liquidity Grab Reversal*, **6.442 eventi**, netto medio **−2,20 punti**, **T = −14,12**. Non è "non funziona": è **negativo con una statistica enorme**. ⚠️ Nota di trasparenza: resta pendente il candidato `DataTraderH4Breakout` ([68082](https://www.mql5.com/en/code/68082)), **promosso il 21/08 e mai trasformato in un round**. **Non lo ri-promuovo**: la sua famiglia ha preso due colpi il 22 e il 23/08, DOPO quella promozione. Se qualcuno lo riapre, deve prima spiegare perché un box di 4 ore sia diverso dai livelli che R95 ha bocciato. |
| **S13** | **Pista 5 — meccanismi volume-confermati su forex e oro** | 🔴 **NON TRADUCIBILE su questi simboli** | **(a)** `REGISTRO_TEST.md` §REGOLE PAOLO: _"**Volumi affidabili SOLO sugli indici** (regolamentati), **NON sulle valute**"_ — su forex e su CFD MT5 dà **tick volume** (numero di variazioni di prezzo), non contratti. **(b)** arXiv 2605.04004 §4.5, quattro varianti di *volume signature*: n da 723 a 2.409, netto **−1,94…−2,50**, **T ≈ 0** — _"nulli precisi, non inconcludenti"_. 🟢 **Il candidato `02_volumi` di R101 resta valido dov'è nato — sugli INDICI.** La convergenza col corso del 24/08 è reale e riguarda l'ORB del DAX: **non si esporta sul forex**, e questa riga esiste perché nessuno provi a farlo. |
| **S14** | **Pista 4 — momentum/continuazione di sessione NY su M15** | 🔴 **CHIUSA fino a prova contraria** | `R98_REFERTO.md`: **0/6**, cancello zero **matematicamente impossibile** (−0,31 punti indice per operazione su 410, già al netto dello spread). E il 23/08 la regola è stata scritta nero su bianco (`SWEEP_MECCANISMI_2026-08-23.md` §S5): _"spostare lo stesso motore sul Dow è «parametri diversi di un motore morto» con un simbolo al posto di un parametro. Se qualcuno lo vuole riaprire, deve prima portare una **ragione economica** per cui sia diverso"_. **Per l'oro e per il forex quella ragione economica non ce l'ho**, e non la invento. |
| **S15** | **Pista 3 — oro: mean reversion / pullback intraday** | 🟡 **METÀ chiusa, metà coperta** | La **mean reversion** intraday sull'oro è **già falsificata a verbale** (23/08 §S15: OU su micro gold futures, tutte FAIL, T da −1,12 a −4,49, con l'argomento strutturale: _"the 60-minute signal's mean-reversion half-life works out to roughly 8 hours — longer than a single RTH session"_). Il **pullback con conferma** invece **ce l'abbiamo già** ed è `ABTG_EMA200` XAUUSD (rimbalzo sulla EMA200 con ordini limite) — che però R100 ha ridotto a **0,25%** con la nota **"prop: NO a nessuna taglia"** (DD 45,91% a rischio 1% su 22 anni). ➡️ **Sull'oro il buco non è "un pullback": è un motore con geometria DIVERSA da quello che abbiamo. È esattamente P2.** |

---

## 4. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| non visto | conseguenza concreta su questo dossier |
|---|---|
| 🟢 **TradingView: RIAPERTA** (era il buco storico) | **Non è più un buco.** 203 strategie raccolte, 6 Pine letti, **1 promosso (P3)**. ⚠️ **Ma resta un buco parziale:** su 7 script provati **1 non ha reso l'hash `PUB;`** e non l'ho letto (S21, ed era oro a 15 minuti). E **197 delle 203 strategie raccolte NON le ho aperte**: ho letto le sette in bersaglio. **Il giacimento è appena stato scoperto, non esaurito** |
| 🔴 **Ricerca GitHub (403 su `/search`, `/topics`, e persino sulla pagina di un repo pubblico)** | Canale chiuso. Leggo solo repo di cui conosco già l'URL: **zero repo nuovi in cinque cacce** |
| 🔴 **Forex Factory (403, quinta di fila)** | Continuo a non sapere **come sono invecchiati** i sistemi M15 su GBPUSD e oro. È l'unica fonte che racconta cosa succede quando una strategia smette di funzionare |
| 🔴 **SSRN (403, quinta di fila)** | Zero letteratura peer-review sul forex intraday |
| 🟡 **La data di pubblicazione della scheda di `KA-Gold Bot`** | Ho letto la data **nell'header del sorgente** (2024), non sulla pagina. Marcata **[INCERTO]** nella scheda P2 |
| 🔴 **Lo SPREAD BCM sull'oro** | **Non esiste in repo.** È il cancello zero di P2, e senza quel numero P2 **non parte**. Lo strumento c'è ([Code Base 74148](https://www.mql5.com/en/code/74148), promosso il 23/08) e non è mai stato usato |
| ⚠️ **Nessun backtest è stato eseguito qui** | In questo ambiente non esistono MT5 né Strategy Tester. **Nessun numero di questo dossier è stato misurato oggi**: quelli di casa vengono dai referti citati, quelli di fuori sono etichettati `[DICHIARATO]` |

---

## 5. 📄 LA LETTERATURA — quello che vale, e quello che non c'era

### 5.1 🎯 Il documento che vale più di tutti i candidati messi insieme
**`Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures: A
Systematic Falsification Study`** — Mesfin (2026), arXiv:2605.04004v2
(PDF scaricato e letto).

Era già stato letto il 22/08 per la parte negativa. **Oggi ho letto la parte
che nessuno aveva ancora usato: la §5 (controlli positivi) e l'appendice A1
(registro delle decisioni bloccate).** Tre righe dell'appendice riguardano
direttamente questa caccia, e **sono conferme indipendenti dei nostri
verdetti**:

| decisione bloccata dall'autore | il nostro verdetto corrispondente |
|---|---|
| **`D130 — London ORB continuation rejected (T = 0.176) LOCKED`** | **R45: 0 celle su 48.** Terza conferma indipendente |
| **`D100 — MNQ OU mean reversion permanently rejected (Hurst 0.59, trending)`** + `D101 — MNQ is momentum-dominant at 5-minute resolution` | il nostro `ABTG_MeanRevert` **12/12 in perdita** (R60) |
| **`D105 — MGC intraday research closed – all approaches exhausted`** | l'oro intraday in mean reversion, già chiuso da noi il 23/08 |
| **`D179 — Structural gross edge ceiling confirmed at 5-min OHLCV resolution`** + `D213 — Direction prediction from OHLCV at 5-min resolution largely exhausted` | 🎯 **è la spiegazione economica del nostro "capitolo BREAKOUT M5 CHIUSO"** |

> ### 🧱 La frase che va incorniciata, e che riguarda ogni futuro candidato M5
> _"Across all fourteen signal families, the **maximum achievable gross return
> before friction is roughly 1.05 to 1.50 points**... The **2.0-point friction
> cost consistently exceeds this**."_ [§6.1]
>
> **Tradotto: su M5 non abbiamo sbagliato la taratura — stavamo raccogliendo
> meno di quanto costava raccoglierlo.** È R55 (_lo spread come percentuale
> dello stop_) dimostrato su un campione che non è il nostro. **Ed è il motivo
> per cui il criterio "take ≥ 3× lo spread" di questo mandato non è
> pignoleria: è il cancello principale.**

### 5.2 🕳️ Le due fonti che hanno risposto e non avevano niente — e va scritto

- **arXiv q-fin, sei query:** su FX e oro intraday **il catalogo è vuoto**. Le
  uniche cose in tema che escono sono microstruttura, forecasting di
  volatilità (`2311.18477` *Intraday FX Volatility-Curve Forecasting*),
  reinforcement learning e pricing di opzioni. **Zero regole di trading
  intraday su valute.** Terza caccia che lo misura.
- **Quantpedia, 82 slug enumerati:** **ZERO strategie intraday su FX o oro.**
  Le uniche voci valutarie sono `currency-momentum-factor`,
  `currency-value-factor-ppp-strategy`, `fx-carry-trade`, `dollar-carry-trade`
  — tutte **mensili e di portafoglio**, non traducibili su M15. L'unica voce
  con "intraday" nel nome è `intraday-seasonality-in-bitcoin`. 💰 **Round
  risparmiato: la sezione gratuita di Quantpedia, per un mandato intraday,
  non serve. Non ricontrollarla.**

---

## 6. 🏁 LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## 🎯 **"Il Breaking Band — che a H1 è positivo su 3 simboli su 3 in sei anni e mezzo, e che la sua stessa fonte dichiara «operatività M5/M15» — regge quando lo si porta sul TF in cui il corso dice che vive, o il TP sulla mediana si accorcia più in fretta di quanto si accorci lo spread?"**

**Non "quanto guadagna a M15".** La domanda è **se il take sopravvive al
costo**, e ha una risposta a due gradini che si legge nello stesso referto:

1. **PASSO 0 (cancello zero, si legge PRIMA di ogni P/L):** a M15, su GBPUSD /
   EURUSD / AUDUSD, **quanto vale in pip il TP medio realizzato**, e
   **quante operazioni** fa in quattro anni? Se il TP medio è sotto **3× lo
   spread** → **il round si chiude qui, e la pista M15 su questo motore si
   chiude con un numero.**
2. **Solo se il PASSO 0 è verde:** IS/OOS con i cancelli di casa, cella scelta
   al **centro dell'altopiano, mai al picco** (12 Spearman IS→OOS negative su
   13), e **verdetto SOLO a tick reali** — perché su M5/M15 l'OHLC inganna, e
   in casa nostra l'ha già fatto una volta per +129.000 € finti.

---

## 7. 📋 RIEPILOGO PER LA CODA

| # | oggetto | dove vive | buco che riempie | punti | verdetto | cosa serve |
|---|---|---|---|---:|---|---|
| **P1** | **`ABTG_BreakingBand` su M15** (M5 diagnostico) | **in casa** | **forex intraday M15** — oggi la flotta forex fa 0,6-3,9 op/**mese** per sedia | **9/10** | 🟢 **PROVA SUBITO** | **niente codice.** File prova consegnato: `prove/R108_BB_M15_FOREX.txt` |
| **P2** | **`KA-Gold Bot`** (Code Base 48251) | fuori, **sorgente letto** | **oro intraday M15**, con geometria **opposta** a `ABTG_EMA200` già in flotta | **9/10** | 🟢 **PROVA SUBITO, dietro il cancello zero** | (a) misurare lo **spread BCM sull'oro** col logger 74148; (b) 3-4 ore di rifinitura: rischio %, SL in ATR, parziale+BE+runner, fix riga 266 |
| **P3** | **`DayFlow VWAP Relay — Majors`** (TradingView, **Pine letto**) | fuori | **forex majors M15, motore SIMMETRICO, regime che ROUTA** (fade o breakout) | **9/10** | 🟢 **PROVA, terzo per costo** | **6-10 ore di riscrittura Pine→MQL5** + la cella di controllo TWAP (§P3, limite 1) |
| **P4** | **`London Session Signal B`** (arXiv 2605.04004 §5.2) | fuori, **paper letto** | è **la specifica che P3 realizza** | 9/10 *sull'idea* | 🟡 **IN CODA** | una classificazione di regime **riproducibile** — che P3 porta già |
| S1-S11 | undici scarti da sorgente `.mq5` | — | — | — | 🔴 | motivo per riga, §3.1-3.2 |
| S16-S20 | **cinque scarti da sorgente Pine** (fonte riaperta oggi) | — | — | — | 🔴 | motivo per riga, §3.4 |
| S21 | `15 Minute Gold Trend-Following Strategy` | — | era in pieno bersaglio | — | ⬜ **NON LETTO** | l'hash `PUB;` non c'è nella pagina. Se Claudio riesce ad aprirlo e a incollare il Pine, va dritto nel setaccio |
| S12-S15 | **quattro piste del mandato, chiuse con le prove** | — | — | — | 🔴/🟡 | §3.3 — servono a non ricercarle il giro dopo |

---

## 8. 🧾 ONESTÀ FINALE — la riga che Claudio deve leggere due volte

**Il MQL5 Code Base, sulla parola "M5/M15", è vuoto per noi. E stavolta non è
un'impressione: è la quarta aratura dello stesso campo, con i conteggi
accanto.** 1.597 titoli, catalogo completo fino all'ultima pagina, 61 in tema,
13 letti nel sorgente, **UNO promosso**. GitHub è chiuso. Forex Factory e SSRN
sono mute da cinque cacce.

🔓 **L'eccezione, ed è arrivata a caccia in corso: TRADINGVIEW SI LEGGE.** Il
canale l'ha trovato la sessione gemella, io l'ho applicato al mio bersaglio in
un'ora: **203 strategie, 6 Pine letti, cinque scarti secchi e un promosso a
9/10.** ⚠️ **Ma attenzione a non entusiasmarsi sul campione:** cinque Pine su
sei erano **senza stop, con lo stop che scappa, col 100% dell'equity per
operazione o con la tesi messa dentro un `input.bool`**. La qualità media di
TradingView è **peggiore** di quella del Code Base, non migliore: quello che
cambia è il **volume** del giacimento, non la sua purezza. **Il setaccio serve
lì più che altrove.**

**E c'è una ragione economica, non un caso: su M5 il costo mangia il segnale.**
Lo dice il documento più adversariale che ho letto — soffitto lordo 1,05-1,50
punti contro 2,0 di attrito — e lo dicono i nostri stessi morti, tutti in
apertura, tutti su M5, tutti belli in OHLC e rossi al tick.

> 🎯 **La conseguenza pratica per la challenge, ed è la cosa che vale più di
> tutto il dossier: la frequenza intraday NON la compreremo dal Code Base.
> Ce la dobbiamo prendere ABBASSANDO IL TF DEI MOTORI CHE SONO GIÀ VIVI —
> e per uno di quelli la fonte ci aveva già scritto dove guardare, tredici
> giorni fa, in un file che abbiamo in repo.**

Se il PASSO 0 di P1 dovesse dire che a M15 il take non copre lo spread, la
conclusione corretta **non sarà "cerchiamo un altro EA M15"**: sarà che
**su questo broker il TF M15 sul forex non è un terreno nostro**, e che la
frequenza per la challenge va cercata su **più simboli allo stesso TF**
invece che sullo stesso simbolo a TF più basso. Sarebbe una risposta scomoda,
ma sarebbe **una risposta**, e costa una passata.

---

_Dossier compilato il 25/08/2026. Fonti aperte davvero: MQL5 Code Base
(catalogo completo 1.597 titoli, **13 sorgenti `.mq5` scaricati, decodificati
e letti**), **TradingView (203 strategie raccolte, 6 Pine scaricati e letti
via pine-facade)**, arXiv (6 query API + **1 PDF letto**), Quantpedia
(82 slug), GitHub in sola lettura raw (1 README). Fonti dichiarate NULLE:
GitHub ricerca (403), Forex Factory (403), SSRN (403). **Nessun numero di
performance dichiarato da un autore ha pesato su un punteggio.** Nessun EA
nostro è stato toccato, nessun parametro in forward è stato modificato._

_Attribuzione, come da regola di casa:_
- _`KA-Gold Bot MT5` è di **Hung_tthanh@yahoo.com** (MQL5 Code Base, id 48251)_
- _`DayFlow VWAP Relay — Majors` è di **© exlux** (TradingView `muhhiXQs`),
  **Mozilla Public License 2.0** — la licenza va riportata, non solo l'autore_
- _il paper di falsificazione è di **Mesfin (2026)**, arXiv:2605.04004_
- _il canale di lettura del Pine (§1-bis) è stato trovato dalla sessione
  gemella del 25/08 (`CACCIA_M5M15_INDICI_2026-08-25.md`): qui è stato
  applicato e verificato, non scoperto._

_La citazione dell'autore va ripetuta **in testa a qualunque `.mq5` derivato**._
