# UBS C forex a tick reali (15/11/2026): gli scalper crollano, i volatility breakout reggono ma rendono pochissimo

**Fonte:** `ANNO_ORO_GRADINI_UBSCFT_20261115_1729.zip` (riga `6c9f18f6`, tester pin `70181fd2`). **14 passate su 14 `OK`.** 7 set x (Modello 1, Modello 4) sullo STESSO anno 2025, lotto fisso 0,1 (`Risk=0`, `StartLots=0.1`), deposito 100.000 EUR, BCM. Le passate a tick: qualita storico **100%**, 24-37 milioni di tick reali, operazioni in tutti i 12 mesi; durata 98-198 s ciascuna. Previsioni scritte prima: `PREVISIONI_UBS_C_FOREX_TICK_2026-11-15.md`; criteri del piano: `UBS_COMBINAZIONI_PIANO_2026-11-15.md`.

## Confronto M1 -> tick reali (stesso anno, stesso set)
| Set | Op M1/tick | PF M1 -> tick (rapporto) | DD M1 -> tick (rapporto) | Vincenti % | Vincita media (EUR) | Netto M1 -> tick (EUR) | Soglie |
|---|---|---|---|---|---|---|---|
| SCALP_EU_SL17 (EURUSD H1) | 180/174 | 1,98 -> 1,13 (x0,57) | 93 -> 64 (x0,69) | 91 -> 90 | 3,8 -> 2,3 | 288 -> 37 | **NON PASSA** (PF) |
| SCALP_EU_SL22 (EURUSD H1) | 177/169 | 2,44 -> 1,22 (x0,50) | 65 -> 55 (x0,84) | 93 -> 91 | 4,2 -> 2,2 | 386 -> 55 | **NON PASSA** (PF) |
| SCALP_GU_H1 (GBPUSD H1) | 150/143 | 2,32 -> 1,02 (x0,44) | 53 -> 68 (x1,29) | 93 -> 88 | 4,1 -> 2,2 | 304 -> 5 | **NON PASSA** (PF) |
| SCALP_UJ_H1 (USDJPY H1) | 316/312 | 2,06 -> 0,84 (x0,41) | 77 -> 131 (x1,69) | 89 -> 83 | 3,9 -> 2,0 | 544 -> **-90** | **NON PASSA** (PF e DD) |
| SCALP_UJ_H4 (USDJPY H4) | 293/290 | 1,85 -> 0,99 (x0,54) | 52 -> 150 (x2,91) | 66 -> 54 | 6,4 -> 5,4 | 556 -> **-7** | **NON PASSA** (PF, DD, % vincenti) |
| VOL_f (EURUSD) | 23/23 | 1,05 -> 1,04 (x0,99) | 86 -> 80 (x0,94) | 57 -> 57 | 22,4 -> 22,7 | 15 -> 10 | passa |
| VOL_o (EURUSD) | 22/22 | 1,18 -> 1,20 (x1,02) | 79 -> 75 (x0,95) | 59 -> 59 | 26,1 -> 26,7 | 51 -> 58 | passa |

Soglie (piano, da Wim): PF tick/M1 >= 0,7 (sotto 0,5 e FAIL), DD tick <= 1,5 x M1, operazioni +-10%, % vincenti +-10 punti.

## Lettura
- **Gli scalper sono un effetto del Modello 1.** Vincono quasi sempre (83-93%) ma poco; con i tick reali la vincita media quasi si dimezza (3,8-4,2 -> 2,0-2,3 EUR) mentre la perdita media resta quella (11-19 EUR). Con una vincita da 2 EUR e una perdita da 14 serve oltre l'87% di vincenti solo per pareggiare. Ipotesi sulla causa (NON verificata): spread e prezzi reali all'interno della barra, che il Modello 1 non vede. **Dei 5 scalper nessuno ha un vantaggio che si possa chiamare tale a tick reali**: PF 0,84-1,22, netto da -90 a +55 EUR su 100.000.
- **Tre scalper su cinque (GU, EU_SL22, UJ_H1) sono sotto 0,5 di rapporto**, che nella scala di Wim e FAIL; EU_SL17 e UJ_H4 sono FAIL per le soglie del piano (sotto 0,7).
- **I due volatility breakout sono identici a tick e a candele** (rapporto 0,99 e 1,02), con 22-23 operazioni: sono set a stop larghi, non sensibili al tick. Ma **nel 2025 hanno reso quasi niente** (+10 e +58 EUR su 100.000, PF 1,04-1,20).
- **Limite del test:** un anno (2025), un percorso per passata; i tick sono quelli del server BCM demo (spread BCM, non FTMO). La conclusione sugli scalper e comunque netta: il PF si dimezza o peggio in tutti e 5.

## Previsioni: esito
- **T-1** (14 passate valide e complete): **VERA** (il caso migliore, 55%).
- **T-2** (mediana rapporto PF degli scalper fra 0,6 e 0,95, 60%): **FALSA**: mediana 0,50 (il caso "< 0,6", 25%).
- **T-3** (almeno 1 scalper sotto 0,7): **VERA** (tutti e 5).
- **T-4** (almeno 3 scalper con PF tick >= 1,30): **FALSA**; nessuno >= 1,30 (il caso 15%).
- **T-5** (DD tick <= 1,5 x M1 in almeno 3 su 5): **VERA** (3 su 5).
- **T-6** (VOL_f e VOL_o rapporto 0,85-1,10): **VERA** (0,99 e 1,02).
- **T-7** (operazioni +-10% in almeno uno): **FALSA** (massimo -5%).
- **T-8** (almeno 1 scalper supera tutte le soglie): **FALSA**; nessuno (il caso 25%).
- **T-9** (durata 10-60 min): **FALSA**: 98-198 secondi per passata (il caso "sotto 10 min", 20%).
**Bilancio:** ho sottostimato il crollo degli scalper: la mia ipotesi centrale era un peggioramento moderato, i fatti dicono crollo.

## Conseguenza per il piano (importante)
1. **Il pool diventa: VOL_f / VOL_o** (famiglia correlata 0,59: ne basta uno) **piu i set "non valutabili" della Fase 2** (VOL_C20/C37/C63/e/k, OTH_EU_b, OTH_GU_a, HJP09/10) che a tick vanno ancora verificati, **e HANG4** (lotti 1,2-2,3, DD fino a 6,5%).
2. **Il problema vero e il rendimento, non solo l'affidabilita.** Con i dati multi-anno a lotto 0,1 su 100.000 EUR, rendimento medio annuo / DD massimo (un Calmar grezzo): VOL_f 1,0 (P1) e 0,4 (P2); VOL_o 0,4 e 0,5; HJP09 0,5 e 0,8; HJP10 0,6 e 1,0; HANG4 0,7 e 0,3 (lotti non uguali). **Valori bassi (0,3-1,0)**: per arrivare al 10% di obiettivo in tempi ragionevoli serve un lotto molte volte piu grande, e il DD cresce in proporzione (VOL_f per fare il 10% in un anno avrebbe un DD di circa il 10%, cioe il limite di fallimento). **Un portafoglio di set cosi, preso cosi com'e, non e un motore per superare la challenge: puo essere al massimo un diversificatore.**
3. **Questo scontra con la decisione "portafoglio separato dall'oro"** (obiettivo meno rischio di fallire): un portafoglio separato di soli set a Calmar < 1 ha poco rischio di fallire MA quasi nessuna probabilita di raggiungere il 10%: e la "trappola" dichiarata nel piano. Va rivalutata con Claudio (opzioni sotto).
4. **Gli scalper in generale** (stessa famiglia di set) vanno considerati inaffidabili a candele: tutto cio che l'UBS Optimizer produce con target corti va giudicato SOLO con lo stress test a tick reali (che l'app prevede).

## Opzioni (decide Claudio)
- **A.** Usare l'UBS Optimizer per cercare set nuovi con rendimento/DD piu alto, con stress test a tick reali obbligatorio e hold-out 2025 (criteri: `UBS_OPTIMIZER_CRITERI_2026-11-15.md`). Probabilita che esca un candidato con Calmar >= 2 a tick reali nell'hold-out: 20-30% (stima, non misurata).
- **B.** Tenere i set non-oro come diversificatori DENTRO il portafoglio con l'oro (cambia la decisione del 15/11), misurando se abbassano il fail-rate.
- **C.** Verificare a tick i set "non valutabili" con qualche anno in piu (rendimento basso comunque).
- **D.** Fermarsi sul forex dei set consegnati e passare alle strategie di Claudio (limit sull'oro) come ramo A.

## Cosa NON sappiamo
Se lo stesso crollo c'e anche negli anni 2013-2024 (i tick reali BCM di quegli anni: non verificati, anche se 2025 e completo); lo spread FTMO; se gli scalper sono usati in live da Wim con risultati diversi (dato non verificato).
