# Goldbot One sonda 3: lettura (21/10/2026)

Fonte: `GB3.zip` = `GB3_GOLDBOTONEMT5.zip` (manifest identico). Previsioni: `GOLDBOT_D1_SONDA3_ATTESE_2026-10-21.md`. Non controllata da agenti. Sei passate OHLC 1 minuto, 189-319 s ciascuna, 451 operazioni in tutte, tutti e quattro gli input dei lotti confermati dal report in ogni passata, .ex5 invariato (SHA256 uguale dopo ogni passata), 0 stop out.

## Mappa di Risk (dai lotti: [PROBABILE], i set non portano il nome della voce)
- **Risk=0**: use StartLots (lotto fisso, scalato da StartLots).
- **Risk=3**: use Max Risk Per Strategy: il lotto mediano cresce con MaxRiskPerStrategy (0,24 -> 0,58 -> 1,33) e col saldo.
- **Risk=9999**: use LotsizeStep: il lotto cala all'aumentare dello step (0,56 -> 0,22 -> 0,03).
- Risk 1 e 2 non sono voci valide (sonda 2: lotto 0,01).

## Numeri (XAUUSD D1, 01/01/2025-01/10/2026, 80.000 EUR; DD in % degli 80.000 e dal picco)
| T | input | netto | PF | DD equity EUR | DD % 80K | DD % picco | lotti min/med/max | rapporto | long / short |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Risk 3, MaxRisk 3 | +51.745 | 1,83 | 10.829 | 13,5% | 9,18% | 0,12/0,24/0,81 | 6,8 | 42.442 / 12.180 |
| 2 | Risk 3, MaxRisk 6 | +128.666 | 1,78 | 31.372 | 39,2% | 18,42% | 0,28/0,58/2,33 | 8,3 | 102.435 / 32.973 |
| 3 | Risk 3, MaxRisk 10 | +279.478 | 1,74 | 80.555 | 100,7% | 30,11% | 0,45/1,33/6,20 | 13,8 | 216.518 / 76.791 |
| 4 | Risk 9999, step 1000 | +97.009 | 1,76 | 34.201 | 42,8% | 21,06% | 0,30/0,56/0,74 | 2,5 | 83.237 / 19.603 |
| 5 | Risk 9999, step 2000 | +40.427 | 1,82 | 12.304 | 15,4% | 10,73% | 0,11/0,22/0,30 | 2,7 | 35.255 / 7.691 |
| 6 | Risk 9999, step 10000 | +6.108 | 1,88 | 1.599 | 2,0% | 1,87% | 0,01/0,03/0,06 | 6,0 | 5.389 / 1.120 |
Operazioni 451 ovunque; massimo di posizioni aperte insieme 8; mesi positivi 15-16 su 21; entrambe le meta' positive in tutte; commissioni+swap da -401 (T6) a -13.831 (T3). Le somme long+short sono al lordo di commissioni.

## Cancelli (regole gia' scritte, applicate alla lettera)
- **S-DD (<=10% dal deposito, <=15,2% dal picco)**: passa **solo T6** (2,0%). T1 13,5%, T5 15,4% dal deposito: fuori. Dal picco T1 9,18% e T5 10,73% sarebbero dentro 15,2%, ma la regola chiede anche il 10% dal deposito.
- **S-NOSCALA (rapporto lotti <=3, <=10 posizioni)**: passano **T4 e T5** (2,5 e 2,7; posizioni 8). T1, T2, T3 (6,8-13,8) e T6 (6,0: 0,01-0,06 per arrotondamento al minimo) no.
- **Nessuna passata passa entrambi.** Il modo a Max Risk ha rapporto >6 gia' nel primo mese (pesi per strategia), quindi non passa S-NOSCALA alla lettera a nessun livello provato.
- Con Risk 3 e 9999 i lotti crescono col saldo (T3: lotto medio 1,06 -> 2,95 fra primo e ultimo mese): il guadagno e' composto, non lineare.

## Altro
- Long 78-83% del profitto in tutte; gli short restano positivi. Un solo regime (oro in rialzo).
- Nel modo a step il ritmo del 2026 e' piu' basso del 2025 (T6: 2025 circa +4.730 su 12 mesi, 2026 circa +1.400 su 9; T4: 69.429 contro 28.006); nel modo a Max Risk no (T2 71.951 contro 57.335). Non so perche' [NON VERIFICATO].
- Il DD in percentuale del picco cresce molto piu' lentamente del DD sugli 80.000 perche' il picco sale con il guadagno: si leggono sempre entrambi.

## Previsioni
S1 inputs applicati: vero. S2 almeno uno scala: vero (entrambi). S3 Risk 3 lotto cresce con MaxRisk: vero. S4 Risk 9999 lotto cala con lo step: vero. S5 operazioni 440-470: vero (451). S6 sotto 10 minuti: vero (189-319 s).

## Cosa resta aperto
Fra step 2000 (DD 15,4%) e step 10000 (DD 2,0%) esiste una zona non misurata dove entrambi i cancelli potrebbero passare [DERIVATO: DD circa proporzionale a 1/step; NON MISURATO]. Il livello di rischio resta decisione di Claudio.
