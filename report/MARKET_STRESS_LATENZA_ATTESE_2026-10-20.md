# Stress del costo, parte 2: esecuzione RITARDATA nel tester -- previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** La parte 1 (analitica, `MARKET_STRESS_COSTO_LETTURA_2026-10-20.md`) ha aggiunto un costo fisso per operazione. Non vede la latenza: l'ordine parte, il prezzo si muove, l'esecuzione e' peggiore. Il tester ha `ExecutionMode` (ritardo in millisecondi; in repo e' la chiave usata da `walkforward_generico.ps1 -Ritardo`, scala 0/50/100/500 ms); finora tutti i giri del Market sono a `ExecutionMode=0` (nessun ritardo).

## Cosa si fa
Per Prop Firm Gold EA e Smart Gold Hunter, due corse continue 01/01/2025 - 01/10/2026 (XAUUSD H1, 5.000 EUR, ticks reali, input NON imposti, da confrontare con la corsa base): **ritardo 200 ms** (TRANCHE1) e **ritardo 1000 ms** (TRANCHE2). Il riferimento e' la corsa a 0 ms gia' fatta (Prop Firm +1.591 / PF 1,26 / 673 op.; Smart Gold Hunter +276 / PF 1,74 / 237 op.).
## Soglia (invariata, scritta il 19/10)
Con il costo stressato l'EA resta candidato solo se netto > 0 e PF > 1,10. Qui lo stress e' la latenza: **1000 ms** e' la corsa che decide; 200 ms e' il caso realistico di un VPS.
## Previsioni dichiarate ORA
- **L1**: Prop Firm a 1000 ms: netto **entro -20% / +10%** del base (tenuta media di 8 ore: poco sensibile), PF > 1,10, stesse operazioni +/-5%.
- **L2**: Smart Gold Hunter a 1000 ms: netto **positivo** ma **piu' basso di almeno il 15%** del base (ordini pendenti con TP 250 / SL 500 punti e trailing 100/50: piu' sensibile), PF > 1,10. Fiducia media.
- **L3**: a 200 ms entrambi entro il 10% del base.
- **L4**: nessuno stop-out e nessun "no money" in nessuna delle quattro corse.
- Se `ExecutionMode` non viene applicato (i risultati risultano identici al centesimo al base a 0 ms), lo scrivo cosi': vuol dire che il tester ignora la chiave con questi EA o che il ritardo non cambia nessun prezzo, e il test non e' una prova di robustezza.
- Il valore esatto dell'`ExecutionMode` nel report non e' stampato: [NON VERIFICATO] che 200/1000 sia applicato come ms su questo MT5; lo si verifica dal confronto dei numeri e dal giornale del tester.
