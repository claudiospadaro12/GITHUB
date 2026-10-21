# Goldbot One sonda 2 dei metodi di lotto: lettura (21/10/2026)

Fonte: `GB2.zip` e `GB2_GOLDBOTONEMT5.zip` (identici: SHA256 di manifest e referto). Previsioni: `GOLDBOT_D1_SONDA2_ATTESE_2026-10-21.md`. Non controllata da agenti. Sei passate OHLC 1 minuto, 183-193 s ciascuna, 451 operazioni in tutte.

## Difetto mio di disegno (dichiarato)
Le passate NON hanno imposto tutti gli input dei lotti: gli input non imposti restano "ultimo valore salvato nel tester". I report lo mostrano: T3 ha `MaxRiskPerStrategy=50` (ereditato da T2); T4, T5, T6 hanno `StartLots=0.08` e `MaxRiskPerStrategy=50` (ereditati). Quindi T3-T6 NON sono variazioni di UN solo input. T1 e T2 sono pulite (StartLots 0,01 e step 1000 come in tutte le prove).

## Numeri (XAUUSD D1, 01/01/2025-01/10/2026, 80.000 EUR, OHLC 1 min)
| passata | input effettivi | lotti ingresso min/med/max | netto | PF | DD equity | long / short |
|---|---|---|---|---|---|---|
| T1 | Risk 1, MaxRisk 10 | 0,01/0,01/0,01 | +1.675,28 | 1,71 | 0,80% | 1.450 / 333 |
| T2 | Risk 1, MaxRisk 50 | 0,01/0,01/0,01 | +1.675,28 | 1,71 | 0,80% | idem T1 |
| T3 | **Risk 0, StartLots 0,08** (MaxRisk 50 ereditato) | **0,01/0,03/0,06** | **+6.013,66** | 1,88 | **1,84%** (1.570 EUR; saldo 1,52%) | 5.401 / 1.014 |
| T4 | Risk 2, step 20000 (+ StartLots 0,08, MaxRisk 50 ereditati) | 0,01/0,01/0,02 | +1.670,01 | 1,70 | 0,80% | 1.445 / 333 |
| T5 | Risk 2, step 10000 | idem T4 | +1.670,01 | 1,70 | 0,80% | idem |
| T6 | Risk 2, step 1000 | idem T4 | +1.670,01 | 1,70 | 0,80% | idem |

## Cosa si legge
- **Risk=1 non scala i lotti** (MaxRisk 10 e 50: sempre 0,01).
- **Risk=2 non reagisce al LotsizeStep** (20000, 10000 e 1000 danno lo stesso risultato) e nemmeno a StartLots=0,08 ereditato: quindi NON e' ne' "use StartLots" ne' un metodo che usa lo step, in questo tester. I valori numerici di `Risk` non corrispondono all'ordine della tendina come ipotizzato [mappa REALE: NON TROVATA].
- **Risk=0 con StartLots 0,08 scala**, ma non a 0,08: i lotti per operazione vanno da 0,01 a 0,06 (mediana 0,03; una sola etichetta di commento, non per strategia) e calano nel tempo (media mensile da 0,047 a circa 0,026) mentre il saldo sale poco. Il netto e' 3,6 volte, il DD 2,3 volte quello a lotto 0,01. Non so da cosa dipenda il lotto per operazione [NON VERIFICATO: l'EA e' una scatola nera].
- T3 (la sola configurazione che scala), con le regole gia' scritte: S-N 451 >= 150 ok; S-M 15 mesi positivi su 21 = 71% ok; S-H prima meta' (01-10/2025) +4.509, seconda +1.905 ok; S-DD 1,84% dal deposito ok. S-NOSCALA: rapporto lotti massimo/minimo 0,06/0,01 = 6,0 > 3: **fuori soglia alla lettera** (il lotto e' piu' alto all'inizio, non dopo perdite: non e' un martingale ma la regola dice 3). Netto +7,5% di 80.000 in 21 mesi, long 84% del profitto in un mercato in rialzo.

## Previsioni
S1 inputs applicati: vero (con l'ereditarieta' dichiarata sopra). S2 T3 lotti 0,08 e netto 8x: FALSO (mediana 0,03, 3,6x). S3 Risk=2 con step: FALSO. S4 Risk=1 lotti 0,01: VERO. S5 DD T3 6%+-50%: FALSO (1,84%); step 1000 sopra 30%: FALSO. S6 sotto 10 min: VERO (circa 3 minuti).

## Prossimo passo
Lo .set con la tendina su "use Max Risk Per Strategy" (Salva dal tester) dice il valore numerico vero di `Risk`. Poi una riga PULITA con TUTTI gli input dei lotti imposti in ogni passata.
