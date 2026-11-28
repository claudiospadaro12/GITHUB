# UBS R4: validazione dell'ottimizzazione 1 (istantanea A0, 20 set, 40 passate) — 28/11/2026

**Criteri e previsioni:** `UBS_OTT_GVD_VALIDAZIONE_CRITERI_2026-11-27.md` (scritti prima). Dati: `UBS_NOTTE/RISULTATI_R4_2026-11-28.csv`; parser `backtest_pipeline/ubs_r4_parse.py`. 10 selezionati (SEL) + 10 passaggi idonei a caso (CTRL), oro D1, set di Wim (ricerca, fuori flotta).
- **V1** 1 minuto 2004-2012 (prima della finestra di ottimizzazione 2013-2022): cancello PF>=1,20, utile>0, >=20 op, anni negativi <=40%.
- **V3** tick reali 2025-01..2026-10: PF>=1,0 (solo 16-82 operazioni per set: indicativo).

| | V1 passano | V1 PF mediano (min-max) | V3 passano | V3 PF mediano |
|---|---|---|---|---|
| SEL | 9/10 | 2,25 (1,74-2,89) | 10/10 | 1,82 |
| CTRL | 9/10 | 2,73 (1,47-3,78) | 10/10 | 1,92 |

- **I selezionati NON battono i controlli**: differenza mediana V1 -0,48 (p permutazione 0,98 per SEL>CTRL), V3 -0,10 (p 0,56). L'ottimizzazione non aggiunge nulla rispetto a un parametro idoneo qualunque; il vantaggio e' della struttura oro D1 (tendenza), non della ricerca dei parametri.
- Il PF in campione prevede poco il PF fuori campione: Spearman 0,39 su 20 (SEL 0,65, CTRL 0,12). Rapporto V1/PF in campione mediano 1,22 (SEL) / 1,42 (CTRL): nessun degrado, anzi 2004-12 e' migliore del 2013-22.
- Il migliore in campione (n. 8, PF 3,54) e' secondo nei SEL in V1 (2,45): previsione O5 confermata.
- Passano V1 e V3: 18/20 (fuori: n. 3 per anni negativi 44%, n. 18 per anni negativi 50%).
- V3/V1 mediano 0,82 (D1: nessuna gonfiatura da modello 1 minuto, coerente con la calibrazione).
- Previsioni: O1 SI (9 e 9 su 10), O2 SI (SEL non superiore), O3 SI (10/10), O4 non misurata (correlazione con GoldenZoe non calcolata), O5 SI.

## Conseguenze
1. **Non lanciare la validazione A2**: il criterio scritto era "solo se i selezionati battono i controlli" e non e' cosi'. L'ottimizzazione genetica (2.345+ passaggi) non e' piu' necessaria per avere set oro D1 che reggono: ne bastano di casuali idonei (come gia' R2: 13/13 reggono).
2. Resta una **sola famiglia oro D1** (un posto), di Wim, probabile correlazione con GoldenZoe (0,23-0,30 in R2): non e' il terzo EA scorrelato.
3. Limiti: V3 su 2 anni e poche operazioni; 2004-12 e' un oro con trend; hold-out 2023-24 e V2 non aperti (non serve se non si prosegue).
