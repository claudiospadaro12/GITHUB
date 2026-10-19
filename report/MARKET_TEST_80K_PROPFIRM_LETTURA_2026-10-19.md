# Test a 80.000 EUR: Prop Firm Gold EA (lettura PARZIALE, manca Smart Gold Hunter) -- 19/10/2026

**Non controllata da agenti.** Previsioni scritte prima: `MARKET_TEST_80K_ATTESE_2026-10-19.md` (c09b8705). Ricevuto solo `DEEP80K_PROPFIRMGOLDEA.zip`; **Smart Gold Hunter a 80K non e' arrivato** (e portafoglio A a 80K non calcolabile). Dati in `backtest_pipeline/risultati_archivio/TEST80K_20261019/`.

## Conformita'
Corsa continua 01/01/2025 - 01/10/2026, XAUUSD H1, ticks reali 100%, deposito 80.000, 673 operazioni, nessuno stop-out e nessun "no money" nel log. **Input scritti nel report identici a quelli della corsa a 5.000** (24 righe confrontate).

## Numeri (80.000 EUR) contro la corsa a 5.000
| | 5.000 EUR | 80.000 EUR |
|---|---|---|
| netto | +1.590,96 (+31,8%) | **+34.129,71 (+42,7%)** |
| PF | 1,26 | 1,25 |
| operazioni | 673 | 673 |
| DD equity dal picco | 7,80% | **9,72%** (11.023 EUR) |
| perdita max dal deposito (equity) | 0,01% | 0,02% (17,10 EUR) |
| lotti | 0,01 (4 volte 0,02) | **0,16 - 0,31** (mediana circa 0,22) |
| posizioni contemporanee | 3 | 3 |
| mesi positivi | 14/21 | 14/21 |
| profitto medio per operazione | 2,36 | 50,71 (circa 11,9 volte il costo spread stimato) |
Il lotto **scala col saldo** (0,015-0,039 lotti ogni 10.000 EUR di saldo; parte da 0,30 all'inizio e scende a circa 0,2 con il saldo che sale: non e' un rapporto fisso, la logica interna non e' leggibile). A 5.000 il 0,01 era il **pavimento del lotto minimo**, non la taglia vera.

## Previsioni
- **Q1** (lotto > 0,01 a 80K): **CONFERMATA**.
- **Q2** (rendimento +22%..+41% sul deposito se il lotto scala): **SBAGLIATA di poco**: +42,7%, sopra la banda di 1,7 punti. Rispetto alla pura scala lineare x16 (+25.455) il risultato e' **+34% piu' alto**, perche' a 5.000 il lotto minimo schiacciava la taglia sotto il valore che l'EA avrebbe scelto.
- **Q3** (DD equity <= 15,2%, perdita dal deposito <= 10%): **CONFERMATA** (9,72% e 0,02%). La stima 6-10% era giusta ma sul bordo alto.
- **Q4** (nessuno stop-out): confermata.
- **Q5** (operazioni +/-10%): confermata (673 identiche).
- **Q7** (costo >= 3x): confermata (11,9x).
- Q6 (portafoglio A a 80K): **non calcolabile** senza Smart Gold Hunter.

## Cosa dice e cosa NO
Dice: a 80K il Prop Firm Gold EA scala da solo (lotti 0,16-0,31), il rendimento percentuale e' dello stesso ordine (+43% in 21 mesi, circa 1,7%/mese medio) e il **DD sale in percentuale (9,72% contro 7,80%)**, vicino al 10%. Non dice niente su slippage con lotti da 0,2-0,3 (il tester non ne ha), margine reale (nel tester livello di margine minimo 1.350%; oro ~8.580 EUR/lotto contro 1.784 sul reale), regole di una prop. H2 (giu-set 2026) +9.322 contro H1 +24.808: l'ultima parte e' piu' debole in proporzione. Il lotto e la taglia sul conto vero restano decisione di Claudio.
