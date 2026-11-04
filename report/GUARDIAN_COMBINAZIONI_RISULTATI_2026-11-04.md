# Combinazioni di set con Guardian simulato: risultati (04/11/2026)
Criteri e previsioni scritti prima (commit 188c7eb5): `GUARDIAN_COMBINAZIONI_CRITERI_2026-11-04.md`. Script: `GUARDIAN_COMBINAZIONI/fetch_ev.py` (estrae i deal dai report su `lavoro` e dagli zip) e `sim_comb.py` (Guardian simulato + finestre di 14 giorni). 1.152 combinazioni = Reaper {D9, DD6, DD12, DD15, LIVE30, LIVE9, R50A, R50B} x Goldbot {nessuno, PF525, PF105, LOW3} x Phantom {nessuno, PROPCOMBO_D4, PROPFIRM_D9, LOWRISK_D10, MEDIUM_D30, HIGHRISK_D60} x GTP {nessuno, COMBO, PROPFIRM_R1, LOWRISK_R15, MEDIUM_R3, HIGHRISK_R6}; anni 2013, 2018, 2020, 2025, 80.000 EUR, Modello 1 (DD9 coincide col D9: escluso). Non controllata da agenti.

## Limiti (importanti)
Realizzato senza flottante; Guardian = approssimazione: la giornata si taglia al -4,3% (A: esatto; B: al deal che supera la soglia, quindi con overshoot) e gli eventi successivi di quel giorno cadono; il totale 9,3% ferma tutto ("stop", non e un fallimento). In una gara reale il Guardian controlla ogni secondo e uno spike veloce dell'oro puo andare oltre il -4,3%: "fallimento 0" qui NON e una garanzia. Regole FTMO non verificate (obiettivo +5%, giorno -5%, totale -10%). 4 anni, un percorso per anno: nessuna combinazione e una raccomandazione.

## Prova di 14 giorni (finestre di partenza su tutti i giorni dei 4 anni, modello B)
| Combinazione | passa +5% | fallisce | stop 9,3% | peggior giorno | DD realizzato max | netto/anno | tagli Guardian (4 anni) |
|---|---|---|---|---|---|---|---|
| Reaper D9 | 5,3% | 0 | 0 | -3.593 | 4.940 | 21.790 | 2 |
| + Goldbot PF525 | 13,7% | 0 | 0 | -4.341 | 6.366 | 32.883 | 4 |
| **Trio attuale** (+ Phantom PROPCOMBO D4) | **16,7%** | 0 | 0 | -3.713 (-4,64%) | 7.033 (8,8%) | 37.230 | 4 |
| Trio + GTP COMBO | 25,9% | 0 | 0 | -3.794 | 8.152 (10,2%) | 48.174 | 5 |
| Trio + GTP PROP (R1) | 31,0% | 0 | 0 | -3.899 | 9.296 | 61.657 | 6 |
| Reaper D9 + PF525 + Phantom LOWRISK_D10 | 22,5% | 0 | 0 | -3.822 | 8.326 | 44.566 | 4 |
| Reaper D9 + PF525 + Phantom MEDIUM_D30 | 40,5% | 0 | 0,6% | -3.790 | 12.323 (15,4%) | 74.660 | 10 |
| DD12 + PF105 + Phantom MEDIUM_D30 + GTP PROP | 49,4% | 0 | 2,6% | -3.962 | 16.500 (20,6%) | 119.246 | 24 |
| DD12 + LOW3 + MEDIUM_D30 + GTP PROP (miglior passaggio) | 51,2% | 0,6% | 3,7% | -4.081 | 17.492 | 136.420 | 29 |
Senza Guardian il fallimento (giorno -5% o totale -10%) sale: trio 1,9%, trio + COMBO 2,9%, D9+PF525+MEDIUM_D30 4,1%, le combinazioni aggressive 7-15%.
Il trio attuale per anno (fallimento B): 0% in tutti e 4.

## Cosa dice
- Con il Guardian (modello B) il tasso di fallimento e **0% per 318 combinazioni su 1.152**, compreso il trio attuale e il trio + GTP COMBO. Con il modello A e 0% per tutte e 1.152. Il Guardian fa il lavoro pesante, come diceva Claudio; la stima resta approssimata.
- Il problema del trio, in questa misura, non e il rischio ma il **tempo**: in 14 giorni tocca +5% nel 16,7% dei casi (83% delle finestre scade senza raggiungerlo). Il GTP COMBO porta il passaggio al 25,9% senza aumentare il fallimento (con Guardian).
- Le combinazioni con piu passaggio (40-50%) usano set piu aggressivi (Phantom MEDIUM_D30, Reaper DD12/DD15, GTP PROP, Goldbot LOW3): hanno DD realizzato 12-17k (15-21% di 80.000, anche con il taglio giornaliero), 10-29 tagli del Guardian in 4 anni e il 1-4% delle finestre arriva allo stop al 9,3%.
- Il GTP peggiora il fallimento (modello B) nel 68% delle coppie con/senza GTP (650 su 960): peso piccolo in valore assoluto (valori vicini a 0).

## Previsioni vs realta
K1 trio con fallimento >0 sui 4 anni (75%): **NO** (0% con Guardian; 1,9% senza). K2 modello A <= B in almeno meta delle combinazioni (80%): SI (1.152 su 1.152; A < B in 834). K3 esiste una combinazione con fallimento 0 e passaggio >= 40% (45%): SI (64). K4 GTP peggiora il fallimento in piu del 60% delle coppie (70%): SI (68%). K5 la combinazione con piu passaggio contiene Reaper D9/DD9 (35%): **NO** (DD12). K6 il fallimento del trio e tutto nel 2013 (60%): **NO** (0% in ogni anno con Guardian).

## Cosa NON dice
Che il Guardian regga uno spike dell'oro del 2013 (reazione al secondo non simulata); che le regole FTMO siano quelle supposte; che una combinazione piu aggressiva sia adatta: e una scelta di rischio di Claudio. Nessuna taglia proposta.
