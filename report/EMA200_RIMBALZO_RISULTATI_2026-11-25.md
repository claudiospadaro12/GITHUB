# Media 200 rimbalzo corto (idea di Claudio): risultati con M1 (25/11/2026)

Criteri: `EMA200_RIMBALZO_CRITERI_2026-11-25.md` (con l'aggiunta scritta prima dei dati M1). Simulatore: `backtest_runner/simulatore/ema200_rimbalzo_m1.py`. Dati: H1 BCM 10 coppie 2005-2026 + M1 delle 2.253 ore di scatto (copertura 98-99%).

| variante | calcolo | periodo | setup | PF (R) | R medio | R/anno |
|---|---|---|---|---|---|---|
| PRIMARIA (TP 10, SL 2 ATR) | pessimistico H1 | IS 2005-2015 | 984 | 0.60 | -0.040 | -3.6 |
| PRIMARIA (TP 10, SL 2 ATR) | pessimistico H1 | OOS 2016-2021 | 410 | 0.42 | -0.079 | -5.4 |
| PRIMARIA (TP 10, SL 2 ATR) | pessimistico H1 | HO 2022-2026 | 327 | 0.50 | -0.061 | -4.0 |
| PRIMARIA (TP 10, SL 2 ATR) | M1 (risolto) | IS 2005-2015 | 984 | 0.70 | -0.026 | -2.3 |
| PRIMARIA (TP 10, SL 2 ATR) | M1 (risolto) | OOS 2016-2021 | 410 | 0.49 | -0.061 | -4.2 |
| PRIMARIA (TP 10, SL 2 ATR) | M1 (risolto) | HO 2022-2026 | 327 | 0.68 | -0.030 | -2.0 |
| PRIMARIA (TP 10, SL 2 ATR) | ottimistico H1 | IS 2005-2015 | 984 | 4.35 | 0.056 | 5.0 |
| PRIMARIA (TP 10, SL 2 ATR) | ottimistico H1 | OOS 2016-2021 | 410 | 2.93 | 0.051 | 3.5 |
| PRIMARIA (TP 10, SL 2 ATR) | ottimistico H1 | HO 2022-2026 | 327 | 2.01 | 0.036 | 2.4 |
| TP 15 pip | pessimistico H1 | IS 2005-2015 | 984 | 0.72 | -0.032 | -2.9 |
| TP 15 pip | pessimistico H1 | OOS 2016-2021 | 410 | 0.47 | -0.089 | -6.1 |
| TP 15 pip | pessimistico H1 | HO 2022-2026 | 327 | 0.59 | -0.059 | -3.9 |
| TP 15 pip | M1 (risolto) | IS 2005-2015 | 984 | 0.79 | -0.022 | -2.0 |
| TP 15 pip | M1 (risolto) | OOS 2016-2021 | 410 | 0.52 | -0.075 | -5.1 |
| TP 15 pip | M1 (risolto) | HO 2022-2026 | 327 | 0.63 | -0.050 | -3.3 |
| TP 15 pip | ottimistico H1 | IS 2005-2015 | 984 | 4.21 | 0.081 | 7.2 |
| TP 15 pip | ottimistico H1 | OOS 2016-2021 | 410 | 2.14 | 0.057 | 3.9 |
| TP 15 pip | ottimistico H1 | HO 2022-2026 | 327 | 2.34 | 0.061 | 4.0 |
| SL 1 ATR | pessimistico H1 | IS 2005-2015 | 984 | 0.56 | -0.072 | -6.4 |
| SL 1 ATR | pessimistico H1 | OOS 2016-2021 | 410 | 0.46 | -0.104 | -7.1 |
| SL 1 ATR | pessimistico H1 | HO 2022-2026 | 327 | 0.54 | -0.083 | -5.4 |
| SL 1 ATR | M1 (risolto) | IS 2005-2015 | 984 | 0.67 | -0.047 | -4.2 |
| SL 1 ATR | M1 (risolto) | OOS 2016-2021 | 410 | 0.58 | -0.065 | -4.5 |
| SL 1 ATR | M1 (risolto) | HO 2022-2026 | 327 | 0.73 | -0.037 | -2.4 |
| SL 1 ATR | ottimistico H1 | IS 2005-2015 | 984 | 2.68 | 0.080 | 7.1 |
| SL 1 ATR | ottimistico H1 | OOS 2016-2021 | 410 | 2.63 | 0.081 | 5.5 |
| SL 1 ATR | ottimistico H1 | HO 2022-2026 | 327 | 1.95 | 0.062 | 4.0 |
| SL fisso 30 pip | pessimistico H1 | IS 2005-2015 | 984 | 0.39 | -0.163 | -14.6 |
| SL fisso 30 pip | pessimistico H1 | OOS 2016-2021 | 410 | 0.38 | -0.148 | -10.1 |
| SL fisso 30 pip | pessimistico H1 | HO 2022-2026 | 327 | 0.42 | -0.146 | -9.6 |
| SL fisso 30 pip | M1 (risolto) | IS 2005-2015 | 984 | 0.49 | -0.114 | -10.2 |
| SL fisso 30 pip | M1 (risolto) | OOS 2016-2021 | 410 | 0.47 | -0.105 | -7.2 |
| SL fisso 30 pip | M1 (risolto) | HO 2022-2026 | 327 | 0.53 | -0.097 | -6.3 |
| SL fisso 30 pip | ottimistico H1 | IS 2005-2015 | 984 | 1.45 | 0.050 | 4.5 |
| SL fisso 30 pip | ottimistico H1 | OOS 2016-2021 | 410 | 1.79 | 0.063 | 4.3 |
| SL fisso 30 pip | ottimistico H1 | HO 2022-2026 | 327 | 1.24 | 0.028 | 1.8 |

VERDETTO:
- PRIMARIA (TP 10, SL 2 ATR) [pessimistico H1]: IS 0.60 (n=984), OOS 0.42 (n=410), HO 0.50 (n=327) -> non passa; rimbalzi di 10 pip: 84% (su 2706)
- PRIMARIA (TP 10, SL 2 ATR) [M1 (risolto)]: IS 0.70 (n=984), OOS 0.49 (n=410), HO 0.68 (n=327) -> non passa; rimbalzi di 10 pip: 86% (su 2706); copertura M1 2642/2655 barre di scatto
- PRIMARIA (TP 10, SL 2 ATR) [ottimistico H1]: IS 4.35 (n=984), OOS 2.93 (n=410), HO 2.01 (n=327) -> PASSA; rimbalzi di 10 pip: 97% (su 2706)
- TP 15 pip [pessimistico H1]: IS 0.72 (n=984), OOS 0.47 (n=410), HO 0.59 (n=327) -> non passa; rimbalzi di 15 pip: 80% (su 2706)
- TP 15 pip [M1 (risolto)]: IS 0.79 (n=984), OOS 0.52 (n=410), HO 0.63 (n=327) -> non passa; rimbalzi di 15 pip: 81% (su 2706); copertura M1 2642/2655 barre di scatto
- TP 15 pip [ottimistico H1]: IS 4.21 (n=984), OOS 2.14 (n=410), HO 2.34 (n=327) -> PASSA; rimbalzi di 15 pip: 94% (su 2706)
- SL 1 ATR [pessimistico H1]: IS 0.56 (n=984), OOS 0.46 (n=410), HO 0.54 (n=327) -> non passa; rimbalzi di 10 pip: 75% (su 2706)
- SL 1 ATR [M1 (risolto)]: IS 0.67 (n=984), OOS 0.58 (n=410), HO 0.73 (n=327) -> non passa; rimbalzi di 10 pip: 79% (su 2706); copertura M1 2552/2565 barre di scatto
- SL 1 ATR [ottimistico H1]: IS 2.68 (n=984), OOS 2.63 (n=410), HO 1.95 (n=327) -> PASSA; rimbalzi di 10 pip: 93% (su 2706)
- SL fisso 30 pip [pessimistico H1]: IS 0.39 (n=984), OOS 0.38 (n=410), HO 0.42 (n=327) -> non passa; rimbalzi di 10 pip: 65% (su 2706)
- SL fisso 30 pip [M1 (risolto)]: IS 0.49 (n=984), OOS 0.47 (n=410), HO 0.53 (n=327) -> non passa; rimbalzi di 10 pip: 70% (su 2706); copertura M1 2385/2398 barre di scatto
- SL fisso 30 pip [ottimistico H1]: IS 1.45 (n=984), OOS 1.79 (n=410), HO 1.24 (n=327) -> PASSA; rimbalzi di 10 pip: 87% (su 2706)

## Lettura
**0 candidate: Media 200 "rimbalzo 10 pip" CHIUSA.** Con la barra di scatto risolta a 1 minuto il risultato cade vicino al limite pessimistico, non a quello ottimistico: PF 0,70 IS / 0,49 OOS / 0,68 hold-out (primaria, 984/410/327 setup); tutte le 4 varianti (TP 15, SL 1 ATR, SL fisso 30) sono sotto 0,8 in tutti i periodi.
- Il rimbalzo di 10 pip c'e': 86% degli ordini (su 2.706). Ma il pareggio con TP 10 e SL 2 ATR sta a circa 83-87%: i rimbalzi mancati (14%) costano 4-6 volte il guadagno di quelli riusciti, e spread e slippage chiudono il resto. Il lotto non cambia il PF.
- Il limite ottimistico H1 (PF 2-4) era un artefatto: nell'ora di scatto il massimo spesso precede il minimo, quindi il "rimbalzo" non e' dopo l'ingresso.
- Limiti: spread M1 reale (o fisso se 0); stop meccanici (2 ATR); non simulati i livelli tecnici scelti a occhio ne' il filtro "come arriva la candela" (spike nella prima mezz'ora) del corso: sono ipotesi nuove da testare con criteri propri (per esempio escludere i tocchi con candela H1 ampia). Se "10 punti" fossero 10 punti MT5 = 1 pip, lo spread (0,8-2,8 pip) supera il bersaglio.
