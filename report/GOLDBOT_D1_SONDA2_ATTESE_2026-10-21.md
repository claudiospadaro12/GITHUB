# Goldbot One, sonda 2 dei metodi di lotto: previsioni scritte PRIMA dei numeri (21/10/2026)

**Non controllata da agenti.** Origine: la prima prova (`GOLDBOT_D1_LETTURA_2026-10-21.md`) ha dato lotto 0,01 fisso in ogni deal anche con Risk=0/1 e MaxRiskPerStrategy 3/6. Claudio ha mandato la scheda Input (campo `Lotsize calculation method` = `Risk` nel report, valore attuale "use StartLots") e le tre voci della tendina: **use StartLots, use Max Risk Per Strategy, use LotsizeStep** (ordine come da Claudio; che i valori numerici di `Risk` siano 0, 1, 2 in questo ordine e' un'IPOTESI [NON VERIFICATA]). Titolo della finestra: "Goldbot One MT5 3.3" contro 3.4 del Market [da verificare].
## Passate (XAUUSD D1, OHLC a 1 minuto, 01/01/2025-01/10/2026, 80.000 EUR, leva 1:100; il 21/10 T5 ha impiegato 3 minuti)
T1 Risk=1, MaxRiskPerStrategy=10; T2 Risk=1, MaxRiskPerStrategy=50 (valore estremo); T3 Risk=0, StartLots=0,08 (controllo a lotto fisso); T4/T5/T6 Risk=2 con LotPerBalance_step (= "LotsizeStep") 20000 / 10000 / 1000. Base di confronto: T5 del 21/10 (OHLC 1 min, lotto 0,01): 451 op, +1.675,28, PF 1,71, DD equity 0,80%.
## Previsioni
- **S1** tutti gli input imposti applicati: 85%.
- **S2** T3 (0,08 fisso): lotti tutti 0,08 e netto circa 8x quello di 0,01 (+-25%), operazioni entro +-5% di 451: 70%.
- **S3** Risk=2 con step 10000: lotto mediano fra 0,06 e 0,10; step 20000 meta' del precedente; step 1000 circa 0,6-1,0: 60% (ipotesi sull'ordine della tendina).
- **S4** Risk=1 con MaxRiskPerStrategy 10 e 50: lotti ancora tutti 0,01 (la modalita' non scala nel tester): 45%.
- **S5** DD equity: T3 6% +-50%; step 1000 sopra 30%: 50%.
- **S6** ogni passata sotto 10 minuti: 80%.
## Cosa si fa dopo (invariato)
Soglie: S-DD (<=10% dal deposito), S-NOSCALA (rapporto lotti <=3), S-N >=150 op, S-M >=60% mesi. DD sempre anche in % degli 80.000. Se una configurazione passa, S-CORR/S-PORT con Prop Firm e Gold Reaper.
