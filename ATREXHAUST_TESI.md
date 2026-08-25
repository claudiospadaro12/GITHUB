# 🎯 ATR EXHAUSTION & VOLUME SPIKE — tesi del porting (25/08/2026)

**File EA:** `mql5/Experts/ABTG_AtrExhaustVol.mq5` · **magic 774401** (blocco
7744xx verificato VERGINE nel repo il 25/08/2026)
**Origine:** candidato **P2** della caccia M5/M15 indici del 25/08/2026
(`backtest_pipeline/caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md`, voto
**9/10 — PROVA SUBITO**).
**Sorgente d'autore:** `ATR Exhaustion & Volume Spike Strategy` di
**MyStrategyHub**, TradingView `8ltrS3Yg`, creato 2026-04-07, v1.0, 88 righe,
9 input, `scriptAccess: open_no_auth`, **nessuna licenza dichiarata nel file**
→ ⚠️ attribuzione obbligatoria, riportata in testa al `.mq5`.
Copia archiviata: `backtest_pipeline/caccia_strategie/biblioteca/sorgenti/AtrExhaustionVolumeSpike_MyStrategyHub_tv8ltrS3Yg_2026-08-25.pine`.

> 🚧 **STATO: CANDIDATO DA BACKTEST.** Non è una sedia, **non va in forward**,
> il round coi criteri **non è questo documento**. Qui c'è solo: il meccanismo,
> cosa è costitutivo, ogni scostamento dichiarato, e i rischi da mettere sul
> tavolo *prima* di guardare un numero.

---

## 1. ⚡ IL MECCANISMO IN UNA PAGINA

**La tesi di mercato, in una riga:**
> _"Un movimento che arriva a un livello strutturale dopo essersi allungato più
> di 2 ATR ha già speso il carburante: se lì sopra arriva un picco di volume,
> quel volume non è continuazione — è chi chiude."_

È un **fade a un livello**, non un breakout. E non è nessuno dei nostri caduti:
non è un ORB (niente box, niente orario), non è R42 (il livello è un pivot
strutturale, non l'estremo del range d'apertura), **non è R95/sweep+reclaim**
(lì il livello va BUCATO e riconquistato; qui **non va bucato affatto**, va solo
raggiunto in stato di esaurimento con volume).

### Il giro completo (LONG; lo short è lo specchio esatto)

| # | pezzo | come si calcola nel `.mq5` |
|---|---|---|
| 1 | **IL LIVELLO** | `AggiornaPivot()` → pivot low confermato a **(5 sinistra, 5 destra)**. La barra candidata è la **[1+InpPivotRight]**: tutte le sue barre di conferma sono già CHIUSE. **Non ridipinge, per costruzione.** Memorizzato in `gLastPL` + il suo `datetime`. |
| 2 | **(a) PROSSIMITÀ** | `Prossimita_Calc()` — il **minimo della barra di segnale [1]** sta entro la tolleranza dal pivot. Tolleranza = **0,5% del prezzo del pivot** (modo autore). |
| 3 | **(b) ESAURIMENTO** | `Esaurimento_Calc()` — la strada **dal pivot OPPOSTO** (`gLastPH − low[1]`) supera **2,0 × ATR(14)**. È il collo di bottiglia del motore: filtra le discese "corte". |
| 4 | **(c) VOLUME** | `VolumeSpike_Calc()` — **tick volume della barra [1] > 1,5 × la media a 20 barre**. 🔴 **Costitutivo.** |
| 5 | **grilletto** | `TriggerAutore_Calc()` — `close>open` **oppure** `close>high[2]`. |
| 6 | **INGRESSO** | a mercato, all'apertura della barra successiva. **Una posizione alla volta per magic.** |
| 7 | **STOP** | strutturale: il **più protettivo** fra pivot low e minimo della barra (`MathMin`), meno `InpSLBufferPts`. Poi pavimento, normalizzazione al tick, controllo `SYMBOL_TRADE_STOPS_LEVEL`. |
| 8 | **TARGET** | **2R** secco (default autore). Parziale/BE/trailing esistono ma partono **spenti**. |
| 9 | **LOTTO** | dal rischio: `InpRiskPercent` del saldo / distanza dello stop, con `OrderCalcProfit` (converte in valuta conto) e tick value come ripiego. |

**Decide SOLO a barra chiusa** (`IsNewBar()` + tutti i dati letti su `[1]`/`[2]`):
è l'equivalente MT5 di uno `strategy` Pine con `calc_on_every_tick=false`.
**Niente look-ahead, niente repaint.**

---

## 2. 🔴 COSA È COSTITUTIVO (non si spegne) e COSA È INPUT

### Costitutivo — se lo togli, è un altro motore

| pezzo | perché è costitutivo |
|---|---|
| **IL PICCO DI VOLUME** | È **la tesi del candidato**. `REGISTRO_TEST.md` §MODIFICHE dà la soglia di casa (≥1,5× media a 20 barre) e in casa il volume l'abbiamo misurato **solo come filtro appiccicato**: R12 (ORB+EMA200+volumi Nasdaq) → **48/48 negative OOS**; R101 gradino `02_volumi` → unico sopravvissuto a G1+G2+G3. Il §5B del mandato misura la differenza: **filtro aggiunto dopo = 0 successi su 5; filtro che È la strategia = 30 celle su 30.** 👉 **Non esiste nessun `InpUseVolume`: sarebbe la trasformazione dell'EA in un motore diverso, e renderebbe la misura irripetibile.** |
| **LE TRE CONDIZIONI INSIEME** | `SegnaleLato_Calc()` le richiede tutte e tre + grilletto. Non c'è un modo "2 su 3". |
| **IL PIVOT CONFERMATO** | il ritardo di `InpPivotRight` barre è ciò che rende il livello non ridipingente. Le spalle sono input, la **conferma** no. |
| **UNA POSIZIONE ALLA VOLTA** | fedele all'autore (`strategy.position_size == 0`). |
| **SL VERO AL BROKER** | mai stealth, mai virtuale (bandiera §4). |

### 🎛️ Comportamento a dato mancante — scelta dichiarata

Negli altri EA di casa un filtro senza dati **lascia passare** (_"un filtro senza
dati non deve inventare un veto"_, `VolumeOK()` di `ABTG_CrossEma`).
**Qui è il contrario:** `VolumeSpike_Calc()` e `Esaurimento_Calc()` a dato
mancante **BLOCCANO**. Motivo in una riga: **un filtro senza dati non deve
vietare, ma un MOTORE senza dati non esiste.**

### Input — tutti con default = autore, salvo i due dichiarati al §4

Il tetto di casa è ~15 input sul motore. Qui il **motore** ne ha 13, il resto è
gestione/operativa/standard.

---

## 3. 📋 GLI INPUT COMPLETI, COL DEFAULT E DA DOVE VIENE

### Motore (costitutivo: non si spegne, si tara)
| input | default | da dove viene |
|---|---|---|
| `InpPivotLeft` | **5** | 🟰 autore |
| `InpPivotRight` | **5** | 🟰 autore (= barre di conferma) |
| `InpProxMode` | **EX_PROX_PERC** | 🟰 autore (l'alternativa ATR è §4.1) |
| `InpProxPercent` | **0.5** | 🟰 autore (`level_diff_per = 0.5`) |
| `InpProxAtrMult` | 0.5 | 🆕 nostro, **inerte** nel modo PERC |
| `InpAtrPeriod` | **14** | 🟰 autore |
| `InpAtrExhaustMult` | **2.0** | 🟰 autore |
| `InpVolSmaBars` | **20** | 🟰 **autore E casa: coincidono** ⬇️ |
| `InpVolSpikeMult` | **1.5** | 🟰 **autore E casa: coincidono** ⬇️ |
| `InpTrigMode` | **EX_TRIG_AUTORE** | 🟰 autore (l'alternativa è §4.2) |
| `InpTrigClosePct` | 70.0 | 🆕 nostro, **inerte** nel modo AUTORE |
| `InpAllowLong` | true | 🏠 casa: **i lati si misurano SEPARATI** (R52) |
| `InpAllowShort` | true | idem |

> ✅ **LA COINCIDENZA CHE NON VA TOCCATA.**
> `REGISTRO_TEST.md` §MODIFICHE fissa la soglia di casa a **≥1,5× la media a 20
> barre**. Il default dell'autore è `vol_multiplier = 1.5`, `vol_sma_len = 20`.
> **Identici.** E il corso lo prescrive per conto suo
> (`ANALISI_LIVE_EMILIANO_2026-08-24.md`: _"ORB: si entra SOLO con aumento di
> volume"_). **Tre strade indipendenti, stesso numero.**
> 👉 **Questi due parametri NON entrano nella prima griglia.** Cambiarli
> significherebbe buttare via l'unico punto in cui il candidato esterno, la
> nostra regola e il corso concordano — e trasformare una convergenza in una
> manopola da girare verso il passato.

### Stop, target, gestione
| input | default | nota |
|---|---|---|
| `InpSLBufferPts` | **0** | 🟰 autore = stop **esattamente** sul livello. >0 = stop **oltre** il pivot (§6, prima cosa da misurare) |
| `InpMinSLPts` | **0** | 🟰 autore. Pavimento in **punti MT5**; se acceso lo stop **si allarga**, non salta il trade |
| `InpTP_RR` | **2.0** | 🟰 autore (`rr_ratio = 2.0`) |
| `InpTP1_RR` | 1.0 | 🆕 inerte finché `InpTP1Pct = 0` |
| `InpTP1Pct` | **0** | 🟰 autore: **niente parziale**. La gestione "parziale 1R + BE + runner" della scheda P2 è **presente ma spenta** |
| `InpBreakeven` | true | inerte senza parziale (stessa firma degli altri ABTG) |
| `InpUseTrailAtr` | **false** | 🆕 opt-in |
| `InpTrailAtrMult` | 2.0 | inerte |

### Operativa
| input | default | nota |
|---|---|---|
| `InpMaxTradesPerDay` | **3** | 🔴 **SCOSTAMENTO OBBLIGATO** (§4.5) |
| `InpOneTradePerLevel` | **false** | 🟰 autore (l'idea "un livello = un trade" è della scheda P2: presente, spenta) |
| `InpUseHourFilter` / `InpHourStart` / `InpHourEnd` | false / 8 / 20 | **ORA SERVER**. BCM = ora italiana −1 |
| `InpFridayClose` / `InpFridayCloseHour` | false / 20 | opt-in |
| `InpRiskPercent` | **1.0** | 🔴 **SCOSTAMENTO DICHIARATO** (§4.6) |
| news (7 input) | tutti off | blocco standard ABTG |
| `InpComment` | `"ATREXH"` | |
| `InpMagic` | **774401** | blocco vergine |
| `InpMaxSpread` | 0 | punti MT5 |
| `InpVerbose` / `InpAutoTest` | true / true | |
| `InpUsaGuardian` | true | fail-open: nel tester non esiste → **backtest confrontabili** |

---

## 4. 🔍 GLI SCOSTAMENTI DAL PINE — uno per uno, col motivo

**Regola applicata: default = AUTORE.** Ogni variante nostra esiste come input
con default che **non cambia il comportamento del Pine tradotto**, così la cella
"AUTORE" del round è il porting nudo e ogni gamba si misura da sola.
Se una variante è accesa, l'EA **lo scrive nel log** (`ATTENZIONE: almeno una
variante è accesa. Questa cella NON è la cella AUTORE del porting.`).

### 4.1 Prossimità in % del prezzo → resta il default, ma c'è il modo ATR
- **Autore:** `level_diff_per = 0.5%` del prezzo del pivot.
- **Il problema (scheda P2):** su un DAX a 24.000 sono **120 punti indice** di
  tolleranza; su un Dow a 45.000, **225**. È il difetto di scala già visto in
  `ProAutoSL_DynamicTP`.
- **Cosa ho fatto:** `InpProxMode` con **default PERC (autore)** + modo ATR.
- **Perché non ho messo l'ATR come default:** sarebbe stata una nostra variante
  spacciata per porting. **La misura decide, non io.** ⚠️ Questa è la prima
  gamba dell'ablazione (§6).

### 4.2 Grilletto debole → resta il default, ma c'è il modo CLOSE
- **Autore:** `close > open or close > high[1]` → vero **circa metà delle
  volte**: è il pezzo più debole del file (giudizio della scheda P2).
- **Cosa ho fatto:** `InpTrigMode` con **default AUTORE** + modo CLOSE
  (chiusura oltre il 70% del range dal lato favorevole, grilletto preso dal
  candidato P1). Seconda gamba dell'ablazione.

### 4.3 🔴 ASIMMETRIA DELL'AUTORE CORRETTA — l'unico scostamento nel MOTORE
```pine
dist_from_high = last_ph - low      // LONG:  usa il MINIMO della barra
dist_from_low  = close  - last_pl   // SHORT: usa la CHIUSURA della barra
```
- **Fatto:** il Pine misura l'esaurimento con **due grandezze diverse** sui due
  lati. Non c'è nessuna riga nel file che lo giustifichi.
- **Cosa ho fatto:** **simmetrizzato sull'ESTREMO** (`low[1]` per il long,
  `high[1]` per lo short).
- **Motivo:** (a) l'esaurimento è "quanta strada ha fatto il movimento", e la
  strada la segna l'estremo; (b) la simmetria long/short è **costitutiva** in
  questo motore (è uno dei buchi che deve riempire: le nostre celle vive sono
  quasi tutte long-only, R52) e un'asimmetria non motivata la rompe; (c) la
  direzione della correzione è **verso il ramo dell'autore**: il long usa già
  l'estremo, quindi lo short diventa permissivo **quanto il long**, non di più.
- **Effetto atteso:** **qualche short in più** rispetto al Pine. È l'unico punto
  in cui il conteggio dei trade del porting può divergere da quello dell'autore
  a parità di dati. **Dichiarato qui perché regga fra un mese.**

### 4.4 Media del volume: la barra di segnale NON entra nella sua media
- **Autore:** `ta.sma(volume, 20)` **include** la barra corrente.
- **Nostro:** media sulle **20 barre precedenti** ([2]…[21]).
- **Motivo:** è la convenzione di casa (`VolumeOK()` di `ABTG_CrossEma`), e due
  EA che misurano "il volume" in due modi diversi non sono confrontabili fra
  loro.
- **Quanto pesa, misurato a tavolino:** con l'inclusione la condizione
  `V > 1,5·(V+19M)/20` equivale a **V > ~1,54·M**; con l'esclusione è
  **V > 1,50·M**. 👉 **Il nostro è ~2,6% più permissivo.** Differenza piccola ma
  **non nulla**: se un giorno i conteggi non tornano con TradingView, è qui.

### 4.5 🔴 CAP GIORNALIERO — scostamento per REGOLA DI CASA, non per misura
- **Autore:** nessun cap.
- **Nostro:** `InpMaxTradesPerDay = 3`.
- **Motivo:** criterio **C6** del dossier: _"ogni promosso deve avere un cap di
  operazioni al giorno fra i suoi input"_ (`METRO_PROP`: −5.000 € su 100k butta
  fuori anche col totale intatto). E il rischio è specifico di questo motore:
  **tre indici × tre trade = nove operazioni**, e se DAX, Dow e Nasdaq si
  esauriscono sullo stesso livello lo stesso pomeriggio **sono stop correlati in
  una seduta sola**. La peggior giornata di casa misurata è **−2,06%** (R51).
- ⚠️ **È l'unico default che cambia il comportamento rispetto al Pine.** Va
  detto ogni volta che si confronta un conteggio col TradingView dell'autore.
  Chi vuole la fedeltà pura mette `InpMaxTradesPerDay = 0` e **lo dichiara**.

### 4.6 Rischio 0,5% → 1,0%
- **Autore:** `risk_per_trade = 0.5%`. **In campo giriamo a 0,65%.**
- **Nostro default: 1,0%**, perché è il default richiesto per questo porting.
- ⚠️ **Il rischio % è un moltiplicatore lineare del P/L e del drawdown**: il
  round va letto sapendo che **a 0,65% tutti i numeri in euro e in % si
  moltiplicano per 0,65**, e a 0,5% (autore) per 0,5. **Nessuna conclusione sul
  MERITO cambia; tutte le conclusioni sul RISCHIO sì.**

### 4.7 Volume = TICK VOLUME
- **Autore:** `volume` del feed TradingView (su un future = volume vero).
- **Nostro:** `CopyTickVolume` — sugli indici CFD di BCM `SYMBOL_VOLUME_REAL`
  non è garantito, **il tick volume è quello che c'è**.
- ⚠️ **[INCERTO, da misurare]**: se BCM esponesse il volume reale su
  D30EUR/U30USD/NASUSD, la misura andrebbe rifatta. Non è un dettaglio:
  **è il dato su cui poggia il motore intero.**

### 4.8 Pivot: pareggi esclusi
- `ta.pivothigh` non documenta la semantica dei pareggi. Ho scelto il confronto
  **strettamente maggiore su entrambi i lati**: un plateau (due massimi
  identici) **non è un pivot**. **Perde qualche livello, non ne inventa
  nessuno.** Sugli indici a 1-2 decimali i pareggi esistono davvero, quindi lo
  scarto è reale ma conservativo. **[SCELTA DICHIARATA]**

### 4.9 Traduzioni tecniche obbligate (non sono scelte)
- `strategy.entry` a chiusura barra → **ordine a mercato all'apertura della
  barra successiva** (equivalente MT5).
- `strategy.exit(stop=, limit=)` → **SL e TP veri sul server** all'apertura.
- **Rispetto di `SYMBOL_TRADE_STOPS_LEVEL`**: se lo stop strutturale cade dentro
  la distanza minima del broker, **il trade non parte** (in Pine il problema non
  esiste). Se il TP cade dentro, il TP viene **tolto** e la posizione resta alla
  gestione. ⚠️ **Questo può togliere trade che TradingView mostra.**
- **Normalizzazione al tick** (`SYMBOL_TRADE_TICK_SIZE`) e **vincoli di volume**
  (min/max/step) — assenti in Pine, obbligatori qui.
- **Nessuna ipotesi forex nel sizing:** distanza in **prezzo**, perdita per
  lotto da `OrderCalcProfit` (lezione 08/08/2026 su 225JPY), tick value solo
  come ripiego. Le soglie "in punti" degli input sono **punti MT5** (`_Point`):
  su U30USD e NASUSD **1 punto indice = 100 punti MT5** (misura R97).

### 4.10 Cosa NON ho portato del Pine
I `plot`/`plotshape` (grafica pura) e `initial_capital`/`currency` (roba del
simulatore TradingView).

---

## 5. 🎯 DOVE DEVE GIRARE, E QUANTO DOVREBBE SPARARE

**Simboli:** `D30EUR`, `U30USD`, `NASUSD` (BCM, conto HEDGING).
**TF primario: M15.** Seconda cella su **M5** (dove la frequenza sale e il
campione si allarga). Storico BCM sugli indici: dal **2024.09.26** (misurato,
`REFERTO_SONDA_STORICO_17-08.md`, stato COMPLETO) ≈ **450 sedute**.

> ⚖️ **REGOLA DEI DUE LATI + STORICO LUNGO (CLAUDE.md, congelata il 25/08).**
> Due conseguenze dirette su questo candidato:
> 1. **Long E short si misurano TUTTI E DUE, sempre** — è già il punto 1 del §6,
>    ed è anche il lato che ho simmetrizzato (§4.3): a maggior ragione.
> 2. **La profondità dei dati BCM sugli indici si MISURA, non si assume.** Il
>    "dal 2024.09.26" qui sopra viene dalla sonda del 17/08: **va rifatta prima
>    del round**, perché se il broker nel frattempo ha allungato lo storico
>    cambia il conteggio delle operazioni e quindi l'esito dell'Emendamento §A.
>    ⚠️ **E c'è il tetto del tester: ~100.000 barre per corsa** → **M15 ≈ 4 anni,
>    M5 ≈ 1,3 anni**. Per finestre più lunghe si sale di TF o si spezza la corsa
>    in tranche, **dichiarandolo**. Su M5 questo morde subito.

### 📊 Frequenza — ⚠️ **STIME, NON MISURE**

| | valore | rango |
|---|---|---|
| trade/giorno per indice, M15 | **1-3** | 🔶 **STIMA** della scheda P2, non misurata da noi |
| operazioni totali attese, M15, 450 sedute, un indice | **~450-1.350** | 🔶 **STIMA derivata** dalla riga sopra |
| il collo di bottiglia | la condizione di **esaurimento a 2 ATR** | 🔶 **INFERENZA** dalla lettura del sorgente: i pivot(5,5) su M15 sono frequenti, il volume >1,5× capita spesso, la corsa da 2 ATR no |

👉 **Se la stima regge, questo è il primo candidato del lotto che NON ha
problemi di campione** (Emendamento §A: ≥150 operazioni IS). **Se non regge,
scatta la valvola R59** — vedi §7.

### 💰 Cancello C1 (il costo è il criterio) — anch'esso STIMA
| | stima |
|---|---|
| SL (distanza barra→pivot su M15) | **10-25 punti indice** 🔶 |
| TP a 2R | **20-50 punti indice** 🔶 |
| spread BCM indici | **1-2 punti indice** ⚠️ **[INCERTO]** (`R98_CRITERI.md`, non è una misura nostra ripetibile) |
| take medio / spread | **~10-25×** → ✅ **PASSA C1** con margine |

⚠️ **Il PASSO 0 del round misura il lordo medio per operazione in punti indice
PRIMA di leggere qualunque profit factor.** È il cancello S0 che ha bocciato R98
in una riga (lordo medio **−0,31 punti** su 410 operazioni).

---

## 6. 🧪 COSA MISURARE, E IN CHE ORDINE (per il round, che non è questo file)

**Una gamba alla volta, tutto il resto pinnato.** La cella base è **AUTORE**:
`ProxMode=PERC`, `TrigMode=AUTORE`, `TP1Pct=0`, `TrailAtr=off`,
`OneTradePerLevel=off`, `SLBufferPts=0`, `MinSLPts=0`.

0. **PASSO 0 — CONTARE.** Trade totali, trade/giorno, lordo medio in punti
   indice, distribuzione di R. **Prima di qualunque PF.**
1. **I LATI SEPARATI** (`InpAllowLong` / `InpAllowShort`, mai insieme al primo
   colpo): lezione R52, e qui lo short è anche il lato che ho simmetrizzato
   (§4.3).
2. **Prossimità PERC vs ATR** (§4.1) — l'ipotesi più forte del dossier.
3. **Grilletto AUTORE vs CLOSE** (§4.2).
4. **SL: buffer oltre il pivot** (`InpSLBufferPts` > 0) e **pavimento**
   (`InpMinSLPts` > 0).
5. **Gestione:** parziale 1R + BE (`InpTP1Pct`), poi trailing.
6. **`InpOneTradePerLevel`** (lo stesso pivot che spara più volte).
7. ❌ **`InpVolSpikeMult` e `InpVolSmaBars` NON si toccano nella prima
   griglia** (§3).

**Selezione della cella: CENTRO DELL'ALTOPIANO, MAI IL PICCO** — e la regola di
selezione si dichiara insieme al numero, altrimenti il numero non vuol dire
niente (Emendamento §A).

---

## 7. 🚨 I RISCHI — dichiarati PRIMA dei numeri

1. 🔴 **OHLC 1-min SU M15 INGANNA — validazione SOLO A TICK REALI.**
   Misurato in casa: **+129k finti sul DAX** (`REGISTRO_TEST.md` §2), e il
   capitolo breakout M5 d'apertura è chiuso proprio per questo. Qui morde **più
   del solito**: l'ingresso nasce da un **estremo di barra** (`low[1]`/`high[1]`)
   e lo stop sta **a un tick dal minimo** (buffer 0 di default). In OHLC il
   simulatore non sa in che ordine il prezzo ha visitato high e low dentro la
   barra → **stop e target dello stesso trade sono decisi da un'ipotesi.**
   👉 **Lo screening OHLC vale per CONTARE i trade e leggere la frequenza. MAI
   per il segno.**
2. 🔴 **n < 150 → VALVOLA R59.** Se le operazioni IS sono meno di 150
   (Emendamento §A), il round **misura il RISCHIO** (drawdown, peggior giornata:
   fatti accaduti) e **sospende il giudizio sul MERITO**. Non si promuove niente
   su un campione sottile, e non si boccia niente **per il merito** su un
   campione sottile.
3. 🔴 **UN SOLO REGIME.** Lo storico BCM sugli indici parte dal **2024.09.26**:
   ~21 mesi, prevalentemente **rialzisti**. Un motore **controtendenza** in un
   toro incassa serie di stop; in un orso potrebbe fare tutt'altro. **Non
   abbiamo la prova di regime** (Emendamento §C) su questi simboli. Va scritto
   nel referto, non scoperto dopo.
4. 🟠 **CORRELAZIONE FRA I TRE INDICI.** DAX, Dow e Nasdaq si esauriscono spesso
   **insieme**. Il cap giornaliero è un tampone per sedia, **non** un cap di
   famiglia: serve un limite di posizioni aperte contemporanee sull'intera
   famiglia prima di qualunque discorso prop (lo dice la scheda P2, §🏛️).
5. 🟠 **STOP MOLTO STRETTO → LOTTO GRANDE.** Con `InpMinSLPts = 0` uno stop
   strutturale può nascere a pochi punti dal prezzo: il lotto per rischio
   esplode e **lo slippage si mangia l'operazione intera** (R55: 1,5 punti
   indice sfondavano il 10% sull'ORB). Il pavimento c'è ed è un input; **il
   PASSO 0 deve guardare la distribuzione di R e dire se va acceso.**
6. 🟠 **TICK VOLUME ≠ VOLUME.** §4.7. È il dato su cui poggia tutto il motore.
7. 🟠 **BROKER SINGOLO, COSTI SINGOLI.** Tutto misurato su BCM, con lo spread di
   BCM. Non è una proprietà del mercato.
8. ⚪ **PINE → MQL5 NON È UN PORTING, È UNA RISCRITTURA** (mandato §3D). I numeri
   che l'autore mostra su TradingView sono **una sola sequenza, senza costi**:
   **nessun numero d'autore è stato usato in questo documento**, e nessuno deve
   entrare nel referto del round.

---

## 8. 👀 DOVE GUARDA PER PRIMO UN REVISORE

Se hai dieci minuti e vuoi trovare l'errore, guarda **in quest'ordine**:

1. **`AggiornaPivot()`** — l'indice della barra candidata è `1 + InpPivotRight`.
   Se qualcuno lo abbassa a `InpPivotRight`, **entra una barra in formazione e
   il pivot ridipinge**: da lì in poi ogni backtest è finto.
2. **`SegnaleLato_Calc()`** — che le tre condizioni siano davvero in **AND** e
   che `VolumeSpike_Calc` **non** abbia un `return(true)` di cortesia sui dati
   mancanti. È il punto in cui il motore potrebbe silenziosamente diventare un
   altro motore.
3. **§4.3, la simmetrizzazione dell'esaurimento** — è l'unico scostamento nel
   motore, ed è il primo sospetto se i conteggi short non tornano.
4. **`LeggiVolume()`** — `CopyTickVolume(_Symbol,gTF,1,n+1,v)`: parte da **shift
   1** (la barra di segnale è `v[0]`) e la media gira su `v[1..n]`. Se qualcuno
   la fa partire da 0, la barra in formazione entra nel calcolo.
5. **`Enter()`** — ordine: pavimento → normalizzazione → `STOPS_LEVEL` → TP →
   lotto → **Guardian** → invio. Il Guardian sta **immediatamente prima
   dell'invio**, così l'unico effetto è che l'ordine non parte.
6. **`LotByRisk()`** — che la distanza sia in **prezzo** e la perdita per lotto
   venga da `OrderCalcProfit`. Qualunque conversione in "pip" qui è un bug su un
   indice.
7. **Gli orari** — `OraOK()` legge `iTime(...,1)`, cioè l'**ora SERVER** della
   barra di segnale. **Ora italiana −1.** E i log di MT5 sono in ora **locale
   del PC**: non confrontarli col grafico (lezione 06/08).
8. **L'AUTOTEST** — 7 blocchi sul nucleo puro (pivot, prossimità, esaurimento,
   volume, grilletti, segnale completo, pavimento SL, orario). Si legge
   **ESEGUENDO** un test singolo nel tester, **non compilando**. Se stampa
   `DIVERGE`, i risultati non si usano.

---

## 9. ⚠️ LE DUE RIGHE CHE VALGONO PIÙ DI TUTTO IL RESTO

> **Questo file NON dice che la strategia funziona.** Dice cosa fa il codice,
> dove si scosta dall'autore e perché, e quali sono i rischi. **Il giudizio
> arriva dal round, a tick reali, con i criteri congelati prima dei numeri.**

> **NON va in forward.** Un backtest profittevole non è una promessa: broker
> singolo, un solo regime, ~21 mesi di storico, e un motore controtendenza in un
> mercato che è salito.

---

*Documento della caccia M5/M15 indici del 25/08/2026 — candidato P2.
EA: `mql5/Experts/ABTG_AtrExhaustVol.mq5`, magic 774401.
Attribuzione: MyStrategyHub, TradingView `8ltrS3Yg`.*
