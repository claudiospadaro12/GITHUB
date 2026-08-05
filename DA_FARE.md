# ✅ DA FARE — lista maniacale

_05/08/2026. Ogni voce ha: **cosa**, **perché lo so**, **come si chiude**._
_Aggiornare questo file a ogni chiusura. Quello che non è qui, non esiste._

---

# 🔴 A — RISCHIO IMMEDIATO (sono soldi, adesso)

### A1. `Apertura Marco` e `DAX Apertura EU` sono lo stesso EA
**Prova:** `audit_flotta.py` → **100% su 64 parametri condivisi**. E il 05/08 hanno fatto
lo stesso trade allo stesso secondo allo stesso prezzo (26.339,50 → 26.332,30, +7,20 × 2).
**Effetto:** il segnale d'apertura del DAX rischia **2% + 2% = 4%**. Con una regola prop da
−5% giornaliero, **un trade solo arriva a un passo dal limite**.
**Chiude quando:** Claudio decide se spegnere Marco, o differenziarlo davvero (buffer/ora/lato).

### A2. Tre EA sull'oro condividono il magic **250604**
**Prova:** `audit_flotta.py` → `Gold_Ichimoku_TK_ATR_EA`, `IchiCross_Gold_722`,
`IchiTrend_Gold_Base`.
**Effetto:** se **due di loro girano insieme sullo stesso simbolo**, ognuno vede le posizioni
dell'altro come proprie: le chiude, ci mette il breakeven, ci fa il trailing. Comportamento
imprevedibile.
**Chiude quando:** verificato quali sono attaccati sul VPS. Se più di uno → magic diversi.
**Priorità:** verificarlo **subito**, è una riga da guardare nel Navigatore.

### A3. In forward si rischia il 2%, i backtest sono all'1%
**Prova:** `audit_flotta.py` → 11 EA sopra l'1%. `PostNews` al **3%**, `ORB_GOLD_FIBONACCI_EA`
al **5%**.
**Effetto:** ogni drawdown che ho riportato va **moltiplicato** (×2, ×3, ×5). Il DD del DAX
al 38,96% misurato all'1% diventa un altro film al 2%.
**Chiude quando:** o si porta il forward all'1%, o si rifanno i backtest al 2%. Non a metà.

### A4. La guardia "un trade al giorno" non sopravvive al riavvio
**Prova:** codice, riga 476. Guarda solo se **adesso** c'è un ordine o una posizione. Il
05/08 alle 09:46 il riattacco degli EA ha **ripiazzato i pendenti** su una giornata già
operata (buy stop 26.440,50, ticket #3078825 e #3078827).
**Effetto:** riavviare a mercato aperto = secondo trade non previsto, e dal lato sbagliato.
**Chiude quando:** la guardia legge lo storico deal del giorno per magic, non solo lo stato.
**Nel frattempo:** riattaccare gli EA d'apertura solo **fuori** dalla loro finestra.

### A5. Il `DAX Live5m` gira a **2 lotti**, il doppio degli altri
**Prova:** trade del 05/08, −103,80 contro −52,90 del v2 sullo stesso identico segnale.
**Effetto:** l'EA col difetto strutturale più documentato (3 sweep su 3) è quello che pesa di più.

### A6. Concentrazione sull'oro: 6 short contemporanei
**Prova:** 05/08, −173,02 €. Alle 03:35:54 gli STREV vengono stoppati, **9 secondi dopo**
l'EMA200 rientra short 2 punti più in alto, poi altre 3 volte scalando contro il movimento.
**Effetto:** non sono 6 operazioni indipendenti, è **una con 6× la size**.
**Chiude quando:** esiste un tetto di esposizione per simbolo (il `Guardian` potrebbe farlo).

---

# 🟠 B — MISURE DA RIFARE (i verdetti attuali non valgono)

### B1. Rifare `aperture_trailing` sulla configurazione ACCESA
**Prova:** `AUDIT_live_vs_backtest.md`. **6 divergenze sul DAX, 9 sul Nasdaq.** Il test usava
TP 1,5R senza parziale né BE, risk 1%; gli EA veri: **TP 3R + parziale 50% + stop in pari**,
risk 2%, Nasdaq in PREVBAR H1, chiusura 21:45.
**Effetto:** *"nessuna combinazione è in profitto"* vale per la configurazione **testata**.
**Non è dimostrato** che descriva quello che gira. **Verdetto sospeso.**

### B2. Il Nasdaq in `RangeMode=2` non è mai stato testato
Gira in PREVBAR H1 dal primo giorno; **tutti** i test l'hanno misurato in OPENING.
→ coperto da `aperture_retest_fade.ps1` (job `NASDAQ_prevH1`).

### B3. Quante volte il buy stop **non è piazzabile** in PREVBAR?
**Prova:** 05/08 ore 14:30, prezzo già a 29.866 sopra il livello (29.830,50): il `BUY STOP`
è stato rifiutato dal broker e all'EA è rimasto **solo l'ordine dalla parte sbagliata**.
Nel codice non c'è nessun controllo, solo un `ABTGLog("BUY STOP fallito")`.
**Chiude quando:** misurata la frequenza. Se è alta, PREVBAR ha un difetto strutturale.

### B4. Discrepanza aperta sul filtro volumi del Nasdaq
Ablazione di inizio agosto: **PF 1,15 su 152 trade**. Test del 05/08 con volumi accesi:
**PF 0,955 su 260 trade**. Cambiano gestione e numero di trade. Da capire prima di
continuare a dare per buono quel filtro.

### B5. Il conteggio dei "trade" è gonfiato fino a 3×
`TP1Pct=50` + `TP2Pct=50` + residuo = fino a 3 chiusure per posizione, e MT5 le conta tutte.
I "393 trade" del MaxMinNotte sono forse 130-180 posizioni. **La soglia di significatività
va applicata alle posizioni.**

### B6. Lo storico dell'oro parte davvero dal 2024?
Lo studio della notte ha trovato dati M5 **solo dal 28/02/2025**, ma i backtest chiedono dal
2024.01.01. Se anche l'M1 parte nel 2025, il test copre 16 mesi e non 30 — e sono i mesi in
cui la volatilità dell'oro è **raddoppiata** (29,8 $ → 59,5 $ di ampiezza notturna mediana).

---

# 🟡 C — TEST PRONTI (script scritti, da lanciare)

| # | script | pass | domanda |
|---|---|---:|---|
| C1 | `notte_05-08.ps1` | 56 | OPENCONFIRM (grafico + M15) e geometria dell'ingresso — **in corso** |
| C2 | `goldencross_lavorenti.ps1` | 24 | su H1 bastano **due** candele HA? E le Bollinger in espansione servono? |
| C3 | `aperture_retest_fade.ps1` | 48 | RETEST e RANGE_FADE con la gestione buona (la bocciatura di luglio non vale) |
| C4 | `maxmin_oro.ps1 -Fase 2 -SLMode 0` | 12 | il MaxMinNotte sull'oro a tick reali, griglia spostata dove puntavano i gradienti |

**Ordine consigliato:** C1 (in corso) → C3 → C2 → C4. Mai due insieme: si rubano la CPU.

---

# 🔵 D — DA MISURARE, script ancora da scrivere

- **D1.** Apertura delle **02:00 sull'oro**. Lo studio dice che quell'ora fa il **47,9%**
  dell'escursione della notte, contro il 35,7% della seconda. Nessun EA ci opera.
- **D2.** ORB con la **vera finestra di 15 minuti** dopo l'apertura (contraddizione risolta
  dalle live, mai testata).
- **D3.** Aperture con `RangeMode=PREV` sull'oro.
- **D4.** Breakeven a 0,5R **con** parziale sul DAX (divergenza con le live).
- **D5.** `InpAtrSlMult` per il fade, se il fade mostra qualcosa in C3.

---

# ⚫ E — BUG NOTI, NON RISOLTI

- **E1.** Il bug del **breakeven al lotto minimo** è ancora in **10 EA** in forma diversa:
  `DAX_M3`, `FiboH4_Multi`, `GoldenCross`(+Ott), `Londra_ORB`, `MaxMinNotte`(+Ott), `ORB`,
  `ORB_Fibo`, `SupertrendInvert`. Costa soldi veri.
- **E2.** `InpConfirmMode = CONF_OR` è ancora il default sulle aperture. È l'errore che
  introdussi il 02/08: neutralizza il filtro volumi (PF 1,38 → 0,99). Innocuo finché volumi
  e ATR non sono accesi insieme — ma è una mina.
- **E3.** `InpTrailFixedPts = 410` sopravvive come default anche dove ora `TrailMode = 1`.
  Inerte, ma se qualcuno rimette il modo 2 da preset torna in gioco senza avvisare.
- **E4.** `ABTG_SupertrendReversal_Multi` **non ha** `InpFridayClose`, che il fratello ha.
- **E5.** I **661 trade non etichettati** (−18.707 €, 485 su XAUUSD, lotti 0,5-1,0, fino al
  27/07): non sappiamo ancora di chi siano.

---

# 🟣 F — DA ATTIVARE

- **F1.** `ABTG_Dow_Apertura_US` in forward su U30USD. È **l'unico** EA validato in
  walk-forward (PF 1,371 · DD 5,32% · 329 trade · 40/40 combinazioni OOS in utile) e
  **l'unico** i cui default combaciano con ciò che è stato misurato. È pronto dal 05/08.
- **F2.** Ricompilare sul VPS per attivare il trailing a base candela M5 su DAX e Marco.

---

# 🧭 G — PROCESSO (perché non ricascarci)

### G1. `audit_flotta.py` — creato il 05/08
Trova da solo: magic duplicati, gemelli comportamentali, chi rischia sopra l'1%, chi dipende
dal timeframe del grafico. **Va lanciato prima di ogni verdetto e dopo ogni modifica agli EA.**

```
python3 backtest_pipeline/audit_flotta.py
```

### G2. La regola sui verdetti
Prima di dire *"questo EA fa X"*: **estrarre i suoi default effettivi e metterli accanto a
quelli del test.** Se non combaciano, il verdetto non vale — e va detto **prima**, non dopo.

### G3. Il limite dell'audit automatico, da ricordare
`audit_flotta.py` confronta i **parametri**, non i **motori**. `ABTG_SuperWave` e
`ABTG_SupertrendReversal` hanno 36 parametri su 36 uguali tranne uno, ma il primo entra su un
**incrocio EMA 14/200** e il secondo su un **rimbalzo del Supertrend**. Il codice va letto.

### G4. Dove il timeframe del grafico conta davvero
`AtrValue()` legge `iATR(_Symbol, PERIOD_CURRENT, ...)` e il filtro volumi legge il TF del
grafico. Sulla configurazione attuale (BREAKOUT + SL_RANGE + trailing a base candela) **non
vengono chiamati**, quindi il grafico non conta. Diventano rilevanti appena si accende:
**RANGE_FADE**, stop ad ATR, trailing ad ATR, filtro volumi. Da ricordare quando C3 darà i
risultati.
