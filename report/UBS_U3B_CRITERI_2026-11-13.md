# UBS U3b: il margine di sicurezza sul DD misurato, fuori periodo — CRITERI e PREVISIONI (13/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, riga NON ancora lanciata.** Segue `RISULTATI_UBS_U3T_2026-11-13.md`: nel doppio incrocio fuori periodo (misura su un periodo, prova sull'altro) il DD% della prova e risultato circa 2 x (DD01 del periodo di prova / DD01 del periodo di misura) x un fattore 0,98-1,44: 9 casi su 18 PRECISI (1,5-2,5%), 4 casi sopra il 3% (massimo 8,84% su Goldbot dailyC). Wim suggerisce di arrotondare IN SU il DD misurato (lot size step). U3b misura se un cuscinetto lo fa. Solo tester; reale, trial FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti.

## Cosa si testa
Stessi 9 set, stessi due incroci e stessi periodi di U3 tappa 2 (X: misura 2013-2018, prova 2019-2025; Y: misura 2019-2025, prova 2013-2018), stessi input (`Risk=123`, `MaxRiskPerStrategy_Value=2.0`, `AdjustLotsizeToVariableValues=true`). **Unica differenza**: `HistoricalMaxDD` = DD01 dell'altro periodo x 1,15 (cambio) **x 1,5 (cuscinetto)**, cioe il lotto e circa 1/1,5 di quello di U3 (arrotondato a 0,01 lotti). 18 passate, stessa riga di U3T con valori diversi (circa 1-3 ore).

## Misure
Per passata: DD equity % del deposito (confronto con la stessa cella di U3T), netto, PF, lotto medio e massimo, peggior giorno. Per il confronto: rapporto netto U3b / netto U3T e DD% U3b / DD% U3T.

## Regole di lettura (fissate ora)
- **Validita**: come U3 (deposito 100.000, qualita >= 95%, nessuno stop out/no money, input imposti confermati dal report e tutti gli altri uguali al set).
- **Casi contenuti** = DD% <= 2,5; **casi lontani** = DD% > 3,0 (sotto 1,0 non e un difetto: e prudenza, ma si segnala).
- **Verdetto del cuscinetto**: **UTILE** se i casi contenuti sono almeno 15 su 18 e il massimo DD% e <= 4,0%; **PARZIALE** se i contenuti sono 13-14 o il massimo e > 4,0%; **INUTILE** se i contenuti sono meno di 13. Per confronto in U3T i casi contenuti erano 11 su 18 e il massimo 8,84%.
- Se UTILE o PARZIALE si legge anche il costo: quanto scende il netto rispetto a U3T.

## Previsioni dichiarate ORA (non misurate)
- **U3b-1** Almeno 16 passate su 18 valide: 90%.
- **U3b-2** Casi contenuti (DD% <= 2,5) in almeno 15 su 18: 55%.
- **U3b-3** Massimo DD% sopra 4,0 (il caso Goldbot dailyC a 3,08 volte): 70%.
- **U3b-4** Goldbot dailyC incrocio Y ancora sopra 3,0%: 85%.
- **U3b-5** DD% mediano fra 1,4 e 1,9: 65%.
- **U3b-6** Mediana del rapporto netto U3b / netto U3T fra 0,55 e 0,80: 75%.
- **U3b-7** Verdetto: UTILE 25%, PARZIALE 50%, INUTILE 25%.

## Limiti
Un percorso per set; lotto arrotondato a 0,01 (set con lotto piccolo, come Reaper s1 D1 e Phantom strat8, possono non scalare con proporzione); il DD cresce col saldo (compounding): la relazione non e esattamente lineare; solo due periodi (2013-18 e 2019-25); cambio EUR/USD 1,15 ipotesi; Modello 1.
