# Challenge con le regole di Concept Trading: oro (GoldenZoe) e oro + Dow `g` (22/11/2026)
Script `backtest_runner/simulatore/gz_dow_concept.py`; uscita completa `GOLDENZOE_DOWRAPTOR_CONCEPT_dati.txt`. Regole ASSUNTE dall'analisi del sito (non verificate col supporto): drawdown **statico** dal saldo iniziale (equity al minuto, perdite flottanti incluse), **nessun limite giornaliero**, obiettivo a saldo chiuso, tempo illimitato, chiusura per inattivita dopo 42 giorni. Programmi: Premier (DD 5% / obiettivo 7%), Empire (10% / 10%), Foundation fase 1 (6% / 10%), fase 2 (6% / 5%). Oro = simulatore FTMO, costi FTMO; Dow = 129 operazioni vere del tester BCM (set `g` di Wim), scalate sul drawdown obiettivo; partenze settimanali (oro da solo dal 2015: 603; ultimi 4 anni: 191; oro + Dow: 90 partenze su 26 mesi).
## Risultati principali (passate % | mediana giorni | fallite per drawdown)
| Programma | oro ALTO + Dow MEDIO | oro MEDIO + Dow MEDIO | oro ALTO + Dow ALTO | oro ALTO da solo (26 mesi) |
|---|---|---|---|---|
| Premier 5% / 7% | 88% / 166 gg / 1% | 82% / 210 gg / 1% | 88% / 127 gg / **12%** | 66% / 217 gg / 1% |
| Empire 10% / 10% | 72% / 218 gg / 0% | 67% / 267 gg / 0% | **98% / 195 gg / 0%** | 60% / 273 gg / 0% |
| Foundation fase 1 6% / 10% | 72% / 218 gg / 0% | 67% / 267 gg / 0% | 90% / 194 gg / 8% | 60% / 273 gg / 0% |
| Foundation fase 2 6% / 5% | 100% / 112 gg / 0% | 100% / 146 gg / 0% | 92% / 96 gg / 8% | 77% / 134 gg / 0% |
Oro da solo, finestra lunga (dal 2015), Premier: PROP 80% passate / 955 gg (nessun fallito), MEDIO 81% / 508 gg (12% fallite), ALTO 68% / 268 gg (26% fallite); ultimi 4 anni: ALTO 81% / 230 gg.
## La regola dei 42 giorni di inattivita
GoldenZoe da solo fa circa 18 operazioni l'anno: se "attivita" significa aprire o chiudere operazioni, **dal 2015 la maggioranza delle partenze verrebbe chiusa per inattivita** (fallite per inattivita: 475 su 603 con PROP, 304-370 con ALTO; le due letture, posizione aperta = attivita o no, danno lo stesso numero perche cio che pesa sono le pause da flat). Il Dow `g` ha invece un'attivita ogni circa 6 giorni (gap massimo 28 giorni su 114 giorni di uscite): con il Dow nel portafoglio la regola non scatta. **Da chiarire col supporto** (la domanda 2 della lista) prima di usare GoldenZoe da solo.
## Lettura (solo misure, nessun consiglio su taglie)
1. **Senza limite giornaliero il Dow ALTO smette di essere un problema** (Empire: 98% passate, 0% fallite) ma il drawdown statico del 5% di Premier e il 6% di Foundation lo colpiscono (8-12% di fallimenti).
2. **L'oro da solo e lento e dipende dal periodo**: dal 2015 mediana di 1-3 anni per l'obiettivo; con il Dow insieme 4-7 mesi nella finestra recente.
3. Il risultato oro + Dow riguarda 26 mesi con l'oro in salita; il Dow e il set di Wim (non nostro); regole di Concept non verificate; costi FTMO per l'oro.
