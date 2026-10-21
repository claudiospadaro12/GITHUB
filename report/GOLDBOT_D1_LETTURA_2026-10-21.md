# Goldbot One D1 a 80K: lettura (21/10/2026)

Fonte: `GBO.zip` (identico, SHA256 di manifest/referto/report, a `GBO_GOLDBOTONEMT5.zip`). Previsioni: `GOLDBOT_D1_ATTESE_2026-10-20.md`. Non controllata da agenti.

## Fatto principale
**T1, T2, T3 sono IDENTICHE al centesimo** (449 operazioni, netto 1426,37, PF 1,57, DD 0,88%) pur con Risk 0/1 e MaxRiskPerStrategy 6/3/6. In tutti i deal il volume e' **0,01** (min = mediana = max). I lotti NON sono scalati: `Risk=0` e `Risk=1` danno entrambi lotto fisso `StartLots`. Il selettore "usa il rischio massimo per strategia" ha un altro valore di `Risk` [NON TROVATO]. T4 KO (timeout 180 min, non misurato).

## Numeri (XAUUSD D1, 01/01/2025-01/10/2026, 80.000 EUR, lotto 0,01)
| | T1/T2/T3 (tick reali) | T5 (OHLC 1 min) |
|---|---|---|
| operazioni | 449 | 451 |
| netto | +1.426,37 (+1,8% di 80K) | +1.675,28 |
| PF | 1,57 | 1,71 |
| DD equity / saldo | 0,88% / 0,78% | 0,80% / 0,68% |
| long / short (somma Profitto delle uscite) | 285 op +1.296,59 / 164 op +238,45 | 286 +1.450,45 / 165 +332,84 |
Somma colonna Profitto 1.535,04; netto 1.426,37 (differenza -108,67 = commissioni+swap). Mesi positivi 15/21 (71%). Meta' finestra (01/2025-10/2025 / 11/2025-09/2026): +1.104 / +429. Mesi negativi 2026: feb -336, mar -211, mag -108.

## Previsioni
GB1 applicati: vero su T1,T2,T3,T5 (T4 non girata). GB2 lotti crescono: **FALSO** (tutti 0,01). GB3 150-600 op: vero (449). GB4 DD crescente T2<T3<T4 con T2<=6%: T2 0,88% vero, crescente falso. GB5 PF T3 0,9-2,0: vero (1,57). GB6 T5 entro +-30% netto e +-10% op: vero (+17,5%, +0,4%). GB7 <30 min: **FALSO** (tick reali circa 160-175 min a passata; OHLC 3 min).

## Altro
- Giornale: `Error when reading GMT URL 4014` (WebRequest non consentita nel tester): AutoGMT non funziona, usa gli offset manuali di default 2/3 [effetto non verificato]; il server BCM e' UTC+1 fisso.
- Calendario MQL5 per il filtro NFP nel tester [NON VERIFICATO se disponibile].
- Il netto e' piccolo perche' il lotto e' minimo: scalare linearmente e' una stima DERIVATA, non misurata.
