# HAM (EMA 9/21 + Supertrend + Heikin-Ashi, motore di Emiliano, script Pine di Claudio v10 / Wide): criteri PRIMA dei numeri (20/11/2026)

**Fonte:** `03_ham-style-ema-st-ha-claudio-v10.pine`, `04_ham-test-wide-claudio.pine`, `05_ham-profit-max-claudio-v11.pine` (stesso motore del v10; il v11 aggiunge solo trailing e break-even spenti di default e lotto al 30%: a default i segnali sono identici al v10, non si testa a parte). `075 HAM score 55` non letto: non incluso. Porting `mql5/Experts/ABTG_HAM.mq5` (per il tester MT5).
**Differenza voluta dal Pine:** i filtri H1/H4/D1 usano **l'ultima candela chiusa** (il Pine, con `request.security(..., lookahead_off)` su storico, vede la chiusura finale della candela superiore anche nelle ore precedenti: informazione del futuro; i backtest di TradingView di questi script sono con tutta probabilita' gonfiati). Altre differenze: ingresso al mercato dopo la chiusura della candela (nel Pine a `process_orders_on_close`); SL/TP calcolati sul close del segnale come nel Pine; rischio 1% per operazione (nel Pine 10%/30% del capitale); costi = spread del tester (nel Pine commissione 0,02% e slippage 2).
**Set (2) x timeframe (3) x simboli (29):** V10 (default del Pine v10: score 70, distanza EMA 0,08, H4 e D1 attivi) e WIDE (score 55, distanza 0,05, H4 e D1 spenti); M5, M15, M30 (il timeframe d'uso non e' stato dichiarato da Claudio); 28 cross forex + XAUUSD, **2013-01-01 -> 2024-12-31**, BCM portabile, Modello 1. 174 passate. **Indici e DAX non inclusi** (BCM li ha nativi solo 2024-2026, con convenzioni d'orario da verificare: prova separata). Orario 8-18 ora italiana (conversione con la regola europea dell'ora legale dal server GMT+1 fisso).
**IS 2013-2020 / OOS 2021-2024**, serie giornaliere sommate per gruppo (28 cross; oro), R = rendimento / 1%. 12 gruppi (2 set x 3 TF x 2 gruppi): lettura esplorativa, la soglia non si abbassa.
## Previsioni
- Tutti i 12 gruppi con PF pooled < 1,10 in IS: **80%**; almeno un gruppo con IS PF >= 1,3 e OOS PF > 1,2: **7%**.
- WIDE ha piu' operazioni di V10 (almeno +50%): **75%**; WIDE ha PF peggiore di V10 nel gruppo 28 cross: **60%**.
- I TF piu' alti (M30) hanno PF migliore di M5 (costi relativi minori): **70%**.
## Regole di esito (invariate dopo i numeri)
**CANDIDATO** (per set, TF e gruppo): IS PF >= 1,3 con >= 100 operazioni; OOS PF > 1,2 con >= 50 operazioni; IC90 inferiore del R medio > 0 su IS+OOS; >= 8 anni su 12 non negativi; leave-one-out PF > 1,0; prova di deriva (long contro short non entrambi dipendenti da un lato; sul forex il lungo non e' favorito, sull'oro si'). Meno di 100 operazioni IS = NON VALUTABILE. Simboli singoli solo descrittivi. Nessun consiglio di taglie. Hold-out 2025-26 non usato.

## RISULTATI (174 passate ricevute 21/11, nessun errore; serie giornaliere sommate, R = rendimento / 1%)
| Gruppo | IS 2013-2020 (n / R / PF / win) | OOS 2021-2024 (n / R / PF) | Anni + |
|---|---|---|---|
| V10 M5, 28 cross | 4.575 / -0,30 / 0,59 / 33% | 2.384 / -0,21 / 0,70 | 0/12 |
| V10 M15, 28 cross | 1.596 / -0,19 / 0,73 / 34% | 857 / -0,08 / 0,88 | 1/12 |
| V10 M30, 28 cross | 884 / -0,18 / 0,74 / 33% | 484 / -0,12 / 0,82 | 2/12 |
| WIDE M5 / M15 / M30, 28 cross | PF 0,59 / 0,75 / 0,80 (n 9.576 / 3.155 / 1.680) | PF 0,69 / 0,84 / 0,84 | 0 / 1 / 1 su 12 |
| V10 XAUUSD M5 / M15 / M30 | PF 0,48 / 0,52 / 0,62 (n 132 / 70 / 33) | PF 0,79 / 1,19 (n 41, IC90 inf -0,24) / 0,80 | 2-3 su 12 |
| WIDE XAUUSD M5 / M15 / M30 | PF 0,67 / 0,57 / 0,67 | PF 0,71 / 1,02 / 0,76 | 0-2 su 12 |
- **12 gruppi su 12 con PF IS < 1 (0,48-0,80); nessun candidato.** R medio negativo ovunque in IS; in OOS l'unico PF > 1 sono due celle oro con 41 e 80 operazioni (IC90 inferiore negativo). Win rate 27-35%.
- Previsioni: tutti i 12 gruppi con PF IS < 1,10 (80%): **si'**; un candidato (7%): no; WIDE ha almeno +50% di operazioni (75%): **si'** (+98% a M15); WIDE ha PF peggiore di V10 sui 28 cross (60%): **no** (0,75 contro 0,73 a M15, 0,80 contro 0,74 a M30; uguali a M5); M30 meglio di M5 (70%): **si'** (0,74 contro 0,59).
- **Conclusione: HAM (motore di Emiliano + filtri di Claudio, con i filtri H1/H4/D1 sull'ultima candela chiusa, quindi senza il futuro che gonfia il backtest di TradingView) non ha vantaggio su 28 cross e oro, M5-M30, 2013-2024.** Il Pine di TradingView mostra risultati migliori perche' i suoi filtri H4/D1 su storico vedono la chiusura finale della candela superiore. Non testati: indici e DAX (nessun M1 sul tester per il periodo lungo). Chiuso.
