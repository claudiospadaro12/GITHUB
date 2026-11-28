# Sala del Consiglio sul Pine "Bulge Signals FILTRO R/R" - RISULTATI (28/11/2026) - CESTINO DEFINITIVO
Criteri: `BULGE_SALA_CRITERI_2026-11-28.md`. Script `backtest_runner/simulatore/bulge_sala.py`. 39.474 segnali grezzi su 10 cross H1 2005-26, ogni segnale = un trade, R = risultato/distanza stop. Costo A = spread reale per coppia + 0,2 pip (costo medio 0,027R), B = 0,02% per lato (come il 24/11).
## Autopsia del codice (Auditor)
- E' un INDICATORE: nessun PF in TradingView; senza uscite non esiste backtest. Stop e target sono solo etichette.
- Nessun bug di indicizzazione: `isBulge[1]`/`close[1]` coerenti. Segnale sulla chiusura della barra di rientro: in TradingView `buySignal`/frecce possono comparire e sparire sulla barra in corso (nessun `barstate.isconfirmed`); l'alert e sicuro solo con "una volta a chiusura barra". Ingresso reale all'apertura della barra dopo (nei test).
- Il filtro R/R: stop = (minimo - 3 ATR) quindi rischio grande; R/R >= 1,5 quasi mai vero. Il 24/11 con minRR 1,5 restavano 122 segnali su 36.861 (0,3%): NON rispetta una ritenzione 70-85%. Entro la ritenzione (minRR <= 0,3 = 88%) il PF e 0,80.
- Limite etichette: default 50 (aggiungere `max_labels_count=500` per non perdere le vecchie).
## Misure (Quant)
- Uscite (18 combinazioni stop 1,5/3 ATR, target mediana/1R/1,5R, breakeven, trailing): PF IS/OOS modello A da 0,75/0,79 a 0,95/0,90 (migliore stop 3 ATR, target 1,5R, senza BE). Breakeven e trailing PEGGIORANO (0,83-0,86). Anni positivi 0-14%.
- Lordo senza costi: PF 1,01 IS / 0,98 OOS, media -0,004R: nessun vantaggio nemmeno prima dei costi. Il costo medio (0,027R) basta a portarlo sotto 1.
- REVERSE (direzione opposta): netto 0,95-0,97 IS / 0,88-0,95 OOS, lordo 1,02/1,03 (+0,012R medio, inferiore ai costi 0,033R): il segnale non sbaglia in modo sistematico, e rumore.
- Micro-filtri (ritenzione 89-94%): PF IS/OOS 0,95-0,97 / 0,91-0,92, praticamente uguale.
## Verdetto (Giudice): CESTINO DEFINITIVO
Nessuna combinazione supera PF 1,0 con ritenzione >= 75% (migliore netto 0,95 IS / 0,90 OOS; target 1,35 irraggiungibile). Il lordo e 1,0: nessun margine da recuperare. Costi A e B danno lo stesso esito (il modello B peggiora fino a 0,64-0,86). Idoneita prop non valutata (nessun PF da proteggere). Il Pine resta utile solo come indicatore per la lettura discrezionale (con il diario degli avvisi), non come strategia. Non riscrivo il Pine: nessun upgrade e giustificato dai dati.
Nota di metodo: i test non coprono 27 cross e M15 (solo 10 cross H1 con dati) ne l'ingresso intrabarra; non cambiano la conclusione sul lordo 1,0.
