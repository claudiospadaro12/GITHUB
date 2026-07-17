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

> ⚠️ `InpBufferPoints` e `InpGapMinPoints` sono in **punti**, che dipendono dallo strumento.
> Sugli indici un "punto indice" può valere 1, 10 o 100 punti a seconda del broker: tara
> questi valori sul tuo simbolo.

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
- Il calendario news (ForexFactory) **non** è integrato: evita manualmente le fasce dei
  dati ad alto impatto, oppure usa `InpCloseHour` per non restare esposto.
- Il **Multipivot / %Custom** proprietario è approssimato con R-multipli e numeri tondi.

Se vuoi, posso aggiungere: filtro news via file, livelli a numero tondo come TP,
o versioni separate "solo breakout" / "solo gap fill".
