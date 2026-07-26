# REGISTRO TEST EA — DAX / Nasdaq / Oro
_Documento vivo: aggiornato ad ogni nuovo backtest. Pensato anche per condividere i parametri con Emiliano e farsi consigliare._

## Contesto fisso (per tutti i test)
- **Conto:** DEMO BCM Markets 50503392, tipo **HEDGING**. Server **BCM = ora italiana − 1** (DAX apre 08:00 server, Nasdaq 14:30 server).
- **Periodo backtest:** 01.01.2024 → 30.06.2026 (2,5 anni).
- **Deposito:** 10.000 €. **Rischio per trade:** 1% (per confronto pulito; in live si alza dopo forward).
- **Modelli:** *OHLC 1-min* = screen veloce (affidabile su H1/H4, ottimista su M5/breakout intraday). *Real tick* = verità (obbligatorio per validare).
- **Criterio ottimizzazione:** Recovery Factor.
- **Regola:** gli `_Ottimizzato` girano in parallelo agli originali (magic diversi). NIENTE hedging/martingala.

---

## 1) APERTURE (breakout apertura mercato)

| # | EA | Sym | TF/finestra | Config chiave | Modello | Risultato | Verdetto |
|---|---|---|---|---|---|---|---|
| A1 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **entrambe + Supertrend ON**, buffer 200-600, floor 200 | real tick | 3% combo pos, best PF 1.03 | 🔴 morto (config sbagliata) |
| A2 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **SOLO LONG, ST OFF**, buffer 600, floor 200 | real tick | **PF 1.49 (avg 1.25), DD 3.8%, 314 tr**, cluster 100% pos | 🟢 **KEEPER** |
| A3 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **SOLO SHORT**, ST OFF, buffer 200-600 | real tick | — | ⏳ in coda |
| A4 | Nasdaq_Apertura_US | NASUSD | candela H1 prec, ora 14:30 | **SOLO LONG**, floor 0-400, buffer 50-350 | real tick | 0% combo pos, best PF 0.91 | 🔴 morto |
| A5 | DAX + Nasdaq "stile Monza" | D30EUR/NASUSD | candela 5-min pre-apertura | **direzione ADATTIVA Supertrend D1** + filtro 17-40 pt + floor | real tick | — | ⏳ in coda |

**A2 = configurazione vincente DAX aperture (da discutere con Emiliano):**
`Ora apertura 8:00 server | Range 15 min | Buffer 600 pt (6 punti indice) | SOLO LONG | Supertrend OFF | Floor SL 200 pt | Slippage 100 pt | Rischio 1%`
→ già messa nell'EA `ABTG_DAX_Apertura_EU_Ottimizzato` (magic 770111).

---

## 2) LIVE 5 MINUTI (rottura candela pre-apertura)

| # | EA | Sym | Config | Modello | Risultato | Verdetto |
|---|---|---|---|---|---|---|
| L1 | DAX_Live5m (orig.) | D30EUR | buffer 700, entrambe | real tick | 27/27 combo NEGATIVE | 🔴 morto |
| L2 | Nasdaq_Live5m (orig.) | NASUSD | buffer 700, entrambe | real tick | 27/27 combo NEGATIVE | 🔴 morto |
| L3 | DAX_Live5m_v2 | D30EUR | +floor +slippage +direzione, 3 varianti | real tick | solo V3 (PrevWin15+ST) marginale, PF 1.04 | 🟠 in pari |

_Nota: in OHLC i Live5m davano numeri finti enormi (+129k DAX, +30k Nasdaq). In real tick: morti. Lezione: M5/breakout → OHLC inganna._

---

## 3) ORB e altri breakout indici (screen OHLC + direzione L/S)

| # | EA | Sym | Miglior config | Risultato | Verdetto |
|---|---|---|---|---|---|
| O1 | ORB | NASUSD | EntryPoints 20, TP_R 2.5, entrambe | real tick: 50% pos, best PF 1.15, DD 16%, 625 tr | 🟡 marginale |
| O2 | ORB_Fibo | NASUSD | — | OHLC 29% pos | 🔴 morto |
| O3 | DAX_M3 | D30EUR | — | OHLC 33% pos, short 0% | 🔴 morto |
| O4 | Londra_ORB | GBPUSD | — | OHLC 11% pos, DD 23% | 🔴 morto |

---

## 4) SUPERTREND REVERSAL portato su indici (screen OHLC 1-min)
_Strategia = trend + rimbalzo (NON breakout). Su oro fa PF 3.17. Ottimizza StMult / StAtrPeriod / TP_RR, rischio 1%._

| # | Sym | TF | Risultato | Verdetto |
|---|---|---|---|---|
| S1 | DAX (D30EUR) | **H1** | **66% combo pos**, best +2254 PF 1.48 (419 tr) / +1955 **PF 2.01 DD 4.0%** (239 tr), 67 combo con PF>1.2 | 🟢 **grande candidato** (da validare real tick) |
| S2 | DAX (D30EUR) | M5 | 0% pos, DD 30-37% | 🔴 morto |
| S3 | Nasdaq (NASUSD) | H4 | 43% pos ma best solo 15-19 trade | 🟡 pochi trade, inaffidabile |
| S4 | DAX (D30EUR) | H4 | — | ⏳ da rifare (ripresa) |
| S5 | Nasdaq (NASUSD) | **H1** | — | ⏳ da rifare — **il più atteso** |
| S6 | Nasdaq (NASUSD) | M5 | — | ⏳ da rifare (atteso morto) |

**S1 = miglior scoperta indici finora (da discutere con Emiliano):**
`SupertrendReversal su DAX H1 | StMult ~3.0-3.5 | StAtrPeriod ~8-9 | TP in R ~2.5-3.0 | rischio 1%` → PF 1.48-2.01, DD 4-9%, 240-420 trade/2,5 anni.

---

## 5) ORO (baseline già validati — spina dorsale)
| EA | Sym | TF | PF | Note |
|---|---|---|---|---|
| SupertrendReversal_Multi | XAUUSD | H4 | **3.17** | migliore in assoluto |
| EMA200 | XAUUSD | — | 1.92 | 100% combo pos |
| GoldenCross | XAUUSD | — | 1.58 | |
| SupertrendReversal | XAUUSD | H4 | 2.74 | |

---

## SPUNTI DALLA LIVE DI EMILIANO MONZA (17.07.26, apertura Nasdaq)
**Da usare:**
- Direzione decisa PRIMA dal trend Weekly/Daily + correlazione S&P → opera solo in quella direzione (→ test A5 stile Monza).
- Filtro ampiezza candela **17-40 punti** (sotto=whipsaw, sopra=stop troppo largo).
- Ordine a **7 punti** oltre max/min della candela 5-min pre-apertura.
- ORB: volumi in crescita alla rottura + EMA 9/21 allineate + ingresso sul **retest** se apre lontano.
- Parziale 50% a ~20 punti + stop in pari.

**Da NON usare (pericoloso):**
- Piano B/C = hedging/martingala (raddoppio contro la perdita). È ciò che gli ha causato −500k / −1,4M di drawdown. Escluso.

---

## DOMANDE PER EMILIANO (bozza)
1. Sul **DAX aperture** conviene davvero solo-LONG, o la direzione adattiva (Supertrend Daily) rende di più anche prendendo gli short nei giorni ribassisti?
2. Buffer: 7 punti fissi o proporzionale all'ATR/ampiezza candela?
3. Filtro ampiezza 17-40: valori confermati anche sul DAX o solo Nasdaq?
4. Sul **Nasdaq** l'aperture da solo non ha edge nei nostri test: quali filtri aggiuntivi usi tu (correlazione, imbalance, livelli) che possiamo automatizzare?
5. Il SupertrendReversal su **DAX H1** ci dà PF ~1.5-2.0: ha senso come "core" indici o preferisci sempre l'apertura?

---
_Ultimo aggiornamento: dopo i test aperture real-tick + SupertrendReversal indici (parziale). Mancano: A3, A5, S4/S5/S6, DAX short._
