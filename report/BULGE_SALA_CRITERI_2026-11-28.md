# Sala del Consiglio sul Pine "Bulge Signals FILTRO R/R" - CRITERI (scritti prima dei numeri, 28/11/2026)
Codice: quello incollato da Claudio (indicatore, non strategia: nessun PF in TradingView; il PF si misura con la nostra replica `pine_bulge_fasciano.py` `prep()`, regole identiche: Bollinger 20/2, bulge = larghezza > 1,12 x media(20), BUY/SELL al rientro, stop = estremo +/- 3 ATR(14), target = mediana).
Dati: forex H1 BCM 10 cross 2005-2026 (`/tmp/claude-0/fxh1`), IS 2005-2015 / OOS 2016-2026. Ogni segnale e un trade (sovrapposizioni permesse), ingresso all'apertura della barra dopo il segnale, in R (risultato / distanza stop). In stessa barra vale lo stop (prudente).
Costo: MODELLO A realistico = spread per coppia (EURUSD 0,8 pip ... GBPJPY 2,8 pip, tabella di `bb_v42_port.py`) + 0,2 pip; MODELLO B come i test del 24/11 = 0,02% per lato (4 pip su EURUSD: probabilmente troppo alto, mostrato per confronto).
## Interventi (max 3, ritenzione segnali >= 75%)
1. USCITE (ritenzione 100%): stop 1,5 o 3 ATR; target mediana / 1R / 1,5R; breakeven a +1 ATR; trailing 2 ATR dopo il BE; uscita a tempo 40 barre. 18 configurazioni.
2. REVERSE: stessa entrata, direzione opposta, stop 1,5/3 ATR, target 1R/1,5R (4 celle).
3. MICRO-FILTRI (tagliano <= 20%, scelti sull'IS, giudicati sull'OOS): ore 22-23 server (spread/rollover); segnali con larghezza banda/ATR nel decile piu alto.
## Cancelli (non abbassati)
Candidata se PF IS >= 1,25 e PF OOS >= 1,15 (cancello della routine; target di Claudio X non indicato: se X=1,35 sara citato), >= 60% anni positivi, PF con costo x2 > 1,0 e ritenzione >= 75%. Soglie non cambiano dopo aver visto i risultati.
Previsione scritta: 0 candidate; le uscite miglioreranno il PF di 0,05-0,10 ma il PF restera sotto 1 (il test del 24/11 ha dato 0,74-0,85 su 27.000 operazioni). Il modello A potrebbe alzare il PF sopra 0,85 perche i costi del 24/11 erano alti.
