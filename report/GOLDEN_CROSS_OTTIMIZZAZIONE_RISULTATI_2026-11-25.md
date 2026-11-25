# Golden Cross HA: ottimizzazione coi criteri di Wim, risultati (25/11/2026)

Criteri: `GOLDEN_CROSS_OTTIMIZZAZIONE_CRITERI_2026-11-25.md`. Script: `backtest_runner/simulatore/golden_cross_opt.py`. Famiglia A (PDF HA+ADX), 10 coppie forex, 576 combinazioni (tentativi). Ricerca solo IS 2005-2015.

Combinazioni (tentativi): 576
  ... 0/576 (2s)
  ... 96/576 (99s)
  ... 192/576 (168s)
  ... 288/576 (218s)
  ... 384/576 (243s)
  ... 480/576 (262s)

DISTRIBUZIONE PF IN CAMPIONE (IS 2005-2015), combinazioni con >= 300 operazioni: 312
  massimo 1.46, 90 percentile 1.13, mediana 0.95, minimo 0.74
IDONEI IS (PF >= 1,30, n >= 300, profitto > 0, anni positivi >= 60%): 11 su 576
Selezionati 10 candidati (40% migliori, 30% diversi, 30% a sorte)

| config (TF, ADX, dist, target, stop, exit EMA21) | IS PF | IS n | V1 OOS PF | V1 n | V1 anni non neg. | V2 varianti PF>1 IS+V1 | V1 | V2 | V4 hold-out |
|---|---|---|---|---|---|---|---|---|---|
| ('H4', 25, 1.5, 2.0, 1.5, False) | 1.46 | 500 | 0.85 | 243 | 33% | 1/7 | no | no | non aperto |
| ('H4', 25, 1.5, 2.0, 1.5, True) | 1.45 | 503 | 0.86 | 243 | 0% | 1/7 | no | no | non aperto |
| ('H4', 25, 1.5, 3.0, 1.5, False) | 1.36 | 499 | 0.86 | 243 | 17% | 1/6 | no | no | non aperto |
| ('H4', 25, 1.5, 1.5, 1.5, False) | 1.36 | 501 | 0.94 | 243 | 50% | 2/7 | no | no | non aperto |
| ('H4', 25, 1.5, 1.5, 1.5, True) | 1.32 | 503 | 0.93 | 243 | 50% | 0/7 | no | no | non aperto |
| ('H4', 25, 1.5, 1.0, 2.5, True) | 1.34 | 503 | 0.90 | 243 | 33% | 1/5 | no | no | non aperto |
| ('H4', 25, 1.5, 1.5, 2.5, True) | 1.37 | 503 | 0.86 | 243 | 0% | 2/6 | no | no | non aperto |
| ('H4', 25, 1.5, 3.0, 1.5, True) | 1.36 | 503 | 0.91 | 243 | 17% | 1/6 | no | no | non aperto |
| ('H4', 25, 1.5, 3.0, 2.5, True) | 1.35 | 503 | 0.89 | 243 | 33% | 2/5 | no | no | non aperto |
| ('H4', 25, 1.5, 2.0, 2.5, True) | 1.36 | 503 | 0.90 | 243 | 33% | 2/6 | no | no | non aperto |

ESITO: vedi tabella.

## Lettura
**0 candidati.** 11 combinazioni su 576 sono idonee in campione (PF 1,32-1,46, circa 500 operazioni), tutte nella stessa zona stretta: **H4, ADX >= 25, distanza <= 1,5 ATR**. Nessuna regge fuori campione: **PF OOS 0,85-0,94 (anni non negativi 0-50%) per tutti e 10 i selezionati**; la perturbazione V2 fallisce (0-2 varianti su 5-7 con PF > 1 in IS e OOS). L'hold-out 2022-2026 non e stato aperto, come da criteri.
- Distribuzione dei PF in campione: massimo 1,46, 90 percentile 1,13, mediana 0,95. Il gruppo idoneo e' un'unica regione (stesso TF, ADX e distanza) e non un altopiano: i vicini non reggono. Con 576 tentativi un massimo di 1,46 e' atteso dal caso.
- Il campione H4 e' piccolo (circa 500 operazioni su 11 anni in 10 coppie): un singolo anno favorevole sposta il PF.
- Previsione (80% nessun idoneo) sbagliata sul numero (11 idonei) ma giusta sul verdetto (nessun candidato, probabilita' 3%).
- **Conclusione:** Golden Cross HA CHIUSA come EA: ne' la traduzione del PDF, ne' le sue varianti ottimizzate coi criteri di Wim superano il fuori campione. La parte discrezionale non e' simulata. Famiglia B (Paolo) non ottimizzabile: 13-23 operazioni per periodo sull'oro.
