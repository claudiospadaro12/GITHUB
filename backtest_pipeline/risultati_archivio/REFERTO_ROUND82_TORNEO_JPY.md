# R82 - IL TORNEO JPY: **ZERO VINCITORI SU SETTE.** L'implementazione fedele del corso non ha edge su nessun cross.

_18/08/2026 18:05. Giro 1 screening OHLC-M1, finestra identica per tutti
(2007.02.12 ->, IS/OOS al 2014.11.13), deposito 10k, rischio 1%/op (cella
di screening). Criteri congelati PRIMA in prove/TORNEO_JPY_CRITERI.md.
CSV in r82_csv/. Igiene: 14/14, gemelle identiche, autotest del test-case
del corso PASSATO nel log._

## Tabellone

| cross | IS profit | IS PF | OOS profit | OOS PF | trades IS/OOS |
|---|---:|---:|---:|---:|---|
| USDJPY | -6.643 | 0,783 | -7.765 | 0,884 | 927 / 2.138 |
| EURJPY | **+5.476** | **1,112** | -6.108 | 0,902 | 895 / 2.068 |
| GBPJPY | -704 | 0,942 | -1.684 | 0,980 | 264 / 1.467 |
| AUDJPY | -3.634 | 0,888 | -8.394 | 0,839 | 687 / 2.059 |
| CHFJPY | -2.732 | 0,861 | -8.730 | 0,769 | 493 / 1.782 |
| CADJPY | -4.219 | 0,802 | -7.878 | 0,831 | 566 / 2.063 |
| NZDJPY | -5.062 | 0,722 | -8.228 | 0,817 | 502 / 1.966 |

## Verdetto (coi cancelli congelati)
1. **ZERO vincitori**: nessun cross positivo in entrambe le finestre ->
   NIENTE giro 2 (nessuno da validare ai tick). "Zero e' un verdetto
   valido" era scritto prima, ed e' successo.
2. **Copertura piena dichiarata**: 264-2.138 operazioni per finestra su
   tutti e sette - le finestre non erano vuote (chiuso il dubbio del
   passo 0 monco).
3. **EURJPY, l'unico lampo**: positivo 2007-2014, negativo 2014-2026.
   Profilo dell'edge mangiato dal mercato - forse il mondo da cui vengono
   gli esempi del corso.
4. **Ipotesi A dimostrata a livello screening**: il +133% della lez. 39
   non si riproduce su nessun cross con l'implementazione fedele
   (autotest ok, vincolo 20 candele, Williams 140 scritto, SuperTrend
   default come da lez. 10 del modulo base).
5. **La sedia BREAKOUT_JPY resta spenta con processo completo alle
   spalle.** Porta di rientro C3: solo con una tesi NUOVA, non con una
   taratura. La regola di portafoglio "max UNA sedia dalla famiglia JPY"
   resta firmata e in vigore.

## Limiti dichiarati
- Screening OHLC-M1: per regola di casa l'OHLC non da' verdetti di
  promozione - ma qui il verdetto e' di NON promozione su segno negativo
  unanime con campioni enormi: la clausola di segno si applica in pieno.
- DD 70-89% = artefatto della cella di screening (1%/op senza cap), non
  stima d'esercizio.
