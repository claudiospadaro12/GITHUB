# Gold Reaper con MaxAllowedDD 6 / 9 / 12 / 15: CRITERI e PREVISIONI (28/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (28/10): "la riga del Reaper con MaxAllowedDD diversi". Riga `RIGA_LANCIA_REAPER_MAXDD_80K.txt` (generatore `gen_riga_reaper_maxdd_80k.py`, pin 3e43646d, script ANNO80K v5), 18 passate, 80.000 EUR, XAUUSD H1.

## Perche
Il Reaper dimensiona il lotto da `MaxAllowedDD` (con 0 il lotto cade a 0,01: 27/10). Il set prop e 9. Non sappiamo come cambiano rendimento, DD di equity, giorno peggiore e tempo di una challenge con altri valori: ipotesi non verificata che il lotto sia proporzionale. Il limite giornaliero interno resta acceso (4%).

## Passate
Input fissi: `TradeFrequency=2`, `PropFirmMaxDailyDD=4.0`, `OnlyUp=false`; cambia solo `MaxAllowedDD` in {6, 9, 12, 15}. 16 passate a Modello 1 (2013, 2018, 2020, 2025: 12 mesi) per ogni valore, poi 21 mesi a tick reali (01/01/2025-01/10/2026) per 12 e 15. Il 9 e il controllo: riferimenti `GR80K_20261020` (21 mesi +59.796, DD equity 3.854) e `ANNO80K_TRE_EA_ZIP_1444` (2013 +21.757 / 2018 +13.535 / 2020 +20.388).

## Lettura
Per ogni valore: netto, PF, DD equity, stop out, giorni con perdita realizzata >= 3/4/5%, peggior giorno, lotto medio/min/max, posizioni insieme, giorni di calendario per +8.000 e poi +4.000 da conto nuovo (metodo dei tempi del 28/10), PROP-ANNI con `leggi_tre_anni_80k.py` (la calibrazione si misura solo dove c'e il Modello 4: 12 e 15; per 6 e 9 il riferimento e quello del set 9).

## Criteri
PROP-ANNI: netto > 0 in 2013, 2018, 2020; DD equity <= 8.000; nessuno stop out; nessun giorno con perdita realizzata >= 5%; calibrazione 2025 OK (dove misurabile).

## Previsioni dichiarate ORA
- K1: il lotto medio cresce in modo quasi proporzionale a MaxAllowedDD: lotto medio a 12 fra 1,2 e 1,45 volte quello a 9; a 15 fra 1,5 e 1,9 volte; a 6 fra 0,55 e 0,8 volte: 60%.
- K2: il 9 riproduce i riferimenti (stesso numero di operazioni e netto entro +-1%): 90%.
- K3: DD equity dei 21 mesi a 15 fra 4.500 e 8.300 (lineare: 3.854 x 15/9 = 6.400): 55%.
- K4: DD equity del 2013 a 15 supera 8.000 (lineare: 5.621 x 15/9 = 9.370): 75%.
- K5: PROP-ANNI passa per 6: 90%; per 12: 50%; per 15: 20%.
- K6: almeno un giorno con perdita realizzata >= 5% in uno dei 4 anni a 15: 65%; a 12: 40%; a 9: 10%.
- K7: netto(15) / netto(9) nel 2025 M1 fra 1,3 e 1,9: 60%.
- K8: giorni per +8.000 da conto nuovo (2025 M1) a 15 sotto 70 (lineare 112 x 9/15 = 67): 50%; a 6 sopra 150: 60%.
- K9: il limite giornaliero (4%) interviene (operazioni diverse dal 9 nello stesso anno, oltre a quanto gia visto il 23/01/2013) in almeno uno fra 2018, 2020 e 2025 a 15: 50%.

## Cosa NON dice
Un percorso per anno; Modello 1 per i tre anni vecchi; 2013/2018/2020 probabilmente dentro l ottimizzazione del venditore; nessuna slippage, filtro news non simulato; orologio AutoGMT non verificato; lotto e DD possono non scalare in modo lineare (arrotondamento dei lotti, limite giornaliero); margine con leva FTMO non simulato dal tester (con 1:9 sull oro il margine del Reaper supera gia il conto a 9). Nessun giudizio su acquisto, lotto o taglia.
