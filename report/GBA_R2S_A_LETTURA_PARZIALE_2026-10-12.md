# GBA R2S stadio A -- LETTURA PARZIALE con D2 (12/10/2026): arrivati solo R2SNAS e R2SU30

**Stato: PARZIALE, esiti formali tutti (C) perche' manca il lotto-ancora R2SANC (CE1). Mancano anche R2SXAG e R2SD30. Nessun verdetto, nessuna archiviazione; il certificato di morte non e' toccato.**
Strumento: backtest_pipeline/leggi_gba_r2s_c3g.py SHA256 14384D87... (PASS del cancello, commit 4814795a). Zip letti (SHA256 inizio): R2SNAS fcb370b6-origine, R2SU30 c503e62e. Uscita integrale di D2 qui sotto (campo stop/spread del giornale, Modello 1, T1 2026, un regime).

```
==============================================================================================================
 leggi_gba_r2s_c3g v2 (D2, strato 2 del 12/10) -- GBA R2S stadio A, C3G (mediana vera del campo stop/spread delle righe segnale). SHA256 di questo file: 14384d874d124021
 Regole: righe -1.0x = INFINITO (contate, non scartate); mediana con n PARI = media delle due centrali (INF se una delle due e' INF); fasce = lettore r.52, campo 'ora server'.
 Precondizione FUORI da D2: il G0 del lettore leggi_gba_r0.py (sezione (1)) per ogni passata; l'A3 dell'ancora (doppione con GBA_R0_S0.zip).
==============================================================================================================
(0) PROVA D'ACCETTAZIONE di D2 (giornali archiviati, rifatta adesso): PASSATA
   S0_01 (Modello 1): cella 22.80; fasce asia 19.80 / europa 24.50 / pausa 26.20 / USA apertura 39.20 / USA pomeriggio 20.60 / rollover 10.65; asia BUY 21.40 (n 1139) SELL 18.50 (n 1175); ingressi 158, tentati 158, righe -1.0x 0, righe >= 40x 740, >= 50x 355 -> IDENTICI ai numeri scritti
   R1A T1 (tick reali): cella 21.60, ingressi 128, righe >= 40x 651, >= 50x 280 -> IDENTICI
   CE1 ancora: NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SANC: NON CARICATO (zip assente o compilazione fallita) -> nessun esito

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SXAG: NON CARICATO (zip assente o compilazione fallita) -> nessun esito

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SNAS  CELLA M5 = NASUSD M5  (passata R2SNAS_01_M5_T1_m775800, stato driver OK)
--------------------------------------------------------------------------------------------------------------
   righe segnale (segnali grezzi) 1491 | ingressi del giornale (senza SALTATO) 124, di cui a SPREAD ZERO (-1.0x) 0 | righe -1.0x in tutto 0 | righe d'ingresso eseguite 124
   n del report 124 | EA: segnali 1491, ingressi tentati 124, scartati spread 1101, posizione aperta 266, ATR non valido 0 | quota dei liberi scartata per spread 89.9% (1101 su 1225)
   motivi delle righe: ok 124, posizione gia' aperta 266, spread oltre il limite 1101 | lotti degli ingressi: 1.00
   C3G CELLA 33.90 (n 1491)   BUY 30.30 (n 804)   SELL 37.40 (n 687)   righe >= 40x 516 (la (v) di E4)   righe >= 50x 306   spread della cella (mediana del campo spread) 1.800
   fascia          ore    righe      C3G      BUY      n     SELL      n   >=40x   >=50x  ingressi    quota   spread
   asia            00-07    452    28.00    24.10    238    33.40    214      87      37        15    12.1%     1.80
   europa          07-12    364    30.70    27.20    197    35.90    167      71      19         6     4.8%     1.80
   pausa           12-14    176    34.70    34.50     93    34.80     83      51      11         9     7.3%     1.80
   USA apertura    14-17    265    58.90    56.10    139    64.10    126     222     171        66    53.2%     1.80
   USA pomeriggio  17-22    185    33.20    29.85    114    53.00     71      69      54        21    16.9%     1.80
   rollover        22-24     49    27.30    30.00     23    26.35     26      16      14         7     5.6%     1.80
   CE2 verde: firma dell'oro assente
   CE3 verde: solo spread n=124 mediana 60.8 p10 50.8 quota <40x 0%
   CE4 verde: segnali(EA) 1491 = tentati 124 + spread 1101 + posizione 266 + altri 0 (somma 1491); righe del giornale 1491, senza SALTATO 124, SALTATO per spread 1101
   CE6 verde: tentati 124 - n 124 = 0 (ammesso 0 o 1)
   PORTA STADIO B: n 124 - ingressi a spread zero 0 = 124 >= 30
   eccezione n = 0 (KO solo per ZERO operazioni, tentati 0, scartati spread >= 1): no
   condizioni di ESCLUSA, S = 13.30x, testo pinnato ((ii) su fasce >= 100 righe: asia, europa, pausa, USA apertura, USA pomeriggio): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 516 < 30: no
   condizioni di ESCLUSA, S = 13.30x, con E1 ((ii) su fasce >= 30 righe: asia, europa, pausa, USA apertura, USA pomeriggio, rollover): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 516 < 30: no
   (variante) ESITO secondo il testo pinnato, (i)-(iv), (ii) >= 100: (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   (variante) ESITO con E1, (i)-(iv), (ii) >= 30:                  (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   ESITO DI RIFERIMENTO (E1 + E4, (i)-(v), dicitura E3):          (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   CASELLA 4 (E3): NON ANCORA MISURATO, casella 4 aperta: nessuna ESCLUSA (Modello 1) da confermare

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SNAS  CELLA M15 = NASUSD M15  (passata R2SNAS_02_M15_T1_m775800, stato driver OK)
--------------------------------------------------------------------------------------------------------------
   righe segnale (segnali grezzi) 488 | ingressi del giornale (senza SALTATO) 135, di cui a SPREAD ZERO (-1.0x) 0 | righe -1.0x in tutto 0 | righe d'ingresso eseguite 135
   n del report 135 | EA: segnali 488, ingressi tentati 135, scartati spread 132, posizione aperta 221, ATR non valido 0 | quota dei liberi scartata per spread 49.4% (132 su 267)
   motivi delle righe: ok 135, posizione gia' aperta 221, spread oltre il limite 132 | lotti degli ingressi: 1.00
   C3G CELLA 62.00 (n 488)   BUY 54.95 (n 280)   SELL 72.75 (n 208)   righe >= 40x 407 (la (v) di E4)   righe >= 50x 335   spread della cella (mediana del campo spread) 1.800
   fascia          ore    righe      C3G      BUY      n     SELL      n   >=40x   >=50x  ingressi    quota   spread
   asia            00-07    107    51.60    43.35     56    59.40     51      79      57        23    17.0%     1.80
   europa          07-12    125    47.20    38.70     73    63.25     52      83      58        24    17.8%     1.80
   pausa           12-14     54    53.95    51.40     35    67.80     19      46      34        19    14.1%     1.80
   USA apertura    14-17    116    83.30    78.55     60    92.00     56     115     113        44    32.6%     1.80
   USA pomeriggio  17-22     77    87.80    76.30     49    98.85     28      76      65        22    16.3%     1.80
   rollover        22-24      9    66.50    60.30      7    75.20      2       8       8         3     2.2%     1.80
   CE2 verde: firma dell'oro assente
   CE3 verde: solo spread n=135 mediana 72.4 p10 53.0 quota <40x 0%
   CE4 verde: segnali(EA) 488 = tentati 135 + spread 132 + posizione 221 + altri 0 (somma 488); righe del giornale 488, senza SALTATO 135, SALTATO per spread 132
   CE6 verde: tentati 135 - n 135 = 0 (ammesso 0 o 1)
   PORTA STADIO B: n 135 - ingressi a spread zero 0 = 135 >= 30
   eccezione n = 0 (KO solo per ZERO operazioni, tentati 0, scartati spread >= 1): no
   condizioni di ESCLUSA, S = 13.30x, testo pinnato ((ii) su fasce >= 100 righe: asia, europa, USA apertura): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 407 < 30: no
   condizioni di ESCLUSA, S = 13.30x, con E1 ((ii) su fasce >= 30 righe: asia, europa, pausa, USA apertura, USA pomeriggio): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 407 < 30: no
   (variante) ESITO secondo il testo pinnato, (i)-(iv), (ii) >= 100: (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   (variante) ESITO con E1, (i)-(iv), (ii) >= 30:                  (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   ESITO DI RIFERIMENTO (E1 + E4, (i)-(v), dicitura E3):          (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   CASELLA 4 (E3): NON ANCORA MISURATO, casella 4 aperta: nessuna ESCLUSA (Modello 1) da confermare

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SD30: NON CARICATO (zip assente o compilazione fallita) -> nessun esito

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SU30  CELLA M5 = U30USD M5  (passata R2SU30_01_M5_T1_m775800, stato driver OK)
--------------------------------------------------------------------------------------------------------------
   righe segnale (segnali grezzi) 1451 | ingressi del giornale (senza SALTATO) 112, di cui a SPREAD ZERO (-1.0x) 0 | righe -1.0x in tutto 0 | righe d'ingresso eseguite 112
   n del report 112 | EA: segnali 1451, ingressi tentati 112, scartati spread 1112, posizione aperta 227, ATR non valido 0 | quota dei liberi scartata per spread 90.8% (1112 su 1224)
   motivi delle righe: ok 112, posizione gia' aperta 227, spread oltre il limite 1112 | lotti degli ingressi: 1.00
   C3G CELLA 29.90 (n 1451)   BUY 27.80 (n 772)   SELL 32.50 (n 679)   righe >= 40x 458 (la (v) di E4)   righe >= 50x 308   spread della cella (mediana del campo spread) 2.000
   fascia          ore    righe      C3G      BUY      n     SELL      n   >=40x   >=50x  ingressi    quota   spread
   asia            00-07    369    16.80    16.10    220    18.60    149       1       0         0     0.0%     2.00
   europa          07-12    391    27.10    26.40    212    27.40    179      42      14         5     4.5%     2.00
   pausa           12-14    187    36.40    37.50     99    35.75     88      67      20         6     5.4%     2.00
   USA apertura    14-17    274    68.70    65.40    111    68.90    163     250     223        83    74.1%     2.00
   USA pomeriggio  17-22    191    38.90    36.50    104    42.60     87      89      49        16    14.3%     2.00
   rollover        22-24     39    28.90    23.55     26    33.00     13       9       2         2     1.8%     2.00
   CE2 verde: firma dell'oro assente
   CE3 verde: solo spread n=112 mediana 66.7 p10 52.3 quota <40x 0%
   CE4 verde: segnali(EA) 1451 = tentati 112 + spread 1112 + posizione 227 + altri 0 (somma 1451); righe del giornale 1451, senza SALTATO 112, SALTATO per spread 1112
   CE6 verde: tentati 112 - n 112 = 0 (ammesso 0 o 1)
   PORTA STADIO B: n 112 - ingressi a spread zero 0 = 112 >= 30
   eccezione n = 0 (KO solo per ZERO operazioni, tentati 0, scartati spread >= 1): no
   condizioni di ESCLUSA, S = 13.30x, testo pinnato ((ii) su fasce >= 100 righe: asia, europa, pausa, USA apertura, USA pomeriggio): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 458 < 30: no
   condizioni di ESCLUSA, S = 13.30x, con E1 ((ii) su fasce >= 30 righe: asia, europa, pausa, USA apertura, USA pomeriggio, rollover): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 458 < 30: no
   (variante) ESITO secondo il testo pinnato, (i)-(iv), (ii) >= 100: (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   (variante) ESITO con E1, (i)-(iv), (ii) >= 30:                  (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   ESITO DI RIFERIMENTO (E1 + E4, (i)-(v), dicitura E3):          (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   CASELLA 4 (E3): NON ANCORA MISURATO, casella 4 aperta: nessuna ESCLUSA (Modello 1) da confermare

--------------------------------------------------------------------------------------------------------------
 LOTTO R2SU30  CELLA M15 = U30USD M15  (passata R2SU30_02_M15_T1_m775800, stato driver OK)
--------------------------------------------------------------------------------------------------------------
   righe segnale (segnali grezzi) 460 | ingressi del giornale (senza SALTATO) 115, di cui a SPREAD ZERO (-1.0x) 0 | righe -1.0x in tutto 0 | righe d'ingresso eseguite 115
   n del report 115 | EA: segnali 460, ingressi tentati 115, scartati spread 145, posizione aperta 200, ATR non valido 0 | quota dei liberi scartata per spread 55.8% (145 su 260)
   motivi delle righe: ok 115, posizione gia' aperta 200, spread oltre il limite 145 | lotti degli ingressi: 1.00
   C3G CELLA 58.05 (n 460)   BUY 54.65 (n 246)   SELL 67.95 (n 214)   righe >= 40x 363 (la (v) di E4)   righe >= 50x 286   spread della cella (mediana del campo spread) 2.000
   fascia          ore    righe      C3G      BUY      n     SELL      n   >=40x   >=50x  ingressi    quota   spread
   asia            00-07     78    34.25    34.60     45    33.90     33      24       6         1     0.9%     2.00
   europa          07-12    114    45.75    44.80     69    47.50     45      78      46        24    20.9%     2.00
   pausa           12-14     84    54.85    52.80     44    57.35     40      78      56        18    15.7%     2.00
   USA apertura    14-17    112    96.00    94.00     49    97.20     63     111     109        51    44.3%     2.00
   USA pomeriggio  17-22     64    99.75   116.30     31    94.00     33      64      63        18    15.7%     2.00
   rollover        22-24      8    54.60    54.60      8     n.d.      0       8       6         3     2.6%     2.00
   CE2 verde: firma dell'oro assente
   CE3 verde: solo spread n=115 mediana 76.1 p10 52.1 quota <40x 0%
   CE4 verde: segnali(EA) 460 = tentati 115 + spread 145 + posizione 200 + altri 0 (somma 460); righe del giornale 460, senza SALTATO 115, SALTATO per spread 145
   CE6 verde: tentati 115 - n 115 = 0 (ammesso 0 o 1)
   PORTA STADIO B: n 115 - ingressi a spread zero 0 = 115 >= 30
   eccezione n = 0 (KO solo per ZERO operazioni, tentati 0, scartati spread >= 1): no
   condizioni di ESCLUSA, S = 13.30x, testo pinnato ((ii) su fasce >= 100 righe: europa, USA apertura): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 363 < 30: no
   condizioni di ESCLUSA, S = 13.30x, con E1 ((ii) su fasce >= 30 righe: asia, europa, pausa, USA apertura, USA pomeriggio): (i) SI  (ii) no  (iii) no  (iv) no  | (v) E4 righe >= 40x 363 < 30: no
   (variante) ESITO secondo il testo pinnato, (i)-(iv), (ii) >= 100: (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   (variante) ESITO con E1, (i)-(iv), (ii) >= 30:                  (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   ESITO DI RIFERIMENTO (E1 + E4, (i)-(v), dicitura E3):          (C) NON SI LEGGE: CE1 (ancora) NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato
   CASELLA 4 (E3): NON ANCORA MISURATO, casella 4 aperta: nessuna ESCLUSA (Modello 1) da confermare

 NON giudica il merito, NON promuove, NON legge PF. Ogni esito vale solo con il G0 del lettore OK sulla stessa passata.
 CSV: /tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/r2s_lettura/D2_parziale.csv
```
