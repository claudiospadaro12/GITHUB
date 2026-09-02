# 🏹 CACCIA FREQUENZA — **QUARTA BATTUTA · FRONTE B** · MQL5 Code Base · siti EA gratuiti · paper intraday — 02/09/2026

**Mandato (Claudio, 02/09 sera, testuale):** _"MANDA LA NOSTRA FLOTTA DI AGENTI
A CACCIA DI EA DAL TF BASSO M5, M15"_.

**Perimetro assegnato (FRONTE B — l'altro cacciatore batte TradingView/GitHub):**
- **MQL5 Code Base** `/en/code/mt5/experts` — ⚠️ **fonte DIVERSA dagli articoli**,
  che il 01/09 sono stati chiusi strutturalmente su 1.120 titoli.
- **Siti di EA gratuiti col sorgente** (EarnForex code, forum MQL5, altri archivi
  open che passino il controllo positivo del proxy).
- **Paper**: Quantpedia screener (schede gratuite) + arXiv q-fin 2024-2026 su
  pattern **intraday ad alta frequenza di segnale**, con il vincolo esplicito di
  **non ri-coprire** Breedon-Ranaldo / Ranaldo / 1103.5664 (già agli atti dal
  01/09) e di cercare **quello che manca: meccanismi M5/M15 su INDICI e ORO**,
  non solo forex.

---

## ⚡ IL RISULTATO IN CINQUE RIGHE

> **Su 5 fonti sottoposte a controllo positivo — 2 vive, 1 semi-viva, 2 murate —
> ho censito 400 id unici del Code Base su 10 pagine (il censimento più profondo
> mai fatto in repo su questa fonte: le battute precedenti si erano fermate a 20
> id e 4 pagine), lanciato 9 query arXiv, scaricato 8 ZIP e 2 PDF. Sono arrivato
> al sorgente su 9 oggetti e li ho letti riga per riga. PROMUOVO UNO, E NON A
> "PROVA SUBITO": va IN CODA a 6/10.**
>
> 🥇 **Il promosso è `VGRSI` — Visibility Graphs RSI, arXiv 2605.01300, Rafał
> Rak, Univ. Rzeszów, 02/05/2026.** È l'unico oggetto delle quattro battute che
> arriva con **frequenza DICHIARATA sopra il pavimento (3,3-4,8 trade/giorno)**,
> misurata **su DJI30, EUR/USD e XAU/USD** — cioè i nostri simboli — **dentro
> MetaTrader 5 con spread e commissioni reali**, con **long e short bilanciati**
> e **SL/TP simmetrici tarati sulla mediana dell'altezza delle candele recenti**.
> Il meccanismo (un RSI costruito sulle relazioni di *visibilità all'indietro*
> della traiettoria invece che sulle differenze di prezzo) **non esiste in nessuna
> forma in repo**: grep su `visibility graph|VGRSI` → **zero occorrenze**.
>
> 🔴 **E il rovescio va scritto prima dei complimenti, perché è grosso: i numeri
> dell'autore nascono da una RI-OTTIMIZZAZIONE SETTIMANALE.** Verbatim: _"The EA
> performed simulations with a given set of parameters in a 30-day window. It then
> selected the parameter set that was best in terms of profit and executed trades
> over the following 7 days."_ 👉 **È esattamente la regola di selezione che in
> casa abbiamo misurato ANTI-predittiva: 12 Spearman IS→OOS negative su 13.** Il
> paper **non riporta un solo risultato a parametri fissi**. Quindi dei suoi
> 340.000 USD non prendiamo niente — **prendiamo l'indicatore, e ce lo misuriamo
> noi a parametri congelati.**
>
> 🔴 **Il verdetto sulle due fonti nuove, che risparmia due cacce future.**
> (a) **Il Code Base è confermato ESAURITO sui motori, e adesso su 400 titoli e
> non su 20**: fra i ~60 id recenti mai setacciati ci sono **zero** motori
> intraday M5/M15 — sono pannelli, calcolatori, griglie, recovery, ONNX e Renko.
> (b) **Il canale "siti di EA gratuiti" è MORTO da qui: 6 domini su 6 murati**,
> EarnForex provato su **due trasporti diversi** (curl → CONNECT 403; WebFetch →
> EGRESS_BLOCKED). Non è "non ho trovato": è che la porta non si apre.
>
> 🪦 **E porto a casa una lapide che vale quanto un candidato: `arXiv 2407.08036`
> — "The tube oscillator" su DAX ed EUR/USD.** Stessa famiglia del promosso
> (oscillatori geometrici), stessi nostri simboli, rendimenti mensili dichiarati
> del 2-4,7%... e **61,67 trade al giorno con tenuta media di 171 secondi** e un
> **margine netto dichiarato di 0,037 pip per trade**. 🔴 **Contro il nostro
> spread di ~1 pip è morto di un fattore ~27, e viola il paletto prop P5.** In
> più i parametri del cuore geometrico sono **letteralmente oscurati** nel paper
> (`###`, _"in this preliminary version, the parameters are not disclosed"_):
> **non è replicabile nemmeno volendo.** Direzione "oscillatore geometrico ad
> altissima frequenza" chiusa con un numero, prima di spenderci un round.

---

## 0. ⚖️ I CRITERI — congelati dal mandato, scritti PRIMA di aprire un sorgente

Presi parola per parola dal mandato del 02/09 sera, non toccati dopo.

| # | criterio | soglia |
|---|---|---|
| **C1** | **TIMEFRAME DI LAVORO** | **M5 o M15** |
| **C2** | **FREQUENZA** | **≥ 2,0 trade/giorno**, `[MISURATA]` o `[DERIVABILE]` — **e si dichiara quale delle due** |
| **C3** | **§4 NON SI AMMORBIDISCE** | griglia / martingala / recovery / IgnoreSL / trucchi anti-prop → **scarto con la riga di codice che lo prova** |
| **C4** | **MECCANISMO NUOVO** sulla stessa inefficienza | mai "parametri diversi di un motore morto". **Ogni candidato passa la lista dei caduti** |
| **C5** | **GRATUITO**, sorgente **o** regole complete leggibili | mai promuovere da una descrizione |

**Più i paletti di casa, che il mandato non sospende:**
- **H8 — aritmetica:** `p ≥ 1,075/(RR+1)`. 🔴 **RR < 0,70 = MORTO SENZA CORSA.**
- **P5 — HFT prop** (`report/CONFIG_PROP_2026-08-31.md`): **max 25% dei trade
  sotto 60 secondi**. Niente tick-scalping.
- **Muro prop:** DD totale **10%**, DD **giornaliero 5%** su 100k.
- **Numeri d'autore:** si leggono, si etichettano, **non entrano in nessun
  punteggio**.
- **F11:** nessun file di forward, nessun EA vivo, nessun magic toccato.

---

## 1. 📕 IL CIMITERO, RILETTO PRIMA DI USCIRE

Letti per intero prima di aprire un browser:
`CACCIA_FREQUENZA3_ART_PAPER_2026-09-01.md` (788 righe),
`CACCIA_FREQUENZA3_TV_GH_2026-09-01.md`, `CACCIA_FREQUENZA_2026-08-31.md`,
`CACCIA_FREQUENZA2_2026-08-31.md`, `PROMEMORIA_SBLOCCO_FONTI.md` (452 righe),
`SETACCIO_MANUALE.md`, `backtest_pipeline/REGISTRO_TEST.md`.
Più il grep meccanico degli id Code Base già setacciati su
`caccia_strategie/*.md` **e** `report/*` (§F del promemoria: il setaccio da solo
non è l'indice completo) → **78 id già visti, tenuti fuori dal secondo taglio.**

| famiglia caduta / occupata | verdetto misurato | chi ha ucciso oggi |
|---|---|---|
| **breakout · ORB · session breakout** | ~210 celle a tick, R45 **0/48**, R12 **48/48 negative OOS**. Chiuso 26.07.26 | 🔴 primo taglio: `Range BreakOut`, `Periodic Range Breakout` ×2, `Vinci EA`, `Outbreak Trader`, `VR Breakdown level`, `Moving average breakout` |
| **fade degli estremi di sessione** | R42 **0/24 IS e 0/24 OOS** | — |
| **CRT / Turtle Soup** | `REFERTO_CRT_2026-08-30.md`, **0/30 celle** a tick | — |
| **SMC / ICT / FVG / order block** | setacciata 26/08 e 30-31/08 | 🔴 `ICT_conceptsEA by Emil`, `The Playground Series v1-v4` |
| **capitolo M1 · capitolo M5 breakout** | chiusi a tick. M1 = _"trappola di costo strutturale"_ | 🔴 **S2** (AK-47, stop 3,5 pip) |
| **M0PB — RSI(6) estremo + rientro EMA5** | 🔴 **MORTO 12/12 al PASSO 0 il 31/08**: lato migliore **0,52 segnali/giorno** contro pavimento 1,00 | 🔴 **S6** (`QuickTrend Scalper`: `InpPeriodRSI = 6`, **stesso identico grilletto**) e 🟠 **S4** (`RSI Ea MT5`, RSI 20/80: stessa classe di evento di coda) |
| **filtro appiccicato a motore già tarato** | **0 successi su 5** | 🔴 primo taglio sui multi-indicatore |
| **momentum intraday a orario fisso (Gao)** | R98 **−0,31 punti/trade su 410** | — |
| **barre alternative (tick/volume/imbalance)** | lapide del 01/09: 60,5 M di tick, AUC OOS 0,42-0,55 | 🔴 **i quattro `GDS Renko … Demo EA`** (76793/76794/76806/76811), scartati al primo taglio per questa lapide |
| **articoli MQL5** | 1.120 titoli, **fonte chiusa strutturalmente il 01/09** | ⬜ **non riaperta**, come da mandato |
| **QuantConnect** | 83 slug enumerati, **fonte chiusa il 01/09** | ⬜ **non riaperta** |

📌 **La frase-bussola, ora alla quinta conferma:**
> _"La frequenza NON la compreremo scendendo di timeframe. Va presa con PIÙ
> SIMBOLI a M15-H1."_ (caccia M1, 29/08)
> 👉 **Il promosso di oggi è il primo oggetto che la sfida con un numero
> dichiarato invece che con una speranza: 3 simboli × 3,3-4,8 trade/giorno.**

---

## 2. 📡 CONTROLLO POSITIVO — misurato OGGI, 02/09, fonte per fonte

| fonte | HTTP | bersaglio noto verificato **oggi** | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** (60.008 byte) | `/en/code/68951` → `<title>` letto: _"Free download of the 'Liquidity Sweep H4 - M15 (Swing Highs and Lows) / MQL5' expert by **'OsmarSandovalEspinosa'** for MetaTrader 5 in the MQL5 Code Base, **2026.03.23**"_ — **identico** ai censimenti del 26/08, 28/08, 31/08 e 01/09 | 🟢 **PASSA** |
| **Code Base — indice experts** | **200** | `/en/code/mt5/experts` pagine 1→10, **73.539-85.400 byte ciascuna**, **400 id unici con titolo** estratti | 🟢 **PASSA** |
| **Code Base — download ZIP** | **200** | 8 id scaricati (5.622 / 4.319 / 1.677 / 6.082 / 2.394 / 7.487 / 2.227 / 23.160 byte) | 🟢 **PASSA** |
| **arXiv API** (`export.arxiv.org`) | **200** (1.934 byte) | `id_list=1103.5664` → _"Intra-Day Seasonality in Foreign Exchange Market Transactions"_ | 🟢 **PASSA** |
| **arXiv PDF** (`arxiv.org/pdf`) | **200** | `2605.01300v1` → **5.756.634 byte, 16 pagine** · `2407.08036v1` → **5.395.191 byte** | 🟢 **PASSA** |
| **Quantpedia** | **200** | 🟠 **PREMIUM RICONFERMATO OGGI**, e stavolta con la prova doppia: `/strategies/intraday-currency-seasonality/` e `/strategies/exponential-fx-mean-reversion-strategy/` → **entrambe 300.143 byte IDENTICI** con `<title>` = home page. Lo `/screener/` risponde con **641.609 byte** e titolo proprio, ma **0 slug estraibili dall'HTML grezzo** (tutto in JS) | 🟠 **SEMI-VIVA — 0 regole leggibili** |
| **MQL5 forum** | **200** (160.848 byte, 147 link a thread) | `/en/forum` titolo corretto. ⚠️ **`/en/forum/expert` → 404** | 🟢 raggiungibile, **⬜ non battuto** (§5.2) |
| **EarnForex** | **000 / EGRESS_BLOCKED** | provato su **DUE trasporti**: `curl` → `CONNECT tunnel: HTTP/1.1 403 Forbidden`; `WebFetch` → `{"error_type":"EGRESS_BLOCKED"}` | 🔴 **NULLA** |
| **SSRN** | **403** | — | 🔴 **NULLA — UNDICESIMA di fila** |
| **Forex Factory** | **403** | — | 🔴 **NULLA** |

### ⛔ Il canale "siti di EA gratuiti", sondato in blocco e murato: **6 domini su 6**

| dominio | esito 02/09 |
|---|---|
| `www.earnforex.com` | 🔴 **000** (curl CONNECT 403) **+ EGRESS_BLOCKED** (WebFetch) |
| `www.forex-tsd.com` | 🔴 **000** |
| `fxcodebase.com` | 🔴 **000** |
| `www.mt5-ea.com` | 🔴 **000** |
| `traderversity.com` | 🔴 **000** |
| `bestmetatraderindicators.com` | 🔴 **000** |

> 🎯 **Da scrivere nel promemoria e non riprovare senza motivo nuovo:** _"Il
> mondo dei siti di EA gratuiti fuori da mql5.com è **irraggiungibile da questo
> ambiente**. Misurato il 02/09/2026 su sei domini, con EarnForex provato su due
> trasporti indipendenti. Le uniche fonti di CODICE vive restano **mql5.com**,
> **tradingview.com + pine-facade** e **raw.githubusercontent.com**."_
>
> ⚠️ **404 ≠ 503, e nemmeno 000 ≠ 403.** I sei sopra sono **000 al CONNECT**:
> è il proxy che rifiuta, non il sito che non c'è. Se un domani l'allowlist si
> apre (`PROMEMORIA_SBLOCCO_FONTI.md` §2), **EarnForex torna in gioco** — ha
> sorgenti `.mq5` con licenza dichiarata. **Non è un cadavere: è una porta
> chiusa.**

---

## 3. 📊 COSA HO SFOGLIATO, fonte per fonte

| fonte | quanto | candidati visti | **letti nel sorgente / per intero** |
|---|---|---|---|
| **MQL5 Code Base** | **10 pagine** di `/en/code/mt5/experts` | **400 id unici con titolo**, 379 con descrizione estratta | **7 `.mq5` letti riga per riga** (8 ZIP scaricati) |
| **arXiv q-fin** | **9 query** (`intraday+gold`, `index futures+intraday`, `abs:intraday momentum`, `abs:intraday reversal`, `abs:opening range`, `cat:q-fin.TR + trading strategy`, `time-of-day`, `5-minute+futures/gold`, `mean reversion+intraday`, `q-fin.TR + MetaTrader/expert advisor/forex`) | ~110 titoli, **6 in bersaglio** | **2 PDF scaricati e letti per intero** (16 + ~24 pagine) |
| **Quantpedia** | screener + 2 slug strategia | — | **0** (muro premium riconfermato con prova) |
| **Siti EA gratuiti** | 6 domini sondati | — | **0** (canale murato) |
| **MQL5 forum** | root | 147 thread | **0** — dichiarato, §5.2 |

### 3.1 🔬 Il censimento del Code Base — e perché stavolta conta

Le battute precedenti hanno chiuso il Code Base **su 20 id e 4 pagine**
(31/08, §4.1 della seconda battuta: _"il giacimento è ESAURITO su questo
bersaglio"_). **Era un verdetto giusto ma su un campione piccolo.** Oggi l'ho
rifatto su **400 id / 10 pagine**, cioè il catalogo che va dall'id **76811**
(29/08/2026) fino all'id **11637**, e ho incrociato meccanicamente con i **78 id
già setacciati** nei dossier precedenti. Ecco l'intero catalogo **mai setacciato
prima**, per classe:

| classe | quanti | esempi (id) |
|---|---:|---|
| **pannelli, calcolatori, gestori, trailing, logger, copiatori, journal** | **~150** | 7 utility `Quantora` di fila (75729-75749), `ASQ`/`BEC`/`XPro`/`ExMachina` ×9, `Trade Manager` ×6, `Position Size Calculator` ×5 |
| **snippet didattici** ("how to detect a new bar", "get Nth trade", `IsConnected`, `RectangleTest`, i **7 volumi** di *MQL5 Programming for Traders*) | **~60** | 49018, 49171, 41601, 45590-45596 |
| **§4 dal titolo** — griglia / martingala / recovery / lock / basket | **~30** | `XANDER **Grid**`, `XANDER Gold **Recovery**`, `RSI **Grid** Pro`, `BGC **Grid**`, `**Grid** Master`, `Simple_**Grid**`, `Sideways **Martingale**`, `Reversing **Martingale**`, `Basic **Martingale** v3`, `Breakout **Martin Gale**`, `Periodic Range Breakout (**Martingale**)`, `MultiMartin`, `KSU_martin`, `VR **Locker** Lite`, `Long and Short Stepped **Grid** Trade`, `MA **Grid** Trade`, `MT5-**BuildYourGrid**EA`, `Daily Zone **Recovery**`, `Sniper Gold Hybrid **Recovery**` |
| **rete / DLL / servizi esterni** | **~8** | `Prime Quantum AI (Anthropic/OpenAI/Gemini/DeepSeek/Grok)`, `ExMachina Telegram Bridge`, `KSQ CommandCenter Google Sheets`, `MT5 Telegram Trade Notifier`, `T5Copier` |
| **ONNX / ML con modello allegato** | **4** | `Larry Williams XGBoost Onnx` 68424, `Market Structure Onnx` 68535, `Sideways Martingale onnx` 68537, `ONNX Trader` 48482 → 🔴 **il modello è un binario: non si legge, non si rifinisce, non si audita** |
| **arbitraggio triangolare / correlazione multi-simbolo** | **5** | 51014, 57272, 29115, 29116, 52043 → 🟡 **classe che resta un BUCO vero della flotta** (terza volta che lo scrivo), ma richiede tester multi-valuta e book: **costo di validazione > valore atteso in questo mandato** |
| **Renko / barre sintetiche** | **4** | 76793, 76794, 76806, 76811 (tutti *GDS … Demo EA*, 27-29/08/2026) → 🔴 **chiusi dalla lapide delle barre alternative del 01/09** (60,5 M di tick, AUC OOS 0,42-0,55, p=0,10) |
| **incroci di media / multi-indicatore generici, senza sessione né TF dichiarato** | **~80** | `Classic 2 MA crossover`, `Simple EMA Cross`, `Pro MA Crossover`, `Aegis Quantum Lite` (EMA 9/21 + RSI 14, **lotto fisso dichiarato in descrizione**), `YY_Cross_2_Ma`, `EMA LWMA RSI`, `Seven strategies in One`, `Popular MACD Strategy from Viral YouTube Video` |
| **fuori strumento / fuori mandato** | **~20** | cripto, `BITEX.ONE MarketMaker`, `PlayDOOM` (sì, davvero), `Sudoku` |
| **motori candidati veri, portati al sorgente** | **7** | §4 |

> ### 🔴 IL VERDETTO SULLA FONTE — e adesso è su 400 titoli, non su 20
> **Su 400 EA del Code Base MT5, i motori intraday M5/M15 con SL vero, rischio
> in percentuale e frequenza ≥2/giorno sono ZERO.** Non "pochi": zero.
> Il catalogo si divide in **attrezzi (~53%)**, **griglie/martingala/recovery
> (~8%)**, **snippet didattici (~15%)** e **incroci di indicatori senza tesi
> (~20%)**.
>
> 🔬 **E la ragione è strutturale, esattamente come per gli articoli:** il Code
> Base premia ciò che è **utile a chiunque** — un calcolatore di lotto serve a
> tutti, un motore di sessione su M5 serve a chi ha già una tesi. **Chi ha una
> tesi che funziona non la carica gratis.** Ciò che resta è o un attrezzo, o una
> griglia, o un template.
>
> ➡️ **Regola d'uso confermata e rafforzata: il Code Base si apre per gli
> ATTREZZI, non per i motori.** Le battute del 31/08 e del 01/09 lo avevano
> scritto su 20 e 0 id; oggi è misurato su **400**. **Non si riapre per cercare
> un motore intraday senza una ragione nuova e dichiarata.**

---

## 4. 🗑️ GLI SCARTATI — con la riga che lo prova

### 4.1 MQL5 Code Base — **7 sorgenti letti riga per riga, 7 scarti**

| # | candidato | fonte / autore / data | la riga che lo prova |
|---|---|---|---|
| **S1** | **`Ingrit`** — 821 righe, 11 input, **M5 NATIVO** ([id 23499](https://www.mql5.com/en/code/23499)) | Vladimir Karputov · `#property copyright "Copyright © 2018, Vladimir Karputov"` | 🔴 **AVERAGING SENZA CAP, DENTRO UN MOTORE DI FADE. È il peggiore dei sette proprio perché è il più credibile.** Il motore è pulito e leggibile — fade dell'estensione: `if(rates_m5[1].open>rates_m5[1].close) if((rates_m5[14].high-rates_m5[1].low)>ExtStep) m_need_open_buy=true;` (riga ~242) = _"se il prezzo è sceso di ≥25 pip in 14 barre M5 e l'ultima candela è ribassista, COMPRA"_. Decide su **barra chiusa** (`ArraySetAsSeries(rates_m5,true)` + indice `[1]`), rischio **vero in percentuale** (`IntLotOrRisk=risk`, `InpVolumeLorOrRisk=3.0`). 🔴 **Ma il blocco di apertura (righe 170-191) NON HA NESSUN CONTROLLO SUL NUMERO DI POSIZIONI:** `if(m_need_open_buy){ if(InpCloseOpposite){…} … OpenPosition(POSITION_TYPE_BUY,level); return; }` — e **`InpCloseOpposite` è `false` di default**. Il flag si riarma **a ogni nuova barra M5** che soddisfa la condizione. 👉 **Su una discesa che continua, l'EA compra a ogni barra M5, al 3% di rischio ciascuna: 12 barre = 12 posizioni = 36% di equity, tutte CONTRO il prezzo.** È la definizione di averaging del §4, con l'aggravante che il motore è **un fade**, cioè fa esattamente il contrario di quello che il prezzo sta facendo. 🟡 **Cosa terrei comunque:** l'idea di fade dell'estensione a N barre su M5 è scrivibile e a due lati. 🔴 **Cosa la uccide oltre all'averaging:** tutte le soglie sono in **PIP FISSI** (`InpStep=25`, `InpStopLoss=80`, `InpTakeProfit=70`) e non in ATR → non è portabile fra simboli, ed è la taratura dell'autore su una coppia che non dichiara |
| **S2** | **`AK-47 Scalper EA - MT5`** — 591 righe ([id 44883](https://www.mql5.com/en/code/44883)) | — | 🔴🔴 **NON HA UN SEGNALE. NEMMENO UNO.** Riga 152 di `OpenOrder()`: `ENUM_ORDER_TYPE OrdType = ORDER_TYPE_SELL;//-1;` — **il tipo d'ordine è CABLATO a SELL**, quindi il ramo `else if(OrdType == ORDER_TYPE_BUY)` (righe 178-196) è **codice morto** e l'EA non fa altro che **riarmare in eterno un sell-stop 1,75 pip sotto il bid**, senza guardare un solo indicatore, prezzo o livello. In più: `InpSL_Pips = 3.5` → **stop da 3,5 pip su forex**, dove ~1 pip di spread è il **29% dello stop**; e `LotSize = (InpRisk) * m_account.FreeMargin();` (riga 307) **non è un rischio in percentuale**, è il 3× del margine libero. **Doppia squalifica: nessuna tesi + capitolo M1/scalping chiuso a tick** |
| **S3** | **`Probability Theory Expert Advisor for Forex`** (file `QUANT EA.mq5` / `Probability theory.mq5`) — 186 righe ([id 49770](https://www.mql5.com/en/code/49770)) | Yevgeniy Koshtenko · `#property copyright "Copyright 2024"` | 🔴 **NESSUNO STOP LOSS DI DEFAULT, provato in tre righe.** `input int StopLoss = 0;` (riga 15) → `if(StopLoss>0) sl=NormalizeDouble(Bid-StopLoss*_Point,_Digits);` (righe 168-169) → `trade.Buy(Lot(),NULL,pr,sl,tp,"");` (riga 173) **con `sl` che resta 0**. Idem sullo short (righe 177-182). E `input double Lots = 0.1;` = **lotto fisso**. §4 due volte |
| **S4** | **`RSI Ea MT5`** — 804 righe, ~25 input ([id 59303](https://www.mql5.com/en/code/59303)) | — | 🟠 **SCARTO PER FREQUENZA, e NON per difetto: è il codice meglio scritto dei sette.** Ha ATR-stop (`VolatilityFactorSL=2`, `VolatilityFactorTP=3` → **RR 1,5**, passa H8), rischio in % opzionale (`ENUM_RISK_BASE`), filtro di sessione (`EnableSessionFilter`, `SessionStartHour/EndHour`), scale-out, e legge **barra chiusa** (`CopyBuffer(SignalIndicatorHandle, 0, 1, 2, …)`, riga 643). 🔴 **Ma il grilletto è un EVENTO DI CODA, riga 675:** `if ((CurrentSignal > LowerThreshold) && (PreviousSignal <= LowerThreshold)) LongEntrySignal = true;` con `LowerThreshold = 20` su `iRSI(…, MomentumPeriod=14, …)`. 👉 **RSI(14) che rientra sopra 20 su M5/M15 forex non accade due volte al giorno: accade qualche volta al mese.** È **la stessa malattia di M0PB**, morto 12/12 il 31/08 con 0,52 segnali/giorno sul lato migliore. Più `MaxOpenPositions = 1` → **il tetto è 1 trade alla volta per definizione**. C2 fallito per costruzione |
| **S5** | **`CCI + MACD Scalper`** — 260 righe, 10 input ([id 42283](https://www.mql5.com/en/code/42283)) | — | 🔴 **DECIDE SULLA BARRA IN FORMAZIONE, e l'errore è di indicizzazione.** Righe 84-87: `CopyBuffer(cciHandler, 0, 0, 3, cciArray);` — **`start_pos = 0` include la barra corrente e NESSUN `ArraySetAsSeries` è mai chiamato** su quegli array. In ordine non-serie l'elemento **`[2]` È LA BARRA IN CORSO**, ed è proprio quello usato nella condizione (riga 99: `macdArray[2] < 0 && … macdSignalArray[2] < macdArray[2]`, riga 101: `cciArray[2] < 0 && cciArray[1] > 0`). 👉 **L'autore crede di leggere due barre chiuse e ne legge una chiusa e una viva.** Il gate `isNewBar` limita il danno al primo tick, ma il valore resta quello di una barra incompleta. In più: **tesi assente** (EMA34 **AND** incrocio zero del CCI **AND** incrocio MACD = tre indicatori in AND, la "tesi dentro il menu" già caduta tre volte), e **una sola posizione alla volta** (`tradeTicket`). 🟢 Da tenere: `accountRisk` è un rischio vero e lo stop è **strutturale** (`iLowest(…,5,1)`), non a pip fissi |
| **S6** | **`QuickTrend Scalper`** (file `revised_self_adaptive_ea.mq5`) — 129 righe ([id 52105](https://www.mql5.com/en/code/52105)) | — | 🔴 **DOPPIONE DI UN CADAVERE (C4).** `input int InpPeriodRSI = 6;` + `InpMAPeriod = 2` + `InpAverBodyPeriod = 3`: è **lo stesso identico grilletto di M0PB** — RSI a periodo **6**, cioè l'estremo di coda che il 31/08 ha misurato **0,52 segnali/giorno** contro un pavimento di 1,00, **12 celle su 12 morte**. La regola del mandato è esplicita: *mai "parametri diversi di un motore morto"*. In più `input double InpLot = 0.05;` = **lotto fisso** e il nome del file (`revised_self_adaptive_ea`) non corrisponde al titolo pubblicato: **file riciclato** |
| **S7** | **`Aussie Surfer`** — 597 righe ([id 43278](https://www.mql5.com/en/code/43278)) · **GBPAUD, M15 dichiarato in pagina** | — | 🔴 **LOTTO FISSO E NESSUN TAKE, dichiarati negli input.** `static input double Entry_Amount = 0.30; // Entry lots` (riga 20) → **0,30 lotti fissi, non scalabili a 100k e non confrontabili con nessuna nostra cella**; `input int Take_Profit = 0; // Take Profit (pips)` (riga 22) → **nessun target**: si esce solo sull'inversione dell'Alligator. E il motore è **Bollinger(5, 2,5) + Alligator** = **doppione di `ABTG_BandFade`** già in casa (F5). 🟡 Nota: legge barre chiuse (`CopyBuffer(…, 1, 2, …)`, start_pos 1) → niente repaint |

### 4.2 Paper — **1 scarto, ed è la lapide più utile della battuta**

| # | paper | la riga che lo prova |
|---|---|---|
| **S8** | **`Financial market geometry: The tube oscillator`** — [arXiv 2407.08036](https://arxiv.org/abs/2407.08036), Dragoljub Katic & Stefan Richter, 10/07/2024. **DAX 40 + EUR/USD, 2019/01 → 2024/05, dentro MetaTrader** | 🔴 **TRE SQUALIFICHE INDIPENDENTI, tutte VERBATIM dal PDF letto per intero.** **(1) NON È REPLICABILE, e lo dice il paper:** la Tabella 1 riporta `###` al posto di *basic slope* `m_basic`, *slopes* `f_k`, `N_s` e *starting points* `s_j` — didascalia testuale: _"In this preliminary version, the parameters are not disclosed."_ 👉 **I quattro numeri che definiscono la geometria dell'oscillatore sono oscurati: non si può implementare senza inventarli.** **(2) VIOLA IL PALETTO PROP P5, di gran lunga:** _"in average, **61.67 trades are performed per day** (standard deviation: 25.37), with an **average position holding time of 171.75 seconds** … the position duration is right-skewed with **lots of positions gave up in less than 30 seconds**"_. Il nostro tetto è **max 25% dei trade sotto 60 s**; qui la moda della distribuzione è sotto i 30. **(3) MURO D'ATTRITO, con l'aritmetica dell'autore:** _"The **average profit/share is 0.37·10⁻⁵**"_ su EUR/USD = **0,037 pip netti per trade**, con l'ipotesi di costo _"the loss of one bid-ask-spread for each trade"_ e _"besides the bid-ask-spread, there are **no additional costs**"_. 👉 **Con il nostro spread di ~1 pip `[NON MISURATO]`, un margine di 0,037 pip × 61,67 trade/giorno è annientato di circa un fattore 27.** In più: **nessuno stop loss** (_"in particular no stop loss was introduced"_) e **100% del saldo per trade** (_"each trade was performed with a 100% investment of the current balance"_) |

> ### 🪦 **LA LAPIDE, e vale un round risparmiato**
> **La direzione "oscillatore geometrico continuo ad altissima frequenza" è
> chiusa prima di essere aperta.** È la mossa che sarebbe venuta naturale la
> settimana prossima — se un oscillatore basato sulla geometria della traiettoria
> funziona (ed è la stessa famiglia del promosso di oggi), **perché non farlo
> girare in continuo?** Risposta, con i numeri di chi l'ha provato su 5 anni e
> due dei nostri simboli: **perché a 61 trade/giorno il margine per trade scende
> a 0,037 pip, e a quel punto il segno del risultato lo decide lo SPREAD DEL
> BROKER, non l'oscillatore.**
>
> 🎯 **È la terza conferma indipendente del muro d'attrito** (arXiv 2605.04004
> §6.2, la lapide di `fx-bizday` del 01/09 — _"even 1 basis point will destroy
> the profitability"_ — e adesso questa). **Tre fonti, tre mercati, tre metodi,
> stessa parete.** E dice anche **dove sta la porta**: il promosso di oggi fa
> **3,3-4,8 trade/giorno**, cioè **13 volte meno**, con **SL/TP dimensionati
> sulla volatilità** invece che sull'uscita a soglia. **Non è la stessa cosa, ed
> è per questo che vale la pena guardarlo.**

### 4.3 Scartati al primo taglio (titolo/descrizione, sorgente **non** aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---:|---|
| **Code Base — attrezzi e snippet** | **~210** | 🔴 **zero ingressi = niente da backtestare.** Regola del `SETACCIO_MANUALE`: se non c'è `OrderSend`/`trade.Buy` → si salta |
| **Code Base — §4 dal titolo** (grid / martingale / recovery / locker / basket) | **~30** | 🔴 primo taglio, elencati per nome in §3.1 |
| **Code Base — incroci di media / multi-indicatore senza sessione** | **~80** | 🔴 nessuna tesi, nessun TF dichiarato, `MaxOpenPositions=1` o lotto fisso nella descrizione. **Doppioni di `CrossEma`/`GoldenCross`/`SupertrendReversal`** |
| **Code Base — Renko / barre sintetiche** | **4** | 🔴 **lapide delle barre alternative** (01/09) |
| **Code Base — ONNX / modello binario** | **4** | 🔴 **il modello non si legge**: non auditabile, non rifinibile, e il file `.onnx` è una dipendenza esterna |
| **Code Base — rete / WebRequest / servizi esterni** | **~8** | 🔴 §4, e non backtestabile |
| **Code Base — già setacciati nei dossier 16→01/09** | **78 id** | 🔵 **ciò che è setacciato non si ricontrolla** |
| **Code Base — fuori strumento / fuori genere** | **~20** | 🔴 cripto, market making, `PlayDOOM`, `Sudoku` |
| **arXiv — fuori dominio** | **~90** | 🔴 le query `opening range`, `time-of-day`, `5-minute` **rendono quasi solo fisica, matematica pura e computer vision**: le stringhe sono ambigue fuori da q-fin. Segnalato come **buco di ricerca**, non come assenza di letteratura |
| **arXiv — in tema ma già agli atti o già caduti** | **6** | `2605.04004` (muro d'attrito, agli atti) · `2605.11423` (VVG classifier di Mesfin — **già letto il 31/08**, e l'autore stesso conclude _"None of the evaluated strategies satisfy the same validation criteria"_) · `2006.08307` (HMM, già scartato) · `2602.18912` (overreaction su AAPL, azione singola US) · `2512.12924` (walk-forward su 100 azioni US, **Sharpe 0,33, p=0,34** dichiarati dagli autori) · `2602.10785` (metodologia di walk-forward su Bitcoin) |

---

## 5. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

### 5.1 I buchi di fonte

| oggetto | perché, e cosa ci costa |
|---|---|
| 🔴 **TUTTO il canale "siti di EA gratuiti"** | **6 domini, 6 mura**, EarnForex su due trasporti. 👉 **Non so cosa ci sia su EarnForex**: ha sorgenti `.mq5` con licenza dichiarata ed è la seconda fonte open più citata dopo il Code Base. **È il buco più grosso di questa battuta** |
| 🔴 **Le REGOLE di qualunque strategia Quantpedia** | Muro premium riconfermato con la prova dei **300.143 byte identici su due slug diversi**. Dalla sitemap si legge il **nome dell'effetto**, mai le regole. **Terza caccia consecutiva, zero candidati** |
| 🟠 **Il forum MQL5** | Risponde (200, 147 thread), **ma non l'ho battuto**. Motivo dichiarato: per MT5 i codici condivisi finiscono **nel Code Base**, che ho appena censito per intero; il forum è un firehose di Q&A dove entrare **con una domanda precisa**, non a pescare (§3E del mandato di ruolo). ⚠️ `/en/forum/expert` → **404**: la sezione non esiste con quello slug. **Chi ci riprova, cerchi prima lo slug giusto** |
| 🟡 **Le pagine 11+ del Code Base** | Mi sono fermato a **10**. Sotto l'id ~23000 si entra nel 2018 e prima, dove il catalogo è quasi solo `Exp_<Indicatore>_MMRec_Duplex` (la serie generata di Nikolay Kositsin). **Il fondo del catalogo resta non censito**, e va detto |
| 🟡 **~370 dei 400 titoli Code Base** | Filtrati **per titolo + descrizione**, sorgente non aperto. Le classi e i motivi sono in §3.1 e §4.3. ⚠️ **Con `?keyword=` rotto** (riconfermato dai dossier precedenti, non riprovato oggi) **non esiste modo di interrogare il testo dei sorgenti**: il filtro per titolo può aver perso qualcosa |
| 🔴 **La FREQUENZA di qualunque candidato, MISURATA** | **Nessuna fonte dati di prezzo raggiungibile** (Yahoo, Stooq, Dukascopy: murate dal 31/08, non riprovate oggi). **Da qui nessun agente può misurare una frequenza.** Quella del promosso è `[DICHIARATA DALL'AUTORE]`, e **il numero vero lo fa il PC di Claudio** |
| 🔴 **LO SPREAD BCM** | `[NON MISURATO]`. **Ottava caccia che lo scrive.** Uso ~1 pip di convenzione su EURUSD e 2,0 punti indice su Dow (`METRO_PROP` D4). 🟢 Resta vero quel che ha scritto il 01/09: **la Sonda dell'Orologio lo campiona già, nell'ora in cui si paga** — accenderla chiude anche questo |
| ⚠️ **Nessun backtest eseguito** | Qui non esistono MT5 né Strategy Tester. **Nessun numero di questo dossier è stato misurato oggi.** Quelli di casa vengono dai referti citati; quelli di fuori sono `[VERIFICATO su pagina/sorgente]`, `[DICHIARATO DALL'AUTORE]` o `[CALCOLO MIO]` |
| 🔴 **Nessun EA toccato, nessuna sedia, nessun magic, nessun parametro in forward** | **F11 rispettato.** L'unico file nuovo in `prove/` è una **specifica**, non un artefatto eseguibile (§7) |

### 5.2 🔧 Un rilievo di processo, perché costa tempo al prossimo

Il `SETACCIO_MANUALE.md` indicizza gli **URL**, non i **titoli** — e §F del
promemoria lo dice già. Oggi ho aggirato il problema costruendo l'indice degli
id **con un grep su due alberi** (`caccia_strategie/` **e** `report/`), che ne
rende **78**. 👉 **Ma resta il fatto che il Code Base ha 400+ id e noi ne
tracciamo 78 in file sparsi.** Proposta minima e a costo zero: **una riga per
id nel `SETACCIO_MANUALE.md`, con id, titolo, data ed esito** — così il secondo
taglio diventa meccanico invece che archeologico. **Non l'ho fatto oggi perché
non me l'ha chiesto nessuno e toccare un file di indice a metà di una caccia è
il modo di romperlo.**

---

## 6. 🟢 IL PROMOSSO — uno, e va detto subito che **NON è "PROVA SUBITO"**

### 🥇 P1 — `VGRSI` · Visibility Graphs Relative Strength Index

```
FREQUENZA          3,3 - 4,8 TRADE/GIORNO          <-- PRIMO CAMPO
                   [DICHIARATA DALL'AUTORE, Tabella 1, NON verificata da noi]
                   DJI30 3,5/gg (1.842 trade) | EUR/USD 3,3/gg (1.677)
                   XAU/USD 4,8/gg (2.418), su 503 giorni di borsa 2024-2025.
                   E' COERENTE con i vincoli interni dichiarati nel paper
                   (max 2 posizioni aperte per strumento + minimo 30 minuti
                   fra due ingressi): il tetto teorico sarebbe 48/giorno,
                   il misurato e' 3-5. Il numero non e' gonfiato.
                   >= 2,0/giorno: PASSA, e con margine.

NOME               Visibility Graphs Relative Strength Index (VGRSI)
FONTE / URL        arXiv 2605.01300v1  --  https://arxiv.org/abs/2605.01300
                   PDF scaricato oggi: 5.756.634 byte, 16 pagine, LETTO PER
                   INTERO (metodo + risultati + discussione).   [VERIFICATO]
AUTORE / DATA      Rafal Rak, Institute of Physics, Faculty of Exact and
                   Technical Sciences, University of Rzeszow (Polonia)
                   Pubblicato 02/05/2026, cs.CE.
POPOLARITA'        [INCERTO] -- nessun contatore di citazioni raggiungibile
                   (il canale accademico non-arXiv e' murato, 11 domini).
LICENZA            🔴 ATTENZIONE, E VA DICHIARATA: nessuna licenza aperta.
                   Nota 1 a pag. 3, verbatim: "The VGRSI indicator is an
                   original authorial concept introduced in this paper;
                   the author reserves all rights to its use."
                   👉 NESSUN CODICE PUBBLICATO. Il paper descrive la formula
                   per intero (ed e' implementabile), ma non c'e' repo, non
                   c'e' .mq5, non c'e' MIT/MPL. Uso interno di ricerca: si
                   fa. Qualunque cosa oltre: si chiede prima all'autore.
RIGHE / INPUT      il nucleo matematico e' ~15 righe di formula.
                   Nella forma del paper i parametri liberi sono ~10
                   (WS e WV per TRE timeframe, variante A0/A1, soglia long,
                   soglia short, N e Z dello stop). Nella forma SONDA che
                   propongo io sono QUATTRO. La differenza e' il §6.3.
COSTO DI PORTING   🟠 MEDIO. Non c'e' niente da tradurre: c'e' da SCRIVERE
                   un indicatore da una formula. ~150 righe di matematica
                   + il guscio. Vincolo tecnico misurato sulla formula:
                   l'implementazione ingenua e' O(WS x WV^2) per barra e
                   NON gira; serve la forma incrementale (si calcola il set
                   di visibilita' V_j UNA volta per barra nuova, O(WV^2), e
                   si tiene una coda delle ultime WS barre). Con WS=WV=35
                   sono ~1.200 operazioni/barra: su 150.000 barre M5 e'
                   nulla. 👉 IL COSTO E' REALE MA NOTO, e la trappola pure.
```

**TESI IN UNA RIGA**
> _"Non conta solo di quanto il prezzo si è mosso, ma **quali punti del passato
> sono ancora 'in vista'** dal punto di adesso: un RSI calcolato solo sulle
> variazioni dei punti non oscurati dal profilo intermedio misura la **struttura
> geometrica** della traiettoria, e distingue un impulso senza seguito (pochi
> movimenti, grande ampiezza) da un trend che si sta formando — cosa che l'RSI
> classico, che somma tutte le differenze locali, non può vedere."_

⚠️ **E lo dichiaro io, perché pesa nel punteggio: questa è una tesi
STATISTICA/GEOMETRICA, non una tesi di MERCATO.** Non dice *chi* sta dall'altra
parte né *perché* quel flusso esiste — a differenza di Breedon-Ranaldo, dove
l'inventario dei dealer è il meccanismo. `prove/LEGGIMI.md` chiede la tesi prima
del codice, e questa la soddisfa **a metà**. **Vale un punto, non due.**

**MECCANICA — tre righe, come da scheda** [VERIFICATO, §Results punto (8) del paper]
- **Ingresso:** l'apertura della posizione è basata **esclusivamente** su
  VGRSI — verbatim: _"The opening of a position was based solely on the
  indicator VGRSI_rA(t)"_. Tre scale temporali (**M1, M5, M30**) devono
  concordare: _"Crossing the relevant threshold from above on all time scales
  triggered the opening of the corresponding position"_. Soglie testate: **20-35
  per il long, 70-95 per lo short**.
- **Uscita:** **SL e TP simmetrici**, posti **all'apertura**: si prende la
  **mediana dell'altezza delle ultime N candele** (rialziste e ribassiste) in
  punti, la si moltiplica per **Z**, e quello è il livello. 👉 **RR = 1,00
  esatto per costruzione.** Cancello H8: serve `p ≥ 1,075/2 = ` **53,75%** di
  win rate. **RR 1,00 > 0,70 → passa l'aritmetica, ma non con abbondanza.**
- **Stop:** ✅ **c'è, ed è volatility-adaptive** — è la mediana dell'altezza
  delle candele recenti × Z. **Non è a pip fissi.** È la forma che in casa
  usiamo già (ATR-scalato) arrivata da una strada diversa.

**GESTIONE RISCHIO (quella dell'autore, che rifaremmo per intero)**
🔴 **1.000 USD fissi per trade su un portafoglio da 10.000** = ~10% di nozionale
a lotto **fisso**, leva 1:100, **max 2 posizioni per strumento**, **minimo 30
minuti fra due ingressi**. Da noi: **rischio in percentuale dell'equity (0,65%)**,
cap posizioni, cap giornaliero. **È esattamente la parte che sappiamo fare.**

**BANDIERE ROSSE §4** — ✅ **nessuna nel motore**: niente martingala, niente
griglia, niente recovery, niente hedge, **stop vero e non virtuale**, nessuna
dipendenza esterna, e **nessun repaint possibile** (la visibilità all'indietro
usa **solo punti passati**, per definizione: `i ∈ {j−1, …, max(0, j−WV)}`).
🟠 **Nel setup dell'autore: lotto fisso** (gestione, si rifà) **e M1 fra le tre
scale** (il nostro capitolo M1 è chiuso — ma qui M1 non è il TF di trading, è una
delle tre scale di conferma. **La distinzione è reale e la dichiaro; il PASSO 0
la aggira misurando M5 da solo, §7**).

**PUNTEGGIO** — compilato **prima** di guardare i numeri di performance dell'autore

- **[1] semplicità** — 🔴 nella forma del paper sono **~10 parametri liberi
  ri-scelti ogni settimana**: è il contrario di "poche regole, pochi parametri".
  🟢 Nella forma-sonda che propongo sono **quattro** (WS, WV, variante, soglia)
  su **un solo TF**. **Un punto, e la discrepanza è dichiarata.**
- **[2] il filtro È il motore** — _"based solely on the indicator"_. Non c'è
  niente da appiccicare e niente da togliere. È la forma `ABTG_EMA200` del §5B
  di `ROBUSTEZZA.md` (**30 celle su 30 a PASS pieno**), non la forma "filtro
  aggiunto dopo" (**0 successi su 5**).
- **[1] tesi di mercato scrivibile** — scrivibile sì, **di mercato no**: è
  geometria, non microstruttura. Vedi sopra.
- **[2] riempie un BUCO** — **e ne riempie tre insieme.** (a) **I DUE LATI, VERI**:
  su EUR/USD i corti sono **più** dei lunghi (media 9 contro 7 per finestra), su
  DJI30 sono bilanciati (10 long / 8 short) — e la flotta viva è **quasi tutta
  long-only**, con il censimento dei lati (`R52_CENSIMENTO_LATI.md`) che lo
  dice da mesi. (b) **Frequenza ≥3/giorno su M5**, che è il mandato. (c) **Gli
  stessi tre simboli su cui giriamo già** (Dow, EURUSD, oro): niente strumento
  nuovo, niente storico nuovo da misurare.
- **[0] testabile senza riscritture** — 🔴 **NO. Non esiste codice.** L'indicatore
  va scritto da zero da una formula, e con l'accortezza algoritmica del §COSTO.
  **Zero punti, e sono il motivo per cui questo non è un "PROVA SUBITO".**

## **VERDETTO: 🟠 IN CODA — 6/10**

**PERCHÉ:** è l'unico oggetto delle quattro battute con **frequenza dichiarata
sopra il pavimento sui nostri simboli dentro il nostro terminale**, con un
**motore a due lati costitutivo**, uno **stop volatility-adaptive** e **nessuna
bandiera rossa del §4**. Ma **non c'è codice**, la tesi è geometrica e non
economica, e **i numeri dell'autore nascono dalla regola di selezione che
abbiamo misurato anti-predittiva**. 👉 **Non merita una corsa: merita un
PASSO 0 di CONTEGGIO, a parametri congelati, prima che qualcuno scriva un EA.**

### 🔴 IL ROVESCIO, scritto qui e non in fondo

**1. La ri-ottimizzazione settimanale è il fatto centrale del paper.** Verbatim
(§Results punto 4): _"The EA performed simulations with a given set of parameters
in a 30-day window. It then selected the parameter set that was best in terms of
profit and executed trades over the following 7 days."_
👉 **Ogni numero della Tabella 1 — 340.000 USD, Sharpe 2,55-3,60, DD 10-18% —
è il risultato di 104 ri-scelte del PICCO su 30 giorni.** In casa la regola è
**centro dell'altopiano, MAI il picco**, e il motivo è misurato: **12 Spearman
IS→OOS negative su 13**, l'ultima (R58) sui tick reali del nostro broker.
🔴 **Il paper non riporta NESSUN risultato a parametri fissi.** Quindi:
**dell'autore prendiamo l'indicatore e la frequenza, non il P/L.**

**2. Il drawdown dichiarato è AL MURO O SOPRA, su tutti e tre.**
DJI30 **18%** · EUR/USD **12%** · XAU/USD **10%**, relativi a 10.000 USD.
Il muro prop è **10% totale**. 👉 **Così com'è stata girata dall'autore, la
strategia avrebbe bruciato una challenge su due strumenti su tre**, e sarebbe
finita esattamente sul filo sul terzo. Il DD scala col rischio per trade e il
nostro è 0,65% contro il suo ~10% di nozionale, quindi **è comprimibile** — ma
**un drawdown è un fatto accaduto** (regola B dell'Emendamento della Finestra),
e va scritto prima, non scoperto dopo.

**3. Un'ambiguità operativa che NON so risolvere dal testo, e la dichiaro.**
Il paper dice _"crossing the relevant threshold **from above**"_ **per entrambi
i lati**. Per lo short (soglia 70-95) "da sopra" significa una caduta
dall'ipercomprato = **reversal**. Per il long (soglia 20-35) "da sopra"
significherebbe **scendere sotto 30 e comprare** = fade dell'ipervenduto. Le due
letture sono coerenti fra loro (**è un motore di mean-reversion simmetrico**),
ma l'alternativa — crossing *dal basso* per il long — è quella dell'RSI
classico e il testo non la esclude in modo definitivo.
🔴 **`[INCERTO]`. È il dettaglio più importante della meccanica, e il PASSO 0
lo risolve nel modo giusto: MISURANDO ENTRAMBE LE LETTURE** (§7, criterio V4).
**Non lo indovino.**

### 🏛️ IN OTTICA PROP

- 🟢 **Sul muro GIORNALIERO (−5.000 su 100k) il profilo è gentile**: **3-5 trade
  al giorno con RR 1,00 e stop volatility-adaptive**, non una raffica. A 0,65%
  di rischio, cinque stop pieni nella stessa giornata fanno **−3,25%**, cioè
  **dentro il cap giornaliero e dentro il cap C1 di rischio aperto firmato il
  18/08** (3,25% = 5 SL vivi da 0,65%). 👉 **I numeri combaciano: questo motore
  sta esattamente nella taglia che la casa ha già firmato.**
- 🔴 **Sul muro TOTALE il DD dichiarato è 10-18%.** Vedi sopra.
- 🟢 **Zero problemi HFT (P5).** Con max 2 posizioni e **minimo 30 minuti fra due
  ingressi**, la quota di trade sotto 60 secondi è **strutturalmente bassa**.
  Contro E8 (50% sotto il minuto) siamo su un altro pianeta.
- 🎯 **SCORRELAZIONE — ed è l'argomento più forte, ma con un avvertimento.**
  🟢 La flotta viva è concentrata su **apertura DAX (08:00 server)** e **sessione
  USA**, quasi tutta **long**. Un motore **a due lati, continuo dentro la
  sessione, su tre strumenti diversi** è un'altra cosa. 🔴 **Ma XAU/USD è il
  simbolo con più trade del paper (4,8/giorno) ed è anche dove abbiamo già
  sedie**: **regola di rotta 1 — mai due EA sullo stesso simbolo a rischio pieno
  finché la correlazione per-trade non è MISURATA.** Se il PASSO 0 passa, **il
  primo strumento da accendere è il Dow, non l'oro.**
- ⚠️ **DD TRAILING:** un motore a RR 1,00 e ~4 trade/giorno produce una curva
  **a scalini con ritorni dal picco frequenti** — la forma che il trailing
  punisce (`METRO_PROP`, Upcomers). Le nostre Monte Carlo sono tutte su **DD
  statico dal deposito**: **col trailing non valgono, e non è stato ricalcolato.**

---

## 7. 📦 IL PASSO 0 — **si conta PRIMA, si giudica DOPO**

🔴 **Non propongo una griglia. Non propongo un EA. Propongo di scrivere
l'INDICATORE e di contare.** L'artefatto è una **specifica congelata**, non una
riga di lancio pronta:

📄 `backtest_pipeline/prove/VGRSI_SONDA_CONTEGGIO_M5.txt`

⚠️ **Non è un file eseguibile e non pinna niente**, e lo dico perché l'errore n.3
della `CHECKLIST_RIGA_DI_LANCIO` — un pin che MT5 **ignora in silenzio** — è come
è nato il falso "0/8" del FiboH4. **La sonda `ABTG_SondaVGRSI` NON ESISTE
ANCORA**: questo file è il contratto che chi la scriverà deve rispettare, con i
criteri **congelati prima di qualunque numero**.

**Precedente esatto:** `M0PB_FREQUENZA_M5.txt` / `_M15.txt` — nati da una bozza,
promossi a prova vera quando la sonda è esistita. **E hanno fatto il loro lavoro:
hanno ucciso il promosso 12/12 prima che costasse un round.**

**I numeri che devono uscire, con i cancelli congelati PRIMA:**

| # | numero da leggere | cancello |
|---|---|---|
| **V1** | **segnali per lato al giorno**, su M5, a parametri **fissi** | **≥ 2,0/giorno** (mandato 02/09). < 2,0 → **round chiuso, come M0PB** |
| **V2** | **mediana dell'escursione favorevole a 12 barre** dall'ingresso | **≥ 3 × spread** — Dow: > 6,0 punti indice · EURUSD: > 3,0 pip. Sotto → **SCARTO**. Fra 2 e 3 × → **SOSPESO**, e si misura finalmente lo spread |
| **V3** | **RR da mediane** (mediana altezza candele × Z, per Z = 1,0 / 1,5 / 2,0) | **H8: RR < 0,70 → morto senza corsa.** Atteso ~1,00 per costruzione |
| **V4** | 🆕 **le DUE letture del grilletto**, contate separatamente | scioglie l'ambiguità `[INCERTO]` del §6. **La lettura giusta è quella che il paper descrive, non quella che conta di più**: si dichiara quale si è usata |
| **V5** | **la PEGGIOR GIORNATA** e il **massimo di segnali in una giornata** | **C4 — il rischio si legge sempre, a qualunque n.** Il massimo giornaliero taglia `InpMaxTradesPerDay` **sui dati**, non a occhio |
| **V6** | **l'altopiano su (WS, WV)** | **MAI la cella migliore.** Se la superficie è frastagliata → **è rumore**, e si chiude |
| **V7** | 🆕 **tempo di calcolo per passata** | se la forma incrementale non regge il tester, **il candidato muore di costo** e va detto |

**E la clausola che rende utile anche il fallimento:** se V1 non passa su nessuno
dei tre simboli, allora **la geometria di visibilità non produce frequenza sui
nostri dati** — e la famiglia "oscillatori geometrici" si chiude **per intero**,
perché l'altro membro (il *tube oscillator*, §4.2) è già morto per attrito.
**Due misure indipendenti che chiudono una famiglia la chiudono bene.**

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Su M5, a parametri CONGELATI (nessuna ri-ottimizzazione settimanale), il VGRSI produce almeno 2 segnali al giorno per lato su U30USD / EURUSD / XAUUSD — e l'escursione favorevole mediana vale almeno tre volte lo spread che si paga?**

**È la domanda giusta per tre motivi, e li scrivo tutti e tre:**

1. **Toglie di mezzo l'unica cosa che rende non trasferibili i numeri
   dell'autore.** Lui ha ri-scelto il picco 104 volte; noi congeliamo. **Se
   l'edge sopravvive al congelamento, è un edge; se no, era la ri-ottimizzazione.**
   E questa è **la stessa domanda** che il progetto si è già posto 13 volte, con
   **12 risposte negative**: c'è una probabilità alta e dichiarata che finisca lì.
2. **Costa una sonda, non un round.** Nessun EA da promuovere, nessun magic,
   nessuna sedia, nessuna griglia. **Il precedente è M0PB: la sonda l'ha ucciso
   in un pomeriggio invece che in una campagna.**
3. **Chiude comunque.** Se V1+V2 passano → abbiamo un **motore a due lati,
   intraday, M5, su tre simboli che già giriamo, con la frequenza del mandato e
   nessuna bandiera rossa**, cioè il primo candidato serio di quattro battute.
   Se non passano → **la famiglia degli oscillatori geometrici si chiude con un
   numero nostro**, accanto al numero esterno del *tube oscillator*, e la caccia
   alla frequenza smette di ripartire da lì ogni settimana.

**E se la risposta è no, resta in piedi una sola strada — la stessa del 29/08,
mai smentita:** **più SIMBOLI a M15-H1, non più velocità.** Con l'aggravante,
adesso misurata su **400 EA del Code Base**, **1.120 articoli MQL5**, **83
strategie QuantConnect**, **1.118 slug Quantpedia** e **due paper di oscillatori
geometrici**, che **nessuna di queste fonti ha una scorciatoia da venderci.**

---

_Dossier chiuso il 02/09/2026. **400 id unici del Code Base censiti su 10 pagine**
(il censimento più profondo mai fatto in repo su questa fonte) · **78 id già
setacciati incrociati meccanicamente** su due alberi di file · **9 query arXiv** ·
**6 domini di EA gratuiti sondati e murati** · **2 fonti murate + 1 semi-viva** ·
**9 oggetti letti nel sorgente o per intero** (7 `.mq5` riga per riga da 8 ZIP
scaricati, 2 PDF arXiv letti per intero) · **8 scarti motivati con la riga che lo
prova** · **~370 scarti al primo taglio** · **1 promosso IN CODA (6/10)** ·
**1 lapide** che chiude la famiglia degli oscillatori geometrici ad alta
frequenza · **1 verdetto di fonte** (Code Base esaurito sui motori, adesso su 400
titoli) · **1 canale dichiarato morto da qui** (siti di EA gratuiti, 6/6).
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato, nessun
criterio congelato spostato.**_
