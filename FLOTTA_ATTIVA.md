# 🖥️ FLOTTA ATTIVA SUL VPS — mappa dai 52 screenshot (02/08/2026)

_Fonte: `EXPERT_CARICATI_SU_VPS.zip` (52 grafici). Nome EA letto in alto a destra di ogni grafico._
_Legenda stato: ✅ validato tick reali · 🟡 nativo/da verificare · ❌ scartato (backtest) · ☠️ "morto" (tenuto per osservazione) · ⚙️ utility._

## 🔎 SCOPERTE IMPORTANTI
- **`NZDCADH1` = `ABTG_TradeExporter`** ⚙️ → è l'exporter che scrive `ABTG_Trades.csv` (con **magic + commento**) in Common\Files. **Ce l'hai già attivo!** Quel CSV dà l'attribuzione per-EA perfetta: caricamelo e faccio pagelle precise al 100%.
- **`D30EURM54` = nessun nome EA visibile** ⚠️ → grafico vuoto o EA staccato. **Da verificare** (se doveva esserci un EA, non sta girando).
- **Concentrazione ORO altissima:** 12 grafici su XAUUSD (3 SupRev + 2 SupRev_Multi + 2 EMA200 + 2 GoldenCross + SupertrendInvert + PTE + WOL). Tanta roba correlata sullo stesso strumento.
- **Concentrazione DAX:** 14 grafici su D30EUR (molti intraday "morti" + aperture).

## 🟢 SQUADRA VALIDATA (i 13 del forward + Ottimizzati)
| Grafico | EA | Simbolo | TF | Stato |
|---|---|---|---|---|
| XAUUSDH4 | SupertrendReversal_Multi_Ottimizzato | Oro | H4 | ✅ TOP (PF bt 3.17) |
| XAUUSDH41 | SupertrendReversal_Ottimizzato | Oro | H4 | ✅ (770901) |
| XAUUSDH42 | EMA200_Ottimizzato | Oro | H4 | ✅ (771501) |
| XAUUSDH1 | GoldenCross_Ottimizzato | Oro | H1 | ✅ (970301) |
| XAGUSDH4 | SupertrendReversal | Argento | H4 | ✅ (770922) |
| 225JPYH4 | SupertrendReversal | Nikkei | H4 | ✅ (770924, DD 0.14%) |
| D30EURH43 | SupertrendReversal | DAX | H4 | ✅ (770923) |
| NASUSDH1 | SupRev_NAS_H1_Ottimizzato | Nasdaq | H1 | ✅ TOP (770925, DD 1.2%) |
| USDCHFH4 | GoldenCross | USDCHF | H4 | ✅ (770331) |
| USDCADH4 | GoldenCross | USDCAD | H4 | ✅ (770332) |
| NZDUSDH4 | GoldenCross | NZDUSD | H4 | ✅ (770333) |
| 200AUDH4 | EMA200 | 200AUD (ASX) | H4 | ✅ (771511) |
| AUDJPYH4 | EMA200 | AUDJPY | H4 | ✅ (771512) |
| GBPJPYH4 | EMA200 | GBPJPY | H4 | ✅ (771513) |
| SPXUSDH4 | EMA200 | S&P (SPXUSD) | H4 | ✅ (771514) |
| GBPUSDH4 | EMA200 | GBPUSD | H4 | ✅ (771515, SHORT) |

## 🟡 IN OSSERVAZIONE / DA VERIFICARE (Ottimizzati + nativi)
| Grafico | EA | Simbolo | TF | Nota |
|---|---|---|---|---|
| D30EURH1 | SupRev_DAX_H1_Ottimizzato | DAX | H1 | 🟡 (970911) |
| D30EURH4 | SupRev_DAX_H4_Ottimizzato | DAX | H4 | 🟡 marginale RT (970912) |
| D30EURH41 | SuperWave_DAX_H4_Ottimizzato | DAX | H4 | 🟡 (770512) |
| D30EURH42 | SuperWave | DAX | H4 | 🟡 nativo |
| D30EURM15 | MaxMinNotte_DAX_Short_Ottimizzato | DAX | M15 | ✅ (770411) |
| D30EURM3 | SuperWave_EA | DAX | M3 | 🟡 test M3 |
| U30USDH12 | SuperWave_DOW_H1_Ottimizzato | Dow | H1 | 🟡 (770511) |
| EURUSDM15 | MaxMinNotte | EURUSD | M15 | 🟡 edge EURUSD |
| EURUSDM152 | Nightly | EURUSD | M15 | 🟡 edge EURUSD |
| EURUSDM5 | HARSI | EURUSD | M5 | 🟡 scan da fare |
| EURJPYM54 | PostNews | EURJPY | M5 | 🟡 |
| EURUSDM54 | PostNews | EURUSD | M5 | 🟡 |
| NASUSDH14 | SupertrendReversal | Nasdaq | H1 | 🟡 nativo (vs Ott) |
| XAUUSDH12 | GoldenCross | Oro | H1 | 🟡 nativo |
| XAUUSDH14 | SupertrendInvert | Oro | H1 | 🟡 da verificare |
| XAUUSDH43 | SupertrendReversal | Oro | H4 | 🟡 nativo |
| XAUUSDH45 | SupertrendReversal_Multi | Oro | H4 | 🟡 nativo |
| XAUUSDH46 | EMA200 | Oro | H4 | 🟡 nativo |
| XAUUSDH47 | PTE | Oro | H4 | 🟡 da verificare |
| XAUUSDDaily | WOL | Oro | D1 | 🟡 da verificare |

## 🎯 APERTURE (il focus di oggi)
| Grafico | EA | Simbolo | TF | Nota |
|---|---|---|---|---|
| D30EURM5 | DAX_Apertura_EU_Ottimizzato | DAX | M5 | apertura validata (770111) — fix gestione + RETEST pronti |
| D30EURM56 | DAX_Apertura_EU | DAX | M5 | apertura nativo |
| ~~D30EURM53~~ | ~~Apertura_Marco~~ | DAX | M5 | 🛑 **RITIRATO 06/08/2026** — doppione di `DAX_Apertura_EU`: stesso trade allo stesso secondo, 2%+2% = 4% su un segnale. Il 06/08 ha prodotto −205,92 insieme al gemello. [perché](report/A1_A4_rischio_immediato.md) |
| NASUSDM5 | Nasdaq_Apertura_US_Ottimizzato | Nasdaq | M5 | apertura |
| NASUSDM52 | Nasdaq_Apertura_US | Nasdaq | M5 | apertura nativo |

## ☠️ "MORTI" tenuti per osservazione (decisione Claudio: teniamo tutto fino alla quadra del mese)
| Grafico | EA | Simbolo | TF |
|---|---|---|---|
| D30EURM51 | DAX_Live5m | DAX | M5 |
| D30EURM55 | DAX_Live5m_v2 | DAX | M5 |
| NASUSDM53 | Nasdaq_Live5m | Nasdaq | M5 |
| NASUSDM54 | ORB | Nasdaq | M5 |
| NASUSDM55 | ORB_Fibo | Nasdaq | M5 |

## ❌ SCARTATI (backtest) ma tenuti in osservazione
| Grafico | EA | Simbolo | TF | Perché scartato |
|---|---|---|---|---|
| F40EURH4 | SupRev_CAC_H4_Ottimizzato | CAC | H4 | overfit (RT 0.96) |
| U30USDH4 | SupRev_DOW_H4_Ottimizzato | Dow | H4 | illusione OHLC (RT 0.79) |
| U30USDH1 | SupRev_DOW_H1_Ottimizzato | Dow | H1 | DD 10% |

## ⚙️ UTILITY / DA VERIFICARE
| Grafico | EA | Nota |
|---|---|---|
| NZDCADH1 | **TradeExporter** | scrive ABTG_Trades.csv (magic+commento) → caricalo per pagelle perfette |
| D30EURM54 | **(nessun EA visibile)** | ⚠️ grafico vuoto / EA staccato — verificare |

---
**Totale:** 52 grafici → ~50 EA di trading attivi + 1 exporter + 1 grafico da verificare.

---

## 🆕 SEDIA NUOVA — deploy del 16/08/2026 (conto piccolo 50503392, VPS)

| Grafico | EA | Simbolo | TF | Magic | Stato |
|---|---|---|---|---|---|
| 225JPY M1 | **ABTG_GapContinuation** | Nikkei | M1 | **774101** | 🆕 forward dal 16/08, rischio 1% |
| GBPUSD H1 | **ABTG_PTE** _(candidata R78)_ | Cable | H1 | **771332** | 🆕🧪 dal 17/08 — `buffer 25 / TP2 3,0`, rischio **0,5%** · ✅ verificata 7/7 |
| GBPUSD H1 | **ABTG_PTE** _(sedia storica)_ | Cable | H1 | **771322** | ⚠️ rischio 1,0% → **0,5%** il 17/08 · ✅ verificata 7/7 |

**Prima sedia arrivata dalla caccia esterna al Code Base** (origine:
`mql5.com/en/code/75301`, Francesc Jordi Mallol Nolden — attribuzione in
testa al `.mq5`). Validata in **R65 + R66**.

**Cosa gira:** cella `gap 1,00 / OR 15 / TP_R 3`, sessione **01:00-07:30 ora
server** (cash di Tokyo), commento ordini **`GAPCONT`**.

**Numeri a tick reali** (OOS 2025.06.10 → 2026.06.30, rischio 1%):
**+8.339,62 · PF 1,398 · n=70 · DD 11,59% · peggior giornata −1,10% · zero
overnight** (max 6h10m in posizione).

### ⚠️ Le tre cose da sapere su questa sedia

1. 🔴 **Il lato SHORT perde** (−2.182 OOS): il profitto e' tutto del long.
   **NON riempie il buco n.3 degli short**, e va ricordato ogni volta che lo
   si cita. Gira simmetrico per costruzione: **non si spegne un lato
   guardando i risultati** (malattia R52).
2. 🔴 **Le perdite arrivano in gruppo**: Z-Score **−4,03 (99,74%)**, 6
   perdite consecutive misurate. Una serie storta **e' nel carattere del
   motore**, non un guasto. E le Monte Carlo del progetto assumono
   indipendenza: **su questo EA sottostimano la coda**.
3. 🟡 **La cella e' un PICCO in campione, non un altopiano** (R66): scelta
   difendibile per metodo, non per robustezza del parametro.

### 📅 Cosa aspettarsi, in tempo

**~3,7 operazioni al mese** (47 in 12,7 mesi, `InpOneTradePerDay=true`).
Quindi: **~4 mesi** per i 15 trade della regola di casa, **~8 mesi** per i
30 trade OOS-forward di `ROTTA_PROP`. **E' un passeggero, non un pilota:
entra per la fascia oraria e la scorrelazione, non per il rendimento.**

⚠️ **Richiede la build del 16/08** con la correzione a
`HasAnyPositionOnSymbol()`: la versione precedente si autozittiva quando
`SupertrendReversal 225JPY` o `GapFill 225JPY` avevano una posizione aperta.
Se il pannello dice _"Blocked: another position exists on the symbol"_ mentre
un altro EA e' in posizione, il `.ex5` e' vecchio.


---

## 🧪 IL DUELLO GBPUSD — `771322` contro `771332` (dal 17/08/2026)

**Scelta di Claudio: strada A di R78.** Invece di decidere quale banco ha
ragione, si mettono in campo tutte e due le configurazioni e si guarda.

| | magic | buffer | TP2 | rischio |
|---|---|---:|---:|---:|
| 🪑 **sedia storica** | **771322** | 5 | 2,0 | **0,5%** |
| 🧪 **candidata R78** | **771332** | **25** | **3,0** | **0,5%** |

_(TP1 0,5 / 50% e TF H1 su entrambe: cambiano SOLO buffer e target.)_

### Perche' due sedie e non un cambio

| banco | dice |
|---|---|
| **R78** — OHLC, **13 anni** (OOS 2013-2026, n 447/477) | la storica **perde** −2.125 (PF 0,972, DD 17,68%), la candidata **guadagna** +4.323 (PF 1,095, DD 9,87%) |
| **R73** — tick reali, **2 anni** (OOS 2025-2026, n 49/51) | il contrario: storica **+2.091**, candidata +1.172 |

🔴 **Non e' conciliabile coi dati che abbiamo**: i tick reali di BCM partono
dal 2024.07.05, quindi il round lungo a tick reali **non si puo' fare**.
**O la finestra lunga o il riempimento vero.** Il forward e' l'unico giudice
che li ha tutti e due.

### ⚠️ Il tocco alla sedia viva, dichiarato

**E' il primo cambio in forward dopo dodici round.** Non e' la strategia: e'
**solo il rischio, da 1,0% a 0,5%**, e per due motivi:
1. le due sedie devono avere la **stessa taglia**, altrimenti il confronto non
   vale niente;
2. **0,5 + 0,5 = 1,0**: l'esposizione totale su GBPUSD **resta quella di ieri**.

📌 **Conseguenza da ricordare**: i profitti in euro della `771322` **prima e
dopo il 17/08 non sono confrontabili fra loro**. Il contatore dei TRADE si'.

### 🔒 Le regole del duello, congelate PRIMA dei numeri

1. Si confronta **a PARI NUMERO DI TRADE, non a pari data**: la candidata opera
   di piu' (in R78: 477 contro 447).
2. **Collaudo a 10 trade per sedia, verdetto a 30.** A ~34 trade/anno fanno
   **~3,5 mesi** e **~10 mesi**.
3. Si giudica su **profitto, PF, drawdown e peggior giornata** — gli stessi
   quattro di sempre.
4. 🔴 **Fino ai 30 trade non si tocca nessuna delle due**, qualunque cosa
   facciano nel frattempo. Le due sedie condividono lo stesso segnale di
   ingresso: le prime settimane diranno poco.

### ✅✅ VERIFICA DOPPIA — screenshot **e** file `.chr`, tutto verde

**Secondo controllo (17/08 ore 21:29, `verifica_duello_pte.ps1`): letto dai
`.chr` salvati alle 21:21, quattro sedie su quattro OK.**

```
GBPUSD  magic 771322  buf  5.0  TP2 2.0  TP1 0.5  risk 0.5  'PTE GBPUSD'
GBPUSD  magic 771332  buf 25.0  TP2 3.0  TP1 0.5  risk 0.5  'PTE GBPUSD B25'
U30USD  magic 771321  buf  5.0  TP2 2.0  TP1 0.5  risk 1.0  'PTE DOW'      <- NON toccata
USDJPY  magic 771323  buf  5.0  TP2 2.0  TP1 0.5  risk 1.0  'PTE USDJPY'   <- NON toccata
-> magic DIVERSI su GBPUSD: 771322 / 771332
=== TUTTO A POSTO. Il duello e' in campo. ===
```

📌 **Le due sedie non-GBPUSD sono ancora a rischio 1,0**: la conferma che il
preset non e' finito sul grafico sbagliato. E' il controllo che gli screenshot
**non** possono dare, perche' guardano solo il pannello che hai aperto.

### ✅ Primo controllo — screenshot degli input, 17/08 21:18-21:19, 7 campi su 7

Controllata dagli screenshot degli input **prima dell'OK**, campo per campo:

| campo | `771322` storica | `771332` candidata |
|---|---|---|
| `InpTF` | **1 Hour** ✅ | **1 Hour** ✅ |
| `InpSLbufferPips` | **5.0** ✅ | **25.0** ✅ |
| `InpTP2_ATRmult` | **2.0** ✅ | **3.0** ✅ |
| `InpTP1_ATRmult` | **0.5** ✅ | **0.5** ✅ |
| `InpRiskPercent` | **0.5** ✅ | **0.5** ✅ |
| `InpMagic` | **771322** ✅ | **771332** ✅ |
| `InpComment` | `PTE GBPUSD` ✅ | `PTE GBPUSD B25` ✅ |

🔴 **I due magic sono DIVERSI**, ed e' la condizione che rende possibile il
duello: `CountPositions()` filtra per simbolo **e** magic (`ABTG_PTE.mq5:484`),
quindi le due sedie **non si bloccano a vicenda**. Con magic uguali si sarebbero
mutate a vicenda e non ce ne saremmo accorti se non dopo settimane.

✅ **E tutto il resto e' identico sulle due sedie**, come dev'essere: TMA
56/100/2,0 e 14/30/2,0, doji 10%, Heikin Ashi on, color-flip on, long **e**
short attivi, EMA200-bias off, WPR off, ATR uscita 14, `SLfromDoji` off,
TP1Pct 50, breakeven on, trailing on, max 1 posizione, filtro news off.
**Cambiano SOLO buffer e target: e' un esperimento a una variabile per parte.**
