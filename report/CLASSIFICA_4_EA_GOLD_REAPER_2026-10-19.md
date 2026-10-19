# Classifica dei 4 EA del pacchetto Gold Reaper (Gold Reaper, Gold Trade Pro, Goldbot One, The Gold Phantom) -- 19/10/2026

**Non controllata da agenti.** Stesse soglie S-* scritte prima; ordine per fasce, non per profitto; dentro la fascia e' un mio giudizio. Dati: 21 tranche mensili (tutti), Gold Reaper anche corsa continua col set di Claudio (GRC). S-CORR/S-PORT calcolati ADESSO con lo strumento congelato (non pre-registrati per Phantom; stessi criteri gia' scritti). Uscite in `backtest_pipeline/risultati_archivio/SCORR_SPORT_20261019/pacchetto_*.txt`.

| # | EA | soglie | op. | mesi pos. | netto | DD | note |
|---|---|---|---|---|---|---|---|
| 1 | Gold Trade Pro (D1 ipotesi) | tutte le misurabili | 473 | 16/21 | +2.554 (mesi indip.) | 11,02% mensile | 10 pos. contemporanee; costo 30x; corsa continua non fatta |
| 2 | Goldbot One (H1 ipotesi) | tutte le misurabili | 448 | 16/21 | +1.300 | 6,96% mensile | 8 pos.; costo 16x; continua non fatta |
| 3 | Gold Reaper, set di Claudio | S-NOSCALA (11 pos. contro 10) | 791 | 18/21 | +3.970 (continua) | 4,77% (2,67% dal deposito) | e' il set di Claudio; unico con corsa continua; a default (mesi indip.) lotto fino a 0,06 e 9 pos. |
| 4 | The Gold Phantom (H1 ipotesi) | S-NOSCALA (17 pos. contemporanee) | 1.199 | 17/21 | +5.293 | 7,71% mensile | la piu' correlata agli altri |

## Correlazioni (r dei risultati giornalieri, Gold Reaper = set di Claudio)
GR/GTP 0,508 - GR/Goldbot 0,412 - GR/Phantom 0,583 - GTP/Goldbot 0,422 - GTP/Phantom 0,526 - Goldbot/Phantom 0,599. Nessuna sotto 0,30; **4 su 6 sopra 0,50**; per lo strumento tutte "NON MISURATA" (intervalli contengono 0,50). **S-CORR smentita** per il pacchetto.
## S-PORT (peso 1, pavimento / tetto, % di 5.000)
Tutti e 4: **17,57% / 26,21%** -> non passa (anche il pavimento supera il 10%; aprile 2026 il mese peggiore, B6 smentita). Terne e coppie: GR+Goldbot **6,16% / 8,44% -> PASSA**; GR+Phantom 8,55/11,72; GR+GTP 9,24/14,59; Goldbot+Phantom 9,60/12,49; GTP+Goldbot 12,35/16,14; GTP+Phantom 13,06/18,39; GR+GTP+Goldbot 12,98/19,28; GR+Goldbot+Phantom 10,03/14,75 -> **solo la coppia Gold Reaper + Goldbot One sta dentro il 10% col tetto.**
## Limiti
Solo Gold Reaper ha una corsa continua; i tre periodi (D1/H1/H1) non sono confermati; i quattro sono sullo stesso oro e perdono insieme in aprile-maggio 2026; la regola di acquisto del pacchetto intero (B5 su 3 EA su 4 + B6) resta NON soddisfatta (lettura del 19/10).
