# Gold Reaper con MaxAllowedDD 6 / 9 / 12 / 15: RISULTATI (29/10/2026)
Criteri e previsioni scritti prima: `REAPER_MAXALLOWEDDD_CRITERI_2026-10-28.md`. Fonte: zip `ANNO80K_REAPER_MAXDD_20261029_0416` (riga `RIGA_LANCIA_REAPER_MAXDD_80K.txt`, pin 3e43646d; archivio `backtest_pipeline/risultati_archivio/ANNO80K_REAPER_MAXDD_20261029_0416`). Lettori: `leggi_tre_anni_80k.py` (esiti), lotti e giorni per gli obiettivi dalle liste affari (conti da conto nuovo, +8.000 poi +4.000 dal primo giorno). Non controllata da agenti. 80.000 EUR, XAUUSD H1, set prop: `TradeFrequency=2`, `PropFirmMaxDailyDD=4`, `OnlyUp=false`.

**Validita:** 18/18 passate OK, `input_ok = si`. **Controllo MaxAllowedDD=9 riprodotto**: 2013 +21.757 (509 operazioni), 2018 +13.535 (548), 2020 +20.388 (460), identici ai riferimenti del 26/10.

## Netto, DD equity e giorno peggiore (Modello 1, un anno ciascuno)
| MaxAllowedDD | 2013 | 2018 | 2020 | 2025 (12 mesi) |
|---|---|---|---|---|
| **6** | +12.704 / DD 4.831 / -4,5% | +8.952 / 3.584 / -1,4% | +13.132 / 2.402 / -1,1% | +18.903 / 1.814 / -0,7% |
| **9** | +21.757 / 5.621 / -4,6% | +13.535 / 5.504 / -2,2% | +20.388 / 3.839 / -1,6% | +30.457 / 3.077 / -1,1% |
| **12** | +32.047 / **8.728** / -4,9% | +12.481 / **8.438** / -3,7% | +28.152 / 5.496 / -2,2% | +43.127 / 4.559 / -1,5% |
| **15** | +38.600 / **11.622** / **-6,1%** (1 giorno >= 5%) | +13.104 / **9.928** / -4,4% (484 righe "no money") | +36.414 / 7.391 / -2,7% | +42.252 / 5.491 / -4,2% |
(netto in EUR / DD equity in EUR / peggior giorno realizzato). **A tick reali, 21 mesi:** MaxAllowedDD 9 (riferimento del 20/10) +59.796, DD 3.854; **12: +89.611 (+112%), PF 2,92, DD equity 6.074, peggior giorno -1,7%; 15: +102.211 (+127,8%), PF 2,67, DD equity 7.968, peggior giorno -4,0% (1 giorno >= 4%)**. Calibrazione 2025 OK per 12 (rapporto 1,07, correlazione 0,99) e 15 (1,09, 0,98).

## Esito PROP-ANNI (netto > 0, DD equity <= 8.000, nessuno stop out, nessun giorno >= 5% realizzato)
**6: i tre anni passano** (calibrazione non misurata a tick reali per 6 e 9: il lettore scrive "non valutabile"; per il 9 e stata OK il 26/10). **9: passa** (riferimento). **12: NON passa** (DD equity 8.728 nel 2013 e 8.438 nel 2018, di poco sopra 8.000). **15: NON passa** (DD 11.622 e 9.928, e un giorno -6,1% nel 2013).

## Lotti (media per ingresso; rapporto rispetto a MaxAllowedDD 9)
2013: 0,277 / 0,444 / 0,634 / 0,812 (x0,62 / x1 / x1,43 / x1,83); 2018: 0,248 / 0,382 / 0,509 / 0,625; 2020: 0,188 / 0,298 / 0,418 / 0,550; 2025: 0,095 / 0,153 / 0,215 / 0,259. **Il lotto scala quasi in proporzione a MaxAllowedDD** (x0,62-0,65 a 6, x1,33-1,43 a 12, x1,64-1,85 a 15). Ma **il netto non scala in proporzione e si ferma**: 2018 il 15 rende +13.104, meno del 9 (+13.535); 2025 il 15 rende +42.252, meno del 12 (+43.127); il DD cresce piu del netto (2013: DD 15 = 2,07x quello del 9, netto 1,77x).

## Giorni da conto nuovo per +8.000 / poi +4.000 (calendario)
| MaxAllowedDD | 2013 | 2018 | 2020 | 2025 (M1, 12 mesi) |
|---|---|---|---|---|
| 6 | 174 / 120 | 350 / 197 | 189 / 51 | 139 / 105 |
| 9 | 120 / 91 | 236 / 176 | 51 / 48 | 110 / 92 |
| 12 | 96 / 53 | 197 / 138 | 51 / 23 | 105 / 86 |
| 15 | 96 / 90 | 197 / 141 | 48 / 7 | 133 / 110 |

## Contro le previsioni (scritte prima)
K1 (lotto proporzionale a 12 / 15 / 6): **SI** (tutte e 4 le serie dentro gli intervalli). K2 (il 9 riproduce i riferimenti): **SI**. K3 (DD 21 mesi a 15 fra 4.500 e 8.300): **SI** (7.968). K4 (DD 2013 a 15 > 8.000): **SI** (11.622). K5 (PROP-ANNI: 6 si 90%, 12 al 50%, 15 al 20%): **6 si (calibrazione non misurata), 12 NO, 15 NO**. K6 (giorno >= 5% a 15 in un anno: 65%; a 12: 40%; a 9: 10%): **a 15 SI (2013), a 12 NO, a 9 NO**. K7 (netto 15 / netto 9 nel 2025 fra 1,3 e 1,9): **SI** (1,39). K8 (giorni per +8.000 a 15 sotto 70; a 6 sopra 150): **NO e NO** (133 giorni a 15, piu lento del 9; 139 a 6). K9 (il limite giornaliero interviene a 15 in 2018/2020/2025): **NON SEPARABILE**: le operazioni a 15 sono diverse da quelle a 9 (2018 533 contro 548, 2025 491 contro 497, anche 2013 510 contro 509 e 505 a 12), ma nel 2018 ci sono 484 righe "no money" (margine) e non si distingue la causa.

## Cosa significa e cosa NO
- Con questo set e questa finestra, **MaxAllowedDD 9 e il valore piu alto che resta dentro 8.000 in tutti e tre gli anni**; il 12 sfora di poco (2013 e 2018), il 15 di piu e con un giorno oltre il 5% di FTMO.
- **Il tempo per la challenge non migliora in proporzione al lotto**: nel 2025 il 12 e solo 5 giorni piu rapido del 9 per +8.000, il 15 e piu lento; nel 2018 il 12 e il 15 sono uguali (197). Nel 2020 (rialzo) il 15 chiude la fase 2 in 7 giorni, ma e un solo anno favorevole.
- Un solo percorso per anno; Modello 1 per i tre anni vecchi (2013/2018/2020 probabilmente dentro l'ottimizzazione del venditore); nessuna slippage; filtro news non simulato; tester senza leva FTMO (con leva 1:9 sull'oro il margine supera il conto gia a 9); il 2018 a 15 e limitato dal margine del tester. Nessun giudizio su acquisto, lotto o taglia.
