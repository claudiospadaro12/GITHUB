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

## AGGIORNAMENTO (28/11, screenshot di Claudio)
Lo screenshot e' la specifica di **BCHUSD** (Bitcoin Cash), non di BTCUSD, ma mostra la DEFINIZIONE del modo: "Tipo di swap: in termini percentuali, usando il corrente prezzo", swap long -30 e short -30, coefficienti lun-gio 1 e venerdi 3 (sab e dom 0), commissione 0,0325% per lotto (deals in/out, in EUR), margine 30% del nozionale. Il file delle specifiche dava lo stesso modo e la stessa cifra (-30/-30) per BTCUSD ed ETHUSD: quindi la lettura piu probabile e **-30% annuo sul valore al prezzo corrente, circa 0,08% al giorno (0,25% nel fine settimana)**, sia per i long sia per gli short. Il BTCUSD vero non e' stato fotografato: confermare se possibile.
Con swap 30% e costo 0,10% per operazione (commissione 2 x 0,0325% + spread): IS 2015-20 PF 5,72 (R +36,3), OOS 2021-23 1,54 (+4,2), HO 2024-26 **0,87 (-1,3 R)**; con costo 0,15% HO 0,86. L'uscita a tempo non aiuta (HO 0,87-1,00): 10 giorni 0,96, 20 giorni 0,94, 30 giorni 1,00, nessun limite 0,87.
**Verdetto: Bitcoin D1 su FTMO ESCLUSO dalla categoria B** (swap -30% annuo, ultimi 3 anni in perdita, 80 operazioni < 100). Le altre cripto FTMO hanno lo stesso swap (-30) e anche gli short pagano: sul FTMO le cripto a mantenimento di giorni non sono un'opzione; resterebbero solo operazioni nello stesso giorno (gia' chiuse: Bitcoin intraday) o un altro broker con swap cripto basso (NON misurato).
