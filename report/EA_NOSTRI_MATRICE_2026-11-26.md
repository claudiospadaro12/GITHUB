# Matrice dei 108 EA di TUTTI_EA.zip (26/11/2026): controllo automatico, nessun agente

Dati: `EA_NOSTRI_MATRICE_2026-11-26.csv` (una riga per file: righe, numero input, ordini pendenti, input di orario, uso dell'ora server/GMT, distanze in punti, ATR, lettura della barra 0, nuova barra, trailing/BE, differenze col repo). **Sono ricerche di testo (euristiche), non analisi del codice**: servono a decidere dove guardare. I sorgenti NON sono nel repo (pubblico). I `.ex5` non sono stati aperti ne eseguiti.

**Elenco:** 108 `.mq5`; 103 aprono ordini; 5 sonde/strumenti (Apertura_Study_EA, SondaGapCash, SondaMargine, SpreadLogger, CLAU12_EXPORT_BARRE_H1). Solo 2 file identici al repo, **43 diversi**, **63 mai visti**.

## Conteggi (sui 103 che aprono ordini)
| Controllo | EA |
|---|---|
| Ordini pendenti (stop/limit) | 46 |
| Input di orario (ore di sessione) | 97; usano l'ora server 96; **gestiscono GMT/ora legale 78** |
| Distanze in punti/pip negli input | 92 (di cui 90 citano anche l'ATR) |
| Lettura di prezzi della barra 0 (iOpen/High/Low/Close ...,0) | 25 |
| Buffer indicatore con barra di partenza 0 | 79 (**da verificare uno per uno**: se legge la barra in formazione l'EA puo' ridisegnare) |
| Senza controllo di nuova barra | 31 (6 con ordini a mercato: GapContinuation, IntradayMomentum, Nightly, Nightly_Ottimizzato, ScalperClaudio, Guardian) |
| Trailing / breakeven | 88 |

**Orari in input SENZA alcuna gestione di ora legale (20):** AllineaLondra, BreakoutCorso, CRT_TurtleSoup, CanaleLento, ChaosLyapunov, CostToCost, EasyTrend, GapFill, **GoldBreakoutATR**, Guardian, InvEsaurimento, LondonFx, OutOfNoise, **PunteLarry**, Relativo, ScalperClaudio, SondaM0PB, SondaRelativo, SondaRsiEmaV8, EA_NatCla. Regola CLAUDE.md: l'orario in ora server va cambiato due volte l'anno (BCM GMT+1 fisso): un test su un anno intero con un solo orario e' sbagliato per meta' dell'anno. Per GoldBreakoutATR e PunteLarry (candidati) e' il primo controllo da fare.

## Scoperta sul repo
Le versioni sul PC differiscono da quelle nel repo per 43 file; le piu' lontane: DAX_Apertura_EU (1.713 righe cambiate), Nasdaq_Apertura_US (1.528), BreakoutCorso (1.040), MaxMinNotte (399), GoldenCross (342), PTE (334). **I risultati dei nostri test (CLASSIFICA, forward) potrebbero riferirsi a versioni diverse da quelle nel repo**: prima di ogni nuova misura va fissata la versione (md5).

## Cosa NON ho potuto stabilire
- **Griglia/martingala:** la ricerca per parole chiave dava falsi positivi (testi tipo "senza martingala"), colonna scartata. Va letto il codice.
- Risultati di backtest per EA: non sono nello zip (i log sono 100 file di compilazione/esecuzione, non letti).

## Prossimo passo dove la Sala serve davvero
Famiglie nuove nello zip e mai misurate, con orari senza ora legale o barra 0 da verificare: GoldBreakoutATR, `Gold_Ichimoku_TK_ATR_EA`, PunteLarry (versione PC), AltaVelocita, MeanRevert, VwapRevert, FvgRetest, LiquiditySweep, OutOfNoise, CRT_TurtleSoup, TurnaroundTuesday, CanaleLento, ChaosLyapunov, CrossEma.
