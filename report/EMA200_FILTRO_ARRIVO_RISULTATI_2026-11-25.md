# Media 200 rimbalzo: filtro sulla candela di arrivo, risultati (25/11/2026)

Criteri: `EMA200_FILTRO_ARRIVO_CRITERI_2026-11-25.md`. Simulatore: `backtest_runner/simulatore/ema200_rimbalzo_filtro.py`. La base senza filtro riproduce il test M1 precedente (PF 0,70 / 0,49 / 0,68).

| cella | periodo | setup | PF (R) | R medio | R/anno |
|---|---|---|---|---|---|
| BASE senza filtro (M1) | IS 2005-2015 | 984 | 0.70 | -0.026 | -2.3 |
| BASE senza filtro (M1) | OOS 2016-2021 | 410 | 0.49 | -0.061 | -4.2 |
| BASE senza filtro (M1) | HO 2022-2026 | 327 | 0.68 | -0.030 | -2.0 |
| FA spike prima mezz'ora (m<30) | IS 2005-2015 | 638 | 0.59 | -0.033 | -1.9 |
| FA spike prima mezz'ora (m<30) | OOS 2016-2021 | 258 | 0.53 | -0.045 | -1.9 |
| FA spike prima mezz'ora (m<30) | HO 2022-2026 | 193 | 0.62 | -0.031 | -1.2 |
| FB arrivo lento (S<=1,0 ATRh) | IS 2005-2015 | 493 | 0.76 | -0.014 | -0.6 |
| FB arrivo lento (S<=1,0 ATRh) | OOS 2016-2021 | 167 | 0.69 | -0.020 | -0.6 |
| FB arrivo lento (S<=1,0 ATRh) | HO 2022-2026 | 143 | 0.72 | -0.017 | -0.5 |
| FC arrivo lento stretto (S<=0,5 ATRh) | IS 2005-2015 | 180 | 0.86 | -0.007 | -0.1 |
| FC arrivo lento stretto (S<=0,5 ATRh) | OOS 2016-2021 | 56 | 0.46 | -0.045 | -0.4 |
| FC arrivo lento stretto (S<=0,5 ATRh) | HO 2022-2026 | 49 | 0.59 | -0.028 | -0.3 |
| FD m<30 e S<=1,0 ATRh | IS 2005-2015 | 416 | 0.79 | -0.011 | -0.4 |
| FD m<30 e S<=1,0 ATRh | OOS 2016-2021 | 143 | 0.60 | -0.029 | -0.7 |
| FD m<30 e S<=1,0 ATRh | HO 2022-2026 | 117 | 0.72 | -0.017 | -0.4 |

VERDETTO:
- BASE senza filtro (M1): IS 0.70 (n=984), OOS 0.49 (n=410), HO 0.68 (n=327) -> non passa; ordini entrati 2706, rimbalzo 86%
- FA spike prima mezz'ora (m<30): IS 0.59 (n=638), OOS 0.53 (n=258), HO 0.62 (n=193) -> non passa; ordini entrati 1373, rimbalzo 85%, scartati dal filtro 1333 su 2706 scatti
- FB arrivo lento (S<=1,0 ATRh): IS 0.76 (n=493), OOS 0.69 (n=167), HO 0.72 (n=143) -> non passa; ordini entrati 914, rimbalzo 88%, scartati dal filtro 1792 su 2706 scatti
- FC arrivo lento stretto (S<=0,5 ATRh): IS 0.86 (n=180), OOS 0.46 (n=56), HO 0.59 (n=49) -> non passa; ordini entrati 300, rimbalzo 88%, scartati dal filtro 2406 su 2706 scatti
- FD m<30 e S<=1,0 ATRh: IS 0.79 (n=416), OOS 0.60 (n=143), HO 0.72 (n=117) -> non passa; ordini entrati 743, rimbalzo 87%, scartati dal filtro 1963 su 2706 scatti

## Lettura
**0 candidate: nessun filtro porta il PF vicino a 1.** Il rimbalzo passa dall'86% al massimo all'88% (arrivo lento), con meta' o piu' degli ordini scartati, e il PF resta 0,46-0,86 in tutti i periodi.
- "Spike nella prima mezz'ora" (m < 30): rimbalzo 85%, PF 0,59 / 0,53 / 0,62, non migliora la base: l'euristica della lezione non e' supportata dai dati.
- "Arrivo lento" (S <= 1 ATR h): rimbalzo 88%, PF 0,76 / 0,69 / 0,72; con 0,5 ATR (180/56/49 setup) il campione e' sotto i minimi e il fuori campione cade (0,46).
- Per superare lo stop da 4-6 volte il bersaglio servirebbe un tasso di rimbalzo stabile oltre il 92%: nessuna regola causale testata ci si avvicina.
- Resta fuori dalla simulazione il giudizio sul livello a occhio (supporti, minimi precedenti) e l'orario sul lotto/gestione manuale: se Claudio la usa, va misurata col diario (casi presi a mano), non con questa traduzione.
- **Conclusione:** Media 200 forex (bersaglio EMA14, rimbalzo 10 pip, filtro di arrivo) CHIUSA come EA meccanico.
