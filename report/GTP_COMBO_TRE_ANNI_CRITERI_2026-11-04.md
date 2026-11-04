# Gold Trade Pro COMBO su 2013, 2018 e 2020: criteri e previsioni scritti PRIMA dei numeri (04/11/2026)
Richiesta di Claudio: "preparami la riga per il GTP COMBO sul 2013, 2018 e 2020". Origine: l'analisi del 29/10 (lavoro, `ANALISI_SET_BUNDLE_ORO_2026-10-29.md`) aveva solo una STIMA del COMBO (serie del PROP x 0,5): aggiungere il GTP al Reaper + Goldbot (+ Phantom) portava il giorno peggiore del 2013 a -7,1% / -7,6%. Il COMBO vero (rischio 0,5) e stato misurato solo su 2005-2012 e 2025 a tick reali. Non controllata da agenti.

## Passate (script ANNO80K v5, pin 3e43646d)
Quattro corse, XAUUSD D1, **Modello 1**, 80.000 EUR, `Gold Trade Pro MT5.ex5`, input COMBO: `Risk=3`, `MaxRiskPerStrategy=0,5`, `PropFirmMaxDailyDD=4,0`: anni **2013, 2018, 2020** (come per gli altri EA, PROP-ANNI) piu **2025** a Modello 1 per la calibrazione (il Modello 4 e gia stato letto: +8.667, DD 1.585).

## Criteri (PROP-ANNI, come per gli altri EA)
Validita: stato OK, `input_ok = si`, finestra dell'anno, stop out 0. Misure: netto, DD equity massimo, peggior giorno realizzato (in % di 80.000), operazioni, long/short. Passa se: netto > 0 in 2013, 2018, 2020; DD equity <= 8.000; nessun giorno realizzato >= 5% (4.000).
Seconda fase (dopo i numeri, dai deal): serie giornaliera del COMBO sommata alle serie di Reaper D9, Goldbot PF525 e Phantom D4 degli stessi anni (zip gia caricati), per vedere il giorno peggiore del trio con e senza GTP (realizzato; il flottante non c'e nei deal).

## Previsioni (probabilita)
- **H1** Le quattro corse valide: 85%.
- **H2** Netto positivo: 2013 60%, 2018 75%, 2020 85%.
- **H3** DD equity <= 8.000 in tutti e tre gli anni: 75%.
- **H4** Nessun giorno realizzato >= 4.000 del COMBO da solo: 85%; peggior giorno del 2013 <= 2,5%: 65%.
- **H5** Netto 2025 a Modello 1 tra 0,9 e 1,3 volte quello a tick reali (8.667): 65%.
- **H6** Il trio + GTP COMBO ha nel 2013 (realizzato) un giorno peggiore piu basso o uguale a quello del trio da solo di piu di 0,5 punti percentuali, cioe peggiora almeno di 0,5 punti: 45%.
- **H7** Il trio da solo supera il 5% di giorno peggiore nel realizzato in almeno un anno dei tre: 30%.

## Cosa NON dice
Modello 1 (barre da 1 minuto: sottostima i picchi intragiorno), un percorso per anno, set e anni da cui la stima del 29/10 era derivata, DD combinato senza flottante, il Guardian non e simulato. Nessun giudizio su acquisti, lotti o taglie; la composizione della Free Trial non cambia da sola.
