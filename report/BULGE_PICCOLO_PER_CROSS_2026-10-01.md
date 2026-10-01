# Bulge sul piccolo 50503392: i numeri per cross dal report MT5 del 01/10/2026

Fonte: `data/statements/ReportHistory_50503392_2026-10-01.xlsx` (posizioni dal 30/04 al 30/09; commento dal deal di ingresso; netto = profitto + commissioni + swap). **Versione VECCHIA del Bulge** (commento `BULGE_MULTI_SIGNAL_*`, difetto del primo tick, BLU e VIOLA insieme): 159 posizioni. Il v5.20 ha solo 10 posizioni (BLU 4 PF 0,11; VIOLA 6 su 6 vinte, +36,26): troppo poche per un numero.
**Cautela**: con 6-12 posizioni per cross il PF e' rumore (errore standard grande). Questa tabella NON e' una selezione di cross: e' la forma dei dati che R92b dovra' misurare su anni.

## Il totale
n 159 · win 69,8% · netto -448,01 · **PF 0,86** · vincita media 24,88 · perdita media 66,88 · payoff 0,372 · **win rate di pareggio 72,9%** contro 69,8% osservato (3 punti sotto).

## Per cross (n >= 6)
| Cross | n | win % | netto EUR | PF | vincita media | perdita media | win % di pareggio |
|---|---:|---:|---:|---:|---:|---:|---:|
| AUDCAD | 12 | 83,3 | 60,94 | 1,28 | 27,69 | 107,97 | 79,6 |
| EURGBP | 11 | 81,8 | 10,35 | 1,05 | 22,61 | 96,55 | 81,0 |
| GBPAUD | 9 | 77,8 | 11,89 | 1,06 | 32,41 | 107,50 | 76,8 |
| CADJPY | 9 | 77,8 | 28,39 | 1,43 | 13,49 | 33,02 | 71,0 |
| USDCAD | 9 | 77,8 | 38,20 | 1,30 | 23,49 | 63,13 | 72,9 |
| NZDCHF | 8 | 62,5 | -239,15 | 0,23 | 13,93 | 102,93 | 88,1 |
| GBPCAD | 8 | 62,5 | -3,44 | 0,97 | 26,13 | 44,70 | 63,1 |
| AUDUSD | 8 | 87,5 | 207,20 | 22,65 | 30,97 | 9,57 | 23,6 |
| CHFJPY | 8 | 62,5 | -44,20 | 0,75 | 25,97 | 58,02 | 69,1 |
| AUDJPY | 8 | 50,0 | -40,14 | 0,77 | 33,18 | 43,22 | 56,6 |
| USDCHF | 7 | 100,0 | 97,14 | nd | 13,88 | 0 | - |
| GBPNZD | 7 | 57,1 | -126,98 | 0,41 | 21,77 | 71,36 | 76,6 |
| EURNZD | 7 | 71,4 | 125,63 | 2,24 | 45,43 | 50,75 | 52,8 |
| NZDCAD | 6 | 66,7 | -66,48 | 0,61 | 26,42 | 86,08 | 76,5 |
| NZDUSD | 6 | 83,3 | 3,29 | 1,03 | 19,85 | 95,95 | 82,9 |
| GBPUSD | 6 | 100,0 | 166,53 | nd | 27,75 | 0 | - |
| AUDNZD | 6 | 33,3 | -299,00 | 0,10 | 17,46 | 83,48 | 82,7 |
| GBPJPY | 6 | 66,7 | 57,20 | 2,85 | 22,03 | 15,46 | 41,2 |

## Letture
1. **Il Bulge vince 7 volte su 10 e perde lo stesso**: serve il 72,9% per pareggiare e ne fa il 69,8%. La forma e' quella del payoff asimmetrico (vincita media 25, perdita media 67).
2. **I perdenti sono concentrati sui cross NZD**: AUDNZD (PF 0,10, -299), NZDCHF (0,23, -239), GBPNZD (0,41, -127), NZDCAD (0,61, -66). Sono 4 cross su 18 e valgono -731 EUR, piu' del totale (-448). E' un indizio, NON un criterio: n e' 6-8 per cross e la versione e' quella col difetto. **Quattro di questi cross sono nella lista dei 15 della trial** (AUDNZD, NZDCHF, GBPNZD, NZDCAD): per la regola dei 14 giorni non si cambia niente, ma e' una colonna da guardare nei primi risultati e da misurare in R92b (per cross, su anni).
3. I cross con le vincite migliori (AUDUSD, GBPUSD, USDCHF) hanno n 6-8: non e' un motivo per sceglierli.
4. **Cosa dovra' misurare R92b**: win rate per cross contro il win rate di pareggio per cross, su centinaia di operazioni; spread e commissione per cross; TP minimo contro costo.

## L'ORB Ottimizzato sul piccolo (commento `ORB OTT BUY`)
8 posizioni, tutte U30USD buy, 11/08-03/09: **7 perse** (da -19,98 a -50,91, ingressi 14:45-15:05) e 1 vinta (+76,66, 03/09 16:05). Netto -209,18. Il pattern e' quello del breakout subito dopo il range che rientra: coerente con "non ancora misurato", non dimostra niente sulla cella FTMO (orari e rischio diversi).

## L'oro senza commento (485 posizioni, -17.066,92)
E' un EPISODIO di giugno-luglio, non il presente: giugno -2.160, **luglio -14.907**; 51 posizioni il 16/06, 37 il 15/06, 34 il 30/06; lotti piu' frequenti 0,5 (232 posizioni), 1,0 (56), 3,0 (29 posizioni a 3 lotti); ora piu' frequente le 14 (85). Non e' di nessuna sedia attuale riconoscibile dal commento; da riconoscere con il magic (non presente in questo report). Nessuna posizione senza commento dopo luglio su XAUUSD in questo file.
