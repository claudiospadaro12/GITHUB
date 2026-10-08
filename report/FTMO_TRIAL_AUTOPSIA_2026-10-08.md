# Trial FTMO 1514806751 -- autopsia a freddo (08/10/2026)

Fonte: `data/statements/ReportHistory_trial_1514806751_2026-10-08.xlsx` (23 posizioni chiuse, 01-06/10) + schermate FTMO del 08/10 08:10 + `ABTG_Guardian.mq5` r.734-771. Sola lettura, nessun parametro toccato.

## Quadro FTMO (schermate)
Free Trial "In corso / Attivo", 01/10-14/10, conto 160.000. Equity 145.083,71. Perdita massima -14.916,29 (-9,3%) su limite -16.000 (muro a 144.000, margine **1.083,71**). Perdita giornaliera e giorni minimi OK. Obiettivo profitto +8.000: non raggiunto (servirebbero +22.916,29 da qui).

## Controprova dei conti
La somma di profitto+commissioni+swap delle 23 posizioni = **-14.916,29** (uguale a FTMO) e l'equity a fine sequenza = **145.083,71** (uguale al saldo FTMO).

## Chi ha perso (netto per famiglia, dal commento dell'ordine di apertura)
| famiglia | n | vinte | netto EUR |
|---|---:|---:|---:|
| DAX Apertura EU retest sell (GER40.cash) | 2 | 0 | -6.160,42 |
| Bulge v5.20 forex | 19 | 10 | -4.925,49 |
| MaxMin DAX short (770411, GER40.cash) | 1 | 0 | -3.292,52 |
| ORB Dow (US30.cash) | 1 | 0 | -537,86 |
Le tre posizioni su GER40.cash sono tre stop pieni (-3.292,52, -3.110,48, -3.049,94 = **-9.452,94, il 63% della perdita totale**), tutte e tre con il rischio per sedia a 2,00% (preset DAX, `PIANO_FREE_TRIAL_FTMO_2026-09-30.md`; il preset non riletto oggi). Il 01/10 due sedie DAX short sono state stoppate nella stessa mattina: -6.403,00 (4,0% di 160.000) -- il tetto per cluster (C2) e' firmato ma non attivo (CLAUDE.md, nota 12/09).

## Cosa ha fatto scattare il Guardian
Seguendo l'equity chiusura per chiusura: la prima chiusura sotto il pavimento del Guardian (145.120 = InpTotalDDPct 9,3% di 160.000) e' l'ultima, **USDCHF 06/10 11:07:52 (-333,19)**: 145.416,90 -> 145.083,71, 36,29 EUR sotto la soglia. Da li' `FlattenAll` + `GV_FAILED` + pausa 30 giorni: nessun ingresso dal 06/10 (ultimi ordini 06/10).

## Cosa NON si puo' concludere
- Campione: 4 posizioni su indici, 19 sul forex, in 6 giorni, **un solo regime** (settimana in cui il DAX e' salito contro gli short). Nessun verdetto sull'edge di nessuna sedia: sono "NON ANCORA MISURATO", non "morte" (certificato di morte del 09/09).
- Il Bulge forex ha 10 vinte su 19 e netto -4.925,49: da leggere sulle commissioni/stop (non misurato qui).
- I due conteggi giornalieri di FTMO (calendario vs riepilogo) hanno attribuzioni diverse per giorno ma lo stesso totale: causa non misurata.

## Decisioni di Claudio (non prese qui)
Lasciare il trial fermo fino al 14/10 oppure riattivare le sedie con il margine di 1.083,71 EUR dal muro: richiede una firma sui parametri di rischio (pavimento del Guardian e/o rischio per sedia). Su `C:\FTMO` non e' stato toccato niente.
