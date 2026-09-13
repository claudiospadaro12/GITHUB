# 🏹 CACCIA ALLO STOP STRUTTURALE — 13/09/2026

> 🔒 **PERIMETRO, dichiarato prima di tutto il resto.**
> **Zero EA nostri scritti o toccati. Zero preset. Zero `.set`. Zero righe in
> `CODA.txt`. Zero backtest eseguiti. Zero terminali.** Gli unici file nuovi
> sono **questo `.md`** e **quattro sorgenti esterni archiviati** in
> `backtest_pipeline/caccia_strategie/biblioteca/sorgenti/`.
> Il **secondo strato del cancello** (agente `controllo-preventivo`) **lo lancia
> il coordinatore**: io lo dichiaro e non lo aggiro.

---

# 0. 🔴 LA RIGA CHE VA LETTA PER PRIMA

> ## Su **999 titoli** del Code Base (25 pagine) e **992 script** TradingView indicizzati per parola chiave, **1.221 sorgenti scaricati e passati al setaccio automatico** (907 `.mq5` + 314 Pine), **148 passano il PRIMO FILTRO (stop strutturale)**, **7 letti riga per riga a mano**, **3 promossi IN CODA**, **ZERO PROVA SUBITO, ZERO file prova consegnati** — e lo zero sui file prova **ha una prova, non una scusa** (§8).

**E la cosa che porto a casa non e' un candidato: sono DUE NUMERI e UNO SBLOCCO.**

## 🔓 LO SBLOCCO: TradingView e' diventata LEGGIBILE E CERCABILE, oggi

Tutti i dossier precedenti la danno per chiusa. Testuale, `PROMEMORIA_SBLOCCO_FONTI.md`:
_"TradingView **200 ma il Pine NON è nell'HTML** (0 occorrenze di `strategy(` su
1,54 MB) → **non setacciabile**"_. E `CACCIA_SABATO_2026-09-13.md`:
_"TradingView: NON aperta in questa battuta... **E' un buco vero di questa caccia**"_.

🟢 **Il Pine si legge, e la ricerca per parola chiave funziona. Misurato oggi:**

| passo | endpoint | esito MISURATO |
|---|---|---|
| **ricerca per parola** | `tradingview.com/pubscripts-suggest-json/?search=<parole>` | **200** · JSON con `scriptName`, `author`, `agreeCount`, `scriptIdPart`, `kind`, `access` — **50 risultati per query** |
| 🥇 **SORGENTE Pine** | `pine-facade.tradingview.com/pine-facade/get/PUB%3B<hash>/last` | **200** · campo **`source`** = il Pine **in chiaro** (controllo positivo: `ATR Exhaustion & Volume Spike`, 3.550 byte, `//@version=5` — **lo stesso script gia' in casa** come `ABTG_AtrExhaustVol`) |
| pagina HTML | `tradingview.com/script/<id>/` | 200, **ma 0 occorrenze di `strategy(`** — cioe' **il vecchio verdetto era giusto sull'HTML e sbagliato sulla FONTE** |

👉 **Da oggi il §4 (il setaccio) e' applicabile a TradingView senza intermediari**,
e la ricerca per meccanismo — impossibile sul Code Base, dove `?s=` e' in JS — **e'
possibile qui**. **50 query girate oggi, 992 script unici indicizzati.**

## 📊 IL NUMERO CHE GIUSTIFICA IL MANDATO DI OGGI

Il brief dice che quattro cacce di fila sono morte sullo stop a punti fissi.
**Misurato sui 907 sorgenti `.mq5` letti oggi, non opinato:**

| cosa | quanti | quota |
|---|---:|---:|
| sorgenti `.mq5` scaricati, **decodificati UTF-16** e setacciati | **907** | 100% |
| **stop dichiarato come COSTANTE NUMERICA in un `input`** | **187** | **20,6%** |
| griglia (parole di griglia/averaging nel sorgente) | 177 | 19,5% |
| martingala (moltiplicatore sul lotto nel sorgente) | 44 | 4,9% |
| 🟢 **stop STRUTTURALE (da ATR o da un LIVELLO) e nessuna martingala** | **50** | **5,5%** |

> 🔴 **Lo stop strutturale e' il 5,5% del Code Base.** Non e' sfortuna delle
> quattro cacce precedenti: e' la distribuzione della fonte. Chi non mette il
> filtro dello stop in TESTA butta 19 sorgenti su 20.
> ⚠️ **Precisione dichiarata**: i tre conteggi vengono da espressioni regolari
> sul sorgente, non da lettura umana. Sono **[DERIVATI]**, con residuo di falsi
> positivi (es. `SL_koef = 1` conta come "costante" e non lo e'). L'ordine di
> grandezza regge; il decimale no.

Su TradingView la quota e' **piu' alta**, e vale la pena scriverlo: **98 su 314
strategie open-source (31,2%)** hanno lo stop legato ad ATR o a un livello.
Il Pine ha `ta.atr()` a portata di mano e si vede.

---

# 1. 🔌 CONTROLLO POSITIVO — fonte per fonte, misurato oggi

| fonte | bersaglio | esito MISURATO | verdetto |
|---|---|---|---|
| **MQL5 Code Base** (elenco) | `/en/code/mt5/experts` + `page2..page25` | **200** su 25 pagine · **999 coppie id+titolo** estratte | 🟢 **PASSA** |
| **MQL5 Code Base** (scheda) | `/en/code/<ID>` × 999 | **200** · `<meta description>` con **autore + data** (controllo: `77167` → *"by 'RanaAli878' ... 2026.09.09"*) · `datePublished` nel JSON-LD | 🟢 **PASSA** |
| 🥇 **MQL5 sorgente** | `/en/code/download/<ID>/<file>.mq5` | **200** · **907 file scaricati** | 🟢 **PASSA** |
| 🔓 **TradingView ricerca** | `pubscripts-suggest-json/?search=` | **200** · 50 query · **992 script unici** con autore, `agreeCount`, licenza d'accesso | 🟢 **PASSA (nuovo)** |
| 🔓 **TradingView SORGENTE** | `pine-facade.../get/PUB;<hash>/last` | **200** · **314 sorgenti Pine** scaricati, campo `source` in chiaro | 🟢 **PASSA (nuovo)** |
| **GitHub** — raw | `raw.githubusercontent.com/EarnForex/ATR-Trailing-Stop/main/README.md` | **200, 729 byte** | 🟡 **PARZIALE** |
| **GitHub** — API repo/ricerca | `api.github.com/repos/...` · `/search/repositories` | **403** (*"sessions are bound to their configured repositories"*) → **nessun elenco file**, e i 4 percorsi tentati del sorgente danno **404** | 🔴 **sorgente NON letto** |
| **Quantpedia** | `quantpedia.com/strategies/` | **200, 641.496 byte** ma **0 link `/strategies/<slug>/` nell'HTML** (contenuto in JS) | 🔴 **raggiunta, NON setacciabile** |
| **arXiv** | `export.arxiv.org/api/query?...` | **429**, poi **429**, poi **timeout a 40 s** su tre tentativi con attesa crescente | 🔴 **NON raggiunta — e 429 ≠ 404**: non cancella nessun candidato, si riprova |
| **SSRN** | `papers.ssrn.com/sol3/papers.cfm?abstract_id=1911243` | **403** | 🔴 **NON raggiunta** |
| **Forex Factory** | `/forum/71-trading-systems` | **403** | 🔴 **NON raggiunta** |

⚠️ **Popolarita' delle schede Code Base: [NON MISURATA]** — i contatori sono in JS,
non nell'HTML. Non li invento e non li peso. Su TradingView invece **`agreeCount`
c'e' nel JSON** ed e' riportato: e' un numero della pagina, non mio.

⚠️ **Nota di provenienza, perche' conta.** La cartella di lavoro temporanea e'
**condivisa fra sessioni**: conteneva gia' 228 sorgenti Pine e ~178 `.mq5` di
cacce precedenti. **Tutti i conteggi di questo dossier filtrano per data di
scaricamento = 13/09/2026**, cioe' contano SOLO cio' che ho scaricato io oggi.

---

# 2. 🎯 IL PRIMO FILTRO, applicato come chiede il brief

**Screening d'INGRESSO, prima di leggere qualunque altra cosa**: se lo stop e'
una costante in punti/pip, si scarta senza continuare.

| passaggio | Code Base | TradingView | totale |
|---|---:|---:|---:|
| titoli visti | 999 | 992 | **1.991** |
| sorgenti scaricati e setacciati | **907** | **314** | **1.221** |
| 🟢 **passano il primo filtro (stop strutturale)** | **50** | **98** | **148** |
| di questi, con **target proporzionale allo stop** (ancora unica, euristica) | 12 | 25 | **37** |
| **letti riga per riga a mano** | 1 | 6 | **7** |
| **promossi** | **0** | **3** | **3 (tutti IN CODA)** |

🔬 **E il primo filtro automatico NON e' un verdetto — verificato con un
contro-esempio, oggi.** `Dow Theory Trend Strategy` (Salaryman_G, 139 agree) e'
stato marcato **stop strutturale** dall'euristica perche' il file e' pieno di
`lastPivotLow` / `prevPivotLow`. **Letto a mano: non ha NESSUNO stop.** Le uniche
righe di ordine sono `strategy.entry("L", strategy.long)` e
`strategy.entry("S", strategy.short)`: e' uno **stop-and-reverse sempre a
mercato**, zero `strategy.exit`. 👉 **E' esattamente la classe 289 che il brief
mi chiedeva di non farmi scappare** (un nome che sembra uno stop e non lo e'), e
si trova **solo leggendo**.

---

# 3. 🏅 I PROMOSSI — tre schede, tutte IN CODA, nessuna PROVA SUBITO

> ⚠️ **Perche' nessuno arriva a PROVA SUBITO (>=8):** tutti e tre sono Pine, e la
> voce **"testabile senza riscritture"** vale **0** per costruzione. Non e' un
> giudizio sul motore: e' il costo di porting, e va detto prima, non dopo.

## 🥇 C1 — `Volatility Momentum Breakout Strategy`

```
NOME            Volatility Momentum Breakout Strategy
FONTE / URL     https://www.tradingview.com/script/dJe0bGvQ-Volatility-Momentum-Breakout-Strategy/
                (HTTP 200 verificato) - sorgente letto da
                pine-facade.tradingview.com/pine-facade/get/PUB%3B<hash>/last
AUTORE / DATA   cryptechcapital · created 2025-02-05T13:43:09Z   POPOLARITA' 27 agree
LICENZA         NON DICHIARATA nel sorgente  [INCERTO]
RIGHE / INPUT   111 righe · 10 input

TESI IN UNA RIGA
  "una rottura che supera il massimo delle ultime N barre DI UN MULTIPLO DELLA
   VOLATILITA' CORRENTE non e' rumore: e' espansione, e prosegue."

MECCANICA   ingresso  close > ta.highest(high[1],20) + 1,5 x ATR(14)   (specchiato short)
            stop      entry - atrStopMult x ATR(14)
            target    entry + (entry - stop) x riskReward      <-- R-multiplo ESPLICITO
GESTIONE RISCHIO  🔴 lotto = 5% dell'equity (strategy.percent_of_equity, r.33).
                  `riskPercent` e' DEFINITO a r.45 e MAI USATO: manopola inerte,
                  verificata a grep riga per riga (le uniche entry, r.72 e r.74,
                  non passano `qty`). La gestione gliela mettiamo noi.
BANDIERE ROSSE    nessuna. Niente martingala, niente griglia, stop vero,
                  niente look-ahead (usa esplicitamente high[1]/low[1]).
COSTO DI PORTING  Pine -> MQL5 = RISCRITTURA. ~1 giornata uomo con la carcassa
                  di casa (OnTester/OPTFRAME/rischio %/spread% dello stop).

PUNTEGGIO
  [2] semplicita'            10 input, 3 regole
  [1] il filtro E' il motore  la soglia ATR e' costitutiva; EMA50 e RSI>50 sono
                              appiccicati (e quasi impliciti: chi rompe il
                              massimo a 20 barre + 1,5 ATR sta gia' sopra la EMA50)
  [2] tesi scrivibile
  [1] riempie un buco         SIMMETRICO L/S per costruzione (nessun input di lato)
                              = buco SHORT. Ma la famiglia "breakout" in casa e'
                              porta chiusa con ~96-210 celle
  [0] testabile senza riscritture
VERDETTO   IN CODA (6/10)
PERCHE'    e' l'unico dei 1.221 sorgenti di oggi in cui TUTTE E TRE le quantita'
           (soglia d'ingresso, stop, target) scalano con lo stesso ATR.
```

### 🔴 L'obiezione seria, e la scrivo io contro il mio candidato
La casa ha **"breakout = porta chiusa"** scritto in quattro dossier (~96 celle
R7-R13/R42/R45/R12, ~210 celle sull'ORB, R97 0/4 a tick). **Devo dire in cosa
questo differisce, o non e' un candidato: e' una riapertura.**

| | i breakout gia' bocciati in casa | C1 |
|---|---|---|
| ancora del range | **CALENDARIO** (box d'apertura, range di sessione, prima ora) | **BARRE** (massimo delle ultime 20 barre del grafico) |
| soglia di rottura | livello nudo, o + buffer in **punti fissi** | **+ k x ATR(14)** |
| stop | punti fissi / bordo opposto del box | **k x ATR(14)** |
| target | campanella, flat di seduta, punti fissi | **R-multiplo dello stop** |
| scendendo di TF | lo stop si stringe ma il box no -> **costa due volte** | **tutto si stringe insieme** |

👉 **La differenza strutturale c'e' ed e' l'ancora.** 🔴 **Ma resta una
scommessa sulla stessa inefficienza**, e va detto a Claudio cosi': se il
brutto dei ~200 cell e' il MECCANISMO e non la GEOMETRIA, C1 muore uguale.

## 🥈 C2 — `[KL] Mean Reversion (ATR) Strategy`

```
NOME            [KL] Mean Reversion (ATR) Strategy
FONTE / URL     https://www.tradingview.com/script/vUm2xj05-KL-Mean-Reversion-ATR-Strategy/
                (HTTP 200 verificato) - sorgente da pine-facade
AUTORE / DATA   DojiEmoji · created 2021-10-31T07:04:01Z   POPOLARITA' 146 agree
LICENZA         🟢 Mozilla Public License 2.0, DICHIARATA in testa al file
RIGHE / INPUT   108 righe · 8 input

TESI IN UNA RIGA
  "quando la VOLATILITA' (non il prezzo) esce di piu' di una sigma dalla sua
   media a 20 barre e la deriva logaritmica e' positiva, il mercato torna a
   respirare e la gamba successiva e' lunga."

MECCANICA   ingresso  ATR(20) > media(ATR,20) + 1 sigma   AND   drift lognormale > 0
            stop      low - 2 x ATR(14), che TRASCINA verso l'alto (mai indietro)
            target    1R / 2R / 3R a SCAGLIONI, dove R = risk_amt = 2 x ATR
GESTIONE RISCHIO  🔴 taglia = 5% del portafoglio (allocazione), NON rischio %.
                  🟢 MA la scala d'uscita e' LA NOSTRA: parziale a 1R, parziale a
                  2R, runner a 3R, stop che trascina. Scritta da un estraneo.
BANDIERE ROSSE    nessuna del §4. 🐛 Un difetto vero: il latch
                  `_signal_diverted_ATR := not _signal_diverted_ATR and X or Y`
                  si legge, per precedenza, come `(not s and X) or Y` -> stato
                  con memoria difficile da riprodurre. Da riscrivere esplicito.
COSTO DI PORTING  ~mezza giornata (e' piu' corto e piu' lineare di C1).

PUNTEGGIO
  [2] semplicita'            8 input
  [2] il filtro E' il motore  il segnale di volatilita' E' la strategia: non c'e'
                              nessun "motore + filtro", non c'e' nessun interruttore
  [2] tesi scrivibile
  [1] riempie un buco         famiglia VOLATILITA' (non prezzo): NON e' R60
                              (`ABTG_MeanRevert` 12/12 in perdita e' mean reversion
                              di PREZZO). Ma e' LONG-ONLY, e long-only ne abbiamo gia'
  [0] testabile senza riscritture
VERDETTO   IN CODA (7/10) -- il piu' alto della giornata
PERCHE'    e' l'unico candidato la cui GESTIONE non va rifatta: e' gia' la nostra.
```

## 🥉 C3 — `Donchian Breakout with ATR Trailing Stop (Trend Following)`

```
NOME            Donchian Breakout with ATR Trailing Stop (Trend Following)
FONTE / URL     https://www.tradingview.com/script/NeEiwmDq-Donchian-Breakout-with-ATR-Trailing-Stop-Trend-Following/
                (HTTP 200 verificato) - sorgente da pine-facade
AUTORE / DATA   raven_suurineru · created 2026-07-07T18:51:57Z  POPOLARITA' 46 agree
LICENZA         NON DICHIARATA  [INCERTO]
RIGHE / INPUT   146 righe · 12 input · Pine v6

TESI IN UNA RIGA
  "la rottura del canale a 20 barre nella direzione della EMA200 e' l'inizio di
   un trend, e il trend si lascia correre con un trascinamento a 2,5 ATR."

MECCANICA   ingresso  close > ta.highest(high,20)[1]  AND  close > EMA200
            stop      trascinamento: max(trailStop, high - 2,5 x ATR)
            target    nessuno: esce solo sul trascinamento
GESTIONE RISCHIO  🟢 **LA PIU' PULITA DELLA GIORNATA**:
                  `qty = (equity x riskPct/100) / (ATR x trailMult)` con tetto di
                  leva e guardia sulla divisione per zero. E' il rischio % scritto
                  giusto, uguale al nostro.
BANDIERE ROSSE    nessuna. `calc_on_every_tick=false`, `process_orders_on_close=true`,
                  canale con `[1]` esplicito -> niente look-ahead, niente ridipintura.
ANCORA            🟡 **UNICA MA DEBOLE**: stop e uscita sono la STESSA quantita'
                  (2,5 ATR), quindi la E in R non si diluisce allargando lo stop.
                  Ma non c'e' un target in R: l'edge lo fa la CODA, e la coda
                  dipende dal regime, non dalla geometria.
COSTO DI PORTING  ~mezza giornata.

PUNTEGGIO
  [2] semplicita' · [1] filtro=motore (EMA200 e' un interruttore: `useTrendFilt`)
  [2] tesi · [0] buco (doppione: `ABTG_CanaleLento` E' Donchian 55/20, e la EMA200
      e' la nostra sedia migliore) · [0] riscrittura
VERDETTO   IN CODA (5/10)
PERCHE'    il motore e' doppio di casa; quello che vale davvero e' il SIZING, e
           quello ce l'abbiamo gia'.
```

## 🏛️ IL CANCELLO PROP — la riga in piu' per ciascun promosso

- **C1** — 🟢 simmetrico: e' l'unico che porta **lato short** senza un interruttore.
  🟠 **Ma non ha flat di seduta**: tiene overnight, quindi sui CFD indice misura
  anche il **gap**, e il gap e' la forma che il **DD trailing** delle prop punisce.
  🟠 Frequenza **[NON MISURATA]**: una rottura a 20 barre + 1,5 ATR e' rara per
  costruzione. Su M30 indici la banda plausibile e' 0,1-0,4 op/giorno per simbolo:
  **sotto il pavimento di 1,00 se non si accende su 3 simboli** (firma 07/09, il
  pavimento e' di FAMIGLIA).
- **C2** — 🟠 long-only: **non aiuta la scorrelazione**, che e' il vero criterio
  prop (_"il DD della prop e' UNO"_). Aggiunge pero' una gamba che lavora
  **nell'espansione di volatilita'**, cioe' dove le sedie di apertura non stanno.
  🟢 La scala 1R/2R/3R e' la forma che in casa tiene il DD basso.
- **C3** — 🔴 **il piu' pericoloso dei tre in ottica prop**: trend following puro
  con uscita solo a trascinamento = **curva a scalini con lunghi ritorni dal
  picco**, che e' *esattamente* la forma che il DD trailing taglia. Da non
  accendere per primo.

---

# 4. 💸 LA FRONTIERA DEL COSTO, con gli SPREAD MISURATI (punto 3 del brief)

**Spread usati — MISURATI, non convenzionali:**

| simbolo | mediana | campione | fonte |
|---|---:|---|---|
| D30EUR | **1,70** idx | n=78.314, GG=6 | `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` |
| NASUSD | **1,80** idx | n=79.150, GG=5 | idem (cash USA 14-20: **1,6-1,8**, `spread_flotta`) |
| U30USD | **2,00** idx | n=79.138, GG=5 | idem (cash USA 14-20: **1,9-2,0**) |
| EURUSD | 0,20 pip | n=84.997, GG=6 | idem — **+ commissione ~0,5 pip** (0,004% del nozionale) |
| GBPUSD | 0,30 pip | n=84.968, GG=6 | idem |

**Commissione sugli indici: 0,0000 MISURATA** (n=302 deal, `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.181) → **sugli indici il pedaggio e' lo spread e basta.**

**ATR per TF** = `ADR x sqrt(minuti/1440)`, con ADR **MISURATI**: D30EUR **186,5**
(49 giorni, `LA_BANDA_BASSA` r.338) · NASUSD **313,8** · U30USD **314,5**
(24 giorni, `ROUND_ORB_ATR_PS5` r.233-234).
⚠️ **Questa legge SOTTOSTIMA del 18-27%** (misurato, `EMA200_I_DUE_REQUISITI` r.182):
👉 **i rapporti qui sotto sono un PAVIMENTO, non una stima centrata.**

### `stop / spread` di C1, per TF e per moltiplicatore dello stop

| simbolo | TF | ATR~ | k=1,0 | k=1,5 | **k=2,0** | k=2,5 |
|---|---|---:|---:|---:|---:|---:|
| **D30EUR** | **M15** | 19,0 | 🔴 **11,2x** | 16,8x | 22,4x | 28,0x |
| **D30EUR** | **M30** | 26,9 | 15,8x | 23,8x | 31,7x | 🟢 **39,6x** |
| **NASUSD** | **M15** | 32,0 | 17,8x | 26,7x | 35,6x | 🟢 **44,5x** |
| **NASUSD** | **M30** | 45,3 | 25,2x | 🟢 **37,7x** | 🟢 **50,3x** | 62,9x |
| **U30USD** | **M15** | 32,1 | 16,0x | 24,1x | 32,1x | 🟢 **40,1x** |
| **U30USD** | **M30** | 45,4 | 22,7x | 34,0x | 🟢 **45,4x** | 56,7x |

_(pavimento di lavoro **40x**; pavimento **DURO 13,3x**)_

> ## 🎯 **IL RISULTATO CHE RISPONDE AL MANDATO, e vale piu' dei tre candidati**
> **Con uno stop strutturale, M15 sugli indici NON e' chiuso.** A `k = 2,5`
> NASUSD fa **44,5x** e U30USD **40,1x** — **sopra il pavimento di lavoro, a M15**.
> Nelle quattro cacce precedenti M15 sfondava perche' lo stop era una costante e
> **non poteva crescere**. Qui puo'.
> 🔴 **UNICA eccezione, e va detta: D30EUR M15 a k=1,0 fa 11,2x, cioe' SFONDA IL
> PAVIMENTO DURO.** Sul DAX il TF basso resta chiuso finche' non si porta lo stop
> ad almeno **1,2 ATR**; per il 40x servirebbe **k = 3,6**, che non e' piu' uno
> stop, e' un'altra strategia.

### 🔑 E perche' allargare lo stop qui e' LEGITTIMO (punto 4 del brief)

Su C1 **l'ANCORA E' UNICA e si legge nel codice**:
`longTarget = longEntryPrice + (longEntryPrice - longStop) * riskReward`.
Il target **e'** un multiplo della distanza di stop. Quindi, nell'aritmetica di
casa (`CACCIA_TF_BASSO_2026-09-12.md`):

```
E_netta(R) = (edge_in_punti - costo_in_punti) / stop_in_punti
```
l'edge in punti **cresce con lo stop esattamente quanto lo stop**, e **solo il
costo resta fisso**. 👉 **Allargare `atrStopMult` COMPRA la frontiera senza
diluire l'edge in R.** Sul cono di rumore (M18) e sul salto statistico (M31)
questo NON era vero, ed e' per quello che sono morti a 52x.

🔴 **IL LIMITE, scritto prima e non dopo, perche' e' il pezzo debole:**
l'invarianza in R e' **ASSUNTA** (auto-similarita' del processo), **non misurata
su questo motore** — identica onesta' di `R141c` r.60-66. E la casa ha gia' una
misura che dice il contrario **su un altro motore**: sul cono di rumore l'edge
e' crollato da +0,054 R a +0,012 R allargando lo stop. **Il modo di romperla
e' un asse su `atrStopMult`, ed e' il primo round che chiederei.**

---

# 5. 🔧 «AVREBBE MERITO MA LO STOP E' FISSO» — vale la pena riscriverlo?

| # | script | fonte / autore | il merito | la riga che lo blocca | riscrittura? |
|---|---|---|---|---|---|
| R1 | **[`Keltner bounce from border. No repaint. V2`](https://www.tradingview.com/script/mQKGzLMD-Keltner-bounce-from-border-No-repaint-V2-by-Zelibobla/)** | TradingView · **zelibobla** · **2.000 agree** (il piu' popolare del lotto) | **Fade simmetrico dell'estremo**: compra la rottura al ribasso della banda inferiore di Keltner a **8 ATR** dalla media a 200, vende lo specchio. Uscita al ritorno sulla media. **Tesi di LATERALE/CROLLO, che e' un buco vero** (LARRY muore nel laterale: −6.445 nel 2019). In casa **NON esiste nessun EA Keltner** (grep su 115 EA: zero occorrenze) | `SL = input(defval=50, ..., title="Stop loss in ticks")` + `strategy.exit(..., loss=SL)` = **stop in TICK** · taglia `tradeSize = 1` **fissa** | 🟢 **SI', ed e' la riscrittura piu' economica della giornata (~3 ore)**: la banda **e' gia'** `EMA ± k x ATR`, quindi lo stop strutturale c'e' gia' nel disegno — basta ancorarlo alla banda invece che ai tick, e il target (la media) **scala con la stessa ATR** -> **ancora unica per costruzione** |
| R2 | **`[STRATEGY][RS]Open Session Breakout Trader`** | TradingView · RicardoSantos · 2.661 agree | breakout di sessione, scritto bene | `stop_loss = input.float(100.0, 'SL in ticks(1/10 of a pip)')` | 🔴 **NO — doppione**: e' l'ORB, porta chiusa con ~210 celle |
| R3 | **`Hans123_Trader` / `v2`** | Code Base **20149** / **20397** · 7-8 input | il classico range asiatico -> rottura Londra, **solo 7 input** | stop dal livello ma **niente ATR e niente R-target**; 2010-2011 | 🔴 **NO — doppione** dell'ORB/MaxMinNotte |
| R4 | **`Mutanabby_AI | ATR+ | Trend-Following`** | TradingView · 439 agree | trend following con ATR | `stop_loss_points = input.float(10.0, "Stop Loss Points")` — **ATR nel nome, punti nello stop**: la classe 289 in piena regola | 🔴 **NO** |
| R5 | **`PLC (penetration of the last candle)`** | Code Base **20668** · 8 input | motore minimo: rottura del massimo/minimo della candela precedente, stop sull'estremo opposto -> **stop strutturale vero, 8 input** | non ha ATR ne' R-target; e' del 2011, senza rischio % | 🟡 **FORSE, ma basso**: e' un ingresso, non una strategia. Utile come **mattone** in un motore nostro, non come EA |

---

# 6. 🗑️ GLI SCARTI, uno per riga, con la riga di codice che li prova

| # | candidato | fonte | perche' e' fuori |
|---|---|---|---|
| S1 | **`AdaptiveTrader Pro EA`** (Code Base **52152**, sasan31, 2024.09.15, 388 righe, 20 input) — **mai setacciato prima** | Code Base | 🔴 **SI OTTIMIZZA DA SOLO A RUNTIME.** `BacktestWithParameters(rsiPeriod, atrMultiplier, ...)` (r.250) girato ogni `OptimizationInterval = 3600` secondi su tre cicli annidati (r.265-272) per scegliere i "parametri migliori". **Il risultato non e' riproducibile e la selezione avviene sui dati appena passati.** In piu' `iATR(symbol, PERIOD_M5, 14)` (r.105) **inchioda l'ATR a M5**: il TF del grafico non conta. 🟢 Lo stop **e'** strutturale (r.223) e il rischio **e'** in % (r.10): l'idraulica e' buona, la misura no |
| S2 | **`Dow Theory Trend Strategy`** (TradingView, Salaryman_G, 139 agree) | TradingView | 🔴 **NESSUNO STOP.** Due `strategy.entry`, **zero** `strategy.exit`: stop-and-reverse sempre a mercato. §4 senza discussione |
| S3 | **`Volatility Breakout System [Fixed Risk]`** (TradingView, debdaspt85, 212 agree, 204 righe) | TradingView | 🔴 **ANCORA MISTA**: lo stop e' `entry - atr x 4` (ATR) ma il breakeven e il trascinamento sono in **PERCENTUALE DEL PREZZO** (`bk_activation`, `trail_start`, `trail_offset`) -> allargando lo stop l'edge in R si diluisce. 🔴 Piu' `lookahead=barmerge.lookahead_on` nel file (funzione `get_safe_trend`) e **quattro filtri a interruttore** (`use_adx`, `use_vol_filter`, `use_trend_ema`) = filtri appiccicati, 0/5 in casa. 🔴 Taglia: 50% dell'equity x leva 2 |
| S4 | **`EA AurumNeuro Vanguard`** (Code Base 77206) | Code Base | 🔴 **32 input** = il doppio del tetto. Gia' scartato l'11/09 per la stessa ragione: non lo riapro |
| S5 | **`MSNR v5.31Plus AEU EA`** (Code Base 73680) | Code Base | 🔴 **252 input.** Non e' un motore, e' un ottimizzatore |
| S6 | **`ZetaBurst` / `PulseStrike`** (77220 / 77167) | Code Base | 🔵 **gia' setacciati il 13/09 stamattina** (stesso file byte per byte): stop strutturale vero, ma `stop/spread >= 4,71x` contro il duro 13,3x, e RR 0,64 |
| S7 | **famiglia Supertrend** (~18 script TV: `SUPERTREND ATR WITH TRAILING`, `AI SuperTrend x Pivot`, `Master Supertrend`, `Sniper`…) | TradingView | 🔵 **doppione**: in casa ci sono **9** EA Supertrend, e il blocco B/C di `ABTG_SupRev` sul Dow e' chiuso il 12/09 |
| S8 | **famiglia ORB** (~14 script TV: `ORB Strategy [LuciTech]`, `ORB Pro`, `NY15m ORB`, `ORB MEEEEEKS`, `TOT Strategy`…) | TradingView | 🔵 **porta chiusa** con ~210 celle a tick (R97 0/4, R45 0/48, R12 48/48 negative OOS) |
| S9 | **famiglia VWAP** (~8 script TV) | TradingView | 🔵 `ABTG_VwapRevert` **falsificato** il 03/09, cancello S0 |
| S10 | **incroci di indicatori con ATR SL/TP appiccicato** (~30 script TV: `CRYPTO 3EMA`, `Scalping 15min EMA+MACD+RSI`, `CCI+EMA`, `MA Simple Strategy`…) | TradingView | 🔴 **§5C: nessuna tesi di mercato scrivibile in una riga.** L'ATR non li salva: lo stop e' strutturale, il **motore** no |
| S11 | **597 sorgenti delle pagine 11-25 del Code Base** (2010-2013) | Code Base | 🔴 **resa quasi nulla, e adesso e' misurata**: 20 su 597 con stop strutturale (3,3%), **127 con parole di griglia**, e i sopravvissuti sono `MacdPatternTraderAll` (65 e 71 input), `Flat Channel` e `jMaster RSI` (43 input), `Freeman`/`freeman` (27-28). **Questo pozzo e' secco: non lo riapra nessuno senza una ragione nuova** |

---

# 7. 🪦 PASSAGGIO DALLA LISTA DEI CADUTI (`REGISTRO_TEST.md`)

| famiglia del candidato | cosa dice il registro | esito del confronto |
|---|---|---|
| **C1 breakout** | *"breakout = porta chiusa, ~96 celle (R7-R13, R42, R45, R12)"*; ORB *"~210 celle"*; R97 0/4 a tick | 🟡 **RIAPERTO CON UNA DIFFERENZA STRUTTURALE DICHIARATA** (§3): ancora a BARRE invece che a CALENDARIO, e target in R. **Non e' "altri parametri dello stesso motore morto"**, ed e' la clausola della regola del 19/08 |
| **C2 mean reversion** | `ABTG_MeanRevert` **R60: 12 celle su 12 in perdita**; *"il coltello che cade"* | 🟢 **NON E' QUELLA FAMIGLIA**: R60 e' mean reversion di **PREZZO** (`price < MA - ATR x k`). C2 misura la **VOLATILITA'** e richiede **deriva positiva** — cioe' entra col trend, non contro |
| **C3 Donchian** | `ABTG_CanaleLento` (Donchian 55/20, D1 XAUUSD): **PF IS 0,87 / OOS 1,10 su n=20** | 🔴 **DOPPIONE**, e con n=20 il PF non si giudica (regola di casa). Resta il sizing come miglioria |
| **R1 Keltner** | **nessuna riga**: `grep -i keltner` sui 115 EA di casa = **zero** | 🟢 **VERGINE** |

---

# 8. 🔴 PERCHE' ZERO FILE PROVA — e il contro-esempio che lo dimostra

Il brief chiede un file prova pronto per ogni candidato che passa i punti 1-4.
**Non ne consegno nessuno, e la ragione non e' pigrizia: e' che il cancello lo
rifiuterebbe.** Provato, non supposto:

```
$ printf '#  EA: ABTG_NonEsiste\n@SIMBOLO NASUSD\n...' > prova_finta.txt
$ python3 backtest_pipeline/controlla_prova.py prova_finta.txt
  prova_finta.txt      EA NON TROVATO -> non misurabile
  file: 1 | celle totali: 0 | problemi: 1
  ESITO: FALLITO -- non si manda nessuna riga di lancio finche' e' rosso.
  exit 1
```

👉 **Un file prova esiste solo se esiste l'`.mq5`.** I tre promossi sono Pine:
l'`.mq5` va **scritto**, e scrivere un EA e' **fuori dal perimetro di questa
caccia** (confine bloccante del brief: *"Zero EA nostri toccati"*).

🟢 **Quindi consegno la cosa che rende quel passo meccanico: la SPEC di C1,
pronta da codificare.** Non e' un file prova e non lo chiamo cosi'.

```
EA proposto     ABTG_VolExpBreak        (magic da assegnare, VERGINE)
TF              M30 indici (M15 solo a k >= 2,5, e MAI su D30EUR)
INGRESSO        barra CHIUSA; long  se close > Highest(high,20)[1] + kBreak x ATR(14)
                              short se close < Lowest(low,20)[1]  - kBreak x ATR(14)
                direzione COSTITUTIVA: nessun input di lato
STOP            entry -/+ kStop x ATR(14)   + pavimento InpMinSLPts (lezione R109)
TARGET          entry +/- (kStop x ATR) x InpTP_RR        <-- ANCORA UNICA
GESTIONE        la nostra: parziale a 1R, breakeven, runner a 2R, rischio 0,65%
                dell'equity, spread come PERCENTUALE dello stop (R55), non in punti
INPUT (9)       kBreak, kStop, InpTP_RR, InpAtrPeriod, InpLookback,
                InpRiskPercent, InpMinSLPts, InpMaxSpreadPctOfStop, InpMagic
DA NON PORTARE  riskPercent dell'autore (inerte), EMA50 e RSI50 (filtri appiccicati:
                si portano SPENTI e si accendono solo in un round dedicato)
PRIMO ASSE      kStop = 1,0 || 1,5 || 2,0 || 2,5   -> misura DOVE cade la frontiera
                E rompe l'assunzione di invarianza in R. E' il round che serve.
COSTO STIMATO   ~1 giornata uomo di scrittura + 4 celle x 2 finestre = ~1 minuto macchina
```

---

# 9. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non tappato

1. **arXiv / SSRN / Forex Factory**: 429-timeout e 403. **Nessuna riga di questo
   dossier viene da un paper.** E 429 **non cancella** la fonte: si riprova.
2. **Quantpedia**: raggiunta (200, 641 KB) ma **zero link di strategia
   nell'HTML** -> contenuto in JS, **non setacciabile**.
3. **GitHub**: `raw` legge (README 200), ma **non esiste l'elenco dei file**
   (403 sull'API) e i 4 percorsi tentati danno 404. **Zero sorgenti GitHub letti
   oggi.** E' il buco piu' grosso della giornata.
4. **Popolarita' Code Base [NON MISURATA]** (contatori in JS).
5. **ATR reale dei nostri simboli [NON MISURATO]**: tutti i rapporti del §4
   poggiano su `ADR x sqrt(t/1440)`, che **sottostima del 18-27%** (misurato).
6. **ATR M30 sul FOREX [NON MISURATO]**: non l'ho estrapolato e non lo invento —
   quindi **C1 su GBPUSD/EURUSD non ha un conto di costo**, e non lo propongo li'.
7. **Frequenza attesa dei tre candidati [NON MISURATA]**: nessuno dei tre dichiara
   un numero di operazioni che io possa verificare, e **i numeri degli autori non
   sono un criterio**.
8. **TradingView, i limiti della fonte nuova**: `pubscripts-suggest-json` e' un
   **suggeritore**, non un motore di ricerca completo — le query lunghe rendono
   **zero** risultati (`"opening range breakout atr"` -> 0, `"opening range
   breakout"` -> 50). **Quindi i 992 script NON sono "tutta TradingView"**: sono
   cio' che 50 parole chiave corte hanno tirato su.

---

# 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## **Allargando SOLO lo stop (`kStop` 1,0 → 2,5) su un motore la cui ancora e' UNICA, l'edge in R resta lo stesso — oppure si diluisce come si e' diluito sul cono di rumore?**

E' **la** domanda, perche' da lei dipende tutto il mandato di oggi: se l'edge in R
e' invariante, **M15 e M30 sugli indici si comprano** e quattro cacce di frontiera
si riaprono; se si diluisce, **lo stop strutturale non e' una scorciatoia** e la
frontiera del costo resta un muro come lo era per gli stop fissi.

🔴 **E non si risponde con un PF.** Si risponde con **quattro celle sullo stesso
asse**, guardando se la E netta in R e' piatta lungo `kStop`. Il PF viene dopo, e
solo se la risposta e' "piatta".

---

## 📎 ATTRIBUZIONE E LICENZE (regola di casa)

| candidato | autore | licenza dichiarata | obbligo |
|---|---|---|---|
| C1 `Volatility Momentum Breakout Strategy` | **cryptechcapital** | **NESSUNA [INCERTO]** — pubblicato open source su TradingView | citazione in testa a qualunque `.mq5` derivato |
| C2 `[KL] Mean Reversion (ATR) Strategy` | **DojiEmoji** | 🟢 **MPL 2.0**, dichiarata nel file | MPL 2.0 va **riportata** nel derivato |
| C3 `Donchian Breakout with ATR Trailing Stop` | **raven_suurineru** | **NESSUNA [INCERTO]** | citazione |
| R1 `Keltner bounce from border V2` | **zelibobla** | **NESSUNA [INCERTO]** | citazione |

Sorgenti archiviati (copia fedele, nessuna riga modificata) in
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/`:

- `VolatilityMomentumBreakout_cryptechcapital-NOLICENSE_tvdJe0bGvQ_2026-09-13.pine` (5.808 byte)
- `KlMeanReversionAtr_DojiEmoji-MPL2_tvvUm2xj05_2026-09-13.pine` (5.310 byte)
- `DonchianBreakoutAtrTrail_raven_suurineru-NOLICENSE_tvNeEiwmDq_2026-09-13.pine` (7.689 byte)
- `KeltnerBorderBounceV2_zelibobla-NOLICENSE_tvmQKGzLMD_2026-09-13.pine` (2.157 byte)

**URL diretti, tutti verificati HTTP 200 il 13/09/2026:**
`tradingview.com/script/dJe0bGvQ-...` · `.../vUm2xj05-...` · `.../NeEiwmDq-...` · `.../mQKGzLMD-...`
