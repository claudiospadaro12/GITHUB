# A5 Monte Carlo potenza  seed=12345 NSIM=20000 win rate=0.6
Payoff medio vincita (in R, perdita=1R): PF1.00 -> 0.667R ; PF1.15 -> 0.767R ; PF1.30 -> 0.867R
Expectancy per trade: PF1.15 -> +0.0600R ; PF1.30 -> +0.1200R
Formula normale (1 coda 5%, potenza 80%, esiti binari): N ~ ((z*sd)/m)^2 = 1287 trade (sd per trade 0.865R)

## Modello BINARIO: potenza (alpha=5% 1 coda) per distinguere PF1.15 da PF1.0; e alpha effettivo
| N trade | soglia PF (95% sotto H0) | potenza PF1.15 | potenza PF1.30 | potenza PF1.50 | P(PF_oss>1 | H0) |
|---|---|---|---|---|---|
| 20 | 2.00 | 13% | 25% | 25% | 45% |
| 30 | 1.83 | 9% | 18% | 29% | 43% |
| 50 | 1.71 | 9% | 15% | 34% | 55% |
| 80 | 1.47 | 15% | 29% | 54% | 54% |
| 120 | 1.38 | 15% | 39% | 68% | 54% |
| 200 | 1.27 | 26% | 59% | 89% | 53% |
| 400 | 1.19 | 40% | 81% | 99% | 52% |
| 800 | 1.13 | 60% | 98% | 100% | 52% |
| 1300 | 1.09 | 81% | 100% | 100% | 51% |
| 2000 | 1.08 | 93% | 100% | 100% | 51% |

## Modello RUMOROSO: potenza (alpha=5% 1 coda) per distinguere PF1.15 da PF1.0; e alpha effettivo
| N trade | soglia PF (95% sotto H0) | potenza PF1.15 | potenza PF1.30 | potenza PF1.50 | P(PF_oss>1 | H0) |
|---|---|---|---|---|---|
| 20 | 2.41 | 7% | 12% | 17% | 51% |
| 30 | 1.99 | 9% | 15% | 24% | 50% |
| 50 | 1.68 | 11% | 21% | 37% | 50% |
| 80 | 1.51 | 13% | 27% | 49% | 50% |
| 120 | 1.40 | 16% | 36% | 64% | 50% |
| 200 | 1.29 | 22% | 52% | 84% | 50% |
| 400 | 1.19 | 37% | 79% | 99% | 50% |
| 800 | 1.13 | 58% | 97% | 100% | 50% |
| 1300 | 1.10 | 78% | 100% | 100% | 49% |
| 2000 | 1.08 | 90% | 100% | 100% | 50% |

## Effetto minimo rilevabile (potenza 80%, alpha 5%), modello BINARIO, win rate 60%
| N trade totali | PF vero minimo rilevabile |
|---|---|
| 28 | 2.60 |
| 57 | 2.00 |
| 114 | 1.65 |
| 230 | 1.40 |
| 340 | 1.35 |
| 680 | 1.25 |
| 1300 | 1.20 |

## Criterio '4 periodi su 4 con PF>1' (cosa dimostra?) - modello BINARIO, trade per periodo = n
| trade/periodo | P(4/4 periodi PF>1 | H0 PF=1.0) | P(4/4 | PF vero 1.15) | P(4/4 | PF vero 1.30) |
|---|---|---|---|---|
| 7 | 3.1% | 25.1% | 25.6% |
| 14 | 5.4% | 23.0% | 22.9% |
| 28 | 9.4% | 23.1% | 35.4% |
| 57 | 5.1% | 21.5% | 49.8% |
| 85 | 5.0% | 25.8% | 61.8% |
| 200 | 7.7% | 46.3% | 86.5% |

## Intervallo di confidenza 90% del PF osservato quando il PF vero e 1.15 (binario, 5-95 percentile)
| N | PF 5% | PF mediano | PF 95% |
|---|---|---|---|
| 28 | 0.66 | 1.18 | 2.30 |
| 57 | 0.74 | 1.13 | 1.80 |
| 114 | 0.85 | 1.13 | 1.60 |
| 340 | 0.96 | 1.15 | 1.39 |
| 1300 | 1.05 | 1.15 | 1.26 |
