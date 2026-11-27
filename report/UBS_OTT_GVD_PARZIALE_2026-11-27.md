# Ottimizzazione 1 (Gold Various daily, XAUUSD D1, 2013-2022, 1 minuto): analisi dei primi ~357 passaggi (4 ore, 27/11/2026)

Fonte: `ReportOptimizer-50503392.xml` (non nel repo). Criterio: Custom max (EP 0, RF 3, TR 100). 20 parametri liberi, 1,67e29 combinazioni: il campione e' un'esplorazione, non una ricerca esaustiva. **Parziale: la genetica gira fino a 12 ore; la selezione dei candidati (10: 40% migliori, 30% piu' diversi, 30% a caso fra gli idonei) si fa sulla tabella finale.**

| Misura | Valore |
|---|---|
| Passaggi validi | 357 (1 riga vuota scartata; 1 PF di 2.087 con 1 operazione) |
| Profitto (EUR a 0,1 lotti) | mediano 1.345; p10 61; p90 3.576; max 7.062 |
| PF | mediano **1,63**; p25 1,32; p75 1,99; p90 2,49; passaggi con PF < 1: 24 (7%) |
| Operazioni in 10 anni | mediana 111; 153 passaggi con meno di 100 |
| DD equity | mediano 0,55%; p90 1,13% (lotto 0,1 su 100.000) |
| **Idonei IS** (PF >= 1,30, op >= 100, profitto > 0) | **160 su 357 (45%)**; il criterio "anni positivi >= 60%" non e' nel report: si controlla nelle convalide |
| Top 10 per Result | PF 1,90-2,72, RF 4,8-11,3, 128-331 operazioni, profitto 4.450-6.200 |

## Lettura
1. **La genetica non ha ancora convergiu.** Deviazione standard del 10% migliore rispetto a tutti i passaggi: da 0,69 (ATRDefault) a 1,07; solo tre parametri si restringono (ATRDefault 0,69, MinDist_to_HL 0,76, Exit_limit 0,81). Correlazione di rango fra parametri e Result: solo ST1_HL_strength_R (-0,31). Con 357 passaggi su 1,7e29 e' sostanzialmente un campionamento casuale: il "migliore" e' il migliore di un campione, non un ottimo.
2. **Il 93% dei passaggi casuali e' in profitto, con PF mediano 1,63.** Il vantaggio NON dipende da una combinazione speciale di parametri, e la differenza fra mediano (1,63) e migliori 10% (2,12) e' modesta. Due letture possibili, non distinguibili da questo file: (a) il motore breakout e' strutturalmente robusto; (b) l'oro D1 2013-2022 premia qualsiasi breakout con target maggiore dello stop (rialzo 2019-2022, long-bias, campione di un solo regime). **Test che le distingue (a basso costo):** convalida V1 (2004-2012) di 10 passaggi CASUALI idonei oltre ai 10 candidati: se i casuali rendono quanto i selezionati fuori campione, l'ottimizzazione non aggiunge niente.
3. **Pochi trade per anno** (mediana 11): a PF 2 con 128-331 operazioni la significativita' c'e', ma e' sensibile a poche code.
4. **DD bassi** per il lotto minimo: non indicano il rischio reale a lotti prop.

## Prossimi passi
Lasciare finire la genetica (tetto 12 ore); a fine corsa: XML finale, selezione dei 10 candidati con le regole scritte, V1 (2004-2012) per i 10 + 10 casuali di controllo (nuova aggiunta, scritta prima di vedere V1), V2, V3, V4.
