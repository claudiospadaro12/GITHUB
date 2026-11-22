# US30 volatility M15 a TICK REALI sul clone U30USD_T (22/11/2026, passo 2 della guida di Wim)
Sorgenti: `TICK_CLONI_20261122_075954.txt` (copia tick: 549 giorni, 66,6 milioni di tick, 0 errori, controllo ultimi 3 giorni 291.063 = 291.063) e `ANNO_ORO_GRADINI_UBSCT4_20261122_0827.zip` (6 passate Modello 4, 01/01/2025-13/11/2026, lotto 0,1, 100.000 EUR). Le passate sono marcate KO dalla riga **solo per il controllo formale**: i tick partono dal 02/01/2025 (il 01/01 non ci sono tick) quindi la qualita e "99% tick reali"; non e un guasto. Operazioni identiche al test a 1 minuto in tutte e 6.

| Set | PF tick | PF 1 min | Rapporto | DD tick / 1 min | Ops | P (01/01-12/05/2025) n / PF tick | Q n / PF tick | V3 |
|---|---|---|---|---|---|---|---|---|
| US30_VOL_M15_g | 1,88 | 2,03 | 0,93 | 0,98x | 113 | 20 / 1,30 | 93 / 2,20 | **passa** |
| US30_VOL_M15_a | 1,60 | 1,69 | 0,95 | 0,86x | 94 | 20 / 0,93 | 74 / 1,99 | passa V3, ma G2 non (P < 1) |
| US30_VOL_M15_c | 1,18 | 1,57 | 0,75 | **1,503x** | 110 | 22 / 1,06 | 88 / 1,21 | **non passa per un soffio** (DD 1,503 > 1,5) |
| US30_VOL_M15_b | 1,90 | 12,11 | **0,16** | 2,66x | 73 | 21 / 22,15 | 52 / 1,28 | **bocciato** (< 0,5): il PF 12 era un effetto delle barre da 1 minuto |
| US30_U3V08 | 1,01 | 1,15 | 0,88 | 0,97x | 102 | 19 / 0,73 | 83 / 1,19 | PF a tick 1,01 ma G1 gia non passava |
| US30_U3V12 | 0,99 | 1,12 | 0,88 | 0,86x | 120 | 21 / 0,52 | 99 / 1,29 | non passa (PF tick < 1) |

**Esito (cancelli scritti prima):** dei tre candidati provvisori a 1 minuto (b, c, g) resta **`US30_VOL_M15_g`** (tutti i cancelli G1-G5 + V3). `b` e bocciato (la nostra diffidenza sul PF 12 era giusta), `c` fallisce V3 di 0,003 sul DD. `a` passa V3 ma non G2.
**Limiti:** 22 mesi, un solo regime (Dow in forte rialzo), un solo indice, set della stessa famiglia; **nessun fuori campione lungo** (i dati BCM del Dow partono dal 2024: la guida di Wim usa il 2000-2013, non disponibile); la perturbazione dei parametri (V2) e l'hold-out (V4) non sono ancora fatti. I profitti in EUR dei cloni vanno letti con prudenza (tick value).
**Previsioni scritte prima:** il rapporto tick/1 minuto >= 0,7 per i candidati non scalper: previsto 70%; qui 4 su 6 lo superano (esclusi b e... solo b sotto 0,7; U3V12/U3V08 0,88).
