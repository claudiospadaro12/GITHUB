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

---
# AGGIORNAMENTO 20/10: arrivato Smart Gold Hunter a 80K, portafoglio A a 80K

**Smart Gold Hunter a 80.000**: 237 operazioni, **lotto sempre 0,01**, netto **+275,56 (PF 1,74)**, **identico al centesimo alla corsa a 5.000**; input identici. Non scala col saldo: i suoi input hanno `inp_LotMethod=0` e `inp_Lots=0.01` (lotto fisso) e anche `inp_RiskPercent=1.0` / `inp_BalancePer001Lot=100`, ma cambiare il metodo del lotto sarebbe una VARIANTE non testata. A 80K pesa lo 0,8% del profitto della combinazione.
**Previsione Q2 per SGH** (+3%..+8% se il lotto scala): non applicabile, il lotto non scala. **Q1** confermata (dal Prop Firm). **Q5** confermata (237 = 237).

**Portafoglio A a 80K (calcolo mio, serie giornaliere sommate, corsa continua; non lo strumento congelato)**: netto **+34.405 (+43,0%)**, PF per operazione 1,25 (910 operazioni), 14 mesi positivi su 21, peggior giorno -2.502 (3,1% di 80K), peggior mese -3.819 (4,8%), **DD dei realizzi concatenati 9.978 EUR = 12,5% di 80.000**, somma dei DD di equity dei due (tetto) 11.061 EUR = **13,8% di 80.000**.
**Q6** (DD di portafoglio <= 10% di 80.000, pavimento e tetto): **SBAGLIATA/SMENTITA** nella base scritta (10% dei 80.000 di partenza): 12,5% e 13,8%. Per chiarezza, NON ammorbidisco: la cifra del report del solo Prop Firm (9,72%) e' in percentuale del PICCO di equity (che sale a circa 115.000), mentre i 11.023 EUR sono il 13,8% degli 80.000 iniziali; la perdita massima dal deposito resta 0,02% (il conto non e' mai sceso sotto i 80.000). Quale delle due basi conta dipende dalla regola del conto su cui girerebbe (DD statico dal capitale iniziale, relativo al picco, giornaliero): non la conosco.

**Osservazione sugli input di Smart Gold Hunter (non verificata)**: `UseAutoBrokerGMTOffset=false`, `ManualBrokerGMTOffset=2`, chiusure giornaliera 21:15 e venerdi' 15:25, filtro news. Il server BCM e' un'ora indietro rispetto all'ora italiana (UTC+1 oggi, non +2): se l'EA usa quel offset a mano, orari di chiusura e filtro news possono slittare di un'ora sul conto vero. Nel tester vale il suo offset dichiarato; che coincida col server BCM e' [NON VERIFICATO].
