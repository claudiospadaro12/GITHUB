# TRACKING FORWARD DEMO — BCM 50503392

Registro dei risultati **in avanti** (demo) di tutti gli EA + trade manuali.
Confronto forward vs backtest. Rischio target: 1% per trade.

**Come si aggiorna:** sul VPS gira `ABTG_TradeExporter` su un grafico di scorta →
scrive `ABTG_Trades.csv` (Common\Files) con TUTTI i trade chiusi (auto + manuali).
Claudio carica il CSV qui → Claude parsa, calcola e compila le tabelle sotto.

---

## LEGENDA STRATEGIE (per magic)

### Ottimizzati (validati real-tick)
| Magic | EA | Strumento | TF | PF backtest | DD backtest |
|---|---|---|---|---|---|
| 971001 | SupRev_Multi_Ottimizzato | XAUUSD | H4 | 3.17 | basso |
| 970901 | SupRev_Ottimizzato | XAUUSD | H4 | 2.74 | basso |
| 971501 | EMA200_Ottimizzato | XAUUSD | H4 | 1.92 | basso |
| 970301 | GoldenCross_Ottimizzato | XAUUSD | H1 | 1.58 | basso |
| 770111 | DAX_Apertura_EU_Ottimizzato | D30EUR | M5 | 1.49 | 3.8% |
| 970911 | SupRev_DAX_H1_Ottimizzato | D30EUR | H1 | 1.45 | 5.6% |
| 970912 | SupRev_DAX_H4_Ottimizzato | D30EUR | H4 | 1.96 | 5.7% |
| 770411 | MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | M15 | 2.05 | 3.1% |
| 970913 | SupRev_NAS_H1_Ottimizzato | NASUSD | H1 | 1.57 | 1.2% |
| 970914 | SupRev_DOW_H4_Ottimizzato | U30USD | H4 | 2.77 | 4.0% |
| 970915 | SupRev_CAC_H4_Ottimizzato | F40EUR | H4 | 1.79 | 3.5% |
| 970916 | SupRev_DOW_H1_Ottimizzato | U30USD | H1 | 1.20 | 10% |
| 770511 | SuperWave_DOW_H1_Ottimizzato | U30USD | H1 | 1.52 | 4.0% |
| 770512 | SuperWave_DAX_H4_Ottimizzato | D30EUR | H4 | 1.28 | 3.3% |

### EMA200 nuovi in forward (attaccati 01/08 su VPS, H4, tick reali PFmed ≥1.3)
_Motore più robusto finora. Girano in parallelo all'EMA200_Ott oro (771501). Oro NON riattaccato (doppione)._
| Magic | Strumento | TF | Dir | PFmed reale | DD% |
|---|---|---|---|---|---|
| 771511 | 200AUD (ASX) | H4 | LONG | 1.59 | 1.4 |
| 771512 | AUDJPY | H4 | LONG | 1.50 | 3.1 |
| 771513 | GBPJPY | H4 | LONG | 1.46 | 3.4 |
| 771514 | SPXUSD (S&P) | H4 | LONG | 1.44 | 1.9 |
| 771515 | GBPUSD | H4 | SHORT | 1.38 | 4.2 |

### Nativi (in forward per verifica, anche i "morti" nel backtest)
_Girano in parallelo agli ottimizzati (magic diversi). Verdetto backtest tra parentesi._
| Magic | EA nativo | Note backtest |
|---|---|---|
| (nativo) | DAX_Apertura_EU | ottimo solo LONG |
| (nativo) | Nasdaq_Apertura_US | morto real-tick |
| (nativo) | DAX_Live5m | morto |
| (nativo) | Nasdaq_Live5m | morto |
| (nativo) | DAX_M3 | morto |
| (nativo) | ORB / ORB_Fibo | marginale / morto |
| (nativo) | Londra_ORB | morto |
| (nativo) | SupertrendReversal / _Multi | edge (oro/indici) |
| (nativo) | EMA200 / GoldenCross | edge (oro) |
| (nativo) | MaxMinNotte | edge solo DAX short |
| (nativo) | Nightly / FiboH4_Multi / PostNews / PTE / WOL / SupertrendInvert | da verificare |

> Nota: i magic esatti dei nativi si leggono dal CSV dell'exporter (campo strategy/magic). Li mappo al primo caricamento.

---

## RISULTATI SETTIMANALI

_(Compilato da Claude dal CSV dell'exporter. In attesa del primo file.)_

### Settimana del ____ → ____
| Magic / EA | Tipo | Strumento | N. trade | P/L | DD% | Win% | Note |
|---|---|---|---|---|---|---|---|
| — in attesa dati — | | | | | | | |

**Trade MANUALI (magic 0 / non EA):**
| Data | Strumento | Lato | P/L | Note |
|---|---|---|---|---|
| — in attesa dati — | | | | |

**Sintesi settimana:** _(totale P/L, n. trade, miglior/peggior EA, nativo vs ottimizzato)_

---

## STORICO SINTESI (una riga per settimana)
| Settimana | Trade tot | P/L tot | Miglior EA | Peggior EA | Note |
|---|---|---|---|---|---|
| — | | | | | |
