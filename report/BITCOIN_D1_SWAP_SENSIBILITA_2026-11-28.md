# Bitcoin D1 nostro: sensibilita allo swap (28/11/2026)
Regola: N 20 giorni, stop iniziale 3 ATR, chandelier 3 ATR, solo long, costo 0,05% per operazione, barre D1 da M1 FTMO 2015-2026 (`btc_d1_nostro.py`, replicata in `metalli_miglioramenti.py`). 80 operazioni (6,7 all'anno), 17 giorni medi in posizione.
Specifica FTMO (file `SWAPINFO_20261119/FTMO_PROVA_ABTG_SWAPINFO.csv`): modo "interesse % annuo sul prezzo corrente", swap long -30 e swap short -30. Se la cifra e davvero -30% annuo il costo e di circa 0,08% del valore al giorno; NON verificato con una posizione reale (la ricerca web non ha trovato le tariffe FTMO). BCM non offre BTC nella lista misurata.
| swap annuo | IS 2015-20 (n 37) | OOS 2021-23 (n 20) | HO 2024-26 (n 23) | tutto |
|---|---|---|---|---|
| 0% | PF 7,37 (R +42,5) | 2,00 (+6,9) | 1,24 (+2,1) | 3,29 |
| 10% | 6,79 (+40,5) | 1,84 (+6,0) | 1,11 (+1,0) | 3,02 |
| 20% | 6,26 (+38,5) | 1,70 (+5,1) | 0,99 (-0,1) | 2,78 |
| 30% | 5,78 (+36,5) | 1,56 (+4,2) | 0,89 (-1,2) | 2,55 |
| 40% | 5,33 (+34,4) | 1,43 (+3,4) | 0,79 (-2,3) | 2,34 |
Pareggio: swap di 46% annuo per il periodo 2021-26 (PF = 1,0); su tutto il periodo il PF resta > 1 anche con swap 100%.
Lettura: il vantaggio del Bitcoin trend e concentrato nel 2015-2020 (+40 R su 37 operazioni, 2017 compreso); dal 2021 in poi rende poco (+6 R in 3 anni, +1 R in 2024-26 a swap 10%). Se lo swap FTMO fosse -30% annuo gli ultimi 3 anni sarebbero in perdita (-1,2 R in 23 operazioni). A rischio 0,5% per R il contributo del Bitcoin al portafoglio negli ultimi 5 anni e di circa +0,4%/anno a swap 10% e negativo da 20% in su; il +1,7%/anno del portafoglio 2016-26 e dovuto soprattutto al 2016-2020.
Da fare per decidere: misurare lo swap REALE (specifica del simbolo con la definizione del modo, oppure una posizione demo tenuta 3 notti e lo swap letto nella cronologia, oppure risposta di FTMO), la correlazione con GoldenZoe (-0,01 mensile misurata) e ETH come secondo simbolo.
