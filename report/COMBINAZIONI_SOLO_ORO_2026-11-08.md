# Due combinazioni prop solo con gli EA oro di Wim (08/11/2026)

"Gold bundle" inteso come i 4 EA oro di Wim (Reaper, Phantom, Goldbot One, Gold Trade Pro), senza Daytrade Pro e senza forex. (Il file `Gold_Bundle.zip` di Wim e un solo backtest di UBS V6.4: non e questo.) Dati: stessi test a 80k (2013, 2020, 2025), commissioni FTMO e slippage nello scenario centrale (36 EUR/lotto oro), P&L giornaliero realizzato. Script: stesso metodo di `ORO_GRADINI_dati/costi_prop.py`.

| Sigla | Combinazione (livello) | Guadagno lordo/anno a 80k (media 3 anni, centrale) | per anno 2013 / 2020 / 2025 | Peggior giorno | DD realizzato | DD equity (somma dei massimi, limite superiore) | Giorni <= -4,3% |
|---|---|---|---|---|---|---|---|
| G-A | Phantom Gradino 1 + Goldbot Prop | **22.048** | 20.820 / 18.710 / 26.614 | -4,3% | 5,7% | 9,1% | 0 |
| G-C | Reaper Combo 3GOLD + Gold Trade Pro Combo | 13.426 | 13.878 / 10.421 / 15.980 | -4,4% | 7,7% | 8,4% | 1 |
| G-E | Goldbot Combo 3GOLD + Gold Trade Pro Combo | 17.151 | 23.811 / 13.509 / 14.134 | -3,9% | 5,5% | 7,9% | 0 |
| G-D | Reaper Combo 3GOLD + Goldbot Prop | 16.254 | 16.795 / 16.217 / 15.751 | -3,4% | 5,3% | 7,7% | 0 |
| G-B | Phantom Prop + Goldbot Prop | 15.844 | | -3,2% | 3,4% | 5,9% | 0 |
| G-K | Reaper Combo + Goldbot Combo | 13.768 | | -2,9% | 5,0% | 7,0% | 0 |
| G-F | Reaper Combo + Phantom Combo | 9.882 | | -2,2% | 5,3% | 5,8% | 0 |
| G-I | Phantom Gradino 1 + GTP Combo | 19.220 | | -3,7% | 8,1% | 9,8% | 0 |
| G-H | Phantom G1 + Goldbot Prop + GTP Combo | 30.453 | | **-6,0%** | 9,9% | 13,6% | 1 |

## Le due proposte
- **Coppia 1 "EA distinti"**: conto 1 = **G-A**, conto 2 = **G-C**. Nessun EA in comune (Phantom + Goldbot contro Reaper + Gold Trade Pro). Totale circa **35.500 EUR/anno** a 80k per conto.
- **Coppia 2 "piu rendimento"**: conto 1 = **G-A**, conto 2 = **G-E** (alternativa G-D). Goldbot in comune (livelli diversi: Prop contro Combo). Totale circa **39.200 EUR/anno** (38.300 con G-D).
- Scartate: G-H (supera il -5% giornaliero), G-I (DD vicino al limite), G-F (rendimento basso).

## Letture e limiti
- Senza Daytrade Pro i rendimenti scendono di circa 8-9.000 EUR/anno per conto rispetto alle combo P1-P5, e **tutto e oro**: nelle fasi sfavorevoli dell'oro i due conti perdono insieme (nel 2013 l'oro e sceso del 27%).
- "DD equity (somma)" e la somma dei massimi dei singoli EA: e un **limite superiore prudente**, non il DD vero della combinazione; il DD equity vero non e stato ricostruito per queste combinazioni (per P1-P5 e 6,8-8,4% nel 2013).
- Il -4,3% di G-A coincide con la soglia del Guardian (e puo includere l'artefatto della chiusura forzata del 31/12 nei test).
- G-A e il conto piu vicino al limite del 10% (9,1% il limite superiore): prudenza sul primo conto.
- Backtest su 3 anni, nessun forward, nessun costo di swap reale, lotti dei set. Nessuna taglia consigliata.
