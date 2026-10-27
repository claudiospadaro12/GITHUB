# My AI Gold con 8 set nei tre mercati: RISULTATI (27/10/2026)
**Natura: LETTURA. Non controllata da agenti.** Zip `ANNO80K_MYAI_20261027_0652` (40 passate della riga `RIGA_LANCIA_MYAI_GOLD_80K.txt`, pin 3e43646d). Criteri e previsioni scritti prima: `MY_AI_GOLD_SET_TRE_ANNI_CRITERI_2026-10-26.md`. Lettore `leggi_tre_anni_80k.py` (corretto: nella ricerca del riferimento Modello 4 prendeva anche lo zip accanto alla cartella). 80.000 EUR, XAUUSD H1, input imposti: solo balance (+ FrHour 22, news 60/60 per PROPX9).

## Esito: nessuno degli 8 set supera PROP-ANNI
Netto (EUR) / DD equity (EUR) per anno; 2025 = calibrazione, riportato il Modello 4 (tick reali). `no money` = ordini rifiutati per margine insufficiente.
| set (balance) | lotto a 80k | 2013 | 2018 laterale | 2020 rialzo | 2025 (M4) | peggior giorno 2018 / 2020 |
|---|---|---|---|---|---|---|
| AGGRESSIVE 100 | 8,0 | NON MISURATO | -30.487 / 45.952 (3 ops, 474 no money) | -8.861 / 45.403 | -23.795 / 42.593 | -43,8% / -35,7% |
| HIGHRISK 250 | 3,2 | NON MISURATO | -58.659 / 61.379 | -40.996 / 112.859 | -46.184 / 74.669 | -38,8% / -41,3% |
| NORMAL 500 | 1,6 | NON MISURATO | -50.078 / 58.727 | +231.911 / 76.592 | +151.700 / 52.819 | -22,0% / -20,6% |
| LOWRISK 750 | 1,07 | NON MISURATO | -35.717 / 42.406 | +120.852 / 36.370 | +87.205 / 27.441 | -13,2% / -14,0% |
| CONSERVATIVE 1000 | 0,8 | NON MISURATO | -27.489 / 32.873 | +80.581 / 22.962 | +60.169 / 19.514 | -9,8% / -10,5% |
| **PROPFTMO 1500** | 0,53 | NON MISURATO | -18.953 / 22.811 | +47.491 / 12.739 | +36.616 / 12.196 | -6,6% / -7,1% |
| GUIDA2000 2000 | 0,4 | NON MISURATO | -14.351 / 17.360 | +33.740 / 8.716 | +26.574 / 8.944 | -5,0% / -5,3% |
| **PROPX9 2500** | 0,32 | NON MISURATO | -11.586 / 13.997 | +26.062 / 6.704 | +20.862 / 6.911 | -3,9% / -4,3% |
Nessuno stop out del tester in nessuna passata (le perdite grandi di AGGRESSIVE/HIGHRISK sono posizioni bloccate da ordini rifiutati per margine).

## Letture
1. **Il 2018 (laterale) e negativo per TUTTI gli 8 set**, con le stesse 42 operazioni e lo stesso PF 0,43 per i set da balance >= 500: i set differiscono solo per la dimensione, quindi nessuna scelta di balance puo rendere positivo il 2018. Il DD del 2018 scala circa inverso con balance: per stare sotto 8.000 EUR servirebbe balance circa 4.400 (stima: 13.997 x 2500/8000), e il netto resterebbe negativo (circa -6.600).
2. **2020 e 2025 (rialzo) sono positivi** per balance >= 500 ma il DD e alto: PROPFTMO 12.739 e 12.196 (circa 15-16% di 80.000), sopra il tuo limite di 8.000. Solo GUIDA2000 e PROPX9 stanno sotto o vicino a 8.000 nei due anni di rialzo (8.716-8.944 e 6.704-6.911).
3. **Il 2013 non e misurato per nessun set**: ZERO operazioni in tutte e 8 le passate. Il giornale mostra che nel 2013 il tester ha caricato solo XAUUSD H1 (storico dal 2012) e nessun altro simbolo ne timeframe, mentre nel 2018 ha caricato EURUSD e le barre M1/M15/M30/H4/D1. Causa (probabile mancanza di dati che l'EA richiede nel 2012-2013): NON VERIFICATA.
4. **PROPX9 contro GUIDA2000**: stesse operazioni (42, 164, 203) e netti in rapporto 0,77-0,81 (circa 2000/2500 = 0,8): nel tester il filtro news acceso e la chiusura del venerdi alle 22 non cambiano nulla (il filtro news non e simulabile). Il vantaggio di PROPX9 rispetto a PROPFTMO nel tester e solo la dimensione piu piccola.
5. **Calibrazione Modello 1 / tick reali OK per 6 set su 8** (rapporto 1,02, correlazione 1,00), non attendibile per AGGRESSIVE e HIGHRISK (ordini rifiutati). Per questo EA (circa 200 operazioni l'anno) il Modello 1 e affidabile.
6. Per una challenge FTMO (obiettivo +10%, perdita massima 10%): PROPX9 in un anno di rialzo fa +26/+33% con DD equity 8,4-8,6% ma nel laterale 2018 perde 14,5% con DD 17,5%: il limite del 10% sarebbe violato. Un anno solo di laterale e un campione, ma 7 anni su 20 dal 2006 sono laterali (regimi in `TRE_ANNI_REGIMI_5K_RISULTATI_2026-10-26.md`).

## Previsioni contro esito
M1 (aggressive e highrisk oltre 8.000 DD o stop out in un anno) 90%: SI. M2 (PROPFTMO PROP-ANNI) 30%: NO. M3 (PROPX9 PROP-ANNI) 40%: NO. M4 (almeno un set PROP-ANNI) 55%: NO. M5 (calibrazione OK per almeno 5 su 8) 55%: SI (6 su 8). M6 (un set con netto negativo nel 2013) 60%: NON VALUTABILE (2013 assente). M7 (PROPX9/GUIDA2000 entro +-25% di 0,8) 65%: SI. M8 (DD equity PROPFTMO oltre 8.000 nel peggior anno) 50%: SI (22.811).

## Cosa NON dice
Un percorso per anno e un solo anno laterale; 2013 mancante; Recovery attivo (default installato) mai spento; AutoGMT e filtro news non verificabili sul tester; il MaxCountOrders=1 del set PROPX9 non esiste nella versione installata (puo cambiare le operazioni in anni con piu posizioni); a 5.000 EUR il lotto 0,02 (balance 2500) e coarse: i percentuali non si scalano esattamente. Nessun giudizio su acquisto, lotto o taglia.
