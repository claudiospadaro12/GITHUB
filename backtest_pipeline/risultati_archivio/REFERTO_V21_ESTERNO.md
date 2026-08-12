# REFERTO — NasdaqOpeningBreakout v21 dell'amico (12/08): BOCCIATO, capitolo chiuso

## Il percorso (tutto in UN giorno)
Mattina: EA esterno scoperto AGGANCIATO al vivo sul conto piccolo (fuori
imbuto, filtro S/R acceso = l'idea bocciata in R30 poche ore prima).
Decisione di Claudio: "A: spegnere, pero' ci lavoriamo". Spento alle
14:22 (un'ora prima dell'apertura), config salvata dal .chr, ex5
pubblicato sul repo, misura automatica sul PC di backtest: 2 lanci
singoli IS/OOS a tick reali, NASUSD M20, la SUA config con l'unica
traduzione dichiarata (orario 16:25 -> 14:25 fuso BCM). Nessuna
ottimizzazione: si misurava LUI, non lo si accordava.

## I numeri (deposito 10k, lotto fisso 0,1 come da sua config)
| | IS (24.09.26-25.06.09) | OOS (25.06.10-26.06.30) |
|---|---|---|
| Profitto netto | **−1,18** | **−15,35** |
| Fattore di profitto | 0,80 | **0,02** |
| Trade (tutti SHORT) | 32, vinti 21,9% | 71, vinti **5,6%** |
| DD equity | 0,03% | 0,15% |

**Rosso in entrambe le finestre. Coi cancelli di tutti: bocciato.**

## La diagnosi (piu' interessante del verdetto)
I numeri microscopici raccontano il difetto strutturale: su BCM il punto
del NASUSD vale 0,01 — quindi `BaseStopLoss=50 punti` = **mezzo punto
indice** di stop, TP 1 punto, trailing 0,3. Sul broker dell'amico
(cifre diverse) quei numeri hanno senso; trapiantati su BCM producono
stop mangiati dallo spread al 94% (OOS: 4 vinti su 71) e soli short.
**La config non e' trasferibile fra broker: ne' il fuso (16:25 vs
14:25), ne' le unita' dei punti.** Se stamattina fosse rimasto sul vivo,
avrebbe grattato il conto del vivaio un trade alla volta.

Ri-tarare noi i suoi parametri per BCM = ottimizzare l'EA di un altro
(la pesca che non facciamo). Le sue DUE idee originali erano gia' state
misurate nel modo giusto — innestate nel NOSTRO lab con unita' nostre
(R30): S/R bocciato col 20° ribaltamento, VolRegime in cassetta come
attrezzo anti-DD. **Dal v21 non c'e' altro da estrarre.**

## Conclusione
Capitolo CHIUSO. Si riapre solo se l'amico fornisce risultati veri del
SUO broker o un .set tarato per BCM — e comunque ripasserebbe da qui.
Per Claudio, se vuole dirglielo con una frase: "il tuo EA sul mio
broker perde per colpa di fuso e unita' dei punti, non riesce nemmeno a
giocare la sua partita; le tue due idee le ho fatte testare per bene:
il filtro S/R e' un'illusione da backtest, il regime di volatilita' e'
buono ma costa profitto."

_Report del tester in `risultati_prove/v21_esterno/` (V21_IS.htm,
V21_OOS.htm + grafici). Config in `prove/V21_CONFIG_AMICO.txt`._
