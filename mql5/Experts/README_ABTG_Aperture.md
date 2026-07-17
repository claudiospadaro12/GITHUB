# 🕘 EA "Aperture Mercati" — DAX (Europa) & Nasdaq (USA)

Due Expert Advisor per **MetaTrader 5** che automatizzano la parte **meccanica** dei
piani di trading sulle **aperture** (Europa 09:00 e USA 15:30), tratti dai materiali
"Piano di Trading Apertura Europea/Americana" e "La Magia delle Aperture".

| File | Mercato | Logica |
|------|---------|--------|
| `ABTG_DAX_Apertura_EU.mq5` | DAX / D30EUR (apertura EU) | Breakout del range di apertura |
| `ABTG_Nasdaq_Apertura_US.mq5` | Nasdaq / NASUSD (apertura USA) | Breakout + Gap Fill opzionale |
| `Include/ABTG/ABTG_ApertureCore.mqh` | — | Motore condiviso (non si avvia da solo) |

I due EA sono **gusci sottili** sopra lo stesso motore: stessa logica, default diversi.
Funzionano anche su **oro, forex e altri indici/metalli** cambiando simbolo e orari.

---

## ⚠️ Leggi prima di tutto

- **Nessun EA garantisce profitti.** Questi automatizzano regole d'ingresso/gestione,
  ma il risultato dipende da mercato, broker, spread, slippage e parametri.
- I piani originali contengono **parti discrezionali** (lettura correlazioni "a occhio",
  indicatore proprietario **Qqin Multipivot** non pubblico). Qui sono **approssimate**
  con logica equivalente (range, ATR, R-multipli, EMA/Supertrend). Non è una copia 1:1.
- **Testa SEMPRE su conto DEMO** e nello **Strategy Tester** prima di usare denaro vero.

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
2. **Range di apertura** → registra massimo/minimo dei primi `InpRangeMinutes` (default 15).
3. **Ordini pendenti** → `BUY STOP` sopra il massimo + buffer, `SELL STOP` sotto il minimo − buffer.
4. **OCO** → quando uno parte, l'altro viene cancellato.
5. **Gestione** → al 1° obiettivo (`InpTP1_R`, default 1R) chiude una **parziale**
   (`InpTP1_ClosePct`, default 50%), porta lo **stop in pari** e attiva il **trailing** ATR.
6. **Fine sessione** (`InpCloseHour`) → cancella i pendenti e (se `InpCloseAtEnd`) chiude.

**Modalità Gap Fill** (solo `ABTG_Nasdaq_Apertura_US`, opzionale): imposta
`InpEntryMode = GAPFILL` e `InpUseGapFill = true`. Se il mercato apre in gap ≥
`InpGapMinPoints`, opera **verso la chiusura precedente** (gap up → short, gap down → long),
con **TP sulla chiusura di ieri**.

---

## 🎛️ Parametri principali

| Gruppo | Parametro | Significato |
|--------|-----------|-------------|
| Sessione | `InpSessionHour/Min` | Apertura mercato **in ora server** |
| Sessione | `InpRangeMinutes` | Durata del range di apertura (min) |
| Sessione | `InpCloseHour/Min` | Ora di flat / stop nuovi ingressi |
| Ingresso | `InpEntryMode` | `BREAKOUT` o `GAPFILL` |
| Ingresso | `InpRangeMode` | Range = apertura (`OPENING`) o finestra precedente (`PREV`) |
| Ingresso | `InpBufferPoints` | Buffer oltre il range (in punti) |
| Filtri | `InpUseEmaFilter` | Opera solo a favore delle EMA (14/200) |
| Filtri | `InpUseSupertrend` | Filtro Supertrend (mult. 2.5 come da piano) |
| Filtri | `InpUseCorrelation` + `InpCorrSymbol` | Opera solo se l'indice guida (es. `SPXUSD`) concorda |
| Rischio | `InpRiskPercent` | Rischio per trade in % (default 1%) |
| Rischio | `InpSLMode` | Stop su estremo opposto (`RANGE`) o su ATR |
| Rischio | `InpTP1_R` / `InpTP1_ClosePct` | 1° obiettivo (in R) e % da chiudere |
| Rischio | `InpUseTrailing` / `InpTrailAtrMult` | Trailing stop su ATR |
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

## ❗ Limiti noti di questa versione 1.0

- Serve **storia M1** per calcolare il range: usa dati/tick reali nel tester.
- Su conti **hedging** un whipsaw molto rapido potrebbe far scattare entrambi i pendenti
  prima dell'OCO (raro). Su conti **netting** si compensano.
- Il calendario news va **mantenuto a mano** nel CSV (nessuna connessione a internet).
- Il **Multipivot / %Custom** proprietario è approssimato con R-multipli e numeri tondi.

Possibili aggiunte future: import automatico del calendario news, livelli di Fibonacci
come obiettivi, versioni separate "solo breakout" / "solo gap fill".
