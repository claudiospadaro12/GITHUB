# Goldbot One, sonda 3 dei metodi di lotto: previsioni scritte PRIMA dei numeri (21/10/2026)

**Non controllata da agenti.** Origine: i set salvati da Claudio (`backtest_pipeline/set_vendor_21102026/`): `Risk=0` (use StartLots, voce attiva), `Risk=3` e `Risk=9999` (le altre due voci della tendina; QUALE sia use Max Risk Per Strategy e quale use LotsizeStep NON e' noto: i due file non portano il nome della voce). I valori 1 e 2 della sonda 2 non esistono come voci: davano lotto 0,01 (ipotesi: valore sconosciuto = lotto minimo [NON VERIFICATO]). Errore della sonda 2: input non imposti ereditati fra passate. Qui OGNI passata impone tutti e quattro gli input dei lotti (Risk, MaxRiskPerStrategy, StartLots 0.01, LotPerBalance_step).
## Passate (XAUUSD D1, OHLC 1 minuto, 01/01/2025-01/10/2026, 80.000 EUR)
T1/T2/T3: Risk=3, MaxRiskPerStrategy 3 / 6 / 10 (step 1000). T4/T5/T6: Risk=9999, MaxRiskPerStrategy 6, LotPerBalance_step 1000 / 2000 / 10000. Base di confronto: lotto 0,01 +1.675 (DD 0,80%); StartLots 0,08: +6.014, DD 1,84%.
## Previsioni
- **S1** tutti gli input imposti applicati e uguali al .ini nel report: 90%.
- **S2** almeno uno fra Risk=3 e Risk=9999 porta il lotto mediano sopra 0,01: 85%.
- **S3** con Risk=3 il lotto mediano cresce con MaxRiskPerStrategy (T1 <= T2 <= T3, almeno uno stretto): 55% (dipende da quale voce sia).
- **S4** con Risk=9999 il lotto mediano cala all'aumentare dello step (T4 >= T5 >= T6): 55%.
- **S5** operazioni fra 440 e 470 nelle passate con lotto piccolo: 70% (con lotti grandi il margine puo' cambiarle).
- **S6** ogni passata sotto 10 minuti: 80%.
## Cosa si fa dopo
Soglie invariate (S-DD <=10% dal deposito, S-NOSCALA lotto max/min <=3, S-N >=150, S-M >=60%). DD sempre anche in % degli 80.000. Il rapporto lotti 6,0 trovato con StartLots 0,08 e' un fatto noto da riportare accanto.
