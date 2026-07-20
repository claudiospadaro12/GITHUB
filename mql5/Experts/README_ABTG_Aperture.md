# 🕘 EA "Aperture Mercati" — DAX (Europa) & Nasdaq (USA)

Due Expert Advisor per **MetaTrader 5** che automatizzano la parte **meccanica** dei
piani di trading sulle **aperture** (Europa 09:00 e USA 15:30), tratti dai materiali
"Piano di Trading Apertura Europea/Americana" e "La Magia delle Aperture".

| File | Mercato | Logica (come da piano) |
|------|---------|--------|
| `ABTG_DAX_Apertura_EU.mq5` | DAX / D30EUR (apertura EU) | Breakout del **range di apertura** (primi 15 min) |
| `ABTG_Nasdaq_Apertura_US.mq5` | Nasdaq / NASUSD (apertura USA) | Rottura **massimi/minimi candela H1 precedente** + Gap Fill |
| `ABTG_Nasdaq_Live5m.mq5` | Nasdaq / NASUSD | **Variante "live":** candela **5 min pre-apertura**, 7 punti, filtro 17-40 |
| `ABTG_DAX_Live5m.mq5` | DAX / D30EUR | **Variante "live":** candela **5 min pre-apertura**, 7 punti |
| `Include/ABTG/ABTG_ApertureCore.mqh` | — | Motore condiviso (non si avvia da solo) |

> 🔬 **Le versioni "Live5m"** servono per il **confronto A/B**: falle girare su grafici
> SEPARATI dagli EA base (hanno magic number diversi, i trade non si mescolano) e dopo
> qualche settimana confronta i risultati. Vedi la sezione *"Confronto A/B"* in fondo.

I due EA sono **gusci sottili** sopra lo stesso motore: stessa logica, default diversi.
Funzionano anche su **oro, forex e altri indici/metalli** cambiando simbolo e orari.

---

## ⚠️ Leggi prima di tutto

- **Nessun EA garantisce profitti.** Questi automatizzano regole d'ingresso/gestione,
  ma il risultato dipende da mercato, broker, spread, slippage e parametri.
- Solo l'indicatore proprietario **Qqin Multipivot / %Custom** non è pubblico: i suoi
  livelli-obiettivo sono resi con i **numeri tondi** (come indica lo stesso piano Nasdaq).
  Tutto il resto segue **alla lettera** le regole scritte (vedi sezione sotto).
- **Testa SEMPRE su conto DEMO** e nello **Strategy Tester** prima di usare denaro vero.

---

## ✅ Fedeltà ai piani (cosa è stato tradotto ESATTAMENTE)

| Regola scritta nei file | Dove | Come è implementata |
|---|---|---|
| "Ordini nel time frame **H1**: SELL STOP sotto i **minimi precedenti**, BUY STOP sopra i **massimi precedenti**" | Nasdaq, sl. 10 | `InpRangeMode = Candela precedente`, `InpLevelTF = H1` |
| "Cancello l'ordine non eseguito" | Nasdaq, sl. 11 | OCO automatico |
| "Porto lo stop sui massimi precedenti" | Nasdaq, sl. 11 | SL su estremo opposto (`InpSLMode = RANGE`) |
| "TP in divenire **dimezzando** sui livelli" + "Primo obiettivo = **numero tondo**" | Nasdaq, sl. 11-12 | Parziale 50% al numero tondo (`InpUseRoundLevels`) |
| "Lo stop lo porto **in pari**" | Nasdaq, sl. 11 | Breakeven dopo la parziale |
| "Scendo in **M1**, seguo lo stop alla **base della candela precedente**" | America, sl. 11 | `InpTrailMode = Base candela prec.`, `InpTrailTF = M1` |
| "% di perdita **massimo del 2%**" | Nasdaq, sl. 14 | `InpRiskPercent = 2.0` |
| Gap up → SELL al **break** sotto il minimo, SL sopra, **TP = chiusura prec.**, **RR ≥ 1:1.5** | PDF p.24-25 | Modalità Gap Fill con `InpGapMinRR = 1.5` |
| DAX: breakout **primi 15 minuti**; trailing indici ~**410 punti** | PDF p.8/14, DAX sl. 20 | `InpRangeMode = Apertura` (15 min), `InpTrailMode = Punti fissi (410)` |
| "Prima di un dato a **3 tori** tolgo tutto" | Nasdaq/America, Routine | Filtro news: chiude/cancella tutto nel blackout |

---

## 📥 Installazione

1. Apri MT5 → **File ▸ Apri cartella dati** (`Open Data Folder`).
2. Copia i file rispettando le cartelle:
   - `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`     → `MQL5/Experts/`
   - `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5`  → `MQL5/Experts/`
   - `mql5/Include/ABTG/ABTG_ApertureCore.mqh`   → `MQL5/Include/ABTG/`
3. In **MetaEditor** apri i due `.mq5` e premi **Compila** (F7). Devono compilare
   senza errori (l'`.mqh` viene incluso in automatico).
4. In MT5 trascina l'EA sul grafico dello strumento (es. DAX su timeframe **M15**).

---

## 🕒 IMPORTANTISSIMO: gli orari sono quelli del SERVER del broker

L'EA ragiona sugli **orari del server** (quelli che vedi sul grafico), **non** sull'ora
italiana. Il fuso del server cambia da broker a broker.

**Come impostarli bene (1 minuto):**
1. Guarda a che ora, **sul tuo grafico**, si muove davvero l'apertura del DAX (09:00 CET)
   o del Nasdaq cash (15:30 CET).
2. Metti quell'ora in `InpSessionHour` / `InpSessionMin`.

Esempi comuni (indicativi — **verifica sul tuo grafico**):

| Fuso server broker | Apertura DAX 09:00 CET → server | Apertura Nasdaq 15:30 CET → server |
|--------------------|-------------------------------|-----------------------------------|
| GMT+2 (molti broker, inverno) | 08:00 | 14:30 |
| GMT+3 (molti broker, ora legale) | 08:00 | 14:30 |
| GMT+1 | 09:00 | 15:30 |

> Regola pratica: se il grafico mostra la candela delle 09:00 CET a un'ora diversa,
> usa **quell'ora** del grafico. In caso di dubbio parti col default e correggi guardando
> il log dell'EA ("apertura server HH:MM").

---

## ⚙️ Come funziona (passo passo)

1. **Attesa apertura** → all'ora impostata parte la fase operativa.
2. **Livelli** (`InpRangeMode`) → massimo/minimo dei primi `InpRangeMinutes` (DAX) **oppure**
   della **candela H1 precedente** (Nasdaq, come da piano).
3. **Ordini pendenti** → `BUY STOP` sopra il massimo + buffer, `SELL STOP` sotto il minimo − buffer.
4. **OCO** → quando uno parte, l'altro viene cancellato.
5. **Gestione** → al 1° obiettivo (numero tondo o R) chiude una **parziale** (default **50%**),
   porta lo **stop in pari** e attiva il **trailing** (base candela M1 su Nasdaq, punti fissi su DAX).
6. **Fine sessione** (`InpCloseHour`) → cancella i pendenti e (se `InpCloseAtEnd`) chiude.

**Modalità Gap Fill** (solo `ABTG_Nasdaq_Apertura_US`, opzionale): imposta
`InpEntryMode = GAPFILL` e `InpUseGapFill = true`. Se il mercato apre in gap ≥
`InpGapMinPoints`, l'EA — come nell'esempio del PDF — **aspetta la prima finestra** di
apertura e poi mette uno **stop order al break dell'estremo iniziale verso la chiusura
precedente** (gap up → SELL sotto il minimo; gap down → BUY sopra il massimo), con
**SL oltre l'estremo opposto**, **TP = chiusura di ieri**, ed entra **solo se RR ≥ `InpGapMinRR`** (1:1.5).

---

## 🎛️ Parametri principali

| Gruppo | Parametro | Significato |
|--------|-----------|-------------|
| Sessione | `InpSessionHour/Min` | Apertura mercato **in ora server** |
| Sessione | `InpRangeMinutes` | Durata del range di apertura (min) |
| Sessione | `InpCloseHour/Min` | Ora di flat / stop nuovi ingressi |
| Ingresso | `InpEntryMode` | `BREAKOUT` o `GAPFILL` |
| Ingresso | `InpRangeMode` | `Apertura` (primi N min), `Finestra prec.`, o **`Candela prec.`** (Nasdaq: H1) |
| Ingresso | `InpLevelTF` | TF dei massimi/minimi precedenti (Nasdaq: **H1**) |
| Ingresso | `InpBufferPoints` | Buffer oltre il livello (in punti) |
| Gap Fill | `InpGapMinPoints` / `InpGapMinRR` | Gap minimo e RR minimo (PDF: 1:1.5) |
| Filtri | `InpUseEmaFilter` | Opera solo a favore delle EMA (14/200) |
| Filtri | `InpUseSupertrend` | Filtro Supertrend (mult. 2.5 come da piano) |
| Filtri | `InpUseCorrelation` + `InpCorrSymbol` | Opera solo se l'indice guida (es. `SPXUSD`) concorda |
| Rischio | `InpRiskPercent` | Rischio per trade in % (**default 2%**, come da piano) |
| Rischio | `InpSLMode` | Stop su estremo opposto (`RANGE`) o su ATR |
| Rischio | `InpTP1_R` / `InpTP1_ClosePct` | 1° obiettivo (in R) e % da chiudere (dimezzo=50%) |
| Rischio | `InpUseTrailing` / `InpTrailMode` | Trailing: **ATR**, **Base candela prec.** (M1), o **Punti fissi** (410) |
| Rischio | `InpTrailTF` / `InpTrailFixedPts` | TF candela (per base candela) / distanza fissa in punti |
| Numeri tondi | `InpUseRoundLevels` | Usa il numero tondo come 1° obiettivo |
| Numeri tondi | `InpRoundStep` | Passo della griglia (in **PREZZO**, es. 100) |
| Numeri tondi | `InpRoundMinDistPts` | Distanza minima dall'ingresso (in **punti**) |
| News | `InpUseNewsFilter` + `InpNewsFile` | Blocca il trading intorno alle news da file CSV |
| News | `InpNewsMinImpact` | Impatto minimo (3=High "3 tori") |
| News | `InpNewsBeforeMin/AfterMin` | Minuti di stop prima/dopo la news |
| News | `InpNewsFlatten` | Chiudi tutto prima della news |

> ⚠️ Unità: `InpRoundStep` è in **PREZZO**; `InpBufferPoints`, `InpGapMinPoints` e
> `InpRoundMinDistPts` sono in **punti**. Sugli indici un "punto" può valere 1, 10 o 100 a
> seconda del broker: **tara questi valori sul tuo simbolo**.
>
> **Esempio (broker BCM Markets, D30EUR/NASUSD):** Cifre=2, tick=0.10 → **1 punto indice = 100 punti**.
> Quindi buffer 300 = 3 punti indice; gap 3000 = 30 punti indice. Il Nasdaq ha inoltre
> **livello stop = 100 punti**: l'EA alza da solo il buffer sopra questa soglia per non farsi
> rifiutare gli ordini, e arrotonda tutti i prezzi al tick (0.10).

---

## 🎯 Numeri tondi come obiettivo (approssima il %Custom/Multipivot)

Il piano Nasdaq usa i **numeri tondi** (17000, 38000, …) come livelli-obiettivo. Attivando
`InpUseRoundLevels = true`, la **parziale** viene presa al **primo numero tondo** nella
direzione del trade (multiplo di `InpRoundStep`), ad almeno `InpRoundMinDistPts` di distanza.
È attivo di default nel preset Nasdaq (`InpRoundStep = 100`).

---

## 📰 Filtro news (file CSV — "prima di un dato a 3 tori tolgo tutto")

L'EA **non** si collega a internet: legge le news da un file CSV in `MQL5/Files/`.

1. Copia `mql5/Files/abtg_news.csv` in `MQL5/Files/`.
2. Attiva `InpUseNewsFilter = true` (già attivo nei preset Nasdaq).
3. Nella finestra `[news − InpNewsBeforeMin, news + InpNewsAfterMin]` l'EA **non apre**
   nuovi ordini e, se `InpNewsFlatten = true`, **cancella i pendenti e chiude** le posizioni.

**Formato del file** (separatore `;`, una riga per evento):
```
YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
2026.01.09 14:30 ; High ; USD ; Non-Farm Payrolls
```
- **Impatto**: `High`/`Medium`/`Low` oppure `3`/`2`/`1`. Con `InpNewsMinImpact = 3` filtri solo i "3 tori".
- La **prima riga di intestazione** viene ignorata automaticamente.
- **Orari**: devono essere in **ora SERVER**. Se esporti da ForexFactory in un altro fuso,
  usa `InpNewsShiftMinutes` per allinearli (es. `-60` o `+60`).
- **Valute**: con `InpNewsCurrencies = "USD"` filtri solo gli eventi USD (vuoto = tutti).

> Devi tenere aggiornato il CSV (es. incollando le news della settimana da ForexFactory).
> Il file di esempio contiene alcuni eventi 2026 come modello.

---

## 📂 File preset `.set` pronti (cartella `mql5/Presets/`)

| File | EA | Uso |
|------|----|----|
| `ABTG_DAX_Apertura_EU.set` | DAX | Breakout apertura europea |
| `ABTG_Nasdaq_Apertura_US.set` | Nasdaq | Breakout + numeri tondi + news |
| `ABTG_Nasdaq_GapFill.set` | Nasdaq | Modalità Gap Fill |

Caricali nello **Strategy Tester ▸ scheda Input ▸ Load** (oppure nella finestra parametri
dell'EA sul grafico, pulsante *Load*).

> ⚠️ I `.set` ipotizzano un broker **GMT+2/+3** (DAX apre 08:00, Nasdaq 14:30 sul server).
> **Correggi `InpSessionHour`** se il tuo broker ha un fuso diverso (vedi tabella orari sopra).

---

## 🔎 Preset consigliati (da cui partire e poi ottimizzare)

**DAX (`ABTG_DAX_Apertura_EU`)** — grafico M15:
- `InpRangeMinutes = 15`, `InpSLMode = RANGE`, `InpRiskPercent = 1.0`
- Filtri consigliati: `InpUseSupertrend = true` (mult 2.5, H1); opzionale
  `InpUseCorrelation = true`, `InpCorrSymbol = SPXUSD`.

**Nasdaq (`ABTG_Nasdaq_Apertura_US`)** — grafico M15:
- `InpRangeMinutes = 15`, `InpSLMode = RANGE`, `InpRiskPercent = 1.0`
- Gap Fill: `InpEntryMode = GAPFILL`, `InpUseGapFill = true`, `InpGapMinPoints` tarato sullo strumento.

---

## 🧪 Come testare (Strategy Tester)

1. MT5 → **Visualizza ▸ Strategy Tester** (Ctrl+R).
2. Expert: scegli l'EA. Simbolo: il tuo DAX/Nasdaq. Timeframe: **M15**.
3. Modello: **"Ogni tick basato su tick reali"** (serve la storia **M1** per il range!).
4. Periodo: almeno alcuni mesi. Deposito: coerente col conto reale.
5. Controlla nel log i messaggi `[DAX Apertura EU] ...` / `[Nasdaq Apertura US] ...`.
6. Ottimizza pochi parametri per volta (buffer, RangeMinutes, TP1_R, filtri).

---

## 🔬 Confronto A/B: versioni base vs "Live5m"

Due modi diversi di leggere l'apertura, da confrontare sul campo:

| | EA base (`_Apertura_`) | EA live (`_Live5m`) |
|---|---|---|
| Candela di riferimento | Range primi 15 min (DAX) / candela H1 prec. (Nasdaq) | **Candela 5 min PRIMA** dell'apertura |
| Buffer ordini | 3 punti indice (300) | **7 punti indice** (700) |
| Filtro ampiezza | no | **sì (Nasdaq: 17-40 punti)** |
| Origine | PowerPoint / PDF del corso | Live del 17/07/26 |

**Come si confrontano:**
1. Metti i 4 EA su **4 grafici separati** (2 DAX + 2 Nasdaq), ognuno col suo preset.
2. Hanno **magic number diversi** (770101 / 770103 / 770201 / 770203): i trade restano distinti.
3. Dopo qualche settimana di DEMO, apri **Cronologia conto** e filtra per commento/magic,
   oppure guarda i risultati nello **Strategy Tester** con lo stesso periodo per entrambi.
4. Confronta: numero operazioni, % vincenti, profitto netto, drawdown massimo.

**Nuovi parametri del filtro ampiezza** (`ABTG_ApertureCore`):
- `InpMinRangePts` — ampiezza minima candela/range in punti (0 = disattivato).
- `InpMaxRangePts` — ampiezza massima (0 = disattivato).
- Sul broker BCM: 17 punti indice = **1700**, 40 punti indice = **4000**.

> ⚠️ La live include anche un **hedging "Piano B/C"** (aggiungere size in perdita per
> recuperare). **NON è automatizzato** di proposito: è la parte che genera i grossi
> drawdown mostrati nella live stessa. Gli EA fanno OCO pulito e non mediano mai.

---

## ❗ Limiti noti di questa versione 1.0

- Serve **storia M1** per calcolare il range: usa dati/tick reali nel tester.
- Su conti **hedging** un whipsaw molto rapido potrebbe far scattare entrambi i pendenti
  prima dell'OCO (raro). Su conti **netting** si compensano.
- Il calendario news va **mantenuto a mano** nel CSV (nessuna connessione a internet).
- Il **Multipivot / %Custom** proprietario è approssimato con R-multipli e numeri tondi.

Possibili aggiunte future: import automatico del calendario news, livelli di Fibonacci
come obiettivi, versioni separate "solo breakout" / "solo gap fill".
