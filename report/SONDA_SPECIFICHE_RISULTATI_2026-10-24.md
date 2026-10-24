# Sonda delle specifiche dei simboli: risultati (24/10/2026)
**Natura: MISURA (lettura delle specifiche del server).** Pin `e9820bfe`, PC di backtest DESKTOP-H4D7CAJ, terminale `C:\Program Files\BCM Markets MT5 Terminal`, profilo `Default` con 0 EA attaccati, lettura sabato 24/10 alle 07:37 ora locale (mercato chiuso). Compilazione dello script: 0 errori, 0 avvisi (`compila_sonda_*.log`). Stato `ESEGUITO_OK`, 2 file su 2. Archivio: `backtest_pipeline/risultati_archivio/SONDE_SPECIFICHE_20261024`.

## A1: il pendente a 20 pip e' rifiutato? **COERENTE coi dati** (criterio congelato)
| Simbolo | StopsLevel | FreezeLevel | Distanza pendente (20 "pip") | Verdetto |
|---|---|---|---|---|
| U30USD | 5 | 0 | 20 punti | AMMESSO |
| D30EUR | 0 | 0 | 20 punti | AMMESSO |
| NASUSD | **100** | 20 | 20 punti | **RIFIUTATO** |
| 225JPY | **100** | 20 | 20 punti | **RIFIUTATO** |
| XAUUSD | **50** | 20 | 20 punti | **RIFIUTATO** (fuori dal criterio, stessa regola) |
Distanza in punti MT5: 20 "pip" = 0,20 di prezzo sugli indici a 2 cifre (20 point da 0,01) e 20 punti di prezzo sul Nikkei (point = 1), come `PipSize()` dell'EA.
- **Cosa spiega:** la gamba 2/3 mancante su Nasdaq 970913 (0 su 9 ingressi) e Nikkei 770924 (0 su 5), la gamba presente a +0,2 sul gemello DAX 970911 e sul Dow (StopsLevel 5/0), e il sospetto del giro 2 sull'oro: **SupertrendReversal_Ott 970901 e il suo BuyStop a 0,20 sull'oro** (0 gambe 2/3 su 6 segnali) hanno StopsLevel 50, quindi il pendente e' rifiutato dal server. Il server rifiuta l'ordine e l'EA non legge il retcode (r.291 del DAX, DICHIARATO dal revisore): rifiuto muto.
- **Effetto:** su Nasdaq, Nikkei e oro le sedie con questo schema entrano solo con la quota a mercato (1/3 del lotto): il rischio vero e' circa un terzo di quello dichiarato, come gia' si vedeva dal CSV (perdita peggiore -13,07 e -15,41).
- **Limiti:** specifiche di OGGI (non di agosto-settembre); lette a mercato chiuso; la metà "righe del Giornale Esperti" di A1 resta NON FATTA (i Giornali del VPS non sono raggiungibili da qui). Non e' una prova che il rifiuto avvenga in campo: e' il valore che il server dichiara.

## A2: soglia del pavimento del lotto. **Il criterio scritto prima aveva due errori** (vedi ERRATA nei criteri)
Tabella a posteriori (`sonda_spec_a2_post.py`), "punti indice" = 1,00 di prezzo, minimo/passo 0,10 su U30USD, NASUSD, D30EUR, 225JPY. Conversioni dalle stesse specifiche: 1 USD = 0,8927 EUR, 1 JPY = 0,005692 EUR.
| Simbolo | EUR per punto per lotto | Il pavimento morde con stop SOPRA (punti indice), saldo 5.344: rischio 1,0 / 0,65 / 0,5 / 0,3 / 0,25 |
|---|---|---|
| U30USD, NASUSD | 0,8927 | 599 / 389 / 299 / 180 / 150 |
| D30EUR | 1,00 | 534 / 347 / 267 / 160 / 134 |
| 225JPY | 0,0569 | 9.389 / 6.103 / 4.694 / 2.817 / 2.347 |
Con saldo 5.000 (cifra tua, NON VERIFICATA) le soglie sono circa il 6% piu' basse. Per oro e forex il lettore congelato e' corretto nelle unita' (point di MT5): oro (minimo 0,01) 5.986 / 3.891 / 2.993 / 1.796 / 1.497 point; AUDCHF 4.940 / 3.211 / 2.470 / 1.482 / 1.235; GBPUSD come l'oro; CHFJPY ed EURJPY 9.389 / 6.103 / 4.694 / 2.817 / 2.347 (per il saldo 5.344).
- **Lettura:** sul Dow, con rischio 1% e stop sopra circa 600 punti (SuperWave H2: stop 290-870) il lotto calcolato e' sotto 0,10 e il pavimento lo porta a 0,10; con rischio 0,65 la soglia scende a circa 390 punti. Questo e' coerente con il caso del 19/08 (770531, stop 422 punti, 0,10+0,10 lotti, -72,32). Sul Nikkei il pavimento non morde mai con gli stop tipici: i lotti 0,3-1,4 del forward lo confermano.
- **Valore del punto indice U30USD:** 0,8927 EUR per lotto, contro 0,8666 misurato sul CSV dal revisore (differenza circa 3%: cambio del momento e scarti di esecuzione, NON VERIFICATO).

## Scoreboard delle attese dichiarate prima
Sonda compila e parte 85%: SI. NASUSD StopsLevel > 20 45%: SI (100). 225JPY StopsLevel > 20 45%: SI (100). D30EUR StopsLevel <= 20 70%: SI (0). U30USD vol_min 0,10 85%: SI. Swap non zero sugli indici 80%: SI (U30USD -1,4/-1,15; modo di swap 5-6, interpretazione NON VERIFICATA).

## Cosa NON dice
Non dice che la gamba 2/3 sia rifiutata in ogni circostanza ne' che il rifiuto avvenga con i tick di agosto. Non dice quanti ordini il campo ha perso. Non cambia nessun set, sedia o rischio: sono decisioni di Claudio (per esempio se mettere il pendente fuori da 100 punti, se spegnere la gamba 2/3 dove e' rifiutata, o lasciare com'e').
