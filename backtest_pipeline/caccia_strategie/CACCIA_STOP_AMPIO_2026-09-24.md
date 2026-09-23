# 🏹 CACCIA ALLO STOP AMPIO PER COSTRUZIONE — 24/09/2026

_Cacciatore di strategie · repo `/home/user/GITHUB`, branch `lavoro`, HEAD `aa62d5ef`._

> 🔒 **PERIMETRO, dichiarato prima di tutto il resto.**
> **Zero EA scritti o toccati. Zero preset, zero `.set`, zero `.ini`. Zero round
> lanciati. Zero terminali. Zero forward. Zero righe verso Claudio.** Il conto
> reale `10105439` non compare in nessun comando.
> **Scritto: questo solo file.** Il blocco di file prova del §8 è una **BOZZA
> dentro il dossier**, non un file in `prove/`: nulla esce senza il PASS dei due
> strati del cancello, e il cancello non l'ho ancora chiamato.

---

# 0. 🥁 LA RIGA CHE VA LETTA PER PRIMA

> ## Su **1.280 titoli del Code Base + 680 strategie TradingView indicizzate con 109 ricerche per MECCANISMO**, **974 archivi `.mq5` e 456 sorgenti Pine scaricati e passati al setaccio**, **40 sorgenti letti riga per riga**, **3 li proverei** — e il primo **non richiede una riga di codice nuova**: è una **geometria di box mai provata su un EA che abbiamo già in casa**.

E le due righe che valgono quanto la prima:

> 🔴 **IL CODE BASE NON HA NULLA PER QUESTO MANDATO, ED È MISURATO.** Delle **974**
> cartelle scaricate, **462** contengono un `OnTick`, **28** sono pulite dalle
> bandiere dure E hanno uno stop E un ATR — e di quelle **28, ZERO hanno uno stop
> ampio per costruzione**: le ho aperte e lo stop è **una costante in punti** in
> tutte (§3.3, con le righe). Non è sfortuna: è la distribuzione della fonte.

> 🟢 **E LA COSA CHE CAMBIA IL MANDATO È UN CONTO, NON UN CANDIDATO.** Con la legge
> di casa `ATR(T) = ADR × √(T/1440)` (validata a **−1%**,
> `report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md`) la **frontiera del 40×
> si attraversa fra `1,5 × ATR(H1)` e `2,0 × ATR(H1)`**. Sopra `2,0 × ATR(H1)`
> (= `1,0 × ATR(H4)`) **passano TUTTI E QUATTRO i simboli**, DAX Dow Nasdaq e Oro,
> anche al bordo pessimista dello spread. 👉 **Non serve andare a D1 per pagare il
> pedaggio: serve arrivare a un ATR di H4.** Questo è il numero operativo della
> nottata, e vale anche per gli EA che abbiamo già.

---

# 1. 🚦 LA TABELLA CHE SERVE SUBITO — `stop / spread`, ORDINE DECRESCENTE

**Come è costruita, prima dei numeri.** Ogni meccanismo è espresso come multiplo di
una grandezza **misurata in casa**, poi diviso per lo **spread misurato in casa**.

| ingrediente | valore | provenienza | tag |
|---|---:|---|---|
| ADR `D30EUR` · spread | **252,5** idx · **1,70** | `MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §5 e §3.2 | 🟢 `[MISURATO]` n=52 |
| ADR `U30USD` · spread | **379,5** idx · **3,00** (bordo prudente) | idem | 🟢 `[MISURATO]` n=24 |
| ADR `NASUSD` · spread | **384,6** idx · **1,80** | idem | 🟢 `[MISURATO]` n=26 |
| ADR `XAUUSD` · spread | **62,60 $** · **0,2503** | idem §6 (ancora calcolata lì, n=67) | 🟢 `[MISURATO]` |
| `ATR(T) = ADR × √(T/1440)` | residuo **−1%** su `U30USD` H1 | `ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` §4 | 🟡 `[DERIVATO, validato]` |
| pavimento di lavoro · pavimento duro | **40×** · **13,3×** | `R125_ORB_COSTO_CRITERI.md` §2 via `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.168-171 | 🟢 regola di casa |

## 1.1 🎯 LA TABELLA

| # | meccanismo — **dove sta lo stop, con la formula** | D30EUR | U30USD | NASUSD | XAUUSD | 40× ? |
|---:|---|---:|---:|---:|---:|---|
| 1 | **Outside bar, ingresso all'estremo** · SL = estremo opposto della barra esterna ≈ **1,20 × range del giorno** | **178,2×** | **151,8×** | **256,4×** | **300,1×** | 🟢 tutti (min 152×) |
| 2 | **Camarilla L4↔H4** · SL al livello opposto = `1,10 × range del giorno precedente` | **163,4×** | **139,2×** | **235,0×** | **275,1×** | 🟢 tutti (min 139×) |
| 3 | **Rottura del giorno precedente, SL all'estremo opposto** = `1,00 × ADR` | **148,5×** | **126,5×** | **213,7×** | **250,1×** | 🟢 tutti (min 127×) |
| 3b | *(riferimento)* **`1,0 × ATR(D1)`** | 148,5× | 126,5× | 213,7× | 250,1× | 🟢 tutti |
| 4 | **`2,0 × ATR(H4)`** | 121,3× | 103,3× | 174,5× | 204,2× | 🟢 tutti |
| 5 | **Outside bar, ingresso al 50% (LIMIT)** · SL = estremo della barra ≈ **0,60 × ADR** | **89,1×** | **75,9×** | **128,2×** | **150,1×** | 🟢 tutti (min 76×) |
| 6 | **Corpo della candela D1 di ieri** (Rouro, `slType="Body"`) ≈ `0,55 × ADR` | **81,7×** | **69,6×** | **117,5×** | **137,6×** | 🟢 tutti (min 70×) |
| 7 | **Outside bar su H4, ingresso all'estremo** ≈ `1,20 × ATR(H4)` | 72,8× | 62,0× | 104,7× | 122,5× | 🟢 tutti |
| 8 | 🎯 **`1,0 × ATR(H4)` = `2,0 × ATR(H1)` — LA FRONTIERA COMODA** | **60,6×** | **51,6×** | **87,2×** | **102,1×** | 🟢 tutti (min 52×) |
| 9 | `1,5 × ATR(H1)` | 45,5× | **38,7×** | 65,4× | 76,6× | 🟠 **MISTO**: il Dow cade |
| 10 | `2,0 × ATR(M30)` *(≈ la cella viva `770411`, 2,5 ATR M15)* | 42,9× | **36,5×** | 61,7× | 72,2× | 🟠 **MISTO**: il Dow cade |
| 11 | **Outside bar su H4, ingresso al 50%** ≈ `0,60 × ATR(H4)` | **36,4×** | **31,0×** | 52,3× | 61,3× | 🟠 **MISTO** |
| 12 | `1,0 × ATR(H1)` | **30,3×** | **25,8×** | 43,6× | 51,1× | 🔴 due su quattro |
| 13 | 🪦 **APERTURA · BREAKOUT / GAPFILL** — `R + 2B + S` = **63,1 idx** (dato del mandato) | **37,1×** | — | — | — | 🔴 **NO** |
| 14 | 🪦 **APERTURA · RETEST** — `R + B − O` = **56,1 idx** | **33,0×** | — | — | — | 🔴 **NO** |
| 15 | 🪦 **APERTURA · DELAYED** — `entry − L` = **53,1 idx** | **31,2×** | — | — | — | 🔴 **NO** |

### 🔴 UN'INCOERENZA CHE SEGNALO INVECE DI NASCONDERE (e non cambia nessun verdetto)

Il mandato dà lo stop BREAKOUT del DAX a **63,1 idx**. Ma `MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md`
§4.2 misura il **range di 35' stesso** a `49,1 × 1,70 =` **83,5 idx** (coerente con
`R₁₅ = 54,65` misurato al §6.1: `83,5 × √(15/35) = 54,7` ✅). 🔴 **Uno stop che vale
`R + 2B + S` non può essere il 24% PIÙ PICCOLO di `R`.** Le due misure vanno
riconciliate da chi le ha prese.
🟢 **Perché non tocca questo dossier**: prendendo il numero **più generoso** dei due
(83,5 idx → 49,1×), l'Apertura DAX resta **3,3 volte** sotto il candidato n.1 e
**1,2 volte** sopra il pavimento — mentre tutti i promossi stanno fra **70× e 300×**.
Il contro-esempio è costruito e **non ribalta niente**.

---

# 2. ✅ CONTROLLO POSITIVO — fonte per fonte, MISURATO stanotte

| fonte | bersaglio | esito misurato | verdetto |
|---|---|---|---|
| **MQL5 Code Base** (elenco) | `/en/code/mt5/experts` + `page9..page40` | 🟢 **200** · 89.438 byte · **40 `id + title` per pagina** su 32 pagine → **1.280 ID unici** | 🟢 **PASSA** |
| **MQL5 sorgente** | `/en/code/download/<ID>` (zip, senza nome file) | 🟢 **200** · **1.280 zip**, **974 validi**, **1.528 `.mq5`/`.mqh`** estratti | 🟢 **PASSA** |
| **TradingView ricerca** | `pubscripts-suggest-json/?search=` | 🟢 **200** · **109 ricerche** · **680 strategie uniche** con autore, `agreeCount`, `access` | 🟢 **PASSA** |
| **TradingView sorgente** | `pine-facade.../get/PUB%3B<hash>/last` | 🟢 **200** · **456 sorgenti** in chiaro · **224 falliti** (`access` 2/3 = protected/invite: **niente sorgente, §4**) | 🟢 **PASSA** |
| **arXiv** — elenco mensile | `arxiv.org/list/q-fin.TR/2026-09` | 🟢 **200**, 45.214 byte | 🟢 **PASSA** |
| **arXiv** — ricerca HTML | `arxiv.org/search/?searchtype=all&query=…` | 🟢 **200**, 83.109 byte, titoli parsabili | 🟢 **PASSA** |
| 🔴 **arXiv — API** | `export.arxiv.org/api/query` | 🔴 **406 Not Acceptable** su 6 tentativi, con e senza `User-Agent`, http e https | 🔴 **NULLA stanotte** — e **406 ≠ 404**: si riprova |
| **GitHub** — raw | `raw.githubusercontent.com/EarnForex/ATR-Trailing-Stop/main/README.md` | 🟢 **200**, 729 byte | 🟡 **PARZIALE** |
| 🔴 **GitHub** — API/ricerca | `api.github.com/search/repositories` | 🔴 **403**, 249 byte | 🔴 **NULLA** — nessun elenco repo, nessuna ricerca per meccanismo |
| 🟠 **Quantpedia** | `quantpedia.com/strategies/` | 🟠 **308 → `/screener`**, 641.494 byte, **0 link `/strategies/<slug>/` nell'HTML** (contenuto in JS) | 🔴 **raggiunta, NON setacciabile** |
| 🔴 **SSRN** | `papers.ssrn.com/sol3/papers.cfm?abstract_id=1911243` | 🔴 **403**, 5.526 byte | 🔴 **NON raggiunta** |
| 🔴 **Forex Factory** | `/forum/71-trading-systems` | 🔴 **403**, 5.469 byte | 🔴 **NON raggiunta** |
| ⚪ **QuantConnect** | `/learning/articles` | ⚪ **301**, redirect non seguito per tempo | ⚪ **NON MISURATA — buco dichiarato** |

⚠️ **Popolarità del Code Base: `[NON MISURATA]`** — i contatori di download sono in JS,
non nell'HTML. Non li invento e non li peso. Su TradingView `agreeCount` **è nel JSON**
ed è riportato come numero della pagina, non mio.

---

# 3. 🔎 IL SETACCIO, COL NUMERO

## 3.1 L'imbuto completo

| passaggio | Code Base | TradingView | totale |
|---|---:|---:|---:|
| titoli/strategie indicizzati | **1.280** | **680** | **1.960** |
| sorgenti scaricati | 1.280 zip → **974** validi | **456** | **1.430** |
| file di codice estratti e decodificati (UTF-16 incluso) | **1.528** | 456 | 1.984 |
| contengono un motore (`OnTick` / `strategy.exit`) | **462** | **301** *(su 456, dopo le rosse)* | 763 |
| puliti dalle **bandiere dure** E con uno stop | **162** | **301** | 463 |
| 🎯 **stop legato a una STRUTTURA più grande di un range intraday** | 🔴 **0** | **22** | **22** |
| **letti riga per riga a mano** | **28** | **12** | **40** |
| 🏅 **promossi** | **0** | **3** | **3** |

## 3.2 Le bandiere rosse trovate (regex sul sorgente, non sulla descrizione)

| bandiera | Code Base (su 462) | quota |
|---|---:|---:|
| `iCustom` di un indicatore esterno | 240 | 51,9% |
| **martingala** (`lot*=`, `LotExponent`, `MathPow(..Multiplier)`) | 7 | 1,5% |
| `#import` di `.dll` | 4 | 0,9% |
| griglia / averaging | 1 | 0,2% |
| `WebRequest` | 1 | 0,2% |

⚠️ **Precisione dichiarata**: sono espressioni regolari, quindi `[DERIVATI]` con residuo
di falsi positivi e negativi. Il 51,9% di `iCustom` è alto perché conto **tutti** i file
dell'archivio: quando l'indicatore è **allegato nello stesso zip** la bandiera non è
applicabile, e infatti l'ho trattata come **morbida** nel conteggio dei 28 letti a mano.
Le bandiere **dure** (martingala, griglia, recovery, DLL, WebRequest) restano dure.

## 3.3 🔴 IL VERDETTO SUL CODE BASE, con le righe che lo provano

Dei **28** sorgenti puliti+stop+ATR, li ho aperti e lo stop è **sempre una costante in
punti**. Tre prove, verbatim:

```mql5
// ID 19343  Exp_NRTR_ATR_STOP_Tm   (il nome PROMETTE uno stop da ATR)
input int StopLoss_ = 1000;                      // "стоплосс в пунктах" = stop IN PUNTI
ATR_Handle = iATR(Symbol(), PERIOD_CURRENT, ATR_Period);   // l'ATR serve all'INDICATORE, non allo stop
```
```mql5
// ID 18160  Exp_Kolier_SuperTrend_X2
input uint StopLoss_ = 1000;                     // stop in punti
```
```mql5
// ID 20705  RSI Bollinger Bands EA   (l'UNICO con un ATR su H4 in tutto il raccolto)
input ushort InpStopLoss_Buy_1 = 70;             // "(in pips)"
handle_iATR = iATR(m_symbol.Name(), PERIOD_H4, ATRPer);    // usato per FILTRARE, non per lo stop
ExtStopLoss_Buy_1 = InpStopLoss_Buy_1 * m_adjusted_point;  // lo stop resta la costante
```

> 🎯 **Classe da ricordare: un `iATR(...,PERIOD_H4,...)` nel sorgente NON vuol dire
> "stop ampio".** In tutti e tre i casi l'ATR alimenta il segnale e lo stop resta una
> costante. **Il filtro automatico "c'è un ATR" produce falsi positivi al 100% su
> questo raccolto** — e si scopre solo aprendo il file.

🟢 **Conclusione onesta:** per questo mandato **il Code Base è una fonte NULLA**, e lo
scrivo come risultato, non come scusa. È coerente con `CACCIA_MECCANISMI_2026-09-23.md`
(*«il raccolto del Code Base non sono motori: sono pannelli»*): le prime pagine di
stanotte sono `Safe Risk Manager EA`, `PropFirm Risk Guardian`, `One-Click Trade Manager`.
👉 **Raccomandazione operativa: smettere di rastrellare l'elenco del Code Base per
MOTORI.** Le pagine 1-40 sono state setacciate fra il 13/09, il 23/09 e stanotte.

---

# 4. 🧭 QUALE BUCO STAVO CERCANDO — letto PRIMA di uscire

Letti: `report/ROBUSTEZZA.md`, `report/ROTTA_PROP.md`,
`report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md`,
`report/INVENTARIO_MOTORI_APERTURA_2026-09-24.md`,
`report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md`,
`backtest_pipeline/REGISTRO_TEST.md` (4.145 righe),
`backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md`,
`backtest_pipeline/caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md`.
Censiti gli EA di casa: **104 `ABTG_*.mq5`** unici in `mql5/Experts/`.

**Il buco, in una riga**: in casa **ogni** motore intraday appende lo stop a una
struttura **di giornata o più piccola** — range d'apertura (Apertura ×3), box notturno
(`MaxMinNotte`), ATR del TF di gestione (M15/M30), Supertrend (`SupRev`, H1/H4).
🔴 **Nessun motore in casa costruisce lo stop sul GIORNO PRECEDENTE.**
E il repo lo aveva già scritto, cinque giorni fa, senza dargli seguito:

> `REGISTRO_TEST.md` r.3809-3815 (**R187**, 19/09): *«i livelli a grafico sono `Max sett.
> prec. · Max notturno · Max giorno prec. · Apertura giorno · Min notturno`, e il nostro
> EA delle aperture sul Nasdaq **non usa nessuno di questi**. […] Quando tre ingressi
> diversi sullo stesso livello sbagliano, l'indiziato è il LIVELLO.»*

## 4.1 🛑 IL PASSAGGIO DALLA LISTA DEI CADUTI — e un'obiezione che devo affrontare

`CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md` r.266 dichiara **chiusa** la famiglia
*«breakout / range / ORB / initial balance»* e ci mette dentro, per nome, **proprio**
`Previous Day High and Low Breakout` e `Camarilla Strategy — breakouts of H4 and L4`,
con la motivazione: *«famiglia chiusa da ~210 celle a tick (R45 **0/48**, R12 **48/48
negative OOS**)»*.

🔴 **Devo prenderla sul serio, e la prendo. Ma la chiusura non copre questi candidati, e
si vede da cosa hanno MISURATO R45 e R12:**

| | cosa ha misurato | stop | `stop/spread` |
|---|---|---|---|
| **R45** | ORB di Londra, `InpRangeStartHour=7` (`REGISTRO_TEST.md` r.127) | range di **1 ora** | ~31-37× |
| **R12** | ORB, range intraday | range di **30-60'** | ~31-37× |
| 🎯 **i candidati di stanotte** | livelli del **GIORNO PRECEDENTE** | **1,0-1,2 × ADR** | **70-300×** |

👉 **È la stessa PAROLA («breakout di un livello») ma non è la stessa GEOMETRIA**: lo
stop è **da 3,4 a 8,1 volte più largo**, e il motivo per cui l'ORB muore — il pedaggio —
è **esattamente la variabile che cambia**. Chiuderli insieme è l'**errore di categoria**
che `REGISTRO_TEST.md` r.126 già rimprovera al censimento dell'Apertura
(*«due dei sei non sono breakout d'apertura, ed è un errore di categoria»*).
🟠 **E dichiaro il rischio contrario**: se il segnale del breakout di livello è morto
*di suo*, allargare lo stop non lo resuscita — semplicemente perde più lentamente. **Per
questo il primo test costa dieci minuti e non una giornata** (§8).

---

# 5. 🏅 I TRE PROMOSSI

## 5.1 🥇 CANDIDATO 1 — **BOX DEL GIORNO PRECEDENTE** (stop all'estremo opposto)

```
NOME            Previous Day High and Low Breakout Strategy
FONTE / URL     https://www.tradingview.com/script/c3wgFOxdo49IKxOLddlh7DTSIXEl1jGO/
                (sorgente via pine-facade, PUB;c3wgFOxdo49IKxOLddlh7DTSIXEl1jGO)
AUTORE / DATA   ceyhun · Pine v4 · data di pubblicazione [NON MISURATA: non nel JSON]
POPOLARITA'     958 agree  [VERIFICATO nel JSON di ricerca]
LICENZA         Mozilla Public License 2.0  [VERIFICATO, riga 2 del sorgente]
RIGHE / INPUT   29 righe / 0 input

DOVE STA LO STOP, CON LA FORMULA
  🔴 NEL CODICE: DA NESSUNA PARTE. Zero occorrenze di strategy.exit.
     Il sorgente e' uno stop-and-reverse sempre a mercato:
         if crossover(high, D_High)   -> strategy.entry("Long",  strategy.long)
         if crossunder(low,  D_Low)   -> strategy.entry("Short", strategy.short)
  🟢 NEL COMMENTO DELL'AUTORE (righe 11-12), ed e' la geometria che vale:
         "Go Long  - if prev day high is broken and stop loss prev day low"
         "Go Short - if prev day low  is broken and stop loss prev day high"
     => SL = estremo OPPOSTO del giorno precedente
     => distanza ingresso->SL = 1,00 x range del giorno precedente = 1,00 x ADR

STOP / SPREAD   D30EUR 148,5x · U30USD 126,5x · NASUSD 213,7x · XAUUSD 250,1x
                🟢 PASSA il 40x con un margine da 3,2 a 6,3 volte.

TESI IN UNA RIGA
  "Guadagna perche' il range del giorno precedente e' il livello su cui si e'
   fermata la distribuzione di ieri: romperlo significa che un partecipante
   nuovo ha accettato un prezzo che ieri nessuno accettava, e quel disaccordo
   si paga in continuazione."

MECCANICA       ingresso: rottura del massimo/minimo del giorno precedente
                uscita:   [DA COSTRUIRE - l'autore non ne ha]
                stop:     estremo opposto del giorno precedente

GESTIONE RISCHIO 🔴 ASSENTE nel sorgente: nessun lotto, nessun rischio %, nessun flat.
BANDIERE ROSSE   🔴 NESSUNO STOP LOSS nel codice (§4 del mandato: e' la bandiera).
                 🟢 repaint: NO - security(tickerid,'D',high[1]) usa la barra D1
                    GIA' CHIUSA. In Pine v4 security() e' lookahead_off per
                    default, e l'indice [1] toglie anche il dubbio.
                 🟢 niente martingala, niente griglia, niente DLL, niente iCustom.
COSTO DI PORTING 🟢 ZERO ORE. Vedi sotto: non si porta, si CONFIGURA.

PUNTEGGIO
  [2] semplicita'          29 righe, 0 input
  [2] il filtro E' il motore   il livello E' la strategia, non un cerotto
  [2] tesi di mercato scrivibile
  [2] riempie un BUCO       nessun EA di casa usa il giorno precedente (R187)
  [2] testabile senza riscritture   ZERO codice nuovo (vedi §5.1.1)
VERDETTO   🟢 PROVA SUBITO (10/10)
PERCHE'    e' la geometria con lo stop piu' largo che sappiamo gia' eseguire,
           e il primo test costa dieci minuti di banco.
```

### 5.1.1 🔥 LA COSA CHE RENDE QUESTO CANDIDATO IL NUMERO UNO — **non serve scrivere niente**

`ABTG_MaxMinNotte.mq5` **fa già esattamente questo motore**, e le manopole sono libere.
Verificato riga per riga sul nostro sorgente:

```mql5
// mql5/Experts/standalone/ABTG_MaxMinNotte.mq5
r.37-40  input int InpBoxStartHour = 23;  InpBoxStartMin = 0;
         input int InpBoxEndHour   = 4;   InpBoxEndMin   = 59;
r.61     input ENUM_MM_SL InpSLMode = MM_SL_ATR;   // <- ha anche MM_SL_OPPOSITE
r.251    if(InpSLMode==MM_SL_OPPOSITE) sl = oppLevel;   // = estremo opposto del BOX
```
e dentro `ComputeBox` (r.177-196) c'è la riga che apre la porta:
```mql5
r.182    if(tStart>=tEnd) tStart -= 86400;   // il box inizia il giorno prima
```

> 🎯 **Quindi un box `InpBoxStartHour=22 / InpBoxEndHour=21, InpBoxEndMin=59` è un box
> di 23h59m = IL GIORNO PRECEDENTE INTERO**, e `InpSLMode=MM_SL_OPPOSITE` mette lo stop
> **all'estremo opposto di quel giorno**. **Zero righe di codice nuove. Zero
> ricompilazioni. Zero porting.**

🔴 **E la casella è VUOTA, verificato**: `REGISTRO_TEST.md` r.3843-3844 elenca le **uniche
due** geometrie di box mai messe su un file prova — `23:00-04:59` (6h) e `23:00-14:29`
(15,5h). **Il giorno intero non è mai stato provato, su nessun simbolo.**

⚠️ **Tre avvertenze, dette prima dei numeri:**
1. **`MaxMinNotte` fuori dal DAX ha una base storica NEGATIVA**, ed è scritto: `100GBP`
   **0/54** celle positive, `E50EUR` **0/54**, `F40EUR` **0/54** (r.2737-2739). Quelle
   corse erano però sul box **notturno**: la geometria di stanotte è un'altra, e va detto
   in tutte e due le direzioni.
2. 🔴 **Un 1R da 1 ADR è un target ESIGENTE.** Con `InpTP1_R=1.0` il primo parziale sta a
   un intero range giornaliero di distanza. 👉 **La leva è già in casa**: `InpSLMode=MM_SL_ATR`
   con `InpMgmtTF=PERIOD_H4` e `InpAtrSLmult` fra **1,0 e 2,0** dà uno stop di
   **51,6× - 204×** (righe 4 e 8 della tabella) con un 1R raggiungibile. **È la stessa
   manopola, già compilata.**
3. ⚠️ **`@DAQUANDO 2024.09.26`** (misurato, `ABTG_StoricoScaricato.csv`) = ~24 mesi. A
   ~0,25 operazioni/giorno il campione arriva a **~125**, cioè **sotto i 150**: il MERITO
   resterà sospeso, il **RISCHIO no** (regola B dell'emendamento della finestra).

**FREQUENZA ATTESA**: `[STIMATA, NON MISURATA]` **~0,2-0,3 op/giorno per simbolo**
(un livello del giorno precedente viene rotto in modo netto in ~20-30% delle sedute).
Su 3 indici + oro = **0,8-1,2 op/giorno di FAMIGLIA** → 🟢 **al pavimento firmato il
07/09**, e non sopra.

**🏛️ IN OTTICA PROP**: un solo pendente OCO per simbolo per giorno, flat a fine giornata
(`InpCloseAtEnd`) → **niente overnight, niente concentrazione di 5 trade correlati in una
mattina**. 🔴 **Ma il rovescio va scritto**: 4 simboli che rompono il livello del giorno
prima **lo stesso giorno** sono 4 ingressi nello stesso momento e nello stesso verso —
è **rischio di giornata**, non diversificazione, e il cap `C1` al 3,25% è ciò che lo tiene.

---

## 5.2 🥈 CANDIDATO 2 — **OUTSIDE BAR, ingresso in ritracciamento, stop dietro la barra**

```
NOME            Outside Bar Strategy %
FONTE / URL     https://www.tradingview.com/script/36101983b9cb4ad9ab3ebff663f8473c/
                (sorgente via pine-facade, PUB;36101983b9cb4ad9ab3ebff663f8473c)
AUTORE / DATA   Alessxio · Pine v6 · data [NON MISURATA]
POPOLARITA'     63 agree  [VERIFICATO nel JSON]
LICENZA         🔴 [INCERTO] - NESSUNA intestazione di licenza nel sorgente.
                Verificato solo che access=1 (leggibile). Leggibile != riutilizzabile:
                in un nostro .mq5 non va UNA riga del suo codice, solo la geometria.
RIGHE / INPUT   114 righe / 16 input

DOVE STA LO STOP, CON LA FORMULA  (righe 54-57 e 75-78, verbatim)
    barSize         = high - low                                  // la barra ESTERNA
    longEntryLevel := low  + barSize * entryPercentage            // default 50%
    longStopLoss   := low  - f_pipsToPrice(stopLossOffsetPips)    // ESTREMO della barra
    longTakeProfit := high + barSize * tpPercentage               // default +100%
  => distanza ingresso->SL = entryPercentage x barSize + offset
  => al 50%: SL = 0,50 x (range della barra esterna)
  => e una barra ESTERNA ingloba per definizione la precedente: su D1 il suo
     range e' >= il range di ieri, quindi >= 1,0 ADR. Uso 1,20 ADR come stima.

STOP / SPREAD   ingresso al 50% su D1 (0,60 ADR):
                  D30EUR 89,1x · U30USD 75,9x · NASUSD 128,2x · XAUUSD 150,1x  🟢
                ingresso all'estremo su D1 (1,20 ADR):
                  178,2x · 151,8x · 256,4x · 300,1x  🟢
                ingresso al 50% su H4 (0,60 ATR H4):
                  36,4x · 31,0x · 52,3x · 61,3x  🟠 DAX e Dow CADONO, Nasdaq e Oro no
                🎯 IL NUMERO CHE DECIDE IL DISEGNO: su H4 questo motore si puo'
                schierare SOLO su NASUSD e XAUUSD, oppure entrando piu' in alto.

TESI IN UNA RIGA
  "Guadagna perche' una barra che ingloba tutto il range della precedente e'
   un doppio fallimento di breakout nello stesso periodo: la sua chiusura dice
   quale dei due lati ha perso, e il ritracciamento dentro la barra offre
   l'ingresso col rischio dietro l'estremo che ha gia' respinto il prezzo."

MECCANICA       ingresso: ordine al <entryPercentage>% del range della barra esterna
                stop:     estremo della barra esterna + offset
                uscita:   TP = estremo opposto + 100% del range  (R:R 3:1 al 50%)
                          + parziale a 1R (partialRR) + BREAKEVEN dopo la parziale

GESTIONE RISCHIO 🔴 lotto fisso implicito (nessun rischio %), 🟢 MA la MECCANICA di
                 uscita e' GIA' LA NOSTRA: parziale a 1R (r.63) + breakeven (r.98,
                 r.103). E' il candidato che ci somiglia di piu'.
BANDIERE ROSSE   🟢 NESSUNA. Stop sempre presente. Niente martingala, griglia,
                 recovery, DLL. Niente lookahead. calc_on_every_tick NON impostato.

🔬 IL DIFETTO CHE SI VEDE SOLO LEGGENDO (e che vale il porting)
  r.60:  strategy.entry('Long', strategy.long, stop = longEntryLevel)
  E' un ordine STOP a META' barra. Ma una barra esterna RIALZISTA chiude VICINO
  AL MASSIMO, quindi il prezzo e' GIA' SOPRA il livello: il buy-stop e' gia'
  violato e riempie all'apertura della barra dopo.
  🔴 => l'input "entryPercentage" e' INERTE come scritto: non si entra mai in
  ritracciamento, si entra a mercato. La descrizione promette un pullback, il
  codice non lo fa.
  🟢 => e nella nostra riscrittura diventa un LIMIT, e allora E' il ritracciamento
  profondo che il mandato chiede -- con R:R 3:1 per costruzione invece di 1:1.
  Questo e' esattamente "il motore si tiene, la gestione si rifa'".

COSTO DI PORTING 🟡 4-6 ore (Pine -> MQL5 = riscrittura). 114 righe, geometria
                 elementare, nessuna dipendenza esterna, nessun indicatore.

PUNTEGGIO
  [2] semplicita'          114 righe, 16 input di cui 8 sono COLORI
  [2] il filtro E' il motore   la barra esterna E' il segnale
  [2] tesi di mercato scrivibile
  [2] riempie un BUCO      🟢 VERIFICATO: ZERO occorrenze di "inside bar",
                           "barra interna" e "outside bar" in TUTTO mql5/Experts/
                           e in REGISTRO_TEST.md. In casa non c'e' NESSUN motore
                           che legga la relazione di INGLOBAMENTO fra due barre.
                           ⚠️ ABTG_IBRetest NON c'entra: "IB" li' sta per
                           INITIAL BALANCE (r.4 del sorgente), non inside bar --
                           e questa e' una trappola di nome che ho sbagliato
                           una volta prima di aprire il file.
  [1] testabile senza riscritture   🔴 no: e' una riscrittura
VERDETTO   🟢 PROVA SUBITO (9/10)
PERCHE'    e' l'unico candidato che porta insieme uno stop strutturale ampio E
           un R:R 3:1 per disegno E una gestione d'uscita gia' identica alla
           nostra: si traduce, non si inventa.
```

**FREQUENZA ATTESA**: `[STIMATA]` su D1 una barra esterna vale ~8-12% delle sedute →
**~0,1 op/giorno per simbolo** 🔴 **troppo poco da solo**. Su **H4** il conteggio barre
è ×6 → ~**0,6 op/giorno per simbolo**, ma su H4 il cancello di costo **esclude DAX e Dow**
(31-36×) se si entra al 50%. 👉 **La cella schierabile a ottobre è H4 su `NASUSD` e
`XAUUSD`**, oppure D1 su tutti e quattro accettando la bassa frequenza. **Questa
tensione fra frequenza e costo va decisa da Claudio, non da me.**

**🏛️ IN OTTICA PROP**: il parziale a 1R + breakeven è già il nostro schema, quindi il DD
per operazione è tagliato a metà dopo il primo target. 🟠 **Ma un motore a bassa frequenza
e alto R ha una curva a scalini con lunghi ritorni dal picco — esattamente la forma che
il DD TRAILING di alcune prop punisce** (`DOSSIER_PROP_UPCOMERS_2026-08-26.md`), e le
nostre Monte Carlo sono tutte su DD statico. **Segnalato, non risolto.**

---

## 5.3 🥉 CANDIDATO 3 — **LIVELLI CAMARILLA H4/L4 del giorno precedente**

```
NOME            Camarilla Strategy - breakouts of H4 and L4
FONTE / URL     https://www.tradingview.com/script/1883/    (PUB;1883)
AUTORE / DATA   cristian.d ("Created by CristianD") · Pine v2 · data [NON MISURATA]
POPOLARITA'     838 agree  [VERIFICATO nel JSON]
LICENZA         🔴 [INCERTO] - nessuna intestazione di licenza. access=1.
RIGHE / INPUT   73 righe / 0 input

DOVE STA LO STOP, CON LA FORMULA
  🔴 NEL CODICE: DA NESSUNA PARTE. Zero strategy.exit, zero strategy.close.
     r.66-72:  longCondition  = close > dtime_h4  -> strategy.entry(long)
               shortCondition = close < dtime_l4  -> strategy.entry(short)
  🟢 LA GEOMETRIA DEI LIVELLI, invece, e' scritta ed e' il valore (r.8-11):
               h4 = close + (high - low) * 1.1 / 2.0
               l4 = close - (high - low) * 1.1 / 2.0
     tutti letti sul giorno PRECEDENTE:  dtime_h4 = security(tickerid,'D',h4[1])
  => H4 sta a +0,55 x range(ieri) dalla chiusura di ieri; L4 a -0,55 x range(ieri)
  => lo stop naturale (livello opposto) = 1,10 x range del giorno precedente
  => lo stop piu' stretto (H3/L3, a +-0,275 x range) = 0,825 x range: passa anche lui

STOP / SPREAD   con SL al livello opposto (1,10 ADR):
                  D30EUR 163,4x · U30USD 139,2x · NASUSD 235,0x · XAUUSD 275,1x
                🥇 il rapporto piu' alto della caccia dopo l'outside bar all'estremo.

TESI IN UNA RIGA
  "Guadagna perche' i livelli Camarilla sono una misura dell'ampiezza di IERI
   proiettata su OGGI: superare H4 vuol dire che la giornata sta gia' facendo
   piu' del 55% del range di ieri in una sola direzione, cioe' e' una giornata
   di TENDENZA e non di rotazione -- ed e' una classificazione che si fa a
   mercato aperto, non a posteriori."

MECCANICA       ingresso: chiusura oltre H4 (long) / L4 (short)
                stop:     [DA COSTRUIRE] livello opposto, o L3/H3
                uscita:   [DA COSTRUIRE]  -- l'autore non ne ha

GESTIONE RISCHIO 🔴 ASSENTE. Nessun lotto, nessun rischio %, nessun flat.
BANDIERE ROSSE   🔴 NESSUNO STOP LOSS nel codice.
                 🟠 repaint [INCERTO->risolto]: security() in Pine v2 NON ha
                    lookahead esplicito, MA tutti i livelli usano l'indice [1]
                    (barra D1 gia' chiusa), quindi il valore e' noto all'apertura
                    della giornata. 🟢 NON ridipinge.
                 🟢 niente martingala, griglia, DLL.
COSTO DI PORTING 🟡 2-3 ore: i livelli sono 4 righe di aritmetica su iHigh/iLow/
                 iClose di PERIOD_D1. La gestione la mettiamo noi per intero.

PUNTEGGIO
  [2] semplicita'          73 righe, 0 input, 4 righe di aritmetica
  [2] il filtro E' il motore
  [2] tesi di mercato scrivibile
  [2] riempie un BUCO      ZERO occorrenze di "camarilla" e "pivot point" in
                           REGISTRO_TEST.md e in mql5/Experts/  [VERIFICATO]
  [1] testabile senza riscritture   serve un EA nuovo (piccolo)
VERDETTO   🟢 PROVA SUBITO (9/10)
PERCHE'    stesso buco del candidato 1 (il giorno precedente) ma con un livello
           GRADUATO: H1..H6 danno sei distanze diverse sullo stesso segnale,
           cioe' un asse di taratura che NON e' un parametro libero ma una scala.
```

🟠 **E lo dico contro me stesso**: il candidato 3 e il candidato 1 leggono **la stessa
informazione** (il range di ieri) in due modi diversi. **Se il candidato 1 fallisce, la
probabilità che fallisca anche il 3 è alta.** Vanno messi in coda **uno dopo l'altro,
non in parallelo** — e il primo è quello che costa zero.

> 🔎 **Nota storica, perché è già successo**: `CACCIA_INTRADAY_INDICI_2026-08-28.md` r.439
> aveva **già letto** la versione V1 di questo script e scritto *«✅ Spunto forte: i livelli
> Camarilla sono una famiglia di livelli intraday derivati dal giorno prima che non
> abbiamo»*. **Poi il 02/09 è stato chiuso per famiglia, senza essere misurato.** Questa
> è la seconda volta che arriva allo stesso punto: se non si misura adesso, la terza
> caccia lo ritroverà di nuovo.

---

# 6. 📋 GLI SCARTATI — una riga di motivo a testa

## 6.1 Scartati per il CANCELLO DELLO STOP (il filtro di stanotte)

| candidato | fonte | dove sta lo stop | `stop/spread` | motivo |
|---|---|---|---:|---|
| `US 30 Daily Breakout Strategy` | TV · yavanmahur · 73 agree | `stop_loss_pips = 50` **costante** (r.8) | **16,7×** su U30USD | 🔴 ingresso giusto (giorno prec.), **stop a punti fissi**: sfonda il pavimento del 58% |
| `Two-Bar Fib Retrace Strategy [Futures]` | TV · UkesTrades · 648 agree | `sl_bull = b2l - slOffset` = low della 2ª barra d'impulso (r.183) | ~0,45 × ATR(TF) → **13,6×** su DAX H1 | 🔴 struttura di **due barre del TF di lavoro**, non superiore. E **nessun TP e nessuna uscita**: la posizione resta aperta finché non muore. 1.011 righe |
| `BTC Momentum Strategy` (drypacific) | TV · 245 agree | `close - atr(14) * 1.5` su M5/M15 (filtro `timeframeFilter`) | **~11×** su DAX M15 | 🔴 `1,5 × ATR` su M5/M15 è la geometria che stiamo già scartando |
| `Trend Following S/R Fibonacci Strategy 2` | TV · takeutawayfromme2022 · 60 agree | `close - atr(14) * 2.0` sul TF del grafico | 42,9× su M30 DAX, 🔴 36,5× su Dow | 🟠 **passa solo in parte**, e il motore (EMA20/50 + rimbalzo su pivot) è un **doppione** di `ABTG_EMA200` + `ABTG_SupRev` |
| `Outside Bar, ingresso al 50% su H4` | (il ns. candidato 2, cella H4) | 0,60 × ATR(H4) | DAX **36,4×**, Dow **31,0×** | 🟠 **cella esclusa per costo su DAX e Dow**, ammessa su Nasdaq e Oro. Scritto nella scheda |

## 6.2 Scartati per BANDIERA ROSSA o assenza di sorgente

| candidato | fonte | motivo |
|---|---|---|
| `Three (3)-Bar and Four (4)-Bar Plays Strategy` | TV · tormunddookie · 110 | 🔴 **`calc_on_every_tick=true`** nella dichiarazione `strategy()` (r.4) — bandiera §4 |
| `Dow Theory Trend Strategy` | TV · Salaryman_G | 🔴 già scartato il 13/09: stop-and-reverse senza `strategy.exit`. Non ricontrollato |
| `Buy On Open After Outside Bar` | TV · thingsofleon · 66 | 🟠 stop = low della barra esterna (geometria buona) ma **long-only, TP in % fissa (2%), Pine v3**: è una versione degradata del candidato 2 |
| `Failure Swing Strategy (stop hunting) V1` | TV · Heavy91 · 470 | 🔴 `access=2` (protected) → **niente sorgente** → il setaccio non è applicabile |
| `Minervini Pullback Strategy_Trend-Template` | TV · JS_TechTrading · 248 | 🔴 `access=3` (invite-only) → niente sorgente |
| `Outside Bar Strategy with Multiple Entry Models` | TV · FXTDPR · 95 | 🔴 `access=2` → niente sorgente |
| `Previous Day Breakout Trend Following` | TV · bsjawle · 32 | 🔴 `access=2` → niente sorgente |
| `O'Neil Style Breakout - Weekly TF` | TV · mohannedfx · 3 | 🔴 `access=2` → niente sorgente |
| **224 sorgenti Pine** su 680 | TV | 🔴 `access` 2/3: protetti o a invito. **Il 33% della fonte non è leggibile** |
| `The Flash-Strategy` (Minervini Stage) | TV · JS_TechTrading · 716 | 🔴 **doppione**: lo stop è il **Supertrend** (r.115/120) = `ABTG_SupRev`, famiglia viva |
| `Swing Points Breakouts` | TV · tweakerID · 109 | 🔴 **doppione dell'INGRESSO**: `REGISTRO_TEST.md` r.3387 — *«`ABTG_CanaleLento` **È** Donchian 55/20»*. 🟢 Ma lo **stop all'estremo opposto del canale** (`LSL = SwingLow at entry`) è una variante di uscita che `CanaleLento` non ha → **IN CODA come MIGLIORIA**, non come motore nuovo |
| `Exp_*` (19 EA, Code Base) | Code Base | 🔴 stop = `input int StopLoss_ = 1000` in **punti**, template di fabbrica. §3.3 |
| altri 9 EA Code Base puliti | Code Base | 🔴 stop costante in pips/punti, nessuna struttura |
| `Periodic Range Breakout (Martingale)` (30560) | Code Base | 🔴 **martingala dichiarata nel titolo** |

## 6.3 🔴 LA LISTA A PARTE CHIESTA DAL MANDATO — «non dichiarano dove sta lo stop»

Il mandato chiede una lista separata per chi **non è valutabile**. Eccola, e sono **tre**:

| candidato | perché non è valutabile |
|---|---|
| `Previous Day High and Low Breakout Strategy` (ceyhun, 958) | lo stop è **nel commento**, non nel codice. 🟢 **L'ho promosso lo stesso** perché il commento dice la formula per intero e la geometria è verificabile: ma va dichiarato che **il numero non viene dal codice eseguito** |
| `Camarilla Strategy H4/L4` (cristian.d, 838) | idem: i **livelli** sono nel codice, lo **stop** no. Promosso sulla geometria dei livelli, non su uno stop misurato |
| `Daily Breakout + Daily Shadow` (rouro33, 115) | 🟢 lo stop **c'è** (`slVal = b1Low`, corpo della candela D1 di ieri, 81,7×/69,6×/117,5×/137,6×) e `lookahead=barmerge.lookahead_off` è **esplicito**. 🟠 **Non promosso** per un motivo diverso: l'ingresso è al **primo tick del nuovo giorno** dopo una chiusura oltre il corpo dell'altroieri → **≤ 1 operazione al giorno e in pratica ~2-3 al mese per simbolo**. Con la challenge al 1° ottobre, **non ce la fa a fare campione**. Torna in coda se la frequenza smette di essere il vincolo n.1 |

---

# 7. 🕳️ COSA NON HO POTUTO VEDERE — i buchi, dichiarati

1. 🔴 **GitHub: nessuna ricerca, nessun elenco file.** `api.github.com` risponde **403**
   e `gh` non è installato in questa sessione. Ho solo verificato che `raw.githubusercontent.com`
   serve i file **se conosco già il percorso** — che è inutile per cercare. **È un 403,
   non un 404: la fonte esiste e risponderà.** Una sessione con `gh` autenticato la riapre.
2. 🔴 **SSRN e Forex Factory: 403 al primo colpo.** Niente paper con la tesi, niente
   thread storici sull'invecchiamento dei sistemi — che è proprio ciò per cui Forex
   Factory vale.
3. 🔴 **arXiv API: 406** su sei tentativi. 🟢 **Aggirata** con `arxiv.org/search/` in HTML,
   che funziona — ma la resa su q-fin è magra: su 4 ricerche mirate **un solo titolo
   pertinente**, `arXiv:2605.04004` *«Structural Limits of OHLCV-Based Intraday Momentum
   Signals in MNQ Futures: A Systematic Falsification Study»*. ⚠️ **L'ho visto solo come
   TITOLO nella pagina dei risultati: NON ho letto l'abstract e NON ho letto il paper.**
   Non lo conto fra i candidati e non ne cito una sola conclusione. 👉 È però **la lettura
   più pertinente che questa caccia abbia incrociato** e merita mezz'ora di qualcuno.
4. 🟠 **Quantpedia raggiunta ma non setacciabile** (elenco in JS, 0 link `/strategies/` nell'HTML).
5. ⚪ **QuantConnect non misurata** (301 non seguito): buco per scelta di tempo, non per esito.
6. ⚪ **224 sorgenti Pine su 680 (33%) non leggibili** (`access` 2/3).
7. ⚪ **Date di pubblicazione TradingView `[NON MISURATE]`**: il JSON di ricerca non le
   contiene. Ho riportato solo ciò che c'è: nome, autore, `agreeCount`, `access`.
8. ⚪ **306 zip del Code Base su 1.280 non si sono aperti** (contenuto vuoto o non-zip).
   Fra gli ID persi ce n'erano quattro dal titolo interessante (`19498 Daily BreakPoint`,
   `23334 Daily range`, `26451 Range BreakOut EA`, `31198 Periodic Range Breakout 2.0`):
   **non li ho letti e non dico niente su di loro.**

---

# 8. 🧪 LA BOZZA DI FILE PROVA DEL CANDIDATO N.1

🔴 **NON è un file in `prove/`: è una bozza dentro il dossier.** Non è passata da
`controlla_prova.py` né dall'agente `controllo-preventivo`, e finché non passa **non
esce**. La riporto perché il mandato chiede di arrivare fino alla riga di lancio.

```
# IPOTESI: il RANGE DEL GIORNO PRECEDENTE e' un livello operativo sul DAX, e il suo
#   estremo opposto e' uno stop che PAGA IL PEDAGGIO (148,5 x spread contro i 31-37 x
#   di tutti e sei i modi della famiglia Apertura).
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   - RISCHIO (vale a qualunque n): DD di qualunque cella > 10,0% -> motore BOCCIATO.
#   - MERITO: giudicabile SOLO se n >= 150. Sotto, il verdetto e'
#     "NON MISURATO - FINESTRA CORTA", mai "non funziona".
#   - Cella scelta: CENTRO DELL'ALTOPIANO, mai il picco.
#   - Controllo di frequenza: se n < 60 su 24 mesi, il motore e' escluso PER PORTATA
#     e si dichiara, senza giudicare il PF.
@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26        <- MISURATO (risultati_archivio/ABTG_StoricoScaricato.csv)
InpBoxStartHour=22||22||1||22||N
InpBoxStartMin=0||0||1||0||N
InpBoxEndHour=21||21||1||21||N
InpBoxEndMin=59||59||1||59||N
InpSLMode=0||0||1||0||N
InpPlaceHour=22||22||1||22||N
InpPlaceMin=5||5||1||5||N
InpEntryCutoffHour=17||17||1||17||N
InpCloseHour=21||21||1||21||N
InpAllowLong=true||false||0||true||Y
InpAllowShort=true||false||0||true||Y
InpBufferPoints=1000||500||500||2000||Y
InpRiskPercent=0.65||0.65||0.1||0.65||N
InpUseCorrelation=false||false||0||false||N
```

⚠️ **Quattro cose da verificare PRIMA di lanciarla. La prima l'ho verificata io; le
altre tre no, e lo dico:**
1. 🟢 **`InpSLMode=0` = `MM_SL_OPPOSITE`: VERIFICATO, non dedotto.**
   `ABTG_MaxMinNotte.mq5` **r.31**: `enum ENUM_MM_SL { MM_SL_OPPOSITE=0, MM_SL_ATR=1,
   MM_SL_FIXED=2 };`. Ho aperto l'enum invece di fidarmi del commento della r.61.
2. 🔴 **Gli orari sono in ORA SERVER** (regola di casa). `22:00 → 21:59` è un box di
   23h59m che si appoggia a `if(tStart>=tEnd) tStart -= 86400`. **Che il box coincida con
   la giornata di contratto del CFD sull'indice va CONTROLLATO su un grafico**, non assunto.
3. 🟠 **`InpTP1_R=1.0` con uno stop da 1 ADR** mette il primo parziale a un range
   giornaliero di distanza. Prima corsa: lasciarlo com'è e **guardare quante volte viene
   toccato**. Se quasi mai, il motore va rifatto con `MM_SL_ATR` su `PERIOD_H4`.
4. 🔴 **La riga di lancio va costruita da chi ha il banco**, e passa da
   `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` + `controlla_riga.py` + l'agente
   `controllo-preventivo`. 🖥️ **Bersaglio: il PC DI BACKTEST**, non il VPS — la challenge
   è viva e la regola del 21/09 è bloccante.

---

# 9. 🏁 I TRE CHE PROPORREI PER PRIMI, COL COSTO IN TEMPO MACCHINA

| ordine | candidato | cosa costa **prima** del banco | tempo macchina | perché in questo ordine |
|---:|---|---|---:|---|
| **1º** | **Box del giorno precedente** su `ABTG_MaxMinNotte` (§5.1) | 🟢 **ZERO codice.** Solo: leggere l'enum `ENUM_MM_SL`, controllare il box su un grafico, passare la prova dal cancello | 🟢 **~10-20 minuti** per 12 celle su `D30EUR` M15 a tick reali *(base misurata: 0,7 min/passata, `R104_REFERTO_DRIVER` r.15)* | è l'unico che risponde **stanotte** e non chiede una riga di codice. Se muore, muore in venti minuti |
| **2º** | **Livelli Camarilla H4/L4** (§5.3) | 🟡 EA nuovo piccolo: 4 righe di aritmetica su `iHigh/iLow/iClose` di `PERIOD_D1` + la nostra gestione. **2-3 ore** | 🟡 ~20-30 min per uno sweep stretto | stesso buco del 1º ma con **sei distanze graduate** (H1..H6): se il 1º muore *per lo stop troppo largo*, il 3º livello (`H3/L3`, 0,825 ADR) è la risposta immediata |
| **3º** | **Outside bar in ritracciamento** (§5.2) | 🔴 Riscrittura Pine→MQL5: **4-6 ore**, + la correzione dello `stop`→`limit` che ho trovato leggendo | 🟡 ~20-40 min (H4 su `NASUSD` e `XAUUSD`, dove il cancello di costo lo ammette) | è il **migliore dei tre come disegno** (R:R 3:1 per costruzione, gestione già uguale alla nostra), ma è anche l'unico che costa mezza giornata di scrittura prima di dire una parola |

---

# 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## 🎯 **«Quando lo stop passa da 37× a 148× lo spread, sullo STESSO simbolo e con la STESSA macchina, il segno cambia?»**

**Perché è questa e non un'altra.** Tutta la famiglia Apertura del DAX è stata bocciata
con stop fra **31,2× e 37,1×**. Il candidato n.1 gira **sullo stesso simbolo**, con **lo
stesso EA già compilato**, con **la stessa gestione**, e cambia **una sola cosa**: la
geometria del box, e quindi lo stop, che sale a **148,5×**.

👉 **È un esperimento a una variabile**, ed è raro averne uno così pulito. Le due risposte
sono tutte e due utili:
- 🟢 **se il segno cambia**, abbiamo la prova che il collo di bottiglia era **il pedaggio**,
  e allora si riapre l'intera coda dei motori bocciati **per costo** (ORB, Londra, i
  cinque indici esclusi) chiedendosi ogni volta *«e se lo stop stesse su una struttura
  più grande?»*;
- 🔴 **se non cambia**, abbiamo la prova che il collo di bottiglia era **il segnale**, la
  famiglia dei livelli di giornata si chiude **con un numero invece che per analogia**, e
  il candidato 3 si spegne prima di costare tre ore.

**In tutti e due i casi il costo è venti minuti di banco.** Nessun'altra domanda di
questa caccia ha lo stesso rapporto fra informazione e prezzo.

---

## 🔖 Attribuzione e licenze — per ogni `.mq5` che dovesse nascere da qui

| candidato | autore | licenza dichiarata | obbligo |
|---|---|---|---|
| Previous Day H/L Breakout | **ceyhun** (TradingView) | 🟢 **Mozilla Public License 2.0** (riga 2 del sorgente) | citare autore, URL e MPL-2.0 in testa al file |
| Outside Bar Strategy % | **Alessxio** (TradingView) | 🔴 **[INCERTO]** — nessuna intestazione | 🔴 **nessuna riga del suo codice**: solo la geometria, riscritta, con l'attribuzione |
| Camarilla H4/L4 | **cristian.d / CristianD** (TradingView) | 🔴 **[INCERTO]** — nessuna intestazione | 🔴 idem: la formula Camarilla è di pubblico dominio, il suo file no |

---

_Fine del dossier. Nessun EA, preset, `.ini`, terminale, forward o round è stato toccato._
