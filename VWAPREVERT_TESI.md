# 🎯 VWAP MEAN REVERSION — tesi del porting (25/08/2026)

**File EA:** `mql5/Experts/ABTG_VwapRevert.mq5` · **magic 773400** (blocco
7734xx verificato VERGINE nel repo il 25/08/2026; il gemello S2 è `773401`)
**Origine:** candidato **P1** della caccia M5/M15 indici del 25/08/2026
(`backtest_pipeline/caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md`, voto
**8/10 — PROVA SUBITO**).
**Sorgente d'autore:** `VWAP Mean Reversion Strategy` di **sumbloke077**,
TradingView `YBqnzqDK`, creato 2026-04-02, v2.0, 247 righe, 22 input,
`scriptAccess: open_no_auth`, **nessuna licenza dichiarata nel file** (comincia
direttamente da `//@version=5`) → ⚠️ attribuzione obbligatoria, riportata in
testa al `.mq5`.
Copia archiviata:
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/VwapMeanReversion_sumbloke077_tvYBqnzqDK_2026-08-25.pine`.

> ⚠️ **QUALE DEI DUE VWAP REVERSION.** In biblioteca ce ne sono **due**. Questo
> porting è del **`VwapMeanReversion_sumbloke077_tvYBqnzqDK`** (P1, promosso).
> **NON** è il `VwapSD2Reversion_jswapnil_tvoSV81CXs` (§3.2 del dossier:
> scartato — long-only, `default_qty_type = strategy.fixed 100000` = lotto
> fisso, TP/SL a 5 pip tarati su forex, ~30 input; tenuto solo come *spunto*
> per la macchina a stati a 3 passi).

> 🚧 **STATO: CANDIDATO DA BACKTEST.** Non è una sedia, **non va in forward**,
> il round coi criteri **non è questo documento**. Qui c'è solo: il meccanismo,
> cosa è costitutivo, ogni scostamento dichiarato, e i rischi da mettere sul
> tavolo *prima* di guardare un numero.

---

## 1. ⚡ IL MECCANISMO IN UNA PAGINA

**La tesi di mercato, in una riga:**
> _"Dentro la sessione la VWAP è il prezzo che il flusso istituzionale ha
> davvero pagato: quando il prezzo si allontana oltre una deviazione standard
> E lì dentro stampa una candela di rifiuto all'estremo delle ultime 20 barre,
> chi ha inseguito è in perdita e il ritorno verso la VWAP è il suo costo."_

È un **fade a una banda statistica**, non un breakout. E non è nessuno dei
nostri caduti: non è un ORB (niente box, niente orario d'ingresso, zero input
di sessione nel sorgente); non è **R42** (il livello non è l'estremo di un box
di 15 minuti, è una banda ricalcolata a ogni barra sulla sessione in corso, e
soprattutto **c'è una barra di CONFERMA** — R42 entrava sull'estremo secco);
non è **R95/sweep+reclaim** (nessun livello da bucare e riconquistare); non è
**R98** (nessun legame primi-30'/ultimi-30', e la direzione è **opposta**: qui
si compra la debolezza).

### Il giro completo (LONG; lo short è lo specchio esatto)

| # | pezzo | come si calcola nel `.mq5` |
|---|---|---|
| 1 | **LA BANDA** | `CalcVwapBanda()` → VWAP di sessione su `hlc3` pesata sul **tick volume**, azzerata al cambio giorno **server**, accumulata **solo su barre chiuse**; σ volume-pesata; banda a `VWAP − InpSigmaMult·σ`. 🔴 **Costitutiva.** |
| 2 | **FUORI BANDA** | `FuoriBanda_Calc()` — la **chiusura della barra di SETUP** sta sotto la banda bassa. Confronto stretto, come l'autore (`close[1] < lowerBand`). |
| 3 | **L'ESTREMO** | il **minimo della barra di setup** è il minimo delle ultime `InpLookback` barre (setup compresa) — `iLowest(...)`. 🔴 **Costitutivo.** |
| 4 | **LA CANDELA DI RIFIUTO** | `Hammer_Calc()` **oppure** `Doji_Calc()` sulla barra di setup, con la geometria dell'autore. 🔴 **Costitutiva.** |
| 5 | **LA BARRA DI CONFERMA** | la barra dopo: `ChiusuraForte_Calc()` (chiude nel **70% alto** del proprio range) **e** `Engulfing_Calc()` **o** `Continuazione_Calc()` (minimo più alto + chiusura sopra il massimo del setup) **e** `AntiCandelone_Calc()` (range ≤ `InpAtrMult·ATR`). |
| 6 | **INGRESSO** | **BUY STOP** sopra il massimo della barra di **conferma** + `InpAtrBufferPct·ATR`, piazzato all'apertura della barra successiva, **vivo `InpOrderLifeBars` barre** poi cancellato. |
| 7 | **STOP** | al **minimo della barra di conferma** − buffer. Poi pavimento in ATR (due semantiche, §4.4), normalizzazione al tick, controllo `SYMBOL_TRADE_STOPS_LEVEL`. |
| 8 | **TARGET** | **2R** secco (default autore), misurato **dal livello d'ingresso**. Parziale/BE/trailing esistono ma partono **spenti**. |
| 9 | **LOTTO** | dal rischio: `InpRiskPercent` del saldo / R, con `OrderCalcProfit` (converte in valuta conto) e tick value come ripiego. |

**Le due barre, in indici MT5:** la barra di **SETUP** è la **[2]**, quella di
**CONFERMA** è la **[1]** (l'ultima chiusa), l'ordine nasce all'apertura della
**[0]**. È la traduzione esatta del `bearishSetupBar[1] and bearishCloseValid`
dell'autore. **Decide SOLO a barra chiusa: niente look-ahead, niente repaint.**

**Il FRONTE del segnale** (`longSignalOnce` dell'autore, che impedisce di
risparare mentre la condizione persiste) è ricalcolato **senza stato**: si
valuta il segnale con la conferma su [1] e lo si rivaluta con la conferma su
[2]; è un fronte solo se ora è vero e prima era falso. **Un riavvio dell'EA non
cambia la storia** — scelta voluta, costa una seconda passata sulla VWAP.

---

## 2. 🔴 COSA È COSTITUTIVO (non si spegne) e COSA È INPUT

### Costitutivo — se lo togli, è un altro motore

| pezzo | perché è costitutivo |
|---|---|
| **LA BANDA VWAP ±kσ** | È **la tesi del candidato**, ed è il punto per cui è stato promosso. In casa la VWAP l'abbiamo misurata **solo come FILTRO DIREZIONALE appiccicato**: `R101` gradino `07_vwap` → **INCOERENTE fra Dow e DAX** (PF +0,007 sul Dow, −0,061 sul DAX) → **bocciato**. `ROBUSTEZZA.md` misura la differenza fra le due forme: **filtro aggiunto dopo = 0 successi su 5** (R20 ADX, R12, R26, R45, R54, e R101/07 è il sesto); **filtro che È la strategia dall'inizio = 30 celle su 30** (`ABTG_EMA200` Dow, R29). 👉 **Non esiste nessun `InpUseVwap`.** Un input che spegnesse la banda trasformerebbe l'EA in un pattern-trader di hammer, cioè in un altro motore, e renderebbe la misura irripetibile. `InpSigmaMult ≤ 0` fa **fallire `OnInit`**, non "spegne il filtro". |
| **LA CANDELA DI RIFIUTO ALL'ESTREMO** | È l'altra metà del meccanismo secondo la scheda P1 (_"banda + rifiuto"_). Senza, si comprerebbe qualunque discesa fuori banda: è precisamente il fade sull'estremo secco che **R42 ha bocciato 0/24 IS e 0/24 OOS**. `InpLookback < 2` fa fallire `OnInit`. |
| **LA BARRA DI CONFERMA** | È ciò che colloca il motore nella famiglia **RETEST/RECLAIM** — quella che R42 indica come _"l'unica che ha sempre pagato"_ — invece che nel fade secco. Non c'è nessun input per entrare sulla candela di rifiuto stessa. |
| **UNA POSIZIONE ALLA VOLTA** | fedele all'autore (nessun pyramiding). E **un solo pendente alla volta** per magic. |
| **SL VERO AL BROKER** | mai stealth, mai virtuale (bandiera §4 del mandato). |

### 🎛️ Comportamento a dato mancante — scelta dichiarata

Negli altri EA di casa un filtro senza dati **lascia passare** (_"un filtro senza
dati non deve inventare un veto"_, `VolumeOK()` di `ABTG_CrossEma`).
**Qui è il contrario:** `FuoriBanda_Calc()` con **σ ≤ 0** e
`AntiCandelone_Calc()` con **ATR ≤ 0** **BLOCCANO**. Motivo in una riga: **un
filtro senza dati non deve vietare, ma un MOTORE senza dati non esiste.**

> ⚠️ **E qui c'è una conseguenza che vale la pena leggere due volte.** Nel Pine,
> a inizio sessione `cumVol` è piccolo e `stdev` tende a **0**: la banda
> collassa sulla VWAP e `close[1] > upperBand` diventa quasi sempre vero,
> cioè **il filtro-banda è di fatto INERTE nelle prime barre della seduta**.
> Il nostro `σ ≤ 0 → niente segnale` toglie solo il caso degenere della
> **prima barra** (σ esattamente 0). Le barre 2-4, dove σ è piccolo ma non
> nullo, **si comportano come nell'originale**. Per chiuderle davvero c'è
> `InpMinSessionBars`, **spento di default** (§4.7) — ed è una delle prime
> gambe da misurare, perché è il punto in cui il motore potrebbe star facendo
> tutt'altro da quello che la tesi racconta.

### Input — tutti con default = autore, salvo i tre dichiarati al §4

La geometria della candela (`InpBodyPctMax`, `InpWickMult`, `InpDojiBodyPct`,
`InpClosePct`) **si pinna ai default e NON entra nello sweep**: è la
prescrizione della scheda P1 (_"sono le manopole che il backtest girerebbe
verso il passato"_).

---

## 3. 📋 GLI INPUT COMPLETI, COL DEFAULT E DA DOVE VIENE

### Motore — banda VWAP (costitutiva: non si spegne, si tara)
| input | default | da dove viene |
|---|---|---|
| `InpSigmaMult` | **1.0** | 🟰 autore (bande a ±1σ) |
| `InpSessionStartHour` | **-1** | 🟰 autore (−1 = cambio giorno, `ta.change(time("D"))`). ≥0 = ancoraggio a un'ora SERVER (§4.6) |
| `InpMinSessionBars` | **0** | 🟰 autore (nessun minimo). 🆕 nostro se >0 (§4.7) |

### Motore — candela di rifiuto (costitutiva)
| input | default | da dove viene |
|---|---|---|
| `InpLookback` | **20** | 🟰 autore (`lookback = 20`) |
| `InpBodyPctMax` | **0.30** | 🟰 autore (`bodyPercentSS`) — 📌 **pinnato, fuori sweep** |
| `InpWickMult` | **2.0** | 🟰 autore — ma **un solo input per i due lati** (§4.3) — 📌 pinnato |
| `InpDojiBodyPct` | **0.20** | 🟰 autore (`dojiBodyPercent`) — 📌 pinnato |
| `InpClosePct` | **0.30** | 🟰 autore (`closePercent`) — 📌 pinnato |
| `InpEngulfingOnly` | **false** | 🟰 autore |
| `InpAtrPeriod` | **10** | 🟠 autore "base", **ma vedi §4.1: il Pine con i suoi default calcola in realtà ATR(960) su M15** |
| `InpAtrMult` | **1.5** | 🟰 autore (`atrMultiplier`, anti-candelone) |
| `InpAllowLong` | true | 🏠 casa: **i lati si misurano SEPARATI** (R52) |
| `InpAllowShort` | true | idem |

### Ingresso, stop, target
| input | default | nota |
|---|---|---|
| `InpAtrBufferPct` | **0.01** | 🟰 autore (`atrBufferPerc`) |
| `InpSlAtrFloor` | **0.20** | 🟰 autore (`stopATR`) |
| `InpSlFloorMode` | **VR_FLOOR_AUTORE** | 🟰 autore (§4.4). L'alternativa `ALLARGA` è la convenzione di casa |
| `InpSlUseSetupBar` | **false** | 🆕 nostro, spento: SL sull'estremo più protettivo fra setup e conferma |
| `InpTpR` | **2.0** | 🟰 autore (`takeProfitRiskMultiplier`). 0 = nessun TP |
| `InpOrderLifeBars` | **3** | 🟰 autore, ma il numero **non è 2** (§4.5) |
| `InpCloseOnOpposite` | **true** | 🟰 autore (`enableCloseOpposite`) |
| `InpSpreadExtraPts` | **0** | 🔴 **SCOSTAMENTO DICHIARATO** (§4.2): con 0 **non si conta lo spread due volte** |

### Gestione della posizione (spenta = autore)
| input | default | nota |
|---|---|---|
| `InpUsePartial` | **false** | 🟰 autore: **niente parziale**. La gestione "parziale 1R + BE + runner" della scheda P1 è **presente ma spenta** |
| `InpPartialR` | 1.0 | inerte |
| `InpPartialPercent` | 50.0 | inerte |
| `InpBreakEven` | true | inerte senza parziale (stessa firma degli altri ABTG) |
| `InpUseTrailAtr` / `InpTrailAtrMult` | **false** / 2.0 | 🆕 opt-in |

### Operativa
| input | default | nota |
|---|---|---|
| `InpMaxTradesPerDay` | **2** | 🔴 **SCOSTAMENTO OBBLIGATO** (§4.8). Conta gli ingressi **ESEGUITI**, non i pendenti piazzati |
| `InpUseHourFilter` / `InpHourStart` / `InpHourEnd` | **false** / 10 / 16 | **ORA SERVER**. Spento = autore; i valori 10-16 sono la **fascia bersaglio P1** già pronta |
| `InpFridayClose` / `InpFridayCloseHour` | false / 20 | opt-in |
| `InpRiskPercent` | **1.0** | 🟰 **autore E file prova: coincidono** (`riskPerc = 1.0`) |
| `InpMaxSpread` | 0 | punti MT5 |
| `InpMaxSpreadPctSL` | **0** | 🆕 standard di casa R55 (spread in % dello stop), spento |
| news (7 input) | tutti off | blocco standard ABTG |
| `InpComment` | `"VWAPREV"` | |
| `InpMagic` | **773400** | blocco vergine, già pinnato dal file prova |
| `InpVerbose` / `InpAutoTest` | true / true | |
| `InpUsaGuardian` | true | fail-open: nel tester non esiste → **backtest confrontabili** |

---

## 4. 🔍 GLI SCOSTAMENTI DAL PINE — uno per uno, col motivo

**Regola applicata: default = AUTORE.** Ogni variante nostra esiste come input
con default che **non cambia il comportamento del Pine tradotto**, così la cella
"AUTORE" del round è il porting nudo e ogni gamba si misura da sola.
Se una variante è accesa, l'EA **lo scrive nel log** (`ATTENZIONE: almeno una
variante e' accesa. Questa cella NON e' la cella AUTORE del porting.`).

### 4.1 🔴 L'ATR DELL'AUTORE, CON I SUOI DEFAULT, È ATR(960) SU M15 — non ATR(10)

```pine
useAdaptiveATR = input.bool(true,  "Use Adaptive ATR")
baseATRLength  = input.int(10,     "Base ATR Length (on target TF)")
targetTF       = input.timeframe("Chart", "Target Timeframe for ATR")
tfInMinutes(tf) => switch tf
    "1" => 1 ... "240" => 240 ... "D" => 1440
    => 1440                       // <-- il ramo di DEFAULT
adaptiveATRLength = math.max(1, math.round(baseATRLength * (targetTFmin / chartTFmin)))
```

- **Fatto misurato leggendo il sorgente:** la stringa **`"Chart"` non compare in
  nessun `case`** dello `switch`. Cade quindi nel ramo di default e
  **`targetTFmin = 1440`**. Su un grafico M15 (`chartTFmin = 15`):
  `adaptiveATRLength = round(10 × 1440/15)` = **960 barre**. Su M5 sarebbe
  **2880**.
- **Cosa fa davvero, quindi:** l'ATR non è una misura *locale* di volatilità, è
  una **media lunghissima** (960 barre M15 ≈ 10 sedute). Questo cambia tutti e
  tre i suoi usi: l'anti-candelone (`range ≤ 1,5·ATR`), il buffer
  (`0,01·ATR`) e il pavimento dello stop (`0,2·ATR`).
- **È quasi certamente un bug dell'autore**, non un'intenzione: l'etichetta
  dice _"Base ATR Length (on target TF)"_ e il calcolo `base × (target/chart)`
  ha senso solo se con "Chart" il rapporto vale 1.
- **Cosa ho fatto:** ho portato **l'INTENZIONE** — `InpAtrPeriod = 10` sull'ATR
  del TF del grafico — e **non** ho portato la macchina di conversione fra
  timeframe (che con "Chart" non è conversione, è un incidente).
- **Come si riproduce il comportamento LETTERALE del Pine:** basta
  `InpAtrPeriod = 960` su M15 (o 2880 su M5, 480 su M30). **L'input basta a
  coprire entrambe le letture**, e questa è una gamba dell'ablazione (§6).
- ⚠️ **Va detto ogni volta che si confronta un conteggio col TradingView
  dell'autore: i due EA NON stanno usando lo stesso ATR.**

### 4.2 🔴 LO SPREAD: l'autore lo modella a mano, MT5 lo modella da solo

```pine
spreadPoints = input.float(0.09, "Broker Spread (in price units)")
effectiveLongEntry := longEntry + spreadPoints
strategy.exit("Long Exit", stop = longStopStored - spreadPoints,
                           limit = longTargetStored - spreadPoints)
```

- **Perché l'autore lo fa, ed è il pezzo migliore del suo file:** in Pine c'è
  **una sola serie di prezzi**. Se non aggiungi lo spread a mano, non lo paghi
  mai. È la lezione **R55** applicata a monte, ed è per questo che la scheda P1
  dice _"da tenere nella riscrittura"_.
- **Perché in MT5 tenerlo *alla lettera* sarebbe un ERRORE:** MT5 ha **bid e
  ask veri**. Un BUY STOP scatta sull'**ask**, uno SL/TP long esegue sul
  **bid**: **lo spread lo paghi già, una volta.** Sommarci `spreadPoints`
  significherebbe **contarlo due volte** e bocciare il motore per un costo
  inventato.
- **Cosa ho fatto:** `InpSpreadExtraPts = 0` di default. **Non è "ho buttato via
  il pezzo migliore": è che in MT5 quel pezzo lo fa il simulatore.**
- **A cosa serve allora l'input, e non è un contentino.** Resta un **residuo di
  traduzione vero e misurabile**: i grafici MT5 sono **bid-based**, quindi
  `iHigh(...,1)` è un **massimo di bid**, mentre il BUY STOP scatta sull'**ask**
  = bid + spread. Un BUY STOP messo a `high_bid + buffer` viene toccato quando
  il **bid** arriva a `high_bid + buffer − spread`: **un filo più facile da
  riempire di quanto l'autore intendesse.** `InpSpreadExtraPts` (in punti MT5)
  rimette quella distanza. **[GAMBA DA MISURARE, non da assumere]**: quanto
  pesi lo si vede solo contando i trade con 0 e con lo spread tipico.

### 4.3 Le due ombre: due input dell'autore → uno solo nostro
- **Autore:** `upperWickMultiple = 2.0` e `lowerWickMultiple = 2.0`, separati.
- **Nostro:** **`InpWickMult = 2.0`, uno solo, applicato a entrambi i lati.**
- **Motivo:** i due default sono **identici**, e la **simmetria long/short è
  costitutiva** in questo motore — è uno dei buchi che deve riempire (le nostre
  celle vive sono quasi tutte long-only, R52). Due manopole separate sarebbero
  **l'invito a tarare l'hammer diversamente dalla shooting star**, cioè a
  fabbricare un'asimmetria dal backtest. **Meno manopole, e la simmetria non è
  più violabile per distrazione.**
- ⚠️ **Chi volesse la fedeltà pura su questo punto non può averla senza toccare
  il codice.** È l'unico punto in cui ho tolto un grado di libertà all'autore, e
  lo dichiaro qui.

### 4.4 🔴 IL PAVIMENTO DELLO STOP: l'autore NON allarga lo stop
```pine
longRisk = math.max(longEntry - longStopStored, atr * stopATR)
longQty  = math.floor((strategy.equity * riskPerc) / longRisk)
longTargetStored := longEntry + (longRisk * takeProfitRiskMultiplier)
strategy.exit("Long Exit", stop = longStopStored - spreadPoints, ...)  // <-- stop NON toccato
```
- **Fatto:** il pavimento `0,2·ATR` entra **solo** nel calcolo di `longRisk`,
  che governa **il lotto** e **il target**. Lo **stop resta all'estremo
  strutturale**.
- **Conseguenza, che è controintuitiva e va scritta:** quando lo stop
  strutturale è **più stretto** del pavimento, il lotto è calcolato su una
  distanza **maggiore** di quella vera → **la perdita realizzata è MINORE del
  rischio dichiarato**, e l'RR effettivo è **migliore** di `InpTpR`. È
  **conservativo**, ma significa che _"rischio 1%"_ su quei trade **non è vero**:
  è meno.
- **Cosa ho fatto:** `InpSlFloorMode` con **default `VR_FLOOR_AUTORE`**
  (semantica del Pine, sopra) e alternativa **`VR_FLOOR_ALLARGA`** (convenzione
  di casa: lo stop **si sposta** fino al pavimento, rischio realizzato =
  rischio dichiarato, RR = `InpTpR`).
- **Perché non ho messo `ALLARGA` come default:** sarebbe stata una nostra
  variante spacciata per porting. **La misura decide, non io.** ⚠️ È una gamba
  dell'ablazione (§6), e in `ManageAll()` il parziale scatta sull'**R vero della
  posizione** (apertura → stop), non sull'R col pavimento: nel modo AUTORE i due
  numeri possono differire. **Dichiarato perché regga fra un mese.**

### 4.5 🔴 "Annullato dopo 2 barre" — il numero fedele è **3**
```pine
if not na(longSignalBar) and bar_index - longSignalBar > 2
    strategy.cancel("Long")
```
- **Il conto, barra per barra:** segnale alla barra `t` (l'ordine è attivo da
  `t+1`). A `t+1` la differenza è 1 → resta; a `t+2` è 2 → resta; a `t+3` è 3
  → si cancella, **ma a fine barra**, quindi durante `t+3` l'ordine poteva
  ancora riempire. 👉 **L'ordine vive TRE barre, non due.**
- **Il dossier e la bozza dicono "annullato dopo 2 barre"**: è la lettura
  naturale del `> 2`, ed è **imprecisa di una barra**. Lo correggo qui invece di
  ereditarlo.
- **Nostro:** `InpOrderLifeBars = 3`, con cancellazione **a mano** sul conto
  delle barre passate da `ORDER_TIME_SETUP`. ⚠️ **Non uso
  `ORDER_TIME_SPECIFIED`**: non tutti i broker accettano la scadenza sui
  pendenti, e un ordine che il broker si rifiuta di far scadere è un ordine che
  resta vivo per sempre. Il conto sul `TIME_SETUP` **sopravvive anche a un
  riavvio dell'EA**.

### 4.6 L'ancoraggio della sessione: cambio giorno **SERVER**
- **Autore:** `ta.change(time("D"))` = cambio giorno nel fuso **dell'exchange**.
- **Nostro:** cambio giorno **del server** (BCM = ora italiana −1), via
  `SessionStamp_Calc()`.
- ⚠️ **Su un CFD indice questo non è un dettaglio.** Se il simbolo quota quasi
  24h, la VWAP ancorata a mezzanotte server **include tutta la sessione
  notturna**, che è sottile e può sporcare σ. Per Dow e Nasdaq la sessione cash
  (14:30-21:00 server) **cade tutta dentro una giornata server**, quindi il
  problema è il *pre/after market* incluso, non uno spezzamento.
- **Cosa ho fatto:** `InpSessionStartHour` (default **−1 = autore**). Con un
  valore ≥ 0 la VWAP si ancora a quell'**ora SERVER** — es. `8` per il DAX, `14`
  per Dow/Nasdaq. **[GAMBA DA MISURARE]**, non un default nascosto.

### 4.7 `InpMinSessionBars` — la banda inerte a inizio seduta
- **Autore:** nessun minimo. Come spiegato al §2, nelle prime barre σ è
  minuscola e **la banda quasi non filtra**.
- **Nostro:** `InpMinSessionBars = 0` (= autore). Se >0, nessun segnale finché
  la sessione non ha almeno quel numero di barre.
- **Perché è una gamba seria e non una rifinitura:** se una fetta grossa dei
  trade nasce nelle prime 3-4 barre della seduta, **il motore non sta facendo
  quello che la tesi dice** (fade di un allontanamento *statisticamente*
  misurato) ma un banale fade d'apertura — e il **fade d'apertura in casa è già
  morto** (R42: 0/24 + 0/24). 👉 **Il PASSO 0 deve stampare la distribuzione
  oraria dei trade.**

### 4.8 🔴 CAP GIORNALIERO — scostamento per REGOLA DI CASA, non per misura
- **Autore:** nessun cap.
- **Nostro:** `InpMaxTradesPerDay = 2` (valore già pinnato dalla bozza).
- **Motivo:** criterio **C6** del dossier: _"ogni promosso deve avere un cap di
  operazioni al giorno fra i suoi input"_ (`METRO_PROP`: −5.000 € su 100k butta
  fuori anche col totale intatto). E per un motore **controtendenza** il rischio
  è specifico: **in un trend forte incassa serie di stop**, ed è proprio la
  forma che il **DD trailing** di alcune prop punisce.
- **Dettaglio implementativo che cambia il conteggio:** il cap conta gli
  ingressi **ESEGUITI**, non i pendenti piazzati. Con un ordine che può scadere
  senza riempire, contare i piazzamenti significherebbe **bruciare il cap con
  ordini mai diventati rischio**.
- ⚠️ Chi vuole la fedeltà pura mette `InpMaxTradesPerDay = 0` e **lo dichiara**.

### 4.9 Solo il ramo "Stop": il ramo "limit" non si traduce
- **Autore:** `entryType` ha due rami. Il default è **"Close of Confirmation"**,
  che usa `strategy.entry(..., limit = close + buffer + spread)` — cioè un
  **limit su un livello PEGGIORATIVO**.
- **Perché non si porta:** in Pine un `limit` oltre il prezzo riempie subito; in
  MT5 un **BUY LIMIT sopra il mercato non riempie MAI**. È una **trappola di
  traduzione, non un difetto dell'autore** (giudizio già scritto nella scheda
  P1).
- **Nostro:** si implementa **solo il ramo `"Stop"`** (BUY STOP sopra il massimo
  della barra di conferma), che è ciò che l'autore intende.
- ⚠️ **Conseguenza sui conteggi:** il default d'autore su TradingView è l'ALTRO
  ramo. **Il nostro porting non riprodurrà i numeri che l'autore mostra**, e non
  perché sia sbagliato: perché quel ramo, in MT5, non esiste.

### 4.10 Volume = TICK VOLUME
- **Autore:** `volume` del feed TradingView (su un future = volume vero).
- **Nostro:** `tick_volume` da `CopyRates` — sugli indici CFD di BCM
  `SYMBOL_VOLUME_REAL` non è garantito, **il tick volume è quello che c'è**.
  Stessa convenzione di `VwapBias()` in `ABTG_DAX_Apertura_EU` (righe
  1626-1647), che è la funzione di casa da cui parte questo porting.
- ⚠️ **[INCERTO, da misurare]**: se BCM esponesse il volume reale su
  D30EUR/U30USD/NASUSD, la misura andrebbe rifatta. **Non è un dettaglio: la
  VWAP e la σ sono pesate su quel numero, cioè il motore intero.** Guardia
  minore: una barra con `tick_volume = 0` riceve peso 1 invece di 0 (evita la
  divisione per zero; caso praticamente inesistente).

### 4.11 La σ a due passate — **identica**, non uno scostamento
- **Autore:** `variance = cumPV2/cumVol − vwap²`.
- **Nostro:** `Σw(x−vwap)²/Σw` in una seconda passata.
- **Sono la stessa varianza di popolazione pesata**, algebricamente. Uso la
  seconda perché la prima, su un indice a 24.000, **sottrae due numeri
  dell'ordine di 5,8·10⁸ per ottenerne uno dell'ordine di 10²**. Non cambia il
  comportamento: toglie la cancellazione numerica. **Il `max(variance, 0)`
  dell'autore l'ho tenuto comunque.**

### 4.12 Le due condizioni ridondanti dell'autore
`useVWAPFilter` e `useMeanReversion` applicano **la stessa identica condizione**
(`priceAboveUpper` / `priceBelowLower`), entrambe `true` di default: nel Pine
sono due `and` con lo stesso booleano. **Implementata una volta sola.** Nessun
effetto sul comportamento, solo un input in meno.

### 4.13 Traduzioni tecniche obbligate (non sono scelte)
- `strategy.entry(stop=)` a chiusura barra → **ordine BUY/SELL STOP piazzato
  all'apertura della barra successiva** (equivalente MT5).
- `strategy.exit(stop=, limit=)` → **SL e TP veri sul server**, allegati
  all'ordine pendente.
- **Rispetto di `SYMBOL_TRADE_STOPS_LEVEL`**: se il livello d'ingresso è già
  raggiunto o cade dentro la distanza minima, **il trade non parte**; se lo SL
  è troppo vicino al livello d'ingresso, **non parte**; se il TP cade dentro,
  il TP viene **tolto** e la posizione resta alla gestione. ⚠️ **Questo può
  togliere trade che TradingView mostra** — e qui morde più del solito, perché
  lo stop nasce a **un buffer di 0,01·ATR** dal minimo di una barra.
- **Normalizzazione al tick** (`SYMBOL_TRADE_TICK_SIZE`) e **vincoli di volume**
  (min/max/step) — assenti in Pine, obbligatori qui.
- **Nessuna ipotesi forex nel sizing:** distanza in **prezzo**, perdita per
  lotto da `OrderCalcProfit` (lezione 08/08/2026 su 225JPY), tick value solo
  come ripiego. Le soglie "in punti" degli input sono **punti MT5** (`_Point`):
  su U30USD e NASUSD **1 punto indice = 100 punti MT5** (misura R97).
- **`enableCloseOpposite`**: il fronte opposto chiude la posizione **anche se
  quel lato è spento in ingresso** (`InpAllowLong`/`InpAllowShort` filtrano
  l'INGRESSO, non l'USCITA). In live la chiusura potrebbe non riflettersi
  istantaneamente: in quel caso l'ingresso opposto **salta quella barra**
  invece di aprirsi con la vecchia posizione ancora viva. Scelta prudente.

### 4.14 Cosa NON ho portato del Pine
I `plot`/`plotshape` (grafica pura), `initial_capital` (roba del simulatore
TradingView) e il blocco di **P/L "spread-adjusted" a schermo** (righe 226-237:
`lastLongPL`/`cumLongPL` — sono variabili di visualizzazione, non toccano
nessuna decisione; in MT5 il P/L lo dà il terminale).

---

## 5. 🎯 DOVE DEVE GIRARE, E QUANTO DOVREBBE SPARARE

**Simboli:** `D30EUR`, `U30USD`, `NASUSD` (BCM, conto HEDGING).
**TF primario: M15.** Storico BCM sugli indici: dal **2024.09.26** (misurato,
`REFERTO_SONDA_STORICO_17-08.md`, stato COMPLETO = il broker non ha altro)
≈ **450 sedute**.

> 📐 **M30 È UNA VIA DI PROVA LEGITTIMA, e va detto perché.** Il tester ha un
> tetto di **~100.000 barre per corsa**: a **M30 copre ~8 anni**, a **M15 ~4**,
> a **M5 ~1,3**. Sugli indici BCM il tetto non morde (lo storico è di 21 mesi),
> **ma morderebbe eccome su un simbolo con storico lungo** — ed è la strada se
> un giorno si volesse una **prova di regime** (Emendamento §C) su un indice
> con dati veri dal 2010. Su M30 la frequenza cala di ~metà rispetto a M15:
> **è un compromesso fra campione e profondità, e va dichiarato quale dei due
> si sta comprando.**
> ⚠️ **M5 è la direzione opposta** (frequenza ×3, campione più grosso) ma è
> anche dove **il capitolo breakout M5 è morto** e dove l'OHLC inganna di più:
> se ci si va, **solo a tick reali e in tranche**.

### 📊 Frequenza — ⚠️ **STIME, NON MISURE**

| | valore | rango |
|---|---|---|
| trade/giorno per indice, M15 | **0,5-2** | 🔶 **STIMA** della scheda P1, non misurata da noi |
| operazioni totali attese, M15, 450 sedute, un indice | **~225-900** | 🔶 **STIMA derivata** |
| di cui in IS (split 40/60) | **~90-360** | 🔶 **STIMA derivata** |
| il collo di bottiglia | la **contemporaneità** di: fuori banda + estremo di 20 barre + candela di rifiuto + barra di conferma | 🔶 **INFERENZA** dalla lettura del sorgente: è un setup **selettivo**, non uno scalping |
| ⚠️ moltiplicatore che le stime NON contengono | l'ordine **pendente può scadere senza riempire** | 🔶 i "segnali" non sono "trade": **il PASSO 0 deve contare tutti e due i numeri** |

👉 **La riga scomoda, e sta già nel dossier:** se i trade/giorno sono davvero
**0,5**, l'IS finisce **sotto la soglia dei 150** dell'Emendamento §A. **Il
PASSO 0 non è opzionale: prima si CONTANO le operazioni, poi si giudica.**

### 💰 Cancello C1 (il costo è il criterio) — anch'esso STIMA
| | stima |
|---|---|
| SL (range della candela di conferma + buffer, pavimento 0,2·ATR) | **~12-25 punti indice** 🔶 |
| TP a 2R | **~25-50 punti indice** 🔶 |
| spread BCM indici | **1-2 punti indice** ⚠️ **[INCERTO]** (`R98_CRITERI.md`, non è una misura nostra ripetibile) |
| take medio / spread | **~12-25×** → ✅ **PASSA C1** con margine larghissimo |

⚠️ **Il PASSO 0 del round misura il lordo medio per operazione in punti indice
PRIMA di leggere qualunque profit factor.** È il cancello S0 che ha bocciato R98
in una riga (lordo medio **−0,31 punti** su 410 operazioni). E **lo spread medio
di BCM su D30EUR in M15 NON è misurato in casa**: finché non lo si misura con
uno script sul simbolo, **S0 va dichiarato non-adjudicabile, non stimato**.

---

## 6. 🧪 COSA MISURARE, E IN CHE ORDINE (per il round, che non è questo file)

**Una gamba alla volta, tutto il resto pinnato.** La cella base è **AUTORE**:
`SigmaMult=1.0`, `SessionStartHour=-1`, `MinSessionBars=0`, `AtrPeriod=10`,
`SlFloorMode=AUTORE`, `SlUseSetupBar=off`, `UsePartial=off`, `TrailAtr=off`,
`SpreadExtraPts=0`, `EngulfingOnly=off`, `HourFilter=off`, `OrderLifeBars=3`.

0. **PASSO 0 — CONTARE.** Segnali, **pendenti scaduti senza riempire**, trade
   eseguiti, trade/giorno, **distribuzione ORARIA** (§4.7!), lordo medio in
   punti indice, distribuzione di R. **Prima di qualunque PF.**
1. **I LATI SEPARATI** (`InpAllowLong` / `InpAllowShort`, mai insieme al primo
   colpo): lezione R52, e la **simmetria vera** è uno dei buchi che questo
   candidato deve riempire.
2. **`InpSigmaMult`** (1,0 / 1,5 / 2,0) — è la manopola del motore, la sola che
   cambia *quanto lontano* deve essere il prezzo.
3. **`InpMinSessionBars`** (§4.7) — l'ipotesi più insidiosa del porting: se il
   motore vive nelle prime barre della seduta, **non è il motore della tesi**.
4. **`InpAtrPeriod` 10 vs 960** (§4.1) — intenzione dell'autore contro lettera
   del suo codice. **Non è una taratura, è una domanda di traduzione.**
5. **`InpSlFloorMode`** AUTORE vs ALLARGA (§4.4) e **`InpSlUseSetupBar`**.
6. **`InpSessionStartHour`** (§4.6) e **`InpUseHourFilter` 10-16** (la fascia
   bersaglio del dossier).
7. **Gestione:** parziale 1R + BE (`InpUsePartial`), poi trailing.
8. ❌ **La geometria della candela NON si tocca nella prima griglia**
   (`InpBodyPctMax`, `InpWickMult`, `InpDojiBodyPct`, `InpClosePct`): §3.

**Selezione della cella: CENTRO DELL'ALTOPIANO, MAI IL PICCO** — e la regola di
selezione si dichiara insieme al numero, altrimenti il numero non vuol dire
niente (Emendamento §A).

**Cancello S5 (coerenza fra simboli):** se il segno del PF è **opposto** fra
D30EUR e U30USD, **non c'è candidato**. È esattamente il cancello che ha ucciso
il gradino 07 di R101, **e vale anche quando fa comodo il contrario.**

---

## 7. 🚨 I RISCHI — dichiarati PRIMA dei numeri

1. 🔴 **OHLC 1-min SU M15 INGANNA — validazione SOLO A TICK REALI.**
   Misurato in casa: **+129k finti sul DAX** (`REGISTRO_TEST.md` §2). Qui morde
   **più del solito, e per due motivi cumulati**: (a) l'ingresso è un **ordine
   STOP** su un livello a un buffer di `0,01·ATR` dal massimo di una barra, e in
   OHLC il simulatore **non sa in che ordine** il prezzo ha visitato high e low;
   (b) lo **stop sta a un buffer dal minimo della stessa barra**, quindi
   **ingresso e stop dello stesso trade sono decisi da un'ipotesi**.
   👉 **Lo screening OHLC vale per CONTARE i segnali e leggere la frequenza.
   MAI per il segno.**
2. 🔴 **n < 150 → VALVOLA R59.** Se le operazioni IS sono meno di 150
   (Emendamento §A), il round **misura il RISCHIO** (drawdown, peggior giornata:
   fatti accaduti, validi a qualunque n) e **sospende il giudizio sul MERITO**.
   **È un esito legittimo del round, non un guasto.** Su questo candidato è
   l'esito **più probabile dei due** (§5).
3. 🔴 **UN SOLO REGIME.** Lo storico BCM sugli indici parte dal **2024.09.26**:
   ~**21 mesi**, prevalentemente **rialzisti**. Un motore **mean-reverting e
   simmetrico** in un toro incassa gli short e viene salvato dai long: **il
   numero aggregato può nascondere due motori con destini opposti.** È un altro
   motivo per cui il punto 1 del §6 (lati separati) **non è negoziabile**.
   Non abbiamo la **prova di regime** (Emendamento §C) su questi simboli.
4. 🟠 **LA FASCIA 10:00-16:00 NON SI SOVRAPPONE A NESSUNA SEDIA VIVA — e questo
   è il pregio, ma va DIMOSTRATO, non assunto.** Le distanze dichiarate:
   - **`ABTG_DAX_Apertura_EU` (D30EUR)** — entra **alla campanella** (08:00
     server), in **direzione**, su **geometria di rottura/retest** del range
     d'apertura. Distanze: **orario** (lei apre, noi entriamo dopo), **verso**
     (lei con il movimento, noi contro), **livello** (lei un box, noi una banda
     statistica). ⚠️ **Sovrapposizione residua**: se un segnale VWAPREVERT nasce
     alle 10:00 su un DAX ancora dentro l'estensione dell'apertura, **le due
     sedie possono essere aperte insieme sullo stesso simbolo, in verso
     opposto**. Non è hedging (magic diversi, EA diversi), **è rischio che si
     annulla pagando due spread**. Da contare nel round, non da scoprire dopo.
   - **`ABTG_EMA200` (U30USD)** — filtro di trend di **lungo**, rottura
     **in direzione**. Distanza netta di **verso** e di **orizzonte**.
   - **le sedie H1/H4 e notturne** — TF e fascia diversi: distanza netta.
   - 👉 **Il conto vero è la CORRELAZIONE DEI RENDIMENTI GIORNALIERI**, non
     l'orario sulla carta. Si misura con `dd_portafoglio.py` sui CSV per-trade
     (l'EA li esporta già), **dopo** che il round ha prodotto dei trade.
5. 🟠 **CORRELAZIONE FRA I TRE INDICI.** DAX, Dow e Nasdaq escono dalla banda
   **insieme**. Il cap giornaliero è un tampone **per sedia**, **non** un cap di
   famiglia: serve un limite di posizioni aperte contemporanee sull'intera
   famiglia prima di qualunque discorso prop.
6. 🟠 **STOP MOLTO STRETTO → LOTTO GRANDE.** Il buffer di default è
   `0,01 × ATR`: **un centesimo di ATR**. Lo stop nasce a ridosso del minimo
   della candela di conferma. Il pavimento c'è (`0,2·ATR`) ma nel modo AUTORE
   **non allarga lo stop, riduce il lotto** (§4.4). ⚠️ **Il PASSO 0 deve
   guardare la distribuzione di R in punti indice** e dire se il modo `ALLARGA`
   va acceso: R55 misura **1,5 punti indice di slippage che sfondavano il 10%**
   sull'ORB.
7. 🟠 **TICK VOLUME ≠ VOLUME.** §4.10. È il dato su cui poggiano VWAP e σ, cioè
   il motore intero.
8. 🟠 **IL PORTING NON RIPRODURRÀ I NUMERI DELL'AUTORE, E LO SO IN ANTICIPO.**
   Tre motivi già identificati: il ramo d'ingresso di default è diverso (§4.9),
   l'ATR è diverso (§4.1), lo spread è modellato dal simulatore invece che a
   mano (§4.2). **Non è un difetto da correggere: è la dichiarazione che
   "confronto col TradingView" non è un controllo valido su questo file.**
9. 🟠 **BROKER SINGOLO, COSTI SINGOLI.** Tutto misurato su BCM, con lo spread di
   BCM. Non è una proprietà del mercato.
10. ⚪ **PINE → MQL5 NON È UN PORTING, È UNA RISCRITTURA** (mandato §3D). I
    numeri che l'autore mostra su TradingView sono **una sola sequenza, senza
    costi**: **nessun numero d'autore è stato usato in questo documento**, e
    nessuno deve entrare nel referto del round.

---

## 8. 👀 DOVE GUARDA PER PRIMO UN REVISORE

Se hai dieci minuti e vuoi trovare l'errore, guarda **in quest'ordine**:

1. **`CalcVwapBanda()`** — il ciclo parte da `shiftFine` (che è **sempre ≥ 1**)
   e va **indietro** fino al cambio di `SessionStamp_Calc`. **La barra 0, in
   formazione, non entra MAI.** Se qualcuno la fa partire da 0, la VWAP
   ridipinge e da lì in poi ogni backtest è finto. È la stessa guardia che
   `VwapBias()` di `ABTG_DAX_Apertura_EU` ha con `i = 1`.
2. **Gli indici delle due barre** — **setup = [2]**, **conferma = [1]**. In
   `ValutaSegnale()`: `sC = shiftConferma`, `sS = shiftConferma+1`. Se qualcuno
   li scambia, il motore entra **prima** della conferma, che è look-ahead.
3. **`SegnaleLato_Calc()`** — che le condizioni siano davvero in **AND** e che
   `FuoriBanda_Calc` **non** abbia un `return(true)` di cortesia quando σ = 0.
   È il punto in cui il motore potrebbe silenziosamente diventare un altro
   motore (un pattern-trader di hammer senza VWAP).
4. **§4.1, l'ATR** — è lo scostamento più grosso del porting. Se i conteggi non
   tornano con TradingView, **il primo sospetto è qui** (10 contro 960).
5. **§4.4, il pavimento** — nel modo AUTORE **lo stop non si allarga**. Chi
   legge `InpRiskPercent = 1.0` e assume che ogni perdita valga l'1% **sta
   sbagliando**: su quei trade vale meno.
6. **`PiazzaOrdine()`** — ordine delle verifiche: R>0 → normalizzazione →
   `stops level` sul **livello d'ingresso** → `stops level` sullo **SL** →
   filtro spread/SL → TP → lotto → **Guardian** → cancella i vecchi pendenti →
   invio. Il Guardian sta **immediatamente prima dell'invio**, così l'unico
   effetto è che l'ordine non parte.
7. **`CancellaOrdiniScaduti()`** — il conto delle barre si fa su
   `ORDER_TIME_SETUP`, **non** su una variabile globale: dev'essere corretto
   anche dopo un riavvio. E la soglia è `>= InpOrderLifeBars` con default **3**,
   non 2 (§4.5).
8. **`LotByRisk()`** — che la distanza sia in **prezzo** e la perdita per lotto
   venga da `OrderCalcProfit`. Qualunque conversione in "pip" qui è un bug su un
   indice.
9. **`AggiornaContatoreTrade()`** — conta i **ticket nuovi**, quindi gli
   ingressi **eseguiti**. Un parziale non cambia il ticket → non conta due
   volte. Se qualcuno lo sposta dentro `PiazzaOrdine`, il cap comincia a
   contare ordini mai riempiti.
10. **Gli orari** — `OraOK()` legge `iTime(...,1)`, cioè l'**ora SERVER** della
    barra di conferma. **Ora italiana −1.** E i log di MT5 sono in ora **locale
    del PC**: non confrontarli col grafico (lezione 06/08).
11. **L'AUTOTEST** — 9 blocchi sul nucleo puro (VWAP/σ, banda, candele,
    chiusura, engulfing/continuazione, anti-candelone, segnale completo,
    pavimento nelle due semantiche, sessione+orario). Si legge **ESEGUENDO** un
    test singolo nel tester, **non compilando**. Se stampa `DIVERGE`, i
    risultati non si usano.

---

## 9. 📌 DIVERGENZE DALLA BOZZA DEL CACCIATORE (dichiarate)

`backtest_pipeline/prove/VWAPREVERT_DAX_M15_BOZZA.txt` è stato scritto **prima**
che l'EA esistesse. I nomi degli input che pinna sono stati **rispettati** dove
c'erano; tre cose divergono e **la bozza è stata aggiornata di conseguenza**:

| bozza | EA | perché |
|---|---|---|
| `InpTpR`, `InpSlAtrFloor`, `InpSigmaMult`, `InpLookback`, `InpAtrMult`, `InpRiskPercent`, `InpMaxTradesPerDay`, `InpPartialR`, `InpBreakEven` | **identici** | i nomi del cacciatore sono buoni: adottati così com'erano |
| `InpUsePartial=1` (acceso nel pin) | esiste, **default `false`** | il default resta **dell'autore** (nessun parziale). La bozza può accenderlo, ma **quella cella non è la cella AUTORE** e va dichiarato |
| _"ordine STOP annullato dopo **2** barre"_ | `InpOrderLifeBars = **3**` | §4.5: il `> 2` del Pine lascia l'ordine vivo **tre** barre. La bozza ereditava un conteggio impreciso |
| — | **`InpAtrPeriod`** (nuovo, §4.1) | la bozza non prevedeva che l'ATR dell'autore fosse ambiguo. È una gamba da misurare, non una taratura |
| — | **`InpMinSessionBars`**, **`InpSessionStartHour`**, **`InpSlFloorMode`**, **`InpSlUseSetupBar`**, **`InpSpreadExtraPts`**, **`InpMaxSpreadPctSL`** (nuovi, spenti) | gambe di ablazione emerse leggendo il Pine riga per riga |

---

## 10. ⚠️ LE DUE RIGHE CHE VALGONO PIÙ DI TUTTO IL RESTO

> **Questo file NON dice che la strategia funziona.** Dice cosa fa il codice,
> dove si scosta dall'autore e perché, e quali sono i rischi. **Il giudizio
> arriva dal round, a tick reali, con i criteri congelati prima dei numeri.**

> **NON va in forward.** Un backtest profittevole non è una promessa: broker
> singolo, un solo regime, ~21 mesi di storico, e un motore controtendenza in un
> mercato che è salito. **E non è compilato**: chi lo scrive non ha MetaEditor,
> la prima compilazione è il primo controllo vero.

---

*Documento della caccia M5/M15 indici del 25/08/2026 — candidato P1.
EA: `mql5/Experts/ABTG_VwapRevert.mq5`, magic 773400.
Attribuzione: sumbloke077, TradingView `YBqnzqDK`.*
