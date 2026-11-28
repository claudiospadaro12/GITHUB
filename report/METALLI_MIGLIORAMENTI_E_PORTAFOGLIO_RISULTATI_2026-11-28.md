# Miglioramenti comuni sui metalli D1 + portafoglio - RISULTATI (28/11/2026)
Criteri: `METALLI_MIGLIORAMENTI_E_PORTAFOGLIO_CRITERI_2026-11-28.md`; script `backtest_runner/simulatore/metalli_miglioramenti.py`.
## A) Nessun miglioramento comune (0 interventi su 4)
PF netto IS 2000-14 / OOS 2015-26 (base N20, stop 3, chandelier 3): oro 2,10/1,63, argento 1,80/1,09, rame 1,45/1,16 (controlli: platino 0,69/0,71, palladio 0,99/0,93).
- I1 chandelier 4 ATR: oro +0,23/+0,16, argento +0,46/+0,02, rame -0,06/+0,04; ritenzione 79-83%: migliora 1 metallo su 3 per soglia (oro), l'argento solo in IS.
- I2 uscita a tempo 30 barre: nessun effetto (0,00).
- I3 filtro SMA200: oro +0,28/-0,16, argento -0,29/+0,12, rame +0,01/+0,20: incoerente.
- I4 stop 2 ATR: oro +0,08/+0,11, argento -0,17/+0,04, rame -0,04/+0,11: 1 su 3.
Nota: i CONTROLLI (platino, palladio) "migliorano" con I1 (palladio 0,99/0,93 -> 1,04/1,16) e I3 (palladio 1,18/1,04), dove non c'e vantaggio: i miglioramenti singoli sono compatibili col rumore. La regola resta com'e (previsione scritta: 20%; I1 era il piu probabile: confermato come migliore ma non comune).
## B) Portafoglio dal 01/01/2016 (rischio uguale 0,5% a operazione, rendimenti additivi, sul chiuso)
Operazioni dal 2016: GoldenZoe 193, argento 68, rame 60, Bitcoin 78. Correlazione mensile: GoldenZoe-argento 0,28, GoldenZoe-rame 0,16, GoldenZoe-Bitcoin -0,01, argento-rame 0,23, argento-Bitcoin -0,01, rame-Bitcoin 0,15.
| combinazione | rendimento/anno | DD totale | peggior giorno chiuso | mesi positivi |
|---|---|---|---|---|
| GoldenZoe | 2,0% | 4,8% | -0,5% | 44% |
| + argento | 2,2% | 8,9% | -0,8% | 40% |
| + argento + rame | 2,5% | 10,1% | -1,0% | 39% |
| + argento + rame + Bitcoin | 4,2% | 11,3% | -1,0% | 44% |
A rischio 0,25% a operazione tutto si dimezza (DD 2,4 / 4,4 / 5,1 / 5,7%). Letture: argento e rame D1, nel 2016-26, aggiungono piu drawdown che rendimento (argento OOS 1,09; il periodo e quello debole); il Bitcoin e il diversificatore migliore (+1,7%/anno per +1,2 punti di DD, correlazione ~0) ma si basa su swap 10% assunto e 78 operazioni (swap reale NON MISURATO, poco storico).
Limiti: rendimenti additivi non composti; DD sul chiuso (flottante peggiore); costi e swap dei metalli stimati; Bitcoin con swap assunto; nessun consiglio su taglie.
