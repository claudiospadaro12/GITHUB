# CLASSIFICA EA per PROFIT FACTOR — BCM 50503392

Classifica di tutti gli EA per Profit Factor. La colonna **PF backtest** e' fissa
(real-tick 26.07.26). Le colonne **PF forward** si aggiornano man mano, dal CSV
di `ABTG_TradeExporter` (vedi TRACKING_FORWARD.md).

_Ultimo aggiornamento backtest: 26.07.26. Forward: — (in attesa primo CSV)._

---

## 🟢 OTTIMIZZATI (14) — validati real-tick

| # | EA | Strumento | TF | Magic | PF backtest | DD% bt | PF fwd | trade fwd | note fwd |
|---|---|---|---|---|---|---|---|---|---|
| 1 | SupertrendReversal_Multi_Ottimizzato | Oro XAUUSD | H4 | 971001 | 3.17 | basso | | | |
| 2 | SupRev_DOW_H4_Ottimizzato | Dow U30USD | H4 | 970914 | 2.77 | 4.0 | | | |
| 3 | SupertrendReversal_Ottimizzato | Oro XAUUSD | H4 | 970901 | 2.74 | basso | | | |
| 4 | MaxMinNotte_DAX_Short_Ottimizzato | DAX D30EUR | M15 | 770411 | 2.05 | 3.1 | | | |
| 5 | SupRev_DAX_H4_Ottimizzato | DAX D30EUR | H4 | 970912 | 1.96 | 5.7 | | | |
| 6 | EMA200_Ottimizzato | Oro XAUUSD | H4 | 971501 | 1.92 | basso | | | |
| 7 | SupRev_CAC_H4_Ottimizzato | CAC F40EUR | H4 | 970915 | 1.79 | 3.5 | | | |
| 8 | GoldenCross_Ottimizzato | Oro XAUUSD | H1 | 970301 | 1.58 | basso | | | |
| 9 | SupRev_NAS_H1_Ottimizzato | Nasdaq NASUSD | H1 | 970913 | 1.57 | 1.2 | | | |
| 10 | SuperWave_DOW_H1_Ottimizzato | Dow U30USD | H1 | 770511 | 1.52 | 4.0 | | | |
| 11 | DAX_Apertura_EU_Ottimizzato | DAX D30EUR | M5 | 770111 | 1.49 | 3.8 | | | |
| 12 | ~~SupRev_DAX_H1_Ottimizzato~~ 🔴 **SPENTA l'11/08 con delibera di Claudio** (`REFERTO_FUORILISTA.md`: IS −240 / OOS +1.312, IS rosso → "VAI CON LO SPEGNIMENTO"); assente da censimenti .chr 23-25/08 ed Esperti VPS 25/08 22:15 _(nota 26/08)_ | DAX D30EUR | H1 | 970911 | 1.45 | 5.6 | | | niente forward: sedia spenta |
| 13 | ~~SuperWave_DAX_H4_Ottimizzato~~ 🔴 **NON IN CAMPO** (assente da censimenti .chr 23-25/08 ed Esperti VPS 25/08 22:15; fonte: `FLOTTA_ATTIVA.md` corretta il 25/08) _(nota 26/08)_ | DAX D30EUR | H4 | 770512 | 1.28 | 3.3 | | | niente forward: non in campo |
| 14 | SupRev_DOW_H1_Ottimizzato | Dow U30USD | H1 | 970916 | 1.20 | 10 | | | |

## 🔵 NATIVI con edge (≈ base degli ottimizzati oro)

| EA | Strumento | TF | PF backtest | PF fwd | trade fwd | note fwd |
|---|---|---|---|---|---|---|
| SupertrendReversal_Multi | Oro XAUUSD | H4 | ~3.17 | | | |
| SupertrendReversal | Oro XAUUSD | H4 | ~2.74 | | | |
| EMA200 | Oro XAUUSD | H4 | ~1.92 | | | |
| GoldenCross | Oro XAUUSD | H1 | ~1.58 | | | |

## 🟠 NATIVI marginali / morti (misurati)

| EA | Strumento | TF | PF backtest | Verdetto | PF fwd | note fwd |
|---|---|---|---|---|---|---|
| ORB | Nasdaq NASUSD | M5 | 1.15 | marginale | | |
| DAX_Apertura_EU (default) | DAX D30EUR | M5 | 1.03 | solo LONG rende | | |
| MaxMinNotte (default) | DAX D30EUR | M15 | ~1.0 | solo SHORT+corr rende | | |
| Nasdaq_Apertura_US | Nasdaq NASUSD | M5 | 0.91 | morto | | |
| DAX_M3 | DAX D30EUR | M3 | <1 | morto | | |
| DAX_Live5m | DAX D30EUR | M5 | <1 | morto | | |
| Nasdaq_Live5m | Nasdaq NASUSD | M5 | <1 | morto | | |
| ORB_Fibo | Nasdaq NASUSD | M5 | <1 | morto | | |
| Londra_ORB | GBPUSD | M5 | <1 | morto | | |

## ⚪ NATIVI mai backtestati (PF n/d — solo forward)

| EA | Strumento suggerito | TF | PF fwd | trade fwd | note fwd |
|---|---|---|---|---|---|
| Nightly | Valuta (EURUSD?) | M15 | | | |
| PostNews | Valuta/Indice (news) | M5 | | | |
| FiboH4_Multi | Oro/Indice | H4 | | | |
| PTE | Oro/Indice | H4 | | | |
| SupertrendInvert | Oro/Indice | H1 | | | |
| WOL | Oro/Indice | D1 | | | |

---

## NOTE
- **PF backtest** = real-tick 2024.01.01→2026.06.30, rischio 1%. Fisso.
- **PF fwd** = calcolato dai trade reali forward (demo), aggiornato ogni settimana da Claude dal CSV dell'exporter.
- Confronto chiave: se PF fwd ~ PF backtest -> l'edge tiene. Se crolla -> overfitting o cambio regime, si rivede.
- Nativi oro ≈ ottimizzati (l'ottimizzato bake-a i parametri della base).
